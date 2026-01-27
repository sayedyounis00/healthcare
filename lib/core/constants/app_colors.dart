import 'package:flutter/material.dart';

/// Medical & Healthcare App - Professional Color Scheme
/// Designed for trust, calmness, and accessibility
class AppColors {
  AppColors._();

  // ==================== Primary Medical Colors ====================

  // Medical Blue - Trust, security, and professionalism
  static const Color skyBlue = Color(0xFFE3F2FD);
  static const Color lightBlue = Color(0xFF90CAF9);
  static const Color lighterBlue = Color.fromARGB(141, 144, 202, 249);
  static const Color medicalBlue = Color(0xFF2196F3);
  static const Color deepBlue = Color(0xFF1565C0);
  static const Color darkBlue = Color(0xFF0D47A1);

  // Healing Green - Health, wellness, and nature
  static const Color mintGreen = Color(0xFFE8F5E9);
  static const Color lightGreen = Color(0xFF81C784);
  static const Color healingGreen = Color(0xFF4CAF50);
  static const Color medicalGreen = Color(0xFF2E7D32);
  static const Color forestGreen = Color(0xFF1B5E20);

  // Medical Teal - Balance and calm (combination of blue and green)
  static const Color lightTeal = Color(0xFFB2DFDB);
  static const Color medicalTeal = Color(0xFF26A69A);
  static const Color deepTeal = Color(0xFF00796B);

  // Accent Purple - Care and compassion
  static const Color lavender = Color(0xFFF3E5F5);
  static const Color lightPurple = Color(0xFFCE93D8);
  static const Color carePurple = Color(0xFF9C27B0);
  static const Color deepPurple = Color(0xFF6A1B9A);

  // Warm Accents - Energy and encouragement
  static const Color peach = Color(0xFFFFE0B2);
  static const Color warmOrange = Color(0xFFFFB74D);
  static const Color accentOrange = Color(0xFFFF9800);

  // Calm Pink - Comfort and warmth (for women's health, pediatrics)
  static const Color softPink = Color(0xFFFCE4EC);
  static const Color lightPink = Color(0xFFF48FB1);
  static const Color medicalPink = Color(0xFFEC407A);

  // ==================== Neutral & Background Colors ====================

