import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Modern Design System for WorkforceOS
/// Inspired by Swiggy/Zomato/Zepto aesthetic with dynamic Light & Dark themes
class AppTheme {
  AppTheme._();

  // ═══════════════════════════════════════════════════════════════════════════════════
  // LIGHT THEME COLORS
  // ═══════════════════════════════════════════════════════════════════════════════════
  
  // Brand Colors (Light)
  static const Color _lightPrimary = Color(0xFFFC8019); // Swiggy orange
  static const Color _lightPrimaryLight = Color(0xFFFFF3E8); // Very pale orange tint
  static const Color _lightPrimaryDark = Color(0xFFE06812); // Darker press state
  
  // Surface Colors (Light)
  static const Color _lightBackground = Color(0xFFF6F7FB);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightSurfaceElevated = Color(0xFFFFFFFF);
  static const Color _lightCard = Color(0xFFFFFFFF);
  static const Color _lightCardBorder = Color(0xFFF1F5F9);
  static const Color _lightCardSubtle = Color(0xFFF9FAFB);
  
  // Text Colors (Light)
  static const Color _lightTextPrimary = Color(0xFF1C1C1E);
  static const Color _lightTextSecondary = Color(0xFF6B7280);
  static const Color _lightTextTertiary = Color(0xFF9CA3AF);
  static const Color _lightTextOnPrimary = Color(0xFFFFFFFF);
  
  // Semantic Colors (Light)
  static const Color _lightSuccess = Color(0xFF12B76A);
  static const Color _lightSuccessLight = Color(0xFFD1FAE5);
  static const Color _lightWarning = Color(0xFFF59E0B);
  static const Color _lightWarningLight = Color(0xFFFEF3C7);
  static const Color _lightDanger = Color(0xFFEF4444);
  static const Color _lightDangerLight = Color(0xFFFEE2E2);
  static const Color _lightInfo = Color(0xFF3B82F6);
  static const Color _lightInfoLight = Color(0xFFEFF6FF);
  static const Color _lightPurple = Color(0xFF8B5CF6);
  static const Color _lightPurpleLight = Color(0xFFEDE9FE);
  
  // Borders & Dividers (Light)
  static const Color _lightBorder = Color(0xFFE5E7EB);
  static const Color _lightDivider = Color(0xFFF3F4F6);
  
  // Form & UI (Light)
  static const Color _lightInputBg = Color(0xFFFFFFFF);
  static const Color _lightInputBorder = Color(0xFFE5E7EB);
  static const Color _lightHeaderBg = Color(0xFFF6F7FB);
  static const Color _lightModalBg = Color(0xFFFFFFFF);
  static const Color _lightTabBarBg = Color(0xFFFFFFFF);
  static const Color _lightTabBarBorder = Color(0xFFE5E7EB);

  // ═══════════════════════════════════════════════════════════════════════════════════
  // DARK THEME COLORS
  // ═══════════════════════════════════════════════════════════════════════════════════
  
  // Brand Colors (Dark)
  static const Color _darkPrimary = Color(0xFFFF7722); // Vibrant orange for dark
  static const Color _darkPrimaryLight = Color(0xFF2D1B11); // Dark orange tint
  static const Color _darkPrimaryDark = Color(0xFFE06812); // Darker press state
  
  // Surface Colors (Dark)
  static const Color _darkBackground = Color(0xFF121214); // Deep dark background
  static const Color _darkSurface = Color(0xFF1E1E22); // Elevated surface/cards
  static const Color _darkSurfaceElevated = Color(0xFF28282E); // More elevated modals
  static const Color _darkCard = Color(0xFF1E1E22);
  static const Color _darkCardBorder = Color(0xFF2E2E34);
  static const Color _darkCardSubtle = Color(0xFF26262B);
  
