import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import '../../../../shared/widgets/common/app_card.dart';
import '../../domain/attendance_models.dart';
import '../../data/attendance_repository.dart';
import '../bloc/attendance_bloc.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AttendanceBloc(
        attendanceRepository: MockAttendanceRepository(),
      )..add(const AttendanceLoadRequested(employeeId: 'emp_001')),
      child: const AttendanceView(),
    );
  }
}

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  Timer? _clockTimer;
  DateTime _currentTime = DateTime.now();
  bool _isLocationLoading = false;

  @override
  void initState() {
    super.initState();
    _startClock();
    // Load current status
    context.read<AttendanceBloc>().add(
          const AttendanceCurrentStatusRequested(employeeId: 'emp_001'),
        );
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  void _startClock() {
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 1200;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Management'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
      ),
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state.status == AttendanceStateStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? 'An error occurred'),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<AttendanceBloc>().add(
                    const AttendanceLoadRequested(employeeId: 'emp_001'),
                  );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: isDesktop || isTablet
                  ? _buildDesktopLayout(context, state, theme)
                  : _buildMobileLayout(context, state, theme),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    AttendanceState state,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPunchCard(context, state, theme),
        const SizedBox(height: 16),
        _buildMonthlySummary(context, state, theme),
        const SizedBox(height: 16),
        _buildAttendanceHistory(context, state, theme, isMobile: true),
      ],
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    AttendanceState state,
    ThemeData theme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column - Punch card and summary (40%)
        Expanded(
          flex: 4,
          child: Column(
            children: [
              _buildPunchCard(context, state, theme),
              const SizedBox(height: 16),
              _buildMonthlySummary(context, state, theme),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Right column - History (60%)
        Expanded(
          flex: 6,
          child: _buildAttendanceHistory(context, state, theme, isMobile: false),
        ),
      ],
    );
  }

  Widget _buildPunchCard(
    BuildContext context,
    AttendanceState state,
    ThemeData theme,
  ) {
    final currentStatus = state.currentStatus;
    final isPunchedIn = currentStatus?.isPunchedIn ?? false;
    final nextAction = currentStatus?.nextAllowedAction;

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Live Clock
            Text(
              DateFormat('HH:mm:ss').format(_currentTime),
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('EEEE, MMMM d, yyyy').format(_currentTime),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getStatusColor(isPunchedIn).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getStatusColor(isPunchedIn),
                  width: 1,
                ),
              ),
              child: Text(
                isPunchedIn ? 'Punched In' : 'Not Punched In',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _getStatusColor(isPunchedIn),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Punch Button
            if (nextAction != null) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isPunching || _isLocationLoading
                      ? null
                      : () => _handlePunch(context, nextAction),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: nextAction == PunchType.punchIn
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLocationLoading || state.isPunching
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          nextAction.displayName,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],

            // Last punch info
            if (currentStatus?.lastPunchTime != null) ...[
              const SizedBox(height: 16),
              Text(
                'Last Action: ${DateFormat('HH:mm').format(currentStatus!.lastPunchTime!)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(bool isPunchedIn) {
    return isPunchedIn ? Colors.green : Colors.grey;
  }

  Future<void> _handlePunch(BuildContext context, PunchType type) async {
    // Simulate location check
    if (mounted) {
      setState(() {
        _isLocationLoading = true;
      });
    }

    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isLocationLoading = false;
      });

      // Dispatch punch event
      if (type == PunchType.punchIn) {
        context.read<AttendanceBloc>().add(
              const AttendancePunchInRequested(
                employeeId: 'emp_001',
                location: 'Office - Main Building',
              ),
            );
      } else if (type == PunchType.punchOut) {
        context.read<AttendanceBloc>().add(
              const AttendancePunchOutRequested(
                employeeId: 'emp_001',
                location: 'Office - Main Building',
              ),
            );
      }
    }
  }

  Widget _buildMonthlySummary(
    BuildContext context,
    AttendanceState state,
    ThemeData theme,
  ) {
    final summary = state.summary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month Selector
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Monthly Summary',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => _changeMonth(context, state, -1),
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  DateFormat('MMM yyyy').format(
                    DateTime(state.effectiveYear, state.effectiveMonth),
                  ),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => _changeMonth(context, state, 1),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Summary Cards
        if (summary != null) ...[
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Present',
                  summary.presentDays.toString(),
                  Colors.green,
                  Icons.check_circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Absent',
                  summary.absentDays.toString(),
                  Colors.red,
                  Icons.cancel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Late',
                  summary.lateDays.toString(),
                  Colors.orange,
                  Icons.access_time,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Hours',
                  '${summary.totalWorkingHours.toStringAsFixed(1)}h',
                  Colors.blue,
                  Icons.schedule,
                ),
              ),
            ],
          ),
        ] else ...[
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeMonth(BuildContext context, AttendanceState state, int delta) {
    final currentMonth = state.effectiveMonth;
    final currentYear = state.effectiveYear;

    int newMonth = currentMonth + delta;
    int newYear = currentYear;

    if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    } else if (newMonth < 1) {
      newMonth = 12;
      newYear--;
    }

    context.read<AttendanceBloc>().add(
          AttendanceMonthChanged(
            employeeId: 'emp_001',
            month: newMonth,
            year: newYear,
          ),
        );
  }

  Widget _buildAttendanceHistory(
    BuildContext context,
    AttendanceState state,
    ThemeData theme, {
    required bool isMobile,
  }) {
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance History',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (state.status == AttendanceStateStatus.loading)
              const Center(child: CircularProgressIndicator())
            else if (state.records.isEmpty)
              Center(
                child: Text(
                  'No attendance records found',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else if (isMobile)
              _buildMobileHistoryList(state.records, theme)
            else
              _buildDesktopHistoryTable(state.records, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileHistoryList(
    List<AttendanceRecord> records,
    ThemeData theme,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: records.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final record = records[index];
        return Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('EEE, MMM d').format(record.date),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _buildStatusBadge(record.status, theme),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'In: ${record.punchInTime != null ? DateFormat('HH:mm').format(record.punchInTime!) : '-'}',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      'Out: ${record.punchOutTime != null ? DateFormat('HH:mm').format(record.punchOutTime!) : '-'}',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      'Hours: ${record.totalWorkingHours.toStringAsFixed(1)}h',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopHistoryTable(
    List<AttendanceRecord> records,
    ThemeData theme,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text(
              'Date',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Day',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Punch In',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Punch Out',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Hours',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Status',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        rows: records.map((record) {
          return DataRow(
            cells: [
              DataCell(
                Text(
                  DateFormat('MMM d').format(record.date),
                  style: theme.textTheme.bodySmall,
                ),
              ),
              DataCell(
                Text(
                  DateFormat('EEE').format(record.date),
                  style: theme.textTheme.bodySmall,
                ),
              ),
              DataCell(
                Text(
                  record.punchInTime != null
                      ? DateFormat('HH:mm').format(record.punchInTime!)
                      : '-',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              DataCell(
                Text(
                  record.punchOutTime != null
                      ? DateFormat('HH:mm').format(record.punchOutTime!)
                      : '-',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              DataCell(
                Text(
                  '${record.totalWorkingHours.toStringAsFixed(1)}h',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DataCell(_buildStatusBadge(record.status, theme)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatusBadge(AttendanceStatus status, ThemeData theme) {
    Color color;
    switch (status) {
      case AttendanceStatus.present:
        color = Colors.green;
        break;
      case AttendanceStatus.absent:
        color = Colors.red;
        break;
      case AttendanceStatus.late:
        color = Colors.orange;
        break;
      case AttendanceStatus.halfDay:
        color = Colors.blue;
        break;
      case AttendanceStatus.onLeave:
        color = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        status.displayName,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}