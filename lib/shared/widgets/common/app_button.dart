import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

enum AppButtonType {
  primary,
  secondary,
  outline,
  text,
  danger,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

class AppButton extends StatelessWidget {
  const AppButton({
    required this.onPressed,
    required this.child,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.iconPosition = IconPosition.leading,
    super.key,
  });

  const AppButton.primary({
    required this.onPressed,
    required this.child,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.iconPosition = IconPosition.leading,
    super.key,
  }) : type = AppButtonType.primary;

  const AppButton.secondary({
    required this.onPressed,
    required this.child,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.iconPosition = IconPosition.leading,
    super.key,
  }) : type = AppButtonType.secondary;

  const AppButton.outline({
    required this.onPressed,
    required this.child,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.iconPosition = IconPosition.leading,
    super.key,
  }) : type = AppButtonType.outline;

  const AppButton.text({
    required this.onPressed,
    required this.child,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.iconPosition = IconPosition.leading,
    super.key,
  }) : type = AppButtonType.text;

  const AppButton.danger({
    required this.onPressed,
    required this.child,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.iconPosition = IconPosition.leading,
    super.key,
  }) : type = AppButtonType.danger;

  final VoidCallback? onPressed;
  final Widget child;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final IconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _getHeight(),
      child: _buildButton(theme, isEnabled),
    );
  }

  Widget _buildButton(ThemeData theme, bool isEnabled) {
    final buttonChild = _buildButtonChild();

    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: _getElevatedButtonStyle(theme, isEnabled),
          child: buttonChild,
        );

      case AppButtonType.secondary:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: _getSecondaryButtonStyle(theme, isEnabled),
          child: buttonChild,
        );

      case AppButtonType.outline:
        return OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: _getOutlinedButtonStyle(theme, isEnabled),
          child: buttonChild,
        );

      case AppButtonType.text:
        return TextButton(
          onPressed: isEnabled ? onPressed : null,
          style: _getTextButtonStyle(theme, isEnabled),
          child: buttonChild,
        );

      case AppButtonType.danger:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: _getDangerButtonStyle(theme, isEnabled),
          child: buttonChild,
        );
    }
  }

  Widget _buildButtonChild() {
    if (isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == AppButtonType.primary || type == AppButtonType.danger
                ? Colors.white
                : Colors.blue, // fallback color since we don't have context here
          ),
        ),
      );
    }

    if (icon != null) {
      final iconWidget = Icon(icon, size: _getIconSize());
      final spacing = SizedBox(width: _getIconSpacing());

      if (iconPosition == IconPosition.leading) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [iconWidget, spacing, Flexible(child: child)],
        );
      } else {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [Flexible(child: child), spacing, iconWidget],
        );
      }
    }

    return child;
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 32;
      case AppButtonSize.medium:
        return 40;
      case AppButtonSize.large:
        return 48;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 18;
      case AppButtonSize.large:
        return 20;
    }
  }

  double _getIconSpacing() {
    switch (size) {
      case AppButtonSize.small:
        return AppTheme.spaceXSmall;
      case AppButtonSize.medium:
        return AppTheme.spaceSmall;
      case AppButtonSize.large:
        return AppTheme.spaceSmall;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceSmall,
          vertical: AppTheme.spaceXSmall,
        );
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceMedium,
          vertical: AppTheme.spaceSmall,
        );
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceLarge,
          vertical: AppTheme.spaceMedium,
        );
    }
  }

  ButtonStyle _getElevatedButtonStyle(ThemeData theme, bool isEnabled) {
    return ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      disabledBackgroundColor: theme.disabledColor,
      disabledForegroundColor: theme.colorScheme.onSurface.withOpacity(0.38),
      padding: _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      elevation: AppTheme.elevationSmall,
    );
  }

  ButtonStyle _getSecondaryButtonStyle(ThemeData theme, bool isEnabled) {
    return ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.secondary,
      foregroundColor: theme.colorScheme.onSecondary,
      disabledBackgroundColor: theme.disabledColor,
      disabledForegroundColor: theme.colorScheme.onSurface.withOpacity(0.38),
      padding: _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      elevation: AppTheme.elevationSmall,
    );
  }

  ButtonStyle _getOutlinedButtonStyle(ThemeData theme, bool isEnabled) {
    return OutlinedButton.styleFrom(
      foregroundColor: theme.colorScheme.primary,
      disabledForegroundColor: theme.colorScheme.onSurface.withOpacity(0.38),
      side: BorderSide(
        color: isEnabled ? theme.colorScheme.primary : theme.disabledColor,
      ),
      padding: _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
    );
  }

  ButtonStyle _getTextButtonStyle(ThemeData theme, bool isEnabled) {
    return TextButton.styleFrom(
      foregroundColor: theme.colorScheme.primary,
      disabledForegroundColor: theme.colorScheme.onSurface.withOpacity(0.38),
      padding: _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
    );
  }

  ButtonStyle _getDangerButtonStyle(ThemeData theme, bool isEnabled) {
    return ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.error,
      foregroundColor: theme.colorScheme.onError,
      disabledBackgroundColor: theme.disabledColor,
      disabledForegroundColor: theme.colorScheme.onSurface.withOpacity(0.38),
      padding: _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      elevation: AppTheme.elevationSmall,
    );
  }
}

enum IconPosition {
  leading,
  trailing,
}