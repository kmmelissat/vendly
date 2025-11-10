import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/customers_service.dart';
import '../../services/auth_service.dart';
import '../../models/customer.dart';
import 'customers_event.dart';
import 'customers_state.dart';

/// CustomersBloc manages the state of customers using the BLoC pattern.
///
/// This bloc handles all customer-related events (load, filter, search, sort, update, delete)
/// and emits corresponding states that the UI can react to.
class CustomersBloc extends Bloc<CustomersEvent, CustomersState> {
  final CustomersService _customersService;
  // ignore: unused_field
  final AuthService _authService; // Reserved for future use

  CustomersBloc({
    required CustomersService customersService,
    required AuthService authService,
  })  : _customersService = customersService,
        _authService = authService,
        super(CustomersInitial()) {
    // Register event handlers
    on<LoadCustomers>(_onLoadCustomers);
    on<SearchCustomers>(_onSearchCustomers);
    on<FilterCustomersByStatus>(_onFilterCustomersByStatus);
    on<SortCustomers>(_onSortCustomers);
    on<RefreshCustomers>(_onRefreshCustomers);
    on<LoadCustomerDetails>(_onLoadCustomerDetails);
    on<UpdateCustomer>(_onUpdateCustomer);
    on<DeleteCustomer>(_onDeleteCustomer);
  }

  /// Handles the LoadCustomers event
  Future<void> _onLoadCustomers(
    LoadCustomers event,
    Emitter<CustomersState> emit,
  ) async {
    emit(CustomersLoading());
    try {
      final customers = await _customersService.getCustomers(
        storeId: event.storeId,
        includeOrderStats: event.includeOrderStats,
      );
      emit(CustomersLoaded(customers: customers));
    } catch (e) {
      emit(CustomersError(message: e.toString()));
    }
  }

  /// Handles the SearchCustomers event
  void _onSearchCustomers(
    SearchCustomers event,
    Emitter<CustomersState> emit,
  ) {
    if (state is CustomersLoaded) {
      final currentState = state as CustomersLoaded;
      emit(currentState.copyWith(searchQuery: event.query));
    }
  }

  /// Handles the FilterCustomersByStatus event
  void _onFilterCustomersByStatus(
    FilterCustomersByStatus event,
    Emitter<CustomersState> emit,
  ) {
    if (state is CustomersLoaded) {
      final currentState = state as CustomersLoaded;
      emit(currentState.copyWith(statusFilter: event.status));
    }
  }

  /// Handles the SortCustomers event
  void _onSortCustomers(
    SortCustomers event,
    Emitter<CustomersState> emit,
  ) {
    if (state is CustomersLoaded) {
      final currentState = state as CustomersLoaded;
      emit(currentState.copyWith(sortBy: event.sortBy));
    }
  }

  /// Handles the RefreshCustomers event
  Future<void> _onRefreshCustomers(
    RefreshCustomers event,
    Emitter<CustomersState> emit,
  ) async {
    // Keep current state while refreshing
    List<Customer> currentCustomers = [];
    String currentSearchQuery = '';
    String? currentStatusFilter;
    String currentSortBy = 'Recent';

    if (state is CustomersLoaded) {
      final currentState = state as CustomersLoaded;
      currentCustomers = currentState.customers;
      currentSearchQuery = currentState.searchQuery;
      currentStatusFilter = currentState.statusFilter;
      currentSortBy = currentState.sortBy;
    }

    try {
      final customers = await _customersService.getCustomers(
        storeId: event.storeId,
        includeOrderStats: event.includeOrderStats,
      );
      emit(
        CustomersLoaded(
          customers: customers,
          searchQuery: currentSearchQuery,
          statusFilter: currentStatusFilter,
          sortBy: currentSortBy,
        ),
      );
    } catch (e) {
      emit(
        CustomersError(
          message: 'Failed to refresh customers: ${e.toString()}',
          customers: currentCustomers,
        ),
      );

      // Return to loaded state with old customers if refresh fails
      if (currentCustomers.isNotEmpty) {
        emit(
          CustomersLoaded(
            customers: currentCustomers,
            searchQuery: currentSearchQuery,
            statusFilter: currentStatusFilter,
            sortBy: currentSortBy,
          ),
        );
      }
    }
  }

  /// Handles the LoadCustomerDetails event
  Future<void> _onLoadCustomerDetails(
    LoadCustomerDetails event,
    Emitter<CustomersState> emit,
  ) async {
    emit(CustomerDetailsLoading(customerId: event.customerId));

    try {
      final customer = await _customersService.getCustomerDetails(
        customerId: event.customerId,
      );
      if (customer != null) {
        emit(CustomerDetailsLoaded(customer: customer));
      } else {
        emit(CustomersError(message: 'Customer not found'));
      }
    } catch (e) {
      emit(CustomersError(message: 'Failed to load customer details: ${e.toString()}'));
    }
  }

  /// Handles the UpdateCustomer event
  Future<void> _onUpdateCustomer(
    UpdateCustomer event,
    Emitter<CustomersState> emit,
  ) async {
    // Get current customers
    List<Customer> currentCustomers = [];
    if (state is CustomersLoaded) {
      currentCustomers = (state as CustomersLoaded).customers;
    }

    emit(
      CustomerUpdating(
        customerId: event.customerId,
        currentCustomers: currentCustomers,
      ),
    );

    try {
      // Note: CustomersService doesn't have updateCustomer method yet
      // This is a placeholder for future implementation
      throw UnimplementedError('Update customer functionality not yet implemented in CustomersService');

      // When implemented, it should look like:
      // final updatedCustomer = await _customersService.updateCustomer(...);
      // final updatedCustomers = currentCustomers.map((c) {
      //   return c.id == event.customerId ? updatedCustomer : c;
      // }).toList();
      // emit(CustomerUpdated(customer: updatedCustomer, allCustomers: updatedCustomers));
      // emit(CustomersLoaded(customers: updatedCustomers));
    } catch (e) {
      emit(
        CustomersError(
          message: 'Failed to update customer: ${e.toString()}',
          customers: currentCustomers,
        ),
      );

      if (currentCustomers.isNotEmpty) {
        emit(CustomersLoaded(customers: currentCustomers));
      }
    }
  }

  /// Handles the DeleteCustomer event
  Future<void> _onDeleteCustomer(
    DeleteCustomer event,
    Emitter<CustomersState> emit,
  ) async {
    // Get current customers
    List<Customer> currentCustomers = [];
    if (state is CustomersLoaded) {
      currentCustomers = (state as CustomersLoaded).customers;
    }

    emit(
      CustomerDeleting(
        customerId: event.customerId,
        currentCustomers: currentCustomers,
      ),
    );

    try {
      // Note: CustomersService doesn't have deleteCustomer method yet
      // This is a placeholder for future implementation
      throw UnimplementedError('Delete customer functionality not yet implemented in CustomersService');

      // When implemented, it should look like:
      // await _customersService.deleteCustomer(customerId: event.customerId);
      // final updatedCustomers = currentCustomers.where((c) => c.id != event.customerId).toList();
      // emit(CustomerDeleted(customerId: event.customerId, allCustomers: updatedCustomers));
      // emit(CustomersLoaded(customers: updatedCustomers));
    } catch (e) {
      emit(
        CustomersError(
          message: 'Failed to delete customer: ${e.toString()}',
          customers: currentCustomers,
        ),
      );

      if (currentCustomers.isNotEmpty) {
        emit(CustomersLoaded(customers: currentCustomers));
      }
    }
  }
}

