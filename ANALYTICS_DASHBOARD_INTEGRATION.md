# Analytics Dashboard API Integration

## Overview
This document describes the integration of the Analytics Dashboard API endpoint into the Link Up mobile application.

## API Endpoint
```
GET /orders/analytics/dashboard/{store_id}?period=month
```

### Supported Periods
- `week` - Last 7 Days
- `month` - Last 30 Days (default)
- `quarter` - Last 3 Months
- `semester` - Last 6 Months
- `year` - This Year

## Response Structure

The API returns a comprehensive analytics dashboard with the following metrics:

### 1. Income Data
```json
{
  "store_id": 7,
  "total_income": 0.0,
  "period": "month",
  "start_date": "2025-10-11T06:25:19.265121",
  "end_date": "2025-11-10T06:25:19.265121",
  "currency": "USD"
}
```

### 2. Revenue Data
```json
{
  "store_id": 7,
  "total_revenue": 0,
  "total_income": 0,
  "total_costs": 0,
  "profit_margin_percent": 0,
  "period": "month",
  "start_date": "2025-10-11T06:25:19.272118",
  "end_date": "2025-11-10T06:25:19.272118",
  "currency": "USD"
}
```

### 3. Orders Data
```json
{
  "store_id": 7,
  "total_orders": 6,
  "status_breakdown": {
    "pending": 6
  },
  "period": "month",
  "start_date": "2025-10-11T06:25:19.274990",
  "end_date": "2025-11-10T06:25:19.274990"
}
```

### 4. Average Order Value Data
```json
{
  "store_id": 7,
  "average_order_value": 0,
  "total_orders": 0,
  "total_income": 0,
  "period": "month",
  "start_date": "2025-10-11T06:25:19.283097",
  "end_date": "2025-11-10T06:25:19.283097",
  "currency": "USD"
}
```

### 5. Items Sold Data
```json
{
  "store_id": 7,
  "total_items_sold": 0,
  "top_products": [],
  "period": "month",
  "start_date": "2025-10-11T06:25:19.285867",
  "end_date": "2025-11-10T06:25:19.285867"
}
```

### 6. Returned Orders Data
```json
{
  "store_id": 7,
  "returned_orders_count": 0,
  "total_orders": 6,
  "return_rate_percent": 0.0,
  "lost_revenue": 0.0,
  "period": "month",
  "start_date": "2025-10-11T06:25:19.295007",
  "end_date": "2025-11-10T06:25:19.295007",
  "currency": "USD"
}
```

### 7. Fulfilled Orders Data
```json
{
  "store_id": 7,
  "fulfilled_orders_count": 0,
  "total_orders": 6,
  "fulfillment_rate_percent": 0.0,
  "average_fulfillment_days": 0,
  "period": "month",
  "start_date": "2025-10-11T06:25:19.304039",
  "end_date": "2025-11-10T06:25:19.304039"
}
```

### 8. Conversion Data
```json
{
  "store_id": 7,
  "conversion_rate_percent": 0,
  "total_conversion_rate_percent": 0.0,
  "customer_conversion_rate_percent": 0.0,
  "converted_orders": 0,
  "non_converted_orders": 0,
  "in_progress_orders": 6,
  "total_orders": 6,
  "completed_journeys": 0,
  "total_customers": 1,
  "converted_customers": 0,
  "status_breakdown": {
    "pending": 6
  },
  "period": "month",
  "start_date": "2025-10-11T06:25:19.324056",
  "end_date": "2025-11-10T06:25:19.324056",
  "interpretation": {
    "conversion_rate": "Percentage of completed orders that resulted in delivery (excludes in-progress)",
    "total_conversion_rate": "Percentage of all orders that resulted in delivery (includes in-progress)",
    "customer_conversion_rate": "Percentage of unique customers who completed at least one order"
  }
}
```

## Implementation Details

### Models Created

