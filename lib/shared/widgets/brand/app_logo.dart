import 'package:flutter/material.dart';

/// Consistent brand mark used on splash, login, and navigation.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 56,
    this.showWordmark = false,
    this.light = false,
  });

  final double size;
  final bool showWordmark;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.72),
            const Color(0xFF7C3AED),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        Icons.hub_outlined,
        color: Colors.white,
        size: size * 0.48,
      ),
    );

    if (!showWordmark) return mark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        SizedBox(width: size * 0.22),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'WorkforceOS',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
                color: light ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),
            Text(
              'People operations',
              style: theme.textTheme.labelSmall?.copyWith(
                color: light
                    ? Colors.white.withValues(alpha: 0.72)
                    : theme.colorScheme.onSurface.withValues(alpha: 0.55),
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
