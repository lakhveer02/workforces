import 'package:equatable/equatable.dart';

// Base dashboard data structures
abstract class DashboardData extends Equatable {
  const DashboardData({
    required this.recentActivities,
    required this.quickActions,
  });

  final List<Activity> recentActivities;
  final List<QuickAction> quickActions;
}

// Employee Dashboard Data
class EmployeeDashboardData extends DashboardData {
  const EmployeeDashboardData({
    required this.attendanceStatus,
    required this.leaveBalance,
    required this.upcomingHolidays,
    required this.todaySchedule,
    required this.personalStats,
    required super.recentActivities,
    required super.quickActions,
  });

  final AttendanceStatus attendanceStatus;
  final LeaveBalance leaveBalance;
  final List<Holiday> upcomingHolidays;
  final List<ScheduleItem> todaySchedule;
  final List<StatCard> personalStats;

  @override
  List<Object?> get props => [
        attendanceStatus,
        leaveBalance,
        upcomingHolidays,
        todaySchedule,
        personalStats,
        recentActivities,
        quickActions,
      ];
}

// Manager Dashboard Data
class ManagerDashboardData extends DashboardData {
  const ManagerDashboardData({
    required this.teamStats,
    required this.pendingApprovals,
    required this.teamAttendance,
    required this.departmentMetrics,
    required super.recentActivities,
    required super.quickActions,
  });

  final TeamStats teamStats;
  final List<PendingApproval> pendingApprovals;
  final List<TeamMemberAttendance> teamAttendance;
  final List<StatCard> departmentMetrics;

  @override
  List<Object?> get props => [
        teamStats,
        pendingApprovals,
        teamAttendance,
        departmentMetrics,
        recentActivities,
        quickActions,
      ];
}

// Admin Dashboard Data
class AdminDashboardData extends DashboardData {
  const AdminDashboardData({
    required this.companyStats,
    required this.departmentOverview,
    required this.systemAlerts,
    required this.hrMetrics,
    required super.recentActivities,
    required super.quickActions,
  });

  final CompanyStats companyStats;
  final List<DepartmentSummary> departmentOverview;
  final List<SystemAlert> systemAlerts;
  final List<StatCard> hrMetrics;

  @override
  List<Object?> get props => [
        companyStats,
        departmentOverview,
        systemAlerts,
        hrMetrics,
        recentActivities,
        quickActions,
      ];
}

// Attendance Models
class AttendanceStatus extends Equatable {
  const AttendanceStatus({
    required this.isPunchedIn,
    required this.punchInTime,
    required this.punchOutTime,
    required this.workingHours,
    required this.expectedHours,
    required this.status,
  });

  final bool isPunchedIn;
  final DateTime? punchInTime;
  final DateTime? punchOutTime;
  final Duration workingHours;
  final Duration expectedHours;
  final AttendanceStatusType status;

  String get workingHoursFormatted {
    final hours = workingHours.inHours;
    final minutes = (workingHours.inMinutes % 60);
    return '${hours}h ${minutes}m';
  }

  @override
  List<Object?> get props => [
        isPunchedIn,
        punchInTime,
        punchOutTime,
        workingHours,
        expectedHours,
        status,
      ];
}

enum AttendanceStatusType {
  present,
  absent,
  late,
  halfDay,
  onLeave,
}

// Leave Models
class LeaveBalance extends Equatable {
  const LeaveBalance({
    required this.annual,
    required this.sick,
    required this.casual,
  });

  final LeaveInfo annual;
  final LeaveInfo sick;
  final LeaveInfo casual;

  @override
  List<Object?> get props => [annual, sick, casual];
}

class LeaveInfo extends Equatable {
  const LeaveInfo({
    required this.allocated,
    required this.used,
    required this.pending,
  });

  final int allocated;
  final int used;
  final int pending;

  int get remaining => allocated - used - pending;

  @override
  List<Object?> get props => [allocated, used, pending];
}

// Holiday Models
class Holiday extends Equatable {
  const Holiday({
    required this.name,
    required this.date,
    required this.type,
  });

  final String name;
  final DateTime date;
  final HolidayType type;

  @override
  List<Object?> get props => [name, date, type];
}

enum HolidayType {
  national,
  company,
  regional,
}

// Schedule Models
class ScheduleItem extends Equatable {
  const ScheduleItem({
    required this.title,
    required this.time,
    required this.type,
  });

