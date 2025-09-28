import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsPage extends StatelessWidget {
  final String orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    // Sample order data - in real app this would come from API/database
    final orderData = _getOrderData(orderId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order $orderId'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share order functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // More options
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            _buildOrderHeader(context, orderData),
            const SizedBox(height: 24),

            // Customer Information
            _buildCustomerInfo(context, orderData),
            const SizedBox(height: 24),

            // Shipping Information
            _buildShippingInfo(context, orderData),
            const SizedBox(height: 24),

            // Order Items
            _buildOrderItems(context, orderData),
            const SizedBox(height: 24),

            // Order Summary
            _buildOrderSummary(context, orderData),
            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(context, orderData),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getOrderData(String orderId) {
    // Sample data - replace with actual data fetching
    final orders = {
      '#1002': {
        'id': '#1002',
        'date': '11 Feb, 2024',
        'time': '10:30 AM',
        'customer': {
          'name': 'Carlos Hernández',
          'email': 'carlos.hernandez@gmail.com',
          'phone': '+503 7777 7777',
        },
        'shipping': {
          'address': 'Colonia Escalón, Calle Principal, Casa 123',
          'city': 'San Salvador',
          'state': 'San Salvador',
          'zipCode': '01101',
          'country': 'El Salvador',
          'method': 'Standard Shipping',
          'trackingNumber': '2539357',
        },
        'payment': 'Pending',
        'total': 20.00,
        'subtotal': 18.00,
        'shippingCost': 2.00,
        'tax': 0.00,
        'fulfillment': 'Unfulfilled',
        'status': 'Open',
        'paymentColor': const Color(0xFFFF9800),
        'fulfillmentColor': const Color(0xFFF44336),
        'items': [
          {
            'name': 'Labubu Classic',
            'image': 'assets/images/products/labubu1.jpg',
            'quantity': 1,
            'price': 12.00,
            'variant': 'Color: Pink, Size: S',
          },
          {
            'name': 'Sonny Angel',
            'image': 'assets/images/products/sonnyangel1.jpg',
            'quantity': 1,
            'price': 6.00,
            'variant': 'Color: Blue',
          },
        ],
      },
      '#1004': {
        'id': '#1004',
        'date': '13 Feb, 2024',
        'time': '2:15 PM',
        'customer': {
          'name': 'María Elena Rodríguez',
          'email': 'maria.rodriguez@gmail.com',
          'phone': '+503 6666 8888',
        },
        'shipping': {
          'address': 'Colonia San Benito, Avenida La Revolución 456',
          'city': 'San Salvador',
          'state': 'San Salvador',
          'zipCode': '01102',
          'country': 'El Salvador',
          'method': 'Express Shipping',
          'trackingNumber': '2539358',
        },
        'payment': 'Success',
        'total': 22.00,
        'subtotal': 20.00,
        'shippingCost': 2.00,
        'tax': 0.00,
        'fulfillment': 'Fulfilled',
        'status': 'Closed',
        'paymentColor': const Color(0xFF4CAF50),
        'fulfillmentColor': const Color(0xFF4CAF50),
        'items': [
          {
            'name': 'Labubu Special Edition',
            'image': 'assets/images/products/labubu2.jpg',
            'quantity': 1,
            'price': 15.00,
            'variant': 'Color: Blue, Size: M',
          },
          {
            'name': 'Plush Collection',
            'image': 'assets/images/products/plush1.jpg',
            'quantity': 1,
            'price': 5.00,
            'variant': 'Color: White',
          },
        ],
      },
      '#1007': {
        'id': '#1007',
        'date': '15 Feb, 2024',
        'time': '11:45 AM',
        'customer': {
          'name': 'Ana Sofía Martínez',
          'email': 'ana.martinez@hotmail.com',
          'phone': '+503 7888 9999',
        },
        'shipping': {
          'address': 'Colonia Miramonte, Calle Los Robles 789',
          'city': 'Santa Tecla',
          'state': 'La Libertad',
          'zipCode': '01201',
          'country': 'El Salvador',
          'method': 'Standard Shipping',
          'trackingNumber': '2539359',
        },
        'payment': 'Pending',
        'total': 25.00,
        'subtotal': 23.00,
        'shippingCost': 2.00,
        'tax': 0.00,
        'fulfillment': 'Unfulfilled',
        'status': 'Open',
        'paymentColor': const Color(0xFFFF9800),
        'fulfillmentColor': const Color(0xFFF44336),
        'items': [
          {
            'name': 'Labubu Limited',
            'image': 'assets/images/products/labubu3.jpg',
            'quantity': 1,
            'price': 23.00,
            'variant': 'Color: Green, Size: L',
          },
        ],
      },
      // Add more sample orders as needed
    };

    return orders[orderId] ?? orders['#1002']!;
  }

  Future<void> _openTrackingUrl(String trackingNumber) async {
    final url = Uri.parse(
      'https://tracking.goboxful.com/?shipment=$trackingNumber',
    );
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        // Handle error - could show a snackbar or dialog
        debugPrint('Could not launch tracking URL: $url');
      }
    } catch (e) {
      debugPrint('Error launching tracking URL: $e');
    }
  }

  Widget _buildOrderHeader(BuildContext context, Map<String, dynamic> order) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order ${order['id']}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (order['paymentColor'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    order['payment'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: order['paymentColor'] as Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${order['date']} at ${order['time']}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
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
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order['status'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfo(BuildContext context, Map<String, dynamic> order) {
    final customer = order['customer'] as Map<String, dynamic>;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Information',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(context, Icons.person, 'Name', customer['name']),
            const SizedBox(height: 8),
            _buildInfoRow(context, Icons.email, 'Email', customer['email']),
            const SizedBox(height: 8),
            _buildInfoRow(context, Icons.phone, 'Phone', customer['phone']),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingInfo(BuildContext context, Map<String, dynamic> order) {
    final shipping = order['shipping'] as Map<String, dynamic>;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shipping Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (shipping['trackingNumber'] != null)
                  TextButton.icon(
                    onPressed: () =>
                        _openTrackingUrl(shipping['trackingNumber']),
                    icon: const Icon(Icons.track_changes, size: 16),
                    label: const Text('Track'),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              Icons.location_on,
              'Address',
              '${shipping['address']}\n${shipping['city']}, ${shipping['state']} ${shipping['zipCode']}\n${shipping['country']}',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              Icons.local_shipping,
              'Method',
              shipping['method'],
            ),
            if (shipping['trackingNumber'] != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                context,
                Icons.confirmation_number,
                'Tracking',
                shipping['trackingNumber'],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItems(BuildContext context, Map<String, dynamic> order) {
    final items = order['items'] as List<Map<String, dynamic>>;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Items (${items.length})',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...items.map((item) => _buildOrderItem(context, item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.shopping_bag,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  item['variant'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Qty: ${item['quantity']}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          // Price
          Text(
            '\$${item['price'].toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, Map<String, dynamic> order) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              context,
              'Subtotal',
              '\$${order['subtotal'].toStringAsFixed(2)}',
            ),
            _buildSummaryRow(
              context,
              'Shipping',
              '\$${order['shippingCost'].toStringAsFixed(2)}',
            ),
            _buildSummaryRow(
              context,
              'Tax',
              '\$${order['tax'].toStringAsFixed(2)}',
            ),
            const Divider(),
            _buildSummaryRow(
              context,
              'Total',
              '\$${order['total'].toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isTotal ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Map<String, dynamic> order) {
    return Column(
      children: [
        // Primary Actions
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Mark as fulfilled
                },
                icon: const Icon(Icons.check_circle),
                label: const Text('Mark Fulfilled'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Print order
                },
                icon: const Icon(Icons.print),
                label: const Text('Print'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Secondary Actions
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Refund order
                },
                icon: const Icon(Icons.money_off),
                label: const Text('Refund'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFF44336),
                  side: const BorderSide(color: Color(0xFFF44336)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Cancel order
                },
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFF44336),
                  side: const BorderSide(color: Color(0xFFF44336)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
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
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
