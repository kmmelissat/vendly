import 'package:flutter/material.dart';

class FilterTabs extends StatelessWidget {
  final int selectedFilterIndex;
  final List<String> filterTabs;
  final Function(int) onFilterChanged;

  const FilterTabs({
    super.key,
    required this.selectedFilterIndex,
    required this.filterTabs,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filterTabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = selectedFilterIndex == index;

          return GestureDetector(
            onTap: () => onFilterChanged(index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF5329C8).withOpacity(0.1)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF5329C8)
                      : Theme.of(context).dividerColor,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tab,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? const Color(0xFF5329C8)
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
