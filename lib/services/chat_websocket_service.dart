import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/chat.dart';
import '../services/logger_service.dart';
import '../services/auth_service.dart';

class ChatWebSocketService {
  WebSocketChannel? _channel;
  final AuthService _authService;
  StreamController<ChatMessage>? _messageController;
  StreamController<bool>? _typingController;
  StreamController<WebSocketState>? _stateController;

  String? _currentStoreId;
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  bool _isIntentionalClose = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 3);

  // Base WebSocket URL (replace with your actual WebSocket URL)
  static const String _wsBaseUrl = 'ws://localhost:8000';

  ChatWebSocketService({AuthService? authService})
    : _authService = authService ?? AuthService();

  /// Stream of incoming messages
  Stream<ChatMessage> get messageStream {
    _messageController ??= StreamController<ChatMessage>.broadcast();
    return _messageController!.stream;
  }

  /// Stream of typing indicators
  Stream<bool> get typingStream {
    _typingController ??= StreamController<bool>.broadcast();
    return _typingController!.stream;
  }

  /// Stream of connection state changes
  Stream<WebSocketState> get stateStream {
    _stateController ??= StreamController<WebSocketState>.broadcast();
    return _stateController!.stream;
  }

  /// Connect to WebSocket
  Future<void> connect(String storeId) async {
    try {
      _currentStoreId = storeId;
      _isIntentionalClose = false;

      // Get authentication token
      final token = await _authService.getToken();
      if (token == null) {
        LoggerService.error('No authentication token available for WebSocket');
        _updateState(WebSocketState.error);
        return;
      }

      // Close existing connection if any
      await disconnect();

      // Create WebSocket URL with token
      final wsUrl = '$_wsBaseUrl/chat/ws/$storeId?token=$token';

      LoggerService.info('Connecting to WebSocket: $wsUrl');
      _updateState(WebSocketState.connecting);

      // Create WebSocket channel
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Listen to WebSocket stream
      _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
        cancelOnError: false,
      );

      _updateState(WebSocketState.connected);
      _reconnectAttempts = 0;

      // Start ping timer to keep connection alive
      _startPingTimer();

      LoggerService.info('WebSocket connected successfully');
    } catch (e) {
      LoggerService.error('Error connecting to WebSocket', error: e);
      _updateState(WebSocketState.error);
      _scheduleReconnect();
    }
  }

  /// Disconnect from WebSocket
  Future<void> disconnect() async {
    _isIntentionalClose = true;
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();

    try {
      await _channel?.sink.close();
      _channel = null;
      _updateState(WebSocketState.disconnected);
      LoggerService.info('WebSocket disconnected');
    } catch (e) {
      LoggerService.error('Error disconnecting WebSocket', error: e);
    }
  }

  /// Send a message through WebSocket
  void sendMessage(String content, {String messageType = 'text'}) {
    if (_channel == null) {
      LoggerService.warning('Cannot send message: WebSocket not connected');
      return;
    }

    try {
      final message = {
        'type': 'send_message',
        'data': {
          'content': content,
          'message_type': messageType,
          'is_from_customer': false,
        },
      };

      _channel!.sink.add(jsonEncode(message));
      LoggerService.debug('Message sent through WebSocket');
    } catch (e) {
      LoggerService.error('Error sending message through WebSocket', error: e);
    }
  }

  /// Send typing indicator
  void sendTypingIndicator(bool isTyping) {
    if (_channel == null) {
      return;
    }

    try {
      final message = {
        'type': 'typing',
        'data': {'is_typing': isTyping},
      };

      _channel!.sink.add(jsonEncode(message));
    } catch (e) {
      LoggerService.error('Error sending typing indicator', error: e);
    }
  }

  /// Handle incoming WebSocket messages
  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message as String) as Map<String, dynamic>;
      final type = data['type'] as String?;

      switch (type) {
        case 'message':
          _handleIncomingMessage(data['data'] as Map<String, dynamic>);
          break;
        case 'typing':
          _handleTypingIndicator(data['data'] as Map<String, dynamic>);
          break;
        case 'pong':
          // Pong received, connection is alive
          break;
        case 'error':
          LoggerService.error('WebSocket error received: ${data['message']}');
          break;
        default:
          LoggerService.warning('Unknown WebSocket message type: $type');
      }
    } catch (e) {
      LoggerService.error('Error handling WebSocket message', error: e);
    }
  }

  /// Handle incoming chat message
  void _handleIncomingMessage(Map<String, dynamic> data) {
    try {
      final message = ChatMessage.fromJson(data);
      _messageController?.add(message);
      LoggerService.debug('Received message through WebSocket: ${message.id}');
    } catch (e) {
      LoggerService.error('Error parsing incoming message', error: e);
    }
  }

  /// Handle typing indicator
  void _handleTypingIndicator(Map<String, dynamic> data) {
    try {
      final isTyping = data['is_typing'] as bool? ?? false;
      _typingController?.add(isTyping);
    } catch (e) {
      LoggerService.error('Error handling typing indicator', error: e);
    }
  }

  /// Handle WebSocket errors
  void _handleError(dynamic error) {
    LoggerService.error('WebSocket error', error: error);
    _updateState(WebSocketState.error);
    _scheduleReconnect();
  }

  /// Handle WebSocket disconnection
  void _handleDisconnect() {
    LoggerService.info('WebSocket disconnected');
    _updateState(WebSocketState.disconnected);

    if (!_isIntentionalClose) {
      _scheduleReconnect();
    }
  }

  /// Schedule reconnection attempt
  void _scheduleReconnect() {
    if (_isIntentionalClose || _reconnectAttempts >= _maxReconnectAttempts) {
      if (_reconnectAttempts >= _maxReconnectAttempts) {
        LoggerService.error('Max reconnection attempts reached');
        _updateState(WebSocketState.failed);
      }
      return;
    }

    _reconnectAttempts++;
    LoggerService.info(
      'Scheduling reconnection attempt $_reconnectAttempts/$_maxReconnectAttempts',
    );

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      if (_currentStoreId != null) {
        connect(_currentStoreId!);
      }
    });
  }

  /// Start ping timer to keep connection alive
  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_channel != null) {
        try {
          _channel!.sink.add(jsonEncode({'type': 'ping'}));
        } catch (e) {
          LoggerService.error('Error sending ping', error: e);
        }
      }
    });
  }

  /// Update connection state
  void _updateState(WebSocketState state) {
    _stateController?.add(state);
  }

  /// Check if WebSocket is connected
  bool get isConnected => _channel != null;

  /// Dispose resources
  void dispose() {
    _isIntentionalClose = true;
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    _channel?.sink.close();
    _messageController?.close();
    _typingController?.close();
    _stateController?.close();
  }
}

enum WebSocketState { disconnected, connecting, connected, error, failed }
