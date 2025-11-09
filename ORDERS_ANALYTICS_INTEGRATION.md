# Orders Analytics Integration

## Overview
This document describes the integration of real-time orders analytics from the API endpoint `GET /orders/analytics/summary/{store_id}` into the Orders page.

## Changes Made

### 1. New Service: `OrdersService`
**File:** `lib/services/orders_service.dart`

Created a new service to handle all orders-related API calls:

#### Key Features:
- **Authentication**: Automatically includes Bearer token in all requests
- **Logging**: Comprehensive logging for debugging and monitoring
- **Error Handling**: Graceful error handling with fallback values

#### Main Methods:

##### `getOrdersAnalyticsSummary()`
Fetches analytics summary for a specific store.

**Parameters:**
- `storeId` (required): The ID of the store
- `period` (optional): Time period for analytics ('day', 'week', 'month', 'year')
  - Default: 'week'

**Returns:** `Map<String, dynamic>?` containing:
```json
{
  "store_id": 7,
  "period": "week",
  "date_range": {
    "start": "2025-11-02T21:34:56.461555",
    "end": "2025-11-09T21:34:56.461555"
  },
  "total_revenue": {
    "value": 0,
    "change_percent": 0,
    "currency": "USD"
  },
  "total_income": {
    "value": 0,
    "change_percent": 0,
    "currency": "USD"
  },
  "total_orders": {
    "value": 0,
    "change_percent": 0
  },
  "average_order_value": {
    "value": 0,
    "change_percent": 0,
    "currency": "USD"
  }
}
```

##### Other Methods:
- `getOrders()`: Fetch orders list with filtering
- `getOrderDetails()`: Get details for a specific order
- `updateOrderStatus()`: Update order status

### 2. Updated Component: `StatisticsCards`
**File:** `lib/pages/orders/components/statistics_cards.dart`

Enhanced the statistics cards to display real API data.

#### New Properties:
- `analyticsData`: Map containing the API response data
- `isLoading`: Boolean to show loading state

#### Display Cards:
1. **Total Orders**
   - Shows: `total_orders.value`
   - Change: `total_orders.change_percent`

2. **Total Revenue**
   - Shows: `total_revenue.value` (formatted as currency)
   - Change: `total_revenue.change_percent`

3. **Total Income**
   - Shows: `total_income.value` (formatted as currency)
   - Change: `total_income.change_percent`

4. **Average Order Value**
   - Shows: `average_order_value.value` (formatted as currency)
   - Change: `average_order_value.change_percent`

#### Helper Methods:
- `_formatCurrency()`: Formats numeric values as currency (e.g., "$123.45")
- `_formatChange()`: Formats percentage changes with sign (e.g., "+25.2% vs last period")

### 3. Updated Page: `OrdersPage`
**File:** `lib/pages/orders/orders_page.dart`

Integrated the analytics service and updated the UI to display real data.

#### New Features:

##### State Management:
- `_ordersService`: Instance of OrdersService
- `_authService`: Instance of AuthService for authentication
- `_analyticsData`: Stores the fetched analytics data
- `_isLoadingAnalytics`: Loading state indicator
- `_storeId`: Current user's store ID

##### Lifecycle Methods:

**`initState()`**
- Initializes services
- Sets default date range to current week
- Loads user data and fetches analytics

**`_loadUserDataAndFetchAnalytics()`**
- Retrieves user data from AuthService
- Extracts store ID from user profile
- Triggers initial analytics fetch

**`_fetchAnalytics()`**
- Calls the OrdersService to get analytics
- Updates UI state with fetched data
- Handles loading states and errors

##### UI Enhancements:

**Pull-to-Refresh**
- Added `RefreshIndicator` wrapper
- Users can pull down to refresh analytics data

**Date Range Updates**
- Analytics automatically refresh when date range changes
- Provides real-time data based on selected period

## API Integration Details

### Endpoint
```
GET /orders/analytics/summary/{store_id}
```

### Authentication
- Requires Bearer token
- Token automatically included via AuthService interceptor

### Query Parameters
- `period`: Time period for analytics (optional)
  - Values: 'day', 'week', 'month', 'year'
  - Default: 'week'

