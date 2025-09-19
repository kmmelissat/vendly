import 'package:uuid/uuid.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded,
}

enum PaymentStatus { pending, paid, failed, refunded }

class OrderItem {
  final String productId;
  final String productName;
  final String productImageUrl;
  final double unitPrice;
  final int quantity;
  final double totalPrice;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.unitPrice,
    required this.quantity,
  }) : totalPrice = unitPrice * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImageUrl': productImageUrl,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'],
      productName: map['productName'],
      productImageUrl: map['productImageUrl'],
      unitPrice: map['unitPrice']?.toDouble() ?? 0.0,
      quantity: map['quantity'] ?? 1,
    );
  }
}

class Order {
  final String id;
  final String buyerId;
  final String storeId;
  final String storeName;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final String? paymentMethod;
  final String deliveryAddress;
  final String? deliveryInstructions;
  final DateTime? estimatedDelivery;
  final String? trackingNumber;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    String? id,
    required this.buyerId,
    required this.storeId,
    required this.storeName,
    required this.items,
    required this.deliveryFee,
    this.tax = 0.0,
    this.status = OrderStatus.pending,
    this.paymentStatus = PaymentStatus.pending,
    this.paymentMethod,
    required this.deliveryAddress,
    this.deliveryInstructions,
    this.estimatedDelivery,
    this.trackingNumber,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       subtotal = items.fold(0.0, (sum, item) => sum + item.totalPrice),
       total =
           items.fold(0.0, (sum, item) => sum + item.totalPrice) +
           deliveryFee +
           tax,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'buyerId': buyerId,
      'storeId': storeId,
      'storeName': storeName,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'total': total,
      'status': status.name,
      'paymentStatus': paymentStatus.name,
      'paymentMethod': paymentMethod,
      'deliveryAddress': deliveryAddress,
      'deliveryInstructions': deliveryInstructions,
      'estimatedDelivery': estimatedDelivery?.toIso8601String(),
      'trackingNumber': trackingNumber,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    final itemsList = map['items'] as List<dynamic>? ?? [];
    final orderItems = itemsList
        .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
        .toList();

    return Order(
      id: map['id'],
      buyerId: map['buyerId'],
      storeId: map['storeId'],
      storeName: map['storeName'],
      items: orderItems,
      deliveryFee: map['deliveryFee']?.toDouble() ?? 0.0,
      tax: map['tax']?.toDouble() ?? 0.0,
      status: OrderStatus.values.firstWhere((e) => e.name == map['status']),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == map['paymentStatus'],
      ),
      paymentMethod: map['paymentMethod'],
      deliveryAddress: map['deliveryAddress'],
      deliveryInstructions: map['deliveryInstructions'],
      estimatedDelivery: map['estimatedDelivery'] != null
          ? DateTime.parse(map['estimatedDelivery'])
          : null,
      trackingNumber: map['trackingNumber'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Order copyWith({
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    String? paymentMethod,
    String? deliveryAddress,
    String? deliveryInstructions,
    DateTime? estimatedDelivery,
    String? trackingNumber,
    String? notes,
  }) {
    return Order(
      id: id,
      buyerId: buyerId,
      storeId: storeId,
      storeName: storeName,
      items: items,
      deliveryFee: deliveryFee,
      tax: tax,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Order{id: $id, status: $status, total: $total, items: ${items.length}}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
