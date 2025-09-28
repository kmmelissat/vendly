import 'package:flutter/material.dart';

class TopProducts extends StatelessWidget {
  const TopProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final topProducts = [
      {
        'name': 'Labubu Big Into Energy Blind Box',
        'sales': 20,
        'revenue': '\$400',
        'image': 'assets/images/products/labubu1.jpg',
        'trend': 'up',
        'trendValue': '+12%',
      },
      {
        'name': 'Labubu Have a Seat Special Edition',
        'sales': 16,
        'revenue': '\$320',
        'image': 'assets/images/products/labubu2.jpg',
        'trend': 'up',
        'trendValue': '+8%',
      },
      {
        'name': 'Labubu The Monsters Special Edition',
        'sales': 20,
        'revenue': '\$312',
        'image': 'assets/images/products/labubu3.jpg',
        'trend': 'down',
        'trendValue': '-3%',
      },
      {
        'name': 'Powerpuff Girls Series Blind Box',
        'sales': 26,
        'revenue': '\$220',
        'image': 'assets/images/products/plush1.jpg',
        'trend': 'up',
        'trendValue': '+15%',
      },
      {
        'name': 'Sonny Angel I LOVE RAINY DAY Edition',
        'sales': 20,
        'revenue': '\$200',
        'image': 'assets/images/products/sonnyangel1.jpg',
        'trend': 'up',
        'trendValue': '+5%',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top Products',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // Navigate to full products page
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: const Color(0xFF5329C8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Products List
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: topProducts.asMap().entries.map((entry) {
              final index = entry.key;
              final product = entry.value;
              final isLast = index == topProducts.length - 1;

              return _buildProductItem(context, product, index + 1, isLast);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(
    BuildContext context,
    Map<String, dynamic> product,
    int rank,
    bool isLast,
  ) {
    final isUp = product['trend'] == 'up';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? const Color(0xFF5329C8).withOpacity(0.1)
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: rank > 3
                  ? Border.all(color: Theme.of(context).dividerColor, width: 1)
                  : null,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: rank <= 3
                      ? const Color(0xFF5329C8)
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Product Image
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                product['image'],
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to labubu.png if product image fails
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/labubu.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Final fallback to icon if all images fail
                        return Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.shopping_bag,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  '${product['sales']} sales',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          // Revenue and Trend
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                product['revenue'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5329C8),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isUp
                      ? const Color(0xFF4CAF50).withOpacity(0.1)
                      : const Color(0xFFF44336).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isUp ? Icons.trending_up : Icons.trending_down,
                      size: 12,
                      color: isUp
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFF44336),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      product['trendValue'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isUp
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFF44336),
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
