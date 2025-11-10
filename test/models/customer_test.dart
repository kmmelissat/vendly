import 'package:flutter_test/flutter_test.dart';
import 'package:vendly/models/customer.dart';

void main() {
  group('Customer Model Tests', () {
    test('Customer.fromJson parses API response correctly', () {
      final json = {
        "id": 5,
        "username": "john_doe",
        "email": "john@example.com",
        "user_type": "customer",
        "phone": "+1234567890",
        "preferred_payment_method": "paypal",
        "created_at": "2024-01-15T10:30:00",
        "updated_at": "2024-01-20T14:45:00",
        "total_orders": 5,
        "total_spent": 499.95,
        "last_order_date": "2024-11-08T15:30:00"
      };

      final customer = Customer.fromJson(json);

      expect(customer.id, 5);
      expect(customer.username, 'john_doe');
      expect(customer.email, 'john@example.com');
      expect(customer.userType, 'customer');
      expect(customer.phone, '+1234567890');
      expect(customer.preferredPaymentMethod, 'paypal');
      expect(customer.totalOrders, 5);
      expect(customer.totalSpent, 499.95);
      expect(customer.lastOrderDate, isNotNull);
    });

    test('Customer.fromJson handles null optional fields', () {
      final json = {
        "id": 10,
        "username": "jane_doe",
        "email": "jane@example.com",
        "user_type": "customer",
        "phone": null,
        "preferred_payment_method": null,
        "created_at": "2024-01-15T10:30:00",
        "updated_at": "2024-01-20T14:45:00",
        "total_orders": null,
        "total_spent": null,
        "last_order_date": null
      };

      final customer = Customer.fromJson(json);

      expect(customer.id, 10);
      expect(customer.username, 'jane_doe');
      expect(customer.phone, isNull);
      expect(customer.preferredPaymentMethod, isNull);
      expect(customer.totalOrders, isNull);
      expect(customer.totalSpent, isNull);
      expect(customer.lastOrderDate, isNull);
    });

    test('Customer status determination works correctly', () {
      // New customer (no orders)
      final newCustomer = Customer(
        id: 1,
        username: 'new_user',
        email: 'new@example.com',
        userType: 'customer',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        totalOrders: 0,
        totalSpent: 0,
      );
      expect(newCustomer.status, 'New');

      // VIP customer (10+ orders)
      final vipCustomer1 = Customer(
        id: 2,
        username: 'vip_user',
        email: 'vip@example.com',
        userType: 'customer',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        totalOrders: 10,
        totalSpent: 300,
      );
      expect(vipCustomer1.status, 'VIP');

      // VIP customer ($500+ spent)
      final vipCustomer2 = Customer(
        id: 3,
        username: 'vip_user2',
        email: 'vip2@example.com',
        userType: 'customer',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        totalOrders: 5,
        totalSpent: 500,
      );
      expect(vipCustomer2.status, 'VIP');

      // Regular customer
      final regularCustomer = Customer(
        id: 4,
        username: 'regular_user',
        email: 'regular@example.com',
        userType: 'customer',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        totalOrders: 5,
        totalSpent: 250,
      );
      expect(regularCustomer.status, 'Regular');
    });

    test('Customer.toLegacyFormat converts correctly', () {
      final customer = Customer(
        id: 5,
        username: 'john_doe',
        email: 'john@example.com',
        userType: 'customer',
        phone: '+1234567890',
        createdAt: DateTime.parse('2024-01-15T10:30:00'),
        updatedAt: DateTime.parse('2024-01-20T14:45:00'),
        totalOrders: 5,
        totalSpent: 499.95,
        lastOrderDate: DateTime.parse('2024-11-08T15:30:00'),
      );

      final legacy = customer.toLegacyFormat();

      expect(legacy['id'], 'CUST-005');
      expect(legacy['name'], 'john_doe');
      expect(legacy['email'], 'john@example.com');
      expect(legacy['phone'], '+1234567890');
      expect(legacy['totalOrders'], 5);
      expect(legacy['totalSpent'], 499.95);
      expect(legacy['status'], 'Regular');
      expect(legacy['favoriteProducts'], isEmpty);
    });
  });
}

