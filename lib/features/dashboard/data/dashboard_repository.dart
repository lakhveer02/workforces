import 'dart:math';
import '../../../shared/models/user.dart';
import '../../../shared/models/user_role.dart';
import '../domain/dashboard_models.dart';

abstract class DashboardRepository {
  Future<EmployeeDashboardData> getEmployeeDashboard(String userId);
  Future<ManagerDashboardData> getManagerDashboard(String userId);
  Future<AdminDashboardData> getAdminDashboard(String userId);
  Future<List<Activity>> getRecentActivities(String userId, {int limit = 10});
  Future<List<Announcement>> getAnnouncements({int limit = 5});
}

class MockDashboardRepository implements DashboardRepository {
  static const Duration _networkDelay = Duration(milliseconds: 800);
  final Random _random = Random();

  @override
  Future<EmployeeDashboardData> getEmployeeDashboard(String userId) async {
    await Future.delayed(_networkDelay);
    
    return EmployeeDashboardData(
      attendanceStatus: _generateAttendanceStatus(),
      leaveBalance: _generateLeaveBalance(),
      upcomingHolidays: _generateUpcomingHolidays(),
      todaySchedule: _generateTodaySchedule(),
      personalStats: _generatePersonalStats(),
      recentActivities: await getRecentActivities(userId, limit: 8),
      quickActions: _generateEmployeeQuickActions(),
    );
  }

  @override
  Future<ManagerDashboardData> getManagerDashboard(String userId) async {
    await Future.delayed(_networkDelay);
    
    return ManagerDashboardData(
      teamStats: _generateTeamStats(),
      pendingApprovals: _generatePendingApprovals(),
      teamAttendance: _generateTeamAttendance(),
      departmentMetrics: _generateDepartmentMetrics(),
      recentActivities: await getRecentActivities(userId, limit: 10),
      quickActions: _generateManagerQuickActions(),
    );
  }

  @override
  Future<AdminDashboardData> getAdminDashboard(String userId) async {
    await Future.delayed(_networkDelay);
    
    return AdminDashboardData(
      companyStats: _generateCompanyStats(),
      departmentOverview: _generateDepartmentOverview(),
      systemAlerts: _generateSystemAlerts(),
      hrMetrics: _generateHrMetrics(),
      recentActivities: await getRecentActivities(userId, limit: 12),
      quickActions: _generateAdminQuickActions(),
    );
  }

