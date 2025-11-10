class AnalyticsDashboard {
  final int storeId;
  final String period;
  final DateRange dateRange;
  final IncomeData income;
  final RevenueData revenue;
  final OrdersData orders;
  final AverageOrderValueData averageOrderValue;
  final ItemsSoldData itemsSold;
  final ReturnedOrdersData returnedOrders;
  final FulfilledOrdersData fulfilledOrders;
  final ConversionData conversion;

  AnalyticsDashboard({
    required this.storeId,
    required this.period,
    required this.dateRange,
    required this.income,
    required this.revenue,
    required this.orders,
    required this.averageOrderValue,
    required this.itemsSold,
    required this.returnedOrders,
    required this.fulfilledOrders,
    required this.conversion,
  });

  factory AnalyticsDashboard.fromJson(Map<String, dynamic> json) {
    return AnalyticsDashboard(
      storeId: json['store_id'] ?? 0,
      period: json['period'] ?? 'month',
      dateRange: DateRange.fromJson(json['date_range'] ?? {}),
      income: IncomeData.fromJson(json['income'] ?? {}),
      revenue: RevenueData.fromJson(json['revenue'] ?? {}),
      orders: OrdersData.fromJson(json['orders'] ?? {}),
      averageOrderValue: AverageOrderValueData.fromJson(
        json['average_order_value'] ?? {},
      ),
      itemsSold: ItemsSoldData.fromJson(json['items_sold'] ?? {}),
      returnedOrders: ReturnedOrdersData.fromJson(
        json['returned_orders'] ?? {},
      ),
      fulfilledOrders: FulfilledOrdersData.fromJson(
        json['fulfilled_orders'] ?? {},
      ),
      conversion: ConversionData.fromJson(json['conversion'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'period': period,
      'date_range': dateRange.toJson(),
      'income': income.toJson(),
      'revenue': revenue.toJson(),
      'orders': orders.toJson(),
      'average_order_value': averageOrderValue.toJson(),
      'items_sold': itemsSold.toJson(),
      'returned_orders': returnedOrders.toJson(),
      'fulfilled_orders': fulfilledOrders.toJson(),
      'conversion': conversion.toJson(),
    };
  }
}

class DateRange {
  final String start;
  final String end;

  DateRange({required this.start, required this.end});

  factory DateRange.fromJson(Map<String, dynamic> json) {
    return DateRange(start: json['start'] ?? '', end: json['end'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'start': start, 'end': end};
  }
}

class IncomeData {
  final int storeId;
  final double totalIncome;
  final String period;
  final String startDate;
  final String endDate;
  final String currency;

  IncomeData({
    required this.storeId,
    required this.totalIncome,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.currency,
  });

  factory IncomeData.fromJson(Map<String, dynamic> json) {
    return IncomeData(
      storeId: json['store_id'] ?? 0,
      totalIncome: (json['total_income'] ?? 0).toDouble(),
      period: json['period'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      currency: json['currency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'total_income': totalIncome,
      'period': period,
      'start_date': startDate,
      'end_date': endDate,
      'currency': currency,
    };
  }
}

class RevenueData {
  final int storeId;
  final double totalRevenue;
  final double totalIncome;
  final double totalCosts;
  final double profitMarginPercent;
  final String period;
  final String startDate;
  final String endDate;
  final String currency;

  RevenueData({
    required this.storeId,
    required this.totalRevenue,
    required this.totalIncome,
    required this.totalCosts,
    required this.profitMarginPercent,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.currency,
  });

  factory RevenueData.fromJson(Map<String, dynamic> json) {
    return RevenueData(
      storeId: json['store_id'] ?? 0,
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      totalIncome: (json['total_income'] ?? 0).toDouble(),
      totalCosts: (json['total_costs'] ?? 0).toDouble(),
      profitMarginPercent: (json['profit_margin_percent'] ?? 0).toDouble(),
      period: json['period'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      currency: json['currency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'total_revenue': totalRevenue,
      'total_income': totalIncome,
      'total_costs': totalCosts,
      'profit_margin_percent': profitMarginPercent,
      'period': period,
      'start_date': startDate,
      'end_date': endDate,
      'currency': currency,
    };
  }
}

class OrdersData {
  final int storeId;
  final int totalOrders;
  final Map<String, dynamic> statusBreakdown;
  final String period;
  final String startDate;
  final String endDate;

  OrdersData({
    required this.storeId,
    required this.totalOrders,
    required this.statusBreakdown,
    required this.period,
    required this.startDate,
    required this.endDate,
  });

  factory OrdersData.fromJson(Map<String, dynamic> json) {
    return OrdersData(
      storeId: json['store_id'] ?? 0,
      totalOrders: json['total_orders'] ?? 0,
      statusBreakdown: json['status_breakdown'] ?? {},
      period: json['period'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'total_orders': totalOrders,
      'status_breakdown': statusBreakdown,
      'period': period,
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}

class AverageOrderValueData {
  final int storeId;
  final double averageOrderValue;
  final int totalOrders;
  final double totalIncome;
  final String period;
  final String startDate;
  final String endDate;
  final String currency;

  AverageOrderValueData({
    required this.storeId,
    required this.averageOrderValue,
    required this.totalOrders,
    required this.totalIncome,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.currency,
  });

  factory AverageOrderValueData.fromJson(Map<String, dynamic> json) {
    return AverageOrderValueData(
      storeId: json['store_id'] ?? 0,
      averageOrderValue: (json['average_order_value'] ?? 0).toDouble(),
      totalOrders: json['total_orders'] ?? 0,
      totalIncome: (json['total_income'] ?? 0).toDouble(),
      period: json['period'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      currency: json['currency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'average_order_value': averageOrderValue,
      'total_orders': totalOrders,
      'total_income': totalIncome,
      'period': period,
      'start_date': startDate,
      'end_date': endDate,
      'currency': currency,
    };
  }
}

class ItemsSoldData {
  final int storeId;
  final int totalItemsSold;
  final List<dynamic> topProducts;
  final String period;
  final String startDate;
  final String endDate;

  ItemsSoldData({
    required this.storeId,
    required this.totalItemsSold,
    required this.topProducts,
    required this.period,
    required this.startDate,
    required this.endDate,
  });

  factory ItemsSoldData.fromJson(Map<String, dynamic> json) {
    return ItemsSoldData(
      storeId: json['store_id'] ?? 0,
      totalItemsSold: json['total_items_sold'] ?? 0,
      topProducts: json['top_products'] ?? [],
      period: json['period'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'total_items_sold': totalItemsSold,
      'top_products': topProducts,
      'period': period,
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}

class ReturnedOrdersData {
  final int storeId;
  final int returnedOrdersCount;
  final int totalOrders;
  final double returnRatePercent;
  final double lostRevenue;
  final String period;
  final String startDate;
  final String endDate;
  final String currency;

  ReturnedOrdersData({
    required this.storeId,
    required this.returnedOrdersCount,
    required this.totalOrders,
    required this.returnRatePercent,
    required this.lostRevenue,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.currency,
  });

  factory ReturnedOrdersData.fromJson(Map<String, dynamic> json) {
    return ReturnedOrdersData(
      storeId: json['store_id'] ?? 0,
      returnedOrdersCount: json['returned_orders_count'] ?? 0,
      totalOrders: json['total_orders'] ?? 0,
      returnRatePercent: (json['return_rate_percent'] ?? 0).toDouble(),
      lostRevenue: (json['lost_revenue'] ?? 0).toDouble(),
      period: json['period'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      currency: json['currency'] ?? 'USD',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'returned_orders_count': returnedOrdersCount,
      'total_orders': totalOrders,
      'return_rate_percent': returnRatePercent,
      'lost_revenue': lostRevenue,
      'period': period,
      'start_date': startDate,
      'end_date': endDate,
      'currency': currency,
    };
  }
}

class FulfilledOrdersData {
  final int storeId;
  final int fulfilledOrdersCount;
  final int totalOrders;
  final double fulfillmentRatePercent;
  final int averageFulfillmentDays;
  final String period;
  final String startDate;
  final String endDate;

  FulfilledOrdersData({
    required this.storeId,
    required this.fulfilledOrdersCount,
    required this.totalOrders,
    required this.fulfillmentRatePercent,
    required this.averageFulfillmentDays,
    required this.period,
    required this.startDate,
    required this.endDate,
  });

  factory FulfilledOrdersData.fromJson(Map<String, dynamic> json) {
    return FulfilledOrdersData(
      storeId: json['store_id'] ?? 0,
      fulfilledOrdersCount: json['fulfilled_orders_count'] ?? 0,
      totalOrders: json['total_orders'] ?? 0,
      fulfillmentRatePercent: (json['fulfillment_rate_percent'] ?? 0)
          .toDouble(),
      averageFulfillmentDays: json['average_fulfillment_days'] ?? 0,
      period: json['period'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'fulfilled_orders_count': fulfilledOrdersCount,
      'total_orders': totalOrders,
      'fulfillment_rate_percent': fulfillmentRatePercent,
      'average_fulfillment_days': averageFulfillmentDays,
      'period': period,
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}

class ConversionData {
  final int storeId;
  final double conversionRatePercent;
  final double totalConversionRatePercent;
  final double customerConversionRatePercent;
  final int convertedOrders;
  final int nonConvertedOrders;
  final int inProgressOrders;
  final int totalOrders;
  final int completedJourneys;
  final int totalCustomers;
  final int convertedCustomers;
  final Map<String, dynamic> statusBreakdown;
  final String period;
  final String startDate;
  final String endDate;
  final Map<String, String>? interpretation;

  ConversionData({
    required this.storeId,
    required this.conversionRatePercent,
    required this.totalConversionRatePercent,
    required this.customerConversionRatePercent,
    required this.convertedOrders,
    required this.nonConvertedOrders,
    required this.inProgressOrders,
    required this.totalOrders,
    required this.completedJourneys,
    required this.totalCustomers,
    required this.convertedCustomers,
    required this.statusBreakdown,
    required this.period,
    required this.startDate,
    required this.endDate,
    this.interpretation,
  });

  factory ConversionData.fromJson(Map<String, dynamic> json) {
    return ConversionData(
      storeId: json['store_id'] ?? 0,
      conversionRatePercent: (json['conversion_rate_percent'] ?? 0).toDouble(),
      totalConversionRatePercent: (json['total_conversion_rate_percent'] ?? 0)
          .toDouble(),
      customerConversionRatePercent:
          (json['customer_conversion_rate_percent'] ?? 0).toDouble(),
      convertedOrders: json['converted_orders'] ?? 0,
      nonConvertedOrders: json['non_converted_orders'] ?? 0,
      inProgressOrders: json['in_progress_orders'] ?? 0,
      totalOrders: json['total_orders'] ?? 0,
      completedJourneys: json['completed_journeys'] ?? 0,
      totalCustomers: json['total_customers'] ?? 0,
      convertedCustomers: json['converted_customers'] ?? 0,
      statusBreakdown: json['status_breakdown'] ?? {},
      period: json['period'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      interpretation: json['interpretation'] != null
          ? Map<String, String>.from(json['interpretation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_id': storeId,
      'conversion_rate_percent': conversionRatePercent,
      'total_conversion_rate_percent': totalConversionRatePercent,
      'customer_conversion_rate_percent': customerConversionRatePercent,
      'converted_orders': convertedOrders,
      'non_converted_orders': nonConvertedOrders,
      'in_progress_orders': inProgressOrders,
      'total_orders': totalOrders,
      'completed_journeys': completedJourneys,
      'total_customers': totalCustomers,
      'converted_customers': convertedCustomers,
      'status_breakdown': statusBreakdown,
      'period': period,
      'start_date': startDate,
      'end_date': endDate,
      'interpretation': interpretation,
    };
  }
}
