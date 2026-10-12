import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Modern button system inspired by Swiggy/Zomato design
class ModernButton extends StatelessWidget {
  const ModernButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = ModernButtonVariant.primary,
    this.size = ModernButtonSize.medium,
    this.isLoading = false,
    this.isExpanded = false,
    this.icon,
    this.iconPosition = IconPosition.leading,
    this.borderRadius,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final ModernButtonVariant variant;
  final ModernButtonSize size;
  final bool isLoading;
  final bool isExpanded;
  final IconData? icon;
  final IconPosition iconPosition;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final buttonSizeData = _getButtonSizeData(size);
    final buttonVariantData = _getButtonVariantData(variant, colors);

    Widget buttonChild = child;
    
    if (isLoading) {
      buttonChild = SizedBox(
        width: buttonSizeData.iconSize,
        height: buttonSizeData.iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: buttonVariantData.foregroundColor,
        ),
      );
    } else if (icon != null) {
      buttonChild = _buildButtonWithIcon(
        child: child,
        icon: icon!,
        iconPosition: iconPosition,
        iconSize: buttonSizeData.iconSize,
        spacing: buttonSizeData.iconSpacing,
      );
    }

    return SizedBox(
      width: isExpanded ? double.infinity : null,
      height: buttonSizeData.height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonVariantData.backgroundColor,
          foregroundColor: buttonVariantData.foregroundColor,
          disabledBackgroundColor: buttonVariantData.disabledBackgroundColor,
          disabledForegroundColor: buttonVariantData.disabledForegroundColor,
          elevation: buttonVariantData.elevation,
          shadowColor: buttonVariantData.shadowColor,
          padding: EdgeInsets.symmetric(
            horizontal: buttonSizeData.horizontalPadding,
            vertical: buttonSizeData.verticalPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? 
                BorderRadius.circular(buttonSizeData.borderRadius),
            side: buttonVariantData.borderSide,
          ),
          textStyle: TextStyle(
            fontSize: buttonSizeData.fontSize,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        child: buttonChild,
      ),
    );
  }

  Widget _buildButtonWithIcon({
    required Widget child,
    required IconData icon,
    required IconPosition iconPosition,
    required double iconSize,
    required double spacing,
  }) {
    final iconWidget = Icon(icon, size: iconSize);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: iconPosition == IconPosition.leading
          ? [iconWidget, SizedBox(width: spacing), Flexible(child: child)]
          : [Flexible(child: child), SizedBox(width: spacing), iconWidget],
    );
  }

  _ButtonSizeData _getButtonSizeData(ModernButtonSize size) {
    switch (size) {
      case ModernButtonSize.small:
        return _ButtonSizeData(
          height: 36,
          horizontalPadding: AppTheme.spaceMD,
          verticalPadding: AppTheme.spaceSM,
          fontSize: AppTheme.fontSM,
          iconSize: 16,
          iconSpacing: AppTheme.spaceXS,
          borderRadius: AppTheme.radiusSM,
        );
      case ModernButtonSize.medium:
        return _ButtonSizeData(
          height: 44,
          horizontalPadding: AppTheme.spaceXL,
          verticalPadding: AppTheme.spaceMD,
          fontSize: AppTheme.fontBase,
          iconSize: 18,
          iconSpacing: AppTheme.spaceSM,
          borderRadius: AppTheme.radiusMD,
        );
      case ModernButtonSize.large:
        return _ButtonSizeData(
          height: 52,
          horizontalPadding: AppTheme.space2XL,
          verticalPadding: AppTheme.spaceBase,
          fontSize: AppTheme.fontMD,
          iconSize: 20,
          iconSpacing: AppTheme.spaceSM,
          borderRadius: AppTheme.radiusLG,
        );
    }
  }

  _ButtonVariantData _getButtonVariantData(ModernButtonVariant variant, ThemeColors colors) {
    switch (variant) {
      case ModernButtonVariant.primary:
        return _ButtonVariantData(
          backgroundColor: colors.primary,
          foregroundColor: colors.textOnPrimary,
          disabledBackgroundColor: colors.border,
          disabledForegroundColor: colors.textTertiary,
          elevation: 2,
          shadowColor: colors.primary.withOpacity(0.3),
          borderSide: BorderSide.none,
        );
      case ModernButtonVariant.secondary:
        return _ButtonVariantData(
          backgroundColor: colors.cardSubtle,
          foregroundColor: colors.textPrimary,
          disabledBackgroundColor: colors.border,
          disabledForegroundColor: colors.textTertiary,
          elevation: 0,
          shadowColor: Colors.transparent,
          borderSide: BorderSide(color: colors.border),
        );
      case ModernButtonVariant.outline:
        return _ButtonVariantData(
          backgroundColor: Colors.transparent,
          foregroundColor: colors.primary,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: colors.textTertiary,
          elevation: 0,
          shadowColor: Colors.transparent,
          borderSide: BorderSide(color: colors.primary),
        );
      case ModernButtonVariant.ghost:
        return _ButtonVariantData(
          backgroundColor: Colors.transparent,
          foregroundColor: colors.textPrimary,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: colors.textTertiary,
          elevation: 0,
          shadowColor: Colors.transparent,
          borderSide: BorderSide.none,
        );
      case ModernButtonVariant.danger:
        return _ButtonVariantData(
          backgroundColor: colors.danger,
          foregroundColor: colors.textOnPrimary,
          disabledBackgroundColor: colors.border,
          disabledForegroundColor: colors.textTertiary,
          elevation: 2,
          shadowColor: colors.danger.withOpacity(0.3),
          borderSide: BorderSide.none,
        );
      case ModernButtonVariant.success:
        return _ButtonVariantData(
          backgroundColor: colors.success,
          foregroundColor: colors.textOnPrimary,
          disabledBackgroundColor: colors.border,
          disabledForegroundColor: colors.textTertiary,
          elevation: 2,
          shadowColor: colors.success.withOpacity(0.3),
          borderSide: BorderSide.none,
        );
    }
  }
}

