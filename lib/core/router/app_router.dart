import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_verification_screen.dart';
import '../../features/auth/presentation/blocs/auth_bloc.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/employees/presentation/screens/employees_list_screen.dart';
import '../../features/employees/presentation/blocs/employee_bloc.dart';
import '../../features/employees/data/employee_repository.dart';
import '../../shared/widgets/layout/app_shell.dart';

/// WorkforceOS Router Configuration
/// Declarative routing with deep linking support and role-based access control
class AppRouter {
  AppRouter._();

  // Route paths
  static const String splash = '/';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String otp = '/otp';
  
  // Main app routes
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  
  // Employee routes
  static const String employees = '/employees';
  static const String employeeDetail = '/employees/:id';
  static const String addEmployee = '/employees/add';
  
  // Attendance routes
  static const String attendance = '/attendance';
  static const String attendanceHistory = '/attendance/history';
  static const String attendanceReports = '/attendance/reports';
  
  // Leave routes
  static const String leaves = '/leaves';
  static const String leaveDetail = '/leaves/:id';
  static const String applyLeave = '/leaves/apply';
  static const String leaveApprovals = '/leaves/approvals';
  
  // Payroll routes
  static const String payroll = '/payroll';
  static const String payslip = '/payroll/payslip/:id';
  static const String salaryStructure = '/payroll/salary-structure';
  
  // Tasks & Projects routes
  static const String tasks = '/tasks';
  static const String taskDetail = '/tasks/:id';
  static const String projects = '/projects';
  static const String projectDetail = '/projects/:id';
  
  // Company admin routes
  static const String company = '/company';
  static const String departments = '/company/departments';
  static const String roles = '/company/roles';
  static const String permissions = '/company/permissions';
  
  // Communication routes
  static const String notifications = '/notifications';
  static const String announcements = '/announcements';
  static const String documents = '/documents';
  
  // Analytics routes
  static const String analytics = '/analytics';
  static const String reports = '/reports';
  
  // Settings routes
  static const String settings = '/settings';

  /// Router configuration with navigation observer and authentication guards
  static GoRouter router = GoRouter(
    initialLocation: splash,
    observers: [_NavigationObserver()],
    debugLogDiagnostics: true,
    routes: [
      // Splash and Authentication Routes (Unguarded)
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => BlocProvider(
          create: (context) => AuthBloc(authRepository: authRepository),
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => BlocProvider(
          create: (context) => AuthBloc(authRepository: authRepository),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: resetPassword,
        name: 'reset-password',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'];
          return ResetPasswordScreen(token: token);
        },
      ),
      GoRoute(
        path: otp,
        name: 'otp',
        builder: (context, state) {
          final email = state.extra as String?;
          return BlocProvider(
            create: (context) => AuthBloc(authRepository: authRepository),
            child: OtpVerificationScreen(email: email),
          );
        },
      ),

      // Main App Shell with Nested Routes (Authenticated)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          // Dashboard Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: dashboard,
                name: 'dashboard',
                builder: (context, state) => BlocProvider.value(
                  value: context.read<AuthBloc>(),
                  child: const DashboardScreen(),
                ),
              ),
            ],
          ),

          // Employees Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: employees,
                name: 'employees',
                builder: (context, state) => BlocProvider(
                  create: (context) => EmployeeBloc(
                    employeeRepository: MockEmployeeRepository(),
                  ),
                  child: const EmployeesListScreen(),
                ),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: 'employee-detail',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return EmployeeDetailScreen(employeeId: id);
                    },
                  ),
                  GoRoute(
                    path: 'add',
                    name: 'add-employee',
                    builder: (context, state) => const AddEmployeeScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Attendance Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: attendance,
                name: 'attendance',
                builder: (context, state) => const AttendanceScreen(),
              ),
            ],
          ),

          // Leaves Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: leaves,
                name: 'leaves',
                builder: (context, state) => const LeavesScreen(),
              ),
            ],
          ),

          // Tasks Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: tasks,
                name: 'tasks',
                builder: (context, state) => const TasksScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
    
    // Redirect logic for authentication and authorization
    redirect: (context, state) async {
      // Check authentication status
      final isAuthenticated = await _checkAuthentication();
      final isOnAuthScreen = _isAuthenticationScreen(state.matchedLocation);
      
      // Redirect unauthenticated users to login (except auth screens)
      if (!isAuthenticated && !isOnAuthScreen) {
        return login;
      }
      
      // Redirect authenticated users away from auth screens
      if (isAuthenticated && isOnAuthScreen) {
        return dashboard;
      }
      
      return null; // No redirect needed
    },
  );

  /// Check if current route is an authentication screen
  static bool _isAuthenticationScreen(String path) {
    return path == login || 
           path == forgotPassword || 
           path == resetPassword || 
           path == otp ||
           path == splash;
  }

  /// Check authentication status
  static Future<bool> _checkAuthentication() async {
    try {
      final user = await authRepository.getCurrentUser();
      return user != null;
    } catch (e) {
      return false;
    }
  }
}

/// Navigation observer for tracking navigation events
class _NavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    // TODO: Track navigation for analytics
  }
}

// Placeholder screen widgets
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Forgot Password')),
    body: const Center(child: Text('Forgot Password Screen - Coming Soon')),
  );
}

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({required this.token, super.key});
  final String? token;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Reset Password')),
    body: Center(child: Text('Reset Password Screen - Token: ${token ?? "None"}')),
  );
}

class EmployeeDetailScreen extends StatelessWidget {
  const EmployeeDetailScreen({required this.employeeId, super.key});
  final String employeeId;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Employee Details')),
    body: Center(child: Text('Employee Detail Screen - ID: $employeeId')),
  );
}

class AddEmployeeScreen extends StatelessWidget {
  const AddEmployeeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Add Employee')),
    body: const Center(child: Text('Add Employee Screen - Coming Soon')),
  );
}

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Attendance')),
    body: const Center(child: Text('Attendance Screen - Coming Soon')),
  );
}

class LeavesScreen extends StatelessWidget {
  const LeavesScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Leave Management')),
    body: const Center(child: Text('Leave Management Screen - Coming Soon')),
  );
}

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tasks')),
    body: const Center(child: Text('Tasks Screen - Coming Soon')),
  );
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({required this.error, super.key});
  final Exception? error;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Oops! Something went wrong'),
          const SizedBox(height: 8),
          Text('Error: ${error.toString()}'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(AppRouter.dashboard),
            child: const Text('Go to Dashboard'),
          ),
        ],
      ),
    ),
  );
}