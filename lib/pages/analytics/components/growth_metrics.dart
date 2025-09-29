import 'package:flutter/material.dart';

class GrowthMetrics extends StatelessWidget {
  final Map<String, dynamic> growthData;
  final Map<String, dynamic> inventoryInsights;

  const GrowthMetrics({
    super.key,
    required this.growthData,
    required this.inventoryInsights,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Growth Metrics
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Growth Metrics',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildGrowthCard(
                    context,
                    'Monthly Growth',
                    '${growthData['monthlyGrowth'].toStringAsFixed(1)}%',
                    Icons.trending_up,
                    Colors.green,
                  ),
                  _buildGrowthCard(
                    context,
                    'Customer Growth',
                    '${growthData['customerGrowth'].toStringAsFixed(1)}%',
                    Icons.people,
                    Colors.blue,
                  ),
                  _buildGrowthCard(
                    context,
                    'AOV Growth',
                    '${growthData['averageOrderGrowth'].toStringAsFixed(1)}%',
                    Icons.attach_money,
                    Colors.orange,
                  ),
                  _buildGrowthCard(
                    context,
                    'Retention Improvement',
                    '${growthData['retentionImprovement'].toStringAsFixed(1)}%',
                    Icons.favorite,
                    Colors.purple,
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Inventory Insights
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inventory Insights',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildInventoryCard(
                      context,
                      'Low Stock',
                      inventoryInsights['lowStockItems'].toString(),
                      Icons.warning,
                      Colors.orange,
                      'items need restocking',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInventoryCard(
                      context,
                      'Out of Stock',
                      inventoryInsights['outOfStockItems'].toString(),
                      Icons.error,
                      Colors.red,
                      'items unavailable',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildInventoryCard(
                      context,
                      'Fast Moving',
                      inventoryInsights['fastMovingItems'].toString(),
                      Icons.flash_on,
                      Colors.green,
                      'high demand items',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInventoryCard(
                      context,
                      'Slow Moving',
                      inventoryInsights['slowMovingItems'].toString(),
                      Icons.schedule,
                      Colors.grey,
                      'need promotion',
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

  Widget _buildGrowthCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
