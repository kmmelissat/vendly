import 'package:flutter/material.dart';
import 'components/customers_header.dart';
import 'components/customers_stats.dart';
import 'components/customers_list.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  String searchQuery = '';
  String selectedFilter = 'All';
  String sortBy = 'Recent';

  final List<String> filterOptions = ['All', 'VIP', 'Regular', 'New'];
  final List<String> sortOptions = [
    'Recent',
    'Name A-Z',
    'Name Z-A',
    'Orders High-Low',
    'Orders Low-High',
  ];

  // Sample customer data
  final List<Map<String, dynamic>> customers = [
    {
      'id': 'CUST-001',
      'name': 'María González',
      'email': 'maria.gonzalez@email.com',
      'phone': '+503 7123-4567',
      'avatar': 'assets/images/customers/customer1.jpg',
      'totalOrders': 15,
      'totalSpent': 450.75,
      'lastOrder': '2024-01-15',
      'status': 'VIP',
      'joinDate': '2023-08-15',
      'favoriteProducts': ['Labubu Classic Pink', 'Sonny Angel'],
      'address': 'San Salvador, El Salvador',
    },
    {
      'id': 'CUST-002',
      'name': 'Carlos Rodríguez',
      'email': 'carlos.rodriguez@email.com',
      'phone': '+503 7234-5678',
      'avatar': 'assets/images/customers/customer2.jpg',
      'totalOrders': 8,
      'totalSpent': 280.50,
      'lastOrder': '2024-01-12',
      'status': 'Regular',
      'joinDate': '2023-11-20',
      'favoriteProducts': ['Gummy Bear Plush', 'Ternuritos'],
      'address': 'Santa Ana, El Salvador',
    },
    {
      'id': 'CUST-003',
      'name': 'Ana Martínez',
      'email': 'ana.martinez@email.com',
      'phone': '+503 7345-6789',
      'avatar': 'assets/images/customers/customer3.jpg',
      'totalOrders': 22,
      'totalSpent': 675.25,
      'lastOrder': '2024-01-14',
      'status': 'VIP',
      'joinDate': '2023-06-10',
      'favoriteProducts': ['Labubu Golden Edition', 'Cinnamoroll Plush'],
      'address': 'San Miguel, El Salvador',
    },
    {
      'id': 'CUST-004',
      'name': 'Luis Hernández',
      'email': 'luis.hernandez@email.com',
      'phone': '+503 7456-7890',
      'avatar': 'assets/images/customers/customer4.jpg',
      'totalOrders': 3,
      'totalSpent': 95.00,
      'lastOrder': '2024-01-10',
      'status': 'New',
      'joinDate': '2024-01-05',
      'favoriteProducts': ['Ternuritos Classic Pink'],
      'address': 'La Libertad, El Salvador',
    },
    {
      'id': 'CUST-005',
      'name': 'Sofia Ramírez',
      'email': 'sofia.ramirez@email.com',
      'phone': '+503 7567-8901',
      'avatar': 'assets/images/customers/customer5.jpg',
      'totalOrders': 12,
      'totalSpent': 380.90,
      'lastOrder': '2024-01-13',
      'status': 'Regular',
      'joinDate': '2023-09-25',
      'favoriteProducts': ['Wild Cutie Plush', 'Mokoko Seed'],
      'address': 'Sonsonate, El Salvador',
    },
    {
      'id': 'CUST-006',
      'name': 'Diego Morales',
      'email': 'diego.morales@email.com',
      'phone': '+503 7678-9012',
      'avatar': 'assets/images/customers/customer6.jpg',
      'totalOrders': 18,
      'totalSpent': 520.40,
      'lastOrder': '2024-01-11',
      'status': 'VIP',
      'joinDate': '2023-07-18',
      'favoriteProducts': ['Labubu Classic Pink', 'Kawaii Unicorn'],
      'address': 'Ahuachapán, El Salvador',
    },
  ];

  List<Map<String, dynamic>> get filteredCustomers {
    List<Map<String, dynamic>> filtered = customers;

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
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Customers',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Customer Statistics
                CustomersStats(customers: customers),

                const SizedBox(height: 24),

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

                const SizedBox(height: 100), // Bottom padding for navigation
              ]),
            ),
          ),
        ],
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
