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
    final accent = color ?? theme.colorScheme.primary;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, size: isMobile ? 18 : 20, color: accent),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                  color: theme.colorScheme.onSurface,
                  fontSize: isMobile ? 26 : 30,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall,
                ),
              ],
              if (change != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getChangeColor(changeType, theme).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getChangeIcon(changeType),
                        size: 14,
                        color: _getChangeColor(changeType, theme),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        change!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _getChangeColor(changeType, theme),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
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
        return Icons.trending_up_rounded;
      case ChangeType.negative:
        return Icons.trending_down_rounded;
      case ChangeType.neutral:
        return Icons.trending_flat_rounded;
    }
  }

  Color _getChangeColor(ChangeType type, ThemeData theme) {
    switch (type) {
      case ChangeType.positive:
        return AppColors.success;
      case ChangeType.negative:
        return AppColors.error;
      case ChangeType.neutral:
        return theme.colorScheme.onSurface.withValues(alpha: 0.55);
    }
  }
}

enum ChangeType {
  positive,
  negative,
  neutral,
}

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
  final double? progress;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile(context);
    final accent = color ?? theme.colorScheme.primary;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: accent,
                      fontSize: isMobile ? 30 : 36,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(unit, style: theme.textTheme.titleMedium),
                ],
              ),
              if (target != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Target: $target', style: theme.textTheme.labelMedium),
                    if (progress != null)
                      Text(
                        '${(progress! * 100).toStringAsFixed(0)}%',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ],
              if (progress != null) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.16),
                    valueColor: AlwaysStoppedAnimation(accent),
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
