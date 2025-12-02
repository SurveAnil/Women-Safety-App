import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PermissionCardWidget extends StatelessWidget {
  final String iconName;
  final String title;
  final String description;
  final PermissionStatus status;
  final VoidCallback onTap;
  final VoidCallback? onOpenSettings;

  const PermissionCardWidget({
    Key? key,
    required this.iconName,
    required this.title,
    required this.description,
    required this.status,
    required this.onTap,
    this.onOpenSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: status == PermissionStatus.denied && onOpenSettings != null
              ? onOpenSettings
              : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: _getIconBackgroundColor(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: _getIconColor(),
                      size: 6.w,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        description,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      status == PermissionStatus.denied &&
                              onOpenSettings != null
                          ? Padding(
                              padding: EdgeInsets.only(top: 1.h),
                              child: Text(
                                'Tap to open settings',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.primaryEmergency,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
                _buildStatusIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    switch (status) {
      case PermissionStatus.granted:
        return Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: AppTheme.successConfirmation,
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: 'check',
            color: Colors.white,
            size: 4.w,
          ),
        );
      case PermissionStatus.denied:
        return Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: AppTheme.primaryEmergency,
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: 'close',
            color: Colors.white,
            size: 4.w,
          ),
        );
      case PermissionStatus.notRequested:
        return Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: AppTheme.textSecondary,
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: 'help_outline',
            color: Colors.white,
            size: 4.w,
          ),
        );
      default:
        return Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: AppTheme.textSecondary,
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: 'help_outline',
            color: Colors.white,
            size: 4.w,
          ),
        );
    }
  }

  Color _getIconBackgroundColor() {
    switch (status) {
      case PermissionStatus.granted:
        return AppTheme.successConfirmation.withValues(alpha: 0.1);
      case PermissionStatus.denied:
        return AppTheme.primaryEmergency.withValues(alpha: 0.1);
      case PermissionStatus.notRequested:
        return AppTheme.textSecondary.withValues(alpha: 0.1);
      default:
        return AppTheme.textSecondary.withValues(alpha: 0.1);
    }
  }

  Color _getIconColor() {
    switch (status) {
      case PermissionStatus.granted:
        return AppTheme.successConfirmation;
      case PermissionStatus.denied:
        return AppTheme.primaryEmergency;
      case PermissionStatus.notRequested:
        return AppTheme.textSecondary;
      default:
        return AppTheme.textSecondary;
    }
  }
}

enum PermissionStatus {
  granted,
  denied,
  notRequested,
}
