import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/active_alerts_widget.dart';
import './widgets/cancel_emergency_widget.dart';
import './widgets/emergency_contacts_list_widget.dart';
import './widgets/emergency_header_widget.dart';
import './widgets/location_status_widget.dart';
import './widgets/sms_status_widget.dart';

class RealSosAlertScreen extends StatefulWidget {
  const RealSosAlertScreen({Key? key}) : super(key: key);

  @override
  State<RealSosAlertScreen> createState() => _RealSosAlertScreenState();
}

class _RealSosAlertScreenState extends State<RealSosAlertScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late DateTime _alertStartTime;
  late AnimationController _flashController;
  late Animation<Color?> _flashAnimation;

  // Alert states
  bool _isSirenActive = true;
  bool _isVibrationActive = true;
  bool _isVisualAlertActive = true;
  double _vibrationIntensity = 0.8;
  bool _isLocationSharing = true;

  // Mock data
  final List<Map<String, dynamic>> _emergencyContacts = [
    {
      "id": 1,
      "name": "Sarah Johnson",
      "phone": "+1 (555) 123-4567",
      "relationship": "Sister",
      "isPrimary": true,
    },
    {
      "id": 2,
      "name": "Michael Rodriguez",
      "phone": "+1 (555) 987-6543",
      "relationship": "Emergency Contact",
      "isPrimary": false,
    },
    {
      "id": 3,
      "name": "Dr. Emily Chen",
      "phone": "+1 (555) 456-7890",
      "relationship": "Family Doctor",
      "isPrimary": false,
    },
  ];

  final Map<String, String> _deliveryStatus = {
    "1": "delivered",
    "2": "sent",
    "3": "failed",
  };

  final Map<String, dynamic> _locationData = {
    "latitude": 40.7128,
    "longitude": -74.0060,
    "accuracy": 12.5,
    "timestamp": DateTime.now().subtract(const Duration(minutes: 2)),
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _alertStartTime = DateTime.now();
    _initializeFlashAnimation();
    _keepScreenAwake();
    _startEmergencyProcedures();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flashController.dispose();
    _allowScreenSleep();
    super.dispose();
  }

  void _initializeFlashAnimation() {
    _flashController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _flashAnimation = ColorTween(
      begin: AppTheme.lightTheme.scaffoldBackgroundColor,
      end: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
    ).animate(CurvedAnimation(
      parent: _flashController,
      curve: Curves.easeInOut,
    ));

    if (_isVisualAlertActive) {
      _flashController.repeat(reverse: true);
    }
  }

  void _keepScreenAwake() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void _allowScreenSleep() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  void _startEmergencyProcedures() {
    // Simulate SMS sending process
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _deliveryStatus["2"] = "delivered";
        });
      }
    });

    // Simulate vibration patterns
    if (_isVibrationActive) {
      _triggerVibration();
    }
  }

  void _triggerVibration() {
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && _isVibrationActive) {
        HapticFeedback.mediumImpact();
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && _isVibrationActive) {
            _triggerVibration();
          }
        });
      }
    });
  }

  void _toggleSiren() {
    setState(() {
      _isSirenActive = !_isSirenActive;
    });

    if (_isSirenActive) {
      // Start siren sound
      HapticFeedback.selectionClick();
    }
  }

  void _toggleVibration() {
    setState(() {
      _isVibrationActive = !_isVibrationActive;
    });

    if (_isVibrationActive) {
      _triggerVibration();
    }
  }

  void _toggleVisualAlert() {
    setState(() {
      _isVisualAlertActive = !_isVisualAlertActive;
    });

    if (_isVisualAlertActive) {
      _flashController.repeat(reverse: true);
    } else {
      _flashController.stop();
      _flashController.reset();
    }
  }

  void _retryMessage(String contactId) {
    setState(() {
      _deliveryStatus[contactId] = "sending";
    });

    // Simulate retry process
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _deliveryStatus[contactId] = "delivered";
        });
      }
    });

    HapticFeedback.lightImpact();
  }

  void _addContact() {
    Navigator.pushNamed(context, '/add-contact-screen');
  }

  void _cancelEmergency(bool sendAllClear) {
    if (sendAllClear) {
      // Send all clear message to contacts
      for (final contact in _emergencyContacts) {
        final contactId = contact['id'].toString();
        if (_deliveryStatus[contactId] == 'delivered' ||
            _deliveryStatus[contactId] == 'sent') {
          // Send all clear SMS
        }
      }
    }

    // Stop all alert features
    setState(() {
      _isSirenActive = false;
      _isVibrationActive = false;
      _isVisualAlertActive = false;
    });

    _flashController.stop();
    _allowScreenSleep();

    // Navigate back to home
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home-screen',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flashAnimation,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _isVisualAlertActive
              ? _flashAnimation.value
              : AppTheme.lightTheme.scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  // Emergency Header
                  EmergencyHeaderWidget(
                    alertStartTime: _alertStartTime,
                  ),

                  SizedBox(height: 3.h),

                  // SMS Status
                  SmsStatusWidget(
                    emergencyContacts: _emergencyContacts,
                    deliveryStatus: _deliveryStatus,
                    onRetryMessage: _retryMessage,
                  ),

                  SizedBox(height: 2.h),

                  // Location Status
                  LocationStatusWidget(
                    locationData: _locationData,
                    isLocationSharing: _isLocationSharing,
                  ),

                  SizedBox(height: 2.h),

                  // Active Alerts
                  ActiveAlertsWidget(
                    isSirenActive: _isSirenActive,
                    isVibrationActive: _isVibrationActive,
                    isVisualAlertActive: _isVisualAlertActive,
                    vibrationIntensity: _vibrationIntensity,
                    onToggleSiren: _toggleSiren,
                    onToggleVibration: _toggleVibration,
                    onToggleVisualAlert: _toggleVisualAlert,
                  ),

                  SizedBox(height: 2.h),

                  // Emergency Contacts List
                  EmergencyContactsListWidget(
                    emergencyContacts: _emergencyContacts,
                    deliveryStatus: _deliveryStatus,
                    onRetryMessage: _retryMessage,
                    onAddContact: _addContact,
                  ),

                  SizedBox(height: 4.h),

                  // Cancel Emergency Button
                  CancelEmergencyWidget(
                    onCancelEmergency: _cancelEmergency,
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
