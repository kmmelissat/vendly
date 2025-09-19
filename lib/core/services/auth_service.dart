import 'dart:async';
import '../../shared/models/user_model.dart';
import 'database_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final DatabaseService _databaseService = DatabaseService();

  User? _currentUser;
  final StreamController<User?> _userController =
      StreamController<User?>.broadcast();

  User? get currentUser => _currentUser;
  Stream<User?> get userStream => _userController.stream;
  bool get isLoggedIn => _currentUser != null;
  bool get isSeller => _currentUser?.role == UserRole.seller;
  bool get isBuyer => _currentUser?.role == UserRole.buyer;

  Future<AuthResult> signUp({
    required String email,
    required String firstName,
    required String lastName,
    required UserRole role,
    String? phoneNumber,
  }) async {
    try {
      // Check if user already exists
      final existingUser = await _databaseService.getUserByEmail(email);
      if (existingUser != null) {
        return AuthResult.failure('User with this email already exists');
      }

      // Create new user
      final user = User(
        email: email,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        role: role,
      );

      await _databaseService.insertUser(user);

      // Set as current user
      _currentUser = user;
      _userController.add(_currentUser);

      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure('Failed to create account: $e');
    }
  }

  Future<AuthResult> signIn({required String email}) async {
    try {
      final user = await _databaseService.getUserByEmail(email);
      if (user == null) {
        return AuthResult.failure('User not found');
      }

      if (!user.isActive) {
        return AuthResult.failure('Account is deactivated');
      }

      _currentUser = user;
      _userController.add(_currentUser);

      return AuthResult.success(user);
    } catch (e) {
      return AuthResult.failure('Failed to sign in: $e');
    }
  }

  Future<void> signOut() async {
    _currentUser = null;
    _userController.add(null);
  }

  Future<AuthResult> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    if (_currentUser == null) {
      return AuthResult.failure('No user logged in');
    }

    try {
      final updatedUser = _currentUser!.copyWith(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
      );

      await _databaseService.updateUser(updatedUser);
      _currentUser = updatedUser;
      _userController.add(_currentUser);

      return AuthResult.success(updatedUser);
    } catch (e) {
      return AuthResult.failure('Failed to update profile: $e');
    }
  }

  Future<void> initializeAuth() async {
    // In a real app, you might check for stored auth tokens here
    // For now, we'll just ensure the database is initialized
    await _databaseService.database;
  }

  void dispose() {
    _userController.close();
  }
}

class AuthResult {
  final bool isSuccess;
  final String? error;
  final User? user;

  AuthResult._({required this.isSuccess, this.error, this.user});

  factory AuthResult.success(User user) {
    return AuthResult._(isSuccess: true, user: user);
  }

  factory AuthResult.failure(String error) {
    return AuthResult._(isSuccess: false, error: error);
  }
}
