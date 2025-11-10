import 'package:flutter/material.dart';
import 'components/profile_header.dart';
import 'components/profile_menu.dart';
import 'components/profile_settings.dart';
import '../../services/user_service.dart';
import '../../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Try to fetch from API first
      final apiData = await _userService.getCurrentUserProfile();

      if (apiData != null) {
        // Transform API data to match our UI structure
        final store = apiData['store'] as Map<String, dynamic>? ?? {};

        setState(() {
          _userData = {
            'id': apiData['id']?.toString() ?? '',
            'name': apiData['username'] ?? 'User',
            'username': apiData['username'] ?? 'User',
            'email': apiData['email'] ?? '',
            'phone': store['phone'] ?? '',
            'role': 'Store Owner',
            'userType': apiData['user_type'] ?? 'store',
            'joinDate': apiData['created_at'] ?? '',
            'avatar':
                store['profile_image'] ??
                'assets/images/customers/customer1.jpg',
            'businessName': store['name'] ?? 'My Store',
            'businessType': store['type'] ?? 'General Store',
            'location':
                store['location'] ??
                store['store_location'] ??
                'Location not set',
            'storeDescription': store['description'] ?? '',
            'storeId': store['id']?.toString() ?? '',
            'showcaseImages': store['showcase_images'] ?? [],
            'recentActivity': [],
            'preferences': {
              'notifications': true,
              'emailAlerts': true,
              'darkMode': false,
              'language': 'English',
              'currency': 'USD',
              'timeZone': 'America/El_Salvador',
            },
          };
          _isLoading = false;
        });
      } else {
        // Fallback to cached auth data
        final cachedData = await _authService.getUserData();
        if (cachedData != null) {
          final store = cachedData['store'] as Map<String, dynamic>? ?? {};

          setState(() {
            _userData = {
              'id': cachedData['id']?.toString() ?? '',
              'name': cachedData['username'] ?? 'User',
              'username': cachedData['username'] ?? 'User',
              'email': cachedData['email'] ?? '',
              'phone': store['phone'] ?? '',
              'role': 'Store Owner',
              'userType': cachedData['user_type'] ?? 'store',
              'joinDate': cachedData['created_at'] ?? '',
              'avatar':
                  store['profile_image'] ??
                  'assets/images/customers/customer1.jpg',
              'businessName': store['name'] ?? 'My Store',
              'businessType': store['type'] ?? 'General Store',
              'location': store['store_location'] ?? 'Location not set',
              'storeDescription': '',
              'storeId': store['id']?.toString() ?? '',
              'showcaseImages': [],
              'recentActivity': [],
              'preferences': {
                'notifications': true,
                'emailAlerts': true,
                'darkMode': false,
                'language': 'English',
                'currency': 'USD',
                'timeZone': 'America/El_Salvador',
              },
            };
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Failed to load profile data';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading profile: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Simple Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Profile',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (!_isLoading && _userData != null)
                  Row(
                    children: [
                      // Edit Profile Button
                      Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextButton(
                          onPressed: () => _showEditProfileModal(context),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Settings Button
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).dividerColor.withOpacity(0.3),
                          ),
                        ),
                        child: IconButton(
                          onPressed: () => _showSettingsModal(context),
                          icon: Icon(
                            Icons.settings,
                            size: 16,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadUserProfile,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadUserProfile,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          // Profile Header
                          ProfileHeader(userData: _userData!),

                          const SizedBox(height: 24),

                          // Profile Menu
                          ProfileMenu(
                            userData: _userData!,
                            onMenuTap: _handleMenuTap,
                          ),

                          const SizedBox(
                            height: 100,
                          ), // Bottom padding for navigation
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _handleMenuTap(String menuItem) {
    switch (menuItem) {
      case 'Account Settings':
        _showSettingsModal(context);
        break;
      case 'Business Info':
        _showBusinessInfoModal(context);
        break;
      case 'Notifications':
        _showNotificationsModal(context);
        break;
      case 'Privacy & Security':
        _showPrivacyModal(context);
        break;
      case 'Help & Support':
        _showHelpModal(context);
        break;
      case 'About':
        _showAboutModal(context);
        break;
      case 'Logout':
        _showLogoutDialog(context);
        break;
    }
  }

  void _showEditProfileModal(BuildContext context) {
    if (_userData == null) return;

    final nameController = TextEditingController(text: _userData!['name']);
    final emailController = TextEditingController(text: _userData!['email']);
    final phoneController = TextEditingController(text: _userData!['phone']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Profile',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Edit Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Avatar
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                _userData!['avatar'].toString().startsWith(
                                  'http',
                                )
                                ? NetworkImage(_userData!['avatar'])
                                : AssetImage(_userData!['avatar'])
                                      as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Form Fields
                    _buildTextFieldWithController('Username', nameController),
                    const SizedBox(height: 16),
                    _buildTextFieldWithController('Email', emailController),
                    const SizedBox(height: 16),
                    _buildTextFieldWithController('Phone', phoneController),
                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Update profile via API
                          final result = await _userService.updateUserProfile(
                            username: nameController.text,
                            email: emailController.text,
                          );

                          Navigator.pop(context);

                          if (result['success'] == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully!'),
                              ),
                            );
                            // Reload profile data
                            _loadUserProfile();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  result['message'] ??
                                      'Failed to update profile',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsModal(BuildContext context) {
    if (_userData == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: ProfileSettings(
          preferences: Map<String, dynamic>.from(_userData!['preferences']),
        ),
      ),
    );
  }

  void _showBusinessInfoModal(BuildContext context) {
    if (_userData == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Business Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Business Name', _userData!['businessName'] ?? ''),
            _buildInfoRow('Business Type', _userData!['businessType'] ?? ''),
            _buildInfoRow('Location', _userData!['location'] ?? ''),
            _buildInfoRow(
              'Member Since',
              _userData!['joinDate'] != null && _userData!['joinDate'] != ''
                  ? _formatDate(_userData!['joinDate'])
                  : 'N/A',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNotificationsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Notification Settings'),
        content: const Text('Notification preferences will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Privacy & Security'),
        content: const Text(
          'Privacy and security settings will be available soon.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHelpModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Help & Support'),
        content: const Text(
          'For support, please contact us at support@vendly.com',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('About Vendly'),
        content: const Text(
          'Vendly v1.0.0\nYour inventory management solution.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithController(
    String label,
    TextEditingController controller,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
