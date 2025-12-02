import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the safety application.
/// Implements Emergency-Ready Minimalism design approach with High-Stakes Clarity color palette.
class AppTheme {
  AppTheme._();

  // Emergency-focused color palette
  static const Color primaryEmergency =
      Color(0xFFDC2626); // High-contrast red for emergency recognition
  static const Color secondaryAlert =
      Color(0xFFEF4444); // Supporting red for less critical alerts
  static const Color successConfirmation =
      Color(0xFF059669); // Clear green for positive confirmations
  static const Color warningAccent =
      Color(0xFFD97706); // Amber for simulation mode indicators
  static const Color backgroundPrimary =
      Color(0xFFFFFFFF); // Pure white for maximum contrast
  static const Color backgroundSecondary =
      Color(0xFFF9FAFB); // Subtle gray for secondary surfaces
  static const Color textPrimary = Color(0xFF111827); // High-contrast dark gray
  static const Color textSecondary =
      Color(0xFF6B7280); // Medium gray for supporting information
  static const Color borderSubtle = Color(0xFFE5E7EB); // Minimal border color
  static const Color surfaceElevated =
      Color(0xFFF3F4F6); // Light surface for cards and elevated elements

  // Dark theme variants (maintaining safety-first approach)
  static const Color primaryEmergencyDark = Color(0xFFEF4444);
  static const Color secondaryAlertDark = Color(0xFFF87171);
  static const Color successConfirmationDark = Color(0xFF10B981);
  static const Color warningAccentDark = Color(0xFFF59E0B);
  static const Color backgroundPrimaryDark = Color(0xFF111827);
  static const Color backgroundSecondaryDark = Color(0xFF1F2937);
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color borderSubtleDark = Color(0xFF374151);
  static const Color surfaceElevatedDark = Color(0xFF374151);

  // Additional semantic colors
  static const Color shadowLight = Color(0x0F000000);
  static const Color shadowDark = Color(0x1F000000);
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color dividerDark = Color(0xFF374151);

