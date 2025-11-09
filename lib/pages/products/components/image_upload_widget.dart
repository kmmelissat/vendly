import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show File;
import '../../../services/image_upload_service.dart';

class ImageUploadWidget extends StatefulWidget {
  final List<String> initialImages;
  final Function(List<String>) onImagesChanged;
  final int maxImages;
  final bool allowMultiple;

  const ImageUploadWidget({
    super.key,
    this.initialImages = const [],
    required this.onImagesChanged,
    this.maxImages = 5,
    this.allowMultiple = true,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final ImagePicker _picker = ImagePicker();
  final ImageUploadService _uploadService = ImageUploadService();
  List<String> _imagePaths = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String _uploadStatus = '';

  @override
  void initState() {
    super.initState();
    _imagePaths = List.from(widget.initialImages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Images',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Add up to ${widget.maxImages} images. First image will be the main product image.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 12),
        
        // Image Grid
        _buildImageGrid(),
        
        const SizedBox(height: 12),
        
        // Upload Buttons
        _buildUploadButtons(),
        
        if (_isUploading) ...[
          const SizedBox(height: 12),
          _buildUploadingIndicator(),
        ],
      ],
    );
  }

  Widget _buildImageGrid() {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _imagePaths.length + (_imagePaths.length < widget.maxImages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _imagePaths.length) {
            return _buildImageItem(_imagePaths[index], index);
          } else {
            return _buildAddImagePlaceholder();
          }
        },
      ),
    );
  }

  Widget _buildImageItem(String imagePath, int index) {
    final isMainImage = index == 0;
    
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          // Image Container
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isMainImage 
                    ? const Color(0xFF5329C8) 
                    : Theme.of(context).dividerColor,
                width: isMainImage ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(imagePath),
            ),
          ),
          
          // Main Image Badge
          if (isMainImage)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF5329C8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'MAIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          
          // Remove Button
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
          
          // Reorder Handle (for non-main images)
          if (!isMainImage)
            Positioned(
              bottom: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _moveToMain(index),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      // Network image
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / 
                    loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    } else if (imagePath.startsWith('assets/')) {
      // Asset image
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder();
        },
      );
    } else {
      // Local file - handle web differently
      if (kIsWeb) {
        // On web, treat local paths as network URLs (blob URLs)
        return Image.network(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildImagePlaceholder();
          },
        );
      } else {
        // On mobile, use File
        return Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildImagePlaceholder();
          },
        );
      }
    }
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.image_not_supported,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
        size: 32,
      ),
    );
  }

  Widget _buildAddImagePlaceholder() {
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            style: BorderStyle.solid,
          ),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              'Add Image',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _imagePaths.length >= widget.maxImages ? null : () => _pickImage(ImageSource.gallery),
            icon: const Icon(Icons.photo_library_outlined, size: 18),
            label: const Text('Gallery'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _imagePaths.length >= widget.maxImages ? null : () => _pickImage(ImageSource.camera),
            icon: const Icon(Icons.camera_alt_outlined, size: 18),
            label: const Text('Camera'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        if (widget.allowMultiple && _imagePaths.length < widget.maxImages) ...[
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _pickMultipleImages,
              icon: const Icon(Icons.photo_library, size: 18),
              label: const Text('Multiple'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUploadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  value: _uploadProgress > 0 ? _uploadProgress : null,
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _uploadStatus.isNotEmpty ? _uploadStatus : 'Uploading images...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    if (_uploadProgress > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${(_uploadProgress * 100).toInt()}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (_uploadProgress > 0) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _uploadProgress,
              backgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Add Product Image',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Take Photo'),
                  subtitle: const Text('Use camera to take a new photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Choose from Gallery'),
                  subtitle: const Text('Select an existing photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if (widget.allowMultiple)
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Select Multiple'),
                    subtitle: const Text('Choose multiple photos at once'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickMultipleImages();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
        _uploadStatus = 'Selecting image...';
      });

      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        // Validate image - use image.name for web compatibility
        final fileNameToValidate = kIsWeb ? image.name : image.path;
        if (!_uploadService.isValidImageFile(fileNameToValidate)) {
          _showErrorSnackBar('Invalid image format. Please select a JPG, PNG, or WebP image.');
          return;
        }

        if (!_uploadService.isValidFileSize(image.path, maxSizeMB: 5.0)) {
          _showErrorSnackBar('Image too large. Please select an image smaller than 5MB.');
          return;
        }

        setState(() {
          _uploadStatus = 'Uploading image...';
        });

        try {
          // For now, we'll add the local path directly
          // In a real app, you would upload to server first:
          // final uploadedUrl = await _uploadService.uploadImage(image.path);
          
          setState(() {
            _imagePaths.add(image.path);
            _uploadProgress = 1.0;
            _uploadStatus = 'Upload complete!';
          });
          
          widget.onImagesChanged(_imagePaths);
          
          // Clear status after a delay
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              setState(() {
                _uploadStatus = '';
                _uploadProgress = 0.0;
              });
            }
          });
        } catch (e) {
          _showErrorSnackBar('Failed to upload image: $e');
        }
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _pickMultipleImages() async {
    try {
      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
        _uploadStatus = 'Selecting images...';
      });

      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        final remainingSlots = widget.maxImages - _imagePaths.length;
        final imagesToAdd = images.take(remainingSlots).toList();
        
        // Validate all images first
        final validImages = <XFile>[];
        for (final image in imagesToAdd) {
          // Use image.name for web compatibility
          final fileNameToValidate = kIsWeb ? image.name : image.path;
          if (!_uploadService.isValidImageFile(fileNameToValidate)) {
            _showErrorSnackBar('Skipped invalid image: ${image.name}');
            continue;
          }
          if (!_uploadService.isValidFileSize(image.path, maxSizeMB: 5.0)) {
            _showErrorSnackBar('Skipped large image: ${image.name}');
            continue;
          }
          validImages.add(image);
        }

        if (validImages.isNotEmpty) {
          setState(() {
            _uploadStatus = 'Uploading ${validImages.length} images...';
          });

          // For now, add local paths directly
          // In a real app, you would use:
          // final uploadedUrls = await _uploadService.uploadImagesWithProgress(
          //   validImages.map((img) => img.path).toList(),
          //   (current, total, progress) {
          //     setState(() {
          //       _uploadProgress = progress;
          //       _uploadStatus = 'Uploading $current/$total images...';
          //     });
          //   },
          // );

          for (int i = 0; i < validImages.length; i++) {
            setState(() {
              _uploadProgress = (i + 1) / validImages.length;
              _uploadStatus = 'Uploading ${i + 1}/${validImages.length} images...';
            });
            
            _imagePaths.add(validImages[i].path);
            
            // Simulate upload delay
            await Future.delayed(const Duration(milliseconds: 200));
          }

          widget.onImagesChanged(_imagePaths);

          setState(() {
            _uploadProgress = 1.0;
            _uploadStatus = 'Upload complete!';
          });

          // Clear status after a delay
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              setState(() {
                _uploadStatus = '';
                _uploadProgress = 0.0;
              });
            }
          });
        }

        if (images.length > remainingSlots) {
          _showInfoSnackBar(
            'Added ${validImages.length} images. ${images.length - remainingSlots} images were skipped due to limit.',
          );
        }
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick images: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _imagePaths.removeAt(index);
    });
    widget.onImagesChanged(_imagePaths);
  }

  void _moveToMain(int index) {
    setState(() {
      final image = _imagePaths.removeAt(index);
      _imagePaths.insert(0, image);
    });
    widget.onImagesChanged(_imagePaths);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
