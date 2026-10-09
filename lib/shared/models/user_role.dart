enum UserRole {
  employee('Employee', 'employee'),
  manager('Manager', 'manager'),
  hr('HR', 'hr'),
  admin('Admin', 'admin');

  const UserRole(this.displayName, this.value);

  final String displayName;
  final String value;

  /// Get role from string value
  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value.toLowerCase(),
      orElse: () => UserRole.employee,
    );
  }

  /// Check if role has admin privileges
  bool get isAdmin => this == UserRole.admin;

  /// Check if role has HR privileges
  bool get isHR => this == UserRole.hr || isAdmin;

  /// Check if role has manager privileges
  bool get isManager => this == UserRole.manager || isHR || isAdmin;

  /// Get permissions for role
  List<Permission> get permissions {
    switch (this) {
      case UserRole.employee:
        return [
          Permission.viewOwnProfile,
          Permission.editOwnProfile,
          Permission.viewAttendance,
          Permission.applyLeave,
          Permission.viewTasks,
        ];
      case UserRole.manager:
        return [
          ...employee.permissions,
          Permission.viewTeamProfiles,
          Permission.approveLeaves,
          Permission.assignTasks,
          Permission.viewTeamReports,
        ];
      case UserRole.hr:
        return [
          ...manager.permissions,
          Permission.manageEmployees,
          Permission.viewAllReports,
          Permission.managePayroll,
          Permission.manageCompanySettings,
        ];
      case UserRole.admin:
        return Permission.values; // All permissions
    }
  }
}

enum Permission {
  // Profile permissions
  viewOwnProfile,
  editOwnProfile,
  viewTeamProfiles,
  manageEmployees,

  // Attendance permissions
  viewAttendance,
  manageAttendance,

  // Leave permissions
  applyLeave,
  approveLeaves,
  manageLeaves,

  // Task permissions
  viewTasks,
  assignTasks,
  manageTasks,

  // Report permissions
  viewTeamReports,
  viewAllReports,

  // Payroll permissions
  viewOwnPayroll,
  managePayroll,

  // Company permissions
  manageCompanySettings,
  manageRoles,
  managePermissions,
}