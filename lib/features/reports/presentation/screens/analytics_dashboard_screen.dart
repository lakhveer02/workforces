import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/responsive_layout.dart';
import '../../data/report_repository.dart';
import '../../domain/report_models.dart';
import '../widgets/chart_card.dart';
import '../widgets/metric_card.dart';
import '../widgets/date_range_filter.dart' as filter;

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  final _repository = MockReportRepository();
  DashboardMetrics? _metrics;
  bool _isLoading = true;
  String? _error;
  DateRangeFilter _selectedRange = DateRangeFilter.thisMonth;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final filter = ReportFilter(
        dateRange: _selectedRange,
        startDate: _startDate,
        endDate: _endDate,
      );

      final metrics = await _repository.getDashboardMetrics(filter);

      if (mounted) {
        setState(() {
          _metrics = metrics;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _onDateRangeChanged(DateRangeFilter range, DateTime? start, DateTime? end) {
    setState(() {
      _selectedRange = range;
      _startDate = start;
      _endDate = end;
    });
    _loadMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.obsidyen,
      appBar: AppBar(
        title: Text(
          'Analytics Dashboard',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppTheme.buz,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.obsidyen,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.buz),
        actions: [
          IconButton(
            onPressed: _loadMetrics,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Date range filter
          filter.DateRangeFilterWidget(
            selectedRange: _selectedRange,
            startDate: _startDate,
            endDate: _endDate,
            onChanged: _onDateRangeChanged,
          ),
          
          // Content
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryStart),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.soluk,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load analytics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.soluk,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.soluk,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadMetrics,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_metrics == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 64,
              color: AppTheme.soluk,
            ),
            const SizedBox(height: 16),
            Text(
              'No analytics data available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.soluk,
              ),
            ),
          ],
        ),
      );
    }

    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return RefreshIndicator(
      onRefresh: _loadMetrics,
      color: AppTheme.primaryStart,
      backgroundColor: AppTheme.yuzey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricCards(),
            const SizedBox(height: AppTheme.spaceLarge),
            _buildAttendanceCharts(),
            const SizedBox(height: AppTheme.spaceLarge),
            _buildLeaveCharts(),
            const SizedBox(height: AppTheme.spaceLarge),
            _buildTaskCharts(),
            const SizedBox(height: AppTheme.spaceLarge),
            _buildHeadcountCharts(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return RefreshIndicator(
      onRefresh: _loadMetrics,
      color: AppTheme.primaryStart,
      backgroundColor: AppTheme.yuzey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricCards(),
            const SizedBox(height: AppTheme.spaceXLarge),
            
            // Two column layout for charts
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildAttendanceCharts(),
                      const SizedBox(height: AppTheme.spaceLarge),
                      _buildTaskCharts(),
                    ],
                  ),
                ),
                const SizedBox(width: AppTheme.spaceLarge),
                Expanded(
                  child: Column(
                    children: [
                      _buildLeaveCharts(),
                      const SizedBox(height: AppTheme.spaceLarge),
                      _buildHeadcountCharts(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return RefreshIndicator(
      onRefresh: _loadMetrics,
      color: AppTheme.primaryStart,
      backgroundColor: AppTheme.yuzey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceXLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricCards(),
            const SizedBox(height: AppTheme.spaceXXLarge),
            
            // Grid layout for charts
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: AppTheme.spaceXLarge,
              mainAxisSpacing: AppTheme.spaceXLarge,
              children: [
                _buildAttendanceCharts(),
                _buildLeaveCharts(),
                _buildTaskCharts(),
                _buildHeadcountCharts(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCards() {
    final attendance = _metrics!.attendance;
    final leave = _metrics!.leave;
    final task = _metrics!.task;
    final headcount = _metrics!.headcount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Metrics',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppTheme.buz,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spaceMedium),
        
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 1200;
            final isTablet = constraints.maxWidth > 600;
            
            if (isDesktop) {
              return Row(
                children: [
                  Expanded(child: _buildAttendanceMetric(attendance)),
                  const SizedBox(width: AppTheme.spaceMedium),
                  Expanded(child: _buildLeaveMetric(leave)),
                  const SizedBox(width: AppTheme.spaceMedium),
                  Expanded(child: _buildTaskMetric(task)),
                  const SizedBox(width: AppTheme.spaceMedium),
                  Expanded(child: _buildHeadcountMetric(headcount)),
                ],
              );
            } else if (isTablet) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildAttendanceMetric(attendance)),
                      const SizedBox(width: AppTheme.spaceMedium),
                      Expanded(child: _buildLeaveMetric(leave)),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceMedium),
                  Row(
                    children: [
                      Expanded(child: _buildTaskMetric(task)),
                      const SizedBox(width: AppTheme.spaceMedium),
                      Expanded(child: _buildHeadcountMetric(headcount)),
                    ],
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildAttendanceMetric(attendance),
                  const SizedBox(height: AppTheme.spaceMedium),
                  _buildLeaveMetric(leave),
                  const SizedBox(height: AppTheme.spaceMedium),
                  _buildTaskMetric(task),
                  const SizedBox(height: AppTheme.spaceMedium),
                  _buildHeadcountMetric(headcount),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildAttendanceMetric(AttendanceReport report) {
    return MetricCard(
      title: 'Attendance',
      value: '${report.attendancePercentage.toStringAsFixed(1)}%',
      subtitle: '${report.totalPresentDays}/${report.totalWorkingDays} days',
      icon: Icons.access_time,
      color: AppTheme.basari,
      trend: report.attendancePercentage > 90 ? 'up' : 'down',
      trendValue: '${report.attendancePercentage.toStringAsFixed(1)}%',
    );
  }

  Widget _buildLeaveMetric(LeaveReport report) {
    return MetricCard(
      title: 'Leave Requests',
      value: '${report.totalLeaveRequests}',
      subtitle: '${report.pendingLeaves} pending',
      icon: Icons.event_busy,
      color: AppTheme.altin,
      trend: 'neutral',
      trendValue: '${report.averageLeavePerEmployee} avg/employee',
    );
  }

  Widget _buildTaskMetric(TaskReport report) {
    final completionRate = report.totalTasks > 0 
        ? (report.completedTasks / report.totalTasks * 100)
        : 0.0;
    
    return MetricCard(
      title: 'Task Completion',
      value: '${completionRate.toStringAsFixed(1)}%',
      subtitle: '${report.completedTasks}/${report.totalTasks} tasks',
      icon: Icons.check_circle_outline,
      color: AppTheme.primaryStart,
      trend: completionRate > 80 ? 'up' : 'down',
      trendValue: '${report.averageCompletionTime.toStringAsFixed(1)} days avg',
    );
  }

  Widget _buildHeadcountMetric(HeadcountReport report) {
    return MetricCard(
      title: 'Active Employees',
      value: '${report.activeEmployees}',
      subtitle: '${report.newHires} new this month',
      icon: Icons.people_outline,
      color: AppTheme.primaryStart,
      trend: report.newHires > report.terminations ? 'up' : 'down',
      trendValue: '${report.turnoverRate.toStringAsFixed(1)}% turnover',
    );
  }

  Widget _buildAttendanceCharts() {
    final data = ChartData(
      title: 'Attendance Trend',
      subtitle: 'Monthly attendance percentage',
      type: ChartType.line,
      dataPoints: _metrics!.attendance.monthlyTrend,
      yAxisLabel: 'Attendance %',
      maxValue: 100,
      minValue: 70,
    );

    return ChartCard(
      data: data,
      height: 300,
    );
  }

  Widget _buildLeaveCharts() {
    final data = ChartData(
      title: 'Leave Distribution',
      subtitle: 'By type',
      type: ChartType.pie,
      dataPoints: _metrics!.leave.leaveTypeDistribution.entries.map((entry) {
        return ChartDataPoint(
          label: entry.key,
          value: entry.value.toDouble(),
          color: _getLeaveTypeColor(entry.key),
        );
      }).toList(),
    );

    return ChartCard(
      data: data,
      height: 300,
    );
  }

  Widget _buildTaskCharts() {
    final data = ChartData(
      title: 'Task Completion',
      subtitle: 'Monthly trend',
      type: ChartType.bar,
      dataPoints: _metrics!.task.completionTrend,
      yAxisLabel: 'Completed Tasks',
    );

    return ChartCard(
      data: data,
      height: 300,
    );
  }

  Widget _buildHeadcountCharts() {
    final data = ChartData(
      title: 'Team Growth',
      subtitle: 'Headcount over time',
      type: ChartType.area,
      dataPoints: _metrics!.headcount.headcountTrend,
      yAxisLabel: 'Employees',
    );

    return ChartCard(
      data: data,
      height: 300,
    );
  }

  String _getLeaveTypeColor(String leaveType) {
    switch (leaveType) {
      case 'Annual':
        return '#3B82F6';
      case 'Sick':
        return '#EF4444';
      case 'Casual':
        return '#10B981';
      case 'Maternity':
        return '#F59E0B';
      case 'Emergency':
        return '#8B5CF6';
      default:
        return '#94A3B8';
    }
  }
}