import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CancelEmergencyWidget extends StatefulWidget {
  final Function(bool sendAllClear) onCancelEmergency;

  const CancelEmergencyWidget({
    Key? key,
    required this.onCancelEmergency,
  }) : super(key: key);

  @override
  State<CancelEmergencyWidget> createState() => _CancelEmergencyWidgetState();
}

class _CancelEmergencyWidgetState extends State<CancelEmergencyWidget>
    with TickerProviderStateMixin {
  bool _isLongPressing = false;
  double _longPressProgress = 0.0;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation.addListener(() {
      setState(() {
        _longPressProgress = _progressAnimation.value;
      });
    });

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showCancelConfirmationDialog();
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    setState(() {
      _isLongPressing = true;
    });
    _progressController.forward();
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    setState(() {
      _isLongPressing = false;
      _longPressProgress = 0.0;
    });
    _progressController.reset();
  }

  void _showCancelConfirmationDialog() {
    setState(() {
      _isLongPressing = false;
      _longPressProgress = 0.0;
    });
    _progressController.reset();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Cancel Emergency',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to cancel the emergency alert?',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'You can optionally send an "All Clear" message to notify your contacts that you are safe.',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Continue Alert',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onCancelEmergency(false);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              child: Text(
                'Cancel Only',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onCancelEmergency(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              ),
              child: Text(
                'Send All Clear',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: GestureDetector(
        onLongPressStart: _onLongPressStart,
        onLongPressEnd: _onLongPressEnd,
        child: Container(
          height: 8.h,
          decoration: BoxDecoration(
            color: _isLongPressing
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary,
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              // Progress indicator
              if (_isLongPressing) ...[
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: LinearProgressIndicator(
                        value: _longPressProgress,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.3),
                        ),
                        minHeight: double.infinity,
                      ),
                    ),
                  ),
                ),
              ],
              // Button content
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'cancel',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 6.w,
                    ),
                    SizedBox(width: 3.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Cancel Emergency',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          _isLongPressing
                              ? 'Hold to confirm...'
                              : 'Hold to cancel',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
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
    );
  }
}
