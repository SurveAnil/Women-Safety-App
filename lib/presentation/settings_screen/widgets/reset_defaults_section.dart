import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ResetDefaultsSection extends StatelessWidget {
  const ResetDefaultsSection({super.key});

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 24,
            ),
            SizedBox(width: 2.w),
            const Text('Reset to Defaults'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will reset all settings to their default values:',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 1.h),
            _buildResetItem('• Siren sound: Classic Siren'),
            _buildResetItem('• Vibration: Emergency Pattern'),
            _buildResetItem('• Visual effects: Red Flash'),
            _buildResetItem('• Shake sensitivity: 70%'),
            _buildResetItem('• Auto-location: Enabled'),
            _buildResetItem('• Message template: Emergency Alert'),
            _buildResetItem('• Practice reminders: Weekly'),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Emergency contacts will NOT be deleted',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performReset(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: AppTheme.lightTheme.colorScheme.onError,
            ),
            child: const Text('Reset All'),
          ),
        ],
      ),
    );
  }

  Widget _buildResetItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Text(
        text,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  void _performReset(BuildContext context) {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 2.h),
            const Text('Resetting settings...'),
          ],
        ),
      ),
    );

    // Simulate reset process
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog

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
              const Text('Settings reset to defaults successfully'),
            ],
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showResetConfirmation(context),
              icon: CustomIconWidget(
                iconName: 'restore',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 20,
              ),
              label: const Text('Reset to Defaults'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.lightTheme.colorScheme.error,
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.error,
                  width: 1.5,
                ),
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'This will restore all safety settings to their recommended defaults. Your emergency contacts will remain unchanged.',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
