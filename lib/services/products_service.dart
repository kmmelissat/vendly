import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../models/product.dart';
import '../models/category.dart';
import 'logger_service.dart';

class ProductsService {
  static final ProductsService _instance = ProductsService._internal();
  factory ProductsService() => _instance;
  
  late final Dio _dio;

  ProductsService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      headers: ApiConstants.defaultHeaders,
    ));
  }

  /// Fetches products for a specific store
  Future<List<Product>> getStoreProducts(int storeId) async {
    try {
      LoggerService.info('Fetching products for store ID: $storeId');
      
      final endpoint = ApiConstants.replacePathParameter(
        ApiConstants.storeProductsEndpoint,
        'storeId',
        storeId.toString(),
      );
      
      LoggerService.debug('Making GET request to: $endpoint');
      
      final response = await _dio.get(endpoint);

      LoggerService.debug('Response status code: ${response.statusCode}');
      LoggerService.debug('Response data length: ${response.data?.length ?? 0}');

      final List<dynamic> jsonData = response.data as List<dynamic>;
      final products = jsonData
          .map((productJson) => Product.fromJson(productJson))
          .toList();
      
      LoggerService.info('Successfully fetched ${products.length} products for store $storeId');
      return products;
    } on DioException catch (e) {
      LoggerService.error('Dio error fetching store products: ${e.message}');
      LoggerService.error('Status code: ${e.response?.statusCode}');
      throw ProductsServiceException(
        'Failed to fetch products: ${e.message}',
        e.response?.statusCode ?? 0,
      );
    } catch (e) {
      LoggerService.error('Error fetching store products: $e');
      throw ProductsServiceException('Network error: $e', 0);
    }
  }

  /// Creates a new product
  /// Requires authentication token
  Future<Product> createProduct(
    Map<String, dynamic> productData,
    String authToken,
  ) async {
    try {
      LoggerService.info('Creating new product');
      
      // Format data according to API requirements
      final apiData = {
        'name': productData['name'],
        'short_description': productData['description'] ?? productData['short_description'],
        'long_description': productData['detailedDescription'] ?? productData['long_description'],
        'price': productData['price'],
        'production_cost': productData['production_cost'] ?? 0,
        'discount_price': productData['discount_price'],
        'discount_end_date': productData['discount_end_date'],
        'stock': productData['stockQuantity'] ?? productData['stock'] ?? 0,
        'is_active': productData['inStock'] ?? productData['is_active'] ?? true,
        'store_id': productData['store_id'],
        'category_id': productData['category_id'],
        'tag_ids': productData['tag_ids'] ?? [],
      };
      
      final response = await _dio.post(
        ApiConstants.createProductEndpoint,
        data: apiData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      final product = Product.fromJson(response.data);
      LoggerService.info('Successfully created product with ID: ${product.id}');
      return product;
    } on DioException catch (e) {
      LoggerService.error('Dio error creating product: ${e.message}');
      if (e.response?.statusCode == 401) {
        throw ProductsServiceException('Unauthorized: Please log in again', 401);
      }
      throw ProductsServiceException(
        'Failed to create product: ${e.message}',
        e.response?.statusCode ?? 0,
      );
    } catch (e) {
      LoggerService.error('Error creating product: $e');
      throw ProductsServiceException('Network error: $e', 0);
    }
  }

  /// Updates an existing product
  /// Requires authentication token
  /// Note: store_id is NOT included in update (per API spec)
  Future<Product> updateProduct(
    int productId,
    Map<String, dynamic> productData,
    String authToken,
  ) async {
    try {
      LoggerService.info('Updating product ID: $productId');
      
      final endpoint = ApiConstants.replacePathParameter(
        ApiConstants.updateProductEndpoint,
        'id',
        productId.toString(),
      );
      
      // Format data according to API requirements (no store_id in update)
      final apiData = {
        'name': productData['name'],
        'short_description': productData['description'] ?? productData['short_description'],
        'long_description': productData['detailedDescription'] ?? productData['long_description'],
        'price': productData['price'],
        'production_cost': productData['production_cost'] ?? 0,
        'discount_price': productData['discount_price'],
        'discount_end_date': productData['discount_end_date'],
        'stock': productData['stockQuantity'] ?? productData['stock'] ?? 0,
        'is_active': productData['inStock'] ?? productData['is_active'] ?? true,
        'category_id': productData['category_id'],
        'tag_ids': productData['tag_ids'] ?? [],
      };
      
      final response = await _dio.put(
        endpoint,
        data: apiData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      final product = Product.fromJson(response.data);
      LoggerService.info('Successfully updated product ID: $productId');
      return product;
    } on DioException catch (e) {
      LoggerService.error('Dio error updating product: ${e.message}');
      if (e.response?.statusCode == 401) {
        throw ProductsServiceException('Unauthorized: Please log in again', 401);
      }
      throw ProductsServiceException(
        'Failed to update product: ${e.message}',
        e.response?.statusCode ?? 0,
      );
    } catch (e) {
      LoggerService.error('Error updating product: $e');
      throw ProductsServiceException('Network error: $e', 0);
    }
  }

  /// Deletes a product
  Future<void> deleteProduct(int productId) async {
    try {
      LoggerService.info('Deleting product ID: $productId');
      
      final endpoint = ApiConstants.replacePathParameter(
        ApiConstants.deleteProductEndpoint,
        'id',
        productId.toString(),
      );
      
      await _dio.delete(endpoint);
      LoggerService.info('Successfully deleted product ID: $productId');
    } on DioException catch (e) {
      LoggerService.error('Dio error deleting product: ${e.message}');
      throw ProductsServiceException(
        'Failed to delete product: ${e.message}',
        e.response?.statusCode ?? 0,
      );
    } catch (e) {
      LoggerService.error('Error deleting product: $e');
      throw ProductsServiceException('Network error: $e', 0);
    }
  }

  /// Gets a single product by ID
  Future<Product> getProduct(int productId) async {
    try {
      LoggerService.info('Fetching product ID: $productId');
      
      final endpoint = ApiConstants.replacePathParameter(
        ApiConstants.productDetailsEndpoint,
        'id',
        productId.toString(),
      );
      
      final response = await _dio.get(endpoint);

      final product = Product.fromJson(response.data);
      LoggerService.info('Successfully fetched product ID: $productId');
      return product;
    } on DioException catch (e) {
      LoggerService.error('Dio error fetching product: ${e.message}');
      throw ProductsServiceException(
        'Failed to fetch product: ${e.message}',
        e.response?.statusCode ?? 0,
      );
    } catch (e) {
      LoggerService.error('Error fetching product: $e');
      throw ProductsServiceException('Network error: $e', 0);
    }
  }

  /// Fetches all categories
  Future<List<Category>> getCategories() async {
    try {
      LoggerService.info('Fetching categories');
      
      final response = await _dio.get(ApiConstants.categoriesEndpoint);

      LoggerService.debug('Response status code: ${response.statusCode}');
      LoggerService.debug('Response data length: ${response.data?.length ?? 0}');

      final List<dynamic> jsonData = response.data as List<dynamic>;
      final categories = jsonData
          .map((categoryJson) => Category.fromJson(categoryJson))
          .toList();
      
      LoggerService.info('Successfully fetched ${categories.length} categories');
      return categories;
    } on DioException catch (e) {
      LoggerService.error('Dio error fetching categories: ${e.message}');
      LoggerService.error('Status code: ${e.response?.statusCode}');
      throw ProductsServiceException(
        'Failed to fetch categories: ${e.message}',
        e.response?.statusCode ?? 0,
      );
    } catch (e) {
      LoggerService.error('Error fetching categories: $e');
      throw ProductsServiceException('Network error: $e', 0);
    }
  }
}

class ProductsServiceException implements Exception {
  final String message;
  final int statusCode;

  ProductsServiceException(this.message, this.statusCode);

  @override
  String toString() => 'ProductsServiceException: $message (Status: $statusCode)';
}
