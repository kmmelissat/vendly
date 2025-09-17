import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_button.dart';

class HeroBanner extends StatefulWidget {
  const HeroBanner({super.key});

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'Summer Sale',
      'subtitle': 'Up to 70% off on selected items',
      'buttonText': 'Shop Now',
      'gradient': [AppTheme.primaryBlue, AppTheme.lightBlue],
      'image': '🌞',
    },
    {
      'title': 'New Arrivals',
      'subtitle': 'Discover the latest trends',
      'buttonText': 'Explore',
      'gradient': [AppTheme.accentBlue, AppTheme.paleBlue],
      'image': '✨',
    },
    {
      'title': 'Free Shipping',
      'subtitle': 'On orders over \$50',
      'buttonText': 'Learn More',
      'gradient': [AppTheme.lightBlue, AppTheme.accentBlue],
      'image': '🚚',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: AppConstants.animationMedium,
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: AppConstants.spacingLg),
      child: Stack(
        children: [
          // Banner Content
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return _buildBannerItem(banner);
            },
          ),

          // Page Indicators
          Positioned(
            bottom: AppConstants.spacingMd,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _banners.length,
                (index) => _buildPageIndicator(index == _currentPage),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerItem(Map<String, dynamic> banner) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: banner['gradient'],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        boxShadow: [
          BoxShadow(
            color: banner['gradient'][0].withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        child: Stack(
          children: [
            // Background Pattern
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: -20,
              bottom: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Emoji Icon
                  Text(banner['image'], style: const TextStyle(fontSize: 40)),

                  const SizedBox(height: AppConstants.spacingSm),

                  // Title
                  Text(
                    banner['title'],
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingXs),

                  // Subtitle
                  Text(
                    banner['subtitle'],
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingMd),

                  // Button
                  CustomButton(
                    text: banner['buttonText'],
                    onPressed: () => _onBannerButtonPressed(banner),
                    type: ButtonType.glass,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingLg,
                      vertical: AppConstants.spacingSm,
                    ),
                    height: 40,
                    textColor: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: AppConstants.animationMedium,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  void _onBannerButtonPressed(Map<String, dynamic> banner) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${banner['buttonText']} pressed!'),
        backgroundColor: AppTheme.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
      ),
    );
  }
}
