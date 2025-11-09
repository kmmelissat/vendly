import 'package:flutter/material.dart';
import 'components/orders_header.dart';
import 'components/statistics_cards.dart';
import 'components/filter_tabs.dart';
import 'components/orders_list.dart';
import '../../services/orders_service.dart';
import '../../services/auth_service.dart';
import '../../services/logger_service.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int selectedFilterIndex = 0;
  final List<String> filterTabs = [
    'All',
    'Unfulfilled',
    'Unpaid',
    'Open',
    'Closed',
  ];

  // Date range state
  DateTimeRange? selectedDateRange;
  late DateTimeRange defaultDateRange;

  // Services
  late OrdersService _ordersService;
  late AuthService _authService;

  // Analytics data
  Map<String, dynamic>? _analyticsData;
  bool _isLoadingAnalytics = false;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    // Initialize services
    _authService = AuthService();
    _ordersService = OrdersService(authService: _authService);

    // Initialize with current week
    final now = DateTime.now();
    defaultDateRange = DateTimeRange(
      start: now.subtract(const Duration(days: 7)),
      end: now,
    );
    selectedDateRange = defaultDateRange;

    // Load initial data
    _loadUserDataAndFetchAnalytics();
  }

  Future<void> _loadUserDataAndFetchAnalytics() async {
    try {
      // Get user data to extract store ID
      final userData = await _authService.getUserData();
      if (userData != null && userData['store'] != null) {
        final store = userData['store'] as Map<String, dynamic>;
        _storeId = store['id']?.toString();
        
        if (_storeId != null) {
          LoggerService.info('Store ID loaded: $_storeId');
          await _fetchAnalytics();
        } else {
          LoggerService.warning('Store ID not found in user data');
        }
      } else {
        LoggerService.warning('User data or store not found');
      }
    } catch (e, stackTrace) {
      LoggerService.error(
        'Error loading user data',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _fetchAnalytics() async {
    if (_storeId == null) return;

    setState(() {
      _isLoadingAnalytics = true;
    });

    try {
      LoggerService.info('Fetching analytics for store: $_storeId');
      final data = await _ordersService.getOrdersAnalyticsSummary(
        storeId: _storeId!,
        period: 'week', // You can make this dynamic based on date range
      );

      if (mounted) {
        setState(() {
          _analyticsData = data;
          _isLoadingAnalytics = false;
        });
        
        if (data != null) {
          LoggerService.info('Analytics data loaded successfully');
        } else {
          LoggerService.warning('No analytics data returned');
        }
      }
    } catch (e, stackTrace) {
      LoggerService.error(
        'Error fetching analytics',
        error: e,
        stackTrace: stackTrace,
      );
      if (mounted) {
        setState(() {
          _isLoadingAnalytics = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _fetchAnalytics,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date picker and actions
            OrdersHeader(
              selectedDateRange: selectedDateRange,
              defaultDateRange: defaultDateRange,
              onDatePickerTap: () => _showDateRangePicker(context),
            ),
            const SizedBox(height: 24),

            // Statistics Cards with real data
            StatisticsCards(
              analyticsData: _analyticsData,
              isLoading: _isLoadingAnalytics,
            ),
            const SizedBox(height: 24),

            // Filter Tabs
            FilterTabs(
              selectedFilterIndex: selectedFilterIndex,
              filterTabs: filterTabs,
              onFilterChanged: (index) {
                setState(() {
                  selectedFilterIndex = index;
                });
              },
            ),
            const SizedBox(height: 16),

            // Orders List
            OrdersList(
              selectedFilter: filterTabs[selectedFilterIndex],
              selectedDateRange: selectedDateRange,
            ),
          ],
        ),
      ),
    );
  }

  // Date picker functionality
  Future<void> _showDateRangePicker(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: selectedDateRange ?? defaultDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: const Color(0xFF5329C8)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
      });
      // Refresh analytics when date range changes
      await _fetchAnalytics();
    }
  }
}