  // Text Colors (Dark)
  static const Color _darkTextPrimary = Color(0xFFF3F4F6); // High readability off-white
  static const Color _darkTextSecondary = Color(0xFF9CA3AF); // Muted grey
  static const Color _darkTextTertiary = Color(0xFF6B7280); // Darker hint/placeholder
  static const Color _darkTextOnPrimary = Color(0xFFFFFFFF);
  
  // Semantic Colors (Dark)
  static const Color _darkSuccess = Color(0xFF34D399);
  static const Color _darkSuccessLight = Color(0xFF064E3B);
  static const Color _darkWarning = Color(0xFFFBBF24);
  static const Color _darkWarningLight = Color(0xFF78350F);
  static const Color _darkDanger = Color(0xFFF87171);
  static const Color _darkDangerLight = Color(0xFF7F1D1D);
  static const Color _darkInfo = Color(0xFF60A5FA);
  static const Color _darkInfoLight = Color(0xFF1E3A8A);
  static const Color _darkPurple = Color(0xFFA78BFA);
  static const Color _darkPurpleLight = Color(0xFF3B0764);
  
  // Borders & Dividers (Dark)
  static const Color _darkBorder = Color(0xFF2E2E34);
  static const Color _darkDivider = Color(0xFF26262B);
  
  // Form & UI (Dark)
  static const Color _darkInputBg = Color(0xFF26262C);
  static const Color _darkInputBorder = Color(0xFF36363E);
  static const Color _darkHeaderBg = Color(0xFF18181C);
  static const Color _darkModalBg = Color(0xFF1E1E22);
  static const Color _darkTabBarBg = Color(0xFF18181B);
  static const Color _darkTabBarBorder = Color(0xFF27272A);

  // ═══════════════════════════════════════════════════════════════════════════════════
  // DESIGN TOKENS
  // ═══════════════════════════════════════════════════════════════════════════════════

  // Font Sizes
  static const double fontXS = 11.0;
  static const double fontSM = 13.0;
  static const double fontBase = 15.0;
  static const double fontMD = 16.0;
  static const double fontLG = 18.0;
  static const double fontXL = 20.0;
  static const double font2XL = 24.0;
  static const double font3XL = 28.0;
  static const double font4XL = 34.0;

  // Border Radius
  static const double radiusXS = 6.0;
  static const double radiusSM = 10.0;
  static const double radiusMD = 14.0;
  static const double radiusLG = 18.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 999.0;

  // Spacing
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 12.0;
  static const double spaceBase = 16.0;
  static const double spaceLG = 20.0;
  static const double spaceXL = 24.0;
  static const double space2XL = 32.0;
  static const double space3XL = 40.0;

  // Legacy spacing constants for backward compatibility

  // Elevation values
  static const double elevationNone = 0.0;
  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;

  // Aliases for easier migration and backward compatibility
  static const Color background = _lightBackground;
  static const Color surface = _lightSurface; 
  static const Color accent = _lightPrimary;
  static const Color warning = _lightWarning;
  static const Color success = _lightSuccess;
  static const Color buz = _lightTextPrimary;
  static const Color soluk = _lightTextSecondary;
  static const Color yuzey = _lightSurface;
  static const Color structuralLine = _lightBorder;
  static const Color altin = _lightWarning;
  static const Color basari = _lightSuccess;
  static const Color primaryStart = _lightPrimary;
  
  // Additional legacy color aliases needed by other files
  static const Color obsidyen = _lightSurface;  // Mapped to surface
  static const Color panel = _lightCard;        // Mapped to card
  static const Color primaryEnd = _lightPrimaryDark;
  
  // Legacy spacing constants for backward compatibility
  static const double spaceSmall = spaceSM;
  static const double spaceXSmall = spaceXS;
  static const double spaceMedium = spaceMD;
  static const double spaceLarge = spaceLG;
  static const double spaceXLarge = spaceXL;
  static const double spaceXXLarge = space2XL;
  
