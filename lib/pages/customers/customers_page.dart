import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/customers_header.dart';
import 'components/customers_list.dart';
import '../../services/auth_service.dart';
import 'customers_bloc.dart';
import 'customers_event.dart';
import 'customers_state.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  int? _storeId;

  final List<String> filterOptions = ['All', 'VIP', 'Regular', 'New'];
  final List<String> sortOptions = [
    'Recent',
    'Name A-Z',
    'Name Z-A',
    'Orders High-Low',
    'Orders Low-High',
  ];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    try {
      // Get store ID from user data
      final authService = AuthService();
      final userData = await authService.getUserData();
      
      if (userData != null && userData['store'] != null) {
        final store = userData['store'] as Map<String, dynamic>;
        final storeIdString = store['id']?.toString();
        
        if (storeIdString != null) {
          _storeId = int.tryParse(storeIdString);
        }
      }

      if (_storeId != null && mounted) {
        context.read<CustomersBloc>().add(
          LoadCustomers(storeId: _storeId!),
        );
      }
    } catch (e) {
      // Error will be handled by BLoC
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Simple Header
          BlocBuilder<CustomersBloc, CustomersState>(
            builder: (context, state) {
              final isLoading = state is CustomersLoading;
              return Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Customers',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (!isLoading)
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          if (_storeId != null) {
                            context.read<CustomersBloc>().add(
                              RefreshCustomers(storeId: _storeId!),
                            );
                          }
                        },
                        tooltip: 'Refresh',
                      ),
                  ],
                ),
              );
            },
          ),

          // Content
          Expanded(
            child: BlocConsumer<CustomersBloc, CustomersState>(
              listener: (context, state) {
                if (state is CustomerUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Customer updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is CustomerDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Customer deleted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is CustomersLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is CustomersError) {
                  return _buildErrorState(state.message);
                }

                if (state is CustomersLoaded) {
                  final filteredCustomers = state.filteredCustomers
                      .map((customer) => customer.toLegacyFormat())
                      .toList();

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        // Search and Filters
                        CustomersHeader(
                          searchQuery: state.searchQuery,
                          selectedFilter: state.statusFilter ?? 'All',
                          sortBy: state.sortBy,
                          filterOptions: filterOptions,
                          sortOptions: sortOptions,
                          onSearchChanged: (query) {
                            context.read<CustomersBloc>().add(
                              SearchCustomers(query: query),
                            );
                          },
                          onFilterChanged: (filter) {
                            context.read<CustomersBloc>().add(
                              FilterCustomersByStatus(
                                status: filter == 'All' ? null : filter,
                              ),
                            );
                          },
                          onSortChanged: (sort) {
                            context.read<CustomersBloc>().add(
                              SortCustomers(sortBy: sort),
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        // Customers List
                        CustomersList(
                          customers: filteredCustomers,
                          onCustomerTap: (customer) {
                            _showCustomerDetails(context, customer);
                          },
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  );
                }

                return const Center(child: Text('No customers found'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load customers',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                if (_storeId != null) {
                  context.read<CustomersBloc>().add(
                    LoadCustomers(storeId: _storeId!),
                  );
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomerDetails(
    BuildContext context,
    Map<String, dynamic> customer,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Customer Header
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(customer['avatar']),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer['name'],
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  customer['status'],
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                customer['status'],
                                style: TextStyle(
                                  color: _getStatusColor(customer['status']),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Customer Details
                  _buildDetailSection('Contact Information', [
                    _buildDetailItem(Icons.email, 'Email', customer['email']),
                    _buildDetailItem(Icons.phone, 'Phone', customer['phone']),
                    _buildDetailItem(
                      Icons.location_on,
                      'Address',
                      customer['address'],
                    ),
                  ]),

                  const SizedBox(height: 24),

                  _buildDetailSection('Purchase History', [
                    _buildDetailItem(
                      Icons.shopping_cart,
                      'Total Orders',
                      '${customer['totalOrders']} orders',
                    ),
                    _buildDetailItem(
                      Icons.attach_money,
                      'Total Spent',
                      '\$${customer['totalSpent'].toStringAsFixed(2)}',
                    ),
                    _buildDetailItem(
                      Icons.calendar_today,
                      'Last Order',
                      _formatDate(customer['lastOrder']),
                    ),
                    _buildDetailItem(
                      Icons.person_add,
                      'Member Since',
                      _formatDate(customer['joinDate']),
                    ),
                  ]),

                  const SizedBox(height: 24),

                  _buildDetailSection('Favorite Products', [
                    ...customer['favoriteProducts']
                        .map<Widget>(
                          (product) => _buildDetailItem(
                            Icons.favorite,
                            'Product',
                            product,
                          ),
                        )
                        .toList(),
                  ]),

                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to customer orders
                          },
                          icon: const Icon(Icons.history),
                          label: const Text('View Orders'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Edit customer
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Customer'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...items,
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'VIP':
        return Colors.purple;
      case 'Regular':
        return Colors.blue;
      case 'New':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
