import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/dashboard/app_stat_card.dart';
import '../../../../../shared/widgets/dashboard/app_section_header.dart';

class SimpleAdminDashboard extends StatelessWidget {
  const SimpleAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // System Overview
        const AppSectionHeader(
          title: 'System Overview',
          icon: Icons.dashboard,
        ),
        const SizedBox(height: 16),
        
        // Simple Stats Grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: const [
            AppStatCard(
              title: 'Total Users',
              value: '248',
              subtitle: 'registered',
              icon: Icons.people_outline,
              change: '+12%',
              changeType: ChangeType.positive,
              color: AppColors.primary,
            ),
            AppStatCard(
              title: 'System Health',
              value: '99.8%',
              subtitle: 'uptime',
              icon: Icons.health_and_safety,
              change: '+0.1%',
              changeType: ChangeType.positive,
              color: AppColors.success,
            ),
            AppStatCard(
              title: 'Active Sessions',
              value: '156',
              subtitle: 'online now',
              icon: Icons.wifi,
              change: '-5%',
              changeType: ChangeType.negative,
              color: AppColors.info,
            ),
            AppStatCard(
              title: 'Data Usage',
              value: '2.4GB',
              subtitle: 'this month',
              icon: Icons.storage,
              change: '+18%',
              changeType: ChangeType.positive,
              color: AppColors.warning,
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // System Status
        const AppSectionHeader(
          title: 'System Status',
          icon: Icons.monitor_heart,
        ),
        const SizedBox(height: 16),
        
        Card(
          elevation: 0,
          color: AppColors.gray50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildStatusRow('CPU Usage', '45%', AppColors.success),
                const SizedBox(height: 12),
                _buildStatusRow('Memory', '67%', AppColors.warning),
                const SizedBox(height: 12),
                _buildStatusRow('Disk Space', '78%', AppColors.info),
                const SizedBox(height: 12),
                _buildStatusRow('Network', 'Stable', AppColors.success),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(String title, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.gray600,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}