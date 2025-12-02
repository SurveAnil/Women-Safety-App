import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/continue_button_widget.dart';
import './widgets/permission_card_widget.dart' as widgets;
import './widgets/progress_indicator_widget.dart';

// Custom PermissionStatus enum to avoid conflicts
enum PermissionStatus {
  notRequested,
  granted,
  denied,
}

class PermissionSetup extends StatefulWidget {
  const PermissionSetup({Key? key}) : super(key: key);

  @override
  State<PermissionSetup> createState() => _PermissionSetupState();
}

class _PermissionSetupState extends State<PermissionSetup>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _isLoading = false;

  // Permission status tracking
  Map<String, PermissionStatus> _permissionStatuses = {
    'location': PermissionStatus.notRequested,
    'sms': PermissionStatus.notRequested,
    'contacts': PermissionStatus.notRequested,
    'microphone': PermissionStatus.notRequested,
  };

  // Permission data
  final List<Map<String, dynamic>> _permissionData = [
    {
      'key': 'location',
      'icon': 'location_on',
      'title': 'Location Services',
      'description':
          'Required to send your exact location in emergency SMS messages to help responders find you quickly.',
      'isCritical': true,
    },
    {
      'key': 'sms',
      'icon': 'sms',
      'title': 'SMS Access',
      'description':
          'Essential for sending emergency alerts to your trusted contacts when you activate the SOS feature.',
      'isCritical': true,
    },
    {
      'key': 'contacts',
      'icon': 'contacts',
      'title': 'Contacts Access',
      'description':
          'Allows you to easily select emergency contacts from your phone book for faster setup.',
      'isCritical': false,
    },
    {
      'key': 'microphone',
      'icon': 'mic',
      'title': 'Microphone',
      'description':
          'Used for emergency siren sounds and voice recording features during safety situations.',
      'isCritical': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkInitialPermissions();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  Future<void> _checkInitialPermissions() async {
    final Map<String, PermissionStatus> statuses = <String, PermissionStatus>{};

    try {
      // Check location permission
      final locationStatus = await ph.Permission.location.status;
      statuses['location'] = _mapPermissionStatus(locationStatus);

      // Check SMS permission (Android only)
      final smsStatus = await ph.Permission.sms.status;
      statuses['sms'] = _mapPermissionStatus(smsStatus);

      // Check contacts permission
      final contactsStatus = await ph.Permission.contacts.status;
      statuses['contacts'] = _mapPermissionStatus(contactsStatus);

      // Check microphone permission
      final microphoneStatus = await ph.Permission.microphone.status;
      statuses['microphone'] = _mapPermissionStatus(microphoneStatus);

      if (mounted) {
        setState(() {
          _permissionStatuses = statuses;
        });
      }
    } catch (e) {
      // Handle permission check errors silently
      debugPrint('Error checking permissions: $e');
    }
  }

  PermissionStatus _mapPermissionStatus(ph.PermissionStatus status) {
    switch (status) {
      case ph.PermissionStatus.granted:
        return PermissionStatus.granted;
      case ph.PermissionStatus.denied:
      case ph.PermissionStatus.permanentlyDenied:
        return PermissionStatus.denied;
      default:
        return PermissionStatus.notRequested;
    }
  }

  Future<void> _requestPermission(String permissionKey) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      ph.Permission permission;
      String rationale = '';

      switch (permissionKey) {
        case 'location':
          permission = ph.Permission.location;
          rationale =
              'Location access is crucial for emergency services to locate you during SOS alerts. This helps ensure faster response times in critical situations.';
          break;
        case 'sms':
          permission = ph.Permission.sms;
          rationale =
              'SMS permission allows the app to send emergency messages to your trusted contacts automatically when you trigger an SOS alert.';
          break;
        case 'contacts':
          permission = ph.Permission.contacts;
          rationale =
              'Contact access makes it easier to select emergency contacts from your phone book, streamlining the safety setup process.';
          break;
        case 'microphone':
          permission = ph.Permission.microphone;
          rationale =
              'Microphone access enables emergency siren sounds and voice recording features that can help alert others during safety situations.';
          break;
        default:
          return;
      }

      // Show rationale dialog for better user understanding
      final shouldRequest = await _showPermissionRationale(
        _getPermissionTitle(permissionKey),
        rationale,
      );

      if (shouldRequest) {
        final status = await permission.request();

        if (mounted) {
          setState(() {
            _permissionStatuses[permissionKey] = _mapPermissionStatus(status);
          });

          // Provide haptic feedback
          if (status == ph.PermissionStatus.granted) {
            HapticFeedback.lightImpact();
          }
        }
      }
    } catch (e) {
      debugPrint('Error requesting permission: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> _showPermissionRationale(
      String title, String description) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'security',
                    color: AppTheme.primaryEmergency,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      title,
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              content: Text(
                description,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Skip',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryEmergency,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Grant Permission'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  String _getPermissionTitle(String key) {
    final permission = _permissionData.firstWhere((p) => p['key'] == key);
    return permission['title'] ?? '';
  }

  Future<void> _openAppSettings() async {
    try {
      await ph.openAppSettings();
    } catch (e) {
      debugPrint('Error opening app settings: $e');
    }
  }

  int get _completedPermissions {
    return _permissionStatuses.values
        .where((status) => status == PermissionStatus.granted)
        .length;
  }

  bool get _canContinue {
    // Critical permissions must be granted
    final criticalPermissions = _permissionData
        .where((p) => p['isCritical'] == true)
        .map((p) => p['key'] as String);

    return criticalPermissions
        .every((key) => _permissionStatuses[key] == PermissionStatus.granted);
  }

  Future<void> _handleContinue() async {
    if (!_canContinue || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Show success animation
    await _showSuccessAnimation();

    // Navigate to home screen
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home-screen');
    }
  }

  Future<void> _showSuccessAnimation() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: AppTheme.successConfirmation,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'check',
                  color: Colors.white,
                  size: 10.w,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Setup Complete!',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.successConfirmation,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'Your safety features are now ready to use.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );

    // Auto-close after 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.textPrimary,
            size: 6.w,
          ),
        ),
        title: Text(
          'Safety Setup',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Progress indicator
            ProgressIndicatorWidget(
              totalSteps: _permissionData.length,
              completedSteps: _completedPermissions,
            ),

            // Permission cards list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                itemCount: _permissionData.length,
                itemBuilder: (context, index) {
                  final permission = _permissionData[index];
                  final key = permission['key'] as String;
                  final status =
                      _permissionStatuses[key] ?? PermissionStatus.notRequested;

                  return widgets.PermissionCardWidget(
                    iconName: permission['icon'] as String,
                    title: permission['title'] as String,
                    description: permission['description'] as String,
                    status: _mapToWidgetPermissionStatus(status),
                    onTap: () => _requestPermission(key),
                    onOpenSettings: status == PermissionStatus.denied
                        ? _openAppSettings
                        : null,
                  );
                },
              ),
            ),

            // Continue button
            ContinueButtonWidget(
              isEnabled: _canContinue,
              isLoading: _isLoading,
              onPressed: _handleContinue,
            ),
          ],
        ),
      ),
    );
  }

  // Add this helper method to convert between enum types
  widgets.PermissionStatus _mapToWidgetPermissionStatus(
      PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return widgets.PermissionStatus.granted;
      case PermissionStatus.denied:
        return widgets.PermissionStatus.denied;
      case PermissionStatus.notRequested:
        return widgets.PermissionStatus.notRequested;
    }
  }
}
