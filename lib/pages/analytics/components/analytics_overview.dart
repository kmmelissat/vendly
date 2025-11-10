import 'package:flutter/material.dart';
import '../../../models/analytics_dashboard.dart';

class AnalyticsOverview extends StatelessWidget {
  final RevenueData revenue;
  final OrdersData orders;
  final AverageOrderValueData averageOrderValue;
  final ConversionData conversion;
  final IncomeData income;
  final ItemsSoldData itemsSold;

  const AnalyticsOverview({
    super.key,
    required this.revenue,
    required this.orders,
    required this.averageOrderValue,
    required this.conversion,
    required this.income,
    required this.itemsSold,
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
              '\$${revenue.totalRevenue.toStringAsFixed(2)}',
              Icons.attach_money,
              Colors.green,
              'Profit: ${revenue.profitMarginPercent.toStringAsFixed(1)}%',
            ),
            _buildMetricCard(
              context,
              'Total Orders',
              orders.totalOrders.toString(),
              Icons.shopping_cart,
              Colors.blue,
              '${orders.statusBreakdown.length} statuses',
            ),
            _buildMetricCard(
              context,
              'Avg Order Value',
              '\$${averageOrderValue.averageOrderValue.toStringAsFixed(2)}',
              Icons.trending_up,
              Colors.orange,
              '${averageOrderValue.totalOrders} orders',
            ),
            _buildMetricCard(
              context,
              'Conversion Rate',
              '${conversion.conversionRatePercent.toStringAsFixed(1)}%',
              Icons.analytics,
              Colors.purple,
              '${conversion.convertedOrders}/${conversion.totalOrders} converted',
            ),
            _buildMetricCard(
              context,
              'Income',
              '\$${income.totalIncome.toStringAsFixed(2)}',
              Icons.account_balance_wallet,
              Colors.teal,
              income.currency,
            ),
            _buildMetricCard(
              context,
              'Items Sold',
              itemsSold.totalItemsSold.toString(),
              Icons.inventory_2,
              Colors.indigo,
              '${itemsSold.topProducts.length} top products',
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
    String subtitle,
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
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
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
