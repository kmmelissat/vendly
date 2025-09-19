import 'package:uuid/uuid.dart';

enum StoreStatus { pending, active, suspended, closed }

class Store {
  final String id;
  final String sellerId;
  final String name;
  final String description;
  final String? logoUrl;
  final String? bannerUrl;
  final String category;
  final String address;
  final String? phoneNumber;
  final String? website;
  final StoreStatus status;
  final double rating;
  final int totalReviews;
  final int totalProducts;
  final int totalSales;
  final double totalRevenue;
  final DateTime createdAt;
  final DateTime updatedAt;

  Store({
    String? id,
    required this.sellerId,
    required this.name,
    required this.description,
    this.logoUrl,
    this.bannerUrl,
    required this.category,
    required this.address,
    this.phoneNumber,
    this.website,
    this.status = StoreStatus.pending,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.totalProducts = 0,
    this.totalSales = 0,
    this.totalRevenue = 0.0,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sellerId': sellerId,
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'bannerUrl': bannerUrl,
      'category': category,
      'address': address,
      'phoneNumber': phoneNumber,
      'website': website,
      'status': status.name,
      'rating': rating,
      'totalReviews': totalReviews,
      'totalProducts': totalProducts,
      'totalSales': totalSales,
      'totalRevenue': totalRevenue,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['id'],
      sellerId: map['sellerId'],
      name: map['name'],
      description: map['description'],
      logoUrl: map['logoUrl'],
      bannerUrl: map['bannerUrl'],
      category: map['category'],
      address: map['address'],
      phoneNumber: map['phoneNumber'],
      website: map['website'],
      status: StoreStatus.values.firstWhere((e) => e.name == map['status']),
      rating: map['rating']?.toDouble() ?? 0.0,
      totalReviews: map['totalReviews'] ?? 0,
      totalProducts: map['totalProducts'] ?? 0,
      totalSales: map['totalSales'] ?? 0,
      totalRevenue: map['totalRevenue']?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Store copyWith({
    String? name,
    String? description,
    String? logoUrl,
    String? bannerUrl,
    String? category,
    String? address,
    String? phoneNumber,
    String? website,
    StoreStatus? status,
    double? rating,
    int? totalReviews,
    int? totalProducts,
    int? totalSales,
    double? totalRevenue,
  }) {
    return Store(
      id: id,
      sellerId: sellerId,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      category: category ?? this.category,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalProducts: totalProducts ?? this.totalProducts,
      totalSales: totalSales ?? this.totalSales,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Store{id: $id, name: $name, status: $status, rating: $rating}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Store && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
