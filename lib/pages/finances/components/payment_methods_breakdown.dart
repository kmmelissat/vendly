import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PaymentMethodsBreakdown extends StatelessWidget {
  final Map<String, dynamic> paymentData;

  const PaymentMethodsBreakdown({super.key, required this.paymentData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Methods',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                // Stack layout for smaller screens
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Pie Chart
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 4,
                          centerSpaceRadius: 40,
                          sections: _buildPieChartSections(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Legend and Details
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPaymentMethodItem(
                          context,
                          'Bank Transfer',
                          'transfer',
                          Icons.account_balance,
                          const Color(0xFF2196F3),
                        ),
                        const SizedBox(height: 12),
                        _buildPaymentMethodItem(
                          context,
                          'Nico (Digital Wallet)',
                          'nico',
                          Icons.wallet,
                          const Color(0xFF4CAF50),
                        ),
                        const SizedBox(height: 12),
                        _buildPaymentMethodItem(
                          context,
                          'Cash on Delivery',
                          'cash_delivery',
                          Icons.local_shipping,
                          const Color(0xFFFF9800),
                        ),
                        const SizedBox(height: 12),
                        _buildPaymentMethodItem(
                          context,
                          'Salvadorian Card',
                          'card_sv',
                          Icons.credit_card,
                          const Color(0xFF9C27B0),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                // Row layout for larger screens
                return Row(
                  children: [
                    // Pie Chart
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 4,
                            centerSpaceRadius: 40,
                            sections: _buildPieChartSections(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Legend and Details
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildPaymentMethodItem(
                            context,
                            'Bank Transfer',
                            'transfer',
                            Icons.account_balance,
                            const Color(0xFF2196F3),
                          ),
                          const SizedBox(height: 16),
                          _buildPaymentMethodItem(
                            context,
                            'Nico (Digital Wallet)',
                            'nico',
                            Icons.wallet,
                            const Color(0xFF4CAF50),
                          ),
                          const SizedBox(height: 16),
                          _buildPaymentMethodItem(
                            context,
                            'Cash on Delivery',
                            'cash_delivery',
                            Icons.local_shipping,
                            const Color(0xFFFF9800),
                          ),
                          const SizedBox(height: 16),
                          _buildPaymentMethodItem(
                            context,
                            'Salvadorian Card',
                            'card_sv',
                            Icons.credit_card,
                            const Color(0xFF9C27B0),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final colors = [
      const Color(0xFF2196F3), // Transfer - Blue
      const Color(0xFF4CAF50), // Nico - Green
      const Color(0xFFFF9800), // Cash - Orange
      const Color(0xFF9C27B0), // Card SV - Purple
    ];

    final methods = ['transfer', 'nico', 'cash_delivery', 'card_sv'];

    return methods.asMap().entries.map((entry) {
      final index = entry.key;
      final method = entry.value;
      final data = paymentData[method];

      return PieChartSectionData(
        color: colors[index],
        value: data['percentage'].toDouble(),
        title: '${data['percentage'].toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildPaymentMethodItem(
    BuildContext context,
    String name,
    String key,
    IconData icon,
    Color color,
  ) {
    final data = paymentData[key];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${data['amount'].toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      '${data['count']} transactions',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
