class Product {
  final int id;
  final String name;
  final String shortDescription;
  final String longDescription;
  final double price;
  final int stock;
  final bool isActive;
  final int storeId;
  final int categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ProductTag> tags;
  final List<String> images;

  Product({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.longDescription,
    required this.price,
    required this.stock,
    required this.isActive,
    required this.storeId,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.tags,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      shortDescription: json['short_description'] as String,
      longDescription: json['long_description'] as String,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      isActive: json['is_active'] as bool,
      storeId: json['store_id'] as int,
      categoryId: json['category_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      tags: (json['tags'] as List<dynamic>)
          .map((tag) => ProductTag.fromJson(tag as Map<String, dynamic>))
          .toList(),
      images: (json['images'] as List<dynamic>)
          .map((image) => image as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'short_description': shortDescription,
      'long_description': longDescription,
      'price': price,
      'stock': stock,
      'is_active': isActive,
      'store_id': storeId,
      'category_id': categoryId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'tags': tags.map((tag) => tag.toJson()).toList(),
      'images': images,
    };
  }

  // Helper getters for compatibility with existing UI
  bool get inStock => stock > 0 && isActive;
  String get description => shortDescription;
  String get detailedDescription => longDescription;
  String get image => images.isNotEmpty ? images.first : '';

  int get stockQuantity => stock;

  // For backward compatibility with existing product structure
  Map<String, dynamic> toLegacyFormat() {
    return {
      'id': id.toString(),
      'name': name,
      'price': price,
      'originalPrice': null, // API doesn't provide original price
      'image': image,
      'category': 'Product', // Default category
      'brand': 'Store Brand', // Default brand
      'sku': 'SKU-$id', // Generate SKU from ID
      'description': shortDescription,
      'detailedDescription': longDescription,
      'inStock': inStock,
      'stockQuantity': stock,
      'rating': 4.5, // Default rating
      'reviews': 0, // Default reviews count
      'dimensions': null,
      'weight': null,
      'material': null,
      'ageRange': null,
      'origin': null,
      'tags': tags.map((tag) => tag.name).toList(),
      'features': [], // Empty features list
    };
  }
}

class ProductTag {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductTag({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductTag.fromJson(Map<String, dynamic> json) {
    return ProductTag(
      id: json['id'] as int,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
