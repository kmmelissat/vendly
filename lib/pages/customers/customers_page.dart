import 'package:flutter/material.dart';
import 'components/customers_header.dart';
import 'components/customers_list.dart';
import '../../services/customers_service.dart';
import '../../services/auth_service.dart';
import '../../models/customer.dart';
import '../../utils/auth_error_handler.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final CustomersService _customersService = CustomersService();
  
  String searchQuery = '';
  String selectedFilter = 'All';
  String sortBy = 'Recent';
  
  bool _isLoading = true;
  String? _errorMessage;
  List<Customer> _customers = [];
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
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

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

      if (_storeId == null) {
        setState(() {
          _errorMessage = 'Store ID not found. Please login again.';
          _isLoading = false;
        });
        return;
      }

      final customers = await _customersService.getCustomers(
        storeId: _storeId!,
        includeOrderStats: true,
      );

      setState(() {
        _customers = customers;
        _isLoading = false;
      });
    } catch (e) {
      if (AuthErrorHandler.isAuthError(e)) {
        if (mounted) {
          await AuthErrorHandler.handleAuthError(
            context,
            errorMessage: AuthErrorHandler.getAuthErrorMessage(e),
          );
        }
      } else {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> get filteredCustomers {
    // Convert Customer objects to legacy format
    List<Map<String, dynamic>> filtered = _customers
        .map((customer) => customer.toLegacyFormat())
        .toList();

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((customer) {
        return customer['name'].toLowerCase().contains(
              searchQuery.toLowerCase(),
            ) ||
            customer['email'].toLowerCase().contains(
              searchQuery.toLowerCase(),
            ) ||
            customer['phone'].contains(searchQuery);
      }).toList();
    }

    // Apply status filter
    if (selectedFilter != 'All') {
      filtered = filtered.where((customer) {
        return customer['status'] == selectedFilter;
      }).toList();
    }

    // Apply sorting
    switch (sortBy) {
      case 'Name A-Z':
        filtered.sort((a, b) => a['name'].compareTo(b['name']));
        break;
      case 'Name Z-A':
        filtered.sort((a, b) => b['name'].compareTo(a['name']));
        break;
      case 'Orders High-Low':
        filtered.sort((a, b) => b['totalOrders'].compareTo(a['totalOrders']));
        break;
      case 'Orders Low-High':
        filtered.sort((a, b) => a['totalOrders'].compareTo(b['totalOrders']));
        break;
      case 'Recent':
      default:
        filtered.sort(
          (a, b) => DateTime.parse(
            b['lastOrder'],
          ).compareTo(DateTime.parse(a['lastOrder'])),
        );
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Simple Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Customers',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (!_isLoading)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _loadCustomers,
                    tooltip: 'Refresh',
                  ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? _buildErrorState()
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Column(
                          children: [
                            // Search and Filters
                            CustomersHeader(
                              searchQuery: searchQuery,
                              selectedFilter: selectedFilter,
                              sortBy: sortBy,
                              filterOptions: filterOptions,
                              sortOptions: sortOptions,
                              onSearchChanged: (query) {
                                setState(() {
                                  searchQuery = query;
                                });
                              },
                              onFilterChanged: (filter) {
                                setState(() {
                                  selectedFilter = filter;
                                });
                              },
                              onSortChanged: (sort) {
                                setState(() {
                                  sortBy = sort;
                                });
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

                            const SizedBox(
                              height: 100,
                            ), // Bottom padding for navigation
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
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
              _errorMessage ?? 'An unknown error occurred',
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
              onPressed: _loadCustomers,
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
