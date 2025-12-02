import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/alert_customization_section.dart';
import './widgets/app_preferences_section.dart';
import './widgets/emergency_features_section.dart';
import './widgets/reset_defaults_section.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 2; // Settings tab is active

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home-screen');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/emergency-contacts');
        break;
      case 2:
        // Already on settings screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.appBarTheme.iconTheme?.color ??
                AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Settings Help'),
                  content: const Text(
                    'Customize your safety features to ensure optimal emergency response. '
                    'Test different settings to find what works best for your needs. '
                    'Remember to practice using the emergency features regularly.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.lightTheme.appBarTheme.iconTheme?.color ??
                  AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                onTap: _onTabChanged,
                tabs: [
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'home',
                      color: _currentIndex == 0
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Home',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'contacts',
                      color: _currentIndex == 1
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Contacts',
                  ),
                  Tab(
                    icon: CustomIconWidget(
                      iconName: 'settings',
                      color: _currentIndex == 2
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    text: 'Settings',
                  ),
                ],
                labelColor: AppTheme.lightTheme.colorScheme.primary,
                unselectedLabelColor:
                    AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                indicatorColor: AppTheme.lightTheme.colorScheme.primary,
                labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle:
                    AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // Settings Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 1.h),

                    // Header Section
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            AppTheme.lightTheme.colorScheme.secondary
                                .withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CustomIconWidget(
                              iconName: 'tune',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Customize Your Safety',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  'Personalize alerts, manage contacts, and optimize your emergency response settings',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Alert Customization Section
                    const AlertCustomizationSection(),

                    // Emergency Features Section
                    const EmergencyFeaturesSection(),

                    // App Preferences Section
                    const AppPreferencesSection(),

                    // Reset Defaults Section
                    const ResetDefaultsSection(),

                    SizedBox(height: 2.h),

                    // Footer
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'security',
                                color:
                                    AppTheme.lightTheme.colorScheme.secondary,
                                size: 16,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'SafeGuard Women v1.0.0',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Your safety is our priority. Settings are saved automatically.',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
