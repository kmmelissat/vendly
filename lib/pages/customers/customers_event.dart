abstract class CustomersEvent {}

/// Event to load all customers for a store
class LoadCustomers extends CustomersEvent {
  final int storeId;
  final bool includeOrderStats;

  LoadCustomers({
    required this.storeId,
    this.includeOrderStats = true,
  });
}

/// Event to search customers
class SearchCustomers extends CustomersEvent {
  final String query;

  SearchCustomers({required this.query});
}

/// Event to filter customers by status
class FilterCustomersByStatus extends CustomersEvent {
  final String? status; // All, VIP, Regular, New

  FilterCustomersByStatus({this.status});
}

/// Event to sort customers
class SortCustomers extends CustomersEvent {
  final String sortBy; // Recent, Name A-Z, Name Z-A, Orders High-Low, Orders Low-High

  SortCustomers({required this.sortBy});
}

/// Event to refresh customers list
class RefreshCustomers extends CustomersEvent {
  final int storeId;
  final bool includeOrderStats;

  RefreshCustomers({
    required this.storeId,
    this.includeOrderStats = true,
  });
}

/// Event to load a specific customer details
class LoadCustomerDetails extends CustomersEvent {
  final int customerId;

  LoadCustomerDetails({required this.customerId});
}

/// Event to update customer information
class UpdateCustomer extends CustomersEvent {
  final int customerId;
  final Map<String, dynamic> updates;

  UpdateCustomer({
    required this.customerId,
    required this.updates,
  });
}

/// Event to delete a customer
class DeleteCustomer extends CustomersEvent {
  final int customerId;

  DeleteCustomer({required this.customerId});
}

