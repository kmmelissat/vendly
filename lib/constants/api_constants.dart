class ApiConstants {
  // Base API Configuration
  static const String baseUrl = 'https://api.lacuponera.store';
  static const String apiVersion = 'v1';
  
  // Timeout Configuration
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  static const Duration sendTimeout = Duration(seconds: 10);
  
  // Authentication Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String logoutEndpoint = '/auth/logout';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String resetPasswordEndpoint = '/auth/reset-password';
  
  // User Endpoints
  static const String profileEndpoint = '/user/profile';
  static const String updateProfileEndpoint = '/user/profile';
  static const String changePasswordEndpoint = '/user/change-password';
  
  // Store Endpoints
  static const String storesEndpoint = '/stores';
  static const String storeDetailsEndpoint = '/stores/{id}';
  static const String updateStoreEndpoint = '/stores/{id}';
  
  // Product Endpoints
  static const String productsEndpoint = '/products';
  static const String productDetailsEndpoint = '/products/{id}';
  static const String createProductEndpoint = '/products';
  static const String updateProductEndpoint = '/products/{id}';
  static const String deleteProductEndpoint = '/products/{id}';
  
  // Order Endpoints
  static const String ordersEndpoint = '/orders';
  static const String orderDetailsEndpoint = '/orders/{id}';
  static const String updateOrderStatusEndpoint = '/orders/{id}/status';
  
  // Customer Endpoints
  static const String customersEndpoint = '/customers';
  static const String customerDetailsEndpoint = '/customers/{id}';
  
  // Analytics Endpoints
  static const String analyticsEndpoint = '/analytics';
  static const String salesReportEndpoint = '/analytics/sales';
  static const String revenueReportEndpoint = '/analytics/revenue';
  
  // Finance Endpoints
  static const String financesEndpoint = '/finances';
  static const String transactionsEndpoint = '/finances/transactions';
  static const String payoutsEndpoint = '/finances/payouts';
  
  // File Upload Endpoints
  static const String uploadImageEndpoint = '/upload/image';
  static const String uploadDocumentEndpoint = '/upload/document';
  
  // Notification Endpoints
  static const String notificationsEndpoint = '/notifications';
  static const String markNotificationReadEndpoint = '/notifications/{id}/read';
  
  // API Documentation
  static const String docsEndpoint = '/docs';
  
  // Headers
  static const String contentTypeHeader = 'Content-Type';
  static const String authorizationHeader = 'Authorization';
  static const String acceptHeader = 'Accept';
  
  // Content Types
  static const String jsonContentType = 'application/json';
  static const String formDataContentType = 'multipart/form-data';
  
  // User Types
  static const String storeUserType = 'store';
  static const String customerUserType = 'customer';
  static const String adminUserType = 'admin';
  
  // Order Status
  static const String orderPending = 'pending';
  static const String orderConfirmed = 'confirmed';
  static const String orderProcessing = 'processing';
  static const String orderShipped = 'shipped';
  static const String orderDelivered = 'delivered';
  static const String orderCancelled = 'cancelled';
  
  // Payment Status
  static const String paymentPending = 'pending';
  static const String paymentCompleted = 'completed';
  static const String paymentFailed = 'failed';
  static const String paymentRefunded = 'refunded';
  
  // Helper Methods
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
  
  static String replacePathParameter(String endpoint, String parameter, String value) {
    return endpoint.replaceAll('{$parameter}', value);
  }
  
  static Map<String, String> get defaultHeaders => {
    contentTypeHeader: jsonContentType,
    acceptHeader: jsonContentType,
  };
}
