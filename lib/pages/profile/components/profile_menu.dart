import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Function(String) onMenuTap;

  const ProfileMenu({
    super.key,
    required this.userData,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account & Settings',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Menu Items
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              _buildMenuItem(
                context,
                'Account Settings',
                'Manage your account preferences',
                Icons.person_outline,
                Colors.blue,
              ),
              _buildDivider(context),
              _buildMenuItem(
                context,
                'Business Info',
                'View and edit business details',
                Icons.business_outlined,
                Colors.green,
              ),
              _buildDivider(context),
              _buildMenuItem(
                context,
                'Notifications',
                'Configure notification settings',
                Icons.notifications_outlined,
                Colors.orange,
              ),
              _buildDivider(context),
              _buildMenuItem(
                context,
                'Privacy & Security',
                'Manage privacy and security',
                Icons.security_outlined,
                Colors.purple,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Recent Activity
        Text(
          'Recent Activity',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              ...userData['recentActivity'].map<Widget>((activity) {
                final index = userData['recentActivity'].indexOf(activity);
                return Column(
                  children: [
                    if (index > 0) _buildDivider(context),
                    _buildActivityItem(
                      context,
                      activity['action'],
                      activity['item'],
                      activity['time'],
                      activity['icon'],
                      activity['color'],
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Support & About
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              _buildMenuItem(
                context,
                'Help & Support',
                'Get help and contact support',
                Icons.help_outline,
                Colors.teal,
              ),
              _buildDivider(context),
              _buildMenuItem(
                context,
                'About',
                'App version and information',
                Icons.info_outline,
                Colors.grey,
              ),
              _buildDivider(context),
              _buildMenuItem(
                context,
                'Logout',
                'Sign out of your account',
                Icons.logout,
                Colors.red,
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: () => onMenuTap(title),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive
                    ? color.withOpacity(0.1)
                    : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? color : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String action,
    String item,
    String time,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).dividerColor.withOpacity(0.1),
      indent: 16,
      endIndent: 16,
    );
  }
}
