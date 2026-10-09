import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.color,
    this.borderRadius,
    this.border,
    this.onTap,
    this.clipBehavior = Clip.none,
    super.key,
  });

  const AppCard.outlined({
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.onTap,
    this.clipBehavior = Clip.none,
    super.key,
  }) : elevation = 0,
       border = const BorderSide();

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final BorderSide? border;
  final VoidCallback? onTap;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget card = Card(
      elevation: elevation ?? AppTheme.elevationSmall,
      color: color ?? theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusMedium),
        side: border ?? BorderSide.none,
      ),
      margin: margin ?? EdgeInsets.zero,
      clipBehavior: clipBehavior,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppTheme.spaceMedium),
        child: child,
      ),
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: borderRadius as BorderRadius? ?? BorderRadius.circular(AppTheme.radiusMedium),
        child: card,
      );
    }

    return card;
  }
}

class AppInfoCard extends StatelessWidget {
  const AppInfoCard({
    required this.title,
    this.subtitle,
    this.value,
    this.icon,
    this.trailing,
    this.onTap,
    this.color,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? value;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceSmall),
              decoration: BoxDecoration(
                color: (color ?? theme.colorScheme.primary).withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Icon(
                icon,
                color: color ?? theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: AppTheme.spaceMedium),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppTheme.spaceXSmall),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (value != null) ...[
                  const SizedBox(height: AppTheme.spaceXSmall),
                  Text(
                    value!,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: color ?? theme.colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppTheme.spaceSmall),
            trailing!,
          ] else if (onTap != null) ...[
            const SizedBox(width: AppTheme.spaceSmall),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ],
      ),
    );
  }
}

class AppStatCard extends StatelessWidget {
  const AppStatCard({
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.trend,
    this.trendDirection,
    this.color,
    this.onTap,
    super.key,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final String? trend;
  final TrendDirection? trendDirection;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.colorScheme.primary;
    
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  color: cardColor,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceSmall),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: cardColor,
            ),
          ),
          if (subtitle != null || trend != null) ...[
            const SizedBox(height: AppTheme.spaceXSmall),
            Row(
              children: [
                if (subtitle != null)
                  Expanded(
                    child: Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                if (trend != null && trendDirection != null) ...[
                  Icon(
                    trendDirection == TrendDirection.up
                        ? Icons.trending_up
                        : Icons.trending_down,
                    size: 16,
                    color: trendDirection == TrendDirection.up
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  ),
                  const SizedBox(width: AppTheme.spaceXSmall),
                  Text(
                    trend!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: trendDirection == TrendDirection.up
                          ? theme.colorScheme.primary
                          : theme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

enum TrendDirection { up, down }