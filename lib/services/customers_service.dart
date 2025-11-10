import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../models/customer.dart';
import '../services/logger_service.dart';
import 'auth_service.dart';

class CustomersServiceException implements Exception {
  final String message;
  final int? statusCode;

  CustomersServiceException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class CustomersService {
  final Dio _dio;
  final AuthService _authService;

  CustomersService({Dio? dio, AuthService? authService})
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

  Future<List<Customer>> getCustomers({
    required int storeId,
    bool includeOrderStats = true,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw CustomersServiceException('No access token available');
      }

      final response = await _dio.get(
        '/stores/$storeId/customers',
        queryParameters: {
          'include_order_stats': includeOrderStats,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> customersData = response.data as List<dynamic>;
        return customersData
            .map((json) => Customer.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw CustomersServiceException(
          'Failed to fetch customers: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      LoggerService.error('Error fetching customers', error: e);
      if (e.response?.statusCode == 401) {
        throw CustomersServiceException(
          'Authentication failed. Please login again.',
          statusCode: 401,
        );
      } else if (e.response?.statusCode == 404) {
        throw CustomersServiceException(
          'Store not found',
          statusCode: 404,
        );
      }
      throw CustomersServiceException(
        e.response?.data?['detail'] ?? 'Failed to fetch customers',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      LoggerService.error('Unexpected error fetching customers', error: e);
      throw CustomersServiceException('An unexpected error occurred: $e');
    }
  }

  Future<Customer?> getCustomerDetails({
    required int customerId,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null) {
        throw CustomersServiceException('No access token available');
      }

      final endpoint = ApiConstants.replacePathParameter(
        ApiConstants.customerDetailsEndpoint,
        'id',
        customerId.toString(),
      );

      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return Customer.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw CustomersServiceException(
          'Failed to fetch customer details: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      LoggerService.error('Error fetching customer details', error: e);
      if (e.response?.statusCode == 401) {
        throw CustomersServiceException(
          'Authentication failed. Please login again.',
          statusCode: 401,
        );
      } else if (e.response?.statusCode == 404) {
        throw CustomersServiceException(
          'Customer not found',
          statusCode: 404,
        );
      }
      throw CustomersServiceException(
        e.response?.data?['detail'] ?? 'Failed to fetch customer details',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      LoggerService.error('Unexpected error fetching customer details', error: e);
      throw CustomersServiceException('An unexpected error occurred: $e');
    }
  }
}

