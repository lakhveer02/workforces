enum ChartType {
  line,
  bar,
  pie,
  area,
  donut,
}

enum DateRangeFilter {
  today,
  thisWeek,
  thisMonth,
  thisQuarter,
  thisYear,
  lastWeek,
  lastMonth,
  lastQuarter,
  lastYear,
  custom,
}

class ChartDataPoint {
  final String label;
  final double value;
  final String? color;
  final DateTime? date;

  const ChartDataPoint({
    required this.label,
    required this.value,
    this.color,
    this.date,
  });
}

class ChartData {
  final String title;
  final String subtitle;
  final ChartType type;
  final List<ChartDataPoint> dataPoints;
  final String? xAxisLabel;
  final String? yAxisLabel;
  final double? maxValue;
  final double? minValue;

  const ChartData({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.dataPoints,
    this.xAxisLabel,
    this.yAxisLabel,
    this.maxValue,
    this.minValue,
  });

  bool get isEmpty => dataPoints.isEmpty;
  double get totalValue => dataPoints.fold(0.0, (sum, point) => sum + point.value);
}

class AttendanceReport {
  final String period;
  final int totalWorkingDays;
  final int totalPresentDays;
  final int totalAbsentDays;
  final int totalLateDays;
  final double attendancePercentage;
  final Map<String, int> departmentAttendance;
  final List<ChartDataPoint> dailyAttendance;
  final List<ChartDataPoint> monthlyTrend;

  const AttendanceReport({
    required this.period,
    required this.totalWorkingDays,
    required this.totalPresentDays,
    required this.totalAbsentDays,
    required this.totalLateDays,
    required this.attendancePercentage,
    required this.departmentAttendance,
    required this.dailyAttendance,
    required this.monthlyTrend,
  });
}

class LeaveReport {
  final String period;
  final int totalLeaveRequests;
  final int approvedLeaves;
  final int pendingLeaves;
  final int rejectedLeaves;
  final Map<String, int> leaveTypeDistribution;
  final Map<String, int> departmentLeaves;
  final List<ChartDataPoint> monthlyLeaveRequests;
  final double averageLeavePerEmployee;

  const LeaveReport({
    required this.period,
    required this.totalLeaveRequests,
    required this.approvedLeaves,
    required this.pendingLeaves,
    required this.rejectedLeaves,
    required this.leaveTypeDistribution,
    required this.departmentLeaves,
    required this.monthlyLeaveRequests,
    required this.averageLeavePerEmployee,
  });
}

class HeadcountReport {
  final String period;
  final int totalEmployees;
  final int newHires;
  final int terminations;
  final int activeEmployees;
  final Map<String, int> departmentHeadcount;
  final Map<String, int> roleDistribution;
  final List<ChartDataPoint> headcountTrend;
  final double turnoverRate;

  const HeadcountReport({
    required this.period,
    required this.totalEmployees,
    required this.newHires,
    required this.terminations,
    required this.activeEmployees,
    required this.departmentHeadcount,
    required this.roleDistribution,
    required this.headcountTrend,
    required this.turnoverRate,
  });
}

class PayrollReport {
  final String period;
  final double totalGrossPay;
  final double totalNetPay;
  final double totalDeductions;
  final double averageSalary;
  final Map<String, double> departmentPayroll;
  final Map<String, double> salaryRanges;
  final List<ChartDataPoint> monthlyPayroll;

  const PayrollReport({
    required this.period,
    required this.totalGrossPay,
    required this.totalNetPay,
    required this.totalDeductions,
    required this.averageSalary,
    required this.departmentPayroll,
    required this.salaryRanges,
    required this.monthlyPayroll,
  });
}

class TaskReport {
  final String period;
  final int totalTasks;
  final int completedTasks;
  final int inProgressTasks;
  final int overdueTasks;
  final Map<String, int> tasksByPriority;
  final Map<String, int> tasksByProject;
  final List<ChartDataPoint> completionTrend;
  final double averageCompletionTime;

  const TaskReport({
    required this.period,
    required this.totalTasks,
    required this.completedTasks,
    required this.inProgressTasks,
    required this.overdueTasks,
    required this.tasksByPriority,
    required this.tasksByProject,
    required this.completionTrend,
    required this.averageCompletionTime,
  });
}

class DashboardMetrics {
  final AttendanceReport attendance;
  final LeaveReport leave;
  final HeadcountReport headcount;
  final PayrollReport payroll;
  final TaskReport task;
  final DateTime generatedAt;

  const DashboardMetrics({
    required this.attendance,
    required this.leave,
    required this.headcount,
    required this.payroll,
    required this.task,
    required this.generatedAt,
  });
}

class ReportFilter {
  final DateRangeFilter dateRange;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> departments;
  final List<String> roles;
  final List<String> employees;

  const ReportFilter({
    required this.dateRange,
    this.startDate,
    this.endDate,
    this.departments = const [],
    this.roles = const [],
    this.employees = const [],
  });

  ReportFilter copyWith({
    DateRangeFilter? dateRange,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? departments,
    List<String>? roles,
    List<String>? employees,
  }) {
    return ReportFilter(
      dateRange: dateRange ?? this.dateRange,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      departments: departments ?? this.departments,
      roles: roles ?? this.roles,
      employees: employees ?? this.employees,
    );
  }
}