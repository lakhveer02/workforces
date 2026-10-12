import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/theme_bloc.dart';
import '../../../core/theme/app_theme.dart';

/// Modern theme toggle button with Swiggy/Zomato aesthetic
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({
    super.key,
    this.showLabel = true,
    this.size = 48.0,
  });

  final bool showLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final colors = context.colors;
        final isDark = state.isDark(context);

        if (showLabel) {
          return _buildToggleWithLabel(context, colors, isDark, state);
        } else {
          return _buildToggleButton(context, colors, isDark, state);
        }
      },
    );
  }

  Widget _buildToggleWithLabel(BuildContext context, AppColors colors, bool isDark, ThemeState state) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceXS),
      decoration: BoxDecoration(
        color: colors.cardSubtle,
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ThemeOption(
            icon: Icons.light_mode_rounded,
            label: 'Light',
            isSelected: state.themeMode == ThemeMode.light,
            onTap: () => _changeTheme(context, ThemeMode.light),
            colors: colors,
          ),
          _ThemeOption(
            icon: Icons.dark_mode_rounded,
            label: 'Dark',
            isSelected: state.themeMode == ThemeMode.dark,
            onTap: () => _changeTheme(context, ThemeMode.dark),
            colors: colors,
          ),
          _ThemeOption(
            icon: Icons.brightness_auto_rounded,
            label: 'Auto',
            isSelected: state.themeMode == ThemeMode.system,
            onTap: () => _changeTheme(context, ThemeMode.system),
            colors: colors,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(BuildContext context, AppColors colors, bool isDark, ThemeState state) {
    return GestureDetector(
      onTap: () => context.read<ThemeBloc>().add(const ThemeToggled()),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            key: ValueKey(isDark),
            color: colors.textOnPrimary,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }

  void _changeTheme(BuildContext context, ThemeMode themeMode) {
    context.read<ThemeBloc>().add(ThemeChanged(themeMode));
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.colors,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceMD,
        vertical: AppTheme.spaceSM,
      ),
      decoration: BoxDecoration(
        color: isSelected ? colors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: colors.primary.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? colors.textOnPrimary : colors.textSecondary,
            ),
            const SizedBox(width: AppTheme.spaceXS),
            Text(
              label,
              style: TextStyle(
                fontSize: AppTheme.fontSM,
                fontWeight: FontWeight.w500,
                color: isSelected ? colors.textOnPrimary : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple icon-only theme toggle for app bars and toolbars
class ThemeIconButton extends StatelessWidget {
  const ThemeIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDark = state.isDark(context);
        
        return IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              key: ValueKey(isDark),
            ),
          ),
          tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          onPressed: () => context.read<ThemeBloc>().add(const ThemeToggled()),
        );
      },
    );
  }
}

/// Animated theme toggle switch (iOS style)
class ThemeToggleSwitch extends StatelessWidget {
  const ThemeToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final colors = context.colors;
        final isDark = state.isDark(context);
        
        return GestureDetector(
          onTap: () => context.read<ThemeBloc>().add(const ThemeToggled()),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: 60,
            height: 32,
            decoration: BoxDecoration(
              color: isDark ? colors.primary : colors.border,
              borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: isDark ? 32 : 4,
                  top: 4,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      size: 14,
                      color: isDark ? colors.primary : colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}