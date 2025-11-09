import 'dart:io' show File;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import '../constants/api_constants.dart';
import 'logger_service.dart';

class ImageUploadService {
  static final ImageUploadService _instance = ImageUploadService._internal();
  factory ImageUploadService() => _instance;

  late final Dio _dio;

  ImageUploadService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(
          seconds: 30,
        ), // Longer timeout for uploads
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: ApiConstants.defaultHeaders,
      ),
    );
  }

  /// Upload images to a product (max 10 images)
  /// Returns a list of uploaded image URLs
  Future<List<String>> uploadProductImages({
    required int productId,
    required List<XFile> imageFiles,
    required String authToken,
  }) async {
    try {
      LoggerService.info(
        'Uploading ${imageFiles.length} images for product $productId',
      );

      if (imageFiles.isEmpty) {
        throw ImageUploadException('No images to upload');
      }

      if (imageFiles.length > 10) {
        throw ImageUploadException('Maximum 10 images allowed');
      }

      final formData = FormData();

      // Add each image to the form data with field name 'files' as expected by API
      for (int i = 0; i < imageFiles.length; i++) {
        final imageFile = imageFiles[i];

        if (kIsWeb) {
          // On web, read bytes and create MultipartFile from bytes
          final bytes = await imageFile.readAsBytes();
          formData.files.add(
            MapEntry(
              'files',
              MultipartFile.fromBytes(bytes, filename: imageFile.name),
            ),
          );
        } else {
          // On mobile/desktop, use file path
          formData.files.add(
            MapEntry(
              'files',
              await MultipartFile.fromFile(
                imageFile.path,
                filename: imageFile.name,
              ),
            ),
          );
        }
      }

      final endpoint = ApiConstants.uploadProductImagesEndpoint.replaceAll(
        '{productId}',
        productId.toString(),
      );

      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );

      if (response.data != null) {
        // Assuming the API returns a list of image URLs or objects
        final List<String> uploadedUrls = [];

        if (response.data is List) {
          for (var item in response.data) {
            if (item is String) {
              uploadedUrls.add(item);
            } else if (item is Map && item['url'] != null) {
              uploadedUrls.add(item['url'] as String);
            } else if (item is Map && item['image'] != null) {
              uploadedUrls.add(item['image'] as String);
            }
          }
        } else if (response.data is Map && response.data['images'] != null) {
          final images = response.data['images'] as List;
          for (var item in images) {
            if (item is String) {
              uploadedUrls.add(item);
            } else if (item is Map && item['url'] != null) {
              uploadedUrls.add(item['url'] as String);
            } else if (item is Map && item['image'] != null) {
              uploadedUrls.add(item['image'] as String);
            }
          }
        }

        LoggerService.info(
          'Successfully uploaded ${uploadedUrls.length} images',
        );
        return uploadedUrls;
      } else {
        throw ImageUploadException('Invalid response format');
      }
    } on DioException catch (e) {
      LoggerService.error('Dio error uploading images: ${e.message}');
      throw ImageUploadException(
        'Failed to upload images: ${e.message}',
        e.response?.statusCode ?? 0,
      );
    } catch (e) {
      LoggerService.error('Error uploading images: $e');
      throw ImageUploadException('Upload error: $e');
    }
  }

  /// Get all images for a product
  Future<List<String>> getProductImages(int productId) async {
    try {
      LoggerService.info('Fetching images for product $productId');

      final endpoint = ApiConstants.getProductImagesEndpoint.replaceAll(
        '{productId}',
        productId.toString(),
      );

      final response = await _dio.get(endpoint);

      if (response.data != null) {
        final List<String> imageUrls = [];

        if (response.data is List) {
          for (var item in response.data) {
            if (item is String) {
              imageUrls.add(item);
            } else if (item is Map && item['url'] != null) {
              imageUrls.add(item['url'] as String);
            } else if (item is Map && item['image'] != null) {
              imageUrls.add(item['image'] as String);
            }
          }
        } else if (response.data is Map && response.data['images'] != null) {
          final images = response.data['images'] as List;
          for (var item in images) {
            if (item is String) {
              imageUrls.add(item);
            } else if (item is Map && item['url'] != null) {
              imageUrls.add(item['url'] as String);
            } else if (item is Map && item['image'] != null) {
              imageUrls.add(item['image'] as String);
            }
          }
        }

        LoggerService.info(
          'Found ${imageUrls.length} images for product $productId',
        );
        return imageUrls;
      } else {
        return [];
      }
    } on DioException catch (e) {
      LoggerService.error('Dio error fetching product images: ${e.message}');
      throw ImageUploadException(
        'Failed to fetch product images: ${e.message}',
        e.response?.statusCode ?? 0,
      );
    } catch (e) {
      LoggerService.error('Error fetching product images: $e');
      throw ImageUploadException('Fetch error: $e');
    }
  }

  /// Delete a specific image from a product
  Future<void> deleteProductImage({
    required int productId,
    required int imageId,
    required String authToken,
  }) async {
    try {
      LoggerService.info('Deleting image $imageId from product $productId');

      final endpoint = ApiConstants.deleteProductImageEndpoint
          .replaceAll('{productId}', productId.toString())
          .replaceAll('{imageId}', imageId.toString());

      await _dio.delete(
        endpoint,
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );

      LoggerService.info(
        'Successfully deleted image $imageId from product $productId',
      );
    } on DioException catch (e) {
      LoggerService.error('Dio error deleting image: ${e.message}');
      throw ImageUploadException(
        'Failed to delete image: ${e.message}',
        e.response?.statusCode ?? 0,
      );
    } catch (e) {
      LoggerService.error('Error deleting image: $e');
      throw ImageUploadException('Delete error: $e');
    }
  }

  /// Validate image file
  bool isValidImageFile(String filePath) {
    // On web with blob URLs, there's no extension, so always return true
    if (kIsWeb && filePath.startsWith('blob:')) {
      return true;
    }

    // For regular file paths, validate extension
    final extension = filePath.toLowerCase().split('.').last;
    const validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

    return validExtensions.contains(extension);
  }

  /// Get file size in MB
  double getFileSizeMB(String filePath) {
    if (kIsWeb) {
      // On web, we can't easily get file size from path
      // Return 0 to skip size validation
      return 0;
    }

    final file = File(filePath);
    if (!file.existsSync()) return 0;

    final bytes = file.lengthSync();
    return bytes / (1024 * 1024); // Convert to MB
  }

  /// Validate file size (default max 5MB)
  bool isValidFileSize(String filePath, {double maxSizeMB = 5.0}) {
    if (kIsWeb) {
      // On web, skip file size validation
      return true;
    }
    return getFileSizeMB(filePath) <= maxSizeMB;
  }
}

class ImageUploadException implements Exception {
  final String message;
  final int statusCode;

  ImageUploadException(this.message, [this.statusCode = 0]);

  @override
  String toString() => 'ImageUploadException: $message (Status: $statusCode)';
}
