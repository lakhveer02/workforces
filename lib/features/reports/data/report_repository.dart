import '../domain/report_models.dart';

class MockReportRepository {
  static final MockReportRepository _instance = MockReportRepository._internal();
  factory MockReportRepository() => _instance;
  MockReportRepository._internal();

  Future<DashboardMetrics> getDashboardMetrics([ReportFilter? filter]) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    
    return DashboardMetrics(
      attendance: await _generateAttendanceReport(),
      leave: await _generateLeaveReport(),
      headcount: await _generateHeadcountReport(),
      payroll: await _generatePayrollReport(),
      task: await _generateTaskReport(),
      generatedAt: DateTime.now(),
    );
  }

  Future<AttendanceReport> getAttendanceReport([ReportFilter? filter]) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return await _generateAttendanceReport();
  }

  Future<LeaveReport> getLeaveReport([ReportFilter? filter]) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return await _generateLeaveReport();
  }

  Future<HeadcountReport> getHeadcountReport([ReportFilter? filter]) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return await _generateHeadcountReport();
  }

  Future<PayrollReport> getPayrollReport([ReportFilter? filter]) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return await _generatePayrollReport();
  }

  Future<TaskReport> getTaskReport([ReportFilter? filter]) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return await _generateTaskReport();
  }

  Future<AttendanceReport> _generateAttendanceReport() async {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);
    
    return AttendanceReport(
      period: '${now.year}-${now.month.toString().padLeft(2, '0')}',
      totalWorkingDays: 22,
      totalPresentDays: 198,
      totalAbsentDays: 24,
      totalLateDays: 8,
      attendancePercentage: 89.2,
      departmentAttendance: {
        'Engineering': 95,
        'HR': 88,
        'Sales': 92,
        'Marketing': 85,
        'Finance': 91,
      },
      dailyAttendance: List.generate(30, (index) {
        final date = currentMonth.add(Duration(days: index));
        final attendanceRate = 85 + (index % 10) * 1.5;
        return ChartDataPoint(
          label: '${date.day}',
          value: attendanceRate,
          date: date,
        );
      }),
      monthlyTrend: List.generate(6, (index) {
        final month = DateTime(now.year, now.month - index, 1);
        final rate = 87 + (index % 3) * 2.5;
        return ChartDataPoint(
          label: _getMonthName(month.month),
          value: rate,
          date: month,
        );
      }).reversed.toList(),
    );
  }

  Future<LeaveReport> _generateLeaveReport() async {
    final now = DateTime.now();
    
    return LeaveReport(
      period: '${now.year}-${now.month.toString().padLeft(2, '0')}',
      totalLeaveRequests: 45,
      approvedLeaves: 38,
      pendingLeaves: 5,
      rejectedLeaves: 2,
      leaveTypeDistribution: {
        'Annual': 18,
        'Sick': 12,
        'Casual': 8,
        'Maternity': 3,
        'Emergency': 4,
      },
      departmentLeaves: {
        'Engineering': 15,
        'HR': 8,
        'Sales': 12,
        'Marketing': 7,
        'Finance': 3,
      },
      monthlyLeaveRequests: List.generate(6, (index) {
        final month = DateTime(now.year, now.month - index, 1);
        final requests = 35 + (index % 4) * 5;
        return ChartDataPoint(
          label: _getMonthName(month.month),
          value: requests.toDouble(),
          date: month,
        );
      }).reversed.toList(),
      averageLeavePerEmployee: 2.1,
    );
  }

  Future<HeadcountReport> _generateHeadcountReport() async {
    final now = DateTime.now();
    
    return HeadcountReport(
      period: '${now.year}-${now.month.toString().padLeft(2, '0')}',
      totalEmployees: 124,
      newHires: 8,
      terminations: 3,
      activeEmployees: 121,
      departmentHeadcount: {
        'Engineering': 45,
        'Sales': 28,
        'Marketing': 18,
        'HR': 12,
        'Finance': 15,
        'Operations': 6,
      },
      roleDistribution: {
        'Senior Developer': 25,
        'Junior Developer': 18,
        'Sales Executive': 22,
        'Marketing Specialist': 12,
        'HR Specialist': 8,
        'Finance Analyst': 10,
        'Manager': 15,
        'Director': 6,
        'Others': 8,
      },
      headcountTrend: List.generate(12, (index) {
        final month = DateTime(now.year, now.month - index, 1);
        final count = 110 + index * 2;
        return ChartDataPoint(
          label: _getMonthName(month.month),
          value: count.toDouble(),
          date: month,
        );
      }).reversed.toList(),
      turnoverRate: 2.4,
    );
  }

  Future<PayrollReport> _generatePayrollReport() async {
    final now = DateTime.now();
    
    return PayrollReport(
      period: '${now.year}-${now.month.toString().padLeft(2, '0')}',
      totalGrossPay: 1250000.0,
      totalNetPay: 980000.0,
      totalDeductions: 270000.0,
      averageSalary: 10080.0,
      departmentPayroll: {
        'Engineering': 450000.0,
        'Sales': 280000.0,
        'Marketing': 180000.0,
        'HR': 120000.0,
        'Finance': 150000.0,
        'Operations': 70000.0,
      },
      salaryRanges: {
        '30k-50k': 25.0,
        '50k-75k': 35.0,
        '75k-100k': 22.0,
        '100k-150k': 12.0,
        '150k+': 6.0,
      },
      monthlyPayroll: List.generate(6, (index) {
        final month = DateTime(now.year, now.month - index, 1);
        final amount = 1150000 + (index % 3) * 50000;
        return ChartDataPoint(
          label: _getMonthName(month.month),
          value: amount.toDouble(),
          date: month,
        );
      }).reversed.toList(),
    );
  }

  Future<TaskReport> _generateTaskReport() async {
    final now = DateTime.now();
    
    return TaskReport(
      period: '${now.year}-${now.month.toString().padLeft(2, '0')}',
      totalTasks: 156,
      completedTasks: 98,
      inProgressTasks: 32,
      overdueTasks: 12,
      tasksByPriority: {
        'Low': 45,
        'Medium': 68,
        'High': 32,
        'Urgent': 11,
      },
      tasksByProject: {
        'WorkforceOS Mobile': 58,
        'HR Dashboard': 42,
        'Payroll System': 35,
        'Analytics Platform': 21,
      },
      completionTrend: List.generate(6, (index) {
        final month = DateTime(now.year, now.month - index, 1);
        final completed = 85 + (index % 4) * 8;
        return ChartDataPoint(
          label: _getMonthName(month.month),
          value: completed.toDouble(),
          date: month,
        );
      }).reversed.toList(),
      averageCompletionTime: 5.2,
    );
  }

  Future<List<ChartData>> getCustomCharts(ReportFilter filter) async {
    await Future.delayed(const Duration(milliseconds: 700));
    
    return [
      ChartData(
        title: 'Employee Satisfaction',
        subtitle: 'Monthly survey results',
        type: ChartType.line,
        dataPoints: [
          ChartDataPoint(label: 'Jan', value: 4.2),
          ChartDataPoint(label: 'Feb', value: 4.3),
          ChartDataPoint(label: 'Mar', value: 4.1),
          ChartDataPoint(label: 'Apr', value: 4.4),
          ChartDataPoint(label: 'May', value: 4.5),
          ChartDataPoint(label: 'Jun', value: 4.3),
        ],
        yAxisLabel: 'Satisfaction Score',
        maxValue: 5.0,
        minValue: 0.0,
      ),
      ChartData(
        title: 'Training Completion',
        subtitle: 'By department',
        type: ChartType.bar,
        dataPoints: [
          ChartDataPoint(label: 'Engineering', value: 92, color: '#3B82F6'),
          ChartDataPoint(label: 'Sales', value: 88, color: '#10B981'),
          ChartDataPoint(label: 'Marketing', value: 85, color: '#F59E0B'),
          ChartDataPoint(label: 'HR', value: 95, color: '#8B5CF6'),
          ChartDataPoint(label: 'Finance', value: 90, color: '#EF4444'),
        ],
        yAxisLabel: 'Completion %',
        maxValue: 100.0,
      ),
      ChartData(
        title: 'Work From Home',
        subtitle: 'Distribution by preference',
        type: ChartType.pie,
        dataPoints: [
          ChartDataPoint(label: 'Full Remote', value: 35, color: '#10B981'),
          ChartDataPoint(label: 'Hybrid', value: 45, color: '#3B82F6'),
          ChartDataPoint(label: 'Full Office', value: 20, color: '#F59E0B'),
        ],
      ),
    ];
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  Future<List<String>> getDepartments() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      'Engineering',
      'HR',
      'Sales',
      'Marketing',
      'Finance',
      'Operations',
    ];
  }

  Future<List<String>> getRoles() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      'Senior Developer',
      'Junior Developer',
      'Sales Executive',
      'Marketing Specialist',
      'HR Specialist',
      'Finance Analyst',
      'Manager',
      'Director',
    ];
  }

  Future<void> exportReport(String reportType, ReportFilter filter) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    // Mock export - in real app would generate CSV/PDF
    throw UnimplementedError('Report export not implemented in mock');
  }
}