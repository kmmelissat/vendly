abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String? storeName;
  final String? storeLocation;
  final String? storeType;

  RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    this.storeName,
    this.storeLocation,
    this.storeType,
  });
}

class LogoutRequested extends AuthEvent {}

class AuthStatusChanged extends AuthEvent {
  final bool isAuthenticated;
  final String? token;

  AuthStatusChanged({required this.isAuthenticated, this.token});
}
