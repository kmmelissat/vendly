import 'package:flutter_test/flutter_test.dart';
import 'package:vendly/models/order.dart';

void main() {
  group('Order.fromJson', () {
    test('should parse order correctly', () {
      final json = {
        "shipping_address": "redededededededededed",
        "shipping_city": "strededeing",
        "shipping_postal_code": "323232",
        "shipping_country": "el salvasdor",
        "id": 9,
        "order_number": "ORD-20251109223604-PCUS",
        "customer_id": 22,
        "total_amount": 40,
        "status": "pending",
        "created_at": "2025-11-09T22:36:04.644447",
        "updated_at": "2025-11-09T22:36:04.644450",
        "shipped_at": null,
        "delivered_at": null,
        "canceled_at": null,
        "products": [
          {
            "product_id": 24,
            "quantity": 2,
            "unit_price": 20,
            "id": 14,
            "order_id": 9
          }
        ]
      };

      final order = Order.fromJson(json);

      expect(order.id, 9);
      expect(order.orderNumber, "ORD-20251109223604-PCUS");
      expect(order.customerId, 22);
      expect(order.totalAmount, 40);
      expect(order.status, "pending");
      expect(order.shippingAddress, "redededededededededed");
      expect(order.shippingCity, "strededeing");
      expect(order.shippingPostalCode, "323232");
      expect(order.shippingCountry, "el salvasdor");
      expect(order.products.length, 1);
      expect(order.products.first.productId, 24);
      expect(order.products.first.quantity, 2);
      expect(order.products.first.unitPrice, 20);
      expect(order.isPending, true);
      expect(order.isDelivered, false);
    });

    test('should handle nullable date fields', () {
      final json = {
        "shipping_address": "123 Main St",
        "shipping_city": "City",
        "shipping_postal_code": "12345",
        "shipping_country": "Country",
        "id": 1,
        "order_number": "ORD-001",
        "customer_id": 1,
        "total_amount": 100,
        "status": "delivered",
        "created_at": "2025-11-09T22:36:04.644447",
        "updated_at": "2025-11-09T22:36:04.644450",
        "shipped_at": "2025-11-10T10:00:00.000000",
        "delivered_at": "2025-11-11T15:30:00.000000",
        "canceled_at": null,
        "products": []
      };

      final order = Order.fromJson(json);

      expect(order.shippedAt, isNotNull);
      expect(order.deliveredAt, isNotNull);
      expect(order.canceledAt, isNull);
      expect(order.isDelivered, true);
    });

    test('toLegacyFormat should work correctly', () {
      final json = {
        "shipping_address": "123 Main St",
        "shipping_city": "City",
        "shipping_postal_code": "12345",
        "shipping_country": "Country",
        "id": 1,
        "order_number": "ORD-001",
        "customer_id": 1,
        "total_amount": 100,
        "status": "pending",
        "created_at": "2025-11-09T22:36:04.644447",
        "updated_at": "2025-11-09T22:36:04.644450",
        "shipped_at": null,
        "delivered_at": null,
        "canceled_at": null,
        "products": [
          {
            "product_id": 24,
            "quantity": 2,
            "unit_price": 20,
            "id": 14,
            "order_id": 1
          }
        ]
      };

      final order = Order.fromJson(json);
      final legacy = order.toLegacyFormat();

      expect(legacy['id'], "1");
      expect(legacy['orderNumber'], "ORD-001");
      expect(legacy['customer'], "Customer #1");
      expect(legacy['total'], 100);
      expect(legacy['status'], "pending");
      expect(legacy['items'], 1);
    });
  });

  group('OrderProduct', () {
    test('should calculate total price correctly', () {
      final json = {
        "product_id": 24,
        "quantity": 3,
        "unit_price": 15.50,
        "id": 14,
        "order_id": 9
      };

      final orderProduct = OrderProduct.fromJson(json);

      expect(orderProduct.totalPrice, 46.50);
    });
  });
}

