import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContactInputMethodSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelectionChanged;

  const ContactInputMethodSelector({
    Key? key,
    required this.selectedIndex,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSegmentButton(
              context: context,
              title: 'Phone Contacts',
              icon: 'contacts',
              index: 0,
              isSelected: selectedIndex == 0,
            ),
          ),
          Expanded(
            child: _buildSegmentButton(
              context: context,
              title: 'Manual Entry',
              icon: 'edit',
              index: 1,
              isSelected: selectedIndex == 1,
            ),
          ),
          Expanded(
            child: _buildSegmentButton(
              context: context,
              title: 'QR Share',
              icon: 'qr_code',
              index: 2,
              isSelected: selectedIndex == 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton({
    required BuildContext context,
    required String title,
    required String icon,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onSelectionChanged(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
