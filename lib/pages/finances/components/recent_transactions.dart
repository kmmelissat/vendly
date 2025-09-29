import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  // Sample transaction data
  static const List<Map<String, dynamic>> transactions = [
    {
      'id': 'TXN-001',
      'customerName': 'María González',
      'amount': 45.50,
      'paymentMethod': 'transfer',
      'status': 'completed',
      'date': '2024-01-15 14:30',
      'products': ['Labubu Classic Pink', 'Sonny Angel'],
    },
    {
      'id': 'TXN-002',
      'customerName': 'Carlos Rodríguez',
      'amount': 28.00,
      'paymentMethod': 'nico',
      'status': 'completed',
      'date': '2024-01-15 13:45',
      'products': ['Gummy Bear Plush'],
    },
    {
      'id': 'TXN-003',
      'customerName': 'Ana Martínez',
      'amount': 67.25,
      'paymentMethod': 'cash_delivery',
      'status': 'pending',
      'date': '2024-01-15 12:20',
      'products': ['Labubu Golden Edition', 'Cinnamoroll Plush'],
    },
    {
      'id': 'TXN-004',
      'customerName': 'Luis Hernández',
      'amount': 22.00,
      'paymentMethod': 'card_sv',
      'status': 'completed',
      'date': '2024-01-15 11:15',
      'products': ['Ternuritos Classic Pink'],
    },
    {
      'id': 'TXN-005',
      'customerName': 'Sofia Ramírez',
      'amount': 89.75,
      'paymentMethod': 'transfer',
      'status': 'completed',
      'date': '2024-01-15 10:30',
      'products': ['Wild Cutie Plush', 'Mokoko Seed', 'Kawaii Unicorn'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full transactions page
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return FadeInUp(
                duration: Duration(milliseconds: 300 + (index * 100)),
                child: _buildTransactionItem(context, transactions[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    Map<String, dynamic> transaction,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          // Payment Method Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _getPaymentMethodColor(
                transaction['paymentMethod'],
              ).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getPaymentMethodIcon(transaction['paymentMethod']),
              color: _getPaymentMethodColor(transaction['paymentMethod']),
              size: 20,
            ),
          ),

          const SizedBox(width: 16),

          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transaction['customerName'],
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\$${transaction['amount'].toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                Row(
                  children: [
                    Text(
                      transaction['id'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          transaction['status'],
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getStatusText(transaction['status']),
                        style: TextStyle(
                          color: _getStatusColor(transaction['status']),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        transaction['products'].join(', '),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _formatDate(transaction['date']),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method) {
      case 'transfer':
        return Icons.account_balance;
      case 'nico':
        return Icons.wallet;
      case 'cash_delivery':
        return Icons.local_shipping;
      case 'card_sv':
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }

  Color _getPaymentMethodColor(String method) {
    switch (method) {
      case 'transfer':
        return const Color(0xFF2196F3); // Blue
      case 'nico':
        return const Color(0xFF4CAF50); // Green
      case 'cash_delivery':
        return const Color(0xFFFF9800); // Orange
      case 'card_sv':
        return const Color(0xFF9C27B0); // Purple
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'COMPLETED';
      case 'pending':
        return 'PENDING';
      case 'failed':
        return 'FAILED';
      default:
        return 'UNKNOWN';
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString.replaceAll(' ', 'T'));
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}
