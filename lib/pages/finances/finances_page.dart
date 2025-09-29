import 'package:flutter/material.dart';
import 'components/revenue_chart.dart';
import 'components/payment_methods_breakdown.dart';
import 'components/recent_transactions.dart';
import 'components/financial_summary_cards.dart';

class FinancesPage extends StatefulWidget {
  const FinancesPage({super.key});

  @override
  State<FinancesPage> createState() => _FinancesPageState();
}

class _FinancesPageState extends State<FinancesPage> {
  String selectedPeriod = 'This Month';
  final List<String> periods = [
    'Today',
    'This Week',
    'This Month',
    'This Year',
  ];

  // Sample financial data
  final Map<String, dynamic> financialData = {
    'totalRevenue': 15420.50,
    'totalExpenses': 8750.25,
    'netProfit': 6670.25,
    'totalTransactions': 342,
    'averageOrderValue': 45.12,
    'paymentMethods': {
      'transfer': {'amount': 6200.00, 'count': 89, 'percentage': 40.2},
      'nico': {'amount': 4850.00, 'count': 127, 'percentage': 31.4},
      'cash_delivery': {'amount': 2870.50, 'count': 78, 'percentage': 18.6},
      'card_sv': {'amount': 1500.00, 'count': 48, 'percentage': 9.8},
    },
    'monthlyRevenue': [
      {'month': 'Jan', 'revenue': 12500.0},
      {'month': 'Feb', 'revenue': 13200.0},
      {'month': 'Mar', 'revenue': 14800.0},
      {'month': 'Apr', 'revenue': 13900.0},
      {'month': 'May', 'revenue': 15420.5},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Simple Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Finances',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                // Period Selector
                Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withOpacity(0.3),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedPeriod,
                      isDense: true,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      style: const TextStyle(fontSize: 12),
                      items: periods.map((period) {
                        return DropdownMenuItem(
                          value: period,
                          child: Text(
                            period,
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedPeriod = value;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  // Financial Summary Cards
                  FinancialSummaryCards(
                    totalRevenue: financialData['totalRevenue'],
                    totalExpenses: financialData['totalExpenses'],
                    netProfit: financialData['netProfit'],
                    totalTransactions: financialData['totalTransactions'],
                  ),

                  const SizedBox(height: 24),

                  // Revenue Chart
                  RevenueChart(
                    monthlyData: List<Map<String, dynamic>>.from(
                      financialData['monthlyRevenue'],
                    ),
                    selectedPeriod: selectedPeriod,
                  ),

                  const SizedBox(height: 24),

                  // Payment Methods Breakdown
                  PaymentMethodsBreakdown(
                    paymentData: Map<String, dynamic>.from(
                      financialData['paymentMethods'],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Recent Transactions
                  const RecentTransactions(),

                  const SizedBox(height: 100), // Bottom padding for navigation
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
