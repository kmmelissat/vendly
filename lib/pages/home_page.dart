import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personalized Greeting Header
          _buildGreetingHeader(context),
          const SizedBox(height: 32),

          // Notification Items
          _buildNotificationItems(context),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildGreetingHeader(BuildContext context) {
    // Get current time for greeting
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Greeting
        Text(
          '$greeting, LabubuLand',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Here\'s what\'s happening with your store',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 24),

        // Today's Stats
        Row(
          children: [
            // Today's visits
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s visits',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '100',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            // Today's total sales
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s total sales',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$300',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationItems(BuildContext context) {
    final notifications = [
      {
        'text': '6 orders have payments that need to be captured',
        'buttonText': 'View orders',
      },
      {'text': '50+ orders need to be fulfilled', 'buttonText': 'View orders'},
    ];

    return Column(
      children: notifications.map((notification) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              // Blue dot indicator
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),

              // Notification text
              Expanded(
                child: Text(
                  notification['text'] as String,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Action button
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  notification['buttonText'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