/// Floating Action Button with modern design
class ModernFAB extends StatelessWidget {
  const ModernFAB({
    super.key,
    required this.onPressed,
    required this.icon,
    this.label,
    this.size = ModernFABSize.regular,
    this.variant = ModernFABVariant.primary,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String? label;
  final ModernFABSize size;
  final ModernFABVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fabSizeData = _getFABSizeData(size);
    final fabVariantData = _getFABVariantData(variant, colors);

    if (label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(icon, size: fabSizeData.iconSize),
        label: Text(
          label!,
          style: TextStyle(
            fontSize: fabSizeData.fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: fabVariantData.backgroundColor,
        foregroundColor: fabVariantData.foregroundColor,
        elevation: fabSizeData.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(fabSizeData.borderRadius),
        ),
      );
    }

    return SizedBox(
      width: fabSizeData.size,
      height: fabSizeData.size,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: fabVariantData.backgroundColor,
        foregroundColor: fabVariantData.foregroundColor,
        elevation: fabSizeData.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(fabSizeData.borderRadius),
        ),
        child: Icon(icon, size: fabSizeData.iconSize),
      ),
    );
  }

  _FABSizeData _getFABSizeData(ModernFABSize size) {
    switch (size) {
      case ModernFABSize.small:
        return _FABSizeData(
          size: 40,
          iconSize: 20,
          fontSize: AppTheme.fontSM,
          elevation: 4,
          borderRadius: AppTheme.radiusMD,
        );
      case ModernFABSize.regular:
        return _FABSizeData(
          size: 56,
          iconSize: 24,
          fontSize: AppTheme.fontBase,
          elevation: 6,
          borderRadius: AppTheme.radiusLG,
        );
      case ModernFABSize.large:
        return _FABSizeData(
          size: 72,
          iconSize: 28,
          fontSize: AppTheme.fontMD,
          elevation: 8,
          borderRadius: AppTheme.radiusXL,
        );
    }
  }

  _FABVariantData _getFABVariantData(ModernFABVariant variant, ThemeColors colors) {
    switch (variant) {
      case ModernFABVariant.primary:
        return _FABVariantData(
          backgroundColor: colors.primary,
          foregroundColor: colors.textOnPrimary,
        );
      case ModernFABVariant.secondary:
        return _FABVariantData(
          backgroundColor: colors.cardSubtle,
          foregroundColor: colors.textPrimary,
        );
    }
  }
}

