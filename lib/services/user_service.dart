import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'auth_service.dart';
import 'logger_service.dart';

class UserService {
  final Dio _dio;
  final AuthService _authService;

  UserService({AuthService? authService})
      : _authService = authService ?? AuthService(),
        _dio = Dio() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = ApiConstants.connectTimeout;
    _dio.options.receiveTimeout = ApiConstants.receiveTimeout;
    _dio.options.sendTimeout = ApiConstants.sendTimeout;

    // Add interceptor for token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _authService.getToken();
          if (token != null) {
            options.headers[ApiConstants.authorizationHeader] = 'Bearer $token';
          }
          options.headers.addAll(ApiConstants.defaultHeaders);
          handler.next(options);
        },
      ),
    );
  }

  /// Fetch current user profile from API
  /// GET /users/me
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      LoggerService.debug('Fetching current user profile');
      
      final response = await _dio.get('/users/me');

      if (response.statusCode == 200) {
        LoggerService.info('User profile fetched successfully');
        return response.data as Map<String, dynamic>;
      } else {
        LoggerService.warning(
          'Failed to fetch user profile: ${response.statusCode}',
        );
        return null;
      }
    } on DioException catch (e) {
      LoggerService.apiError('/users/me', e);
      
      if (e.response?.statusCode == 401) {
        // Token might be expired, try to refresh
        final refreshed = await _authService.refreshToken();
        if (refreshed) {
          // Retry the request
          try {
            final response = await _dio.get('/users/me');
            if (response.statusCode == 200) {
              return response.data as Map<String, dynamic>;
            }
          } catch (retryError) {
            LoggerService.error('Retry failed after token refresh', error: retryError);
          }
        }
      }
      
      return null;
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected error fetching user profile',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Update user profile
  /// PUT /users/me
  Future<Map<String, dynamic>> updateUserProfile({
    String? username,
    String? email,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (username != null) data['username'] = username;
      if (email != null) data['email'] = email;

      final response = await _dio.put('/users/me', data: data);

      if (response.statusCode == 200) {
        LoggerService.info('User profile updated successfully');
        return {
          'success': true,
          'message': 'Profile updated successfully',
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to update profile',
        };
      }
    } on DioException catch (e) {
      LoggerService.apiError('/users/me', e);
      
      String errorMessage = 'Failed to update profile';
      if (e.response != null) {
        errorMessage = e.response?.data['detail'] ?? errorMessage;
      }
      
      return {
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      LoggerService.error('Unexpected error updating profile', error: e);
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }

  /// Update store information
  /// PUT /stores/{storeId}
  Future<Map<String, dynamic>> updateStoreInfo({
    required int storeId,
    String? name,
    String? location,
    String? type,
    String? description,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (location != null) data['location'] = location;
      if (type != null) data['type'] = type;
      if (description != null) data['description'] = description;

      final endpoint = ApiConstants.replacePathParameter(
        ApiConstants.updateStoreEndpoint,
        'id',
        storeId.toString(),
      );

      final response = await _dio.put(endpoint, data: data);

      if (response.statusCode == 200) {
        LoggerService.info('Store info updated successfully');
        return {
          'success': true,
          'message': 'Store information updated successfully',
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to update store information',
        };
      }
    } on DioException catch (e) {
      LoggerService.apiError('updateStoreInfo', e);
      
      String errorMessage = 'Failed to update store information';
      if (e.response != null) {
        errorMessage = e.response?.data['detail'] ?? errorMessage;
      }
      
      return {
        'success': false,
        'message': errorMessage,
      };
    } catch (e) {
      LoggerService.error('Unexpected error updating store info', error: e);
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }
}

