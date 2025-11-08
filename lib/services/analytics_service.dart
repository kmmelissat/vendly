import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'auth_service.dart';
import 'logger_service.dart';

class AnalyticsService {
  final Dio _dio;
  final AuthService _authService;

  // ✅ Controla si se usa mock o backend real
  final bool _useMock = true;

  AnalyticsService() : _dio = Dio(), _authService = AuthService() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = ApiConstants.connectTimeout;
    _dio.options.receiveTimeout = ApiConstants.receiveTimeout;
    _dio.options.sendTimeout = ApiConstants.sendTimeout;

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

  Future<Map<String, dynamic>?> getAnalyticsSummary({
    required String storeId,
    String period = 'week',
  }) async {
    if (_useMock) {
      await Future.delayed(const Duration(milliseconds: 400));
      return {
        "store_id": storeId,
        "total_orders": 128,
        "total_income": 5200,
        "average_order_value": 40.6,
        "conversion_rate": 2.4,
        "period": period,
        "currency": "USD",
        "customerDemographics": {"men": 45, "women": 55},
        "customerRetentionRate": 78,
        "topSellingProducts": [
          {"name": "Café Premium", "sales": 1200},
          {"name": "Brownie Artesanal", "sales": 950}
        ],
        "salesByCategory": {
          "Bebidas": 2500,
          "Postres": 1700,
          "Snacks": 1000
        },
        "growthMetrics": {"month_over_month": 12.5},
        "inventoryInsights": {"low_stock_items": 4}
      };
    }

    try {
      LoggerService.debug('Fetching analytics summary for store $storeId, period: $period');
      final endpoint = ApiConstants.replacePathParameter(
        ApiConstants.analyticsSummaryEndpoint,
        'storeId',
        storeId,
      );

      final response = await _dio.get(endpoint, queryParameters: {'period': period});
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        LoggerService.info('Analytics summary fetched successfully');
        return data;
      } else {
        LoggerService.warning('Failed to fetch analytics summary: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      LoggerService.apiError('Analytics Summary API', e);
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

  Future<String?> getIncome({
    required String storeId,
    String period = 'week',
  }) async {
    if (_useMock) {
      await Future.delayed(const Duration(milliseconds: 400));
      return "5200.00";
    }

    try {
      LoggerService.debug('Fetching income analytics for store $storeId, period: $period');
      final endpoint = ApiConstants.replacePathParameter(
        ApiConstants.analyticsIncomeEndpoint,
        'store_id',
        storeId,
      );
      final response = await _dio.get(endpoint, queryParameters: {'period': period});
      if (response.statusCode == 200) {
        final data = response.data;
        final income = (data is Map<String, dynamic>)
            ? data['income']?.toString()
            : data.toString();
        LoggerService.info('Income fetched successfully: $income');
        return income;
      } else {
        LoggerService.warning('Failed to fetch income: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      LoggerService.apiError('Analytics Income API', e);
      return null;
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected error fetching income',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> getRevenueForCurrentStore({
    String period = 'month',
    String? startDate,
    String? endDate,
  }) async {
    final storeId = await _getCurrentStoreId();
    if (storeId == null) {
      LoggerService.warning('No store ID found for current user');
      return null;
    }
    return getRevenue(
      storeId: storeId,
      period: period,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<Map<String, dynamic>?> getRevenue({
    required String storeId,
    String period = 'month',
    String? startDate,
    String? endDate,
  }) async {
    if (_useMock) {
      await Future.delayed(const Duration(milliseconds: 400));
      return {
        "store_id": storeId,
        "total_revenue": 3700,
        "total_income": 5000,
        "total_costs": 1300,
        "profit_margin_percent": 26,
        "period": period,
        "currency": "USD"
      };
    }

    try {
      LoggerService.debug('Fetching revenue analytics for store $storeId, period: $period');
      final endpoint = ApiConstants.replacePathParameter(
        ApiConstants.analyticsRevenueEndpoint,
        'store_id',
        storeId,
      );
      final queryParams = {
        'period': period,
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      };
      final response = await _dio.get(endpoint, queryParameters: queryParams);
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        LoggerService.info('Revenue fetched successfully');
        return data;
      } else {
        LoggerService.warning('Failed to fetch revenue: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      LoggerService.apiError('Analytics Revenue API', e);
      return null;
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected error fetching revenue',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}
