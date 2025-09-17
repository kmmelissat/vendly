import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import 'glass_container.dart';

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String? originalPrice;
  final double? rating;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final String? badge;
  final Color? badgeColor;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.originalPrice,
    this.rating,
    this.isFavorite = false,
    this.onTap,
    this.onFavoritePressed,
    this.badge,
    this.badgeColor,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.animationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GlassCard(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSection(),
                  const SizedBox(height: AppConstants.spacingMd),
                  _buildContentSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        // Product Image
        Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            color: AppTheme.paleBlue.withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            child: widget.imageUrl.startsWith('http')
                ? Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder();
                    },
                  )
                : _buildPlaceholder(),
          ),
        ),

        // Badge
        if (widget.badge != null)
          Positioned(
            top: AppConstants.spacingSm,
            left: AppConstants.spacingSm,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingSm,
                vertical: AppConstants.spacingXs,
              ),
              decoration: BoxDecoration(
                color: widget.badgeColor ?? AppTheme.accentBlue,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Text(
                widget.badge!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        // Favorite Button
        Positioned(
          top: AppConstants.spacingSm,
          right: AppConstants.spacingSm,
          child: GestureDetector(
            onTap: widget.onFavoritePressed,
            child: Container(
              padding: const EdgeInsets.all(AppConstants.spacingSm),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(AppConstants.radiusRound),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: widget.isFavorite ? Colors.red : AppTheme.textSecondary,
                size: AppConstants.iconSm,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.paleBlue.withOpacity(0.3),
            AppTheme.accentBlue.withOpacity(0.1),
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.image_outlined, size: 48, color: AppTheme.textLight),
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          widget.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: AppConstants.spacingXs),

        // Rating
        if (widget.rating != null)
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < (widget.rating! / 1).floor()
                      ? Icons.star
                      : index < widget.rating!
                      ? Icons.star_half
                      : Icons.star_border,
                  size: AppConstants.iconXs,
                  color: Colors.amber,
                );
              }),
              const SizedBox(width: AppConstants.spacingXs),
              Text(
                widget.rating!.toStringAsFixed(1),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),

        const SizedBox(height: AppConstants.spacingSm),

        // Price
        Row(
          children: [
            Text(
              widget.price,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryBlue,
              ),
            ),
            if (widget.originalPrice != null) ...[
              const SizedBox(width: AppConstants.spacingSm),
              Text(
                widget.originalPrice!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: AppTheme.textLight,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