  /// Light theme optimized for emergency situations
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryEmergency,
      onPrimary: backgroundPrimary,
      primaryContainer: secondaryAlert,
      onPrimaryContainer: backgroundPrimary,
      secondary: successConfirmation,
      onSecondary: backgroundPrimary,
      secondaryContainer: successConfirmation.withValues(alpha: 0.1),
      onSecondaryContainer: textPrimary,
      tertiary: warningAccent,
      onTertiary: backgroundPrimary,
      tertiaryContainer: warningAccent.withValues(alpha: 0.1),
      onTertiaryContainer: textPrimary,
      error: primaryEmergency,
      onError: backgroundPrimary,
      surface: backgroundPrimary,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: borderSubtle,
      outlineVariant: borderSubtle.withValues(alpha: 0.5),
      shadow: shadowLight,
      scrim: textPrimary.withValues(alpha: 0.5),
      inverseSurface: textPrimary,
      onInverseSurface: backgroundPrimary,
      inversePrimary: primaryEmergencyDark,
    ),
    scaffoldBackgroundColor: backgroundPrimary,
    cardColor: surfaceElevated,
    dividerColor: dividerLight,
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundPrimary,
      foregroundColor: textPrimary,
      elevation: 0,
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.15,
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceElevated,
      elevation: 2.0,
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(8.0),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundPrimary,
      selectedItemColor: primaryEmergency,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 4.0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryEmergency,
      foregroundColor: backgroundPrimary,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: backgroundPrimary,
        backgroundColor: primaryEmergency,
        elevation: 2.0,
        shadowColor: shadowLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        minimumSize: const Size(120, 48),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryEmergency,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: primaryEmergency, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        minimumSize: const Size(120, 48),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryEmergency,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    ),
    textTheme: _buildTextTheme(isLight: true),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: backgroundSecondary,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderSubtle, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderSubtle, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryEmergency, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryEmergency, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryEmergency, width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: primaryEmergency,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryEmergency;
        }
        return textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryEmergency.withValues(alpha: 0.3);
        }
        return borderSubtle;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryEmergency;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(backgroundPrimary),
      side: const BorderSide(color: borderSubtle, width: 2.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryEmergency;
        }
        return borderSubtle;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryEmergency,
      linearTrackColor: borderSubtle,
      circularTrackColor: borderSubtle,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryEmergency,
      thumbColor: primaryEmergency,
      overlayColor: primaryEmergency.withValues(alpha: 0.2),
      inactiveTrackColor: borderSubtle,
      trackHeight: 4.0,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: primaryEmergency,
      unselectedLabelColor: textSecondary,
      indicatorColor: primaryEmergency,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: backgroundPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimary,
      contentTextStyle: GoogleFonts.inter(
        color: backgroundPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: primaryEmergency,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: backgroundPrimary,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: backgroundPrimary,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
    ),
  );

  /// Dark theme optimized for emergency situations
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryEmergencyDark,
      onPrimary: backgroundPrimaryDark,
      primaryContainer: secondaryAlertDark,
      onPrimaryContainer: backgroundPrimaryDark,
      secondary: successConfirmationDark,
      onSecondary: backgroundPrimaryDark,
      secondaryContainer: successConfirmationDark.withValues(alpha: 0.2),
      onSecondaryContainer: textPrimaryDark,
      tertiary: warningAccentDark,
      onTertiary: backgroundPrimaryDark,
      tertiaryContainer: warningAccentDark.withValues(alpha: 0.2),
      onTertiaryContainer: textPrimaryDark,
      error: primaryEmergencyDark,
      onError: backgroundPrimaryDark,
      surface: backgroundPrimaryDark,
      onSurface: textPrimaryDark,
      onSurfaceVariant: textSecondaryDark,
      outline: borderSubtleDark,
      outlineVariant: borderSubtleDark.withValues(alpha: 0.5),
      shadow: shadowDark,
      scrim: textPrimaryDark.withValues(alpha: 0.5),
      inverseSurface: textPrimaryDark,
      onInverseSurface: backgroundPrimaryDark,
      inversePrimary: primaryEmergency,
    ),
    scaffoldBackgroundColor: backgroundPrimaryDark,
    cardColor: surfaceElevatedDark,
    dividerColor: dividerDark,
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundPrimaryDark,
      foregroundColor: textPrimaryDark,
      elevation: 0,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
        letterSpacing: 0.15,
      ),
      iconTheme: const IconThemeData(
        color: textPrimaryDark,
        size: 24,
      ),
    ),
    cardTheme: CardThemeData(
      color: surfaceElevatedDark,
      elevation: 2.0,
      shadowColor: shadowDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(8.0),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundPrimaryDark,
      selectedItemColor: primaryEmergencyDark,
      unselectedItemColor: textSecondaryDark,
      type: BottomNavigationBarType.fixed,
      elevation: 4.0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryEmergencyDark,
      foregroundColor: backgroundPrimaryDark,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: backgroundPrimaryDark,
        backgroundColor: primaryEmergencyDark,
        elevation: 2.0,
        shadowColor: shadowDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        minimumSize: const Size(120, 48),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryEmergencyDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: primaryEmergencyDark, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        minimumSize: const Size(120, 48),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryEmergencyDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    ),
    textTheme: _buildTextTheme(isLight: false),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: backgroundSecondaryDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderSubtleDark, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderSubtleDark, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryEmergencyDark, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryEmergencyDark, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: primaryEmergencyDark, width: 2.0),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondaryDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textSecondaryDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: primaryEmergencyDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryEmergencyDark;
        }
        return textSecondaryDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryEmergencyDark.withValues(alpha: 0.3);
        }
        return borderSubtleDark;
      }),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryEmergencyDark;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(backgroundPrimaryDark),
      side: const BorderSide(color: borderSubtleDark, width: 2.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryEmergencyDark;
        }
        return borderSubtleDark;
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryEmergencyDark,
      linearTrackColor: borderSubtleDark,
      circularTrackColor: borderSubtleDark,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryEmergencyDark,
      thumbColor: primaryEmergencyDark,
      overlayColor: primaryEmergencyDark.withValues(alpha: 0.2),
      inactiveTrackColor: borderSubtleDark,
      trackHeight: 4.0,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: primaryEmergencyDark,
      unselectedLabelColor: textSecondaryDark,
      indicatorColor: primaryEmergencyDark,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: textPrimaryDark.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: backgroundPrimaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: textPrimaryDark,
      contentTextStyle: GoogleFonts.inter(
        color: backgroundPrimaryDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: primaryEmergencyDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: backgroundPrimaryDark,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: backgroundPrimaryDark,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
      ),
    ),
  );

  /// Helper method to build text theme based on brightness
  /// Uses Inter font family for exceptional legibility and JetBrains Mono for data
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis = isLight ? textPrimary : textPrimaryDark;
    final Color textMediumEmphasis =
        isLight ? textSecondary : textSecondaryDark;
    final Color textDisabled = isLight
        ? textSecondary.withValues(alpha: 0.6)
        : textSecondaryDark.withValues(alpha: 0.6);

    return TextTheme(
      // Display styles - Inter 700 for maximum emergency visibility
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        color: textHighEmphasis,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles - Inter 600 for strong character recognition
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles - Inter 500/600 for clear hierarchy
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textHighEmphasis,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles - Inter 400/500 for extended reading
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textHighEmphasis,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMediumEmphasis,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles - Inter 400/500 for UI elements
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textHighEmphasis,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textMediumEmphasis,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: textDisabled,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }

  /// Helper method to get monospace text style for data display
  /// Uses JetBrains Mono for phone numbers, addresses, and technical information
  static TextStyle getDataTextStyle({
    required bool isLight,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    final Color textColor = isLight ? textPrimary : textPrimaryDark;

    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
      letterSpacing: 0.25,
      height: 1.43,
    );
  }

  /// Helper method to get emergency button text style
  /// Optimized for high-stress situations with maximum legibility
  static TextStyle getEmergencyButtonTextStyle({
    required bool isLight,
    double fontSize = 18,
  }) {
    final Color textColor = isLight ? backgroundPrimary : backgroundPrimaryDark;

    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: textColor,
      letterSpacing: 0.5,
      height: 1.22,
    );
  }
}
