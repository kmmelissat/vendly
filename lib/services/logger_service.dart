import 'dart:developer' as developer;
import 'package:dio/dio.dart';

class LoggerService {
  static const String _tag = 'LinkUp';

  // Log levels
  static void debug(String message, {String? tag, dynamic data}) {
    final logTag = tag ?? _tag;
    developer.log(
      message,
      name: logTag,
      level: 500, // Debug level
    );
    if (data != null) {
      developer.log('Data: ${data.toString()}', name: logTag, level: 500);
    }
  }

  static void info(String message, {String? tag, dynamic data}) {
    final logTag = tag ?? _tag;
    developer.log(
      message,
      name: logTag,
      level: 800, // Info level
    );
    if (data != null) {
      developer.log('Data: ${data.toString()}', name: logTag, level: 800);
    }
  }

  static void warning(String message, {String? tag, dynamic data}) {
    final logTag = tag ?? _tag;
    developer.log(
      message,
      name: logTag,
      level: 900, // Warning level
    );
    if (data != null) {
      developer.log('Data: ${data.toString()}', name: logTag, level: 900);
    }
  }

  static void error(
    String message, {
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final logTag = tag ?? _tag;
    developer.log(
      message,
      name: logTag,
      level: 1000, // Error level
      error: error,
      stackTrace: stackTrace,
    );
  }

  // Specific method for API errors
  static void apiError(String endpoint, DioException error) {
    final message = 'API Error on $endpoint';

    developer.log(message, name: '$_tag-API', level: 1000);

    // Log request details
    developer.log(
      'Request: ${error.requestOptions.method} ${error.requestOptions.uri}',
      name: '$_tag-API',
      level: 1000,
    );

    if (error.requestOptions.data != null) {
      developer.log(
        'Request Data: ${error.requestOptions.data}',
        name: '$_tag-API',
        level: 1000,
      );
    }

    if (error.requestOptions.headers.isNotEmpty) {
      developer.log(
        'Request Headers: ${error.requestOptions.headers}',
        name: '$_tag-API',
        level: 1000,
      );
    }

    // Log response details
    if (error.response != null) {
      developer.log(
        'Response Status: ${error.response!.statusCode}',
        name: '$_tag-API',
        level: 1000,
      );

      developer.log(
        'Response Data: ${error.response!.data}',
        name: '$_tag-API',
        level: 1000,
      );

      if (error.response!.headers.map.isNotEmpty) {
        developer.log(
          'Response Headers: ${error.response!.headers.map}',
          name: '$_tag-API',
          level: 1000,
        );
      }
    }

    // Log error type and message
    developer.log('Error Type: ${error.type}', name: '$_tag-API', level: 1000);

    developer.log(
      'Error Message: ${error.message}',
      name: '$_tag-API',
      level: 1000,
    );

    developer.log(
      'Stack Trace: ${error.stackTrace}',
      name: '$_tag-API',
      level: 1000,
    );
  }

  // Network connectivity logging
  static void networkError(String operation, dynamic error) {
    developer.log(
      'Network Error during $operation',
      name: '$_tag-Network',
      level: 1000,
      error: error,
    );
  }

  // Authentication logging
  static void authEvent(String event, {Map<String, dynamic>? data}) {
    developer.log('Auth Event: $event', name: '$_tag-Auth', level: 800);

    if (data != null) {
      // Don't log sensitive data like passwords
      final safeData = Map<String, dynamic>.from(data);
      safeData.remove('password');
      safeData.remove('token');

      developer.log('Auth Data: $safeData', name: '$_tag-Auth', level: 800);
    }
  }

  // Navigation logging
  static void navigation(String from, String to) {
    developer.log('Navigation: $from -> $to', name: '$_tag-Nav', level: 500);
  }

  // Performance logging
  static void performance(String operation, Duration duration) {
    developer.log(
      'Performance: $operation took ${duration.inMilliseconds}ms',
      name: '$_tag-Perf',
      level: 500,
    );
  }
}
