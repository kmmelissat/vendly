import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

enum ButtonType { primary, secondary, outline, glass, icon }

class CustomButton extends StatefulWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final ButtonType type;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomButton({
    super.key,
    this.text,
    this.icon,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = AppConstants.radiusLg,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
  });

  const CustomButton.primary({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = AppConstants.radiusLg,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
  }) : type = ButtonType.primary;

  const CustomButton.secondary({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = AppConstants.radiusLg,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
  }) : type = ButtonType.secondary;

  const CustomButton.outline({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = AppConstants.radiusLg,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
  }) : type = ButtonType.outline;

  const CustomButton.glass({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = AppConstants.radiusLg,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
  }) : type = ButtonType.glass;

  const CustomButton.icon({
    super.key,
    required this.icon,
    required this.onPressed,
    this.text,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = AppConstants.radiusRound,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
  }) : type = ButtonType.icon;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
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
    if (widget.isEnabled && !widget.isLoading) {
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.isEnabled && !widget.isLoading) {
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.isEnabled && !widget.isLoading) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isEnabled && !widget.isLoading ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height ?? 56,
              padding:
                  widget.padding ??
                  const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingLg,
                    vertical: AppConstants.spacingMd,
                  ),
              decoration: _getDecoration(),
              child: _buildContent(),
            ),
          );
        },
      ),
    );
  }

  BoxDecoration _getDecoration() {
    switch (widget.type) {
      case ButtonType.primary:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              widget.backgroundColor ?? AppTheme.primaryBlue,
              widget.backgroundColor?.withOpacity(0.8) ?? AppTheme.darkBlue,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: (widget.backgroundColor ?? AppTheme.primaryBlue)
                  .withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case ButtonType.secondary:
        return BoxDecoration(
          color: widget.backgroundColor ?? AppTheme.paleBlue,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppTheme.paleBlue.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        );
      case ButtonType.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: widget.backgroundColor ?? AppTheme.primaryBlue,
            width: 2,
          ),
        );
      case ButtonType.glass:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.2),
              Colors.white.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case ButtonType.icon:
        return BoxDecoration(
          color: widget.backgroundColor ?? AppTheme.primaryBlue,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: (widget.backgroundColor ?? AppTheme.primaryBlue)
                  .withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        );
    }
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    Color contentColor = _getContentColor();

    if (widget.type == ButtonType.icon) {
      return Center(
        child: Icon(
          widget.icon,
          color: contentColor,
          size: AppConstants.iconMd,
        ),
      );
    }

    List<Widget> children = [];

    if (widget.icon != null) {
      children.add(
        Icon(widget.icon, color: contentColor, size: AppConstants.iconSm),
      );
      if (widget.text != null) {
        children.add(const SizedBox(width: AppConstants.spacingSm));
      }
    }

    if (widget.text != null) {
      children.add(
        Text(
          widget.text!,
          style: TextStyle(
            color: contentColor,
            fontSize: widget.fontSize ?? 16,
            fontWeight: widget.fontWeight ?? FontWeight.w600,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Color _getContentColor() {
    if (widget.textColor != null) return widget.textColor!;

    switch (widget.type) {
      case ButtonType.primary:
      case ButtonType.icon:
        return Colors.white;
      case ButtonType.secondary:
        return AppTheme.primaryBlue;
      case ButtonType.outline:
        return widget.backgroundColor ?? AppTheme.primaryBlue;
      case ButtonType.glass:
        return AppTheme.textPrimary;
    }
  }
}
