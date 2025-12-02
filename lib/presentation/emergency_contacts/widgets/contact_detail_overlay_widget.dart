import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContactDetailOverlayWidget extends StatelessWidget {
  final Map<String, dynamic> contact;
  final VoidCallback onClose;
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTogglePriority;

  const ContactDetailOverlayWidget({
    Key? key,
    required this.contact,
    required this.onClose,
    required this.onCall,
    required this.onMessage,
    required this.onEdit,
    required this.onDelete,
    required this.onTogglePriority,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String name = contact['name'] ?? 'Unknown';
    final String phone = contact['phone'] ?? '';
    final String relationship = contact['relationship'] ?? 'Contact';
    final String? imageUrl = contact['imageUrl'];
    final bool isVerified = contact['isVerified'] ?? false;
    final bool isPriority = contact['isPriority'] ?? false;
    final String email = contact['email'] ?? '';
    final String address = contact['address'] ?? '';
    final DateTime? lastContact = contact['lastContact'] != null
        ? DateTime.tryParse(contact['lastContact'])
        : null;
    final List<dynamic> messageHistory = contact['messageHistory'] ?? [];

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withValues(alpha: 0.5),
        child: SafeArea(
          child: Center(
            child: Container(
              width: 90.w,
              height: 85.h,
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Contact Details',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
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
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Section
                          Center(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 25.w,
                                      height: 25.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: imageUrl != null
                                            ? Colors.transparent
                                            : _getInitialColor(name),
                                      ),
                                      child: imageUrl != null
                                          ? ClipOval(
                                              child: CustomImageWidget(
                                                imageUrl: imageUrl,
                                                width: 25.w,
                                                height: 25.w,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Center(
                                              child: Text(
                                                _getInitials(name),
                                                style: AppTheme.lightTheme
                                                    .textTheme.headlineMedium
                                                    ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                    ),
                                    isPriority
                                        ? Positioned(
                                            right: 0,
                                            top: 0,
                                            child: Container(
                                              width: 6.w,
                                              height: 6.w,
                                              decoration: BoxDecoration(
                                                color: AppTheme.lightTheme
                                                    .colorScheme.error,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: AppTheme.lightTheme
                                                      .colorScheme.surface,
                                                  width: 2,
                                                ),
                                              ),
                                              child: CustomIconWidget(
                                                iconName: 'star',
                                                color: AppTheme.lightTheme
                                                    .colorScheme.onError,
                                                size: 3.w,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  name,
                                  style: AppTheme
                                      .lightTheme.textTheme.headlineSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 1.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                    color: _getRelationshipColor(relationship)
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    relationship,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      color:
                                          _getRelationshipColor(relationship),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 3.h),
                          // Contact Information
                          _buildInfoSection('Contact Information', [
                            _buildInfoItem('Phone', phone, 'phone'),
                            if (email.isNotEmpty)
                              _buildInfoItem('Email', email, 'email'),
                            if (address.isNotEmpty)
                              _buildInfoItem('Address', address, 'location_on'),
                          ]),
                          SizedBox(height: 2.h),
                          // Status Information
                          _buildInfoSection('Status', [
                            _buildStatusItem(
                              'Verification Status',
                              isVerified ? 'Verified' : 'Not Verified',
                              isVerified ? 'check_circle' : 'error',
                              isVerified
                                  ? AppTheme.lightTheme.colorScheme.secondary
                                  : AppTheme.lightTheme.colorScheme.error,
                            ),
                            _buildStatusItem(
                              'Priority Contact',
                              isPriority ? 'Yes' : 'No',
                              isPriority ? 'star' : 'star_border',
                              isPriority
                                  ? AppTheme.lightTheme.colorScheme.error
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            if (lastContact != null)
                              _buildStatusItem(
                                'Last Contact',
                                _formatDate(lastContact),
                                'schedule',
                                AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                          ]),
                          SizedBox(height: 2.h),
                          // Message History
                          if (messageHistory.isNotEmpty) ...[
                            _buildInfoSection('Recent Messages', [
                              ...messageHistory
                                  .take(3)
                                  .map((message) => _buildMessageItem(
                                      message as Map<String, dynamic>))
                                  .toList(),
                            ]),
                            SizedBox(height: 2.h),
                          ],
                          // Action Buttons
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value, String iconName) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(
      String label, String value, String iconName, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
    final String status = message['status'] ?? 'Unknown';
    final DateTime? timestamp = message['timestamp'] != null
        ? DateTime.tryParse(message['timestamp'])
        : null;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: _getMessageStatusIcon(status),
            color: _getMessageStatusColor(status),
            size: 4.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              status,
              style: AppTheme.lightTheme.textTheme.labelMedium,
            ),
          ),
          if (timestamp != null)
            Text(
              _formatDate(timestamp),
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onCall,
                icon: CustomIconWidget(
                  iconName: 'phone',
                  color: AppTheme.lightTheme.colorScheme.onSecondary,
                  size: 5.w,
                ),
                label: Text('Call'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onMessage,
                icon: CustomIconWidget(
                  iconName: 'message',
                  color: AppTheme.lightTheme.colorScheme.onTertiary,
                  size: 5.w,
                ),
                label: Text('Message'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onTogglePriority,
                icon: CustomIconWidget(
                  iconName:
                      contact['isPriority'] == true ? 'star' : 'star_border',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                label: Text(contact['isPriority'] == true
                    ? 'Remove Priority'
                    : 'Set Priority'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onEdit,
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 5.w,
                ),
                label: Text('Edit'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: onDelete,
            icon: CustomIconWidget(
              iconName: 'delete',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 5.w,
            ),
            label: Text(
              'Delete Contact',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
            ),
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Color _getInitialColor(String name) {
    final colors = [
      AppTheme.lightTheme.colorScheme.primary,
      AppTheme.lightTheme.colorScheme.secondary,
      AppTheme.lightTheme.colorScheme.tertiary,
      const Color(0xFF9C27B0),
      const Color(0xFF673AB7),
      const Color(0xFF3F51B5),
      const Color(0xFF2196F3),
      const Color(0xFF00BCD4),
      const Color(0xFF009688),
      const Color(0xFF4CAF50),
    ];
    final index = name.hashCode % colors.length;
    return colors[index.abs()];
  }

  Color _getRelationshipColor(String relationship) {
    switch (relationship.toLowerCase()) {
      case 'family':
        return AppTheme.lightTheme.colorScheme.error;
      case 'friend':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'colleague':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'neighbor':
        return const Color(0xFF9C27B0);
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getMessageStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return 'check_circle';
      case 'failed':
        return 'error';
      case 'pending':
        return 'schedule';
      default:
        return 'help';
    }
  }

  Color _getMessageStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'failed':
        return AppTheme.lightTheme.colorScheme.error;
      case 'pending':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
