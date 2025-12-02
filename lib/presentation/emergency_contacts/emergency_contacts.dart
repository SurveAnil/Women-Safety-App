import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_contact_bottom_sheet_widget.dart';
import './widgets/contact_card_widget.dart';
import './widgets/contact_detail_overlay_widget.dart';
import './widgets/empty_contacts_widget.dart';

class EmergencyContacts extends StatefulWidget {
  const EmergencyContacts({Key? key}) : super(key: key);

  @override
  State<EmergencyContacts> createState() => _EmergencyContactsState();
}

class _EmergencyContactsState extends State<EmergencyContacts>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isMultiSelectMode = false;
  final Set<int> _selectedContacts = {};
  bool _isRefreshing = false;

  // Mock data for emergency contacts
  final List<Map<String, dynamic>> _allContacts = [
    {
      "id": 1,
      "name": "Sarah Johnson",
      "phone": "+1 (555) 123-4567",
      "email": "sarah.johnson@email.com",
      "relationship": "Family",
      "imageUrl":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
      "isVerified": true,
      "isPriority": true,
      "lastMessageStatus": "Delivered",
      "address": "123 Main St, Springfield, IL",
      "lastContact": "2025-01-09T15:30:00Z",
      "messageHistory": [
        {"status": "Delivered", "timestamp": "2025-01-09T15:30:00Z"},
        {"status": "Delivered", "timestamp": "2025-01-08T10:15:00Z"},
        {"status": "Failed", "timestamp": "2025-01-07T14:20:00Z"},
      ]
    },
    {
      "id": 2,
      "name": "Michael Rodriguez",
      "phone": "+1 (555) 987-6543",
      "email": "michael.r@email.com",
      "relationship": "Friend",
      "imageUrl":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop&crop=face",
      "isVerified": true,
      "isPriority": false,
      "lastMessageStatus": "Delivered",
      "address": "456 Oak Ave, Springfield, IL",
      "lastContact": "2025-01-08T12:45:00Z",
      "messageHistory": [
        {"status": "Delivered", "timestamp": "2025-01-08T12:45:00Z"},
        {"status": "Delivered", "timestamp": "2025-01-06T16:30:00Z"},
      ]
    },
    {
      "id": 3,
      "name": "Emma Thompson",
      "phone": "+1 (555) 456-7890",
      "email": "emma.thompson@email.com",
      "relationship": "Neighbor",
      "imageUrl":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop&crop=face",
      "isVerified": false,
      "isPriority": false,
      "lastMessageStatus": "Failed",
      "address": "789 Pine St, Springfield, IL",
      "lastContact": "2025-01-07T09:20:00Z",
      "messageHistory": [
        {"status": "Failed", "timestamp": "2025-01-07T09:20:00Z"},
        {"status": "Pending", "timestamp": "2025-01-07T09:15:00Z"},
      ]
    },
    {
      "id": 4,
      "name": "David Chen",
      "phone": "+1 (555) 321-0987",
      "email": "david.chen@email.com",
      "relationship": "Colleague",
      "imageUrl":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop&crop=face",
      "isVerified": true,
      "isPriority": true,
      "lastMessageStatus": "Delivered",
      "address": "321 Elm Dr, Springfield, IL",
      "lastContact": "2025-01-09T08:10:00Z",
      "messageHistory": [
        {"status": "Delivered", "timestamp": "2025-01-09T08:10:00Z"},
        {"status": "Delivered", "timestamp": "2025-01-05T13:25:00Z"},
      ]
    },
    {
      "id": 5,
      "name": "Lisa Anderson",
      "phone": "+1 (555) 654-3210",
      "email": "lisa.anderson@email.com",
      "relationship": "Family",
      "imageUrl":
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=400&fit=crop&crop=face",
      "isVerified": true,
      "isPriority": false,
      "lastMessageStatus": "Delivered",
      "address": "654 Maple Ln, Springfield, IL",
      "lastContact": "2025-01-06T19:45:00Z",
      "messageHistory": [
        {"status": "Delivered", "timestamp": "2025-01-06T19:45:00Z"},
      ]
    },
  ];

  List<Map<String, dynamic>> _filteredContacts = [];
  Map<String, dynamic>? _selectedContactForDetail;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _filteredContacts = List.from(_allContacts);
    _sortContactsByPriority();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _sortContactsByPriority() {
    _filteredContacts.sort((a, b) {
      final aPriority = a['isPriority'] ?? false;
      final bPriority = b['isPriority'] ?? false;
      if (aPriority && !bPriority) return -1;
      if (!aPriority && bPriority) return 1;
      return (a['name'] ?? '').compareTo(b['name'] ?? '');
    });
  }

  void _filterContacts(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredContacts = List.from(_allContacts);
      } else {
        _filteredContacts = _allContacts.where((contact) {
          final name = (contact['name'] ?? '').toLowerCase();
          final phone = (contact['phone'] ?? '').toLowerCase();
          final relationship = (contact['relationship'] ?? '').toLowerCase();
          final searchLower = query.toLowerCase();

          return name.contains(searchLower) ||
              phone.contains(searchLower) ||
              relationship.contains(searchLower);
        }).toList();
      }
      _sortContactsByPriority();
    });
  }

  Future<void> _refreshContacts() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network call
    await Future.delayed(const Duration(seconds: 1));

    // Update verification status for demonstration
    for (var contact in _allContacts) {
      if (contact['id'] == 3) {
        contact['isVerified'] = true;
        contact['lastMessageStatus'] = 'Delivered';
      }
    }

    setState(() {
      _isRefreshing = false;
      _filteredContacts = List.from(_allContacts);
      _sortContactsByPriority();
    });
  }

  void _toggleMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedContacts.clear();
      }
    });
  }

  void _toggleContactSelection(int contactId) {
    setState(() {
      if (_selectedContacts.contains(contactId)) {
        _selectedContacts.remove(contactId);
      } else {
        _selectedContacts.add(contactId);
      }
    });
  }

  void _deleteSelectedContacts() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Contacts'),
        content: Text(
            'Are you sure you want to delete ${_selectedContacts.length} contact(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _allContacts.removeWhere(
                    (contact) => _selectedContacts.contains(contact['id']));
                _filteredContacts.removeWhere(
                    (contact) => _selectedContacts.contains(contact['id']));
                _selectedContacts.clear();
                _isMultiSelectMode = false;
              });
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDetail(Map<String, dynamic> contact) {
    setState(() {
      _selectedContactForDetail = contact;
    });
  }

  void _hideContactDetail() {
    setState(() {
      _selectedContactForDetail = null;
    });
  }

  void _callContact(Map<String, dynamic> contact) {
    // Implement call functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling ${contact['name']}...')),
    );
  }

  void _messageContact(Map<String, dynamic> contact) {
    // Implement message functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Messaging ${contact['name']}...')),
    );
  }

  void _editContact(Map<String, dynamic> contact) {
    Navigator.pushNamed(context, '/add-contact-screen');
  }

  void _deleteContact(Map<String, dynamic> contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Contact'),
        content: Text('Are you sure you want to delete ${contact['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _allContacts.removeWhere((c) => c['id'] == contact['id']);
                _filteredContacts.removeWhere((c) => c['id'] == contact['id']);
              });
              Navigator.pop(context);
              _hideContactDetail();
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _togglePriority(Map<String, dynamic> contact) {
    setState(() {
      final contactIndex =
          _allContacts.indexWhere((c) => c['id'] == contact['id']);
      if (contactIndex != -1) {
        _allContacts[contactIndex]['isPriority'] =
            !(contact['isPriority'] ?? false);
        _filteredContacts = List.from(_allContacts);
        _sortContactsByPriority();

        // Update the detail view if it's showing this contact
        if (_selectedContactForDetail?['id'] == contact['id']) {
          _selectedContactForDetail = _allContacts[contactIndex];
        }
      }
    });
  }

  void _showAddContactBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddContactBottomSheetWidget(
        onSelectFromPhone: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/add-contact-screen');
        },
        onManualEntry: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/add-contact-screen');
        },
        onQRCode: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('QR Code feature coming soon!')),
          );
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Tab Bar
                Container(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  child: TabBar(
                    controller: _tabController,
                    onTap: (index) {
                      if (index == 0) {
                        Navigator.pushReplacementNamed(context, '/home-screen');
                      } else if (index == 2) {
                        Navigator.pushReplacementNamed(
                            context, '/settings-screen');
                      }
                    },
                    tabs: const [
                      Tab(text: 'Home'),
                      Tab(text: 'Contacts'),
                      Tab(text: 'Settings'),
                    ],
                  ),
                ),
                // Search Bar
                Container(
                  padding: EdgeInsets.all(4.w),
                  color: AppTheme.lightTheme.colorScheme.surface,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _filterContacts,
                          decoration: InputDecoration(
                            hintText: 'Search contacts...',
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: CustomIconWidget(
                                iconName: 'search',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 5.w,
                              ),
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      _filterContacts('');
                                    },
                                    icon: CustomIconWidget(
                                      iconName: 'clear',
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      size: 5.w,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      if (_filteredContacts.isNotEmpty) ...[
                        SizedBox(width: 2.w),
                        IconButton(
                          onPressed: _toggleMultiSelectMode,
                          icon: CustomIconWidget(
                            iconName:
                                _isMultiSelectMode ? 'close' : 'checklist',
                            color: _isMultiSelectMode
                                ? AppTheme.lightTheme.colorScheme.error
                                : AppTheme.lightTheme.colorScheme.primary,
                            size: 6.w,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Multi-select actions
                _isMultiSelectMode && _selectedContacts.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 2.h),
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        child: Row(
                          children: [
                            Text(
                              '${_selectedContacts.length} selected',
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: _deleteSelectedContacts,
                              icon: CustomIconWidget(
                                iconName: 'delete',
                                color: AppTheme.lightTheme.colorScheme.error,
                                size: 4.w,
                              ),
                              label: Text(
                                'Delete',
                                style: TextStyle(
                                  color: AppTheme.lightTheme.colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                // Contact List
                Expanded(
                  child: _filteredContacts.isEmpty
                      ? EmptyContactsWidget(
                          onAddContact: _showAddContactBottomSheet,
                        )
                      : RefreshIndicator(
                          onRefresh: _refreshContacts,
                          child: ListView.builder(
                            itemCount: _filteredContacts.length,
                            itemBuilder: (context, index) {
                              final contact = _filteredContacts[index];
                              final contactId = contact['id'] as int;
                              final isSelected =
                                  _selectedContacts.contains(contactId);

                              return GestureDetector(
                                onLongPress: () {
                                  if (!_isMultiSelectMode) {
                                    _toggleMultiSelectMode();
                                  }
                                  _toggleContactSelection(contactId);
                                },
                                child: Container(
                                  decoration: _isMultiSelectMode && isSelected
                                      ? BoxDecoration(
                                          color: AppTheme
                                              .lightTheme.colorScheme.primary
                                              .withValues(alpha: 0.1),
                                        )
                                      : null,
                                  child: Row(
                                    children: [
                                      _isMultiSelectMode
                                          ? Checkbox(
                                              value: isSelected,
                                              onChanged: (value) =>
                                                  _toggleContactSelection(
                                                      contactId),
                                            )
                                          : const SizedBox.shrink(),
                                      Expanded(
                                        child: ContactCardWidget(
                                          contact: contact,
                                          onTap: () {
                                            if (_isMultiSelectMode) {
                                              _toggleContactSelection(
                                                  contactId);
                                            } else {
                                              _showContactDetail(contact);
                                            }
                                          },
                                          onCall: () => _callContact(contact),
                                          onMessage: () =>
                                              _messageContact(contact),
                                          onEdit: () => _editContact(contact),
                                          onDelete: () =>
                                              _deleteContact(contact),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
                // Contact limit info
                if (_filteredContacts.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(3.w),
                    margin: EdgeInsets.all(4.w),
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
                            '${_allContacts.length}/5 contacts added. Recommended: 3-5 contacts.',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            // Contact Detail Overlay
            _selectedContactForDetail != null
                ? ContactDetailOverlayWidget(
                    contact: _selectedContactForDetail!,
                    onClose: _hideContactDetail,
                    onCall: () => _callContact(_selectedContactForDetail!),
                    onMessage: () =>
                        _messageContact(_selectedContactForDetail!),
                    onEdit: () => _editContact(_selectedContactForDetail!),
                    onDelete: () => _deleteContact(_selectedContactForDetail!),
                    onTogglePriority: () =>
                        _togglePriority(_selectedContactForDetail!),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
      floatingActionButton: _filteredContacts.isNotEmpty && !_isMultiSelectMode
          ? FloatingActionButton(
              onPressed: _showAddContactBottomSheet,
              child: CustomIconWidget(
                iconName: 'person_add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 6.w,
              ),
            )
          : null,
    );
  }
}
