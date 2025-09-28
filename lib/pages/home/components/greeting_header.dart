import 'package:flutter/material.dart';
import 'banner_carousel.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
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

        // Banner Carousel
        const BannerCarousel(),
        const SizedBox(height: 24),

        // Business Metrics Cards
        _buildMetricsCards(context),
      ],
    );
  }

  Widget _buildMetricsCards(BuildContext context) {
    final metrics = [
      {
        'title': 'Total Revenue',
        'value': '\$400.73',
        'change': '7% vs last month',
        'isPositive': true,
      },
      {
        'title': 'Total Income',
        'value': '\$300',
        'change': '4% vs last month',
        'isPositive': true,
      },
      {
        'title': 'Total Order',
        'value': '100',
        'change': '3% vs last month',
        'isPositive': true,
      },
      {
        'title': 'Avg. Order Value',
        'value': '\$60',
        'change': '2% vs last month',
        'isPositive': true,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: const Color(0xFF5329C8).withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF5329C8).withOpacity(0.02),
                  Colors.transparent,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with title and info icon
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          metric['title'] as String,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: const Color(0xFF5329C8).withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.more_vert,
                        size: 16,
                        color: const Color(0xFF5329C8).withOpacity(0.6),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Value
                  Text(
                    metric['value'] as String,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5329C8),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Change indicator
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 12,
                        color: const Color(0xFF4CAF50),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          metric['change'] as String,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: const Color(0xFF4CAF50),
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
