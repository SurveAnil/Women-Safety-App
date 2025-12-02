import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContactCardWidget extends StatelessWidget {
  final Map<String, dynamic> contact;
  final VoidCallback onTap;
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ContactCardWidget({
    Key? key,
    required this.contact,
    required this.onTap,
    required this.onCall,
    required this.onMessage,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String name = contact['name'] ?? 'Unknown';
    final String phone = contact['phone'] ?? '';
    final String relationship = contact['relationship'] ?? 'Contact';
    final String? imageUrl = contact['imageUrl'];
    final bool isVerified = contact['isVerified'] ?? false;
    final bool isPriority = contact['isPriority'] ?? false;
    final String lastMessageStatus = contact['lastMessageStatus'] ?? 'Not sent';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(contact['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onCall(),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
              icon: Icons.phone,
              label: 'Call',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onMessage(),
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
              icon: Icons.message,
              label: 'Message',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onEdit(),
              backgroundColor: AppTheme.lightTheme.colorScheme.outline,
              foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.onError,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  // Contact Avatar
                  Stack(
                    children: [
                      Container(
                        width: 15.w,
                        height: 15.w,
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
                                  width: 15.w,
                                  height: 15.w,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Text(
                                  _getInitials(name),
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
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
                                width: 4.w,
                                height: 4.w,
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.error,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        AppTheme.lightTheme.colorScheme.surface,
                                    width: 1,
                                  ),
                                ),
                                child: CustomIconWidget(
                                  iconName: 'star',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onError,
                                  size: 2.w,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  SizedBox(width: 4.w),
                  // Contact Information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: _getRelationshipColor(relationship)
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                relationship,
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: _getRelationshipColor(relationship),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          phone,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: isVerified ? 'check_circle' : 'error',
                              color: isVerified
                                  ? AppTheme.lightTheme.colorScheme.secondary
                                  : AppTheme.lightTheme.colorScheme.error,
                              size: 4.w,
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: Text(
                                isVerified ? 'Verified' : 'Not verified',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: isVerified
                                      ? AppTheme
                                          .lightTheme.colorScheme.secondary
                                      : AppTheme.lightTheme.colorScheme.error,
                                ),
                              ),
                            ),
                            Text(
                              'Last: $lastMessageStatus',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
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
}
