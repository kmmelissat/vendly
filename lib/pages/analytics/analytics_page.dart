import 'package:flutter/material.dart';
import '../../models/analytics_dashboard.dart';
import '../../services/analytics_service.dart';
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
  final AnalyticsService _analyticsService = AnalyticsService();
  AnalyticsDashboard? _dashboardData;
  bool _isLoading = true;
  String? _errorMessage;

  String selectedPeriod = 'month';
  final Map<String, String> periods = {
    'week': 'Last 7 Days',
    'month': 'Last 30 Days',
    'quarter': 'Last 3 Months',
    'semester': 'Last 6 Months',
    'year': 'This Year',
  };

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _analyticsService.getCurrentStoreDashboard(
        period: selectedPeriod,
      );

      setState(() {
        _dashboardData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load analytics data';
        _isLoading = false;
      });
    }
  }

  void _onPeriodChanged(String? newPeriod) {
    if (newPeriod != null && newPeriod != selectedPeriod) {
      setState(() {
        selectedPeriod = newPeriod;
      });
      _loadDashboardData();
    }
  }

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
                      items: periods.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(
                            entry.value,
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                      onChanged: _onPeriodChanged,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadDashboardData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _dashboardData == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.analytics_outlined,
                          size: 64,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No analytics data available',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadDashboardData,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // Analytics Overview
                          AnalyticsOverview(
                            revenue: _dashboardData!.revenue,
                            orders: _dashboardData!.orders,
                            averageOrderValue:
                                _dashboardData!.averageOrderValue,
                            conversion: _dashboardData!.conversion,
                            income: _dashboardData!.income,
                            itemsSold: _dashboardData!.itemsSold,
                          ),

                          const SizedBox(height: 24),

                          // Sales Performance - Using mock data since API doesn't provide time series yet
                          SalesPerformance(
                            dailySales: [
                              {
                                'date': DateTime.now()
                                    .subtract(const Duration(days: 6))
                                    .toIso8601String(),
                                'sales':
                                    _dashboardData!.revenue.totalRevenue * 0.12,
                                'orders':
                                    (_dashboardData!.orders.totalOrders * 0.12)
                                        .toInt(),
                              },
                              {
                                'date': DateTime.now()
                                    .subtract(const Duration(days: 5))
                                    .toIso8601String(),
                                'sales':
                                    _dashboardData!.revenue.totalRevenue * 0.15,
                                'orders':
                                    (_dashboardData!.orders.totalOrders * 0.15)
                                        .toInt(),
                              },
                              {
                                'date': DateTime.now()
                                    .subtract(const Duration(days: 4))
                                    .toIso8601String(),
                                'sales':
                                    _dashboardData!.revenue.totalRevenue * 0.18,
                                'orders':
                                    (_dashboardData!.orders.totalOrders * 0.18)
                                        .toInt(),
                              },
                              {
                                'date': DateTime.now()
                                    .subtract(const Duration(days: 3))
                                    .toIso8601String(),
                                'sales':
                                    _dashboardData!.revenue.totalRevenue * 0.14,
                                'orders':
                                    (_dashboardData!.orders.totalOrders * 0.14)
                                        .toInt(),
                              },
                              {
                                'date': DateTime.now()
                                    .subtract(const Duration(days: 2))
                                    .toIso8601String(),
                                'sales':
                                    _dashboardData!.revenue.totalRevenue * 0.16,
                                'orders':
                                    (_dashboardData!.orders.totalOrders * 0.16)
                                        .toInt(),
                              },
                              {
                                'date': DateTime.now()
                                    .subtract(const Duration(days: 1))
                                    .toIso8601String(),
                                'sales':
                                    _dashboardData!.revenue.totalRevenue * 0.13,
                                'orders':
                                    (_dashboardData!.orders.totalOrders * 0.13)
                                        .toInt(),
                              },
                              {
                                'date': DateTime.now().toIso8601String(),
                                'sales':
                                    _dashboardData!.revenue.totalRevenue * 0.12,
                                'orders':
                                    (_dashboardData!.orders.totalOrders * 0.12)
                                        .toInt(),
                              },
                            ],
                            selectedPeriod:
                                periods[selectedPeriod] ?? 'Last 30 Days',
                          ),

                          const SizedBox(height: 24),

                          // Customer Insights - Using mock data for now
                          CustomerInsights(
                            customerDemographics: const {
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
                            retentionRate: 68.5,
                          ),

                          const SizedBox(height: 24),

                          // Product Analytics - Using mock data for now
                          ProductAnalytics(
                            topProducts: const [
                              {
                                'name': 'Labubu Classic Pink',
                                'sales': 156,
                                'revenue': 3900.00,
                              },
                              {
                                'name': 'Sonny Angel Series',
                                'sales': 134,
                                'revenue': 2680.00,
                              },
                              {
                                'name': 'Ternuritos Plush',
                                'sales': 98,
                                'revenue': 2156.00,
                              },
                              {
                                'name': 'Wild Cutie Collection',
                                'sales': 87,
                                'revenue': 1914.00,
                              },
                              {
                                'name': 'Gummy Bear Plush',
                                'sales': 76,
                                'revenue': 1520.00,
                              },
                            ],
                            salesByCategory: const {
                              'Labubu': {'sales': 245, 'percentage': 35.2},
                              'Plush': {'sales': 189, 'percentage': 27.1},
                              'Sonny Angel': {'sales': 156, 'percentage': 22.4},
                              'Ternuritos': {'sales': 98, 'percentage': 14.1},
                              'Others': {'sales': 8, 'percentage': 1.2},
                            },
                          ),

                          const SizedBox(height: 24),

                          // Growth Metrics
                          GrowthMetrics(
                            growthData: {
                              'monthlyGrowth':
                                  _dashboardData!.revenue.profitMarginPercent,
                              'customerGrowth': _dashboardData!
                                  .conversion
                                  .customerConversionRatePercent,
                              'averageOrderGrowth': _dashboardData!
                                  .averageOrderValue
                                  .averageOrderValue,
                              'retentionImprovement': _dashboardData!
                                  .fulfilledOrders
                                  .fulfillmentRatePercent,
                            },
                            inventoryInsights: {
                              'lowStockItems': _dashboardData!
                                  .returnedOrders
                                  .returnedOrdersCount,
                              'outOfStockItems':
                                  _dashboardData!.conversion.inProgressOrders,
                              'fastMovingItems':
                                  _dashboardData!.itemsSold.totalItemsSold,
                              'slowMovingItems':
                                  _dashboardData!.returnedOrders.totalOrders -
                                  _dashboardData!
                                      .fulfilledOrders
                                      .fulfilledOrdersCount,
                            },
                          ),

                          const SizedBox(
                            height: 100,
                          ), // Bottom padding for navigation
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
