import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    required this.isLoading,
    required this.child,
    this.message,
    this.color,
    super.key,
  });

  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: LoadingIndicator(
                message: message,
                color: color,
              ),
            ),
          ),
      ],
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    this.message,
    this.color,
    this.size = 24.0,
    super.key,
  });

  final String? message;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLarge),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: color ?? theme.colorScheme.primary,
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppTheme.spaceMedium),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class AppShimmer extends StatefulWidget {
  const AppShimmer({
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
    super.key,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final bool enabled;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    ));

    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final baseColor = widget.baseColor ?? 
        (isDark ? Colors.grey[800]! : Colors.grey[300]!);
    final highlightColor = widget.highlightColor ?? 
        (isDark ? Colors.grey[700]! : Colors.grey[100]!);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                (_animation.value - 1).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 1).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius,
    super.key,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: borderRadius ?? 
              BorderRadius.circular(AppTheme.radiusMedium),
        ),
      ),
    );
  }
}

class ShimmerText extends StatelessWidget {
  const ShimmerText({
    this.width,
    this.height = 16,
    super.key,
  });

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      width: width ?? 100,
      height: height,
      borderRadius: BorderRadius.circular(height / 2),
    );
  }
}