/// Icon button with modern styling
class ModernIconButton extends StatelessWidget {
  const ModernIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = ModernIconButtonSize.medium,
    this.variant = ModernIconButtonVariant.ghost,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final ModernIconButtonSize size;
  final ModernIconButtonVariant variant;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final sizeData = _getIconButtonSizeData(size);
    final variantData = _getIconButtonVariantData(variant, colors);

    Widget button = Container(
      width: sizeData.size,
      height: sizeData.size,
      decoration: BoxDecoration(
        color: variantData.backgroundColor,
        borderRadius: BorderRadius.circular(sizeData.borderRadius),
        border: variantData.borderSide != BorderSide.none 
            ? Border.all(
                color: variantData.borderSide.color,
                width: variantData.borderSide.width,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(sizeData.borderRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(sizeData.borderRadius),
          child: Icon(
            icon,
            size: sizeData.iconSize,
            color: variantData.foregroundColor,
          ),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }

  _IconButtonSizeData _getIconButtonSizeData(ModernIconButtonSize size) {
    switch (size) {
      case ModernIconButtonSize.small:
        return _IconButtonSizeData(
          size: 32,
          iconSize: 16,
          borderRadius: AppTheme.radiusSM,
        );
      case ModernIconButtonSize.medium:
        return _IconButtonSizeData(
          size: 40,
          iconSize: 20,
          borderRadius: AppTheme.radiusMD,
        );
      case ModernIconButtonSize.large:
        return _IconButtonSizeData(
          size: 48,
          iconSize: 24,
          borderRadius: AppTheme.radiusLG,
        );
    }
  }

  _IconButtonVariantData _getIconButtonVariantData(
    ModernIconButtonVariant variant, 
    ThemeColors colors,
  ) {
    switch (variant) {
      case ModernIconButtonVariant.filled:
        return _IconButtonVariantData(
          backgroundColor: colors.primary,
          foregroundColor: colors.textOnPrimary,
          borderSide: BorderSide.none,
        );
      case ModernIconButtonVariant.outline:
        return _IconButtonVariantData(
          backgroundColor: Colors.transparent,
          foregroundColor: colors.primary,
          borderSide: BorderSide(color: colors.border),
        );
      case ModernIconButtonVariant.ghost:
        return _IconButtonVariantData(
          backgroundColor: Colors.transparent,
          foregroundColor: colors.textSecondary,
          borderSide: BorderSide.none,
        );
    }
  }
}

// Enums and Data Classes

enum ModernButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  danger,
  success,
}

enum ModernButtonSize {
  small,
  medium,
  large,
}

enum ModernFABVariant {
  primary,
  secondary,
}

enum ModernFABSize {
  small,
  regular,
  large,
}

enum ModernIconButtonVariant {
  filled,
  outline,
  ghost,
}

enum ModernIconButtonSize {
  small,
  medium,
  large,
}

enum IconPosition {
  leading,
  trailing,
}

class _ButtonSizeData {
  final double height;
  final double horizontalPadding;
  final double verticalPadding;
  final double fontSize;
  final double iconSize;
  final double iconSpacing;
  final double borderRadius;

  _ButtonSizeData({
    required this.height,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.fontSize,
    required this.iconSize,
    required this.iconSpacing,
    required this.borderRadius,
  });
}

class _ButtonVariantData {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color disabledBackgroundColor;
  final Color disabledForegroundColor;
  final double elevation;
  final Color shadowColor;
  final BorderSide borderSide;

  _ButtonVariantData({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.disabledBackgroundColor,
    required this.disabledForegroundColor,
    required this.elevation,
    required this.shadowColor,
    required this.borderSide,
  });
}

class _FABSizeData {
  final double size;
  final double iconSize;
  final double fontSize;
  final double elevation;
  final double borderRadius;

  _FABSizeData({
    required this.size,
    required this.iconSize,
    required this.fontSize,
    required this.elevation,
    required this.borderRadius,
  });
}

class _FABVariantData {
  final Color backgroundColor;
  final Color foregroundColor;

  _FABVariantData({
    required this.backgroundColor,
    required this.foregroundColor,
  });
}

class _IconButtonSizeData {
  final double size;
  final double iconSize;
  final double borderRadius;

  _IconButtonSizeData({
    required this.size,
    required this.iconSize,
    required this.borderRadius,
  });
}

class _IconButtonVariantData {
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderSide borderSide;

  _IconButtonVariantData({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderSide,
  });
}