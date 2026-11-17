import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

enum AppButtonType {
  primary,
  secondary,
  outline,
  outlined,
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
    this.child,
    this.text,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.isEnabled = true,
    this.icon,
    this.iconPosition = IconPosition.leading,
    super.key,
  }) : assert(child != null || text != null, 'Provide child or text');

  const AppButton.primary({
    required this.onPressed,
    this.child,
    this.text,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.isEnabled = true,
    this.icon,
    this.iconPosition = IconPosition.leading,
    super.key,
  })  : type = AppButtonType.primary,
        assert(child != null || text != null, 'Provide child or text');

  const AppButton.secondary({
    required this.onPressed,
    this.child,
    this.text,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.isEnabled = true,
    this.icon,
    this.iconPosition = IconPosition.leading,
    super.key,
  })  : type = AppButtonType.secondary,
        assert(child != null || text != null, 'Provide child or text');

  const AppButton.outline({
    required this.onPressed,
    this.child,
    this.text,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.isEnabled = true,
    this.icon,
    this.iconPosition = IconPosition.leading,
    super.key,
  })  : type = AppButtonType.outline,
        assert(child != null || text != null, 'Provide child or text');

  const AppButton.text({
    required this.onPressed,
    this.child,
    this.text,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.isEnabled = true,
    this.icon,
    this.iconPosition = IconPosition.leading,
    super.key,
  })  : type = AppButtonType.text,
        assert(child != null || text != null, 'Provide child or text');

  const AppButton.danger({
    required this.onPressed,
    this.child,
    this.text,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.isEnabled = true,
    this.icon,
    this.iconPosition = IconPosition.leading,
    super.key,
  })  : type = AppButtonType.danger,
        assert(child != null || text != null, 'Provide child or text');

  final VoidCallback? onPressed;
  final Widget? child;
  final String? text;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final bool isEnabled;
  final IconData? icon;
  final IconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = isEnabled && onPressed != null && !isLoading;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _getHeight(),
      child: _buildButton(theme, enabled),
    );
  }

  Widget _buildButton(ThemeData theme, bool isEnabled) {
    final buttonChild = _buildButtonChild(theme);

    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: _getElevatedButtonStyle(theme),
          child: buttonChild,
        );

      case AppButtonType.secondary:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: _getSecondaryButtonStyle(theme),
          child: buttonChild,
        );

      case AppButtonType.outline:
      case AppButtonType.outlined:
        return OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: _getOutlinedButtonStyle(theme, isEnabled),
          child: buttonChild,
        );

      case AppButtonType.text:
        return TextButton(
          onPressed: isEnabled ? onPressed : null,
          style: _getTextButtonStyle(theme),
          child: buttonChild,
        );

      case AppButtonType.danger:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: _getDangerButtonStyle(theme),
          child: buttonChild,
        );
    }
  }

  Widget _buildButtonChild(ThemeData theme) {
    if (isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == AppButtonType.primary || type == AppButtonType.danger
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.primary,
          ),
        ),
      );
    }

    final label = child ?? Text(text ?? '');

    if (icon != null) {
      final iconWidget = Icon(icon, size: _getIconSize());
      final spacing = SizedBox(width: _getIconSpacing());

      if (iconPosition == IconPosition.leading) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [iconWidget, spacing, Flexible(child: label)],
        );
      }
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [Flexible(child: label), spacing, iconWidget],
      );
    }

    return label;
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
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
          horizontal: AppTheme.spaceLarge,
          vertical: AppTheme.spaceSmall,
        );
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceXLarge,
          vertical: AppTheme.spaceMedium,
        );
    }
  }

  ButtonStyle _getElevatedButtonStyle(ThemeData theme) {
    return ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      disabledBackgroundColor: theme.disabledColor.withValues(alpha: 0.12),
      disabledForegroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.38),
      padding: _getPadding(),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
      ),
    );
  }

  ButtonStyle _getSecondaryButtonStyle(ThemeData theme) {
    return ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
      foregroundColor: theme.colorScheme.primary,
      disabledBackgroundColor: theme.disabledColor.withValues(alpha: 0.12),
      disabledForegroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.38),
      padding: _getPadding(),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
      ),
    );
  }

  ButtonStyle _getOutlinedButtonStyle(ThemeData theme, bool isEnabled) {
    return OutlinedButton.styleFrom(
      foregroundColor: theme.colorScheme.primary,
      disabledForegroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.38),
      side: BorderSide(
        color: isEnabled
            ? theme.colorScheme.outline
            : theme.disabledColor,
      ),
      padding: _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
      ),
    );
  }

  ButtonStyle _getTextButtonStyle(ThemeData theme) {
    return TextButton.styleFrom(
      foregroundColor: theme.colorScheme.primary,
      disabledForegroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.38),
      padding: _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
      ),
    );
  }

  ButtonStyle _getDangerButtonStyle(ThemeData theme) {
    return ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.error,
      foregroundColor: theme.colorScheme.onError,
      disabledBackgroundColor: theme.disabledColor.withValues(alpha: 0.12),
      disabledForegroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.38),
      padding: _getPadding(),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
      ),
    );
  }
}

enum IconPosition {
  leading,
  trailing,
}
