import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
    : _authService = authService,
      super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthStatusChanged>(_onAuthStatusChanged);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _authService.login(
        email: event.email,
        password: event.password,
      );

      if (result['success'] == true) {
        emit(
          AuthSuccess(
            token: result['token'],
            userId: result['user']['id'],
            name: result['user']['name'],
            email: result['user']['email'],
          ),
        );
      } else {
        emit(AuthFailure(error: result['message'] ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _authService.register(
        name: event.name,
        email: event.email,
        password: event.password,
        storeName: event.storeName,
      );

      if (result['success'] == true) {
        emit(
          AuthSuccess(
            token: result['token'],
            userId: result['user']['id'],
            name: result['user']['name'],
            email: result['user']['email'],
          ),
        );
      } else {
        emit(AuthFailure(error: result['message'] ?? 'Registration failed'));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authService.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  void _onAuthStatusChanged(AuthStatusChanged event, Emitter<AuthState> emit) {
    if (event.isAuthenticated && event.token != null) {
      // You might want to fetch user data here
      // For now, we'll emit a basic success state
      emit(AuthSuccess(token: event.token!, userId: '', name: '', email: ''));
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
