import 'package:flutter/material.dart';

class AddProductForm extends StatefulWidget {
  final ScrollController scrollController;
  final Function(Map<String, dynamic>) onProductAdded;

  const AddProductForm({
    super.key,
    required this.scrollController,
    required this.onProductAdded,
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
  final _originalPriceController = TextEditingController();
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

  final List<String> categories = [
    'Labubu',
    'Plush',
    'Sonny Angel',
    'Ternuritos',
    'Others',
  ];

  final List<String> availableImages = [
    'assets/images/products/labubu1.jpg',
    'assets/images/products/labubu2.jpg',
    'assets/images/products/labubu3.jpg',
    'assets/images/products/sonnyangel1.jpg',
    'assets/images/products/plush1.jpg',
    'assets/images/products/cinamonroll1.jpg',
    'assets/images/products/gummybearplush1.jpg',
    'assets/images/products/mokoko.jpg',
    'assets/images/products/ternuritos1.jpg',
    'assets/images/products/ternuritos2.jpg',
    'assets/images/products/ternuritos3.jpg',
    'assets/images/products/wildcutieplush.jpg',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
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
                'Add New Product',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Image Selection
              _buildImageSelection(),
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

  Widget _buildImageSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Image',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: availableImages.length,
            itemBuilder: (context, index) {
              final imagePath = availableImages[index];
              final isSelected = selectedImagePath == imagePath;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedImagePath = imagePath;
                  });
                },
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF5329C8)
                          : Theme.of(context).dividerColor,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Theme.of(context).colorScheme.surface,
                          child: const Icon(Icons.image_not_supported),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
        DropdownButtonFormField<String>(
          value: selectedCategory,
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
          items: categories.map((category) {
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
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Current Price *',
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
                controller: _originalPriceController,
                decoration: InputDecoration(
                  labelText: 'Original Price',
                  hintText: '30.00',
                  prefixIcon: const Icon(Icons.local_offer_outlined),
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
                    final originalPrice = double.tryParse(value);
                    final currentPrice = double.tryParse(_priceController.text);
                    if (originalPrice == null) {
                      return 'Invalid price';
                    }
                    if (currentPrice != null && originalPrice <= currentPrice) {
                      return 'Must be greater than current price';
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
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
            onPressed: _saveProduct,
            icon: const Icon(Icons.save),
            label: const Text('Guardar Producto'),
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

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final newProduct = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _nameController.text,
        'brand': _brandController.text,
        'sku': _skuController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'originalPrice': _originalPriceController.text.isNotEmpty
            ? double.tryParse(_originalPriceController.text)
            : null,
        'image': selectedImagePath ?? 'assets/images/labubu.png',
        'category': selectedCategory,
        'description': _descriptionController.text,
        'detailedDescription': _detailedDescriptionController.text.isNotEmpty
            ? _detailedDescriptionController.text
            : _descriptionController.text,
        'inStock': inStock,
        'stockQuantity': _stockController.text.isNotEmpty
            ? int.tryParse(_stockController.text) ?? 0
            : 0,
        'rating': 4.5,
        'reviews': 0,
        'dimensions': _dimensionsController.text,
        'weight': _weightController.text,
        'material': _materialController.text,
        'ageRange': _ageRangeController.text,
        'origin': _originController.text,
        'tags': _tagsController.text.isNotEmpty
            ? _tagsController.text.split(',').map((e) => e.trim()).toList()
            : <String>[],
        'features': _featuresController.text.isNotEmpty
            ? _featuresController.text.split(',').map((e) => e.trim()).toList()
            : <String>[],
      };

      widget.onProductAdded(newProduct);
      Navigator.pop(context);
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
