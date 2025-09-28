import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  final List<Map<String, dynamic>> sampleOrders = [
    {
      'id': '#1002',
      'date': '11 Feb, 2024',
      'customer': 'Wade Warren',
      'payment': 'Pending',
      'total': '\$20.00',
      'items': '2 items',
      'fulfillment': 'Unfulfilled',
      'paymentColor': const Color(0xFFFF9800),
      'fulfillmentColor': const Color(0xFFF44336),
    },
    {
      'id': '#1004',
      'date': '13 Feb, 2024',
      'customer': 'Esther Howard',
      'payment': 'Success',
      'total': '\$22.00',
      'items': '3 items',
      'fulfillment': 'Fulfilled',
      'paymentColor': const Color(0xFF4CAF50),
      'fulfillmentColor': const Color(0xFF4CAF50),
    },
    {
      'id': '#1007',
      'date': '15 Feb, 2024',
      'customer': 'Jenny Wilson',
      'payment': 'Pending',
      'total': '\$25.00',
      'items': '1 items',
      'fulfillment': 'Unfulfilled',
      'paymentColor': const Color(0xFFFF9800),
      'fulfillmentColor': const Color(0xFFF44336),
    },
    {
      'id': '#1009',
      'date': '17 Feb, 2024',
      'customer': 'Guy Hawkins',
      'payment': 'Success',
      'total': '\$27.00',
      'items': '5 items',
      'fulfillment': 'Fulfilled',
      'paymentColor': const Color(0xFF4CAF50),
      'fulfillmentColor': const Color(0xFF4CAF50),
    },
    {
      'id': '#1011',
      'date': '19 Feb, 2024',
      'customer': 'Jacob Jones',
      'payment': 'Pending',
      'total': '\$32.00',
      'items': '4 items',
      'fulfillment': 'Unfulfilled',
      'paymentColor': const Color(0xFFFF9800),
      'fulfillmentColor': const Color(0xFFF44336),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with date picker and actions
          _buildHeader(context),
          const SizedBox(height: 24),

          // Statistics Cards
          _buildStatisticsCards(context),
          const SizedBox(height: 24),

          // Filter Tabs
          _buildFilterTabs(context),
          const SizedBox(height: 16),

          // Orders List
          _buildOrdersList(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Date picker with flexible but constrained width
        Flexible(
          flex: 3,
          child: GestureDetector(
            onTap: () => _showDateRangePicker(context),
            child: Container(
              height: 44, // Same height as buttons
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _formatDateRange(selectedDateRange ?? defaultDateRange),
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Using SizedBox.square() to guarantee identical dimensions
        SizedBox.square(
          dimension: 44,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                // Export functionality
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.file_download_outlined,
                  size: 20,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Using SizedBox.square() to guarantee identical dimensions
        SizedBox.square(
          dimension: 44,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                // Create order functionality
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF5329C8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.add, size: 20, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsCards(BuildContext context) {
    final stats = [
      {
        'title': 'Total Orders',
        'value': '21',
        'change': '+25.2% last week',
        'isPositive': true,
      },
      {
        'title': 'Order items over time',
        'value': '15',
        'change': '+18.2% last week',
        'isPositive': true,
      },
      {
        'title': 'Returns Orders',
        'value': '0',
        'change': '-1.2% last week',
        'isPositive': false,
      },
      {
        'title': 'Fulfilled orders over time',
        'value': '12',
        'change': '+12.2% last week',
        'isPositive': true,
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

  Widget _buildFilterTabs(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filterTabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = selectedFilterIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilterIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF5329C8).withOpacity(0.1)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF5329C8)
                      : Theme.of(context).dividerColor,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tab,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? const Color(0xFF5329C8)
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context) {
    return Column(
      children: sampleOrders
          .map((order) => _buildOrderCard(context, order))
          .toList(),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Row
            Row(
              children: [
                Text(
                  order['id'],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  order['date'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Customer and Total Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order['customer'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order['total'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5329C8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Status Row
            Row(
              children: [
                // Payment Status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (order['paymentColor'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order['payment'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: order['paymentColor'] as Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Fulfillment Status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (order['fulfillmentColor'] as Color).withOpacity(
                      0.1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order['fulfillment'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: order['fulfillmentColor'] as Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),

                // Items count
                Text(
                  order['items'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
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
    }
  }

  String _formatDateRange(DateTimeRange dateRange) {
    final DateFormat formatter = DateFormat('MMM d');
    final String startDate = formatter.format(dateRange.start);
    final String endDate = formatter.format(dateRange.end);
    final String year = DateFormat('yyyy').format(dateRange.start);

    return '$startDate - $endDate, $year';
  }
}
