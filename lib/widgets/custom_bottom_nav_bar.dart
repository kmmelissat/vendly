import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: themeProvider.isDarkMode
          ? const Color(0xFF2D1B69) // Dark purple background for dark theme
          : Colors.white, // White background for light theme
      selectedItemColor: themeProvider.isDarkMode
          ? Colors.white
          : const Color(0xFF5329C8), // Purple icons for light theme
      unselectedItemColor: themeProvider.isDarkMode
          ? Colors.white.withOpacity(0.6)
          : const Color(
              0xFF5329C8,
            ).withOpacity(0.6), // Purple icons with opacity for light theme
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 0,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        const BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: '',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.inventory), label: ''),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () => _showPopupMenu(context),
            child: const Icon(Icons.more_horiz),
          ),
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage('assets/images/labubu.png'),
          ),
          label: '',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (index) {
        if (index == 3) {
          // Don't change selected index for menu button
          _showPopupMenu(context);
        } else {
          onItemTapped(index);
        }
      },
    );
  }

  void _showPopupMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildMenuItem(context, Icons.analytics, 'Analytics'),
              _buildMenuItem(context, Icons.people, 'Customers'),
              _buildMenuItem(context, Icons.campaign, 'Marketing'),
              _buildThemeToggleItem(context),
              _buildMenuItem(context, Icons.settings, 'Settings'),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        // Handle menu item tap
        // You can add navigation logic here based on the title
      },
    );
  }

  Widget _buildThemeToggleItem(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ListTile(
          leading: Icon(
            themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(
            themeProvider.isDarkMode ? 'Light Theme' : 'Dark Theme',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          trailing: Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          onTap: () {
            themeProvider.toggleTheme();
          },
        );
      },
    );
  }
}
