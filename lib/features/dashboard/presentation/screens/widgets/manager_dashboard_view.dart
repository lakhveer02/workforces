import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/dashboard/app_stat_card.dart';
import '../../../../../shared/widgets/dashboard/app_activity_list.dart';
import '../../../../../shared/widgets/dashboard/app_section_header.dart';
import '../../../domain/dashboard_models.dart';
import '../../blocs/dashboard_bloc.dart';

class ManagerDashboardView extends StatelessWidget {
  const ManagerDashboardView({
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
    if (data is! ManagerDashboardData) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Team Overview Stats
        const AppSectionHeader(
          title: 'Team Overview',
          icon: Icons.groups,
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              // Desktop layout - 4 columns
              return Row(
                children: [
                  Expanded(
                    child: AppStatCard(
                      title: 'Team Size',
                      value: data.teamStats.totalMembers.toString(),
                      subtitle: 'members',
                      icon: Icons.people,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppStatCard(
                      title: 'Present Today',
                      value: data.teamStats.present.toString(),
                      subtitle: '${((data.teamStats.present / data.teamStats.totalMembers) * 100).round()}% attendance',
                      icon: Icons.check_circle,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppStatCard(
                      title: 'Pending Requests',
                      value: data.teamStats.pendingRequests.toString(),
                      subtitle: 'approvals needed',
                      icon: Icons.pending_actions,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppStatCard(
                      title: 'On Leave',
                      value: data.teamStats.onLeave.toString(),
                      subtitle: 'today',
                      icon: Icons.event_busy,
                      color: AppColors.info,
                    ),
                  ),
                ],
              );
            } else {
              // Mobile/tablet layout - 2x2 grid
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppStatCard(
                          title: 'Team Size',
                          value: data.teamStats.totalMembers.toString(),
                          subtitle: 'members',
                          icon: Icons.people,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'Present Today',
                          value: data.teamStats.present.toString(),
                          subtitle: '${((data.teamStats.present / data.teamStats.totalMembers) * 100).round()}% attendance',
                          icon: Icons.check_circle,
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
                          title: 'Pending Requests',
                          value: data.teamStats.pendingRequests.toString(),
                          subtitle: 'approvals needed',
                          icon: Icons.pending_actions,
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'On Leave',
                          value: data.teamStats.onLeave.toString(),
                          subtitle: 'today',
                          icon: Icons.event_busy,
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

        // Team Members Quick View
        const AppSectionHeader(
          title: 'Team Members',
          icon: Icons.people_outline,
        ),
        const SizedBox(height: 16),
        _buildTeamMembersList(context, data.teamAttendance),
        const SizedBox(height: 24),

        // Pending Approvals
        const AppSectionHeader(
          title: 'Pending Approvals',
          icon: Icons.pending_actions,
        ),
        const SizedBox(height: 16),
        _buildPendingApprovals(context, data.pendingApprovals),
        const SizedBox(height: 24),

        // Team Activity
        const AppSectionHeader(
          title: 'Team Activity',
          icon: Icons.timeline,
        ),
        const SizedBox(height: 16),
        AppActivityList(
          activities: _convertActivitiesToActivityItems(data.recentActivities),
        ),
      ],
    );
  }

  Widget _buildTeamMembersList(BuildContext context, List<TeamMemberAttendance> members) {
    return Card(
      elevation: 0,
      color: AppColors.gray50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Team Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to full team view
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Team Management - Coming Soon!')),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...members.take(5).map((member) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary.withValues(alpha: $1),
                      child: Text(
                        member.name.split(' ').map((n) => n[0]).join().toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.gray900,
                            ),
                          ),
                          Text(
                            member.punchInTime != null 
                                ? 'In at ${DateFormat.Hm().format(member.punchInTime!)}'
                                : 'Not punched in',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(member.status).withValues(alpha: $1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        member.status.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(member.status),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingApprovals(BuildContext context, List<PendingApproval> approvals) {
    if (approvals.isEmpty) {
      return Card(
        elevation: 0,
        color: AppColors.gray50,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 48,
                color: AppColors.success.withValues(alpha: $1),
              ),
              const SizedBox(height: 16),
              Text(
                'No Pending Approvals',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'All caught up! Great job.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.gray600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      color: AppColors.gray50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Requires Your Action (${approvals.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to approvals screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Approvals - Coming Soon!')),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...approvals.take(3).map((approval) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getApprovalTypeColor(approval.type).withValues(alpha: $1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getApprovalTypeIcon(approval.type),
                        size: 20,
                        color: _getApprovalTypeColor(approval.type),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${approval.employeeName} - ${approval.type.name.toUpperCase()}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.gray900,
                            ),
                          ),
                          Text(
                            approval.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            // TODO: Implement approval action
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Approved!')),
                            );
                          },
                          icon: const Icon(Icons.check, color: AppColors.success),
                        ),
                        IconButton(
                          onPressed: () {
                            // TODO: Implement rejection action
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Rejected!')),
                            );
                          },
                          icon: const Icon(Icons.close, color: AppColors.error),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(AttendanceStatusType status) {
    switch (status) {
      case AttendanceStatusType.present:
        return AppColors.success;
      case AttendanceStatusType.absent:
        return AppColors.error;
      case AttendanceStatusType.late:
        return AppColors.warning;
      case AttendanceStatusType.onLeave:
        return AppColors.info;
      case AttendanceStatusType.halfDay:
        return AppColors.secondary;
    }
  }

  Color _getApprovalTypeColor(ApprovalType type) {
    switch (type) {
      case ApprovalType.leave:
        return AppColors.warning;
      case ApprovalType.timesheet:
        return AppColors.info;
      case ApprovalType.expense:
        return AppColors.success;
      case ApprovalType.document:
        return AppColors.primary;
    }
  }

  IconData _getApprovalTypeIcon(ApprovalType type) {
    switch (type) {
      case ApprovalType.leave:
        return Icons.event_busy;
      case ApprovalType.timesheet:
        return Icons.schedule;
      case ApprovalType.expense:
        return Icons.receipt;
      case ApprovalType.document:
        return Icons.description;
    }
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