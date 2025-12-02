import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyContactsWidget extends StatelessWidget {
  final VoidCallback onAddContact;

  const EmptyContactsWidget({
    Key? key,
    required this.onAddContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 50.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'contacts',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20.w,
                  ),
                  SizedBox(height: 2.h),
                  CustomIconWidget(
                    iconName: 'add_circle_outline',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 8.w,
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            // Title
            Text(
              'Add Your First Contact',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            // Description
            Text(
              'Emergency contacts are crucial for your safety. Add trusted people who can help you in emergency situations.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            // Recommended contact types
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommended Contacts:',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildRecommendationItem(
                      'Family Member', 'Parents, siblings, or spouse'),
                  _buildRecommendationItem(
                      'Close Friend', 'Someone you trust completely'),
                  _buildRecommendationItem(
                      'Neighbor', 'Someone nearby who can help quickly'),
                  _buildRecommendationItem(
                      'Colleague', 'Trusted coworker or supervisor'),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            // Add Contact Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAddContact,
                icon: CustomIconWidget(
                  iconName: 'person_add',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 5.w,
                ),
                label: Text(
                  'Add Emergency Contact',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            // Contact limit info
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Recommended: 3-5 contacts to prevent SMS spam during emergencies',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 1.5.w,
            height: 1.5.w,
            margin: EdgeInsets.only(top: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
