class AppConstants {
  // App Information
  static const String appName = 'Vendly';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your digital store solution';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  
  // Validation Constants
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minStoreNameLength = 2;
  static const int maxStoreNameLength = 100;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 20.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Image Sizes
  static const double smallImageSize = 40.0;
  static const double mediumImageSize = 60.0;
  static const double largeImageSize = 100.0;
  static const double extraLargeImageSize = 150.0;
  
  // Grid Constants
  static const int productsGridCrossAxisCount = 2;
  static const double productsGridAspectRatio = 0.75;
  static const double productsGridSpacing = 16.0;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // File Upload
  static const int maxImageSizeMB = 5;
  static const int maxDocumentSizeMB = 10;
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedDocumentExtensions = ['pdf', 'doc', 'docx'];
  
  // Currency
  static const String defaultCurrency = 'USD';
  static const String currencySymbol = '\$';
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayDateTimeFormat = 'MMM dd, yyyy HH:mm';
  
  // Regular Expressions
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phoneRegex = r'^\+?[\d\s\-\(\)]+$';
  static const String passwordRegex = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)';
  
  // Error Messages
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String unknownErrorMessage = 'An unexpected error occurred.';
  static const String invalidCredentialsMessage = 'Invalid email or password.';
  static const String emailAlreadyExistsMessage = 'Email already exists.';
  
  // Success Messages
  static const String loginSuccessMessage = 'Welcome back!';
  static const String registerSuccessMessage = 'Account created successfully!';
  static const String logoutSuccessMessage = 'Logged out successfully.';
  static const String profileUpdatedMessage = 'Profile updated successfully.';
  
  // Social Login
  static const String googleClientId = 'your-google-client-id';
  static const String facebookAppId = 'your-facebook-app-id';
  
  // External URLs
  static const String termsOfServiceUrl = 'https://vendly.com/terms';
  static const String privacyPolicyUrl = 'https://vendly.com/privacy';
  static const String supportUrl = 'https://vendly.com/support';
  static const String helpUrl = 'https://vendly.com/help';
  
  // Contact Information
  static const String supportEmail = 'support@vendly.com';
  static const String supportPhone = '+1-800-VENDLY';
  
  // Feature Flags
  static const bool enableGoogleSignIn = true;
  static const bool enableFacebookSignIn = false;
  static const bool enableBiometricAuth = true;
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;
  
  // Debug Settings
  static const bool enableDebugMode = true; // Set to false for production
  static const bool enableLogging = true;
  static const bool enableDetailedErrorMessages = true; // Show debug info in error messages
  static const bool enableCrashReporting = true;
}
