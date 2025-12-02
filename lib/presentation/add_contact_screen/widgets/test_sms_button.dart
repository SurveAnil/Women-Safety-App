import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TestSmsButton extends StatefulWidget {
  final String phoneNumber;
  final bool isEnabled;

  const TestSmsButton({
    Key? key,
    required this.phoneNumber,
    required this.isEnabled,
  }) : super(key: key);

  @override
  State<TestSmsButton> createState() => _TestSmsButtonState();
}

class _TestSmsButtonState extends State<TestSmsButton> {
  bool _isSending = false;
  bool _isDelivered = false;

  Future<void> _sendTestSms() async {
    if (!widget.isEnabled || _isSending) return;

    setState(() {
      _isSending = true;
      _isDelivered = false;
    });

    HapticFeedback.lightImpact();

    try {
      // Simulate SMS sending process
      await Future.delayed(Duration(milliseconds: 1500));

      // Simulate delivery confirmation
      await Future.delayed(Duration(milliseconds: 500));

      setState(() {
        _isSending = false;
        _isDelivered = true;
      });

      _showDeliveryConfirmation();

      // Reset delivery status after 3 seconds
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isDelivered = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        _isSending = false;
        _isDelivered = false;
      });

      _showErrorMessage(
          'Failed to send test SMS. Please check the phone number and try again.');
    }
  }

  void _showDeliveryConfirmation() {
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
                'Test SMS sent successfully to ${widget.phoneNumber}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
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
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: ElevatedButton.icon(
        onPressed: widget.isEnabled && !_isSending ? _sendTestSms : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isDelivered
              ? AppTheme.lightTheme.colorScheme.secondary
              : AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: widget.isEnabled ? 2 : 0,
        ),
        icon: _isSending
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : CustomIconWidget(
                iconName: _isDelivered ? 'check_circle' : 'sms',
                color: Colors.white,
                size: 20,
              ),
        label: Text(
          _isSending
              ? 'Sending...'
              : _isDelivered
                  ? 'SMS Delivered'
                  : 'Test SMS',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
