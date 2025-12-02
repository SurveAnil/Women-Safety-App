import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddContactBottomSheetWidget extends StatelessWidget {
  final VoidCallback onSelectFromPhone;
  final VoidCallback onManualEntry;
  final VoidCallback onQRCode;
  final VoidCallback onClose;

  const AddContactBottomSheetWidget({
    Key? key,
    required this.onSelectFromPhone,
    required this.onManualEntry,
    required this.onQRCode,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add Emergency Contact',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),
            // Options
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  _buildOptionTile(
                    title: 'Select from Phone Contacts',
                    subtitle: 'Choose from your existing contacts',
                    icon: 'contacts',
                    onTap: onSelectFromPhone,
                  ),
                  SizedBox(height: 2.h),
                  _buildOptionTile(
                    title: 'Manual Entry',
                    subtitle: 'Enter contact details manually',
                    icon: 'person_add',
                    onTap: onManualEntry,
                  ),
                  SizedBox(height: 2.h),
                  _buildOptionTile(
                    title: 'QR Code Sharing',
                    subtitle: 'Mutual emergency contact setup',
                    icon: 'qr_code',
                    onTap: onQRCode,
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required String subtitle,
    required String icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.lightTheme.colorScheme.primary,
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
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }
}