  // Legacy radius constants for backward compatibility
  static const double radius8 = 8.0;
  static const double radius12 = radiusSM;
  static const double radius16 = radiusMD;
  static const double radius24 = radiusXL;
  static const double radius32 = 32.0;
  static const double radiusXSmall = radiusXS;
  static const double radiusSmall = radiusXS;
  static const double radiusMedium = radiusSM;
  static const double radiusLarge = radiusMD;
  static const double radiusXLarge = radiusLG;
  static const double radiusRounded = radiusXL;

  /// Get colors based on theme mode
  static AppThemeColors getColors(bool isDark) => isDark ? darkColors : lightColors;

  /// Light theme colors
  static const AppThemeColors lightColors = AppThemeColors(
    // Brand
    primary: _lightPrimary,
    primaryLight: _lightPrimaryLight,
    primaryDark: _lightPrimaryDark,
    
    // Surface
    background: _lightBackground,
    surface: _lightSurface,
    surfaceElevated: _lightSurfaceElevated,
    card: _lightCard,
    cardBorder: _lightCardBorder,
    cardSubtle: _lightCardSubtle,
    
    // Text
    textPrimary: _lightTextPrimary,
    textSecondary: _lightTextSecondary,
    textTertiary: _lightTextTertiary,
    textOnPrimary: _lightTextOnPrimary,
    
    // Semantic
    success: _lightSuccess,
    successLight: _lightSuccessLight,
    warning: _lightWarning,
    warningLight: _lightWarningLight,
    danger: _lightDanger,
    dangerLight: _lightDangerLight,
    info: _lightInfo,
    infoLight: _lightInfoLight,
    purple: _lightPurple,
    purpleLight: _lightPurpleLight,
    
    // Borders & UI
    border: _lightBorder,
    divider: _lightDivider,
    inputBg: _lightInputBg,
    inputBorder: _lightInputBorder,
    headerBg: _lightHeaderBg,
    modalBg: _lightModalBg,
    tabBarBg: _lightTabBarBg,
    tabBarBorder: _lightTabBarBorder,
  );

  /// Dark theme colors
  static const AppThemeColors darkColors = AppThemeColors(
    // Brand
    primary: _darkPrimary,
    primaryLight: _darkPrimaryLight,
    primaryDark: _darkPrimaryDark,
    
    // Surface
    background: _darkBackground,
    surface: _darkSurface,
    surfaceElevated: _darkSurfaceElevated,
    card: _darkCard,
    cardBorder: _darkCardBorder,
    cardSubtle: _darkCardSubtle,
    
    // Text
    textPrimary: _darkTextPrimary,
    textSecondary: _darkTextSecondary,
    textTertiary: _darkTextTertiary,
    textOnPrimary: _darkTextOnPrimary,
    
    // Semantic
    success: _darkSuccess,
    successLight: _darkSuccessLight,
    warning: _darkWarning,
    warningLight: _darkWarningLight,
    danger: _darkDanger,
    dangerLight: _darkDangerLight,
    info: _darkInfo,
    infoLight: _darkInfoLight,
    purple: _darkPurple,
    purpleLight: _darkPurpleLight,
    
    // Borders & UI
    border: _darkBorder,
    divider: _darkDivider,
    inputBg: _darkInputBg,
    inputBorder: _darkInputBorder,
    headerBg: _darkHeaderBg,
    modalBg: _darkModalBg,
    tabBarBg: _darkTabBarBg,
    tabBarBorder: _darkTabBarBorder,
  );

