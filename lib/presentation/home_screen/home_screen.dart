import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/bottom_navigation_widget.dart';
import './widgets/location_status_widget.dart';
import './widgets/quick_stats_widget.dart';
import './widgets/safety_tips_carousel_widget.dart';
import './widgets/shake_detection_widget.dart';
import './widgets/sos_button_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // State variables
  bool _isLocationEnabled = true;
  String _lastLocationUpdate = "2 min ago";
  bool _isShakeDetectionEnabled = true;
  String _shakeSensitivity = "Medium";
  int _emergencyContactsCount = 3;
  String _lastPracticeSession = "3 days ago";
  int _currentNavIndex = 0;
  bool _isEmergencyMode = false;

  // Animation controllers
  late AnimationController _emergencyAnimationController;
  late Animation<Color?> _emergencyColorAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadUserData();
  }

  @override
  void dispose() {
    _emergencyAnimationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _emergencyAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _emergencyColorAnimation = ColorTween(
      begin: AppTheme.backgroundPrimary,
      end: AppTheme.primaryEmergency.withValues(alpha: 0.1),
    ).animate(CurvedAnimation(
      parent: _emergencyAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _loadUserData() async {
    // Simulate loading user preferences and data
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isLocationEnabled = true;
        _lastLocationUpdate = "Just now";
        _emergencyContactsCount = 3;
        _lastPracticeSession = "3 days ago";
      });
    }
  }

  Future<void> _refreshData() async {
    HapticFeedback.lightImpact();

    // Simulate refreshing location and sync status
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _lastLocationUpdate = "Just now";
        _isLocationEnabled = true;
      });
    }
  }

  void _handlePracticeSOS() {
    HapticFeedback.mediumImpact();

    // Navigate to practice SOS simulation
    _showPracticeConfirmationDialog();
  }

  void _handleRealSOS() {
    HapticFeedback.heavyImpact();

    // Show confirmation dialog for real SOS
    _showRealSOSConfirmationDialog();
  }

  void _handleRealSOSLongPress() {
    HapticFeedback.heavyImpact();

    // Direct navigation to real SOS with long press
    _showRealSOSConfirmationDialog();
  }

  void _showPracticeConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'play_circle_outline',
                color: AppTheme.successConfirmation,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Practice SOS',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'This will start a safe practice session. No real alerts will be sent to your emergency contacts.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to practice SOS screen (would be implemented)
                _startPracticeSession();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.successConfirmation,
              ),
              child: const Text('Start Practice'),
            ),
          ],
        );
      },
    );
  }

  void _showRealSOSConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.primaryEmergency,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Emergency Alert',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryEmergency,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This will send REAL emergency alerts to your contacts with your current location.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryEmergency.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryEmergency.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Only use in genuine emergencies',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryEmergency,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/real-sos-alert-screen');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryEmergency,
              ),
              child: const Text('Send Alert'),
            ),
          ],
        );
      },
    );
  }

  void _startPracticeSession() {
    setState(() {
      _lastPracticeSession = "Just now";
    });

    // Show practice mode feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.successConfirmation,
              size: 20,
            ),
            SizedBox(width: 2.w),
            const Text('Practice session started safely'),
          ],
        ),
        backgroundColor: AppTheme.successConfirmation,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _toggleShakeDetection() {
    setState(() {
      _isShakeDetectionEnabled = !_isShakeDetectionEnabled;
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isShakeDetectionEnabled
              ? 'Shake detection enabled'
              : 'Shake detection disabled',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToContacts() {
    Navigator.pushNamed(context, '/emergency-contacts');
  }

  void _handleBottomNavTap(int index) {
    setState(() => _currentNavIndex = index);

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/emergency-contacts');
        break;
      case 2:
        Navigator.pushNamed(context, '/settings-screen');
        break;
    }
  }

  void _showHelpOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.borderSubtle,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Safety Tips & Help',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            const Expanded(
              child: SafetyTipsCarouselWidget(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: AnimatedBuilder(
        animation: _emergencyColorAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _emergencyColorAnimation.value ?? AppTheme.backgroundPrimary,
                  AppTheme.backgroundPrimary,
                ],
              ),
            ),
            child: SafeArea(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refreshData,
                color: AppTheme.primaryEmergency,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      floating: true,
                      snap: true,
                      title: Text(
                        'SafeGuard Women',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      actions: [
                        IconButton(
                          onPressed: _showHelpOverlay,
                          icon: CustomIconWidget(
                            iconName: 'help_outline',
                            color: AppTheme.textSecondary,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.h),

                          // Location Status
                          LocationStatusWidget(
                            isLocationEnabled: _isLocationEnabled,
                            lastUpdate: _lastLocationUpdate,
                            onRefresh: _refreshData,
                          ),

                          SizedBox(height: 4.h),

                          // SOS Buttons
                          SosButtonWidget(
                            title: 'Practice SOS',
                            subtitle: 'Safe to test',
                            isPrimary: false,
                            onTap: _handlePracticeSOS,
                          ),

                          SosButtonWidget(
                            title: 'Real SOS Alert',
                            subtitle: 'Emergency Only',
                            isPrimary: true,
                            onTap: _handleRealSOS,
                            onLongPress: _handleRealSOSLongPress,
                          ),

                          SizedBox(height: 3.h),

                          // Shake Detection Status
                          ShakeDetectionWidget(
                            isEnabled: _isShakeDetectionEnabled,
                            sensitivity: _shakeSensitivity,
                            onToggle: _toggleShakeDetection,
                          ),

                          SizedBox(height: 2.h),

                          // Quick Stats
                          QuickStatsWidget(
                            contactsCount: _emergencyContactsCount,
                            lastPracticeSession: _lastPracticeSession,
                            onContactsTap: _navigateToContacts,
                          ),

                          SizedBox(height: 3.h),

                          // Safety Tips Carousel
                          const SafetyTipsCarouselWidget(),

                          SizedBox(
                              height: 10.h), // Bottom padding for navigation
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentNavIndex,
        onTap: _handleBottomNavTap,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showHelpOverlay,
        backgroundColor: AppTheme.primaryEmergency,
        child: CustomIconWidget(
          iconName: 'help',
          color: AppTheme.backgroundPrimary,
          size: 24,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
