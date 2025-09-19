import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/database_service.dart';
import '../../../../shared/models/store_model.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/glass_container.dart';

class StoreSetupScreen extends StatefulWidget {
  const StoreSetupScreen({super.key});

  @override
  State<StoreSetupScreen> createState() => _StoreSetupScreenState();
}

class _StoreSetupScreenState extends State<StoreSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();

  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  final ImagePicker _imagePicker = ImagePicker();

  String _selectedCategory = 'Electronics';
  File? _logoImage;
  File? _bannerImage;
  bool _isLoading = false;

  final List<String> _categories = [
    'Electronics',
    'Fashion',
    'Home & Garden',
    'Beauty & Health',
    'Sports & Outdoors',
    'Books & Media',
    'Toys & Games',
    'Food & Beverages',
    'Automotive',
    'Other',
  ];

  @override
  void dispose() {
    _storeNameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Setup Your Store'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Message
              FadeInDown(
                duration: AppConstants.animationMedium,
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusXl,
                        ),
                      ),
                      child: const Icon(
                        Icons.storefront_rounded,
                        size: AppConstants.iconLg,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    Text(
                      'Create Your Mini-Shop',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                    ),
                    Text(
                      'Set up your store and start selling',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.spacingXl),

              // Store Images Section
              FadeInLeft(
                duration: AppConstants.animationMedium,
                delay: const Duration(milliseconds: 100),
                child: GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Store Images',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                      ),
                      const SizedBox(height: AppConstants.spacingMd),

                      // Logo Upload
                      _buildImageUpload(
                        title: 'Store Logo',
                        subtitle: 'Square image recommended',
                        image: _logoImage,
                        onTap: () => _pickImage(isLogo: true),
                      ),

                      const SizedBox(height: AppConstants.spacingMd),

                      // Banner Upload
                      _buildImageUpload(
                        title: 'Store Banner',
                        subtitle: 'Wide image recommended',
                        image: _bannerImage,
                        onTap: () => _pickImage(isLogo: false),
                        isWide: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.spacingLg),

              // Store Details Form
              FadeInUp(
                duration: AppConstants.animationMedium,
                delay: const Duration(milliseconds: 200),
                child: GlassContainer(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Store Details',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                        ),
                        const SizedBox(height: AppConstants.spacingMd),

                        // Store Name
                        TextFormField(
                          controller: _storeNameController,
                          decoration: InputDecoration(
                            labelText: 'Store Name',
                            prefixIcon: const Icon(Icons.store_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusMd,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your store name';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: AppConstants.spacingMd),

                        // Category Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            prefixIcon: const Icon(Icons.category_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusMd,
                              ),
                            ),
                          ),
                          items: _categories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                        ),

                        const SizedBox(height: AppConstants.spacingMd),

                        // Description
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Store Description',
                            prefixIcon: const Icon(Icons.description_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusMd,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a store description';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: AppConstants.spacingMd),

                        // Address
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Store Address',
                            prefixIcon: const Icon(Icons.location_on_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusMd,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your store address';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: AppConstants.spacingMd),

                        // Phone
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Store Phone (Optional)',
                            prefixIcon: const Icon(Icons.phone_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusMd,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppConstants.spacingMd),

                        // Website
                        TextFormField(
                          controller: _websiteController,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                            labelText: 'Website (Optional)',
                            prefixIcon: const Icon(Icons.language_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusMd,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: AppConstants.spacingLg),

                        // Create Store Button
                        CustomButton(
                          text: 'Create Store',
                          onPressed: _isLoading ? null : _handleCreateStore,
                          isLoading: _isLoading,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUpload({
    required String title,
    required String subtitle,
    required File? image,
    required VoidCallback onTap,
    bool isWide = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isWide ? 120 : 100,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.borderColor,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          color: AppTheme.surfaceColor,
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: AppConstants.iconLg,
                    color: AppTheme.textSecondary,
                  ),
                  const SizedBox(height: AppConstants.spacingSm),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _pickImage({required bool isLogo}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: isLogo ? 512 : 1024,
        maxHeight: isLogo ? 512 : 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          if (isLogo) {
            _logoImage = File(image.path);
          } else {
            _bannerImage = File(image.path);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleCreateStore() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, you would upload images to a cloud storage service
      // For now, we'll use the local file paths
      final store = Store(
        sellerId: currentUser.id,
        name: _storeNameController.text.trim(),
        description: _descriptionController.text.trim(),
        logoUrl: _logoImage?.path,
        bannerUrl: _bannerImage?.path,
        category: _selectedCategory,
        address: _addressController.text.trim(),
        phoneNumber: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        website: _websiteController.text.trim().isNotEmpty
            ? _websiteController.text.trim()
            : null,
        status: StoreStatus.active,
      );

      await _databaseService.insertStore(store);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Store created successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
          ),
        );

        // Navigate to main screen
        Navigator.of(context).pushReplacementNamed('/main');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create store: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