  /// Light theme configuration
  static ThemeData get lightTheme {
    const colors = lightColors;
    
    final colorScheme = ColorScheme.light(
      brightness: Brightness.light,
      primary: colors.primary,
      onPrimary: colors.textOnPrimary,
      secondary: colors.warning,
      onSecondary: colors.textPrimary,
      tertiary: colors.success,
      onTertiary: colors.textPrimary,
      error: colors.danger,
      onError: colors.textOnPrimary,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      outline: colors.border,
      surfaceContainer: colors.cardSubtle,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      
      // Typography using Inter font with modern sizing
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: font4XL,
          fontWeight: FontWeight.w800,
          color: colors.textPrimary,
          height: 1.1,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: font3XL,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
          height: 1.2,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: font2XL,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
          height: 1.2,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: font2XL,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          height: 1.3,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: fontXL,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          height: 1.3,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: fontLG,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          height: 1.4,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: fontLG,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          height: 1.4,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: fontMD,
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
          height: 1.5,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: fontBase,
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
          height: 1.4,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: fontMD,
          fontWeight: FontWeight.w400,
          color: colors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: fontBase,
          fontWeight: FontWeight.w400,
          color: colors.textSecondary,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: fontSM,
          fontWeight: FontWeight.w400,
          color: colors.textTertiary,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: fontBase,
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
          height: 1.4,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: fontSM,
          fontWeight: FontWeight.w500,
          color: colors.textSecondary,
          height: 1.4,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: fontXS,
          fontWeight: FontWeight.w500,
          color: colors.textTertiary,
          height: 1.3,
        ),
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: elevationNone,
        scrolledUnderElevation: elevationSmall,
        backgroundColor: colors.headerBg,
        foregroundColor: colors.textPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: fontLG,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
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
          borderRadius: BorderRadius.circular(radiusMD),
          side: BorderSide(color: colors.cardBorder, width: 1),
        ),
        color: colors.card,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.04),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.inputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: colors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: colors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: colors.danger),
        ),
        labelStyle: GoogleFonts.inter(
          color: colors.textSecondary,
          fontSize: fontBase,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: GoogleFonts.inter(
          color: colors.textTertiary,
          fontSize: fontBase,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.textOnPrimary,
          elevation: elevationSmall,
          shadowColor: colors.primary.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(horizontal: spaceXL, vertical: spaceMD),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: fontBase,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.border),
          padding: const EdgeInsets.symmetric(horizontal: spaceXL, vertical: spaceMD),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: fontBase,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          padding: const EdgeInsets.symmetric(horizontal: spaceBase, vertical: spaceSM),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSM),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: fontBase,
          ),
        ),
      ),

      // Navigation
      navigationBarTheme: NavigationBarThemeData(
        elevation: elevationSmall,
        backgroundColor: colors.tabBarBg,
        surfaceTintColor: Colors.transparent,
        indicatorColor: colors.primary.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              color: colors.primary,
              fontSize: fontSM,
              fontWeight: FontWeight.w500,
            );
          }
          return GoogleFonts.inter(
            color: colors.textTertiary,
            fontSize: fontSM,
            fontWeight: FontWeight.w400,
          );
        }),
      ),

      // Other components
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1.0,
        space: 1.0,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: colors.cardSubtle,
        selectedColor: colors.primary.withValues(alpha: 0.12),
        labelStyle: GoogleFonts.inter(
          color: colors.textPrimary,
          fontSize: fontSM,
          fontWeight: FontWeight.w500,
        ),
        side: BorderSide(color: colors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
        ),
        padding: const EdgeInsets.symmetric(horizontal: spaceSM, vertical: spaceXS),
      ),
    );
  }


  /// Dark theme configuration
  static ThemeData get darkTheme {
    const colors = darkColors;
    
    final colorScheme = ColorScheme.dark(
      brightness: Brightness.dark,
      primary: colors.primary,
      onPrimary: colors.textOnPrimary,
      secondary: colors.warning,
      onSecondary: colors.textPrimary,
      tertiary: colors.success,
      onTertiary: colors.textPrimary,
      error: colors.danger,
      onError: colors.textOnPrimary,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      outline: colors.border,
      surfaceContainer: colors.cardSubtle,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      
      // Typography using Inter font with modern sizing
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: font4XL,
          fontWeight: FontWeight.w800,
          color: colors.textPrimary,
          height: 1.1,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: font3XL,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
          height: 1.2,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: font2XL,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
          height: 1.2,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: font2XL,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          height: 1.3,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: fontXL,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          height: 1.3,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: fontLG,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          height: 1.4,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: fontLG,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          height: 1.4,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: fontMD,
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
          height: 1.5,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: fontBase,
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
          height: 1.4,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: fontMD,
          fontWeight: FontWeight.w400,
          color: colors.textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: fontBase,
          fontWeight: FontWeight.w400,
          color: colors.textSecondary,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: fontSM,
          fontWeight: FontWeight.w400,
          color: colors.textTertiary,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: fontBase,
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
          height: 1.4,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: fontSM,
          fontWeight: FontWeight.w500,
          color: colors.textSecondary,
          height: 1.4,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: fontXS,
          fontWeight: FontWeight.w500,
          color: colors.textTertiary,
          height: 1.3,
        ),
      ),
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: elevationNone,
        scrolledUnderElevation: elevationNone,
        backgroundColor: colors.headerBg,
        foregroundColor: colors.textPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.inter(
          fontSize: fontLG,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),

      // Card Theme with enhanced dark styling
      cardTheme: CardThemeData(
        elevation: elevationNone,
        color: colors.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          side: BorderSide(color: colors.cardBorder, width: 1),
        ),
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.inputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: colors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: colors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: BorderSide(color: colors.danger),
        ),
        labelStyle: GoogleFonts.inter(
          color: colors.textSecondary,
          fontSize: fontBase,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: GoogleFonts.inter(
          color: colors.textTertiary,
          fontSize: fontBase,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.textOnPrimary,
          elevation: elevationSmall,
          shadowColor: colors.primary.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: spaceXL, vertical: spaceMD),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: fontBase,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          side: BorderSide(color: colors.border),
          padding: const EdgeInsets.symmetric(horizontal: spaceXL, vertical: spaceMD),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: fontBase,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          padding: const EdgeInsets.symmetric(horizontal: spaceBase, vertical: spaceSM),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSM),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: fontBase,
          ),
        ),
      ),

      // Navigation
      navigationBarTheme: NavigationBarThemeData(
        elevation: elevationNone,
        backgroundColor: colors.tabBarBg,
        surfaceTintColor: Colors.transparent,
        indicatorColor: colors.primary.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              color: colors.primary,
              fontSize: fontSM,
              fontWeight: FontWeight.w500,
            );
          }
          return GoogleFonts.inter(
            color: colors.textTertiary,
            fontSize: fontSM,
            fontWeight: FontWeight.w400,
          );
        }),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: elevationMedium,
        backgroundColor: colors.primary,
        foregroundColor: colors.textOnPrimary,
      ),

      // Other components
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1.0,
        space: 1.0,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: colors.cardSubtle,
        selectedColor: colors.primary.withValues(alpha: 0.12),
        labelStyle: GoogleFonts.inter(
          color: colors.textPrimary,
          fontSize: fontSM,
          fontWeight: FontWeight.w500,
        ),
        side: BorderSide(color: colors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
        ),
        padding: const EdgeInsets.symmetric(horizontal: spaceSM, vertical: spaceXS),
      ),

      // Data Table Theme
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(colors.cardSubtle),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary.withValues(alpha: 0.08);
          }
          return null;
        }),
        headingTextStyle: GoogleFonts.inter(
          color: colors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: fontSM,
        ),
        dataTextStyle: GoogleFonts.inter(
          color: colors.textPrimary,
          fontWeight: FontWeight.w400,
          fontSize: fontSM,
        ),
      ),
    );
  }

  // Custom gradient for primary actions
  static LinearGradient get primaryGradient {
    return const LinearGradient(
      colors: [_lightPrimary, Color(0xFFFF9500)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }

  // Status colors
  static Color getStatusColor(String status, {bool isDark = false}) {
    final colors = isDark ? darkColors : lightColors;
    
    switch (status.toLowerCase()) {
      case 'pending':
      case 'bekliyor':
        return colors.warning;
      case 'success':
      case 'paid':
      case 'ödendi':
      case 'approved':
        return colors.success;
      case 'error':
      case 'rejected':
        return colors.danger;
      default:
        return colors.textSecondary;
    }
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 600) {
      return const EdgeInsets.all(spaceBase);
    } else if (screenWidth < 1200) {
      return const EdgeInsets.all(spaceXL);
    } else {
      return const EdgeInsets.all(space2XL);
    }
  }

  /// Get responsive card margin based on screen size
  static EdgeInsets getResponsiveCardMargin(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 600) {
      return const EdgeInsets.symmetric(
        horizontal: spaceBase,
        vertical: spaceSM,
      );
    } else {
      return const EdgeInsets.symmetric(
        horizontal: spaceXL,
        vertical: spaceMD,
      );
    }
  }
}

