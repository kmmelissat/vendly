# Authentication Error Handling Guide

## Overview

This guide explains how the app handles authentication errors, including token expiration and invalid tokens.

## Error Response Format

When authentication fails, the API returns a 401 status code with the following format:

```json
{
  "detail": "Invalid or expired token",
  "error_type": "authentication_error"
}
```

## Automatic Token Refresh

The app automatically handles token expiration through the `AuthService` interceptor:

### How It Works

1. **Detection**: When a 401 error occurs with `error_type: "authentication_error"`, the interceptor detects it
2. **Refresh Attempt**: The app automatically tries to refresh the token using the refresh token
3. **Retry**: If refresh succeeds, the original request is retried with the new token
4. **Logout**: If refresh fails, the user is logged out and redirected to the login page

### Implementation Details

```dart
// In AuthService
onError: (error, handler) async {
  if (error.response?.statusCode == 401) {
    final responseData = error.response?.data;
    
    // Check if it's a token expiration error
    if (responseData is Map && 
        (responseData['error_type'] == 'authentication_error' ||
         responseData['detail']?.toString().toLowerCase().contains('token') == true)) {
      
      // Try to refresh the token
      if (!_isRefreshing) {
        _isRefreshing = true;
        final refreshed = await refreshToken();
        _isRefreshing = false;
        
        if (refreshed) {
          // Retry the original request with new token
          final token = await getToken();
          error.requestOptions.headers['Authorization'] = 'Bearer $token';
          final response = await _dio.fetch(error.requestOptions);
          return handler.resolve(response);
        } else {
          // Refresh failed, logout user
          await logout();
        }
      }
    }
  }
  handler.next(error);
}
```

## Manual Error Handling

For pages that need custom error handling, use the `AuthErrorHandler` utility:

### Example Usage

```dart
import 'package:vendly/utils/auth_error_handler.dart';

// In your page or service
try {
  final data = await someApiCall();
} catch (e) {
  if (AuthErrorHandler.isAuthError(e)) {
    // Show user-friendly error dialog and redirect to login
    if (mounted) {
      await AuthErrorHandler.handleAuthError(
        context,
        errorMessage: AuthErrorHandler.getAuthErrorMessage(e),
      );
    }
  } else {
    // Handle other errors
    print('Error: $e');
  }
}
```

### Available Methods

#### `handleAuthError()`
Shows a dialog and redirects to login:

```dart
await AuthErrorHandler.handleAuthError(
  context,
  errorMessage: 'Your session has expired',
  autoLogout: true, // Default: true
);
```

#### `showAuthErrorSnackbar()`
Shows a snackbar with login action:

```dart
AuthErrorHandler.showAuthErrorSnackbar(
  context,
  message: 'Session expired. Please log in again.',
);
```

#### `isAuthError()`
Checks if an error is authentication-related:

```dart
if (AuthErrorHandler.isAuthError(error)) {
  // Handle auth error
}
```

#### `getAuthErrorMessage()`
Extracts user-friendly message:

```dart
final message = AuthErrorHandler.getAuthErrorMessage(error);
```

## Token Refresh Endpoint

The app uses the following endpoint to refresh tokens:

```
POST /auth/refresh
Content-Type: application/json

{
  "refresh_token": "your_refresh_token_here"
}
```

**Expected Response:**

```json
{
  "access_token": "new_access_token",
  "refresh_token": "new_refresh_token", // Optional
  "token_type": "bearer"
}
```

## Best Practices

### 1. Let the Interceptor Handle It
In most cases, you don't need to manually handle 401 errors. The `AuthService` interceptor will automatically:
- Attempt to refresh the token
- Retry the failed request
- Logout if refresh fails

### 2. Handle UI Feedback
For user-facing operations, show appropriate feedback:

```dart
try {
  await updateUserProfile(data);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Profile updated successfully')),
  );
} catch (e) {
  if (AuthErrorHandler.isAuthError(e)) {
    await AuthErrorHandler.handleAuthError(context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update profile')),
    );
  }
}
```

### 3. Check Authentication Before Critical Operations
For critical operations, verify authentication first:

```dart
final isAuth = await _authService.isAuthenticated();
if (!isAuth) {
  if (mounted) {
    context.go('/login');
  }
  return;
}

// Proceed with operation
await performCriticalOperation();
```

### 4. Handle Background Operations
For background operations without UI context:

```dart
try {
  await backgroundSync();
} catch (e) {
  if (AuthErrorHandler.isAuthError(e)) {
    // Just logout, no UI feedback
    await _authService.logout();
  }
}
```

## Testing Authentication Errors

To test authentication error handling:

1. **Expired Token**: Wait for token to expire naturally
2. **Invalid Token**: Manually modify the stored token in SharedPreferences
3. **Network Issues**: Test with airplane mode to ensure proper error messages

## Common Scenarios

### Scenario 1: User Opens App After Long Time
- Token has expired
- User tries to load data
- Interceptor detects 401
- Attempts refresh
- If refresh token also expired, logout and redirect to login

### Scenario 2: User Makes Multiple Requests
- First request fails with 401
- Interceptor starts refresh (`_isRefreshing = true`)
- Other requests wait or fail gracefully
- After refresh, requests are retried

### Scenario 3: Refresh Token Expired
- Access token expired
- Refresh token also expired
- Refresh attempt fails
- User is logged out
- Redirected to login page

## Debugging

Enable detailed logging to see authentication flow:

```dart
// In app_constants.dart
static const bool enableDetailedErrorMessages = true;
```

Check logs for:
- `Token expired, attempting to refresh`
- `Token refreshed successfully`
- `Token refresh failed, logging out user`

## Security Considerations

1. **Secure Storage**: Tokens are stored in SharedPreferences (consider using flutter_secure_storage for production)
2. **Token Validation**: Always validate tokens on the server side
3. **Refresh Token Rotation**: Implement refresh token rotation for better security
4. **Logout on Suspicious Activity**: Logout immediately on multiple failed refresh attempts

## Troubleshooting

### Issue: Infinite Refresh Loop
**Cause**: Refresh endpoint also returns 401
**Solution**: Ensure refresh endpoint doesn't require valid access token

### Issue: User Not Redirected to Login
**Cause**: Context not available or navigation guard issue
**Solution**: Check router configuration and ensure `context.mounted` before navigation

### Issue: Multiple Refresh Attempts
**Cause**: Multiple simultaneous requests trigger refresh
**Solution**: The `_isRefreshing` flag prevents this, but ensure it's properly reset

## Related Files

- `/lib/services/auth_service.dart` - Main authentication service with interceptor
- `/lib/utils/auth_error_handler.dart` - Helper utilities for error handling
- `/lib/constants/api_constants.dart` - API endpoints configuration
- `/lib/constants/app_constants.dart` - App-wide constants including token keys

