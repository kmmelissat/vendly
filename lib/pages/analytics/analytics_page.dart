import 'package:flutter/material.dart';
import 'components/analytics_overview.dart';
import 'components/sales_performance.dart';
import 'components/customer_insights.dart';
import 'components/product_analytics.dart';
import 'components/growth_metrics.dart';
import 'package:vendly/services/analytics_service.dart';

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

  final analyticsService = AnalyticsService();
  Map<String, dynamic>? analyticsData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() => isLoading = true);

    // 🔹 Usa un método interno del servicio para obtener el storeId sin exponerlo
    final revenueData = await analyticsService.getRevenueForCurrentStore(period: 'month');
    final summaryData = await analyticsService.getCurrentStoreAnalytics(period: 'month');

    final combinedData = {
      ...?summaryData,
      'totalRevenue': revenueData?['total_revenue'] ?? 0,
      'totalIncome': revenueData?['total_income'] ?? 0,
      'totalCosts': revenueData?['total_costs'] ?? 0,
      'profitMarginPercent': revenueData?['profit_margin_percent'] ?? 0,
    };

    setState(() {
      analyticsData = combinedData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (analyticsData == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'No se pudo cargar la información de analíticas.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Analytics',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                      style: const TextStyle(fontSize: 12),
                      items: periods.map((period) {
                        return DropdownMenuItem(
                          value: period,
                          child: Text(period, style: const TextStyle(fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedPeriod = value);
                          _loadAnalytics();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  AnalyticsOverview(
                    totalRevenue: analyticsData!['totalRevenue'] ?? 0,
                    totalOrders: analyticsData!['totalOrders'] ?? 0,
                    averageOrderValue: analyticsData!['averageOrderValue'] ?? 0,
                    conversionRate: analyticsData!['conversionRate'] ?? 0,
                  ),
                  const SizedBox(height: 24),
                  SalesPerformance(
                    dailySales: List<Map<String, dynamic>>.from(
                      analyticsData!['dailySales'] ?? [],
                    ),
                    selectedPeriod: selectedPeriod,
                  ),
                  const SizedBox(height: 24),
                  CustomerInsights(
                    customerDemographics:
                        Map<String, dynamic>.from(analyticsData!['customerDemographics'] ?? {}),
                    retentionRate: analyticsData!['customerRetentionRate'] ?? 0,
                  ),
                  const SizedBox(height: 24),
                  ProductAnalytics(
                    topProducts: List<Map<String, dynamic>>.from(
                      analyticsData!['topSellingProducts'] ?? [],
                    ),
                    salesByCategory: Map<String, dynamic>.from(
                      analyticsData!['salesByCategory'] ?? {},
                    ),
                  ),
                  const SizedBox(height: 24),
                  GrowthMetrics(
                    growthData: Map<String, dynamic>.from(
                      analyticsData!['growthMetrics'] ?? {},
                    ),
                    inventoryInsights: Map<String, dynamic>.from(
                      analyticsData!['inventoryInsights'] ?? {},
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
