import 'package:flutter/material.dart';
import 'banner_carousel.dart';
import '../../../services/auth_service.dart';
import '../../../services/analytics_service.dart';

class GreetingHeader extends StatefulWidget {
  const GreetingHeader({super.key});

  @override
  State<GreetingHeader> createState() => _GreetingHeaderState();
}

class _GreetingHeaderState extends State<GreetingHeader> {
  final AuthService _authService = AuthService();
  final AnalyticsService _analyticsService = AnalyticsService();
  String _storeName = 'Your Store';
  Map<String, dynamic>? _analyticsData;
  bool _isLoadingAnalytics = true;

  @override
  void initState() {
    super.initState();
    _loadStoreName();
    _loadAnalytics();
  }

  Future<void> _loadStoreName() async {
    try {
      final userData = await _authService.getUserData();
      if (userData != null && mounted) {
        final store = userData['store'] as Map<String, dynamic>?;
        setState(() {
          _storeName = store?['name'] ?? userData['username'] ?? 'Your Store';
        });
      }
    } catch (e) {
      // If there's an error, keep the default store name
      if (mounted) {
        setState(() {
          _storeName = 'Your Store';
        });
      }
    }
  }

  Future<void> _loadAnalytics() async {
    try {
      final analyticsData = await _analyticsService.getCurrentStoreAnalytics();
      if (mounted) {
        setState(() {
          _analyticsData = analyticsData;
          _isLoadingAnalytics = false;
        });
      }
    } catch (e) {
      // If there's an error, set loading to false and keep null data
      if (mounted) {
        setState(() {
          _analyticsData = null;
          _isLoadingAnalytics = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get current time for greeting
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Greeting
        Text(
          '$greeting, $_storeName',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Here\'s what\'s happening with your store',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 24),

        // Banner Carousel
        const BannerCarousel(),
        const SizedBox(height: 24),

        // Business Metrics Cards
        _buildMetricsCards(context),
      ],
    );
  }

  Widget _buildMetricsCards(BuildContext context) {
    // Use real analytics data if available, otherwise use fallback values
    final totalRevenue = _analyticsData?['total_revenue'];
    final totalIncome = _analyticsData?['total_income'];
    final totalOrders = _analyticsData?['total_orders'];
    final avgOrderValue = _analyticsData?['average_order_value'];

    final metrics = [
      {
        'title': 'Total Revenue',
        'value': totalRevenue != null
            ? '\$${totalRevenue['value']?.toStringAsFixed(2) ?? '0.00'}'
            : '\$0.00',
        'change': totalRevenue != null
            ? '${totalRevenue['change_percent']?.toStringAsFixed(1) ?? '0.0'}% vs last week'
            : '0.0% vs last week',
        'isPositive': totalRevenue?['change_percent'] != null
            ? totalRevenue['change_percent'] >= 0
            : true,
      },
      {
        'title': 'Total Income',
        'value': totalIncome != null
            ? '\$${totalIncome['value']?.toStringAsFixed(2) ?? '0.00'}'
            : '\$0.00',
        'change': totalIncome != null
            ? '${totalIncome['change_percent']?.toStringAsFixed(1) ?? '0.0'}% vs last week'
            : '0.0% vs last week',
        'isPositive': totalIncome?['change_percent'] != null
            ? totalIncome['change_percent'] >= 0
            : true,
      },
      {
        'title': 'Total Orders',
        'value': totalOrders != null
            ? '${totalOrders['value']?.toString() ?? '0'}'
            : '0',
        'change': totalOrders != null
            ? '${totalOrders['change_percent']?.toStringAsFixed(1) ?? '0.0'}% vs last week'
            : '0.0% vs last week',
        'isPositive': totalOrders?['change_percent'] != null
            ? totalOrders['change_percent'] >= 0
            : true,
      },
      {
        'title': 'Avg. Order Value',
        'value': avgOrderValue != null
            ? '\$${avgOrderValue['value']?.toStringAsFixed(2) ?? '0.00'}'
            : '\$0.00',
        'change': avgOrderValue != null
            ? '${avgOrderValue['change_percent']?.toStringAsFixed(1) ?? '0.0'}% vs last week'
            : '0.0% vs last week',
        'isPositive': avgOrderValue?['change_percent'] != null
            ? avgOrderValue['change_percent'] >= 0
            : true,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];

        // Show loading state if analytics are still loading
        if (_isLoadingAnalytics) {
          return _buildLoadingMetricCard(context);
        }
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: const Color(0xFF5329C8).withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF5329C8).withOpacity(0.02),
                  Colors.transparent,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title and info icon
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          metric['title'] as String,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: const Color(0xFF5329C8).withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.more_vert,
                        size: 16,
                        color: const Color(0xFF5329C8).withOpacity(0.6),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Value
                  Text(
                    metric['value'] as String,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5329C8),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Change indicator
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 12,
                        color: const Color(0xFF4CAF50),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          metric['change'] as String,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: const Color(0xFF4CAF50),
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingMetricCard(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: const Color(0xFF5329C8).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF5329C8).withOpacity(0.02),
              Colors.transparent,
            ],
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Loading shimmer for title
              SizedBox(
                width: 80,
                height: 14,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
              ),
              SizedBox(height: 8),
              // Loading shimmer for value
              SizedBox(
                width: 60,
                height: 20,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
              ),
              SizedBox(height: 4),
              // Loading shimmer for change
              SizedBox(
                width: 100,
                height: 12,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
