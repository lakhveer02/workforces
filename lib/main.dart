import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'features/auth/data/auth_repository.dart';

/// WorkforceOS - Enterprise HRMS and Workforce Management System
/// 
/// A comprehensive Flutter application providing:
/// - Multi-platform support (Android, iOS, iPadOS, macOS, Windows, Web)
/// - Role-based access control
/// - Responsive design with enterprise-grade UI/UX
/// - Complete HRMS functionality
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure system UI overlay style
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Set system UI overlay style for Android/iOS
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const WorkforceOSApp());
}

/// Root application widget
class WorkforceOSApp extends StatelessWidget {
  const WorkforceOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository),
        ),
      ],
      child: MaterialApp.router(
        // App Configuration
        title: 'WorkforceOS',
        debugShowCheckedModeBanner: false,
        
        // Theming
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // Will be managed by ThemeBloc later
        
        // Routing
        routerConfig: AppRouter.router,
        
        // Localization (will be expanded in later phases)
        locale: const Locale('en', 'US'),
        supportedLocales: const [
          Locale('en', 'US'), // English
          // Additional locales can be added here
        ],
        
        // Builder for responsive design utilities
        builder: (context, child) {
          return ResponsiveBuilder(child: child);
        },
      ),
    );
  }
}

/// Responsive builder widget to handle different screen sizes
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    required this.child,
    super.key,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      // Ensure consistent text scaling across platforms
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(
          MediaQuery.textScalerOf(context).scale(1.0).clamp(0.8, 1.2),
        ),
      ),
      child: child ?? const SizedBox.shrink(),
    );
  }
}

/// Device type enumeration for responsive design
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// Responsive design utilities
class Responsive {
  Responsive._();

  /// Get current device type based on screen width
  static DeviceType getDeviceType(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 600) {
      return DeviceType.mobile;
    } else if (screenWidth < 1200) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Check if current device is mobile
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  /// Check if current device is tablet
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  /// Check if current device is desktop
  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }

  /// Get responsive value based on device type
  static T getValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  /// Get number of columns for grid layouts
  static int getGridColumns(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 600) {
      return 1; // Mobile: single column
    } else if (screenWidth < 900) {
      return 2; // Tablet: two columns
    } else if (screenWidth < 1200) {
      return 3; // Small desktop: three columns
    } else {
      return 4; // Large desktop: four columns
    }
  }

  /// Get sidebar width based on screen size
  static double getSidebarWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < 1200) {
      return 280.0; // Tablet and below
    } else {
      return 320.0; // Desktop
    }
  }

  /// Check if sidebar should be collapsed by default
  static bool shouldCollapseSidebar(BuildContext context) {
    return MediaQuery.of(context).size.width < 1200;
  }
}