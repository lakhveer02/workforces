import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/dashboard/app_stat_card.dart';
import '../../../../../shared/widgets/dashboard/app_activity_list.dart';
import '../../../../../shared/widgets/dashboard/app_section_header.dart';
import '../../../domain/dashboard_models.dart' show EmployeeDashboardData, Activity, ScheduleItem;
import '../../blocs/dashboard_bloc.dart';

class EmployeeDashboardView extends StatelessWidget {
  const EmployeeDashboardView({
    super.key,
    required this.state,
  });

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    if (state is! DashboardLoaded) {
      return const SizedBox.shrink();
    }

    final data = (state as DashboardLoaded).data;
    if (data is! EmployeeDashboardData) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Quick Actions
        const AppSectionHeader(
          title: 'Quick Actions',
          icon: Icons.flash_on,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildPunchCard(
                context,
                title: data.attendanceStatus.isPunchedIn ? 'Punch Out' : 'Punch In',
                icon: data.attendanceStatus.isPunchedIn ? Icons.logout : Icons.login,
                color: data.attendanceStatus.isPunchedIn ? AppColors.error : AppColors.success,
                isPunchedIn: data.attendanceStatus.isPunchedIn,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'Apply Leave',
                Icons.event_busy,
                AppColors.warning,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Apply Leave - Coming Soon!')),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Today's Stats
        const AppSectionHeader(
          title: 'Today\'s Overview',
          icon: Icons.today,
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              // Desktop/tablet layout - 4 columns
              return Row(
                children: [
                  Expanded(
                    child: AppStatCard(
                      title: 'Hours Today',
                      value: data.attendanceStatus.workingHoursFormatted,
                      subtitle: 'worked',
                      icon: Icons.access_time,
                      change: data.attendanceStatus.workingHours.inHours > 8 ? '+0.8h' : null,
                      changeType: data.attendanceStatus.workingHours.inHours > 8 
                          ? ChangeType.positive 
                          : ChangeType.neutral,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppStatCard(
                      title: 'Leave Balance',
                      value: data.leaveBalance.annual.remaining.toString(),
                      subtitle: 'days left',
                      icon: Icons.calendar_today,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppStatCard(
                      title: 'Personal Stats',
                      value: data.personalStats.length.toString(),
                      subtitle: 'metrics',
                      icon: Icons.insights,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppStatCard(
                      title: 'Activities',
                      value: data.recentActivities.length.toString(),
                      subtitle: 'recent',
                      icon: Icons.schedule,
                      color: AppColors.info,
                    ),
                  ),
                ],
              );
            } else {
              // Mobile layout - 2x2 grid
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppStatCard(
                          title: 'Hours Today',
                          value: data.attendanceStatus.workingHoursFormatted,
                          subtitle: 'worked',
                          icon: Icons.access_time,
                          change: data.attendanceStatus.workingHours.inHours > 8 ? '+0.8h' : null,
                          changeType: data.attendanceStatus.workingHours.inHours > 8 
                              ? ChangeType.positive 
                              : ChangeType.neutral,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'Leave Balance',
                          value: data.leaveBalance.annual.remaining.toString(),
                          subtitle: 'days left',
                          icon: Icons.calendar_today,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppStatCard(
                          title: 'Personal Stats',
                          value: data.personalStats.length.toString(),
                          subtitle: 'metrics',
                          icon: Icons.insights,
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'Activities',
                          value: data.recentActivities.length.toString(),
                          subtitle: 'recent',
                          icon: Icons.schedule,
                          color: AppColors.info,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
        const SizedBox(height: 24),

        // Recent Activity
        const AppSectionHeader(
          title: 'Recent Activity',
          icon: Icons.history,
        ),
        const SizedBox(height: 16),
        AppActivityList(
          activities: _convertActivitiesToActivityItems(data.recentActivities),
        ),

        const SizedBox(height: 24),

        const SizedBox(height: 24),

        // Today's Schedule
        const AppSectionHeader(
          title: 'Today\'s Schedule',
          icon: Icons.calendar_today,
        ),
        const SizedBox(height: 16),
        _buildScheduleList(context, data.todaySchedule),
      ],
    );
  }

  Widget _buildPunchCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required bool isPunchedIn,
  }) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: color.withValues(alpha: 0.1),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isPunchedIn 
                  ? 'Punched out successfully!' 
                  : 'Punched in successfully!'),
              backgroundColor: color,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: color.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleList(BuildContext context, List<ScheduleItem> schedule) {
    final theme = Theme.of(context);
    if (schedule.isEmpty) {
      return Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 40,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(height: 12),
              Text(
                'Nothing on the calendar',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Your schedule for today will show up here.',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      );
    }
    
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: schedule.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: Container(
                  width: 56,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    DateFormat.Hm().format(item.time),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(item.type.name.toUpperCase()),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.outline,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<ActivityItem> _convertActivitiesToActivityItems(List<Activity> activities) {
    return activities.map((activity) {
      final duration = DateTime.now().difference(activity.timestamp);
      String timeAgo;
      if (duration.inDays > 0) {
        timeAgo = '${duration.inDays}d ago';
      } else if (duration.inHours > 0) {
        timeAgo = '${duration.inHours}h ago';
      } else if (duration.inMinutes > 0) {
        timeAgo = '${duration.inMinutes}m ago';
      } else {
        timeAgo = 'Just now';
      }

      return ActivityItem(
        title: activity.title,
        timeAgo: timeAgo,
        description: activity.description,
        icon: _getIconDataFromString(activity.icon),
      );
    }).toList();
  }

  IconData _getIconDataFromString(String iconName) {
    switch (iconName) {
      case 'access_time':
        return Icons.access_time;
      case 'event_busy':
        return Icons.event_busy;
      case 'task_alt':
        return Icons.task_alt;
      case 'announcement':
        return Icons.announcement;
      case 'account_balance':
        return Icons.account_balance;
      case 'settings':
        return Icons.settings;
      default:
        return Icons.info;
    }
  }
}