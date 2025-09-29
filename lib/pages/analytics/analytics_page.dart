import 'package:flutter/material.dart';
import 'components/analytics_overview.dart';
import 'components/sales_performance.dart';
import 'components/customer_insights.dart';
import 'components/product_analytics.dart';
import 'components/growth_metrics.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  String selectedPeriod = 'Last 30 Days';
  final List<String> periods = [
    'Last 7 Days',
    'Last 30 Days',
    'Last 3 Months',
    'Last 6 Months',
    'This Year',
  ];

  // Sample analytics data
  final Map<String, dynamic> analyticsData = {
    'totalRevenue': 45280.75,
    'totalOrders': 892,
    'averageOrderValue': 50.76,
    'conversionRate': 3.2,
    'customerRetentionRate': 68.5,
    'topSellingProducts': [
      {'name': 'Labubu Classic Pink', 'sales': 156, 'revenue': 3900.00},
      {'name': 'Sonny Angel Series', 'sales': 134, 'revenue': 2680.00},
      {'name': 'Ternuritos Plush', 'sales': 98, 'revenue': 2156.00},
      {'name': 'Wild Cutie Collection', 'sales': 87, 'revenue': 1914.00},
      {'name': 'Gummy Bear Plush', 'sales': 76, 'revenue': 1520.00},
    ],
    'salesByCategory': {
      'Labubu': {'sales': 245, 'percentage': 35.2},
      'Plush': {'sales': 189, 'percentage': 27.1},
      'Sonny Angel': {'sales': 156, 'percentage': 22.4},
      'Ternuritos': {'sales': 98, 'percentage': 14.1},
      'Others': {'sales': 8, 'percentage': 1.2},
    },
    'dailySales': [
      {'date': '2024-01-01', 'sales': 1250.00, 'orders': 28},
      {'date': '2024-01-02', 'sales': 1890.50, 'orders': 35},
      {'date': '2024-01-03', 'sales': 2100.25, 'orders': 42},
      {'date': '2024-01-04', 'sales': 1750.00, 'orders': 31},
      {'date': '2024-01-05', 'sales': 2350.75, 'orders': 48},
      {'date': '2024-01-06', 'sales': 1980.00, 'orders': 39},
      {'date': '2024-01-07', 'sales': 2200.50, 'orders': 44},
    ],
    'customerDemographics': {
      'ageGroups': {
        '18-24': 28.5,
        '25-34': 42.3,
        '35-44': 18.7,
        '45-54': 8.2,
        '55+': 2.3,
      },
      'locations': {
        'San Salvador': 45.2,
        'Santa Ana': 18.7,
        'San Miguel': 12.4,
        'La Libertad': 10.8,
        'Others': 12.9,
      },
    },
    'growthMetrics': {
      'monthlyGrowth': 12.5,
      'customerGrowth': 8.3,
      'averageOrderGrowth': 4.2,
      'retentionImprovement': 2.1,
    },
    'inventoryInsights': {
      'lowStockItems': 12,
      'outOfStockItems': 3,
      'fastMovingItems': 8,
      'slowMovingItems': 15,
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Simple Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Analytics',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                // Period Selector
                Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withOpacity(0.3),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedPeriod,
                      isDense: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      style: const TextStyle(fontSize: 12),
                      items: periods.map((period) {
                        return DropdownMenuItem(
                          value: period,
                          child: Text(
                            period,
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedPeriod = value;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  // Analytics Overview
                  AnalyticsOverview(
                    totalRevenue: analyticsData['totalRevenue'],
                    totalOrders: analyticsData['totalOrders'],
                    averageOrderValue: analyticsData['averageOrderValue'],
                    conversionRate: analyticsData['conversionRate'],
                  ),

                  const SizedBox(height: 24),

                  // Sales Performance
                  SalesPerformance(
                    dailySales: List<Map<String, dynamic>>.from(
                      analyticsData['dailySales'],
                    ),
                    selectedPeriod: selectedPeriod,
                  ),

                  const SizedBox(height: 24),

                  // Customer Insights
                  CustomerInsights(
                    customerDemographics: Map<String, dynamic>.from(
                      analyticsData['customerDemographics'],
                    ),
                    retentionRate: analyticsData['customerRetentionRate'],
                  ),

                  const SizedBox(height: 24),

                  // Product Analytics
                  ProductAnalytics(
                    topProducts: List<Map<String, dynamic>>.from(
                      analyticsData['topSellingProducts'],
                    ),
                    salesByCategory: Map<String, dynamic>.from(
                      analyticsData['salesByCategory'],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Growth Metrics
                  GrowthMetrics(
                    growthData: Map<String, dynamic>.from(
                      analyticsData['growthMetrics'],
                    ),
                    inventoryInsights: Map<String, dynamic>.from(
                      analyticsData['inventoryInsights'],
                    ),
                  ),

                  const SizedBox(height: 100), // Bottom padding for navigation
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
