import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import 'logger_service.dart';

class AuthService {
  final Dio _dio;

  AuthService() : _dio = Dio() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = ApiConstants.connectTimeout;
    _dio.options.receiveTimeout = ApiConstants.receiveTimeout;
    _dio.options.sendTimeout = ApiConstants.sendTimeout;

    // Add interceptor for token and logging
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          LoggerService.debug('API Request: ${options.method} ${options.uri}');
          LoggerService.debug('Request Headers: ${options.headers}');
          if (options.data != null) {
            // Don't log sensitive data
            final safeData = _sanitizeLogData(options.data);
            LoggerService.debug('Request Data: $safeData');
          }

          final token = await getToken();
          if (token != null) {
            options.headers[ApiConstants.authorizationHeader] = 'Bearer $token';
          }
          options.headers.addAll(ApiConstants.defaultHeaders);
          handler.next(options);
        },
        onResponse: (response, handler) {
          LoggerService.debug(
            'API Response: ${response.statusCode} ${response.requestOptions.uri}',
          );
          LoggerService.debug('Response Headers: ${response.headers.map}');
          if (response.data != null) {
            final safeData = _sanitizeLogData(response.data);
            LoggerService.debug('Response Data: $safeData');
          }
          handler.next(response);
        },
        onError: (error, handler) {
          LoggerService.apiError(error.requestOptions.uri.toString(), error);

          if (error.response?.statusCode == 401) {
            LoggerService.warning('Token expired, logging out user');
            logout();
          }
          handler.next(error);
        },
      ),
    );
  }

  // Helper method to sanitize sensitive data from logs
  dynamic _sanitizeLogData(dynamic data) {
    if (data is Map) {
      final sanitized = Map<String, dynamic>.from(data);
      // Remove sensitive fields
      sanitized.remove('password');
      sanitized.remove('token');
      sanitized.remove('refresh_token');
      sanitized.remove('access_token');

      // Mask partial sensitive data
      if (sanitized['email'] != null) {
        final email = sanitized['email'].toString();
        if (email.contains('@')) {
          final parts = email.split('@');
          sanitized['email'] = '${parts[0].substring(0, 1)}***@${parts[1]}';
        }
      }

      return sanitized;
    }
    return data;
  }

  // Login method
  Future<Map<String, dynamic>> login({
    required String
    email, // This is actually username but keeping parameter name for compatibility
    required String password,
  }) async {
    final startTime = DateTime.now();

    try {
      LoggerService.authEvent('Login attempt', data: {'username': email});

      final requestData = {'username': email, 'password': password};

      LoggerService.debug(
        'Making login request to ${ApiConstants.loginEndpoint}',
      );

      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        data: requestData,
      );

      final duration = DateTime.now().difference(startTime);
      LoggerService.performance('Login API call', duration);

      LoggerService.debug('Login response status: ${response.statusCode}');
      LoggerService.debug(
        'Login response data type: ${response.data.runtimeType}',
      );

      if (response.statusCode == 200) {
        final data = response.data;

        LoggerService.info('Login successful for user: $email');

        // Validate response structure
        if (data == null) {
          LoggerService.error('Login response data is null');
          return {
            'success': false,
            'message': 'Invalid server response: no data',
          };
        }

        if (data['access_token'] == null) {
          LoggerService.error('Login response missing access_token');
          LoggerService.debug('Response data: $data');
          return {
            'success': false,
            'message': 'Invalid server response: missing access_token',
          };
        }

        // Save tokens
        await _saveToken(data['access_token']);
        if (data['refresh_token'] != null) {
          await _saveRefreshToken(data['refresh_token']);
        }

        // Create a user object from the token or use username
        final userObject = {
          'username': email,
          'token_type': data['token_type'] ?? 'bearer',
        };
        await _saveUserData(userObject);

        LoggerService.authEvent('Login success', data: {'username': email});
        return {
          'success': true,
          'token': data['access_token'],
          'user': userObject,
          'refresh_token': data['refresh_token'],
          'token_type': data['token_type'],
        };
      } else {
        LoggerService.warning(
          'Login failed with status: ${response.statusCode}',
          data: response.data,
        );
        return {
          'success': false,
          'message': 'Login failed with status ${response.statusCode}',
        };
      }
    } on DioException catch (e) {
      LoggerService.apiError(ApiConstants.loginEndpoint, e);

      String errorMessage = 'Network error occurred';
      String debugMessage = 'DioException: ${e.type} - ${e.message}';

      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final responseData = e.response!.data;

        LoggerService.error(
          'Login API error - Status: $statusCode, Data: $responseData',
        );

        switch (statusCode) {
          case 400:
            errorMessage = 'Invalid username or password';
            if (responseData != null && responseData['message'] != null) {
              debugMessage = 'API Error: ${responseData['message']}';
            }
            break;
          case 401:
            errorMessage = 'Invalid credentials';
            if (responseData != null && responseData['message'] != null) {
              debugMessage = 'API Error: ${responseData['message']}';
            }
            break;
          case 404:
            errorMessage = 'User not found';
            break;
          case 500:
            errorMessage = 'Server error. Please try again later';
            debugMessage =
                'Server Error 500: ${responseData?.toString() ?? 'No details'}';
            break;
          default:
            errorMessage = responseData?['message'] ?? 'Login failed';
            debugMessage =
                'HTTP $statusCode: ${responseData?.toString() ?? 'No response data'}';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection';
        debugMessage =
            'Connection timeout after ${_dio.options.connectTimeout}';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Request timeout. Please try again';
        debugMessage = 'Receive timeout after ${_dio.options.receiveTimeout}';
      } else if (e.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Send timeout. Please try again';
        debugMessage = 'Send timeout after ${_dio.options.sendTimeout}';
      } else if (e.type == DioExceptionType.cancel) {
        errorMessage = 'Request was cancelled';
        debugMessage = 'Request cancelled';
      } else {
        debugMessage = 'Unknown DioException: ${e.type} - ${e.message}';
      }

      LoggerService.authEvent(
        'Login failed',
        data: {'username': email, 'error': debugMessage},
      );

      // In debug mode, return detailed error message
      final finalMessage = AppConstants.enableDetailedErrorMessages
          ? '$errorMessage\nDebug: $debugMessage'
          : errorMessage;

      return {'success': false, 'message': finalMessage};
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected login error',
        error: e,
        stackTrace: stackTrace,
      );

      final debugMessage = 'Unexpected error: ${e.toString()}';
      final finalMessage = AppConstants.enableDetailedErrorMessages
          ? 'An unexpected error occurred\nDebug: $debugMessage'
          : 'An unexpected error occurred';

      return {'success': false, 'message': finalMessage};
    }
  }

  // Register method
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? storeName,
    String? storeLocation,
    String? storeType,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.registerEndpoint,
        data: {
          'username': name,
          'email': email,
          'password': password,
          'user_type': ApiConstants.storeUserType,
          'store_name': storeName ?? '$name\'s Store',
          'store_location': storeLocation ?? 'Location not specified',
          'type': storeType ?? 'General Store',
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;

        // Save token and user data
        await _saveToken(data['token']);
        await _saveUserData(data['user']);

        return {'success': true, 'token': data['token'], 'user': data['user']};
      } else {
        return {'success': false, 'message': 'Registration failed'};
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';

      if (e.response != null) {
        switch (e.response!.statusCode) {
          case 400:
            errorMessage =
                e.response?.data['message'] ?? 'Invalid data provided';
            break;
          case 409:
            errorMessage = 'Email already exists';
            break;
          case 422:
            errorMessage = 'Invalid email format or weak password';
            break;
          case 500:
            errorMessage = 'Server error. Please try again later';
            break;
          default:
            errorMessage = e.response?.data['message'] ?? 'Registration failed';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            'Connection timeout. Please check your internet connection';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Request timeout. Please try again';
      }

      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      // Call logout endpoint if needed
      await _dio.post(ApiConstants.logoutEndpoint);
    } catch (e) {
      // Even if logout fails on server, clear local data
    } finally {
      await _clearAuthData();
    }
  }

  // Get current token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.refreshTokenKey);
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConstants.userDataKey);
    if (userJson != null) {
      // You might want to use dart:convert to decode JSON
      // For now, returning null
      return null;
    }
    return null;
  }

  // Private methods
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
  }

  Future<void> _saveRefreshToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.refreshTokenKey, refreshToken);
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    // You might want to use dart:convert to encode JSON
    // For now, just saving as string
    await prefs.setString(AppConstants.userDataKey, userData.toString());
  }

  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.refreshTokenKey);
    await prefs.remove(AppConstants.userDataKey);
  }

  // Refresh token method (if your API supports it)
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        LoggerService.warning('No refresh token available');
        return false;
      }

      final response = await _dio.post(
        ApiConstants.refreshTokenEndpoint,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['access_token'] != null) {
          await _saveToken(data['access_token']);
          if (data['refresh_token'] != null) {
            await _saveRefreshToken(data['refresh_token']);
          }
          LoggerService.info('Token refreshed successfully');
          return true;
        }
      }
      return false;
    } catch (e) {
      LoggerService.error('Token refresh failed', error: e);
      return false;
    }
  }
}
