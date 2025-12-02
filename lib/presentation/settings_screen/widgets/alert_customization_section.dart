import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AlertCustomizationSection extends StatefulWidget {
  const AlertCustomizationSection({super.key});

  @override
  State<AlertCustomizationSection> createState() =>
      _AlertCustomizationSectionState();
}

class _AlertCustomizationSectionState extends State<AlertCustomizationSection> {
  String selectedSirenSound = 'Classic Siren';
  String selectedVibrationPattern = 'Emergency Pattern';
  String selectedVisualEffect = 'Red Flash';
  double shakesensitivity = 0.7;
  bool isExpandedSirens = false;
  bool isExpandedVibration = false;
  bool isExpandedVisual = false;

  final List<Map<String, dynamic>> sirenSounds = [
    {'name': 'Classic Siren', 'duration': '3 seconds', 'volume': 'High'},
    {'name': 'Police Siren', 'duration': '5 seconds', 'volume': 'Very High'},
    {'name': 'Ambulance Horn', 'duration': '4 seconds', 'volume': 'High'},
    {'name': 'Fire Alarm', 'duration': '6 seconds', 'volume': 'Maximum'},
    {'name': 'Air Raid Siren', 'duration': '8 seconds', 'volume': 'Maximum'},
  ];

  final List<Map<String, dynamic>> vibrationPatterns = [
    {'name': 'Emergency Pattern', 'description': 'Short-Long-Short pulses'},
    {'name': 'SOS Pattern', 'description': '3 short, 3 long, 3 short'},
    {'name': 'Continuous Buzz', 'description': 'Steady vibration'},
    {'name': 'Heartbeat Pattern', 'description': 'Double pulse rhythm'},
    {'name': 'Alert Burst', 'description': 'Quick successive pulses'},
  ];

  final List<Map<String, dynamic>> visualEffects = [
    {'name': 'Red Flash', 'description': 'Screen flashes red rapidly'},
    {'name': 'Red Overlay', 'description': 'Solid red screen overlay'},
    {'name': 'Strobe Effect', 'description': 'White-red alternating flash'},
    {'name': 'Pulse Effect', 'description': 'Gradual red fade in/out'},
    {'name': 'Emergency Popup', 'description': 'Full-screen alert popup'},
  ];

  void _testVibration(String pattern) {
    // Test vibration pattern
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Testing $pattern...'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
      ),
    );
  }

  void _previewSiren(String sound) {
    // Preview siren sound
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing $sound preview...'),
        duration: const Duration(seconds: 3),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _testShakeSensitivity() {
    // Test shake sensitivity
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Shake your device to test sensitivity level'),
        duration: const Duration(seconds: 4),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
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
              'Alert Customization',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),

            // Siren Sounds Section
            _buildExpandableSection(
              title: 'Siren Sounds',
              subtitle: selectedSirenSound,
              isExpanded: isExpandedSirens,
              onTap: () => setState(() => isExpandedSirens = !isExpandedSirens),
              children:
                  sirenSounds.map((siren) => _buildSirenTile(siren)).toList(),
            ),

            SizedBox(height: 2.h),

            // Vibration Patterns Section
            _buildExpandableSection(
              title: 'Vibration Patterns',
              subtitle: selectedVibrationPattern,
              isExpanded: isExpandedVibration,
              onTap: () =>
                  setState(() => isExpandedVibration = !isExpandedVibration),
              children: vibrationPatterns
                  .map((pattern) => _buildVibrationTile(pattern))
                  .toList(),
            ),

            SizedBox(height: 2.h),

            // Visual Effects Section
            _buildExpandableSection(
              title: 'Visual Effects',
              subtitle: selectedVisualEffect,
              isExpanded: isExpandedVisual,
              onTap: () => setState(() => isExpandedVisual = !isExpandedVisual),
              children: visualEffects
                  .map((effect) => _buildVisualEffectTile(effect))
                  .toList(),
            ),

            SizedBox(height: 2.h),

            // Shake Sensitivity Section
            _buildShakeSensitivitySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required String subtitle,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        subtitle,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: isExpanded ? 'expand_less' : 'expand_more',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          SizedBox(height: 1.h),
          ...children,
        ],
      ],
    );
  }

  Widget _buildSirenTile(Map<String, dynamic> siren) {
    final isSelected = selectedSirenSound == siren['name'];

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
        title: Text(
          siren['name'] as String,
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          '${siren['duration']} • ${siren['volume']}',
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _previewSiren(siren['name'] as String),
              icon: CustomIconWidget(
                iconName: 'play_arrow',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
            Radio<String>(
              value: siren['name'] as String,
              groupValue: selectedSirenSound,
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedSirenSound = value);
                }
              },
            ),
          ],
        ),
        onTap: () =>
            setState(() => selectedSirenSound = siren['name'] as String),
      ),
    );
  }

  Widget _buildVibrationTile(Map<String, dynamic> pattern) {
    final isSelected = selectedVibrationPattern == pattern['name'];

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
        title: Text(
          pattern['name'] as String,
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          pattern['description'] as String,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => _testVibration(pattern['name'] as String),
              child: Text(
                'Test',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontSize: 12.sp,
                ),
              ),
            ),
            Radio<String>(
              value: pattern['name'] as String,
              groupValue: selectedVibrationPattern,
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedVibrationPattern = value);
                }
              },
            ),
          ],
        ),
        onTap: () => setState(
            () => selectedVibrationPattern = pattern['name'] as String),
      ),
    );
  }

  Widget _buildVisualEffectTile(Map<String, dynamic> effect) {
    final isSelected = selectedVisualEffect == effect['name'];

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
        title: Text(
          effect['name'] as String,
          style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          effect['description'] as String,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
        trailing: Radio<String>(
          value: effect['name'] as String,
          groupValue: selectedVisualEffect,
          onChanged: (value) {
            if (value != null) {
              setState(() => selectedVisualEffect = value);
            }
          },
        ),
        onTap: () =>
            setState(() => selectedVisualEffect = effect['name'] as String),
      ),
    );
  }

  Widget _buildShakeSensitivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Shake Sensitivity',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: _testShakeSensitivity,
              child: Text(
                'Test',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Text(
              'Low',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            Expanded(
              child: Slider(
                value: shakesensitivity,
                onChanged: (value) => setState(() => shakesensitivity = value),
                min: 0.1,
                max: 1.0,
                divisions: 9,
                activeColor: AppTheme.lightTheme.colorScheme.primary,
                inactiveColor: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            Text(
              'High',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
        Text(
          'Current: ${(shakesensitivity * 100).round()}% sensitivity',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
