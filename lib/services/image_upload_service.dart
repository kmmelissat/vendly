import 'dart:io' show File;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../constants/api_constants.dart';
import 'logger_service.dart';

class ImageUploadService {
  static final ImageUploadService _instance = ImageUploadService._internal();
  factory ImageUploadService() => _instance;
  
  late final Dio _dio;

  ImageUploadService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30), // Longer timeout for uploads
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: ApiConstants.defaultHeaders,
    ));
  }

  /// Upload a single image file
  Future<String> uploadImage(String filePath) async {
    try {
      LoggerService.info('Uploading image: $filePath');
      
      if (kIsWeb) {
        // On web, we can't use File, so skip actual upload for now
        // In production, you would handle web file upload differently
        LoggerService.info('Web upload not implemented, returning path as-is');
        return filePath;
      }

      final file = File(filePath);
      if (!file.existsSync()) {
        throw ImageUploadException('File does not exist: $filePath');
      }

      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        ApiConstants.uploadImageEndpoint,
        data: formData,
      );

      if (response.data != null && response.data['url'] != null) {
        final imageUrl = response.data['url'] as String;
        LoggerService.info('Successfully uploaded image: $imageUrl');
        return imageUrl;
      } else {
        throw ImageUploadException('Invalid response format');
      }
    } on DioException catch (e) {
      LoggerService.error('Dio error uploading image: ${e.message}');
      throw ImageUploadException(
        'Failed to upload image: ${e.message}',
        e.response?.statusCode ?? 0,
      );
    } catch (e) {
      LoggerService.error('Error uploading image: $e');
      throw ImageUploadException('Upload error: $e');
    }
  }

  /// Upload multiple images
  Future<List<String>> uploadImages(List<String> filePaths) async {
    try {
      LoggerService.info('Uploading ${filePaths.length} images');
      
      final List<String> uploadedUrls = [];
      
      for (int i = 0; i < filePaths.length; i++) {
        final filePath = filePaths[i];
        LoggerService.info('Uploading image ${i + 1}/${filePaths.length}: $filePath');
        
        try {
          final url = await uploadImage(filePath);
          uploadedUrls.add(url);
        } catch (e) {
          LoggerService.error('Failed to upload image $filePath: $e');
          // Continue with other images, but log the failure
          // You might want to throw here if you want all-or-nothing behavior
        }
      }
      
      LoggerService.info('Successfully uploaded ${uploadedUrls.length}/${filePaths.length} images');
      return uploadedUrls;
    } catch (e) {
      LoggerService.error('Error uploading multiple images: $e');
      throw ImageUploadException('Batch upload error: $e');
    }
  }

  /// Upload images with progress callback
  Future<List<String>> uploadImagesWithProgress(
    List<String> filePaths,
    Function(int current, int total, double progress)? onProgress,
  ) async {
    try {
      LoggerService.info('Uploading ${filePaths.length} images with progress tracking');
      
      final List<String> uploadedUrls = [];
      
      for (int i = 0; i < filePaths.length; i++) {
        final filePath = filePaths[i];
        
        try {
          // Report progress at start of each upload
          onProgress?.call(i, filePaths.length, i / filePaths.length);
          
          final url = await _uploadImageWithProgress(filePath, (progress) {
            // Calculate overall progress
            final overallProgress = (i + progress) / filePaths.length;
            onProgress?.call(i + 1, filePaths.length, overallProgress);
          });
          
          uploadedUrls.add(url);
        } catch (e) {
          LoggerService.error('Failed to upload image $filePath: $e');
          // Continue with other images
        }
      }
      
      // Report completion
      onProgress?.call(filePaths.length, filePaths.length, 1.0);
      
      LoggerService.info('Completed upload with progress: ${uploadedUrls.length}/${filePaths.length} images');
      return uploadedUrls;
    } catch (e) {
      LoggerService.error('Error uploading images with progress: $e');
      throw ImageUploadException('Progress upload error: $e');
    }
  }

  Future<String> _uploadImageWithProgress(
    String filePath,
    Function(double progress)? onProgress,
  ) async {
    try {
      if (kIsWeb) {
        // On web, simulate progress and return path
        onProgress?.call(1.0);
        return filePath;
      }

      final file = File(filePath);
      if (!file.existsSync()) {
        throw ImageUploadException('File does not exist: $filePath');
      }

      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final response = await _dio.post(
        ApiConstants.uploadImageEndpoint,
        data: formData,
        onSendProgress: (sent, total) {
          if (total > 0) {
            final progress = sent / total;
            onProgress?.call(progress);
          }
        },
      );

      if (response.data != null && response.data['url'] != null) {
        return response.data['url'] as String;
      } else {
        throw ImageUploadException('Invalid response format');
      }
    } catch (e) {
      if (e is ImageUploadException) rethrow;
      throw ImageUploadException('Upload error: $e');
    }
  }

  /// Delete an uploaded image
  Future<void> deleteImage(String imageUrl) async {
    try {
      LoggerService.info('Deleting image: $imageUrl');
      
      // Extract image ID or path from URL if needed
      // This depends on your API structure
      await _dio.delete(
        '/images', // Adjust endpoint as needed
        data: {'url': imageUrl},
      );

      LoggerService.info('Successfully deleted image: $imageUrl');
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
