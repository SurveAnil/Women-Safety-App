import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ManualEntryForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onFormChanged;
  final Map<String, dynamic>? initialData;

  const ManualEntryForm({
    Key? key,
    required this.onFormChanged,
    this.initialData,
  }) : super(key: key);

  @override
  State<ManualEntryForm> createState() => _ManualEntryFormState();
}

class _ManualEntryFormState extends State<ManualEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedRelationship = 'Family';
  XFile? _selectedPhoto;
  final ImagePicker _imagePicker = ImagePicker();

  final List<String> _relationships = [
    'Family',
    'Friend',
    'Neighbor',
    'Coworker',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _nameController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
  }

  void _initializeForm() {
    if (widget.initialData != null) {
      _nameController.text = widget.initialData!['name'] ?? '';
      _phoneController.text = widget.initialData!['phone'] ?? '';
      _selectedRelationship = widget.initialData!['relationship'] ?? 'Family';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    final formData = {
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'relationship': _selectedRelationship,
      'photo': _selectedPhoto?.path,
      'isValid': _isFormValid(),
    };
    widget.onFormChanged(formData);
  }

  bool _isFormValid() {
    return _nameController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _isValidPhoneNumber(_phoneController.text.trim());
  }

  bool _isValidPhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    return phoneRegex.hasMatch(phone);
  }

  Future<void> _selectPhoto() async {
    try {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => _buildPhotoSelectionSheet(),
      );
    } catch (e) {
      _showErrorMessage('Failed to open photo selection');
    }
  }

  Widget _buildPhotoSelectionSheet() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Select Photo',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPhotoOption(
                icon: 'camera_alt',
                title: 'Camera',
                onTap: () => _pickPhoto(ImageSource.camera),
              ),
              _buildPhotoOption(
                icon: 'photo_library',
                title: 'Gallery',
                onTap: () => _pickPhoto(ImageSource.gallery),
              ),
              if (_selectedPhoto != null)
                _buildPhotoOption(
                  icon: 'delete',
                  title: 'Remove',
                  onTap: _removePhoto,
                ),
            ],
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildPhotoOption({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      bool hasPermission = await _requestPermission(source);
      if (!hasPermission) {
        _showErrorMessage(
            'Permission denied. Please enable camera/gallery access in settings.');
        return;
      }

      final XFile? photo = await _imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (photo != null) {
        setState(() {
          _selectedPhoto = photo;
        });
        _onFormChanged();
      }
    } catch (e) {
      _showErrorMessage('Failed to select photo. Please try again.');
    }
  }

  Future<bool> _requestPermission(ImageSource source) async {
    Permission permission =
        source == ImageSource.camera ? Permission.camera : Permission.photos;

    PermissionStatus status = await permission.request();
    return status.isGranted;
  }

  void _removePhoto() {
    setState(() {
      _selectedPhoto = null;
    });
    _onFormChanged();
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPhotoSection(),
            SizedBox(height: 3.h),
            _buildNameField(),
            SizedBox(height: 2.h),
            _buildPhoneField(),
            SizedBox(height: 2.h),
            _buildRelationshipField(),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Center(
      child: GestureDetector(
        onTap: _selectPhoto,
        child: Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: _selectedPhoto != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    _selectedPhoto!.path,
                    width: 25.w,
                    height: 25.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPhotoPlaceholder();
                    },
                  ),
                )
              : _buildPhotoPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIconWidget(
          iconName: 'add_a_photo',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 32,
        ),
        SizedBox(height: 1.h),
        Text(
          'Add Photo',
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Full Name *',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Enter full name',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number *',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-\(\)\+]')),
          ],
          decoration: InputDecoration(
            hintText: '+1 (555) 123-4567',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            suffixIcon: _phoneController.text.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: _isValidPhoneNumber(_phoneController.text)
                          ? 'check_circle'
                          : 'error',
                      color: _isValidPhoneNumber(_phoneController.text)
                          ? AppTheme.lightTheme.colorScheme.secondary
                          : AppTheme.lightTheme.colorScheme.error,
                      size: 20,
                    ),
                  )
                : null,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a phone number';
            }
            if (!_isValidPhoneNumber(value.trim())) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRelationshipField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Relationship',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        DropdownButtonFormField<String>(
          value: _selectedRelationship,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'group',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
          items: _relationships.map((relationship) {
            return DropdownMenuItem<String>(
              value: relationship,
              child: Text(relationship),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedRelationship = value;
              });
              _onFormChanged();
            }
          },
        ),
      ],
    );
  }
}