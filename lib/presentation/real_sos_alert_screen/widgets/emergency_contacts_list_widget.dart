import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyContactsListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> emergencyContacts;
  final Map<String, String> deliveryStatus;
  final Function(String contactId) onRetryMessage;
  final Function() onAddContact;

  const EmergencyContactsListWidget({
    Key? key,
    required this.emergencyContacts,
    required this.deliveryStatus,
    required this.onRetryMessage,
    required this.onAddContact,
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
                iconName: 'contacts',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Emergency Contacts',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${emergencyContacts.length} contacts',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          if (emergencyContacts.isEmpty) ...[
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'person_add',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 8.w,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'No Emergency Contacts',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Add emergency contacts to receive SMS alerts',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ] else ...[
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: emergencyContacts.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                final contact = emergencyContacts[index];
                final contactId = contact['id'].toString();
                final status = deliveryStatus[contactId] ?? 'pending';

                return _buildContactItem(contact, status);
              },
            ),
          ],
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onAddContact,
              icon: CustomIconWidget(
                iconName: 'person_add',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              label: Text(
                'Add Contact to Alert',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(Map<String, dynamic> contact, String status) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'delivered':
      case 'sent':
        statusColor = AppTheme.lightTheme.colorScheme.secondary;
        statusText = 'Delivered';
        statusIcon = Icons.check_circle;
        break;
      case 'failed':
        statusColor = AppTheme.lightTheme.colorScheme.primary;
        statusText = 'Failed';
        statusIcon = Icons.error;
        break;
      case 'sending':
        statusColor = AppTheme.lightTheme.colorScheme.tertiary;
        statusText = 'Sending...';
        statusIcon = Icons.schedule;
        break;
      default:
        statusColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
        statusText = 'Pending';
        statusIcon = Icons.schedule;
    }

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                (contact['name'] as String).isNotEmpty
                    ? (contact['name'] as String)[0].toUpperCase()
                    : '?',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact['name'] as String,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  contact['phone'] as String,
                  style: AppTheme.getDataTextStyle(
                    isLight: true,
                    fontSize: 12.sp,
                  ),
                ),
                if (contact['relationship'] != null) ...[
                  Text(
                    contact['relationship'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: statusIcon.codePoint.toString(),
                    color: statusColor,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    statusText,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (status == 'failed') ...[
                SizedBox(height: 0.5.h),
                TextButton(
                  onPressed: () => onRetryMessage(contact['id'].toString()),
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Retry',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
