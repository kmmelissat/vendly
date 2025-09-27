import 'package:flutter/material.dart';

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
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF2D1B69), // Dark purple background
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.6),
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
            backgroundImage: AssetImage('assets/images/luma.png'),
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
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildMenuItem(context, Icons.analytics, 'Analytics'),
              _buildMenuItem(context, Icons.people, 'Customers'),
              _buildMenuItem(context, Icons.campaign, 'Marketing'),
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
      leading: Icon(icon, color: const Color(0xFF2D1B69)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        Navigator.pop(context);
        // Handle menu item tap
        // You can add navigation logic here based on the title
      },
    );
  }
}