/// Color palette class for structured access to theme colors
class AppThemeColors {
  const AppThemeColors({
    // Brand
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    
    // Surface
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.card,
    required this.cardBorder,
    required this.cardSubtle,
    
    // Text
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textOnPrimary,
    
    // Semantic
    required this.success,
    required this.successLight,
    required this.warning,
    required this.warningLight,
    required this.danger,
    required this.dangerLight,
    required this.info,
    required this.infoLight,
    required this.purple,
    required this.purpleLight,
    
    // Borders & UI
    required this.border,
    required this.divider,
    required this.inputBg,
    required this.inputBorder,
    required this.headerBg,
    required this.modalBg,
    required this.tabBarBg,
    required this.tabBarBorder,
  });

  // Brand colors
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  
  // Surface colors
  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color card;
  final Color cardBorder;
  final Color cardSubtle;
  
  // Text colors
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textOnPrimary;
  
  // Semantic colors
  final Color success;
  final Color successLight;
  final Color warning;
  final Color warningLight;
  final Color danger;
  final Color dangerLight;
  final Color info;
  final Color infoLight;
  final Color purple;
  final Color purpleLight;
  
  // UI colors
  final Color border;
  final Color divider;
  final Color inputBg;
  final Color inputBorder;
  final Color headerBg;
  final Color modalBg;
  final Color tabBarBg;
  final Color tabBarBorder;
  
}

