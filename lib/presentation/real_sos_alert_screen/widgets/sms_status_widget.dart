import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SmsStatusWidget extends StatelessWidget {
  final List<Map<String, dynamic>> emergencyContacts;
  final Map<String, String> deliveryStatus;
  final Function(String contactId) onRetryMessage;

  const SmsStatusWidget({
    Key? key,
    required this.emergencyContacts,
    required this.deliveryStatus,
    required this.onRetryMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sentCount = deliveryStatus.values
        .where((status) => status == 'delivered' || status == 'sent')
        .length;
    final failedCount =
        deliveryStatus.values.where((status) => status == 'failed').length;

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
                iconName: 'message',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'SMS Alert Status',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusItem(
                  icon: 'check_circle',
                  label: 'Sent',
                  count: sentCount,
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
                Container(
                  width: 1,
                  height: 4.h,
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
                _buildStatusItem(
                  icon: 'error',
                  label: 'Failed',
                  count: failedCount,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                Container(
                  width: 1,
                  height: 4.h,
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
                _buildStatusItem(
                  icon: 'contacts',
                  label: 'Total',
                  count: emergencyContacts.length,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ],
            ),
          ),
          if (failedCount > 0) ...[
            SizedBox(height: 2.h),
            Text(
              'Failed Messages',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 1.h),
            ...emergencyContacts
                .where((contact) =>
                    deliveryStatus[contact['id'].toString()] == 'failed')
                .map((contact) => _buildFailedContactItem(contact)),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required String icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: color,
          size: 6.w,
        ),
        SizedBox(height: 0.5.h),
        Text(
          count.toString(),
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildFailedContactItem(Map<String, dynamic> contact) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact['name'] as String,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  contact['phone'] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () => onRetryMessage(contact['id'].toString()),
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 4.w,
            ),
            label: Text(
              'Retry',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
