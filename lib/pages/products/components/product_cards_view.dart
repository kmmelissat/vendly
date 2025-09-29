import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class ProductCardsView extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final Function(Map<String, dynamic>) onProductTap;
  final Function(Map<String, dynamic>, bool) onStockToggle;

  const ProductCardsView({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onStockToggle,
  });

  @override
  State<ProductCardsView> createState() => _ProductCardsViewState();
}

class _ProductCardsViewState extends State<ProductCardsView> {
  String sortBy = 'name'; // name, price, stock
  bool sortAscending = true;
  String viewMode = 'grid'; // grid, list

  List<Map<String, dynamic>> get sortedProducts {
    final products = List<Map<String, dynamic>>.from(widget.products);

    products.sort((a, b) {
      dynamic aValue, bValue;

      switch (sortBy) {
        case 'name':
          aValue = a['name'] ?? '';
          bValue = b['name'] ?? '';
          break;
        case 'price':
          aValue = a['price'] ?? 0.0;
          bValue = b['price'] ?? 0.0;
          break;
        case 'stock':
          aValue = a['stockQuantity'] ?? 0;
          bValue = b['stockQuantity'] ?? 0;
          break;
        default:
          return 0;
      }

      int result;
      if (aValue is String && bValue is String) {
        result = aValue.compareTo(bValue);
      } else if (aValue is num && bValue is num) {
        result = aValue.compareTo(bValue);
      } else {
        result = aValue.toString().compareTo(bValue.toString());
      }

      return sortAscending ? result : -result;
    });

    return products;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildControlsBar(),
        const SizedBox(height: 16),
        Expanded(
          child: viewMode == 'grid' ? _buildGridView() : _buildListView(),
        ),
      ],
    );
  }

  Widget _buildControlsBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Sort dropdown
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.sort,
                  size: 20,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
                const SizedBox(width: 8),
                Text(
                  'Sort by:',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: sortBy,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'name', child: Text('Name')),
                    DropdownMenuItem(value: 'price', child: Text('Price')),
                    DropdownMenuItem(value: 'stock', child: Text('Stock')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        sortBy = value;
                      });
                    }
                  },
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      sortAscending = !sortAscending;
                    });
                  },
                  icon: Icon(
                    sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 20,
                  ),
                  tooltip: sortAscending ? 'Ascending' : 'Descending',
                ),
              ],
            ),
          ),
          // View mode toggle
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      viewMode = 'grid';
                    });
                  },
                  icon: Icon(
                    Icons.grid_view,
                    color: viewMode == 'grid'
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  tooltip: 'Grid View',
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      viewMode = 'list';
                    });
                  },
                  icon: Icon(
                    Icons.view_list,
                    color: viewMode == 'list'
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  tooltip: 'List View',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6, // Further reduced to give even more height
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: sortedProducts.length,
      itemBuilder: (context, index) {
        return FadeInUp(
          delay: Duration(milliseconds: index * 100),
          child: _buildProductCard(sortedProducts[index], isGrid: true),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedProducts.length,
      itemBuilder: (context, index) {
        return FadeInUp(
          delay: Duration(milliseconds: index * 50),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildProductCard(sortedProducts[index], isGrid: false),
          ),
        );
      },
    );
  }

  Widget _buildProductCard(
    Map<String, dynamic> product, {
    required bool isGrid,
  }) {
    final stockLevel = product['stockQuantity'] ?? 0;
    final maxStock = 200;
    final stockPercentage = (stockLevel / maxStock).clamp(0.0, 1.0);
    final isInStock = product['inStock'] ?? false;

    Color stockLevelColor;
    String stockStatus;
    if (stockPercentage > 0.7) {
      stockLevelColor = Colors.green;
      stockStatus = 'High Stock';
    } else if (stockPercentage > 0.3) {
      stockLevelColor = Colors.orange;
      stockStatus = 'Medium Stock';
    } else {
      stockLevelColor = Colors.red;
      stockStatus = 'Low Stock';
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => widget.onProductTap(product),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: isGrid
              ? _buildGridCardContent(
                  product,
                  stockLevel,
                  stockLevelColor,
                  stockStatus,
                  stockPercentage,
                  isInStock,
                )
              : _buildListCardContent(
                  product,
                  stockLevel,
                  stockLevelColor,
                  stockStatus,
                  stockPercentage,
                  isInStock,
                ),
        ),
      ),
    );
  }

  Widget _buildGridCardContent(
    Map<String, dynamic> product,
    int stockLevel,
    Color stockLevelColor,
    String stockStatus,
    double stockPercentage,
    bool isInStock,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: product['image'] != null
                  ? Image.asset(
                      product['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildImagePlaceholder();
                      },
                    )
                  : _buildImagePlaceholder(),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Product Info
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name and Brand
              Flexible(
                child: Text(
                  product['name'] ?? 'Unknown Product',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                product['brand'] ?? 'Unknown Brand',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Price and Stock
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      '\$${(product['price'] ?? 0.0).toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: stockLevelColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      stockLevel.toString(),
                      style: TextStyle(
                        color: stockLevelColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Stock Status and Toggle
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1),
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: stockPercentage,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1),
                                color: stockLevelColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          stockStatus,
                          style: TextStyle(
                            fontSize: 8,
                            color: stockLevelColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 2),
                  Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: isInStock,
                      onChanged: (value) =>
                          widget.onStockToggle(product, value),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListCardContent(
    Map<String, dynamic> product,
    int stockLevel,
    Color stockLevelColor,
    String stockStatus,
    double stockPercentage,
    bool isInStock,
  ) {
    return Row(
      children: [
        // Product Image
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: product['image'] != null
                ? Image.asset(
                    product['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildImagePlaceholder();
                    },
                  )
                : _buildImagePlaceholder(),
          ),
        ),
        const SizedBox(width: 16),

        // Product Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and Brand
              Text(
                product['name'] ?? 'Unknown Product',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                product['brand'] ?? 'Unknown Brand',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 8),

              // Price and Stock Info
              Row(
                children: [
                  Text(
                    '\$${(product['price'] ?? 0.0).toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: stockLevelColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Stock: $stockLevel',
                      style: TextStyle(
                        color: stockLevelColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Stock Level Bar
              Container(
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: stockPercentage,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: stockLevelColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Actions
        Column(
          children: [
            Switch(
              value: isInStock,
              onChanged: (value) => widget.onStockToggle(product, value),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(height: 8),
            IconButton(
              onPressed: () => widget.onProductTap(product),
              icon: const Icon(Icons.edit, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.1),
                foregroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: const Size(36, 36),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      child: Icon(
        Icons.inventory_2,
        color: Theme.of(context).colorScheme.primary,
        size: 32,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeInUp(
            child: Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 24),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text(
              'No products found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 8),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: Text(
              'Try adjusting your search or filters',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
