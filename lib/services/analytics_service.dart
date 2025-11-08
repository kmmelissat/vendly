import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'auth_service.dart';
import 'logger_service.dart';

class AnalyticsService {
  final Dio _dio;
  final AuthService _authService;

  AnalyticsService() : _dio = Dio(), _authService = AuthService() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = ApiConstants.connectTimeout;
    _dio.options.receiveTimeout = ApiConstants.receiveTimeout;
    _dio.options.sendTimeout = ApiConstants.sendTimeout;

    // Add interceptor for token and logging
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
        onResponse: (response, handler) {
          LoggerService.debug(
            'Analytics API Response: ${response.statusCode} ${response.requestOptions.uri}',
          );
          handler.next(response);
        },
        onError: (error, handler) {
          LoggerService.apiError(error.requestOptions.uri.toString(), error);
          handler.next(error);
        },
      ),
    );
  }

  /// Fetch analytics summary for a store
  /// [storeId] - The store ID to fetch analytics for
  /// [period] - The period for analytics (week, month, year)
  Future<Map<String, dynamic>?> getAnalyticsSummary({
    required String storeId,
    String period = 'week',
  }) async {
    try {
      LoggerService.debug(
        'Fetching analytics summary for store $storeId, period: $period',
      );

      final endpoint = ApiConstants.replacePathParameter(
        ApiConstants.analyticsSummaryEndpoint,
        'storeId',
        storeId,
      );

      final response = await _dio.get(
        endpoint,
        queryParameters: {'period': period},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        LoggerService.info('Analytics summary fetched successfully');
        return data;
      } else {
        LoggerService.warning(
          'Failed to fetch analytics summary: ${response.statusCode}',
        );
        return null;
      }
    } on DioException catch (e) {
      LoggerService.apiError('Analytics Summary API', e);

      // Return null on error, let the UI handle fallback
      return null;
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected error fetching analytics summary',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Get store ID from current user data
  Future<String?> _getCurrentStoreId() async {
    try {
      final userData = await _authService.getUserData();
      if (userData != null) {
        final store = userData['store'] as Map<String, dynamic>?;
        return store?['id']?.toString();
      }
      return null;
    } catch (e) {
      LoggerService.error('Failed to get current store ID', error: e);
      return null;
    }
  }

  /// Fetch analytics summary for the current user's store
  Future<Map<String, dynamic>?> getCurrentStoreAnalytics({
    String period = 'week',
  }) async {
    final storeId = await _getCurrentStoreId();
    if (storeId == null) {
      LoggerService.warning('No store ID found for current user');
      return null;
    }

    return getAnalyticsSummary(storeId: storeId, period: period);
  }
}
