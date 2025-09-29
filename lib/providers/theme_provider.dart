import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false); // false = light mode, true = dark mode

  void toggleTheme() {
    state = !state;
  }

  void setLightTheme() {
    state = false;
  }

  void setDarkTheme() {
    state = true;
  }
}

// Provider for the theme state
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});
