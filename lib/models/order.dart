class Order {
  final int id;
  final String orderNumber;
  final int customerId;
  final Customer? customer;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final DateTime? canceledAt;
  final String shippingAddress;
  final String shippingCity;
  final String shippingPostalCode;
  final String shippingCountry;
  final List<OrderProduct> products;

  Order({
    required this.id,
    required this.orderNumber,
    required this.customerId,
    this.customer,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.shippedAt,
    this.deliveredAt,
    this.canceledAt,
    required this.shippingAddress,
    required this.shippingCity,
    required this.shippingPostalCode,
    required this.shippingCountry,
    required this.products,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      orderNumber: json['order_number'] as String,
      customerId: json['customer_id'] as int,
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      shippedAt: json['shipped_at'] != null
          ? DateTime.parse(json['shipped_at'] as String)
          : null,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'] as String)
          : null,
      canceledAt: json['canceled_at'] != null
          ? DateTime.parse(json['canceled_at'] as String)
          : null,
      shippingAddress: json['shipping_address'] as String,
      shippingCity: json['shipping_city'] as String,
      shippingPostalCode: json['shipping_postal_code'] as String,
      shippingCountry: json['shipping_country'] as String,
      products: (json['products'] as List<dynamic>)
          .map(
            (product) => OrderProduct.fromJson(product as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'customer_id': customerId,
      'customer': customer?.toJson(),
      'total_amount': totalAmount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'shipped_at': shippedAt?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
      'canceled_at': canceledAt?.toIso8601String(),
      'shipping_address': shippingAddress,
      'shipping_city': shippingCity,
      'shipping_postal_code': shippingPostalCode,
      'shipping_country': shippingCountry,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }

  // Helper method for backward compatibility with existing UI
  Map<String, dynamic> toLegacyFormat() {
    return {
      'id': id.toString(),
      'orderNumber': orderNumber,
      'customer': customer?.username ?? 'Customer #$customerId',
      'customerEmail': customer?.email,
      'customerPhone': customer?.phone,
      'date': createdAt.toIso8601String(),
      'total': totalAmount,
      'status': status,
      'items': products.length,
      'shippingAddress': shippingAddress,
      'shippingCity': shippingCity,
      'shippingPostalCode': shippingPostalCode,
      'shippingCountry': shippingCountry,
      'products': products.map((p) => p.toLegacyFormat()).toList(),
    };
  }

  // Helper getter for customer display name
  String get customerName => customer?.username ?? 'Customer #$customerId';

  // Status helpers
  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isProcessing => status == 'processing';
  bool get isShipped => status == 'shipped';
  bool get isDelivered => status == 'delivered';
  bool get isCanceled => status == 'cancelled' || status == 'canceled';
}

class OrderProduct {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final double unitPrice;
  final ProductInfo? product;

  OrderProduct({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.product,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      id: json['id'] as int,
      orderId: json['order_id'] as int,
      productId: json['product_id'] as int,
      quantity: json['quantity'] as int,
      unitPrice: (json['unit_price'] as num).toDouble(),
      product: json['product'] != null
          ? ProductInfo.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'product': product?.toJson(),
    };
  }

  // Helper method for backward compatibility
  Map<String, dynamic> toLegacyFormat() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': unitPrice,
      'total': unitPrice * quantity,
    };
  }

  double get totalPrice => unitPrice * quantity;
}

class Customer {
  final int id;
  final String username;
  final String email;
  final String userType;
  final String? phone;

  Customer({
    required this.id,
    required this.username,
    required this.email,
    required this.userType,
    this.phone,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      userType: json['user_type'] as String,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'user_type': userType,
      'phone': phone,
    };
  }
}

class ProductInfo {
  final int id;
  final String name;
  final String shortDescription;
  final double price;
  final double? discountPrice;
  final String? discountEndDate;
  final int stock;
  final bool isActive;
  final int storeId;
  final int categoryId;
  final List<ProductImage> images;

  ProductInfo({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.price,
    this.discountPrice,
    this.discountEndDate,
    required this.stock,
    required this.isActive,
    required this.storeId,
    required this.categoryId,
    required this.images,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    return ProductInfo(
      id: json['id'] as int,
      name: json['name'] as String,
      shortDescription: json['short_description'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: json['discount_price'] != null
          ? (json['discount_price'] as num).toDouble()
          : null,
      discountEndDate: json['discount_end_date'] as String?,
      stock: json['stock'] as int,
      isActive: json['is_active'] as bool,
      storeId: json['store_id'] as int,
      categoryId: json['category_id'] as int,
      images: (json['images'] as List<dynamic>)
          .map((img) => ProductImage.fromJson(img as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'short_description': shortDescription,
      'price': price,
      'discount_price': discountPrice,
      'discount_end_date': discountEndDate,
      'stock': stock,
      'is_active': isActive,
      'store_id': storeId,
      'category_id': categoryId,
      'images': images.map((img) => img.toJson()).toList(),
    };
  }

  String? get imageUrl => images.isNotEmpty ? images.first.imageUrl : null;
  double get effectivePrice => discountPrice ?? price;
}

class ProductImage {
  final int id;
  final String imageUrl;

  ProductImage({required this.id, required this.imageUrl});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] as int,
      imageUrl: json['image_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'image_url': imageUrl};
  }
}
