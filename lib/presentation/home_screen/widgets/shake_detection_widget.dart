import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ShakeDetectionWidget extends StatelessWidget {
  final bool isEnabled;
  final String sensitivity;
  final VoidCallback onToggle;

  const ShakeDetectionWidget({
    Key? key,
    required this.isEnabled,
    required this.sensitivity,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderSubtle,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: isEnabled
                  ? AppTheme.successConfirmation.withValues(alpha: 0.1)
                  : AppTheme.textSecondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'vibration',
              color: isEnabled
                  ? AppTheme.successConfirmation
                  : AppTheme.textSecondary,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shake Detection',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  isEnabled ? 'Sensitivity: $sensitivity' : 'Disabled',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) => onToggle(),
            activeColor: AppTheme.successConfirmation,
            inactiveThumbColor: AppTheme.textSecondary,
            inactiveTrackColor: AppTheme.borderSubtle,
          ),
        ],
      ),
    );
  }
}
