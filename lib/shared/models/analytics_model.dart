class SalesData {
  final DateTime date;
  final double revenue;
  final int orders;
  final int products;

  SalesData({
    required this.date,
    required this.revenue,
    required this.orders,
    required this.products,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'revenue': revenue,
      'orders': orders,
      'products': products,
    };
  }

  factory SalesData.fromMap(Map<String, dynamic> map) {
    return SalesData(
      date: DateTime.parse(map['date']),
      revenue: map['revenue']?.toDouble() ?? 0.0,
      orders: map['orders'] ?? 0,
      products: map['products'] ?? 0,
    );
  }
}

class ProductAnalytics {
  final String productId;
  final String productName;
  final String productImageUrl;
  final int totalSales;
  final double totalRevenue;
  final int views;
  final int favorites;
  final double conversionRate;

  ProductAnalytics({
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.totalSales,
    required this.totalRevenue,
    required this.views,
    required this.favorites,
  }) : conversionRate = views > 0 ? (totalSales / views) * 100 : 0.0;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImageUrl': productImageUrl,
      'totalSales': totalSales,
      'totalRevenue': totalRevenue,
      'views': views,
      'favorites': favorites,
      'conversionRate': conversionRate,
    };
  }

  factory ProductAnalytics.fromMap(Map<String, dynamic> map) {
    return ProductAnalytics(
      productId: map['productId'],
      productName: map['productName'],
      productImageUrl: map['productImageUrl'],
      totalSales: map['totalSales'] ?? 0,
      totalRevenue: map['totalRevenue']?.toDouble() ?? 0.0,
      views: map['views'] ?? 0,
      favorites: map['favorites'] ?? 0,
    );
  }
}

class CustomerData {
  final String customerId;
  final String customerName;
  final String customerEmail;
  final int totalOrders;
  final double totalSpent;
  final DateTime lastOrderDate;
  final DateTime firstOrderDate;

  CustomerData({
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.totalOrders,
    required this.totalSpent,
    required this.lastOrderDate,
    required this.firstOrderDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'totalOrders': totalOrders,
      'totalSpent': totalSpent,
      'lastOrderDate': lastOrderDate.toIso8601String(),
      'firstOrderDate': firstOrderDate.toIso8601String(),
    };
  }

  factory CustomerData.fromMap(Map<String, dynamic> map) {
    return CustomerData(
      customerId: map['customerId'],
      customerName: map['customerName'],
      customerEmail: map['customerEmail'],
      totalOrders: map['totalOrders'] ?? 0,
      totalSpent: map['totalSpent']?.toDouble() ?? 0.0,
      lastOrderDate: DateTime.parse(map['lastOrderDate']),
      firstOrderDate: DateTime.parse(map['firstOrderDate']),
    );
  }
}

class StoreAnalytics {
  final String storeId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final double totalRevenue;
  final double totalDeliveryCosts;
  final double netProfit;
  final int totalOrders;
  final int totalProducts;
  final int totalCustomers;
  final double averageOrderValue;
  final List<SalesData> dailySales;
  final List<ProductAnalytics> topProducts;
  final List<CustomerData> topCustomers;

  StoreAnalytics({
    required this.storeId,
    required this.periodStart,
    required this.periodEnd,
    required this.totalRevenue,
    required this.totalDeliveryCosts,
    required this.totalOrders,
    required this.totalProducts,
    required this.totalCustomers,
    required this.dailySales,
    required this.topProducts,
    required this.topCustomers,
  }) : netProfit = totalRevenue - totalDeliveryCosts,
       averageOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0.0;

  Map<String, dynamic> toMap() {
    return {
      'storeId': storeId,
      'periodStart': periodStart.toIso8601String(),
      'periodEnd': periodEnd.toIso8601String(),
      'totalRevenue': totalRevenue,
      'totalDeliveryCosts': totalDeliveryCosts,
      'netProfit': netProfit,
      'totalOrders': totalOrders,
      'totalProducts': totalProducts,
      'totalCustomers': totalCustomers,
      'averageOrderValue': averageOrderValue,
      'dailySales': dailySales.map((data) => data.toMap()).toList(),
      'topProducts': topProducts.map((product) => product.toMap()).toList(),
      'topCustomers': topCustomers.map((customer) => customer.toMap()).toList(),
    };
  }

  factory StoreAnalytics.fromMap(Map<String, dynamic> map) {
    final dailySalesList = map['dailySales'] as List<dynamic>? ?? [];
    final topProductsList = map['topProducts'] as List<dynamic>? ?? [];
    final topCustomersList = map['topCustomers'] as List<dynamic>? ?? [];

    return StoreAnalytics(
      storeId: map['storeId'],
      periodStart: DateTime.parse(map['periodStart']),
      periodEnd: DateTime.parse(map['periodEnd']),
      totalRevenue: map['totalRevenue']?.toDouble() ?? 0.0,
      totalDeliveryCosts: map['totalDeliveryCosts']?.toDouble() ?? 0.0,
      totalOrders: map['totalOrders'] ?? 0,
      totalProducts: map['totalProducts'] ?? 0,
      totalCustomers: map['totalCustomers'] ?? 0,
      dailySales: dailySalesList
          .map((data) => SalesData.fromMap(data as Map<String, dynamic>))
          .toList(),
      topProducts: topProductsList
          .map(
            (product) =>
                ProductAnalytics.fromMap(product as Map<String, dynamic>),
          )
          .toList(),
      topCustomers: topCustomersList
          .map(
            (customer) =>
                CustomerData.fromMap(customer as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
