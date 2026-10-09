import 'package:flutter/material.dart';
import '../../../shared/models/user_role.dart';

/// Navigation destination model
class NavDestination {
  const NavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
    this.requiredPermissions = const [],
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;
  final List<Permission> requiredPermissions;
}

/// Navigation menu configuration with role-based access control
class NavigationMenu {
  NavigationMenu._();

  /// All available navigation destinations
  static const List<NavDestination> _allDestinations = [
    // Dashboard - Available to all authenticated users
    NavDestination(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Dashboard',
      route: '/dashboard',
    ),

    // Employees - HR, Manager, Admin
    NavDestination(
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
      label: 'Employees',
      route: '/employees',
      requiredPermissions: [Permission.viewTeamProfiles],
    ),

    // Attendance - All users can view own, managers+ can view team
    NavDestination(
      icon: Icons.access_time_outlined,
      selectedIcon: Icons.access_time,
      label: 'Attendance',
      route: '/attendance',
      requiredPermissions: [Permission.viewAttendance],
    ),

    // Leave Management - All users
    NavDestination(
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today,
      label: 'Leave',
      route: '/leaves',
      requiredPermissions: [Permission.applyLeave],
    ),

    // Tasks & Projects - Employees, Managers, Admin
    NavDestination(
      icon: Icons.task_outlined,
      selectedIcon: Icons.task,
      label: 'Tasks',
      route: '/tasks',
      requiredPermissions: [Permission.viewTasks],
    ),

    // Payroll - HR, Admin (employees can see their own payslips)
    NavDestination(
      icon: Icons.account_balance_wallet_outlined,
      selectedIcon: Icons.account_balance_wallet,
      label: 'Payroll',
      route: '/payroll',
      requiredPermissions: [Permission.managePayroll],
    ),

    // Company Management - Admin only
    NavDestination(
      icon: Icons.business_outlined,
      selectedIcon: Icons.business,
      label: 'Company',
      route: '/company',
      requiredPermissions: [Permission.manageCompanySettings],
    ),

    // Analytics & Reports - Manager, HR, Admin
    NavDestination(
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics,
      label: 'Analytics',
      route: '/analytics',
      requiredPermissions: [Permission.viewAllReports],
    ),
  ];

  /// Get filtered destinations based on user role
  static List<NavDestination> _getDestinationsForRole(UserRole role) {
    return _allDestinations.where((destination) {
      // Dashboard is always available
      if (destination.requiredPermissions.isEmpty) {
        return true;
      }

      // Check if user has required permissions
      return destination.requiredPermissions.every(
        (permission) => role.permissions.contains(permission),
      );
    }).toList();
  }

  /// Get bottom navigation destinations for mobile
  static List<NavigationDestination> getBottomNavDestinations(UserRole role) {
    final destinations = _getDestinationsForRole(role);
    
    // Limit to 5 items for bottom navigation
    final limitedDestinations = destinations.take(5).toList();
    
    return limitedDestinations.map((dest) => NavigationDestination(
      icon: Icon(dest.icon),
      selectedIcon: Icon(dest.selectedIcon),
      label: dest.label,
    )).toList();
  }

  /// Get navigation rail destinations for tablet
  static List<NavigationRailDestination> getRailDestinations(UserRole role) {
    final destinations = _getDestinationsForRole(role);
    
    return destinations.map((dest) => NavigationRailDestination(
      icon: Icon(dest.icon),
      selectedIcon: Icon(dest.selectedIcon),
      label: Text(dest.label),
    )).toList();
  }

  /// Get drawer destinations for mobile drawer
  static List<NavDestination> getDrawerDestinations(UserRole role) {
    return _getDestinationsForRole(role);
  }

  /// Get sidebar destinations for desktop
  static List<NavDestination> getSidebarDestinations(UserRole role) {
    return _getDestinationsForRole(role);
  }

  /// Get route for navigation index
  static String getRouteForIndex(int index, UserRole role) {
    final destinations = _getDestinationsForRole(role);
    if (index >= 0 && index < destinations.length) {
      return destinations[index].route;
    }
    return '/dashboard';
  }

  /// Get index for current route
  static int getIndexForRoute(String route, UserRole role) {
    final destinations = _getDestinationsForRole(role);
    for (int i = 0; i < destinations.length; i++) {
      if (destinations[i].route == route) {
        return i;
      }
    }
    return 0; // Default to dashboard
  }

  /// Check if user can access a specific route
  static bool canAccessRoute(String route, UserRole role) {
    final destinations = _getDestinationsForRole(role);
    return destinations.any((dest) => dest.route == route);
  }

  /// Get navigation items for role-specific features
  static Map<String, List<NavDestination>> getRoleSpecificSections(UserRole role) {
    final sections = <String, List<NavDestination>>{};
    
    // Main sections available to all roles
    sections['Main'] = [
      _allDestinations[0], // Dashboard
    ];

    // HR Management section
    if (role.permissions.contains(Permission.viewTeamProfiles)) {
      sections['People'] = [
        _allDestinations[1], // Employees
        _allDestinations[2], // Attendance
        _allDestinations[3], // Leave
      ];
    }

    // Work Management section
    if (role.permissions.contains(Permission.viewTasks)) {
      sections['Work'] = [
        _allDestinations[4], // Tasks
      ];
    }

    // Finance section
    if (role.permissions.contains(Permission.managePayroll)) {
      sections['Finance'] = [
        _allDestinations[5], // Payroll
      ];
    }

    // Administration section
    if (role.permissions.contains(Permission.manageCompanySettings)) {
      sections['Administration'] = [
        _allDestinations[6], // Company
      ];
    }

    // Reports section
    if (role.permissions.contains(Permission.viewAllReports)) {
      sections['Insights'] = [
        _allDestinations[7], // Analytics
      ];
    }

    return sections;
  }
}