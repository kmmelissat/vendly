import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';

class AuthService {
  final Dio _dio;

  AuthService() : _dio = Dio() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = ApiConstants.connectTimeout;
    _dio.options.receiveTimeout = ApiConstants.receiveTimeout;
    _dio.options.sendTimeout = ApiConstants.sendTimeout;

    // Add interceptor for token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getToken();
          if (token != null) {
            options.headers[ApiConstants.authorizationHeader] = 'Bearer $token';
          }
          options.headers.addAll(ApiConstants.defaultHeaders);
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Token expired, logout user
            logout();
          }
          handler.next(error);
        },
      ),
    );
  }

  // Login method
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Save token and user data
        await _saveToken(data['token']);
        await _saveUserData(data['user']);

        return {'success': true, 'token': data['token'], 'user': data['user']};
      } else {
        return {'success': false, 'message': 'Login failed'};
      }
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';

      if (e.response != null) {
        switch (e.response!.statusCode) {
          case 400:
            errorMessage = 'Invalid email or password';
            break;
          case 401:
            errorMessage = 'Invalid credentials';
            break;
          case 404:
            errorMessage = 'User not found';
            break;
          case 500:
            errorMessage = 'Server error. Please try again later';
            break;
          default:
            errorMessage = e.response?.data['message'] ?? 'Login failed';
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

  // Register method
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? storeName,
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

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    // You might want to use dart:convert to encode JSON
    // For now, just saving as string
    await prefs.setString(AppConstants.userDataKey, userData.toString());
  }

  Future<void> _clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userDataKey);
  }

  // Refresh token method (if your API supports it)
  Future<bool> refreshToken() async {
    try {
      final response = await _dio.post(ApiConstants.refreshTokenEndpoint);
      if (response.statusCode == 200) {
        final newToken = response.data['token'];
        await _saveToken(newToken);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
