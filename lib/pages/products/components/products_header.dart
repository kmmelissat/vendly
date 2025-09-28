import 'package:flutter/material.dart';

class ProductsHeader extends StatelessWidget {
  final String searchQuery;
  final String selectedCategory;
  final List<String> categories;
  final Function(String) onSearchChanged;
  final Function(String) onCategoryChanged;
  final VoidCallback onAddProduct;

  const ProductsHeader({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.categories,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with title and add button
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Listing',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: onAddProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9AFF9A),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: const Text('Add New Product'),
              ),
            ],
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Category Filter
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    onCategoryChanged(category);
                  },
                  backgroundColor: Colors.transparent,
                  selectedColor: const Color(0xFF5329C8).withOpacity(0.1),
                  checkmarkColor: const Color(0xFF5329C8),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? const Color(0xFF5329C8)
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFF5329C8)
                        : Theme.of(context).dividerColor,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
