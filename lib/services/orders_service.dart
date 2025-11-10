import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../models/order.dart';
import 'auth_service.dart';
import 'logger_service.dart';

class OrdersService {
  final Dio _dio;
  final AuthService _authService;

  OrdersService({AuthService? authService})
    : _authService = authService ?? AuthService(),
      _dio = Dio() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = ApiConstants.connectTimeout;
    _dio.options.receiveTimeout = ApiConstants.receiveTimeout;
    _dio.options.sendTimeout = ApiConstants.sendTimeout;

    // Add interceptor for token and logging
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          LoggerService.debug('API Request: ${options.method} ${options.uri}');

          final token = await _authService.getToken();
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
          handler.next(response);
        },
        onError: (error, handler) {
          LoggerService.apiError(error.requestOptions.uri.toString(), error);
          handler.next(error);
        },
      ),
    );
  }

  /// Fetch orders analytics summary for a store
  ///
  /// Parameters:
  /// - [storeId]: The ID of the store
  /// - [period]: The time period for analytics (default: 'week')
  ///   Options: 'day', 'week', 'month', 'year'
  Future<Map<String, dynamic>?> getOrdersAnalyticsSummary({
    required String storeId,
    String period = 'week',
  }) async {
    try {
      LoggerService.info(
        'Fetching orders analytics summary for store: $storeId, period: $period',
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
        LoggerService.info('Orders analytics summary fetched successfully');
        return response.data as Map<String, dynamic>;
      } else {
        LoggerService.warning(
          'Failed to fetch orders analytics: ${response.statusCode}',
        );
        return null;
      }
    } on DioException catch (e) {
      LoggerService.apiError('getOrdersAnalyticsSummary', e);

      if (e.response != null) {
        LoggerService.error(
          'Orders analytics API error - Status: ${e.response!.statusCode}',
        );
      }
      return null;
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected error fetching orders analytics',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Fetch orders list for a store
  ///
  /// Parameters:
  /// - [storeId]: The ID of the store
  /// - [status]: Filter by order status (optional)
  /// - [skip]: Number of records to skip for pagination (default: 0)
  /// - [limit]: Maximum number of records to return (default: 100)
  /// - [startDate]: Start date for filtering (optional)
  /// - [endDate]: End date for filtering (optional)
  Future<List<Order>> getOrders({
    required String storeId,
    String? status,
    int skip = 0,
    int limit = 100,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      LoggerService.info(
        'Fetching orders for store: $storeId (skip: $skip, limit: $limit)',
      );

      final queryParams = <String, dynamic>{
        'store_id': storeId,
        'skip': skip,
        'limit': limit,
      };

      if (status != null) {
        queryParams['status'] = status;
      }
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }

      final response = await _dio.get(
        '${ApiConstants.ordersEndpoint}/',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        List<dynamic> ordersList;
        if (data is List) {
          ordersList = data;
        } else if (data is Map && data['orders'] != null) {
          ordersList = data['orders'] as List;
        } else {
          ordersList = [];
        }

        final orders = ordersList
            .map(
              (orderJson) => Order.fromJson(orderJson as Map<String, dynamic>),
            )
            .toList();

        LoggerService.info(
          'Orders fetched successfully: ${orders.length} orders',
        );
        return orders;
      } else {
        LoggerService.warning('Failed to fetch orders: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      LoggerService.apiError('getOrders', e);
      return [];
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected error fetching orders',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// Get order details by ID
  Future<Map<String, dynamic>?> getOrderDetails(String orderId) async {
    try {
      LoggerService.info('Fetching order details for: $orderId');

      final endpoint = ApiConstants.replacePathParameter(
        ApiConstants.orderDetailsEndpoint,
        'id',
        orderId,
      );

      final response = await _dio.get(endpoint);

      if (response.statusCode == 200) {
        LoggerService.info('Order details fetched successfully');
        return response.data as Map<String, dynamic>;
      } else {
        LoggerService.warning(
          'Failed to fetch order details: ${response.statusCode}',
        );
        return null;
      }
    } on DioException catch (e) {
      LoggerService.apiError('getOrderDetails', e);
      return null;
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected error fetching order details',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Update order status
  Future<bool> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      LoggerService.info('Updating order $orderId status to: $status');

      final endpoint = ApiConstants.replacePathParameter(
        ApiConstants.updateOrderStatusEndpoint,
        'id',
        orderId,
      );

      final response = await _dio.patch(endpoint, data: {'status': status});

      if (response.statusCode == 200) {
        LoggerService.info('Order status updated successfully');
        return true;
      } else {
        LoggerService.warning(
          'Failed to update order status: ${response.statusCode}',
        );
        return false;
      }
    } on DioException catch (e) {
      LoggerService.apiError('updateOrderStatus', e);
      return false;
    } catch (e, stackTrace) {
      LoggerService.error(
        'Unexpected error updating order status',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }
}
