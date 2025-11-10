import '../../models/order.dart';

abstract class OrdersState {}

/// Initial state when the bloc is created
class OrdersInitial extends OrdersState {}

/// State when orders are being loaded
class OrdersLoading extends OrdersState {}

/// State when orders are successfully loaded
class OrdersLoaded extends OrdersState {
  final List<Order> orders;
  final String? statusFilter;
  final String searchQuery;

  OrdersLoaded({
    required this.orders,
    this.statusFilter,
    this.searchQuery = '',
  });

  /// Get filtered orders based on status and search query
  List<Order> get filteredOrders {
    var filtered = orders;

    // Filter by status
    if (statusFilter != null && statusFilter!.isNotEmpty) {
      filtered = filtered.where((order) {
        return order.status.toLowerCase() == statusFilter!.toLowerCase();
      }).toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((order) {
        final query = searchQuery.toLowerCase();
        return order.id.toString().contains(query) ||
            order.orderNumber.toLowerCase().contains(query) ||
            (order.customer?.username.toLowerCase().contains(query) ?? false) ||
            (order.customer?.email.toLowerCase().contains(query) ?? false) ||
            order.status.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  /// Create a copy with updated values
  OrdersLoaded copyWith({
    List<Order>? orders,
    String? statusFilter,
    String? searchQuery,
  }) {
    return OrdersLoaded(
      orders: orders ?? this.orders,
      statusFilter: statusFilter ?? this.statusFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// State when an order operation fails
class OrdersError extends OrdersState {
  final String message;
  final List<Order>? orders; // Keep orders if available

  OrdersError({
    required this.message,
    this.orders,
  });
}

/// State when an order is being created
class OrderCreating extends OrdersState {
  final List<Order> currentOrders;

  OrderCreating({required this.currentOrders});
}

/// State when an order is successfully created
class OrderCreated extends OrdersState {
  final Order order;
  final List<Order> allOrders;

  OrderCreated({
    required this.order,
    required this.allOrders,
  });
}

/// State when an order status is being updated
class OrderStatusUpdating extends OrdersState {
  final String orderId;
  final List<Order> currentOrders;

  OrderStatusUpdating({
    required this.orderId,
    required this.currentOrders,
  });
}

/// State when an order status is successfully updated
class OrderStatusUpdated extends OrdersState {
  final Order order;
  final List<Order> allOrders;

  OrderStatusUpdated({
    required this.order,
    required this.allOrders,
  });
}

/// State when an order is being deleted
class OrderDeleting extends OrdersState {
  final String orderId;
  final List<Order> currentOrders;

  OrderDeleting({
    required this.orderId,
    required this.currentOrders,
  });
}

/// State when an order is successfully deleted
class OrderDeleted extends OrdersState {
  final String orderId;
  final List<Order> allOrders;

  OrderDeleted({
    required this.orderId,
    required this.allOrders,
  });
}

/// State when loading order details
class OrderDetailsLoading extends OrdersState {
  final String orderId;

  OrderDetailsLoading({required this.orderId});
}

/// State when order details are loaded
class OrderDetailsLoaded extends OrdersState {
  final Order order;

  OrderDetailsLoaded({required this.order});
}

