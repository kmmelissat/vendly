import 'package:flutter/material.dart';

class AnalyticsOverview extends StatelessWidget {
  final double totalRevenue;
  final int totalOrders;
  final double averageOrderValue;
  final double conversionRate;

  const AnalyticsOverview({
    super.key,
    required this.totalRevenue,
    required this.totalOrders,
    required this.averageOrderValue,
    required this.conversionRate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Overview',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildMetricCard(
              context,
              'Total Revenue',
              '\$${totalRevenue.toStringAsFixed(2)}',
              Icons.attach_money,
              Colors.green,
              '+15.2% vs last period',
            ),
            _buildMetricCard(
              context,
              'Total Orders',
              totalOrders.toString(),
              Icons.shopping_cart,
              Colors.blue,
              '+8.7% vs last period',
            ),
            _buildMetricCard(
              context,
              'Avg Order Value',
              '\$${averageOrderValue.toStringAsFixed(2)}',
              Icons.trending_up,
              Colors.orange,
              '+6.1% vs last period',
            ),
            _buildMetricCard(
              context,
              'Conversion Rate',
              '${conversionRate.toStringAsFixed(1)}%',
              Icons.analytics,
              Colors.purple,
              '+0.8% vs last period',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Icon(Icons.trending_up, color: Colors.green, size: 16),
            ],
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              change,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.green,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
