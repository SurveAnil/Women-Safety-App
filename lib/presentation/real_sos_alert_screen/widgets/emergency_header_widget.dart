import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyHeaderWidget extends StatefulWidget {
  final DateTime alertStartTime;

  const EmergencyHeaderWidget({
    Key? key,
    required this.alertStartTime,
  }) : super(key: key);

  @override
  State<EmergencyHeaderWidget> createState() => _EmergencyHeaderWidgetState();
}

class _EmergencyHeaderWidgetState extends State<EmergencyHeaderWidget>
    with TickerProviderStateMixin {
  late AnimationController _flashController;
  late Animation<double> _flashAnimation;
  String _elapsedTime = "00:00";

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _flashAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flashController,
      curve: Curves.easeInOut,
    ));

    _flashController.repeat(reverse: true);
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        final elapsed = DateTime.now().difference(widget.alertStartTime);
        final minutes = elapsed.inMinutes.toString().padLeft(2, '0');
        final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
        setState(() {
          _elapsedTime = "$minutes:$seconds";
        });
        _startTimer();
      }
    });
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flashAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary.withValues(
              alpha: _flashAnimation.value,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'warning',
                    color: Colors.white,
                    size: 6.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'EMERGENCY ACTIVE',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: 'warning',
                    color: Colors.white,
                    size: 6.w,
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'timer',
                      color: Colors.white,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Duration: $_elapsedTime',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
