import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/database_service.dart';
import '../../../../shared/models/product_model.dart';
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
  final DatabaseService _databaseService = DatabaseService();

  String _selectedCategory = 'All';
  List<Product> _products = [];
  bool _isLoading = true;

  final List<String> _categories = [
    'All',
    'Electronics',
    'Fashion',
    'Home & Garden',
    'Beauty & Health',
    'Sports & Outdoors',
    'Books & Media',
    'Toys & Games',
    'Food & Beverages',
    'Automotive',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _databaseService.getAllProducts(
        category: _selectedCategory == 'All' ? null : _selectedCategory,
      );
      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
              sliver: _isLoading
                  ? const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppConstants.spacingXl),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  : _products.isEmpty
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppConstants.spacingXl),
                          child: Column(
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 64,
                                color: AppTheme.textSecondary,
                              ),
                              const SizedBox(height: AppConstants.spacingMd),
                              Text(
                                'No products found',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(color: AppTheme.textSecondary),
                              ),
                              const SizedBox(height: AppConstants.spacingSm),
                              Text(
                                'Try selecting a different category',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppTheme.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SliverMasonryGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppConstants.spacingMd,
                      crossAxisSpacing: AppConstants.spacingMd,
                      childCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        return FadeInUp(
                          duration: AppConstants.animationMedium,
                          delay: Duration(milliseconds: 400 + (index * 100)),
                          child: ProductCard(
                            imageUrl: product.primaryImageUrl,
                            title: product.name,
                            price: '\$${product.price.toStringAsFixed(2)}',
                            originalPrice: product.originalPrice != null
                                ? '\$${product.originalPrice!.toStringAsFixed(2)}'
                                : null,
                            rating: product.rating,
                            badge: product.isOnSale ? 'Sale' : null,
                            badgeColor: product.isOnSale ? Colors.red : null,
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
    await _loadProducts();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _isLoading = true;
    });
    _loadProducts();
  }

  void _onProductTap(Product product) {
    // Navigate to product details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped on ${product.name}'),
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
    if (index < _products.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${_products[index].name} to favorites'),
          backgroundColor: AppTheme.accentBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
        ),
      );
    }
  }
}
