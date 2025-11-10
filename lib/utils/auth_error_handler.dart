import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../services/logger_service.dart';

class AuthErrorHandler {
  static final AuthService _authService = AuthService();

  /// Handle authentication errors and show appropriate UI feedback
  static Future<void> handleAuthError(
    BuildContext context, {
    required String errorMessage,
    bool autoLogout = true,
  }) async {
    LoggerService.warning('Handling auth error: $errorMessage');

    if (autoLogout) {
      await _authService.logout();
    }

    if (!context.mounted) return;

    // Show error dialog
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Session Expired'),
          ],
        ),
        content: Text(
          errorMessage.isEmpty
              ? 'Your session has expired. Please log in again to continue.'
              : errorMessage,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/login');
            },
            child: const Text('Log In'),
          ),
        ],
      ),
    );
  }

  /// Show a snackbar for authentication errors
  static void showAuthErrorSnackbar(
    BuildContext context, {
    required String message,
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Log In',
          textColor: Colors.white,
          onPressed: () {
            context.go('/login');
          },
        ),
      ),
    );
  }

  /// Check if an error is an authentication error
  static bool isAuthError(dynamic error) {
    if (error == null) return false;

    final errorString = error.toString().toLowerCase();
    return errorString.contains('authentication') ||
        errorString.contains('unauthorized') ||
        errorString.contains('401') ||
        errorString.contains('token') && errorString.contains('expired') ||
        errorString.contains('invalid token');
  }

  /// Extract user-friendly message from authentication error
  static String getAuthErrorMessage(dynamic error) {
    if (error == null) return 'Authentication error occurred';

    final errorString = error.toString();

    if (errorString.contains('expired')) {
      return 'Your session has expired. Please log in again.';
    } else if (errorString.contains('invalid')) {
      return 'Invalid authentication. Please log in again.';
    } else if (errorString.contains('unauthorized')) {
      return 'You are not authorized. Please log in.';
    }

    return 'Authentication error. Please log in again.';
  }
}
