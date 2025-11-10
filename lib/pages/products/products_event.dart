abstract class ProductsEvent {}

/// Event to load all products for a store
class LoadProducts extends ProductsEvent {
  final int storeId;

  LoadProducts({required this.storeId});
}

/// Event to search/filter products
class SearchProducts extends ProductsEvent {
  final String query;

  SearchProducts({required this.query});
}

/// Event to add a new product
class AddProduct extends ProductsEvent {
  final String name;
  final String description;
  final double price;
  final int stock;
  final int categoryId;
  final int storeId;
  final List<String>? imagePaths;

  AddProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.categoryId,
    required this.storeId,
    this.imagePaths,
  });
}

/// Event to update an existing product
class UpdateProduct extends ProductsEvent {
  final int productId;
  final String? name;
  final String? description;
  final double? price;
  final int? stock;
  final int? categoryId;
  final List<String>? imagePaths;

  UpdateProduct({
    required this.productId,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.categoryId,
    this.imagePaths,
  });
}

/// Event to delete a product
class DeleteProduct extends ProductsEvent {
  final int productId;

  DeleteProduct({required this.productId});
}

/// Event to toggle product stock status
class ToggleProductStock extends ProductsEvent {
  final int productId;
  final bool inStock;

  ToggleProductStock({required this.productId, required this.inStock});
}

/// Event to refresh products list
class RefreshProducts extends ProductsEvent {
  final int storeId;

  RefreshProducts({required this.storeId});
}
