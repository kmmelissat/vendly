import 'package:flutter/material.dart';

class StatisticsCards extends StatelessWidget {
  final Map<String, dynamic>? analyticsData;
  final bool isLoading;

  const StatisticsCards({
    super.key,
    this.analyticsData,
    this.isLoading = false,
  });

  String _formatCurrency(dynamic value) {
    if (value == null) return '0.00';
    final numValue = value is num ? value : double.tryParse(value.toString()) ?? 0;
    return numValue.toStringAsFixed(2);
  }

  String _formatChange(dynamic changePercent) {
    if (changePercent == null || changePercent == 0) return 'No change';
    final numValue = changePercent is num 
        ? changePercent 
        : double.tryParse(changePercent.toString()) ?? 0;
    final sign = numValue >= 0 ? '+' : '';
    return '$sign${numValue.toStringAsFixed(1)}% vs last period';
  }

  @override
  Widget build(BuildContext context) {
    // Extract data from API response or use defaults
    final totalOrders = analyticsData?['total_orders'] ?? {};
    final totalRevenue = analyticsData?['total_revenue'] ?? {};
    final totalIncome = analyticsData?['total_income'] ?? {};
    final avgOrderValue = analyticsData?['average_order_value'] ?? {};

    final stats = [
      {
        'title': 'Total Orders',
        'value': isLoading ? '...' : '${totalOrders['value'] ?? 0}',
        'change': _formatChange(totalOrders['change_percent']),
        'isPositive': (totalOrders['change_percent'] ?? 0) >= 0,
      },
      {
        'title': 'Total Revenue',
        'value': isLoading 
            ? '...' 
            : '\$${_formatCurrency(totalRevenue['value'] ?? 0)}',
        'change': _formatChange(totalRevenue['change_percent']),
        'isPositive': (totalRevenue['change_percent'] ?? 0) >= 0,
      },
      {
        'title': 'Total Income',
        'value': isLoading 
            ? '...' 
            : '\$${_formatCurrency(totalIncome['value'] ?? 0)}',
        'change': _formatChange(totalIncome['change_percent']),
        'isPositive': (totalIncome['change_percent'] ?? 0) >= 0,
      },
      {
        'title': 'Avg Order Value',
        'value': isLoading 
            ? '...' 
            : '\$${_formatCurrency(avgOrderValue['value'] ?? 0)}',
        'change': _formatChange(avgOrderValue['change_percent']),
        'isPositive': (avgOrderValue['change_percent'] ?? 0) >= 0,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat['title'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        stat['value'] as String,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '–',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.3),
                          ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      (stat['isPositive'] as bool)
                          ? Icons.trending_up
                          : Icons.trending_down,
                      size: 12,
                      color: (stat['isPositive'] as bool)
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFF44336),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        stat['change'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: (stat['isPositive'] as bool)
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFF44336),
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
