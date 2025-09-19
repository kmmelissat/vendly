import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/database_service.dart';
import '../../../../shared/models/store_model.dart';
import '../../../../shared/models/product_model.dart';
import '../../../../shared/models/order_model.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../widgets/dashboard_metric_card.dart';
import '../widgets/quick_action_card.dart';
import 'product_management_screen.dart';
import 'orders_management_screen.dart';
import 'analytics_screen.dart';

class SellerDashboardScreen extends StatefulWidget {
  const SellerDashboardScreen({super.key});

  @override
  State<SellerDashboardScreen> createState() => _SellerDashboardScreenState();
}

class _SellerDashboardScreenState extends State<SellerDashboardScreen> {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  Store? _store;
  List<Product> _products = [];
  List<Order> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) return;

      final store = await _databaseService.getStoreByUserId(currentUser.id);
      if (store == null) return;

      final products = await _databaseService.getProductsByStoreId(store.id);
      final orders = await _databaseService.getOrdersByStoreId(store.id);

      if (mounted) {
        setState(() {
          _store = store;
          _products = products;
          _orders = orders;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading dashboard: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_store == null) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(child: Text('Store not found')),
      );
    }

    final totalRevenue = _orders
        .where((order) => order.status == OrderStatus.delivered)
        .fold(0.0, (sum, order) => sum + order.total);

    final pendingOrders = _orders
        .where((order) => order.status == OrderStatus.pending)
        .length;

    final activeProducts = _products
        .where((product) => product.status == ProductStatus.active)
        .length;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: GlassAppBar(
        title: 'Seller Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          const SizedBox(width: AppConstants.spacingSm),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        color: AppTheme.primaryBlue,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Store Header
              FadeInDown(
                duration: AppConstants.animationMedium,
                child: GlassContainer(
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(
                            AppConstants.radiusMd,
                          ),
                        ),
                        child: const Icon(
                          Icons.storefront_rounded,
                          color: Colors.white,
                          size: AppConstants.iconLg,
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _store!.name,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                            ),
                            Text(
                              _store!.category,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppTheme.textSecondary),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: AppConstants.iconSm,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: AppConstants.spacingXs),
                                Text(
                                  '${_store!.rating.toStringAsFixed(1)} (${_store!.totalReviews})',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.spacingLg),

              // Metrics Row
              FadeInLeft(
                duration: AppConstants.animationMedium,
                delay: const Duration(milliseconds: 100),
                child: Row(
                  children: [
                    Expanded(
                      child: DashboardMetricCard(
                        title: 'Revenue',
                        value: '\$${totalRevenue.toStringAsFixed(2)}',
                        icon: Icons.attach_money,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: DashboardMetricCard(
                        title: 'Products',
                        value: '$activeProducts',
                        icon: Icons.inventory_2_outlined,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.spacingMd),

              FadeInRight(
                duration: AppConstants.animationMedium,
                delay: const Duration(milliseconds: 200),
                child: Row(
                  children: [
                    Expanded(
                      child: DashboardMetricCard(
                        title: 'Orders',
                        value: '${_orders.length}',
                        icon: Icons.shopping_bag_outlined,
                        color: AppTheme.accentBlue,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: DashboardMetricCard(
                        title: 'Pending',
                        value: '$pendingOrders',
                        icon: Icons.pending_actions,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.spacingLg),

              // Quick Actions
              FadeInUp(
                duration: AppConstants.animationMedium,
                delay: const Duration(milliseconds: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),

                    Row(
                      children: [
                        Expanded(
                          child: QuickActionCard(
                            title: 'Add Product',
                            subtitle: 'Create new listing',
                            icon: Icons.add_box_outlined,
                            color: Colors.green,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductManagementScreen(
                                    storeId: _store!.id,
                                  ),
                                ),
                              ).then((_) => _loadDashboardData());
                            },
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingMd),
                        Expanded(
                          child: QuickActionCard(
                            title: 'Manage Orders',
                            subtitle: 'View & update',
                            icon: Icons.list_alt_outlined,
                            color: AppTheme.primaryBlue,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrdersManagementScreen(
                                    storeId: _store!.id,
                                  ),
                                ),
                              ).then((_) => _loadDashboardData());
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppConstants.spacingMd),

                    Row(
                      children: [
                        Expanded(
                          child: QuickActionCard(
                            title: 'Analytics',
                            subtitle: 'View insights',
                            icon: Icons.analytics_outlined,
                            color: Colors.purple,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AnalyticsScreen(storeId: _store!.id),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingMd),
                        Expanded(
                          child: QuickActionCard(
                            title: 'My Products',
                            subtitle: 'Manage inventory',
                            icon: Icons.inventory_outlined,
                            color: Colors.orange,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductManagementScreen(
                                    storeId: _store!.id,
                                  ),
                                ),
                              ).then((_) => _loadDashboardData());
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.spacingLg),

              // Recent Orders
              if (_orders.isNotEmpty)
                FadeInUp(
                  duration: AppConstants.animationMedium,
                  delay: const Duration(milliseconds: 400),
                  child: GlassContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Orders',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OrdersManagementScreen(
                                          storeId: _store!.id,
                                        ),
                                  ),
                                );
                              },
                              child: const Text('View All'),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.spacingMd),

                        ...(_orders
                            .take(3)
                            .map((order) => _buildOrderItem(order))),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItem(Order order) {
    Color statusColor;
    switch (order.status) {
      case OrderStatus.pending:
        statusColor = Colors.orange;
        break;
      case OrderStatus.confirmed:
        statusColor = AppTheme.primaryBlue;
        break;
      case OrderStatus.shipped:
        statusColor = Colors.blue;
        break;
      case OrderStatus.delivered:
        statusColor = Colors.green;
        break;
      case OrderStatus.cancelled:
        statusColor = Colors.red;
        break;
      default:
        statusColor = AppTheme.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order.id.substring(0, 8)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  '${order.totalItems} items • \$${order.total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingSm,
              vertical: AppConstants.spacingXs,
            ),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Text(
              order.status.name.toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
