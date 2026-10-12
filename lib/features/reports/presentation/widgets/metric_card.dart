import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String trend; // 'up', 'down', 'neutral'
  final String trendValue;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.trend,
    required this.trendValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radius8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.soluk,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.soluk,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              _buildTrendIndicator(),
            ],
          ),
          
          const SizedBox(height: AppTheme.spaceMedium),
          
          // Main value
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.buz,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                trendValue,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.soluk,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendIndicator() {
    IconData trendIcon;
    Color trendColor;

    switch (trend) {
      case 'up':
        trendIcon = Icons.trending_up;
        trendColor = AppTheme.basari;
        break;
      case 'down':
        trendIcon = Icons.trending_down;
        trendColor = Colors.red;
        break;
      default:
        trendIcon = Icons.trending_flat;
        trendColor = AppTheme.soluk;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: trendColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radius24),
        border: Border.all(color: trendColor.withValues(alpha: 0.3)),
      ),
      child: Icon(
        trendIcon,
        color: trendColor,
        size: 14,
      ),
    );
  }
}