import 'package:flutter/material.dart';
import 'components/greeting_header.dart';
import 'components/notification_items.dart';
import 'components/top_products.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personalized Greeting Header (includes banner and metrics)
          const GreetingHeader(),
          SizedBox(height: 32),

          // Notification Items
          NotificationItems(),
          SizedBox(height: 32),

          // Top Products
          TopProducts(),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
