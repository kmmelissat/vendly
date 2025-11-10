import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/orders_header.dart';
import 'components/statistics_cards.dart';
import 'components/filter_tabs.dart';
import 'components/orders_list.dart';
import '../../services/orders_service.dart';
import '../../services/auth_service.dart';
import '../../services/logger_service.dart';
import 'orders_bloc.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
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
          // Load orders using BLoC
          if (mounted) {
            context.read<OrdersBloc>().add(
              LoadOrders(storeId: int.parse(_storeId!)),
            );
          }
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
      onRefresh: () async {
        await _fetchAnalytics();
        if (_storeId != null && mounted) {
          context.read<OrdersBloc>().add(
            RefreshOrders(storeId: int.parse(_storeId!)),
          );
        }
      },
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

            // Filter Tabs with BLoC
            BlocBuilder<OrdersBloc, OrdersState>(
              builder: (context, state) {
                int selectedIndex = 0;
                if (state is OrdersLoaded && state.statusFilter != null) {
                  selectedIndex = filterTabs.indexWhere(
                    (tab) => tab.toLowerCase() == state.statusFilter!.toLowerCase(),
                  );
                  if (selectedIndex == -1) selectedIndex = 0;
                }

                return FilterTabs(
                  selectedFilterIndex: selectedIndex,
                  filterTabs: filterTabs,
                  onFilterChanged: (index) {
                    final filter = index == 0 ? null : filterTabs[index];
                    context.read<OrdersBloc>().add(
                      FilterOrdersByStatus(status: filter),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            // Orders List with BLoC
            BlocConsumer<OrdersBloc, OrdersState>(
              listener: (context, state) {
                if (state is OrderStatusUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order status updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is OrderCreated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order created successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is OrderDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Order deleted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is OrdersLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state is OrdersError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load orders',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (_storeId != null) {
                                context.read<OrdersBloc>().add(
                                  LoadOrders(storeId: int.parse(_storeId!)),
                                );
                              }
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Use the existing OrdersList component
                // It will need to be updated to accept orders from BLoC
                return OrdersList(
                  selectedFilter: filterTabs[0], // Will be handled by BLoC
                  selectedDateRange: selectedDateRange,
                );
              },
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