  // Light Mode Backgrounds
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFF5F5F5);
  static const Color dividerLight = Color(0xFFE0E0E0);

  // Dark Mode Backgrounds
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2C2C2C);
  static const Color dividerDark = Color(0xFF3C3C3C);

  // Neutral Grays
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // ==================== Semantic Colors ====================

  // Success - Healthy status, completed appointments
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color success = Color(0xFF4CAF50);
  static const Color successDark = Color(0xFF2E7D32);

  // Warning - Attention needed, pending actions
  static const Color warningLight = Color(0xFFFFF8E1);
  static const Color warning = Color(0xFFFFC107);
  static const Color warningDark = Color(0xFFF57C00);

  // Error - Critical alerts, missed appointments
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color error = Color(0xFFF44336);
  static const Color errorDark = Color(0xFFC62828);

  // Info - Medical information, tips
  static const Color infoLight = Color(0xFFE3F2FD);
  static const Color info = Color(0xFF2196F3);
  static const Color infoDark = Color(0xFF1565C0);

  // Emergency - Critical attention required
  static const Color emergencyLight = Color(0xFFFFEBEE);
  static const Color emergency = Color(0xFFD32F2F);
  static const Color emergencyDark = Color(0xFFB71C1C);

  // ==================== Text Colors ====================

  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textTertiaryLight = Color(0xFF9E9E9E);
  static const Color textDisabledLight = Color(0xFFBDBDBD);

  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textTertiaryDark = Color(0xFF808080);
  static const Color textDisabledDark = Color(0xFF616161);

  // ==================== Special Medical Use Colors ====================

  // Vital Signs Colors
  static const Color heartRate = Color(0xFFEF5350);
  static const Color bloodPressure = Color(0xFF2196F3);
  static const Color temperature = Color(0xFFFF9800);
  static const Color oxygen = Color(0xFF4CAF50);
  static const Color glucose = Color(0xFF9C27B0);

  // Appointment Status
  static const Color scheduled = Color(0xFF2196F3);
  static const Color confirmed = Color(0xFF4CAF50);
  static const Color completed = Color(0xFF757575);
  static const Color cancelled = Color(0xFFF44336);
  static const Color pending = Color(0xFFFFC107);

  // Medical Specialties Colors
  static const Color cardiology = Color(0xFFEF5350);
  static const Color neurology = Color(0xFF9C27B0);
  static const Color orthopedics = Color(0xFF607D8B);
  static const Color pediatrics = Color(0xFFFF9800);
  static const Color gynecology = Color(0xFFEC407A);
  static const Color generalMedicine = Color(0xFF2196F3);
  static const Color dentistry = Color(0xFF00BCD4);
  static const Color dermatology = Color(0xFFFFEB3B);

  // Medication & Treatment
  static const Color medicationPrimary = Color(0xFF2196F3);
  static const Color medicationSecondary = Color(0xFF4CAF50);
  static const Color therapyColor = Color(0xFF9C27B0);
  static const Color surgeryColor = Color(0xFFEF5350);

  // Health Metrics
  static const Color excellentHealth = Color(0xFF4CAF50);
  static const Color goodHealth = Color(0xFF8BC34A);
  static const Color fairHealth = Color(0xFFFFC107);
  static const Color poorHealth = Color(0xFFFF9800);
  static const Color criticalHealth = Color(0xFFF44336);

  // ==================== Light Theme ColorScheme ====================

  static final ColorScheme lightColorScheme = ColorScheme.light(
    // Primary - Medical Blue (Trust and professionalism)
    primary: medicalBlue,
    onPrimary: Colors.white,
    primaryContainer: skyBlue,
    onPrimaryContainer: darkBlue,

    // Secondary - Healing Green (Health and wellness)
    secondary: healingGreen,
    onSecondary: Colors.white,
    secondaryContainer: mintGreen,
    onSecondaryContainer: forestGreen,

    // Tertiary - Medical Teal (Calm and balance)
    tertiary: medicalTeal,
    onTertiary: Colors.white,
    tertiaryContainer: lightTeal,
    onTertiaryContainer: deepTeal,

    // Error states
    error: error,
    onError: Colors.white,
    errorContainer: errorLight,
    onErrorContainer: errorDark,

    // Surfaces
    surface: surfaceLight,
    onSurface: textPrimaryLight,
    surfaceContainerHighest: cardLight,

    // Outlines
    outline: gray300,
    outlineVariant: gray200,

    // Overlays
    shadow: Colors.black.withValues(alpha: 0.08),
    scrim: Colors.black.withValues(alpha: 0.5),

    // Inverse
    inverseSurface: gray800,
    onInverseSurface: gray50,
    inversePrimary: lightBlue,
  );

  // ==================== Dark Theme ColorScheme ====================

  static final ColorScheme darkColorScheme = ColorScheme.dark(
    // Primary - Softer blue for dark mode
    primary: lightBlue,
    onPrimary: darkBlue,
    primaryContainer: deepBlue,
    onPrimaryContainer: skyBlue,

    // Secondary - Softer green for dark mode
    secondary: lightGreen,
    onSecondary: forestGreen,
    secondaryContainer: medicalGreen,
    onSecondaryContainer: mintGreen,

    // Tertiary - Softer teal for dark mode
    tertiary: lightTeal,
    onTertiary: deepTeal,
    tertiaryContainer: medicalTeal,
    onTertiaryContainer: lightTeal,

    // Error states
    error: errorLight,
    onError: errorDark,
    errorContainer: errorDark,
    onErrorContainer: errorLight,

    // Surfaces
    surface: surfaceDark,
    onSurface: textPrimaryDark,
    surfaceContainerHighest: cardDark,

    // Outlines
    outline: gray600,
    outlineVariant: gray700,

    // Overlays
    shadow: Colors.black.withValues(alpha: 0.6),
    scrim: Colors.black.withValues(alpha: 0.7),

    // Inverse
    inverseSurface: gray100,
    onInverseSurface: gray900,
    inversePrimary: medicalBlue,
  );

  // ==================== Gradient Collections ====================

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2196F3), Color(0xFF1565C0)],
  );

  static const LinearGradient healthGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
  );

  static const LinearGradient calmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF26A69A), Color(0xFF00796B)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2196F3), Color(0xFF1976D2), Color(0xFF1565C0)],
  );

  // Health Status Gradient (Good to Critical)
  static const LinearGradient healthStatusGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF4CAF50), // Excellent
      Color(0xFF8BC34A), // Good
      Color(0xFFFFC107), // Fair
      Color(0xFFFF9800), // Poor
      Color(0xFFF44336), // Critical
    ],
  );

  // ==================== Helper Methods ====================

  /// Returns color with specified opacity (0.0 - 1.0)
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Returns appropriate text color for given background
  static Color getTextColorForBackground(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? textPrimaryLight : textPrimaryDark;
  }

  /// Returns specialty color by specialty name
  static Color getSpecialtyColor(String specialty) {
    switch (specialty.toLowerCase()) {
      case 'cardiology':
      case 'cardiac':
      case 'heart':
        return cardiology;
      case 'neurology':
      case 'neuro':
      case 'brain':
        return neurology;
      case 'orthopedics':
      case 'ortho':
      case 'bones':
        return orthopedics;
      case 'pediatrics':
      case 'pediatric':
      case 'children':
        return pediatrics;
      case 'gynecology':
      case 'obstetrics':
      case 'women':
        return gynecology;
      case 'dentistry':
      case 'dental':
      case 'teeth':
        return dentistry;
      case 'dermatology':
      case 'skin':
        return dermatology;
      case 'general':
      case 'family':
        return generalMedicine;
      default:
        return medicalBlue;
    }
  }

  /// Returns health status color based on value (0-100)
  static Color getHealthStatusColor(double value) {
    if (value >= 80) return excellentHealth;
    if (value >= 60) return goodHealth;
    if (value >= 40) return fairHealth;
    if (value >= 20) return poorHealth;
    return criticalHealth;
  }

  /// Returns appointment status color
  static Color getAppointmentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return scheduled;
      case 'confirmed':
        return confirmed;
      case 'completed':
        return completed;
      case 'cancelled':
        return cancelled;
      case 'pending':
        return pending;
      default:
        return gray500;
    }
  }

  /// Returns vital sign specific color
  static Color getVitalSignColor(String vitalSign) {
    switch (vitalSign.toLowerCase()) {
      case 'heart rate':
      case 'pulse':
        return heartRate;
      case 'blood pressure':
      case 'bp':
        return bloodPressure;
      case 'temperature':
      case 'temp':
        return temperature;
      case 'oxygen':
      case 'spo2':
        return oxygen;
      case 'glucose':
      case 'sugar':
        return glucose;
      default:
        return medicalBlue;
    }
  }

  /// Check if color meets WCAG AA accessibility standards
  static bool meetsAccessibilityStandard(Color foreground, Color background) {
    final fgLuminance = foreground.computeLuminance();
    final bgLuminance = background.computeLuminance();
    final contrast = (fgLuminance > bgLuminance)
        ? ((fgLuminance + 0.05) / (bgLuminance + 0.05))
        : ((bgLuminance + 0.05) / (fgLuminance + 0.05));
    return contrast >= 4.5; // WCAG AA standard
  }
}
