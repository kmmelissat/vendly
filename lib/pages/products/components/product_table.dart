import 'package:flutter/material.dart';

class ProductTable extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function(Map<String, dynamic>) onProductTap;
  final Function(Map<String, dynamic>, bool) onStockToggle;

  const ProductTable({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onStockToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        // Fixed Header
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: 800,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: Text(
                    'Products',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    'Price',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Stock',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    'Stock Level',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    'Status',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(
                  width: 170,
                  child: Text(
                    'Manage',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Scrollable Content
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 800,
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return _buildProductRow(context, product);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_dissatisfied,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow(BuildContext context, Map<String, dynamic> product) {
    final stockLevel = product['stockQuantity'] ?? 0;
    final maxStock = 200;
    final stockPercentage = (stockLevel / maxStock).clamp(0.0, 1.0);

    Color stockLevelColor;
    if (stockPercentage > 0.7) {
      stockLevelColor = Colors.green;
    } else if (stockPercentage > 0.3) {
      stockLevelColor = Colors.orange;
    } else {
      stockLevelColor = Colors.red;
    }

    return Container(
      width: 800, // Ensure consistent width
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Products (200px width)
          SizedBox(
            width: 200,
            child: Row(
              children: [
                // Product Image
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withOpacity(0.2),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: product['image'] != null
                        ? Image.asset(
                            product['image'],
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 40,
                                height: 40,
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1),
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 40,
                            height: 40,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            child: Icon(
                              Icons.inventory_2,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product['name'] ?? 'Unknown Product',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product['brand'] ?? 'Unknown Brand',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Price (100px width)
          SizedBox(
            width: 100,
            child: Text(
              '\$${(product['price'] ?? 0.0).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          // Stock (80px width)
          SizedBox(
            width: 80,
            child: Text(
              '${stockLevel}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          // Stock Level (150px width)
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Progress Bar
                Container(
                  width: 100,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: stockPercentage > 0
                      ? FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: stockPercentage,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: stockLevelColor,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 4),
                Text(
                  '${stockLevel}/${maxStock}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          // Status (100px width)
          SizedBox(
            width: 100,
            child: Switch(
              value: product['inStock'] ?? false,
              onChanged: (value) {
                onStockToggle(product, value);
              },
              activeColor: Colors.green,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),

          // Manage (170px width)
          SizedBox(
            width: 170,
            child: OutlinedButton.icon(
              onPressed: () {
                onProductTap(product);
              },
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Manage', style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                minimumSize: const Size(0, 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
