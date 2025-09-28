import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrdersList extends StatelessWidget {
  final String selectedFilter;
  final DateTimeRange? selectedDateRange;

  const OrdersList({
    super.key,
    required this.selectedFilter,
    this.selectedDateRange,
  });

  @override
  Widget build(BuildContext context) {
    final sampleOrders = [
      {
        'id': '#1002',
        'date': '11 Feb, 2024',
        'customer': 'Carlos Hernández',
        'payment': 'Pending',
        'total': '\$20.00',
        'items': '2 items',
        'fulfillment': 'Unfulfilled',
        'status': 'Open', // Order status for filtering
        'paymentColor': const Color(0xFFFF9800),
        'fulfillmentColor': const Color(0xFFF44336),
      },
      {
        'id': '#1004',
        'date': '13 Feb, 2024',
        'customer': 'María Elena Rodríguez',
        'payment': 'Success',
        'total': '\$22.00',
        'items': '3 items',
        'fulfillment': 'Fulfilled',
        'status': 'Closed', // Order status for filtering
        'paymentColor': const Color(0xFF4CAF50),
        'fulfillmentColor': const Color(0xFF4CAF50),
      },
      {
        'id': '#1007',
        'date': '15 Feb, 2024',
        'customer': 'Ana Sofía Martínez',
        'payment': 'Pending',
        'total': '\$25.00',
        'items': '1 items',
        'fulfillment': 'Unfulfilled',
        'status': 'Open', // Order status for filtering
        'paymentColor': const Color(0xFFFF9800),
        'fulfillmentColor': const Color(0xFFF44336),
      },
      {
        'id': '#1009',
        'date': '17 Feb, 2024',
        'customer': 'Roberto Castillo',
        'payment': 'Success',
        'total': '\$27.00',
        'items': '5 items',
        'fulfillment': 'Fulfilled',
        'status': 'Closed', // Order status for filtering
        'paymentColor': const Color(0xFF4CAF50),
        'fulfillmentColor': const Color(0xFF4CAF50),
      },
      {
        'id': '#1011',
        'date': '19 Feb, 2024',
        'customer': 'Gabriela Campos',
        'payment': 'Pending',
        'total': '\$32.00',
        'items': '4 items',
        'fulfillment': 'Unfulfilled',
        'status': 'Open', // Order status for filtering
        'paymentColor': const Color(0xFFFF9800),
        'fulfillmentColor': const Color(0xFFF44336),
      },
    ];

    // Filter orders based on selected filter
    final filteredOrders = _filterOrders(sampleOrders);

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No orders found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: filteredOrders
          .map((order) => _buildOrderCard(context, order))
          .toList(),
    );
  }

  List<Map<String, dynamic>> _filterOrders(List<Map<String, dynamic>> orders) {
    return orders.where((order) {
      // Apply filter based on selected filter
      switch (selectedFilter) {
        case 'All':
          return true;
        case 'Unfulfilled':
          return order['fulfillment'] == 'Unfulfilled';
        case 'Unpaid':
          return order['payment'] == 'Pending';
        case 'Open':
          return order['status'] == 'Open';
        case 'Closed':
          return order['status'] == 'Closed';
        default:
          return true;
      }
    }).toList();
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to order details - encode the order ID to handle special characters
          final encodedOrderId = Uri.encodeComponent(order['id']);
          context.go('/orders/details/$encodedOrderId');
        },
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
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.6),
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order['customer'],
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
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
      ),
    );
  }
}
