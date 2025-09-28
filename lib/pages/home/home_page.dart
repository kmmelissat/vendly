import 'package:flutter/material.dart';
import 'components/greeting_header.dart';
import 'components/notification_items.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personalized Greeting Header
          GreetingHeader(),
          SizedBox(height: 32),

          // Notification Items
          NotificationItems(),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
