import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../models/chat.dart';
import '../services/logger_service.dart';
import 'auth_service.dart';

class ChatServiceException implements Exception {
  final String message;
  final int? statusCode;

  ChatServiceException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ChatService {
  final Dio _dio;
  final AuthService _authService;

  ChatService({Dio? dio, AuthService? authService})
      : _dio = dio ?? Dio(),
        _authService = authService ?? AuthService() {
    _configureDio();
  }

  void _configureDio() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = ApiConstants.connectTimeout;
    _dio.options.receiveTimeout = ApiConstants.receiveTimeout;
    _dio.options.sendTimeout = ApiConstants.sendTimeout;
    _dio.options.headers = ApiConstants.defaultHeaders;
  }

  /// Get all conversations for a store
  Future<List<Conversation>> getConversations({
    required int storeId,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw ChatServiceException('No access token available');
      }

      final endpoint = ApiConstants.chatConversationsEndpoint
          .replaceAll('{storeId}', storeId.toString());

      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> conversationsData = response.data as List<dynamic>;
        return conversationsData
            .map((json) => Conversation.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ChatServiceException(
          'Failed to fetch conversations: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      LoggerService.error('Error fetching conversations', error: e);
      if (e.response?.statusCode == 401) {
        throw ChatServiceException(
          'Authentication failed. Please login again.',
          statusCode: 401,
        );
      } else if (e.response?.statusCode == 404) {
        throw ChatServiceException(
          'Store not found',
          statusCode: 404,
        );
      }
      throw ChatServiceException(
        e.response?.data?['detail'] ?? 'Failed to fetch conversations',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      LoggerService.error('Unexpected error fetching conversations', error: e);
      throw ChatServiceException('An unexpected error occurred: $e');
    }
  }

  /// Get messages for a specific conversation
  Future<List<ChatMessage>> getMessages({
    required int storeId,
    int? limit,
    int? offset,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw ChatServiceException('No access token available');
      }

      final endpoint = ApiConstants.chatMessagesEndpoint
          .replaceAll('{storeId}', storeId.toString());

      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> messagesData = response.data as List<dynamic>;
        return messagesData
            .map((json) => ChatMessage.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ChatServiceException(
          'Failed to fetch messages: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      LoggerService.error('Error fetching messages', error: e);
      if (e.response?.statusCode == 401) {
        throw ChatServiceException(
          'Authentication failed. Please login again.',
          statusCode: 401,
        );
      } else if (e.response?.statusCode == 404) {
        throw ChatServiceException(
          'Conversation not found',
          statusCode: 404,
        );
      }
      throw ChatServiceException(
        e.response?.data?['detail'] ?? 'Failed to fetch messages',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      LoggerService.error('Unexpected error fetching messages', error: e);
      throw ChatServiceException('An unexpected error occurred: $e');
    }
  }

  /// Send a message
  Future<ChatMessage> sendMessage({
    required SendMessageRequest request,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw ChatServiceException('No access token available');
      }

      LoggerService.info('Sending message to: ${ApiConstants.sendMessageEndpoint}');
      LoggerService.debug('Message data: ${request.toJson()}');

      final response = await _dio.post(
        ApiConstants.sendMessageEndpoint,
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      LoggerService.info('Send message response: ${response.statusCode}');
      LoggerService.debug('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChatMessage.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ChatServiceException(
          'Failed to send message: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      LoggerService.error('DioException sending message', error: e);
      LoggerService.error('Response: ${e.response?.data}');
      LoggerService.error('Status code: ${e.response?.statusCode}');
      
      if (e.response?.statusCode == 401) {
        throw ChatServiceException(
          'Authentication failed. Please login again.',
          statusCode: 401,
        );
      } else if (e.response?.statusCode == 400) {
        throw ChatServiceException(
          'Invalid message data: ${e.response?.data?['detail'] ?? 'Bad request'}',
          statusCode: 400,
        );
      }
      throw ChatServiceException(
        e.response?.data?['detail'] ?? 'Failed to send message',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      LoggerService.error('Unexpected error sending message', error: e);
      throw ChatServiceException('An unexpected error occurred: $e');
    }
  }

  /// Mark messages as read
  Future<void> markMessagesAsRead({
    required int storeId,
    required List<int> messageIds,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw ChatServiceException('No access token available');
      }

      // This endpoint might need to be added to your API
      final response = await _dio.put(
        '/chat/messages/read',
        data: {
          'store_id': storeId,
          'message_ids': messageIds,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw ChatServiceException(
          'Failed to mark messages as read: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      LoggerService.error('Error marking messages as read', error: e);
      // Don't throw error for read receipts - it's not critical
    } catch (e) {
      LoggerService.error(
        'Unexpected error marking messages as read',
        error: e,
      );
      // Don't throw error for read receipts - it's not critical
    }
  }

  /// Delete a message
  Future<void> deleteMessage({
    required int messageId,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw ChatServiceException('No access token available');
      }

      final response = await _dio.delete(
        '/chat/messages/$messageId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ChatServiceException(
          'Failed to delete message: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      LoggerService.error('Error deleting message', error: e);
      if (e.response?.statusCode == 401) {
        throw ChatServiceException(
          'Authentication failed. Please login again.',
          statusCode: 401,
        );
      } else if (e.response?.statusCode == 404) {
        throw ChatServiceException(
          'Message not found',
          statusCode: 404,
        );
      }
      throw ChatServiceException(
        e.response?.data?['detail'] ?? 'Failed to delete message',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      LoggerService.error('Unexpected error deleting message', error: e);
      throw ChatServiceException('An unexpected error occurred: $e');
    }
  }
}

