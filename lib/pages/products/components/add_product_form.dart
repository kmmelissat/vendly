import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'image_upload_widget.dart';
import '../../../services/products_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/image_upload_service.dart';
import '../../../models/category.dart';

class AddProductForm extends StatefulWidget {
  final ScrollController scrollController;
  final Function(Map<String, dynamic>) onProductAdded;
  final Map<String, dynamic>? existingProduct; // For editing
  final bool isEditing;

  const AddProductForm({
    super.key,
    required this.scrollController,
    required this.onProductAdded,
    this.existingProduct,
    this.isEditing = false,
  });

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _skuController = TextEditingController();
  final _priceController = TextEditingController();
  final _productionCostController = TextEditingController();
  final _discountPriceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _detailedDescriptionController = TextEditingController();
  final _stockController = TextEditingController();
  final _dimensionsController = TextEditingController();
  final _weightController = TextEditingController();
  final _materialController = TextEditingController();
  final _ageRangeController = TextEditingController();
  final _originController = TextEditingController();
  final _featuresController = TextEditingController();
  final _tagsController = TextEditingController();

  String selectedCategory = 'Labubu';
  bool inStock = true;
  String? selectedImagePath;
  List<String> uploadedImages = [];
  List<XFile> selectedImageFiles = []; // Store XFile objects for upload
  
  final ProductsService _productsService = ProductsService();
  final AuthService _authService = AuthService();
  final ImageUploadService _imageUploadService = ImageUploadService();
  bool _isSaving = false;
  bool _isLoadingCategories = true;
  
  // API-related fields
  int? storeId; // Will be fetched from user session
  int? selectedCategoryId; // Selected category ID from API
  List<Category> apiCategories = [];
  
