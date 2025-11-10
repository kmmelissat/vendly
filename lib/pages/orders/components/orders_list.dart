import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../models/order.dart';
import '../../../services/orders_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/logger_service.dart';

class OrdersList extends StatefulWidget {
  final String selectedFilter;
  final DateTimeRange? selectedDateRange;

  const OrdersList({
    super.key,
    required this.selectedFilter,
    this.selectedDateRange,
  });

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  late OrdersService _ordersService;
  late AuthService _authService;
  List<Order> _orders = [];
  bool _isLoading = true;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _ordersService = OrdersService(authService: _authService);
    _loadOrders();
  }

  @override
  void didUpdateWidget(OrdersList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload orders if filter or date range changes
    if (oldWidget.selectedFilter != widget.selectedFilter ||
        oldWidget.selectedDateRange != widget.selectedDateRange) {
      _loadOrders();
    }
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get user data to extract store ID
      final userData = await _authService.getUserData();
      if (userData != null && userData['store'] != null) {
        final store = userData['store'] as Map<String, dynamic>;
        _storeId = store['id']?.toString();

        if (_storeId != null) {
          LoggerService.info('Loading orders for store: $_storeId');

          // Map filter to status
          String? status;
          if (widget.selectedFilter != 'All') {
            status = _mapFilterToStatus(widget.selectedFilter);
          }

          final orders = await _ordersService.getOrders(
            storeId: _storeId!,
            status: status,
            startDate: widget.selectedDateRange?.start,
            endDate: widget.selectedDateRange?.end,
          );

          if (mounted) {
            setState(() {
              _orders = orders;
              _isLoading = false;
            });
          }
        }
      }
    } catch (e, stackTrace) {
      LoggerService.error(
        'Error loading orders',
        error: e,
        stackTrace: stackTrace,
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _mapFilterToStatus(String filter) {
    switch (filter) {
      case 'Unfulfilled':
        return 'pending';
      case 'Open':
        return 'confirmed';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show empty state if no orders
    if (_orders.isEmpty) {
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
      children: _orders
          .map((order) => _buildOrderCard(context, order))
          .toList(),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF9800);
      case 'confirmed':
      case 'processing':
        return const Color(0xFF2196F3);
      case 'shipped':
        return const Color(0xFF9C27B0);
      case 'delivered':
        return const Color(0xFF4CAF50);
      case 'cancelled':
      case 'canceled':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF757575);
    }
  }

  String _formatStatus(String status) {
    return status[0].toUpperCase() + status.substring(1);
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final dateFormat = DateFormat('dd MMM, yyyy');
    final statusColor = _getStatusColor(order.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.go('/orders/details/${order.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header Row
              Row(
                children: [
                  Text(
                    order.orderNumber,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    dateFormat.format(order.createdAt),
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
                          'Customer #${order.customerId}',
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
                        '\$${order.totalAmount.toStringAsFixed(2)}',
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
                  // Order Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatStatus(order.status),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Items count
                  Text(
                    '${order.products.length} item${order.products.length != 1 ? 's' : ''}',
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
