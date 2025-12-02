import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActiveAlertsWidget extends StatelessWidget {
  final bool isSirenActive;
  final bool isVibrationActive;
  final bool isVisualAlertActive;
  final double vibrationIntensity;
  final Function() onToggleSiren;
  final Function() onToggleVibration;
  final Function() onToggleVisualAlert;

  const ActiveAlertsWidget({
    Key? key,
    required this.isSirenActive,
    required this.isVibrationActive,
    required this.isVisualAlertActive,
    required this.vibrationIntensity,
    required this.onToggleSiren,
    required this.onToggleVibration,
    required this.onToggleVisualAlert,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'notifications_active',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Active Alert Features',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildAlertFeatureItem(
            icon: 'volume_up',
            title: 'Siren Audio',
            subtitle:
                isSirenActive ? 'Emergency siren playing' : 'Siren stopped',
            isActive: isSirenActive,
            onToggle: onToggleSiren,
          ),
          SizedBox(height: 1.5.h),
          _buildAlertFeatureItem(
            icon: 'vibration',
            title: 'Vibration Pattern',
            subtitle: isVibrationActive
                ? 'Intensity: ${(vibrationIntensity * 100).toInt()}%'
                : 'Vibration disabled',
            isActive: isVibrationActive,
            onToggle: onToggleVibration,
          ),
          SizedBox(height: 1.5.h),
          _buildAlertFeatureItem(
            icon: 'flash_on',
            title: 'Visual Alerts',
            subtitle: isVisualAlertActive
                ? 'Screen flashing active'
                : 'Visual alerts disabled',
            isActive: isVisualAlertActive,
            onToggle: onToggleVisualAlert,
          ),
          if (isSirenActive || isVibrationActive || isVisualAlertActive) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'battery_saver',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Alert features are consuming battery. Consider disabling unused features to extend emergency duration.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAlertFeatureItem({
    required String icon,
    required String title,
    required String subtitle,
    required bool isActive,
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                .withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: isActive
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: Colors.white,
              size: 5.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? AppTheme.lightTheme.colorScheme.onSurface
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isActive,
            onChanged: (_) => onToggle(),
            activeColor: AppTheme.lightTheme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
