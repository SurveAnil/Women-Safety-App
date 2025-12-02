import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SosButtonWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool isPrimary;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const SosButtonWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.isPrimary,
    required this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<SosButtonWidget> createState() => _SosButtonWidgetState();
}

class _SosButtonWidgetState extends State<SosButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              widget.onTap();
            },
            onLongPress: widget.onLongPress != null
                ? () {
                    HapticFeedback.heavyImpact();
                    widget.onLongPress!();
                  }
                : null,
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: Container(
              width: double.infinity,
              height: 12.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: widget.isPrimary
                    ? AppTheme.primaryEmergency
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: widget.isPrimary
                    ? null
                    : Border.all(
                        color: AppTheme.primaryEmergency,
                        width: 2,
                      ),
                boxShadow: [
                  BoxShadow(
                    color: widget.isPrimary
                        ? AppTheme.primaryEmergency.withValues(alpha: 0.3)
                        : AppTheme.shadowLight,
                    blurRadius: _isPressed ? 8 : 12,
                    offset: Offset(0, _isPressed ? 2 : 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: widget.isPrimary
                            ? 'emergency'
                            : 'play_circle_outline',
                        color: widget.isPrimary
                            ? AppTheme.backgroundPrimary
                            : AppTheme.primaryEmergency,
                        size: 28,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        widget.title,
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: widget.isPrimary
                              ? AppTheme.backgroundPrimary
                              : AppTheme.primaryEmergency,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    widget.subtitle,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: widget.isPrimary
                          ? AppTheme.backgroundPrimary.withValues(alpha: 0.9)
                          : AppTheme.primaryEmergency.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