/// Backward compatibility color constants
/// Used by legacy widgets that reference AppColors.primary statically
/// Legacy static color access for backward compatibility
class AppColors {
  static const Color primary = Color(0xFFFC8019);   
  static const Color secondary = Color(0xFFF59E0B); 
  static const Color error = Color(0xFFEF4444);     
  static const Color success = Color(0xFF12B76A);   
  static const Color warning = Color(0xFFF59E0B);   
  static const Color info = Color(0xFF3B82F6);      
  static const Color gray50 = Color(0xFFF9FAFB);    
  static const Color gray400 = Color(0xFF9CA3AF);   
  static const Color gray600 = Color(0xFF6B7280);   
  static const Color gray900 = Color(0xFF1C1C1E);   
}

/// Modern theme colors for context.colors access
class ThemeColors {
  const ThemeColors();
  
  // Instance getters for context.colors access matching the widget expectations
  Color get primary => AppColors.primary;
  Color get secondary => AppColors.secondary;
  Color get background => const Color(0xFFF6F7FB); 
  Color get warning => AppColors.warning;
  Color get success => AppColors.success;
  Color get error => AppColors.error;
  Color get info => AppColors.info;
  Color get card => const Color(0xFFFFFFFF); 
  Color get cardBorder => const Color(0xFFF1F5F9); 
  Color get surface => const Color(0xFFFFFFFF); 
  Color get danger => AppColors.error;
  Color get cardSubtle => AppColors.gray50;
  Color get textPrimary => AppColors.gray900;
  Color get textSecondary => AppColors.gray600;
  Color get textTertiary => AppColors.gray400;
  Color get textOnPrimary => const Color(0xFFFFFFFF);
  Color get border => const Color(0xFFE5E7EB);
}

/// Extension to easily access current theme colors from BuildContext
extension AppThemeExtension on BuildContext {
  ThemeColors get colors {
    // Return the ThemeColors instance for modern widget compatibility
    return const ThemeColors();
  }
  
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}