abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String token;
  final String userId;
  final String name;
  final String email;

  AuthSuccess({
    required this.token,
    required this.userId,
    required this.name,
    required this.email,
  });
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});
}

class AuthUnauthenticated extends AuthState {}
