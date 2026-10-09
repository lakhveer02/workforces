import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// WorkforceOS Theme Configuration
/// Comprehensive theme system supporting light, dark, and system themes
class AppTheme {
  AppTheme._();

  // Border radius values
  static const double radiusXSmall = 4.0;
  static const double radiusSmall = 6.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
  static const double radiusRounded = 24.0;

  // Spacing values
  static const double spaceXSmall = 4.0;
  static const double spaceSmall = 8.0;
  static const double spaceMedium = 16.0;
  static const double spaceLarge = 24.0;
  static const double spaceXLarge = 32.0;
  static const double spaceXXLarge = 48.0;

  // Elevation values
  static const double elevationNone = 0.0;
  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;
  static const double elevationXLarge = 16.0;

  /// Light theme configuration
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,
      tertiary: AppColors.accent,
      onTertiary: AppColors.white,
      error: AppColors.error,
      onError: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.gray900,
      outline: AppColors.gray300,
      surfaceContainerHighest: AppColors.gray100,
      onSurfaceVariant: AppColors.gray600,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: AppTypography.fontFamily,
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: elevationNone,
        scrolledUnderElevation: elevationSmall,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.gray900,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.gray900,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: elevationSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        color: AppColors.white,
        surfaceTintColor: AppColors.primary.withValues(alpha: 0.05),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.gray50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: AppColors.gray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: AppColors.gray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spaceMedium,
          vertical: spaceMedium,
        ),
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.gray600,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.gray400,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: elevationNone,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceLarge,
            vertical: spaceMedium,
          ),
          textStyle: AppTypography.buttonText,
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: elevationNone,
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceLarge,
            vertical: spaceMedium,
          ),
          textStyle: AppTypography.buttonText,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          elevation: elevationNone,
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceMedium,
            vertical: spaceSmall,
          ),
          textStyle: AppTypography.buttonText,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: elevationMedium,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),

      // Navigation Bar Theme
      navigationBarTheme: NavigationBarThemeData(
        elevation: elevationSmall,
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.primary.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelSmall.copyWith(color: AppColors.primary);
          }
          return AppTypography.labelSmall.copyWith(color: AppColors.gray500);
        }),
      ),

      // Navigation Rail Theme
      navigationRailTheme: NavigationRailThemeData(
        elevation: elevationSmall,
        backgroundColor: AppColors.white,
        selectedIconTheme: const IconThemeData(color: AppColors.primary),
        unselectedIconTheme: const IconThemeData(color: AppColors.gray500),
        selectedLabelTextStyle: AppTypography.labelSmall.copyWith(
          color: AppColors.primary,
        ),
        unselectedLabelTextStyle: AppTypography.labelSmall.copyWith(
          color: AppColors.gray500,
        ),
      ),

      // Data Table Theme
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(AppColors.gray50),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withValues(alpha: 0.08);
          }
          return null;
        }),
        headingTextStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.gray700,
          fontWeight: FontWeight.w600,
        ),
        dataTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.gray900,
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.gray200,
        thickness: 1.0,
        space: 1.0,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.gray100,
        selectedColor: AppColors.primary.withValues(alpha: 0.12),
        labelStyle: AppTypography.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: spaceSmall,
          vertical: spaceXSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusRounded),
        ),
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
      brightness: Brightness.dark,
      primary: AppColors.primaryLight,
      onPrimary: AppColors.gray900,
      secondary: AppColors.secondary,
      onSecondary: AppColors.gray900,
      tertiary: AppColors.accent,
      onTertiary: AppColors.gray900,
      error: AppColors.errorLight,
      onError: AppColors.gray900,
      surface: AppColors.darkSurface,
      onSurface: AppColors.gray100,
      outline: AppColors.gray600,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      onSurfaceVariant: AppColors.gray300,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: AppTypography.fontFamily,
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: elevationNone,
        scrolledUnderElevation: elevationSmall,
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.gray100,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.gray100,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: elevationSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        color: AppColors.darkSurface,
        surfaceTintColor: AppColors.primaryLight.withValues(alpha: 0.05),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: AppColors.gray600),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: AppColors.gray600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: AppColors.errorLight),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spaceMedium,
          vertical: spaceMedium,
        ),
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.gray400,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.gray500,
        ),
      ),

      // Continue with other component themes for dark mode...
      // (Similar structure but with dark color variants)
    );
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 600) {
      // Mobile
      return const EdgeInsets.all(spaceMedium);
    } else if (screenWidth < 1200) {
      // Tablet
      return const EdgeInsets.all(spaceLarge);
    } else {
      // Desktop
      return const EdgeInsets.all(spaceXLarge);
    }
  }

  /// Get responsive card margin based on screen size
  static EdgeInsets getResponsiveCardMargin(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 600) {
      // Mobile
      return const EdgeInsets.symmetric(
        horizontal: spaceMedium,
        vertical: spaceSmall,
      );
    } else {
      // Tablet and Desktop
      return const EdgeInsets.symmetric(
        horizontal: spaceLarge,
        vertical: spaceMedium,
      );
    }
  }
}