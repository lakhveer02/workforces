import 'package:flutter/material.dart';

/// WorkforceOS Color System
/// Enterprise-grade color palette designed for accessibility and professional appearance
class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFF2563EB); // Blue 600
  static const Color primaryLight = Color(0xFF3B82F6); // Blue 500
  static const Color primaryDark = Color(0xFF1D4ED8); // Blue 700
  
  static const Color secondary = Color(0xFF7C3AED); // Purple 600
  static const Color accent = Color(0xFF059669); // Emerald 600

  // Neutral Colors (Light Theme)
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkSurfaceVariant = Color(0xFF334155); // Slate 700

  // Semantic Colors
  static const Color success = Color(0xFF059669); // Emerald 600
  static const Color successLight = Color(0xFF10B981); // Emerald 500
  static const Color successSurface = Color(0xFFECFDF5); // Emerald 50

  static const Color warning = Color(0xFFD97706); // Amber 600
  static const Color warningLight = Color(0xFFF59E0B); // Amber 500
  static const Color warningSurface = Color(0xFFFEFBEB); // Amber 50

  static const Color error = Color(0xFFDC2626); // Red 600
  static const Color errorLight = Color(0xFFEF4444); // Red 500
  static const Color errorSurface = Color(0xFFFEF2F2); // Red 50

  static const Color info = Color(0xFF2563EB); // Blue 600
  static const Color infoLight = Color(0xFF3B82F6); // Blue 500
  static const Color infoSurface = Color(0xFFEFF6FF); // Blue 50

  // Role-based Colors
  static const Color employeeAccent = Color(0xFF059669); // Emerald 600
  static const Color managerAccent = Color(0xFF2563EB); // Blue 600
  static const Color hrAccent = Color(0xFF7C3AED); // Purple 600
  static const Color adminAccent = Color(0xFFDC2626); // Red 600

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF2563EB), // Blue
    Color(0xFF059669), // Emerald
    Color(0xFF7C3AED), // Purple
    Color(0xFFD97706), // Amber
    Color(0xFFDC2626), // Red
    Color(0xFF0891B2), // Cyan
    Color(0xFF9333EA), // Violet
    Color(0xFF0D9488), // Teal
  ];
}

/// Color scheme extensions for consistent theming
extension AppColorScheme on ColorScheme {
  Color get surfaceContainer => brightness == Brightness.light 
    ? AppColors.gray50 
    : AppColors.darkSurfaceVariant;
    
  Color get outline => brightness == Brightness.light 
    ? AppColors.gray300 
    : AppColors.gray600;
    
  Color get success => AppColors.success;
  Color get warning => AppColors.warning;
  Color get info => AppColors.info;
}