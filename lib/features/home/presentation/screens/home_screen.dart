import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/product_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/hero_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Electronics',
    'Fashion',
    'Home',
    'Beauty',
    'Sports',
  ];

  final List<Map<String, dynamic>> _featuredProducts = [
    {
      'imageUrl':
          'https://via.placeholder.com/300x300/3B82F6/FFFFFF?text=Product+1',
      'title': 'Wireless Bluetooth Headphones',
      'price': '\$89.99',
      'originalPrice': '\$129.99',
      'rating': 4.5,
      'badge': 'Sale',
      'badgeColor': Colors.red,
    },
    {
      'imageUrl':
          'https://via.placeholder.com/300x300/60A5FA/FFFFFF?text=Product+2',
      'title': 'Smart Fitness Watch',
      'price': '\$199.99',
      'rating': 4.8,
      'badge': 'New',
      'badgeColor': AppTheme.accentBlue,
    },
    {
      'imageUrl':
          'https://via.placeholder.com/300x300/1E3A8A/FFFFFF?text=Product+3',
      'title': 'Premium Coffee Maker',
      'price': '\$149.99',
      'originalPrice': '\$199.99',
      'rating': 4.3,
    },
    {
      'imageUrl':
          'https://via.placeholder.com/300x300/DBEAFE/1E3A8A?text=Product+4',
      'title': 'Organic Skincare Set',
      'price': '\$79.99',
      'rating': 4.7,
      'badge': 'Popular',
      'badgeColor': AppTheme.lightBlue,
    },
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const GlassAppBar(
        title: AppConstants.appName,
        actions: [
          Icon(Icons.notifications_outlined),
          SizedBox(width: AppConstants.spacingSm),
          Icon(Icons.shopping_cart_outlined),
          SizedBox(width: AppConstants.spacingMd),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppTheme.primaryBlue,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Search Bar
            SliverToBoxAdapter(
              child: FadeInDown(
                duration: AppConstants.animationMedium,
                child: const Padding(
                  padding: EdgeInsets.all(AppConstants.spacingMd),
                  child: SearchBarWidget(),
                ),
              ),
            ),

            // Hero Banner
            SliverToBoxAdapter(
              child: FadeInUp(
                duration: AppConstants.animationMedium,
                delay: const Duration(milliseconds: 100),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingMd,
                  ),
                  child: HeroBanner(),
                ),
              ),
            ),

            // Categories
            SliverToBoxAdapter(
              child: FadeInLeft(
                duration: AppConstants.animationMedium,
                delay: const Duration(milliseconds: 200),
                child: _buildCategoriesSection(),
              ),
            ),

            // Section Title
            SliverToBoxAdapter(
              child: FadeInRight(
                duration: AppConstants.animationMedium,
                delay: const Duration(milliseconds: 300),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Products',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Products Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMd,
              ),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: AppConstants.spacingMd,
                crossAxisSpacing: AppConstants.spacingMd,
                childCount: _featuredProducts.length,
                itemBuilder: (context, index) {
                  final product = _featuredProducts[index];
                  return FadeInUp(
                    duration: AppConstants.animationMedium,
                    delay: Duration(milliseconds: 400 + (index * 100)),
                    child: ProductCard(
                      imageUrl: product['imageUrl'],
                      title: product['title'],
                      price: product['price'],
                      originalPrice: product['originalPrice'],
                      rating: product['rating'],
                      badge: product['badge'],
                      badgeColor: product['badgeColor'],
                      onTap: () => _onProductTap(product),
                      onFavoritePressed: () => _onFavoritePressed(index),
                    ),
                  );
                },
              ),
            ),

            // Bottom Spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: AppConstants.spacingXxl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: AppConstants.spacingMd),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: AppConstants.spacingSm),
            child: CategoryChip(
              label: category,
              isSelected: isSelected,
              onTap: () => _onCategorySelected(category),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    // Simulate network request
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        // Refresh data
      });
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onProductTap(Map<String, dynamic> product) {
    // Navigate to product details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped on ${product['title']}'),
        backgroundColor: AppTheme.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
      ),
    );
  }

  void _onFavoritePressed(int index) {
    // Toggle favorite status
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added ${_featuredProducts[index]['title']} to favorites',
        ),
        backgroundColor: AppTheme.accentBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
      ),
    );
  }
}
