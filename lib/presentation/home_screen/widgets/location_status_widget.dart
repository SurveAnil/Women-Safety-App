import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationStatusWidget extends StatelessWidget {
  final bool isLocationEnabled;
  final String lastUpdate;
  final VoidCallback onRefresh;

  const LocationStatusWidget({
    Key? key,
    required this.isLocationEnabled,
    required this.lastUpdate,
    required this.onRefresh,
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
          color: isLocationEnabled
              ? AppTheme.successConfirmation.withValues(alpha: 0.3)
              : AppTheme.warningAccent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: isLocationEnabled
                  ? AppTheme.successConfirmation.withValues(alpha: 0.1)
                  : AppTheme.warningAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: isLocationEnabled ? 'location_on' : 'location_off',
              color: isLocationEnabled
                  ? AppTheme.successConfirmation
                  : AppTheme.warningAccent,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLocationEnabled ? 'Location Active' : 'Location Disabled',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: isLocationEnabled
                        ? AppTheme.successConfirmation
                        : AppTheme.warningAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  isLocationEnabled
                      ? 'Last update: $lastUpdate'
                      : 'Enable location for emergency alerts',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRefresh,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppTheme.borderSubtle,
                  width: 1,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.textSecondary,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
