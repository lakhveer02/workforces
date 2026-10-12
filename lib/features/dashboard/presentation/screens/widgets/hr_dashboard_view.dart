import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/dashboard/app_stat_card.dart';
import '../../../../../shared/widgets/dashboard/app_activity_list.dart';
import '../../../../../shared/widgets/dashboard/app_section_header.dart';
import '../../../domain/dashboard_models.dart';
import '../../blocs/dashboard_bloc.dart';

class HRDashboardView extends StatelessWidget {
  const HRDashboardView({
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
    if (data is! AdminDashboardData) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // HR Overview Stats
        const AppSectionHeader(
          title: 'HR Overview',
          icon: Icons.business_center,
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              // Desktop layout - 4 columns
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppStatCard(
                          title: 'Total Employees',
                          value: data.companyStats.totalEmployees.toString(),
                          subtitle: 'active',
                          icon: Icons.badge,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'Active Employees',
                          value: data.companyStats.activeEmployees.toString(),
                          subtitle: 'working',
                          icon: Icons.person_add,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'New Hires',
                          value: data.companyStats.newHires.toString(),
                          subtitle: 'this period',
                          icon: Icons.event_available,
                          color: AppColors.info,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'Attrition Rate',
                          value: '${data.companyStats.attritionRate.toStringAsFixed(1)}%',
                          subtitle: 'current',
                          icon: Icons.rate_review,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppStatCard(
                          title: 'HR Metrics',
                          value: data.hrMetrics.length.toString(),
                          subtitle: 'tracked',
                          icon: Icons.work_outline,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'Avg Tenure',
                          value: '${data.companyStats.averageTenure.toStringAsFixed(1)}y',
                          subtitle: 'per employee',
                          icon: Icons.attach_money,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'System Alerts',
                          value: data.systemAlerts.length.toString(),
                          subtitle: 'active',
                          icon: Icons.school,
                          color: AppColors.info,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'Departments',
                          value: data.departmentOverview.length.toString(),
                          subtitle: 'managed',
                          icon: Icons.apartment,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              // Mobile/tablet layout - 2x4 grid
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppStatCard(
                          title: 'Total Employees',
                          value: data.companyStats.totalEmployees.toString(),
                          subtitle: 'active',
                          icon: Icons.badge,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'Active Employees',
                          value: data.companyStats.activeEmployees.toString(),
                          subtitle: 'working',
                          icon: Icons.person_add,
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
                          title: 'New Hires',
                          value: data.companyStats.newHires.toString(),
                          subtitle: 'this period',
                          icon: Icons.event_available,
                          color: AppColors.info,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'Attrition Rate',
                          value: '${data.companyStats.attritionRate.toStringAsFixed(1)}%',
                          subtitle: 'current',
                          icon: Icons.rate_review,
                          color: AppColors.warning,
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

        // Department Overview
        const AppSectionHeader(
          title: 'Department Overview',
          icon: Icons.apartment,
        ),
        const SizedBox(height: 16),
        _buildDepartmentOverview(context, data.departmentOverview),
        const SizedBox(height: 24),

        // Recent HR Activities
        const AppSectionHeader(
          title: 'Recent HR Activities',
          icon: Icons.work_history,
        ),
        const SizedBox(height: 16),
        AppActivityList(
          activities: _convertActivitiesToActivityItems(data.recentActivities),
        ),

        const SizedBox(height: 24),

        // Coming Soon Placeholder
        const AppSectionHeader(
          title: 'Employee Lifecycle',
          icon: Icons.timeline,
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          color: AppColors.gray50,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.construction,
                  size: 48,
                  color: AppColors.gray400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Employee Lifecycle Analytics',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentOverview(BuildContext context, List<DepartmentSummary> departments) {
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
                  'Departments',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Department Analytics - Coming Soon!')),
                    );
                  },
                  child: const Text('View Details'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...departments.map((dept) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getDepartmentColor(dept.name).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getDepartmentIcon(dept.name),
                        color: _getDepartmentColor(dept.name),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dept.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.gray900,
                            ),
                          ),
                          Text(
                            '${dept.headcount} employees',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${dept.productivity.round()}%',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray900,
                          ),
                        ),
                        Text(
                          'productivity',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.gray600,
                          ),
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

  Color _getDepartmentColor(String department) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.success,
      AppColors.info,
      AppColors.warning,
    ];
    return colors[department.hashCode % colors.length];
  }

  IconData _getDepartmentIcon(String department) {
    switch (department.toLowerCase()) {
      case 'engineering':
        return Icons.code;
      case 'design':
        return Icons.palette;
      case 'marketing':
        return Icons.campaign;
      case 'sales':
        return Icons.trending_up;
      case 'hr':
        return Icons.people;
      case 'finance':
        return Icons.account_balance;
      case 'operations':
        return Icons.settings;
      default:
        return Icons.business;
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