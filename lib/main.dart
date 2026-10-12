import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_bloc.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'features/dashboard/data/dashboard_repository.dart';

/// WorkforceOS - Enterprise HRMS and Workforce Management System
/// 
/// A comprehensive Flutter application providing:
/// - Multi-platform support (Android, iOS, iPadOS, macOS, Windows, Web)
/// - Role-based access control
/// - Responsive design with enterprise-grade UI/UX
/// - Complete HRMS functionality
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  try {
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
  } catch (error, stackTrace) {
    debugPrint('Error during app initialization: $error');
    debugPrint('Stack trace: $stackTrace');
    
    // Run fallback app with error message
    runApp(MaterialApp(
      title: 'WorkforceOS - Error',
      home: Scaffold(
        appBar: AppBar(title: const Text('Initialization Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Failed to initialize app',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Error: $error'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Try to restart the app
                    main();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

/// Root application widget
class WorkforceOSApp extends StatelessWidget {
  const WorkforceOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc()..add(const ThemeInitialized()),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository),
        ),
      ],
      child: Builder(
        builder: (context) {
          return BlocProvider<DashboardBloc>(
            create: (context) => DashboardBloc(
              dashboardRepository: dashboardRepository,
              authBloc: context.read<AuthBloc>(),
            ),
            child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                return MaterialApp.router(
                  // App Configuration
                  title: 'WorkforceOS',
                  debugShowCheckedModeBanner: false,
                  
                  // Dynamic Theming with Swiggy/Zomato aesthetic
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeState.themeMode,
                  
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
                );
              },
            ),
          );
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