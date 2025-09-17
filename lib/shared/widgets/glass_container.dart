import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blur;
  final double opacity;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = AppConstants.radiusLg,
    this.blur = AppConstants.glassBlur,
    this.opacity = AppConstants.glassOpacity,
    this.borderColor,
    this.borderWidth = 1.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget container = GlassmorphicContainer(
      width: width ?? double.infinity,
      height: height ?? 200,
      borderRadius: borderRadius,
      blur: blur,
      alignment: Alignment.center,
      border: borderWidth,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.glassWhite.withOpacity(opacity),
          AppTheme.glassWhite.withOpacity(opacity * 0.5),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          borderColor?.withOpacity(AppConstants.glassBorderOpacity) ??
              AppTheme.glassBorder,
          borderColor?.withOpacity(AppConstants.glassBorderOpacity * 0.5) ??
              AppTheme.glassBorder.withOpacity(0.1),
        ],
      ),
      child: Container(padding: padding, child: child),
    );

    if (margin != null) {
      container = Container(margin: margin, child: container);
    }

    if (onTap != null) {
      container = GestureDetector(onTap: onTap, child: container);
    }

    return container;
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double elevation;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppConstants.spacingLg),
    this.margin = const EdgeInsets.all(AppConstants.spacingSm),
    this.onTap,
    this.elevation = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            blurRadius: elevation * 4,
            offset: Offset(0, elevation),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusXl),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(AppConstants.radiusXl),
                child: Container(padding: padding, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
