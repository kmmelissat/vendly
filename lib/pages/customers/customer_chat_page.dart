import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/chat.dart';
import '../../services/chat_service.dart';
import '../../services/chat_websocket_service.dart';
import '../../services/auth_service.dart';
import '../../utils/auth_error_handler.dart';

class CustomerChatPage extends StatefulWidget {
  final String customerId;
  final String customerName;
  final String customerAvatar;

  const CustomerChatPage({
    super.key,
    required this.customerId,
    required this.customerName,
    required this.customerAvatar,
  });

  @override
  State<CustomerChatPage> createState() => _CustomerChatPageState();
}

class _CustomerChatPageState extends State<CustomerChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  final ChatWebSocketService _wsService = ChatWebSocketService();
  final AuthService _authService = AuthService();
  
  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  bool _isCustomerTyping = false;
  String? _errorMessage;
  int? _storeId;
  WebSocketState _wsState = WebSocketState.disconnected;
  
  StreamSubscription<ChatMessage>? _messageSubscription;
  StreamSubscription<bool>? _typingSubscription;
  StreamSubscription<WebSocketState>? _stateSubscription;
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();
    _messageSubscription?.cancel();
    _typingSubscription?.cancel();
    _stateSubscription?.cancel();
    _wsService.disconnect();
    _wsService.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get store ID from user data
      final userData = await _authService.getUserData();
      if (userData != null && userData['store'] != null) {
        final store = userData['store'] as Map<String, dynamic>;
        final storeIdString = store['id']?.toString();
        if (storeIdString != null) {
          _storeId = int.tryParse(storeIdString);
        }
      }

      if (_storeId == null) {
        setState(() {
          _errorMessage = 'Store ID not found. Please login again.';
          _isLoading = false;
        });
        return;
      }

      // Fetch messages from API
      final messages = await _chatService.getMessages(storeId: _storeId!);

      if (mounted) {
        setState(() {
          _messages = messages;
          _isLoading = false;
        });
        _scrollToBottom();
        
        // Initialize WebSocket connection
        _initializeWebSocket();
      }
    } catch (e) {
      if (AuthErrorHandler.isAuthError(e)) {
        if (mounted) {
          await AuthErrorHandler.handleAuthError(
            context,
            errorMessage: AuthErrorHandler.getAuthErrorMessage(e),
          );
        }
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = e.toString();
            _isLoading = false;
          });
        }
      }
    }
  }

  void _initializeWebSocket() {
    if (_storeId == null) return;

    // Connect to WebSocket
    _wsService.connect(_storeId.toString());

    // Listen to incoming messages
    _messageSubscription = _wsService.messageStream.listen((message) {
      if (mounted) {
        setState(() {
          _messages.add(message);
        });
        _scrollToBottom();
      }
    });

    // Listen to typing indicators
    _typingSubscription = _wsService.typingStream.listen((isTyping) {
      if (mounted) {
        setState(() {
          _isCustomerTyping = isTyping;
        });
      }
    });

    // Listen to connection state changes
    _stateSubscription = _wsService.stateStream.listen((state) {
      if (mounted) {
        setState(() {
          _wsState = state;
        });
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _isSending || _storeId == null) {
      return;
    }

    final messageText = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _isSending = true;
    });

    try {
      print('Sending message: $messageText');
      print('WebSocket connected: ${_wsService.isConnected}');
      print('Store ID: $_storeId');
      
      // Always use HTTP API for now (WebSocket is optional enhancement)
      final request = SendMessageRequest(
        storeId: _storeId!,
        content: messageText,
        messageType: 'text',
        isFromCustomer: false,
      );

      print('Sending via HTTP API...');
      final sentMessage = await _chatService.sendMessage(request: request);
      print('Message sent successfully: ${sentMessage.id}');

      if (mounted) {
        setState(() {
          _messages.add(sentMessage);
          _isSending = false;
        });
        _scrollToBottom();
        
        // Also send via WebSocket if connected (for real-time to other clients)
        if (_wsService.isConnected) {
          _wsService.sendMessage(messageText);
          _wsService.sendTypingIndicator(false);
        }
      }
    } catch (e) {
      print('Error sending message: $e');
      if (mounted) {
        setState(() {
          _isSending = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: ${e.toString()}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                _messageController.text = messageText;
                _sendMessage();
              },
            ),
          ),
        );
      }
    }
  }

  void _onTextChanged() {
    // Send typing indicator when user is typing
    if (_messageController.text.isNotEmpty && _wsService.isConnected) {
      _wsService.sendTypingIndicator(true);
      
      // Cancel previous timer
      _typingTimer?.cancel();
      
      // Stop typing indicator after 2 seconds of inactivity
      _typingTimer = Timer(const Duration(seconds: 2), () {
        if (_wsService.isConnected) {
          _wsService.sendTypingIndicator(false);
        }
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(widget.customerAvatar),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.customerName,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    _isCustomerTyping
                        ? 'typing...'
                        : _getConnectionStatusText(),
                    style: TextStyle(
                      fontSize: 12,
                      color: _isCustomerTyping
                          ? Theme.of(context).colorScheme.primary
                          : _getConnectionStatusColor(),
                      fontWeight: FontWeight.normal,
                      fontStyle:
                          _isCustomerTyping ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMessages,
            tooltip: 'Refresh messages',
          ),
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: () {
              // TODO: Implement phone call
            },
            tooltip: 'Call customer',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showChatOptions(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? _buildErrorState()
                    : _messages.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final message = _messages[index];
                              final showDateSeparator = index == 0 ||
                                  !_isSameDay(
                                    message.createdAt,
                                    _messages[index - 1].createdAt,
                                  );

                              return Column(
                                children: [
                                  if (showDateSeparator)
                                    _buildDateSeparator(message.createdAt),
                                  _buildMessageBubble(message),
                                ],
                              );
                            },
                          ),
          ),

          // Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load messages',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'An unknown error occurred',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadMessages,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start a conversation with ${widget.customerName}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);
    
    String dateText;
    if (messageDate == today) {
      dateText = 'Today';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      dateText = 'Yesterday';
    } else {
      dateText = DateFormat('MMM dd, yyyy').format(date);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Theme.of(context).dividerColor)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              dateText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Expanded(child: Divider(color: Theme.of(context).dividerColor)),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isFromCustomer = message.isFromCustomer;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isFromCustomer ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isFromCustomer) ...[
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(widget.customerAvatar),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isFromCustomer
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isFromCustomer ? 4 : 20),
                  bottomRight: Radius.circular(isFromCustomer ? 20 : 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isFromCustomer
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onPrimary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(message.createdAt),
                        style: TextStyle(
                          color: isFromCustomer
                              ? Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5)
                              : Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.7),
                          fontSize: 11,
                        ),
                      ),
                      if (!isFromCustomer) ...[
                        const SizedBox(width: 4),
                        Icon(
                          _getStatusIcon(message.messageStatus),
                          size: 14,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withOpacity(0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (!isFromCustomer) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                _showAttachmentOptions(context);
              },
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  onChanged: (_) => _onTextChanged(),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.emoji_emotions_outlined),
                      onPressed: () {
                        // TODO: Show emoji picker
                      },
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttachmentOption(
                      context,
                      Icons.image,
                      'Photo',
                      Colors.purple,
                      () {
                        Navigator.pop(context);
                        // TODO: Pick image
                      },
                    ),
                    _buildAttachmentOption(
                      context,
                      Icons.videocam,
                      'Video',
                      Colors.red,
                      () {
                        Navigator.pop(context);
                        // TODO: Pick video
                      },
                    ),
                    _buildAttachmentOption(
                      context,
                      Icons.insert_drive_file,
                      'Document',
                      Colors.blue,
                      () {
                        Navigator.pop(context);
                        // TODO: Pick document
                      },
                    ),
                    _buildAttachmentOption(
                      context,
                      Icons.location_on,
                      'Location',
                      Colors.green,
                      () {
                        Navigator.pop(context);
                        // TODO: Share location
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _showChatOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Search in conversation'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement search
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_off_outlined),
                title: const Text('Mute notifications'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement mute
                },
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Block customer'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement block
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Clear chat',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showClearChatDialog();
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear chat?'),
          content: const Text(
            'This will delete all messages in this conversation. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _messages.clear();
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  IconData _getStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return Icons.access_time;
      case MessageStatus.sent:
        return Icons.check;
      case MessageStatus.delivered:
        return Icons.done_all;
      case MessageStatus.read:
        return Icons.done_all;
      case MessageStatus.failed:
        return Icons.error_outline;
    }
  }

  String _getConnectionStatusText() {
    switch (_wsState) {
      case WebSocketState.connected:
        return 'Online';
      case WebSocketState.connecting:
        return 'Connecting...';
      case WebSocketState.disconnected:
        return 'Offline';
      case WebSocketState.error:
        return 'Connection error';
      case WebSocketState.failed:
        return 'Connection failed';
    }
  }

  Color _getConnectionStatusColor() {
    switch (_wsState) {
      case WebSocketState.connected:
        return Colors.green[400]!;
      case WebSocketState.connecting:
        return Colors.orange[400]!;
      case WebSocketState.disconnected:
      case WebSocketState.error:
      case WebSocketState.failed:
        return Colors.red[400]!;
    }
  }
}

