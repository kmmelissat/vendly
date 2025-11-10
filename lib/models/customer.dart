class Customer {
  final int id;
  final String username;
  final String email;
  final String userType;
  final String? phone;
  final String? preferredPaymentMethod;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? totalOrders;
  final double? totalSpent;
  final DateTime? lastOrderDate;

  Customer({
    required this.id,
    required this.username,
    required this.email,
    required this.userType,
    this.phone,
    this.preferredPaymentMethod,
    required this.createdAt,
    required this.updatedAt,
    this.totalOrders,
    this.totalSpent,
    this.lastOrderDate,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      userType: json['user_type'] as String,
      phone: json['phone'] as String?,
      preferredPaymentMethod: json['preferred_payment_method'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      totalOrders: json['total_orders'] as int?,
      totalSpent: json['total_spent'] != null
          ? (json['total_spent'] as num).toDouble()
          : null,
      lastOrderDate: json['last_order_date'] != null
          ? DateTime.parse(json['last_order_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'user_type': userType,
      'phone': phone,
      'preferred_payment_method': preferredPaymentMethod,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'total_orders': totalOrders,
      'total_spent': totalSpent,
      'last_order_date': lastOrderDate?.toIso8601String(),
    };
  }

  // Helper method to convert to legacy format for UI compatibility
  Map<String, dynamic> toLegacyFormat() {
    return {
      'id': 'CUST-${id.toString().padLeft(3, '0')}',
      'name': username,
      'email': email,
      'phone': phone ?? 'N/A',
      'avatar': 'assets/images/customers/customer1.jpg', // Default avatar
      'totalOrders': totalOrders ?? 0,
      'totalSpent': totalSpent ?? 0.0,
      'lastOrder': lastOrderDate?.toIso8601String() ?? createdAt.toIso8601String(),
      'status': _determineStatus(),
      'joinDate': createdAt.toIso8601String(),
      'favoriteProducts': <String>[], // Empty for now
      'address': 'N/A',
    };
  }

  String _determineStatus() {
    if (totalOrders == null || totalOrders == 0) {
      return 'New';
    } else if (totalOrders! >= 10 || (totalSpent != null && totalSpent! >= 500)) {
      return 'VIP';
    } else {
      return 'Regular';
    }
  }

  // Getters for convenience
  String get displayName => username;
  String get displayPhone => phone ?? 'No phone';
  int get ordersCount => totalOrders ?? 0;
  double get spentAmount => totalSpent ?? 0.0;
  String get status => _determineStatus();
}

