import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/dashboard/app_stat_card.dart';
import '../../../../../shared/widgets/dashboard/app_activity_list.dart';
import '../../../../../shared/widgets/dashboard/app_section_header.dart';
import '../../../domain/dashboard_models.dart';
import '../../blocs/dashboard_bloc.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({
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
        // System Overview
        const AppSectionHeader(
          title: 'System Overview',
          icon: Icons.dashboard,
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
                          subtitle: 'registered',
                          icon: Icons.people_outline,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'Active Employees',
                          value: data.companyStats.activeEmployees.toString(),
                          subtitle: 'working now',
                          icon: Icons.wifi,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'New Hires',
                          value: data.companyStats.newHires.toString(),
                          subtitle: 'recent',
                          icon: Icons.health_and_safety,
                          color: AppColors.info,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'Attrition Rate',
                          value: '${data.companyStats.attritionRate.toStringAsFixed(1)}%',
                          subtitle: 'current period',
                          icon: Icons.storage,
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
                          icon: Icons.api,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'System Alerts',
                          value: data.systemAlerts.length.toString(),
                          subtitle: 'active',
                          icon: Icons.error_outline,
                          color: data.systemAlerts.isNotEmpty ? AppColors.error : AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'Departments',
                          value: data.departmentOverview.length.toString(),
                          subtitle: 'managed',
                          icon: Icons.security,
                          color: AppColors.info,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'Avg Tenure',
                          value: '${data.companyStats.averageTenure.toStringAsFixed(1)}y',
                          subtitle: 'per employee',
                          icon: Icons.backup,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              // Mobile/tablet layout - key metrics
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppStatCard(
                          title: 'Total Employees',
                          value: data.companyStats.totalEmployees.toString(),
                          subtitle: 'registered',
                          icon: Icons.people_outline,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'Active Employees',
                          value: data.companyStats.activeEmployees.toString(),
                          subtitle: 'working',
                          icon: Icons.health_and_safety,
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
                          subtitle: 'recent',
                          icon: Icons.wifi,
                          color: AppColors.info,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStatCard(
                          title: 'System Alerts',
                          value: data.systemAlerts.length.toString(),
                          subtitle: 'active',
                          icon: Icons.security,
                          color: data.systemAlerts.isNotEmpty ? AppColors.error : AppColors.success,
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

        // System Status Placeholder
        const AppSectionHeader(
          title: 'System Health',
          icon: Icons.monitor_heart,
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
                  'System Health Monitoring',
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
        const SizedBox(height: 24),

        // User Analytics Placeholder
        const AppSectionHeader(
          title: 'User Analytics',
          icon: Icons.analytics,
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
                  'User Analytics Dashboard',
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
        const SizedBox(height: 24),

        // System Activities
        const AppSectionHeader(
          title: 'System Activities',
          icon: Icons.history,
        ),
        const SizedBox(height: 16),
        AppActivityList(
          activities: _convertActivitiesToActivityItems(data.recentActivities),
        ),
      ],
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