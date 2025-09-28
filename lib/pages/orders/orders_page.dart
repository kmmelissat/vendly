import 'package:flutter/material.dart';
import 'components/orders_header.dart';
import 'components/statistics_cards.dart';
import 'components/filter_tabs.dart';
import 'components/orders_list.dart';

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

  @override
  void initState() {
    super.initState();
    // Initialize with January 1-30, 2024
    defaultDateRange = DateTimeRange(
      start: DateTime(2024, 1, 1),
      end: DateTime(2024, 1, 30),
    );
    selectedDateRange = defaultDateRange;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
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

          // Statistics Cards
          const StatisticsCards(),
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
          const OrdersList(),
        ],
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
    }
  }
}
