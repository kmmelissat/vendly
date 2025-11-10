import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/orders_service.dart';
import '../../services/auth_service.dart';
import '../../models/order.dart';
import 'orders_event.dart';
import 'orders_state.dart';

/// OrdersBloc manages the state of orders using the BLoC pattern.
///
/// This bloc handles all order-related events (load, filter, create, update, delete)
/// and emits corresponding states that the UI can react to.
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersService _ordersService;
  // ignore: unused_field
  final AuthService _authService; // Reserved for future use with create/delete operations

  OrdersBloc({
    required OrdersService ordersService,
    required AuthService authService,
  })  : _ordersService = ordersService,
        _authService = authService,
        super(OrdersInitial()) {
    // Register event handlers
    on<LoadOrders>(_onLoadOrders);
    on<FilterOrdersByStatus>(_onFilterOrdersByStatus);
    on<SearchOrders>(_onSearchOrders);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<CreateOrder>(_onCreateOrder);
    on<DeleteOrder>(_onDeleteOrder);
    on<RefreshOrders>(_onRefreshOrders);
    on<LoadOrderDetails>(_onLoadOrderDetails);
  }

  /// Handles the LoadOrders event
  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      final orders = await _ordersService.getOrders(
        storeId: event.storeId.toString(),
      );
      emit(OrdersLoaded(orders: orders));
    } catch (e) {
      emit(OrdersError(message: e.toString()));
    }
  }

  /// Handles the FilterOrdersByStatus event
  void _onFilterOrdersByStatus(
    FilterOrdersByStatus event,
    Emitter<OrdersState> emit,
  ) {
    if (state is OrdersLoaded) {
      final currentState = state as OrdersLoaded;
      emit(currentState.copyWith(statusFilter: event.status));
    }
  }

  /// Handles the SearchOrders event
  void _onSearchOrders(
    SearchOrders event,
    Emitter<OrdersState> emit,
  ) {
    if (state is OrdersLoaded) {
      final currentState = state as OrdersLoaded;
      emit(currentState.copyWith(searchQuery: event.query));
    }
  }

  /// Handles the UpdateOrderStatus event
  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrdersState> emit,
  ) async {
    // Get current orders
    List<Order> currentOrders = [];
    if (state is OrdersLoaded) {
      currentOrders = (state as OrdersLoaded).orders;
    }

    emit(
      OrderStatusUpdating(
        orderId: event.orderId,
        currentOrders: currentOrders,
      ),
    );

    try {
      final success = await _ordersService.updateOrderStatus(
        orderId: event.orderId,
        status: event.newStatus,
      );

      if (!success) {
        throw Exception('Failed to update order status');
      }

      // Update the order in the list
      final updatedOrders = currentOrders.map((o) {
        if (o.id.toString() == event.orderId) {
          // Create updated order with new status
          return Order(
            id: o.id,
            orderNumber: o.orderNumber,
            customerId: o.customerId,
            customer: o.customer,
            totalAmount: o.totalAmount,
            status: event.newStatus,
            createdAt: o.createdAt,
            updatedAt: DateTime.now(),
            shippedAt: o.shippedAt,
            deliveredAt: o.deliveredAt,
            canceledAt: o.canceledAt,
            shippingAddress: o.shippingAddress,
            shippingCity: o.shippingCity,
            shippingPostalCode: o.shippingPostalCode,
            shippingCountry: o.shippingCountry,
            products: o.products,
          );
        }
        return o;
      }).toList();

      final updatedOrder = updatedOrders.firstWhere(
        (o) => o.id.toString() == event.orderId,
      );

      emit(
        OrderStatusUpdated(
          order: updatedOrder,
          allOrders: updatedOrders,
        ),
      );

      // Transition to loaded state
      emit(OrdersLoaded(orders: updatedOrders));
    } catch (e) {
      emit(
        OrdersError(
          message: 'Failed to update order status: ${e.toString()}',
          orders: currentOrders,
        ),
      );

      if (currentOrders.isNotEmpty) {
        emit(OrdersLoaded(orders: currentOrders));
      }
    }
  }

  /// Handles the CreateOrder event
  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrdersState> emit,
  ) async {
    // Get current orders if available
    List<Order> currentOrders = [];
    if (state is OrdersLoaded) {
      currentOrders = (state as OrdersLoaded).orders;
    }

    emit(OrderCreating(currentOrders: currentOrders));

    try {
      // Note: OrdersService doesn't have createOrder method yet
      // This is a placeholder for future implementation
      throw UnimplementedError('Create order functionality not yet implemented in OrdersService');

      // When implemented, it should look like:
      // final newOrder = await _ordersService.createOrder(...);
      // final updatedOrders = [newOrder, ...currentOrders];

      // emit(
      //   OrderCreated(
      //     order: newOrder,
      //     allOrders: updatedOrders,
      //   ),
      // );

      // // Transition to loaded state
      // emit(OrdersLoaded(orders: updatedOrders));
    } catch (e) {
      emit(
        OrdersError(
          message: 'Failed to create order: ${e.toString()}',
          orders: currentOrders,
        ),
      );

      if (currentOrders.isNotEmpty) {
        emit(OrdersLoaded(orders: currentOrders));
      }
    }
  }

  /// Handles the DeleteOrder event
  Future<void> _onDeleteOrder(
    DeleteOrder event,
    Emitter<OrdersState> emit,
  ) async {
    // Get current orders
    List<Order> currentOrders = [];
    if (state is OrdersLoaded) {
      currentOrders = (state as OrdersLoaded).orders;
    }

    emit(
      OrderDeleting(
        orderId: event.orderId,
        currentOrders: currentOrders,
      ),
    );

    try {
      // Note: OrdersService doesn't have deleteOrder method yet
      // This is a placeholder for future implementation
      throw UnimplementedError('Delete order functionality not yet implemented in OrdersService');

      // When implemented, it should look like:
      // await _ordersService.deleteOrder(orderId: event.orderId);
      // final updatedOrders = currentOrders.where((o) => o.id.toString() != event.orderId).toList();

      // emit(
      //   OrderDeleted(
      //     orderId: event.orderId,
      //     allOrders: updatedOrders,
      //   ),
      // );

      // // Transition to loaded state
      // emit(OrdersLoaded(orders: updatedOrders));
    } catch (e) {
      emit(
        OrdersError(
          message: 'Failed to delete order: ${e.toString()}',
          orders: currentOrders,
        ),
      );

      if (currentOrders.isNotEmpty) {
        emit(OrdersLoaded(orders: currentOrders));
      }
    }
  }

  /// Handles the RefreshOrders event
  Future<void> _onRefreshOrders(
    RefreshOrders event,
    Emitter<OrdersState> emit,
  ) async {
    // Keep current orders while refreshing
    List<Order> currentOrders = [];
    String? currentStatusFilter;
    String currentSearchQuery = '';

    if (state is OrdersLoaded) {
      final currentState = state as OrdersLoaded;
      currentOrders = currentState.orders;
      currentStatusFilter = currentState.statusFilter;
      currentSearchQuery = currentState.searchQuery;
    }

    try {
      final orders = await _ordersService.getOrders(
        storeId: event.storeId.toString(),
      );
      emit(
        OrdersLoaded(
          orders: orders,
          statusFilter: currentStatusFilter,
          searchQuery: currentSearchQuery,
        ),
      );
    } catch (e) {
      emit(
        OrdersError(
          message: 'Failed to refresh orders: ${e.toString()}',
          orders: currentOrders,
        ),
      );

      // Return to loaded state with old orders if refresh fails
      if (currentOrders.isNotEmpty) {
        emit(
          OrdersLoaded(
            orders: currentOrders,
            statusFilter: currentStatusFilter,
            searchQuery: currentSearchQuery,
          ),
        );
      }
    }
  }

  /// Handles the LoadOrderDetails event
  Future<void> _onLoadOrderDetails(
    LoadOrderDetails event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrderDetailsLoading(orderId: event.orderId));

    try {
      final order = await _ordersService.getOrderDetails(event.orderId);
      if (order != null) {
        emit(OrderDetailsLoaded(order: order));
      } else {
        emit(OrdersError(message: 'Order not found'));
      }
    } catch (e) {
      emit(OrdersError(message: 'Failed to load order details: ${e.toString()}'));
    }
  }
}

