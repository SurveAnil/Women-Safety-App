import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyFeaturesSection extends StatefulWidget {
  const EmergencyFeaturesSection({super.key});

  @override
  State<EmergencyFeaturesSection> createState() =>
      _EmergencyFeaturesSectionState();
}

class _EmergencyFeaturesSectionState extends State<EmergencyFeaturesSection> {
  bool autoLocationEnabled = true;
  String selectedMessageTemplate = 'Emergency Alert';
  bool practiceRemindersEnabled = true;
  String reminderFrequency = 'Weekly';

  final List<Map<String, dynamic>> messageTemplates = [
    {
      'name': 'Emergency Alert',
      'message':
          'EMERGENCY! I need immediate help. Please contact me or call emergency services. My location: [GPS_LOCATION]',
      'isCustom': false,
    },
    {
      'name': 'Safety Check',
      'message':
          'I\'m in an unsafe situation and need assistance. Please check on me. Location: [GPS_LOCATION]',
      'isCustom': false,
    },
    {
      'name': 'Medical Emergency',
      'message':
          'MEDICAL EMERGENCY! I need immediate medical assistance. Location: [GPS_LOCATION]',
      'isCustom': false,
    },
    {
      'name': 'Custom Message 1',
      'message':
          'Help me! I\'m at [GPS_LOCATION] and need immediate assistance.',
      'isCustom': true,
    },
  ];

  final List<String> reminderOptions = [
    'Daily',
    'Weekly',
    'Bi-weekly',
    'Monthly',
    'Never'
  ];

  void _editMessageTemplate(Map<String, dynamic> template) {
    showDialog(
      context: context,
      builder: (context) => _MessageTemplateDialog(
        template: template,
        onSave: (updatedTemplate) {
          setState(() {
            final index = messageTemplates
                .indexWhere((t) => t['name'] == template['name']);
            if (index != -1) {
              messageTemplates[index] = updatedTemplate;
            }
          });
        },
      ),
    );
  }

  void _reorderContacts() {
    Navigator.pushNamed(context, '/emergency-contacts');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emergency Features',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),

            // Auto-Location Toggle
            _buildToggleRow(
              title: 'Auto-Location',
              subtitle: 'Include GPS location in emergency SMS',
              value: autoLocationEnabled,
              onChanged: (value) => setState(() => autoLocationEnabled = value),
              icon: 'location_on',
            ),

            SizedBox(height: 2.h),

            // Message Templates
            _buildMessageTemplatesSection(),

            SizedBox(height: 2.h),

            // Contact Priorities
            _buildContactPrioritiesSection(),

            SizedBox(height: 2.h),

            // Practice Reminders
            _buildPracticeRemindersSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required String icon,
  }) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
        SizedBox(width: 3.w),
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
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildMessageTemplatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Message Templates',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: () => _editMessageTemplate({
                'name': 'New Custom Message',
                'message': '',
                'isCustom': true,
              }),
              child: Text(
                'Add New',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          'Current: $selectedMessageTemplate',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),
        ...messageTemplates
            .map((template) => _buildMessageTemplateTile(template)),
      ],
    );
  }

  Widget _buildMessageTemplateTile(Map<String, dynamic> template) {
    final isSelected = selectedMessageTemplate == template['name'];

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                template['name'] as String,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
            ),
            if (template['isCustom'] as bool)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Custom',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 0.5.h),
          child: Text(
            template['message'] as String,
            style: AppTheme.lightTheme.textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (template['isCustom'] as bool)
              IconButton(
                onPressed: () => _editMessageTemplate(template),
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            Radio<String>(
              value: template['name'] as String,
              groupValue: selectedMessageTemplate,
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedMessageTemplate = value);
                }
              },
            ),
          ],
        ),
        onTap: () => setState(
            () => selectedMessageTemplate = template['name'] as String),
      ),
    );
  }

  Widget _buildContactPrioritiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Contact Priorities',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: _reorderContacts,
              child: Text(
                'Reorder',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          'Set the order in which emergency contacts will be notified',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'reorder',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                'Tap "Reorder" to manage contact sequence',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPracticeRemindersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'schedule',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Practice Reminders',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Get reminded to practice emergency procedures',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: practiceRemindersEnabled,
              onChanged: (value) =>
                  setState(() => practiceRemindersEnabled = value),
            ),
          ],
        ),
        if (practiceRemindersEnabled) ...[
          SizedBox(height: 1.h),
          Text(
            'Frequency',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 0.5.h),
          DropdownButtonFormField<String>(
            value: reminderFrequency,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: reminderOptions.map((frequency) {
              return DropdownMenuItem(
                value: frequency,
                child: Text(frequency),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => reminderFrequency = value);
              }
            },
          ),
        ],
      ],
    );
  }
}

class _MessageTemplateDialog extends StatefulWidget {
  final Map<String, dynamic> template;
  final Function(Map<String, dynamic>) onSave;

  const _MessageTemplateDialog({
    required this.template,
    required this.onSave,
  });

  @override
  State<_MessageTemplateDialog> createState() => _MessageTemplateDialogState();
}

class _MessageTemplateDialogState extends State<_MessageTemplateDialog> {
  late TextEditingController _nameController;
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.template['name'] as String);
    _messageController =
        TextEditingController(text: widget.template['message'] as String);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Message Template'),
      content: SizedBox(
        width: 80.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Template Name',
                hintText: 'Enter template name',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Enter emergency message',
                helperText: 'Use [GPS_LOCATION] to include location',
              ),
              maxLines: 4,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedTemplate = {
              'name': _nameController.text,
              'message': _messageController.text,
              'isCustom': true,
            };
            widget.onSave(updatedTemplate);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
