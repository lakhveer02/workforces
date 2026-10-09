import 'package:flutter/material.dart';

/// A consistent section header for dashboard sections with optional actions
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.title,
    this.subtitle,
    this.actionText,
    this.onActionTap,
    this.icon,
    this.color,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onActionTap;
  final IconData? icon;
  final Color? color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding,
      child: Row(
        children: [
          // Icon if provided
          if (icon != null) ...[
            Icon(
              icon,
              size: 24,
              color: color ?? theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
          ],
          
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Action button
          if (actionText != null && onActionTap != null)
            TextButton(
              onPressed: onActionTap,
              child: Text(actionText!),
            ),
        ],
      ),
    );
  }
}