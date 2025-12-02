import 'package:flutter/material.dart';
import '../presentation/real_sos_alert_screen/real_sos_alert_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/permission_setup/permission_setup.dart';
import '../presentation/add_contact_screen/add_contact_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/emergency_contacts/emergency_contacts.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String realSosAlert = '/real-sos-alert-screen';
  static const String settings = '/settings-screen';
  static const String permissionSetup = '/permission-setup';
  static const String addContact = '/add-contact-screen';
  static const String home = '/home-screen';
  static const String emergencyContacts = '/emergency-contacts';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const RealSosAlertScreen(),
    realSosAlert: (context) => const RealSosAlertScreen(),
    settings: (context) => const SettingsScreen(),
    permissionSetup: (context) => const PermissionSetup(),
    addContact: (context) => const AddContactScreen(),
    home: (context) => const HomeScreen(),
    emergencyContacts: (context) => const EmergencyContacts(),
    // TODO: Add your other routes here
  };
}
