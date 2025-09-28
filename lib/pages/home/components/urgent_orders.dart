import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UrgentOrders extends StatelessWidget {
  const UrgentOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final urgentOrders = [
      {
        'id': '#1025',
        'customer': 'Sarah Johnson',
        'total': '\$125.99',
        'timeAgo': '2 hours ago',
        'priority': 'High',
        'items': '3 items',
      },
      {
        'id': '#1026',
        'customer': 'Mike Chen',
        'total': '\$89.50',
        'timeAgo': '4 hours ago',
        'priority': 'Medium',
        'items': '2 items',
      },
      {
        'id': '#1027',
        'customer': 'Emma Wilson',
        'total': '\$234.75',
        'timeAgo': '6 hours ago',
        'priority': 'High',
        'items': '5 items',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Icon(Icons.priority_high, color: const Color(0xFFF44336), size: 20),
            const SizedBox(width: 8),
            Text(
              'Urgent Orders to Fulfill',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                context.go('/orders');
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: const Color(0xFF5329C8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Urgent Orders List
        ...urgentOrders.map((order) => _buildUrgentOrderCard(context, order)),
      ],
    );
  }

  Widget _buildUrgentOrderCard(
    BuildContext context,
    Map<String, dynamic> order,
  ) {
    final isPriorityHigh = order['priority'] == 'High';

    return GestureDetector(
      onTap: () {
        context.go('/orders');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPriorityHigh
                ? const Color(0xFFF44336).withOpacity(0.3)
                : const Color(0xFFFF9800).withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  (isPriorityHigh
                          ? const Color(0xFFF44336)
                          : const Color(0xFFFF9800))
                      .withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header Row
            Row(
              children: [
                // Priority Indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (isPriorityHigh
                                ? const Color(0xFFF44336)
                                : const Color(0xFFFF9800))
                            .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPriorityHigh ? Icons.warning : Icons.schedule,
                        size: 12,
                        color: isPriorityHigh
                            ? const Color(0xFFF44336)
                            : const Color(0xFFFF9800),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        order['priority'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isPriorityHigh
                              ? const Color(0xFFF44336)
                              : const Color(0xFFFF9800),
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  order['id'],
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Order Details Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['customer'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            order['items'],
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.6),
                                ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            order['timeAgo'],
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      order['total'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5329C8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5329C8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Fulfill',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