  @override
  Future<List<Activity>> getRecentActivities(String userId, {int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final activities = [
      Activity(
        id: '1',
        type: ActivityType.attendance,
        title: 'Punched In',
        description: 'Started work day',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        icon: 'login',
      ),
      Activity(
        id: '2',
        type: ActivityType.leave,
        title: 'Leave Request Submitted',
        description: 'Annual leave for Dec 25-26',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        icon: 'calendar',
      ),
      Activity(
        id: '3',
        type: ActivityType.task,
        title: 'Task Completed',
        description: 'Employee onboarding documentation',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        icon: 'check',
      ),
      Activity(
        id: '4',
        type: ActivityType.announcement,
        title: 'New Company Policy',
        description: 'Updated remote work guidelines',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        icon: 'info',
      ),
      Activity(
        id: '5',
        type: ActivityType.payroll,
        title: 'Payslip Generated',
        description: 'November salary processed',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        icon: 'payment',
      ),
    ];
    
    return activities.take(limit).toList();
  }

  @override
  Future<List<Announcement>> getAnnouncements({int limit = 5}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final announcements = [
      Announcement(
        id: '1',
        title: 'Holiday Schedule Update',
        content: 'Please note the updated holiday schedule for December.',
        priority: AnnouncementPriority.high,
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        author: 'HR Team',
      ),
      Announcement(
        id: '2',
        title: 'Team Building Event',
        content: 'Join us for the annual team building event on Friday.',
        priority: AnnouncementPriority.medium,
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
        author: 'Management',
      ),
      Announcement(
        id: '3',
        title: 'New Employee Handbook',
        content: 'The updated employee handbook is now available.',
        priority: AnnouncementPriority.low,
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        author: 'HR Team',
      ),
    ];
    
    return announcements.take(limit).toList();
  }

  // Private helper methods for generating mock data
  AttendanceStatus _generateAttendanceStatus() {
    final now = DateTime.now();
    final punchInTime = DateTime(now.year, now.month, now.day, 9, 15);
    
    return AttendanceStatus(
      isPunchedIn: true,
      punchInTime: punchInTime,
      punchOutTime: null,
      workingHours: now.difference(punchInTime),
      expectedHours: const Duration(hours: 8),
      status: AttendanceStatusType.present,
    );
  }

  LeaveBalance _generateLeaveBalance() {
    return LeaveBalance(
      annual: LeaveInfo(
        allocated: 20,
        used: 8,
        pending: 2,
      ),
      sick: LeaveInfo(
        allocated: 10,
        used: 3,
        pending: 0,
      ),
      casual: LeaveInfo(
        allocated: 5,
        used: 2,
        pending: 1,
      ),
    );
  }

  List<Holiday> _generateUpcomingHolidays() {
    final now = DateTime.now();
    return [
      Holiday(
        name: 'Christmas Day',
        date: DateTime(now.year, 12, 25),
        type: HolidayType.national,
      ),
      Holiday(
        name: 'New Year\'s Day',
        date: DateTime(now.year + 1, 1, 1),
        type: HolidayType.national,
      ),
      Holiday(
        name: 'Company Anniversary',
        date: DateTime(now.year + 1, 3, 15),
        type: HolidayType.company,
      ),
    ];
  }

  List<ScheduleItem> _generateTodaySchedule() {
    final now = DateTime.now();
    return [
      ScheduleItem(
        title: 'Team Standup',
        time: DateTime(now.year, now.month, now.day, 10, 0),
        type: ScheduleItemType.meeting,
      ),
      ScheduleItem(
        title: 'Project Review',
        time: DateTime(now.year, now.month, now.day, 14, 30),
        type: ScheduleItemType.meeting,
      ),
      ScheduleItem(
        title: 'Client Call',
        time: DateTime(now.year, now.month, now.day, 16, 0),
        type: ScheduleItemType.call,
      ),
    ];
  }

  List<StatCard> _generatePersonalStats() {
    return [
      StatCard(
        title: 'Hours This Week',
        value: '38.5',
        change: '+2.5',
        changeType: ChangeType.positive,
        icon: 'time',
      ),
      StatCard(
        title: 'Tasks Completed',
        value: '12',
        change: '+3',
        changeType: ChangeType.positive,
        icon: 'task',
      ),
      StatCard(
        title: 'Leave Balance',
        value: '12',
        change: '-2',
        changeType: ChangeType.negative,
        icon: 'calendar',
      ),
    ];
  }

  List<QuickAction> _generateEmployeeQuickActions() {
    return [
      QuickAction(
        title: 'Punch In/Out',
        icon: 'login',
        route: '/attendance',
        isPrimary: true,
      ),
      QuickAction(
        title: 'Apply Leave',
        icon: 'calendar',
        route: '/leaves/apply',
      ),
      QuickAction(
        title: 'View Payslip',
        icon: 'payment',
        route: '/payroll',
      ),
      QuickAction(
        title: 'Submit Expense',
        icon: 'receipt',
        route: '/expenses/add',
      ),
    ];
  }

  TeamStats _generateTeamStats() {
    return TeamStats(
      totalMembers: 15,
      present: 12,
      absent: 2,
      onLeave: 1,
      pendingRequests: 3,
    );
  }

  List<PendingApproval> _generatePendingApprovals() {
    return [
      PendingApproval(
        id: '1',
        type: ApprovalType.leave,
        employeeName: 'John Smith',
        description: 'Annual leave request for Dec 20-22',
        submittedAt: DateTime.now().subtract(const Duration(hours: 2)),
        priority: ApprovalPriority.medium,
      ),
      PendingApproval(
        id: '2',
        type: ApprovalType.expense,
        employeeName: 'Sarah Johnson',
        description: 'Travel expense for client meeting',
        submittedAt: DateTime.now().subtract(const Duration(hours: 5)),
        priority: ApprovalPriority.high,
      ),
    ];
  }

  List<TeamMemberAttendance> _generateTeamAttendance() {
    final members = ['Alice Chen', 'Bob Wilson', 'Carol Davis', 'David Kim', 'Eva Rodriguez'];
    return members.map((name) => TeamMemberAttendance(
      name: name,
      status: AttendanceStatusType.values[_random.nextInt(AttendanceStatusType.values.length)],
      punchInTime: DateTime.now().subtract(Duration(hours: _random.nextInt(3) + 1)),
    )).toList();
  }

  List<StatCard> _generateDepartmentMetrics() {
    return [
      StatCard(
        title: 'Team Productivity',
        value: '94%',
        change: '+5%',
        changeType: ChangeType.positive,
        icon: 'trending_up',
      ),
      StatCard(
        title: 'Average Hours',
        value: '42.3',
        change: '+1.2',
        changeType: ChangeType.positive,
        icon: 'time',
      ),
    ];
  }

  List<QuickAction> _generateManagerQuickActions() {
    return [
      QuickAction(
        title: 'Approve Requests',
        icon: 'approval',
        route: '/approvals',
        isPrimary: true,
      ),
      QuickAction(
        title: 'Team Reports',
        icon: 'chart',
        route: '/reports/team',
      ),
      QuickAction(
        title: 'Schedule Meeting',
        icon: 'calendar',
        route: '/meetings/new',
      ),
    ];
  }

  CompanyStats _generateCompanyStats() {
    return CompanyStats(
      totalEmployees: 247,
      activeEmployees: 235,
      newHires: 8,
      attritionRate: 2.3,
      averageTenure: 2.8,
    );
  }

  List<DepartmentSummary> _generateDepartmentOverview() {
    return [
      DepartmentSummary(
        name: 'Engineering',
        headcount: 45,
        present: 42,
        productivity: 0.96,
      ),
      DepartmentSummary(
        name: 'Sales',
        headcount: 32,
        present: 30,
        productivity: 0.89,
      ),
      DepartmentSummary(
        name: 'Marketing',
        headcount: 18,
        present: 16,
        productivity: 0.92,
      ),
    ];
  }

  List<SystemAlert> _generateSystemAlerts() {
    return [
      SystemAlert(
        title: 'Server Maintenance',
        message: 'Scheduled maintenance on Sunday 2 AM - 4 AM',
        severity: AlertSeverity.info,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      SystemAlert(
        title: 'Backup Completed',
        message: 'Daily backup completed successfully',
        severity: AlertSeverity.success,
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ];
  }

  List<StatCard> _generateHrMetrics() {
    return [
      StatCard(
        title: 'Employee Satisfaction',
        value: '4.2/5',
        change: '+0.3',
        changeType: ChangeType.positive,
        icon: 'sentiment',
      ),
      StatCard(
        title: 'Recruitment',
        value: '15',
        change: '+5',
        changeType: ChangeType.positive,
        icon: 'person_add',
      ),
    ];
  }

  List<QuickAction> _generateAdminQuickActions() {
    return [
      QuickAction(
        title: 'System Health',
        icon: 'monitor',
        route: '/admin/system',
        isPrimary: true,
      ),
      QuickAction(
        title: 'User Management',
        icon: 'people',
        route: '/admin/users',
      ),
      QuickAction(
        title: 'Reports',
        icon: 'chart',
        route: '/admin/reports',
      ),
      QuickAction(
        title: 'Settings',
        icon: 'settings',
        route: '/admin/settings',
      ),
    ];
  }
}

// Singleton instance
final DashboardRepository dashboardRepository = MockDashboardRepository();