  // Fallback categories if API fails
  final List<String> fallbackCategories = [
    'Labubu',
    'Plush',
    'Sonny Angel',
    'Ternuritos',
    'Others',
  ];


  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  Future<void> _initializeForm() async {
    // Fetch store ID from user session
    try {
      final userData = await _authService.getUserData();
      if (userData != null && userData['store_id'] != null) {
        storeId = userData['store_id'] as int;
      } else {
        storeId = 7; // Fallback to default
      }
    } catch (e) {
      storeId = 7; // Fallback on error
    }

    // Fetch categories from API
    try {
      final categories = await _productsService.getCategories();
      if (mounted) {
        setState(() {
          apiCategories = categories;
          _isLoadingCategories = false;
          if (categories.isNotEmpty && selectedCategoryId == null) {
            selectedCategoryId = categories.first.id;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
        });
      }
    }

    // Populate form if editing
    if (widget.isEditing && widget.existingProduct != null) {
      _populateFormWithExistingData();
    }
  }

  void _populateFormWithExistingData() {
    final product = widget.existingProduct!;
    _nameController.text = product['name'] ?? '';
    _brandController.text = product['brand'] ?? '';
    _skuController.text = product['sku'] ?? '';
    _priceController.text = (product['price'] ?? 0.0).toString();
    _productionCostController.text = (product['production_cost'] ?? 0.0).toString();
    _discountPriceController.text = product['discount_price']?.toString() ?? '';
    _descriptionController.text = product['description'] ?? '';
    _detailedDescriptionController.text = product['detailedDescription'] ?? '';
    _stockController.text = (product['stockQuantity'] ?? 0).toString();
    _dimensionsController.text = product['dimensions'] ?? '';
    _weightController.text = product['weight'] ?? '';
    _materialController.text = product['material'] ?? '';
    _ageRangeController.text = product['ageRange'] ?? '';
    _originController.text = product['origin'] ?? '';
    
    // Handle features and tags
    if (product['features'] is List) {
      _featuresController.text = (product['features'] as List).join(', ');
    }
    if (product['tags'] is List) {
      _tagsController.text = (product['tags'] as List).join(', ');
    }
    
    // Set other properties
    final productCategory = product['category'] ?? 'Labubu';
    selectedCategory = fallbackCategories.contains(productCategory) ? productCategory : 'Others';
    inStock = product['inStock'] ?? true;
    selectedImagePath = product['image'];
    
    // Set category ID if available
    if (product['category_id'] != null) {
      selectedCategoryId = product['category_id'] as int;
    }
    
    // Handle images - convert single image to list if needed
    if (product['images'] is List && (product['images'] as List).isNotEmpty) {
      uploadedImages = List<String>.from(product['images']);
    } else if (product['image'] != null && (product['image'] as String).isNotEmpty) {
      uploadedImages = [product['image']];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _productionCostController.dispose();
    _discountPriceController.dispose();
    _descriptionController.dispose();
    _detailedDescriptionController.dispose();
    _stockController.dispose();
    _dimensionsController.dispose();
    _weightController.dispose();
    _materialController.dispose();
    _ageRangeController.dispose();
    _originController.dispose();
    _featuresController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              Text(
                widget.isEditing ? 'Edit Product' : 'Add New Product',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Image Upload
              ImageUploadWidget(
                initialImages: uploadedImages,
                onImagesChanged: (images) {
                  setState(() {
                    uploadedImages = images;
                    // Update selectedImagePath for backward compatibility
                    selectedImagePath = images.isNotEmpty ? images.first : null;
                  });
                },
                onImageFilesChanged: (imageFiles) {
                  setState(() {
                    selectedImageFiles = imageFiles;
                  });
                },
                maxImages: 10, // API supports max 10 images
                allowMultiple: true,
              ),
              const SizedBox(height: 16),

              // Basic Information
              _buildBasicInformation(),
              const SizedBox(height: 16),

              // Pricing
              _buildPricing(),
              const SizedBox(height: 16),

              // Stock
              _buildStock(),
              const SizedBox(height: 16),

              // Descriptions
              _buildDescriptions(),
              const SizedBox(height: 16),

              // Specifications
              _buildSpecifications(),
              const SizedBox(height: 16),

              // Features and Tags
              _buildFeaturesAndTags(),
              const SizedBox(height: 24),

              // Action Buttons
              _buildActionButtons(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildBasicInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Product Name *',
            hintText: 'Ex: Labubu Classic Pink',
            prefixIcon: const Icon(Icons.inventory_2_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the product name';
            }
            if (value.length < 3) {
              return 'Name must be at least 3 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _brandController,
                decoration: InputDecoration(
                  labelText: 'Brand *',
                  hintText: 'Ex: POP MART',
                  prefixIcon: const Icon(Icons.business_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF5329C8),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the brand';
                  }
                  if (value.length < 2) {
                    return 'Brand too short';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _skuController,
                decoration: InputDecoration(
                  labelText: 'SKU *',
                  hintText: 'LAB-001-PNK',
                  prefixIcon: const Icon(Icons.qr_code_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF5329C8),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the SKU';
                  }
                  if (value.length < 3) {
                    return 'SKU too short';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _isLoadingCategories
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text('Loading categories...'),
                  ],
                ),
              )
            : apiCategories.isNotEmpty
                ? DropdownButtonFormField<int>(
                    value: selectedCategoryId,
                    decoration: InputDecoration(
                      labelText: 'Category *',
                      prefixIcon: const Icon(Icons.category_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    items: apiCategories.map((category) {
                      return DropdownMenuItem<int>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategoryId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Select a category';
                      }
                      return null;
                    },
                  )
                : DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category * (Fallback)',
                      prefixIcon: const Icon(Icons.category_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    items: fallbackCategories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            _getCategoryIcon(category),
                            const SizedBox(width: 8),
                            Text(category),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Select a category';
                      }
                      return null;
                    },
                  ),
      ],
    );
  }

  Widget _buildPricing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pricing',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        // Regular Price and Production Cost
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Regular Price *',
                  hintText: '25.00',
                  prefixIcon: const Icon(Icons.attach_money_outlined),
                  prefixText: '\$',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF5329C8),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter the price';
                  }
                  final price = double.tryParse(value);
                  if (price == null) {
                    return 'Invalid price';
                  }
                  if (price <= 0) {
                    return 'Price must be greater than 0';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _productionCostController,
                decoration: InputDecoration(
                  labelText: 'Production Cost',
                  hintText: '15.00',
                  prefixIcon: const Icon(Icons.precision_manufacturing_outlined),
                  prefixText: '\$',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF5329C8),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final cost = double.tryParse(value);
                    if (cost == null) {
                      return 'Invalid cost';
                    }
                    if (cost < 0) {
                      return 'Cannot be negative';
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Discount Price
        TextFormField(
          controller: _discountPriceController,
          decoration: InputDecoration(
            labelText: 'Discount Price (Optional)',
            hintText: '19.99',
            prefixIcon: const Icon(Icons.local_offer_outlined),
            prefixText: '\$',
            helperText: 'Leave empty if no discount',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF5329C8),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final discountPrice = double.tryParse(value);
              final regularPrice = double.tryParse(_priceController.text);
              if (discountPrice == null) {
                return 'Invalid price';
              }
              if (discountPrice < 0) {
                return 'Cannot be negative';
              }
              if (regularPrice != null && discountPrice >= regularPrice) {
                return 'Must be less than regular price';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inventory',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _stockController,
                decoration: InputDecoration(
                  labelText: 'Stock Quantity',
                  hintText: '100',
                  prefixIcon: const Icon(Icons.inventory_outlined),
                  suffixText: 'units',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF5329C8),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 1),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final stock = int.tryParse(value);
                    if (stock == null) {
                      return 'Invalid quantity';
                    }
                    if (stock < 0) {
                      return 'Cannot be negative';
                    }
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SwitchListTile(
                title: const Text('En Stock'),
                value: inStock,
                onChanged: (value) {
                  setState(() {
                    inStock = value;
                  });
                },
                activeColor: Colors.green,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripciones',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: 'Descripción Corta *',
            hintText: 'Descripción breve del producto para mostrar en listas',
            prefixIcon: const Icon(Icons.description_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          maxLines: 3,
          maxLength: 150,
          textCapitalization: TextCapitalization.sentences,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa una descripción';
            }
            if (value.length < 10) {
              return 'La descripción debe tener al menos 10 caracteres';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _detailedDescriptionController,
          decoration: InputDecoration(
            labelText: 'Descripción Detallada',
            hintText:
                'Descripción completa con características, beneficios y detalles técnicos',
            prefixIcon: const Icon(Icons.article_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          maxLines: 4,
          maxLength: 500,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildSpecifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Especificaciones',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _dimensionsController,
                decoration: InputDecoration(
                  labelText: 'Dimensiones',
                  hintText: '8cm x 6cm x 5cm',
                  prefixIcon: const Icon(Icons.straighten_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF5329C8),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Peso',
                  hintText: '120g',
                  prefixIcon: const Icon(Icons.scale_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF5329C8),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _materialController,
          decoration: InputDecoration(
            labelText: 'Material',
            hintText: 'PVC de alta calidad',
            prefixIcon: const Icon(Icons.texture_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _ageRangeController,
                decoration: InputDecoration(
                  labelText: 'Edad Recomendada',
                  hintText: '14+ años',
                  prefixIcon: const Icon(Icons.child_care_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF5329C8),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _originController,
                decoration: InputDecoration(
                  labelText: 'Origen',
                  hintText: 'China',
                  prefixIcon: const Icon(Icons.public_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF5329C8),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                textCapitalization: TextCapitalization.words,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturesAndTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Características y Etiquetas',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _featuresController,
          decoration: InputDecoration(
            labelText: 'Características',
            hintText:
                'Separar con comas: Figura oficial, Caja incluida, Material premium',
            prefixIcon: const Icon(Icons.star_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          maxLines: 3,
          maxLength: 200,
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _tagsController,
          decoration: InputDecoration(
            labelText: 'Etiquetas',
            hintText: 'Separar con comas: coleccionable, kawaii, premium',
            prefixIcon: const Icon(Icons.local_offer_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF5329C8), width: 2),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          maxLines: 2,
          maxLength: 100,
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            label: const Text('Cancelar'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveProduct,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.save),
            label: Text(
              _isSaving
                  ? 'Saving...'
                  : (widget.isEditing ? 'Update Product' : 'Save Product'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5329C8),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      try {
        // Get auth token
        final token = await _authService.getToken();
        if (token == null) {
          throw Exception('Not authenticated. Please log in.');
        }

        // Prepare product data for API
        final productData = {
          'name': _nameController.text,
          'short_description': _descriptionController.text,
          'long_description': _detailedDescriptionController.text.isNotEmpty
              ? _detailedDescriptionController.text
              : _descriptionController.text,
          'price': double.tryParse(_priceController.text) ?? 0.0,
          'production_cost': _productionCostController.text.isNotEmpty
              ? double.tryParse(_productionCostController.text) ?? 0
              : 0,
          'discount_price': _discountPriceController.text.isNotEmpty
              ? double.tryParse(_discountPriceController.text)
              : null,
          'discount_end_date': null, // Could add a date picker for this
          'stock': _stockController.text.isNotEmpty
              ? int.tryParse(_stockController.text) ?? 0
              : 0,
          'is_active': inStock,
          'store_id': storeId ?? 7, // Use fetched store ID or fallback
          'category_id': selectedCategoryId ?? 1, // Use selected category ID or fallback
          'tag_ids': [], // Could add tag selection
        };

        int? productId;
        
        if (widget.isEditing) {
          // Update existing product
          productId = int.tryParse(widget.existingProduct!['id'].toString());
          if (productId != null) {
            await _productsService.updateProduct(productId, productData, token);
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${_nameController.text} updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        } else {
          // Create new product
          final createdProduct = await _productsService.createProduct(productData, token);
          
          // Get product ID from created product
          productId = createdProduct.id;
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${_nameController.text} created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }

        // Upload images if there are any and we have a product ID
        if (productId != null && selectedImageFiles.isNotEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Uploading images...'),
                duration: Duration(seconds: 2),
              ),
            );
          }
          
          try {
            final imageUrls = await _imageUploadService.uploadProductImages(
              productId: productId,
              imageFiles: selectedImageFiles,
              authToken: token,
            );
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${imageUrls.length} images uploaded successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Product saved but image upload failed: ${e.toString()}'),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          }
        }

        // Notify parent and close
        widget.onProductAdded(productData);
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }

  Widget _getCategoryIcon(String category) {
    switch (category) {
      case 'Labubu':
        return const Icon(Icons.toys, size: 16, color: Color(0xFF5329C8));
      case 'Plush':
        return const Icon(Icons.pets, size: 16, color: Color(0xFFFF6B6B));
      case 'Sonny Angel':
        return const Icon(
          Icons.child_friendly,
          size: 16,
          color: Color(0xFF4ECDC4),
        );
      case 'Ternuritos':
        return const Icon(Icons.favorite, size: 16, color: Color(0xFFFFE66D));
      case 'Others':
        return const Icon(Icons.category, size: 16, color: Color(0xFF95A5A6));
      default:
        return const Icon(
          Icons.inventory_2,
          size: 16,
          color: Color(0xFF5329C8),
        );
    }
  }
}
