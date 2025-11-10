abstract class OrdersEvent {}

/// Event to load all orders for a store
class LoadOrders extends OrdersEvent {
  final int storeId;

  LoadOrders({required this.storeId});
}

/// Event to filter orders by status
class FilterOrdersByStatus extends OrdersEvent {
  final String? status;

  FilterOrdersByStatus({this.status});
}

/// Event to search orders
class SearchOrders extends OrdersEvent {
  final String query;

  SearchOrders({required this.query});
}

/// Event to update order status
class UpdateOrderStatus extends OrdersEvent {
  final String orderId;
  final String newStatus;

  UpdateOrderStatus({
    required this.orderId,
    required this.newStatus,
  });
}

/// Event to create a new order
class CreateOrder extends OrdersEvent {
  final int customerId;
  final List<Map<String, dynamic>> items;
  final String? notes;

  CreateOrder({
    required this.customerId,
    required this.items,
    this.notes,
  });
}

/// Event to delete an order
class DeleteOrder extends OrdersEvent {
  final String orderId;

  DeleteOrder({required this.orderId});
}

/// Event to refresh orders list
class RefreshOrders extends OrdersEvent {
  final int storeId;

  RefreshOrders({required this.storeId});
}

/// Event to load a specific order details
class LoadOrderDetails extends OrdersEvent {
  final String orderId;

  LoadOrderDetails({required this.orderId});
}

