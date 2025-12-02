import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContinueButtonWidget extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;
  final bool isLoading;

  const ContinueButtonWidget({
    Key? key,
    required this.isEnabled,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.backgroundPrimary,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: isEnabled && !isLoading ? _handlePress : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled
                ? AppTheme.primaryEmergency
                : AppTheme.textSecondary.withValues(alpha: 0.3),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: isEnabled ? 2 : 0,
          ),
          child: isLoading
              ? SizedBox(
                  height: 5.w,
                  width: 5.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue to Safety Features',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'arrow_forward',
                      color: Colors.white,
                      size: 5.w,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _handlePress() {
    HapticFeedback.lightImpact();
    onPressed();
  }
}
