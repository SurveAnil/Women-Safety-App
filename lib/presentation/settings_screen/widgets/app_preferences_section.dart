import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppPreferencesSection extends StatefulWidget {
  const AppPreferencesSection({super.key});

  @override
  State<AppPreferencesSection> createState() => _AppPreferencesSectionState();
}

class _AppPreferencesSectionState extends State<AppPreferencesSection> {
  final Map<String, bool> permissions = {
    'Location': true,
    'SMS': true,
    'Microphone': false,
    'Camera': false,
    'Contacts': true,
    'Storage': true,
  };

  bool batteryOptimizationEnabled = true;
  String dataRetention = '30 days';
  double cacheSize = 45.2; // MB

  final List<String> retentionOptions = [
    '7 days',
    '30 days',
    '90 days',
    '1 year',
    'Never delete'
  ];

  void _openPermissionSettings() {
    Navigator.pushNamed(context, '/permission-setup');
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: Text(
            'This will clear ${cacheSize.toStringAsFixed(1)} MB of cached data. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => cacheSize = 0.0);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showBatteryOptimizationInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Battery Optimization'),
        content: const Text(
          'When enabled, the app will run efficiently in the background to detect shake gestures for emergency alerts. '
          'Disabling this may affect the app\'s ability to respond to emergencies when not actively in use.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy & Data'),
        content: const Text(
          'Your emergency contacts and location data are stored locally on your device. '
          'No personal information is shared with third parties. '
          'SMS messages are sent directly from your device using your carrier plan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Understood'),
          ),
        ],
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
              'App Preferences',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),

            // Permissions Status
            _buildPermissionsSection(),

            SizedBox(height: 2.h),

            // Battery Optimization
            _buildBatteryOptimizationSection(),

            SizedBox(height: 2.h),

            // Storage Usage
            _buildStorageSection(),

            SizedBox(height: 2.h),

            // Privacy Controls
            _buildPrivacySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Permissions Status',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: _openPermissionSettings,
              child: Text(
                'Manage',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
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
          child: Column(
            children: permissions.entries
                .map((entry) => _buildPermissionRow(entry.key, entry.value))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionRow(String permission, bool isGranted) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: _getPermissionIcon(permission),
            color: isGranted
                ? AppTheme.lightTheme.colorScheme.secondary
                : AppTheme.lightTheme.colorScheme.error,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              permission,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: isGranted
                  ? AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.2)
                  : AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isGranted ? 'Granted' : 'Denied',
              style: TextStyle(
                color: isGranted
                    ? AppTheme.lightTheme.colorScheme.secondary
                    : AppTheme.lightTheme.colorScheme.error,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPermissionIcon(String permission) {
    switch (permission) {
      case 'Location':
        return 'location_on';
      case 'SMS':
        return 'sms';
      case 'Microphone':
        return 'mic';
      case 'Camera':
        return 'camera_alt';
      case 'Contacts':
        return 'contacts';
      case 'Storage':
        return 'storage';
      default:
        return 'security';
    }
  }

  Widget _buildBatteryOptimizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'battery_charging_full',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Battery Optimization',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Background processing for emergency detection',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _showBatteryOptimizationInfo,
              icon: CustomIconWidget(
                iconName: 'info_outline',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            Switch(
              value: batteryOptimizationEnabled,
              onChanged: (value) =>
                  setState(() => batteryOptimizationEnabled = value),
            ),
          ],
        ),
        if (batteryOptimizationEnabled) ...[
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Background shake detection is active',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStorageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Storage Usage',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            if (cacheSize > 0)
              TextButton(
                onPressed: _clearCache,
                child: Text(
                  'Clear Cache',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontSize: 12.sp,
                  ),
                ),
              ),
          ],
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
          child: Column(
            children: [
              _buildStorageRow('App Size', '12.3 MB', 'apps'),
              _buildStorageRow(
                  'Cache', '${cacheSize.toStringAsFixed(1)} MB', 'cached'),
              _buildStorageRow('User Data', '2.1 MB', 'folder'),
              Divider(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Usage',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${(14.4 + cacheSize).toStringAsFixed(1)} MB',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStorageRow(String label, String size, String iconName) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),
          Text(
            size,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Privacy Controls',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: _showPrivacyInfo,
              child: Text(
                'Learn More',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
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
          child: Column(
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Data Retention',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ),
                  DropdownButton<String>(
                    value: dataRetention,
                    underline: const SizedBox(),
                    items: retentionOptions.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(
                          option,
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => dataRetention = value);
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'security',
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Local Storage Only',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Secure',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
