import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';
import '../pages/home/home_page.dart';
import '../pages/orders/orders_page.dart';
import '../pages/orders/order_details_page.dart';
import '../pages/products/products_page.dart';
import '../pages/finances/finances_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Page Not Found', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text('The page "${state.uri}" could not be found.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
    routes: [
      // Redirect root to home
      GoRoute(path: '/', redirect: (context, state) => '/home'),
      ShellRoute(
        builder: (context, state, child) {
          return MainPage(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) =>
                NoTransitionPage(key: state.pageKey, child: const HomePage()),
          ),
          GoRoute(
            path: '/orders',
            name: 'orders',
            pageBuilder: (context, state) =>
                NoTransitionPage(key: state.pageKey, child: const OrdersPage()),
            routes: [
              GoRoute(
                path: 'details/:orderId',
                name: 'order-details',
                builder: (context, state) {
                  final encodedOrderId = state.pathParameters['orderId']!;
                  final orderId = Uri.decodeComponent(encodedOrderId);
                  return OrderDetailsPage(orderId: orderId);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/products',
            name: 'products',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProductsPage(),
            ),
          ),
          GoRoute(
            path: '/finances',
            name: 'finances',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const FinancesPage(),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProfilePage(),
            ),
          ),
        ],
      ),
    ],
  );
}
