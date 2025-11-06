import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_bottom_nav_bar.dart';
import 'providers/theme_provider.dart';
import 'router/app_router.dart';
import 'pages/auth/auth_bloc.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: VendlyApp()));
}

class VendlyApp extends ConsumerWidget {
  const VendlyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    return BlocProvider(
      create: (context) => AuthBloc(authService: AuthService()),
      child: MaterialApp.router(
        title: 'Vendly',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

class MainPage extends ConsumerStatefulWidget {
  final Widget child;
  const MainPage({super.key, required this.child});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int get _selectedIndex {
    // Calculate selected index based on current route
    final location = GoRouterState.of(context).uri.path;
    switch (location) {
      case '/home':
        return 0;
      case '/orders':
        return 1;
      case '/products':
        return 2;
      case '/profile':
        return 4;
      default:
        return 0;
    }
  }

  void _onItemTapped(int index) {
    // Navigate using go_router without manual state management
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/orders');
        break;
      case 2:
        context.go('/products');
        break;
      case 3:
        // Menu - show popup (no navigation)
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    // Set system UI overlay style based on theme
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkMode
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDarkMode
            ? Brightness.light
            : Brightness.dark,
      ),
    );

    return Scaffold(
      appBar: const CustomAppBar(),
      body: widget.child,
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
