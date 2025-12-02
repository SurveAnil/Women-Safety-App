import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhoneContactsSection extends StatefulWidget {
  final Function(Map<String, dynamic>) onContactSelected;

  const PhoneContactsSection({
    Key? key,
    required this.onContactSelected,
  }) : super(key: key);

  @override
  State<PhoneContactsSection> createState() => _PhoneContactsSectionState();
}

class _PhoneContactsSectionState extends State<PhoneContactsSection> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredContacts = [];
  List<Map<String, dynamic>> _allContacts = [];

  final List<Map<String, dynamic>> _mockContacts = [
    {
      "id": "1",
      "name": "Sarah Johnson",
      "phone": "+1 (555) 123-4567",
      "avatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
    },
    {
      "id": "2",
      "name": "Michael Chen",
      "phone": "+1 (555) 987-6543",
      "avatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    },
    {
      "id": "3",
      "name": "Emily Rodriguez",
      "phone": "+1 (555) 456-7890",
      "avatar":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face",
    },
    {
      "id": "4",
      "name": "David Thompson",
      "phone": "+1 (555) 321-0987",
      "avatar":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
    },
    {
      "id": "5",
      "name": "Lisa Wang",
      "phone": "+1 (555) 654-3210",
      "avatar":
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=150&h=150&fit=crop&crop=face",
    },
    {
      "id": "6",
      "name": "James Wilson",
      "phone": "+1 (555) 789-0123",
      "avatar":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face",
    },
  ];

  @override
  void initState() {
    super.initState();
    _allContacts = List.from(_mockContacts);
    _filteredContacts = List.from(_mockContacts);
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _allContacts.where((contact) {
        final name = (contact['name'] as String).toLowerCase();
        final phone = (contact['phone'] as String).toLowerCase();
        return name.contains(query) || phone.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search contacts...',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'search',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                      },
                      icon: CustomIconWidget(
                        iconName: 'clear',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    )
                  : null,
            ),
          ),
        ),
        Expanded(
          child: _filteredContacts.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  itemCount: _filteredContacts.length,
                  separatorBuilder: (context, index) => SizedBox(height: 1.h),
                  itemBuilder: (context, index) {
                    final contact = _filteredContacts[index];
                    return _buildContactItem(contact);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildContactItem(Map<String, dynamic> contact) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        leading: CircleAvatar(
          radius: 6.w,
          backgroundColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          child: contact['avatar'] != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(6.w),
                  child: CustomImageWidget(
                    imageUrl: contact['avatar'],
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                  ),
                )
              : CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
        ),
        title: Text(
          contact['name'] ?? 'Unknown',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          contact['phone'] ?? '',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: CustomIconWidget(
          iconName: 'arrow_forward_ios',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 16,
        ),
        onTap: () {
          widget.onContactSelected(contact);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'contacts',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            _searchController.text.isNotEmpty
                ? 'No contacts found'
                : 'No contacts available',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _searchController.text.isNotEmpty
                ? 'Try a different search term'
                : 'Import contacts from your device',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