  final String title;
  final DateTime time;
  final ScheduleItemType type;

  @override
  List<Object?> get props => [title, time, type];
}

enum ScheduleItemType {
  meeting,
  call,
  task,
  event,
}

// Activity Models
class Activity extends Equatable {
  const Activity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.icon,
  });

  final String id;
  final ActivityType type;
  final String title;
  final String description;
  final DateTime timestamp;
  final String icon;

  @override
  List<Object?> get props => [id, type, title, description, timestamp, icon];
}

enum ActivityType {
  attendance,
  leave,
  task,
  announcement,
  payroll,
  system,
}

// Stat Card Models
class StatCard extends Equatable {
  const StatCard({
    required this.title,
    required this.value,
    required this.change,
    required this.changeType,
    required this.icon,
  });

  final String title;
  final String value;
  final String change;
  final ChangeType changeType;
  final String icon;

  @override
  List<Object?> get props => [title, value, change, changeType, icon];
}

enum ChangeType {
  positive,
  negative,
  neutral,
}

// Quick Action Models
class QuickAction extends Equatable {
  const QuickAction({
    required this.title,
    required this.icon,
    required this.route,
    this.isPrimary = false,
  });

  final String title;
  final String icon;
  final String route;
  final bool isPrimary;

  @override
  List<Object?> get props => [title, icon, route, isPrimary];
}

// Team Models
class TeamStats extends Equatable {
  const TeamStats({
    required this.totalMembers,
    required this.present,
    required this.absent,
    required this.onLeave,
    required this.pendingRequests,
  });

  final int totalMembers;
  final int present;
  final int absent;
  final int onLeave;
  final int pendingRequests;

  double get attendanceRate => present / totalMembers;

  @override
  List<Object?> get props => [totalMembers, present, absent, onLeave, pendingRequests];
}

class TeamMemberAttendance extends Equatable {
  const TeamMemberAttendance({
    required this.name,
    required this.status,
    required this.punchInTime,
  });

  final String name;
  final AttendanceStatusType status;
  final DateTime? punchInTime;

  @override
  List<Object?> get props => [name, status, punchInTime];
}

// Approval Models
class PendingApproval extends Equatable {
  const PendingApproval({
    required this.id,
    required this.type,
    required this.employeeName,
    required this.description,
    required this.submittedAt,
    required this.priority,
  });

  final String id;
  final ApprovalType type;
  final String employeeName;
  final String description;
  final DateTime submittedAt;
  final ApprovalPriority priority;

  @override
  List<Object?> get props => [id, type, employeeName, description, submittedAt, priority];
}

enum ApprovalType {
  leave,
  expense,
  timesheet,
  document,
}

enum ApprovalPriority {
  low,
  medium,
  high,
  urgent,
}

// Company Models
class CompanyStats extends Equatable {
  const CompanyStats({
    required this.totalEmployees,
    required this.activeEmployees,
    required this.newHires,
    required this.attritionRate,
    required this.averageTenure,
  });

  final int totalEmployees;
  final int activeEmployees;
  final int newHires;
  final double attritionRate;
  final double averageTenure;

  @override
  List<Object?> get props => [
        totalEmployees,
        activeEmployees,
        newHires,
        attritionRate,
        averageTenure,
      ];
}

class DepartmentSummary extends Equatable {
  const DepartmentSummary({
    required this.name,
    required this.headcount,
    required this.present,
    required this.productivity,
  });

  final String name;
  final int headcount;
  final int present;
  final double productivity;

  double get attendanceRate => present / headcount;

  @override
  List<Object?> get props => [name, headcount, present, productivity];
}

// System Models
class SystemAlert extends Equatable {
  const SystemAlert({
    required this.title,
    required this.message,
    required this.severity,
    required this.timestamp,
  });

  final String title;
  final String message;
  final AlertSeverity severity;
  final DateTime timestamp;

  @override
  List<Object?> get props => [title, message, severity, timestamp];
}

enum AlertSeverity {
  info,
  warning,
  error,
  success,
}

// Announcement Models
class Announcement extends Equatable {
  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.priority,
    required this.publishedAt,
    required this.author,
  });

  final String id;
  final String title;
  final String content;
  final AnnouncementPriority priority;
  final DateTime publishedAt;
  final String author;

  @override
  List<Object?> get props => [id, title, content, priority, publishedAt, author];
}

enum AnnouncementPriority {
  low,
  medium,
  high,
}