import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';
import '../pages/home/home_page.dart';
import '../pages/orders/orders_page.dart';
import '../pages/orders/order_details_page.dart';
import '../pages/products/products_page.dart';
import '../pages/products/products_bloc.dart';
import '../pages/finances/finances_page.dart';
import '../pages/customers/customers_page.dart';
import '../pages/analytics/analytics_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/onboarding/onboarding_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../services/onboarding_service.dart';
import '../services/auth_service.dart';
import '../services/products_service.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/onboarding',
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
      // Onboarding Route (outside of shell)
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const OnboardingPage()),
      ),
      // Auth Routes (outside of shell)
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const LoginPage()),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const RegisterPage()),
      ),
      // Redirect root based on onboarding and auth status
      GoRoute(
        path: '/',
        redirect: (context, state) async {
          final isOnboardingCompleted =
              await OnboardingService.isOnboardingCompleted();
          if (!isOnboardingCompleted) {
            return '/onboarding';
          }

          final authService = AuthService();
          final isAuthenticated = await authService.isAuthenticated();
          return isAuthenticated ? '/home' : '/login';
        },
      ),
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
              child: BlocProvider(
                create: (context) => ProductsBloc(
                  productsService: ProductsService(),
                  authService: AuthService(),
                ),
                child: const ProductsPage(),
              ),
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
            path: '/customers',
            name: 'customers',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const CustomersPage(),
            ),
          ),
          GoRoute(
            path: '/analytics',
            name: 'analytics',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const AnalyticsPage(),
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
