import 'package:flutter/material.dart';

class CustomersStats extends StatelessWidget {
  final List<Map<String, dynamic>> customers;

  const CustomersStats({super.key, required this.customers});

  @override
  Widget build(BuildContext context) {
    final stats = _calculateStats();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Overview',
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
            _buildStatCard(
              context,
              'Total Customers',
              stats['totalCustomers'].toString(),
              Icons.people,
              Colors.blue,
              '+${stats['newThisMonth']} this month',
            ),
            _buildStatCard(
              context,
              'VIP Customers',
              stats['vipCustomers'].toString(),
              Icons.star,
              Colors.purple,
              '${((stats['vipCustomers'] / stats['totalCustomers']) * 100).toStringAsFixed(1)}% of total',
            ),
            _buildStatCard(
              context,
              'Average Orders',
              stats['avgOrders'].toStringAsFixed(1),
              Icons.shopping_cart,
              Colors.orange,
              'per customer',
            ),
            _buildStatCard(
              context,
              'Total Revenue',
              '\$${stats['totalRevenue'].toStringAsFixed(2)}',
              Icons.attach_money,
              Colors.green,
              'from all customers',
            ),
          ],
        ),
      ],
    );
  }

  Map<String, dynamic> _calculateStats() {
    final totalCustomers = customers.length;
    final vipCustomers = customers.where((c) => c['status'] == 'VIP').length;
    final newCustomers = customers.where((c) {
      final joinDate = DateTime.parse(c['joinDate']);
      final now = DateTime.now();
      final thisMonth = DateTime(now.year, now.month, 1);
      return joinDate.isAfter(thisMonth);
    }).length;

    final totalOrders = customers.fold<int>(
      0,
      (sum, c) => sum + (c['totalOrders'] as int),
    );
    final totalRevenue = customers.fold<double>(
      0,
      (sum, c) => sum + (c['totalSpent'] as double),
    );
    final avgOrders = totalCustomers > 0 ? totalOrders / totalCustomers : 0.0;

    return {
      'totalCustomers': totalCustomers,
      'vipCustomers': vipCustomers,
      'newThisMonth': newCustomers,
      'avgOrders': avgOrders,
      'totalRevenue': totalRevenue,
    };
  }

  Widget _buildStatCard(
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
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