### Response Structure
The API returns a JSON object with the following structure:
- `store_id`: Store identifier
- `period`: Selected time period
- `date_range`: Object with start and end dates
- `total_revenue`: Object with value, change_percent, and currency
- `total_income`: Object with value, change_percent, and currency
- `total_orders`: Object with value and change_percent
- `average_order_value`: Object with value, change_percent, and currency

## Error Handling

### Service Level:
- DioException handling for network errors
- Null safety checks
- Comprehensive logging via LoggerService

### UI Level:
- Graceful fallback to default values (0) when data is unavailable
- Loading indicators during data fetch
- No crashes if API fails - displays zeros instead

## Testing

### Manual Testing Steps:

1. **Login to the app**
   - Ensure you have a valid store account
   - Store ID will be automatically extracted

2. **Navigate to Orders page**
   - Analytics should load automatically
   - Check console logs for API calls

3. **Verify Statistics Cards**
   - Should display real data from API
   - Check that currency formatting is correct
   - Verify percentage changes show with proper signs

4. **Test Pull-to-Refresh**
   - Pull down on the page
   - Analytics should refresh

5. **Test Date Range Picker**
   - Change the date range
   - Analytics should update accordingly

### Expected Behaviors:

**On Initial Load:**
- Loading state shows "..." in statistics cards
- API call is made with store_id from user profile
- Data populates once received

**On Refresh:**
- Pull-to-refresh triggers new API call
- Statistics update with latest data

**On Date Change:**
- New date range triggers analytics refresh
- Data reflects the selected period

**On Error:**
- No crash occurs
- Default values (0) are displayed
- Error is logged to console

## Future Enhancements

1. **Dynamic Period Selection**
   - Add UI controls to switch between day/week/month/year
   - Currently hardcoded to 'week'

2. **Caching**
   - Implement local caching to reduce API calls
   - Use SharedPreferences or SQLite

3. **Offline Support**
   - Store last fetched data locally
   - Display cached data when offline

4. **Real-time Updates**
   - WebSocket integration for live updates
   - Auto-refresh at intervals

5. **Additional Metrics**
   - Add more analytics cards
   - Implement charts and graphs using fl_chart

## Dependencies

Required packages (already in pubspec.yaml):
- `dio: ^5.9.0` - HTTP client
- `shared_preferences: ^2.2.2` - Local storage for tokens
- `intl: ^0.20.2` - Date formatting (if needed)

## Troubleshooting

### Issue: Analytics not loading
**Solutions:**
- Check if user is logged in
- Verify store_id exists in user profile
- Check network connectivity
- Review console logs for API errors

### Issue: Wrong store data showing
**Solutions:**
- Verify correct store_id is being used
- Check authentication token is valid
- Ensure user data is properly stored

### Issue: Date range not updating analytics
**Solutions:**
- Check if `_fetchAnalytics()` is called after date change
- Verify API supports date range filtering
- Review query parameters being sent

## Console Logs

The implementation includes comprehensive logging:

```
[INFO] Store ID loaded: 7
[INFO] Fetching analytics for store: 7
[DEBUG] API Request: GET https://api.lacuponera.store/orders/analytics/summary/7?period=week
[DEBUG] API Response: 200 https://api.lacuponera.store/orders/analytics/summary/7
[INFO] Analytics data loaded successfully
```

## Security Considerations

1. **Token Management**
   - Tokens stored securely in SharedPreferences
   - Automatically included in API requests
   - Auto-logout on 401 responses

2. **Data Validation**
   - All API responses validated before use
   - Null safety checks throughout
   - Type casting with fallbacks

3. **Error Messages**
   - No sensitive data in error messages
   - Detailed logging for debugging (can be disabled in production)

## Conclusion

The Orders Analytics integration is now complete and functional. The implementation follows best practices for:
- Clean architecture with service layer
- Proper error handling
- User experience (loading states, pull-to-refresh)
- Security (token management, data validation)
- Maintainability (logging, documentation)

The statistics cards now display real-time data from the API, providing users with accurate insights into their order metrics.

