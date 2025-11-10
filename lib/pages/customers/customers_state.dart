import '../../models/customer.dart';

abstract class CustomersState {}

/// Initial state when the bloc is created
class CustomersInitial extends CustomersState {}

/// State when customers are being loaded
class CustomersLoading extends CustomersState {}

/// State when customers are successfully loaded
class CustomersLoaded extends CustomersState {
  final List<Customer> customers;
  final String searchQuery;
  final String? statusFilter;
  final String sortBy;

  CustomersLoaded({
    required this.customers,
    this.searchQuery = '',
    this.statusFilter,
    this.sortBy = 'Recent',
  });

  /// Get filtered and sorted customers
  List<Customer> get filteredCustomers {
    var filtered = customers;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((customer) {
        final query = searchQuery.toLowerCase();
        return customer.username.toLowerCase().contains(query) ||
            customer.email.toLowerCase().contains(query) ||
            (customer.phone?.contains(query) ?? false);
      }).toList();
    }

    // Apply status filter
    if (statusFilter != null && statusFilter != 'All') {
      filtered = filtered.where((customer) {
        return customer.status == statusFilter;
      }).toList();
    }

    // Apply sorting
    switch (sortBy) {
      case 'Name A-Z':
        filtered.sort((a, b) => a.username.compareTo(b.username));
        break;
      case 'Name Z-A':
        filtered.sort((a, b) => b.username.compareTo(a.username));
        break;
      case 'Orders High-Low':
        filtered.sort((a, b) => (b.totalOrders ?? 0).compareTo(a.totalOrders ?? 0));
        break;
      case 'Orders Low-High':
        filtered.sort((a, b) => (a.totalOrders ?? 0).compareTo(b.totalOrders ?? 0));
        break;
      case 'Recent':
      default:
        filtered.sort((a, b) {
          final aDate = a.lastOrderDate ?? DateTime(1970);
          final bDate = b.lastOrderDate ?? DateTime(1970);
          return bDate.compareTo(aDate);
        });
        break;
    }

    return filtered;
  }

  /// Create a copy with updated values
  CustomersLoaded copyWith({
    List<Customer>? customers,
    String? searchQuery,
    String? statusFilter,
    String? sortBy,
  }) {
    return CustomersLoaded(
      customers: customers ?? this.customers,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

/// State when a customer operation fails
class CustomersError extends CustomersState {
  final String message;
  final List<Customer>? customers; // Keep customers if available

  CustomersError({
    required this.message,
    this.customers,
  });
}

/// State when loading customer details
class CustomerDetailsLoading extends CustomersState {
  final int customerId;

  CustomerDetailsLoading({required this.customerId});
}

/// State when customer details are loaded
class CustomerDetailsLoaded extends CustomersState {
  final Customer customer;

  CustomerDetailsLoaded({required this.customer});
}

/// State when a customer is being updated
class CustomerUpdating extends CustomersState {
  final int customerId;
  final List<Customer> currentCustomers;

  CustomerUpdating({
    required this.customerId,
    required this.currentCustomers,
  });
}

/// State when a customer is successfully updated
class CustomerUpdated extends CustomersState {
  final Customer customer;
  final List<Customer> allCustomers;

  CustomerUpdated({
    required this.customer,
    required this.allCustomers,
  });
}

/// State when a customer is being deleted
class CustomerDeleting extends CustomersState {
  final int customerId;
  final List<Customer> currentCustomers;

  CustomerDeleting({
    required this.customerId,
    required this.currentCustomers,
  });
}

/// State when a customer is successfully deleted
class CustomerDeleted extends CustomersState {
  final int customerId;
  final List<Customer> allCustomers;

  CustomerDeleted({
    required this.customerId,
    required this.allCustomers,
  });
}

