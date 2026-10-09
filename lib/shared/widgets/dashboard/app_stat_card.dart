import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../main.dart';

/// A responsive stat card component that displays metrics with trend indicators
class AppStatCard extends StatelessWidget {
  const AppStatCard({
    required this.title,
    required this.value,
    this.subtitle,
    this.change,
    this.changeType = ChangeType.neutral,
    this.icon,
    this.color,
    this.onTap,
    super.key,
  });

  final String title;
  final String value;
  final String? subtitle;
  final String? change;
  final ChangeType changeType;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile(context);
    
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with icon and title
              Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (color ?? theme.colorScheme.primary).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        size: isMobile ? 20 : 24,
                        color: color ?? theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Main value
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  fontSize: isMobile ? 28 : 32,
                ),
              ),
              
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
              
              // Change indicator
              if (change != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      _getChangeIcon(changeType),
                      size: 16,
                      color: _getChangeColor(changeType, theme),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      change!,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: _getChangeColor(changeType, theme),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'vs last period',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getChangeIcon(ChangeType type) {
    switch (type) {
      case ChangeType.positive:
        return Icons.trending_up;
      case ChangeType.negative:
        return Icons.trending_down;
      case ChangeType.neutral:
        return Icons.trending_flat;
    }
  }

  Color _getChangeColor(ChangeType type, ThemeData theme) {
    switch (type) {
      case ChangeType.positive:
        return Colors.green;
      case ChangeType.negative:
        return Colors.red;
      case ChangeType.neutral:
        return theme.colorScheme.onSurface.withValues(alpha: 0.6);
    }
  }
}

enum ChangeType {
  positive,
  negative,
  neutral,
}

/// A specialized stat card for displaying key metrics with better visual hierarchy
class AppMetricCard extends StatelessWidget {
  const AppMetricCard({
    required this.title,
    required this.value,
    required this.unit,
    this.target,
    this.progress,
    this.color,
    this.onTap,
    super.key,
  });

  final String title;
  final String value;
  final String unit;
  final String? target;
  final double? progress; // 0.0 to 1.0
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile(context);
    
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Value and unit
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color ?? theme.colorScheme.primary,
                      fontSize: isMobile ? 32 : 40,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    unit,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              
              // Target and progress
              if (target != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Target: $target',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    if (progress != null)
                      Text(
                        '${(progress! * 100).toStringAsFixed(0)}%',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: color ?? theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ],
              
              // Progress bar
              if (progress != null) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation(
                    color ?? theme.colorScheme.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}