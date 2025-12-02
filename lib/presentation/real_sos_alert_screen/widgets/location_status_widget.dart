import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationStatusWidget extends StatelessWidget {
  final Map<String, dynamic> locationData;
  final bool isLocationSharing;

  const LocationStatusWidget({
    Key? key,
    required this.locationData,
    required this.isLocationSharing,
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
                iconName: 'location_on',
                color: isLocationSharing
                    ? AppTheme.lightTheme.colorScheme.secondary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Location Sharing',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: isLocationSharing
                      ? AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.2)
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isLocationSharing ? 'ACTIVE' : 'INACTIVE',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: isLocationSharing
                        ? AppTheme.lightTheme.colorScheme.secondary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (isLocationSharing) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildLocationRow(
                    icon: 'my_location',
                    label: 'Coordinates',
                    value:
                        '${locationData['latitude']?.toStringAsFixed(6) ?? 'N/A'}, ${locationData['longitude']?.toStringAsFixed(6) ?? 'N/A'}',
                  ),
                  SizedBox(height: 1.h),
                  _buildLocationRow(
                    icon: 'gps_fixed',
                    label: 'Accuracy',
                    value:
                        '±${locationData['accuracy']?.toStringAsFixed(1) ?? 'N/A'} meters',
                  ),
                  SizedBox(height: 1.h),
                  _buildLocationRow(
                    icon: 'access_time',
                    label: 'Last Update',
                    value: locationData['timestamp'] != null
                        ? _formatTimestamp(
                            locationData['timestamp'] as DateTime)
                        : 'N/A',
                  ),
                ],
              ),
            ),
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
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Your location is being shared with emergency contacts in real-time',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'location_off',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Location sharing is disabled. Enable location services for better emergency response.',
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

  Widget _buildLocationRow({
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.secondary,
          size: 4.w,
        ),
        SizedBox(width: 3.w),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: AppTheme.getDataTextStyle(
              isLight: true,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }
}
