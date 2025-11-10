import '../../models/product.dart';

abstract class ProductsState {}

/// Initial state when the bloc is created
class ProductsInitial extends ProductsState {}

/// State when products are being loaded
class ProductsLoading extends ProductsState {}

/// State when products are successfully loaded
class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final String searchQuery;

  ProductsLoaded({
    required this.products,
    this.searchQuery = '',
  });

  /// Get filtered products based on search query
  List<Product> get filteredProducts {
    if (searchQuery.isEmpty) {
      return products;
    }
    return products.where((product) {
      return product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  /// Create a copy with updated values
  ProductsLoaded copyWith({
    List<Product>? products,
    String? searchQuery,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// State when a product operation fails
class ProductsError extends ProductsState {
  final String message;
  final List<Product>? products; // Keep products if available

  ProductsError({
    required this.message,
    this.products,
  });
}

/// State when a product is being added
class ProductAdding extends ProductsState {
  final List<Product> currentProducts;

  ProductAdding({required this.currentProducts});
}

/// State when a product is successfully added
class ProductAdded extends ProductsState {
  final Product product;
  final List<Product> allProducts;

  ProductAdded({
    required this.product,
    required this.allProducts,
  });
}

/// State when a product is being updated
class ProductUpdating extends ProductsState {
  final int productId;
  final List<Product> currentProducts;

  ProductUpdating({
    required this.productId,
    required this.currentProducts,
  });
}

/// State when a product is successfully updated
class ProductUpdated extends ProductsState {
  final Product product;
  final List<Product> allProducts;

  ProductUpdated({
    required this.product,
    required this.allProducts,
  });
}

/// State when a product is being deleted
class ProductDeleting extends ProductsState {
  final int productId;
  final List<Product> currentProducts;

  ProductDeleting({
    required this.productId,
    required this.currentProducts,
  });
}

/// State when a product is successfully deleted
class ProductDeleted extends ProductsState {
  final int productId;
  final List<Product> allProducts;

  ProductDeleted({
    required this.productId,
    required this.allProducts,
  });
}

