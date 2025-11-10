import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/products_service.dart';
import '../../services/auth_service.dart';
import '../../models/product.dart';
import 'products_event.dart';
import 'products_state.dart';

/// ProductsBloc manages the state of products using the BLoC pattern.
///
/// This bloc handles all product-related events (load, add, update, delete, search)
/// and emits corresponding states that the UI can react to.
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsService _productsService;
  final AuthService _authService;

  ProductsBloc({
    required ProductsService productsService,
    required AuthService authService,
  }) : _productsService = productsService,
       _authService = authService,
       super(ProductsInitial()) {
    // Register event handlers
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<ToggleProductStock>(_onToggleProductStock);
    on<RefreshProducts>(_onRefreshProducts);
  }

  /// Handles the LoadProducts event
  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final products = await _productsService.getStoreProducts(event.storeId);
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  /// Handles the SearchProducts event
  void _onSearchProducts(SearchProducts event, Emitter<ProductsState> emit) {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      emit(currentState.copyWith(searchQuery: event.query));
    }
  }

  /// Handles the AddProduct event
  Future<void> _onAddProduct(
    AddProduct event,
    Emitter<ProductsState> emit,
  ) async {
    // Get current products if available
    List<Product> currentProducts = [];
    if (state is ProductsLoaded) {
      currentProducts = (state as ProductsLoaded).products;
    }

    emit(ProductAdding(currentProducts: currentProducts));

    try {
      // Get auth token from AuthService
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Authentication required. Please log in again.');
      }

      final productData = {
        'name': event.name,
        'short_description': event.description,
        'long_description': event.description,
        'price': event.price,
        'stock': event.stock,
        'category_id': event.categoryId,
        'store_id': event.storeId,
        'is_active': true,
        'tags': [],
      };

      final newProduct = await _productsService.createProduct(
        productData,
        token,
      );

      // Reload products to get fresh data
      final updatedProducts = await _productsService.getStoreProducts(
        event.storeId,
      );

      emit(ProductAdded(product: newProduct, allProducts: updatedProducts));

      // Transition to loaded state
      emit(ProductsLoaded(products: updatedProducts));
    } catch (e) {
      emit(
        ProductsError(
          message: 'Failed to add product: ${e.toString()}',
          products: currentProducts,
        ),
      );

      // Return to loaded state if we had products
      if (currentProducts.isNotEmpty) {
        emit(ProductsLoaded(products: currentProducts));
      }
    }
  }

  /// Handles the UpdateProduct event
  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductsState> emit,
  ) async {
    // Get current products
    List<Product> currentProducts = [];
    if (state is ProductsLoaded) {
      currentProducts = (state as ProductsLoaded).products;
    }

    emit(
      ProductUpdating(
        productId: event.productId,
        currentProducts: currentProducts,
      ),
    );

    try {
      // Get auth token from AuthService
      final token = await _authService.getToken();
      if (token == null) {
        throw Exception('Authentication required. Please log in again.');
      }

      final productData = <String, dynamic>{};
      if (event.name != null) productData['name'] = event.name;
      if (event.description != null) {
        productData['short_description'] = event.description;
        productData['long_description'] = event.description;
      }
      if (event.price != null) productData['price'] = event.price;
      if (event.stock != null) productData['stock'] = event.stock;
      if (event.categoryId != null)
        productData['category_id'] = event.categoryId;

      final updatedProduct = await _productsService.updateProduct(
        event.productId,
        productData,
        token,
      );

      // Update the product in the list
      final updatedProducts = currentProducts.map((p) {
        return p.id == event.productId ? updatedProduct : p;
      }).toList();

      emit(
        ProductUpdated(product: updatedProduct, allProducts: updatedProducts),
      );

      // Transition to loaded state
      emit(ProductsLoaded(products: updatedProducts));
    } catch (e) {
      emit(
        ProductsError(
          message: 'Failed to update product: ${e.toString()}',
          products: currentProducts,
        ),
      );

      if (currentProducts.isNotEmpty) {
        emit(ProductsLoaded(products: currentProducts));
      }
    }
  }

  /// Handles the DeleteProduct event
  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductsState> emit,
  ) async {
    // Get current products
    List<Product> currentProducts = [];
    if (state is ProductsLoaded) {
      currentProducts = (state as ProductsLoaded).products;
    }

    emit(
      ProductDeleting(
        productId: event.productId,
        currentProducts: currentProducts,
      ),
    );

    try {
      await _productsService.deleteProduct(event.productId);

      // Remove the product from the list
      final updatedProducts = currentProducts
          .where((p) => p.id != event.productId)
          .toList();

      emit(
        ProductDeleted(
          productId: event.productId,
          allProducts: updatedProducts,
        ),
      );

      // Transition to loaded state
      emit(ProductsLoaded(products: updatedProducts));
    } catch (e) {
      emit(
        ProductsError(
          message: 'Failed to delete product: ${e.toString()}',
          products: currentProducts,
        ),
      );

      if (currentProducts.isNotEmpty) {
        emit(ProductsLoaded(products: currentProducts));
      }
    }
  }

  /// Handles the ToggleProductStock event
  Future<void> _onToggleProductStock(
    ToggleProductStock event,
    Emitter<ProductsState> emit,
  ) async {
    // Get current products
    List<Product> currentProducts = [];
    if (state is ProductsLoaded) {
      currentProducts = (state as ProductsLoaded).products;
    }

    try {
      // Update stock status (you may need to add this method to ProductsService)
      // For now, we'll just update locally
      final updatedProducts = currentProducts.map((p) {
        if (p.id == event.productId) {
          // Create a new product with updated stock
          return Product(
            id: p.id,
            name: p.name,
            shortDescription: p.shortDescription,
            longDescription: p.longDescription,
            price: p.price,
            stock: event.inStock ? p.stock : 0,
            isActive: event.inStock,
            categoryId: p.categoryId,
            storeId: p.storeId,
            images: p.images,
            tags: p.tags,
            createdAt: p.createdAt,
            updatedAt: DateTime.now(),
          );
        }
        return p;
      }).toList();

      emit(ProductsLoaded(products: updatedProducts));
    } catch (e) {
      emit(
        ProductsError(
          message: 'Failed to toggle stock: ${e.toString()}',
          products: currentProducts,
        ),
      );

      if (currentProducts.isNotEmpty) {
        emit(ProductsLoaded(products: currentProducts));
      }
    }
  }

  /// Handles the RefreshProducts event
  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductsState> emit,
  ) async {
    // Keep current products while refreshing
    List<Product> currentProducts = [];
    if (state is ProductsLoaded) {
      currentProducts = (state as ProductsLoaded).products;
    }

    try {
      final products = await _productsService.getStoreProducts(event.storeId);
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(
        ProductsError(
          message: 'Failed to refresh products: ${e.toString()}',
          products: currentProducts,
        ),
      );

      // Return to loaded state with old products if refresh fails
      if (currentProducts.isNotEmpty) {
        emit(ProductsLoaded(products: currentProducts));
      }
    }
  }
}
