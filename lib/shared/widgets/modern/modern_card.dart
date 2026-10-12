import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Modern card component with Swiggy/Zomato aesthetic
class ModernCard extends StatelessWidget {
  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.elevation = 0,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.hasBorder = true,
    this.hasShadow = false,
    this.shadowColor,
    this.isSelected = false,
    this.selectedColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double elevation;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool hasBorder;
  final bool hasShadow;
  final Color? shadowColor;
  final bool isSelected;
  final Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectiveBackgroundColor = backgroundColor ?? 
        (isSelected ? colors.primary.withOpacity(0.08) : colors.card);
    final effectiveBorderColor = borderColor ?? 
        (isSelected ? colors.primary : colors.cardBorder);

    return Container(
      margin: margin,
      child: Material(
        color: effectiveBackgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusMD),
        elevation: elevation,
        shadowColor: shadowColor ?? colors.textPrimary.withOpacity(0.08),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusMD),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: padding ?? const EdgeInsets.all(AppTheme.spaceBase),
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusMD),
              border: hasBorder ? Border.all(
                color: effectiveBorderColor,
                width: isSelected ? 1.5 : 1,
              ) : null,
              boxShadow: hasShadow ? [
                BoxShadow(
                  color: (shadowColor ?? colors.textPrimary).withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ] : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Modern elevated card with gradient border effect
class ModernElevatedCard extends StatelessWidget {
  const ModernElevatedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius,
    this.gradientBorder = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final bool gradientBorder;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(AppTheme.radiusMD);

    if (gradientBorder) {
      return Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: effectiveBorderRadius,
          gradient: LinearGradient(
            colors: [colors.primary, colors.warning],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: effectiveBorderRadius,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: effectiveBorderRadius,
            child: InkWell(
              onTap: onTap,
              borderRadius: effectiveBorderRadius,
              child: Padding(
                padding: padding ?? const EdgeInsets.all(AppTheme.spaceBase),
                child: child,
              ),
            ),
          ),
        ),
      );
    }

    return ModernCard(
      margin: margin,
      padding: padding,
      onTap: onTap,
      borderRadius: borderRadius,
      hasShadow: true,
      elevation: 2,
      child: child,
    );
  }
}

/// Modern stats card with icon and metrics
class ModernStatsCard extends StatelessWidget {
  const ModernStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.trend,
    this.trendValue,
    this.color,
    this.onTap,
    this.isLoading = false,
  });

  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  final TrendDirection? trend;
  final String? trendValue;
  final Color? color;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectiveColor = color ?? colors.primary;

    return ModernCard(
      onTap: onTap,
      hasShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spaceSM),
                decoration: BoxDecoration(
                  color: effectiveColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                ),
                child: Icon(
                  icon,
                  color: effectiveColor,
                  size: 20,
                ),
              ),
              const Spacer(),
              if (trend != null && trendValue != null)
                _TrendIndicator(
                  direction: trend!,
                  value: trendValue!,
                  colors: colors,
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceMD),
          if (isLoading)
            Container(
              height: 24,
              width: 80,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(AppTheme.radiusXS),
              ),
            )
          else
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
          const SizedBox(height: AppTheme.spaceXS),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppTheme.spaceXS),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum TrendDirection { up, down, neutral }

class _TrendIndicator extends StatelessWidget {
  const _TrendIndicator({
    required this.direction,
    required this.value,
    required this.colors,
  });

  final TrendDirection direction;
  final String value;
  final ThemeColors colors;

  @override
  Widget build(BuildContext context) {
    Color trendColor;
    IconData trendIcon;

    switch (direction) {
      case TrendDirection.up:
        trendColor = colors.success;
        trendIcon = Icons.trending_up_rounded;
        break;
      case TrendDirection.down:
        trendColor = colors.danger;
        trendIcon = Icons.trending_down_rounded;
        break;
      case TrendDirection.neutral:
        trendColor = colors.textSecondary;
        trendIcon = Icons.trending_flat_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceSM,
        vertical: AppTheme.spaceXS,
      ),
      decoration: BoxDecoration(
        color: trendColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            trendIcon,
            color: trendColor,
            size: 12,
          ),
          const SizedBox(width: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: AppTheme.fontXS,
              fontWeight: FontWeight.w600,
              color: trendColor,
            ),
          ),
        ],
      ),
    );
  }
}