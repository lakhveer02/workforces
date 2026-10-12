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
import '../../features/attendance/presentation/screens/attendance_screen.dart';
import '../../features/leaves/presentation/screens/leave_overview_screen.dart';
import '../../features/leaves/presentation/screens/leave_approvals_screen.dart';
import '../../features/payroll/presentation/screens/salary_overview_screen.dart';
import '../../features/payroll/presentation/screens/payslip_history_screen.dart';
import '../../features/tasks/presentation/screens/task_board_screen.dart';
import '../../features/reports/presentation/screens/analytics_dashboard_screen.dart';
import '../../features/settings/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../shared/widgets/layout/app_shell.dart';
import '../../shared/screens/unauthorized_screen.dart';
import '../../shared/screens/not_found_screen.dart';
import '../../shared/models/user_role.dart';

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
    
    // Enhanced error handling
    errorBuilder: (context, state) {
      // Check if it's a 404 error
      if (state.error is GoException) {
        return const NotFoundScreen();
      }
      
      // For other errors, show generic error screen
      return ErrorScreen(error: state.error);
    },
    
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

      // Unauthorized access route
      GoRoute(
        path: '/unauthorized',
        name: 'unauthorized',
        builder: (context, state) => const UnauthorizedScreen(),
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

          // Employees Branch (HR/Manager only)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: employees,
                name: 'employees',
                builder: (context, state) => const EmployeesListScreen(),
                redirect: (context, state) => _checkRoleAccess([UserRole.hr, UserRole.manager]),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: 'employee-detail',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return EmployeeDetailScreen(employeeId: id);
                    },
                    redirect: (context, state) => _checkRoleAccess([UserRole.hr, UserRole.manager]),
                  ),
                  GoRoute(
                    path: 'add',
                    name: 'add-employee',
                    builder: (context, state) => const AddEmployeeScreen(),
                    redirect: (context, state) => _checkRoleAccess([UserRole.hr]),
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
                builder: (context, state) => const LeaveOverviewScreen(),
                routes: [
                  GoRoute(
                    path: 'approvals',
                    name: 'leave-approvals',
                    builder: (context, state) => const LeaveApprovalsScreen(),
                    redirect: (context, state) => _checkRoleAccess([UserRole.hr, UserRole.manager]),
                  ),
                ],
              ),
            ],
          ),

          // Tasks Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: tasks,
                name: 'tasks',
                builder: (context, state) => const TaskBoardScreen(),
              ),
            ],
          ),

          // Payroll Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: payroll,
                name: 'payroll',
                builder: (context, state) => const SalaryOverviewScreen(),
                routes: [
                  GoRoute(
                    path: 'history',
                    name: 'payslip-history',
                    builder: (context, state) => const PayslipHistoryScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Analytics Branch (HR/Manager only)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: analytics,
                name: 'analytics',
                builder: (context, state) => const AnalyticsDashboardScreen(),
                redirect: (context, state) => _checkRoleAccess([UserRole.hr, UserRole.manager]),
              ),
            ],
          ),

          // Settings Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: settings,
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'profile',
                    name: 'profile',
                    builder: (context, state) => const ProfileScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    
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

  /// Check role-based access control
  static String? _checkRoleAccess(List<UserRole> allowedRoles) {
    try {
      // In a real app, get this from AuthBloc or UserRepository
      // For now, we'll use a mock implementation
      final currentUserRole = _getCurrentUserRole();
      
      if (currentUserRole == null || !allowedRoles.contains(currentUserRole)) {
        return '/unauthorized';
      }
      
      return null; // Access granted
    } catch (e) {
      return '/unauthorized';
    }
  }

  /// Get current user role (mock implementation)
  static UserRole? _getCurrentUserRole() {
    // TODO: Replace with actual user role from AuthBloc/UserRepository
    // For demo purposes, return HR role
    return UserRole.hr;
  }

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
  // TODO: Track navigation for analytics
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



class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});
  @override
  Widget build(BuildContext context) => const TaskBoardScreen();
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