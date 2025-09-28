import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersHeader extends StatelessWidget {
  final DateTimeRange? selectedDateRange;
  final DateTimeRange defaultDateRange;
  final VoidCallback onDatePickerTap;

  const OrdersHeader({
    super.key,
    required this.selectedDateRange,
    required this.defaultDateRange,
    required this.onDatePickerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Date picker with flexible but constrained width
        Flexible(
          flex: 3,
          child: GestureDetector(
            onTap: onDatePickerTap,
            child: Container(
              height: 44, // Same height as buttons
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _formatDateRange(selectedDateRange ?? defaultDateRange),
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Using SizedBox.square() to guarantee identical dimensions
        SizedBox.square(
          dimension: 44,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                // Export functionality
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.file_download_outlined,
                  size: 20,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Using SizedBox.square() to guarantee identical dimensions
        SizedBox.square(
          dimension: 44,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                // Create order functionality
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF5329C8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, size: 20, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateRange(DateTimeRange dateRange) {
    final DateFormat formatter = DateFormat('MMM d');
    final String startDate = formatter.format(dateRange.start);
    final String endDate = formatter.format(dateRange.end);
    final String year = DateFormat('yyyy').format(dateRange.start);

    return '$startDate - $endDate, $year';
  }
}