#### `AnalyticsDashboard` (lib/models/analytics_dashboard.dart)
Main model containing all dashboard metrics with the following sub-models:
- `DateRange` - Start and end dates for the analytics period
- `IncomeData` - Total income information
- `RevenueData` - Revenue, costs, and profit margin
- `OrdersData` - Order counts and status breakdown
- `AverageOrderValueData` - AOV calculations
- `ItemsSoldData` - Items sold and top products
- `ReturnedOrdersData` - Return statistics
- `FulfilledOrdersData` - Fulfillment metrics
- `ConversionData` - Conversion rates and customer metrics

### Service Methods

#### `AnalyticsService.getDashboardAnalytics()`
```dart
Future<AnalyticsDashboard?> getDashboardAnalytics({
  required String storeId,
  String period = 'month',
})
```
Fetches dashboard analytics for a specific store.

#### `AnalyticsService.getCurrentStoreDashboard()`
```dart
Future<AnalyticsDashboard?> getCurrentStoreDashboard({
  String period = 'month',
})
```
Fetches dashboard analytics for the current user's store.

### UI Components

#### Analytics Page (`lib/pages/analytics/analytics_page.dart`)
- Displays loading state while fetching data
- Shows error state with retry button on failure
- Implements pull-to-refresh functionality
- Period selector dropdown (week, month, quarter, semester, year)
- Automatically refetches data when period changes

#### Analytics Overview (`lib/pages/analytics/components/analytics_overview.dart`)
Displays 6 key metrics in a grid:
1. **Total Revenue** - Shows total revenue and profit margin percentage
2. **Total Orders** - Shows order count and number of status types
3. **Avg Order Value** - Shows AOV and total orders
4. **Conversion Rate** - Shows conversion percentage and converted/total orders
5. **Income** - Shows total income and currency
6. **Items Sold** - Shows total items sold and number of top products

## Features

✅ **Real-time API Integration** - Fetches live data from backend  
✅ **Period Selection** - Users can view analytics for different time periods  
✅ **Loading States** - Shows spinner while loading data  
✅ **Error Handling** - Displays user-friendly error messages with retry option  
✅ **Pull to Refresh** - Swipe down to refresh analytics data  
✅ **Comprehensive Metrics** - Displays all 8 metric categories from the API  
✅ **Responsive UI** - Adapts to different screen sizes  
✅ **Type-safe Models** - Strongly typed Dart models for all API responses  

## Usage

The analytics dashboard automatically loads when the user navigates to the Analytics tab. The data is fetched from the API using the authenticated user's store ID.

### Changing Time Period
Users can tap the period selector dropdown in the top-right corner to switch between different time periods. The dashboard will automatically refetch data for the selected period.

### Refreshing Data
Users can pull down on the analytics page to manually refresh the data.

## Future Enhancements

1. **Time Series Data** - Once the API provides time series data, update the `SalesPerformance` component to display actual historical data instead of mock data.

2. **Top Products** - Display actual top products from the `items_sold.top_products` array when the API populates this field.

3. **Customer Demographics** - Integrate real customer demographic data when available from the API.

4. **Trend Indicators** - Add comparison with previous period to show trends (up/down arrows with percentage changes).

5. **Export Functionality** - Allow users to export analytics data as PDF or CSV.

6. **Custom Date Ranges** - Add ability to select custom start and end dates.

## Testing

To test the integration:

1. Ensure you're logged in as a store owner
2. Navigate to the Analytics tab
3. Verify that data loads correctly
4. Try changing the period selector
5. Test pull-to-refresh functionality
6. Test error handling by disconnecting from the internet

## API Constants

The endpoint is defined in `lib/constants/api_constants.dart`:
```dart
static const String analyticsDashboardEndpoint = '/orders/analytics/dashboard/{storeId}';
```

## Error Handling

The service includes comprehensive error handling:
- Network errors are caught and logged
- API errors return `null` and display user-friendly messages
- Users can retry failed requests with a button
- All errors are logged for debugging purposes

