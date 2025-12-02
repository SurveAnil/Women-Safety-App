import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/contact_input_method_selector.dart';
import './widgets/manual_entry_form.dart';
import './widgets/phone_contacts_section.dart';
import './widgets/qr_share_section.dart';
import './widgets/test_sms_button.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({Key? key}) : super(key: key);

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  int _selectedInputMethod = 1; // Default to Manual Entry
  Map<String, dynamic> _contactData = {};
  bool _isSaving = false;
  bool _showDuplicateDialog = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          ContactInputMethodSelector(
            selectedIndex: _selectedInputMethod,
            onSelectionChanged: _onInputMethodChanged,
          ),
          Expanded(
            child: _buildSelectedSection(),
          ),
          _buildBottomSection(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      title: Text(
        'Add Contact',
        style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
      ),
      actions: [
        if (_isValidToSave())
          _isSaving
              ? Container(
                  margin: EdgeInsets.only(right: 4.w),
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                )
              : TextButton(
                  onPressed: _saveContact,
                  child: Text(
                    'Save',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
      ],
    );
  }

  Widget _buildSelectedSection() {
    switch (_selectedInputMethod) {
      case 0:
        return PhoneContactsSection(
          onContactSelected: _onPhoneContactSelected,
        );
      case 1:
        return ManualEntryForm(
          onFormChanged: _onManualFormChanged,
          initialData: _contactData,
        );
      case 2:
        return QrShareSection();
      default:
        return ManualEntryForm(
          onFormChanged: _onManualFormChanged,
          initialData: _contactData,
        );
    }
  }

  Widget _buildBottomSection() {
    // Only show Test SMS button for Manual Entry with valid phone number
    if (_selectedInputMethod == 1 && _hasValidPhoneNumber()) {
      return TestSmsButton(
        phoneNumber: _contactData['phone'] ?? '',
        isEnabled: _hasValidPhoneNumber(),
      );
    }
    return SizedBox.shrink();
  }

  void _onInputMethodChanged(int index) {
    setState(() {
      _selectedInputMethod = index;
      // Clear contact data when switching methods
      if (index != 1) {
        _contactData.clear();
      }
    });
  }

  void _onPhoneContactSelected(Map<String, dynamic> contact) {
    setState(() {
      _contactData = {
        'name': contact['name'] ?? '',
        'phone': contact['phone'] ?? '',
        'relationship': 'Friend',
        'photo': contact['avatar'],
        'isValid': true,
      };
      _selectedInputMethod = 1; // Switch to manual entry to show the form
    });
  }

  void _onManualFormChanged(Map<String, dynamic> formData) {
    setState(() {
      _contactData = formData;
    });
  }

  bool _isValidToSave() {
    return _contactData['isValid'] == true &&
        _contactData['name']?.toString().trim().isNotEmpty == true &&
        _contactData['phone']?.toString().trim().isNotEmpty == true;
  }

  bool _hasValidPhoneNumber() {
    final phone = _contactData['phone']?.toString().trim() ?? '';
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    return phone.isNotEmpty && phoneRegex.hasMatch(phone);
  }

  Future<void> _saveContact() async {
    if (!_isValidToSave() || _isSaving) return;

    // Check for duplicate phone number
    if (_isDuplicatePhoneNumber(_contactData['phone'])) {
      _showDuplicateContactDialog();
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Simulate saving contact
      await Future.delayed(Duration(milliseconds: 1500));

      HapticFeedback.lightImpact();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Emergency contact added successfully',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

      // Navigate back to emergency contacts screen
      Navigator.pop(context, _contactData);
    } catch (e) {
      _showErrorMessage('Failed to save contact. Please try again.');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  bool _isDuplicatePhoneNumber(String? phone) {
    if (phone == null) return false;

    // Mock existing contacts for duplicate check
    final existingNumbers = [
      '+1 (555) 123-4567',
      '+1 (555) 987-6543',
      '+1 (555) 456-7890',
    ];

    return existingNumbers.contains(phone.trim());
  }

  void _showDuplicateContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'Duplicate Contact',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'A contact with this phone number already exists. Would you like to update the existing contact or create a new one?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _mergeWithExistingContact();
            },
            child: Text('Update Existing'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _saveAsNewContact();
            },
            child: Text('Create New'),
          ),
        ],
      ),
    );
  }

  void _mergeWithExistingContact() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Existing contact updated successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
    Navigator.pop(context, _contactData);
  }

  void _saveAsNewContact() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await Future.delayed(Duration(milliseconds: 1000));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New emergency contact created successfully'),
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        ),
      );

      Navigator.pop(context, _contactData);
    } catch (e) {
      _showErrorMessage('Failed to create new contact. Please try again.');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
