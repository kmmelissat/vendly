import 'package:uuid/uuid.dart';

enum ProductStatus { draft, active, outOfStock, discontinued }

class Product {
  final String id;
  final String storeId;
  final String name;
  final String description;
  final List<String> imageUrls;
  final double price;
  final double? originalPrice;
  final String category;
  final List<String> tags;
  final int stockQuantity;
  final int minOrderQuantity;
  final ProductStatus status;
  final double rating;
  final int totalReviews;
  final int totalSales;
  final String? sku;
  final double? weight;
  final Map<String, String>? dimensions;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    String? id,
    required this.storeId,
    required this.name,
    required this.description,
    this.imageUrls = const [],
    required this.price,
    this.originalPrice,
    required this.category,
    this.tags = const [],
    this.stockQuantity = 0,
    this.minOrderQuantity = 1,
    this.status = ProductStatus.draft,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.totalSales = 0,
    this.sku,
    this.weight,
    this.dimensions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  bool get isOnSale => originalPrice != null && originalPrice! > price;

  double get discountPercentage {
    if (!isOnSale) return 0.0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }

  bool get isInStock => stockQuantity > 0 && status == ProductStatus.active;

  String get primaryImageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'storeId': storeId,
      'name': name,
      'description': description,
      'imageUrls': imageUrls.join(','),
      'price': price,
      'originalPrice': originalPrice,
      'category': category,
      'tags': tags.join(','),
      'stockQuantity': stockQuantity,
      'minOrderQuantity': minOrderQuantity,
      'status': status.name,
      'rating': rating,
      'totalReviews': totalReviews,
      'totalSales': totalSales,
      'sku': sku,
      'weight': weight,
      'dimensions': dimensions != null
          ? dimensions!.entries.map((e) => '${e.key}:${e.value}').join(',')
          : null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    Map<String, String>? parsedDimensions;
    if (map['dimensions'] != null && map['dimensions'].isNotEmpty) {
      final dimensionPairs = map['dimensions'].split(',');
      parsedDimensions = {};
      for (final pair in dimensionPairs) {
        final keyValue = pair.split(':');
        if (keyValue.length == 2) {
          parsedDimensions[keyValue[0]] = keyValue[1];
        }
      }
    }

    return Product(
      id: map['id'],
      storeId: map['storeId'],
      name: map['name'],
      description: map['description'],
      imageUrls: map['imageUrls']?.isNotEmpty == true
          ? map['imageUrls'].split(',')
          : <String>[],
      price: map['price']?.toDouble() ?? 0.0,
      originalPrice: map['originalPrice']?.toDouble(),
      category: map['category'],
      tags: map['tags']?.isNotEmpty == true
          ? map['tags'].split(',')
          : <String>[],
      stockQuantity: map['stockQuantity'] ?? 0,
      minOrderQuantity: map['minOrderQuantity'] ?? 1,
      status: ProductStatus.values.firstWhere((e) => e.name == map['status']),
      rating: map['rating']?.toDouble() ?? 0.0,
      totalReviews: map['totalReviews'] ?? 0,
      totalSales: map['totalSales'] ?? 0,
      sku: map['sku'],
      weight: map['weight']?.toDouble(),
      dimensions: parsedDimensions,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Product copyWith({
    String? name,
    String? description,
    List<String>? imageUrls,
    double? price,
    double? originalPrice,
    String? category,
    List<String>? tags,
    int? stockQuantity,
    int? minOrderQuantity,
    ProductStatus? status,
    double? rating,
    int? totalReviews,
    int? totalSales,
    String? sku,
    double? weight,
    Map<String, String>? dimensions,
  }) {
    return Product(
      id: id,
      storeId: storeId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      minOrderQuantity: minOrderQuantity ?? this.minOrderQuantity,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalSales: totalSales ?? this.totalSales,
      sku: sku ?? this.sku,
      weight: weight ?? this.weight,
      dimensions: dimensions ?? this.dimensions,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, status: $status}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
