import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AppLoadingSkeleton extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? period;

  const AppLoadingSkeleton({
    super.key,
    required this.child,
    this.isLoading = true,
    this.baseColor,
    this.highlightColor,
    this.period,
  });

  @override
  State<AppLoadingSkeleton> createState() => _AppLoadingSkeletonState();
}

class _AppLoadingSkeletonState extends State<AppLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.period ?? const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    final baseColor = widget.baseColor ?? AppTheme.yuzey;
    final highlightColor = widget.highlightColor ?? 
        AppTheme.structuralLine.withOpacity(0.3);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + _animation.value, 0.0),
              end: Alignment(1.0 + _animation.value, 0.0),
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

// Predefined skeleton widgets for common use cases
class SkeletonContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const SkeletonContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusSmall),
      ),
    );
  }
}

class SkeletonText extends StatelessWidget {
  final double? width;
  final double height;
  final int lines;

  const SkeletonText({
    super.key,
    this.width,
    this.height = 16,
    this.lines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        final isLastLine = index == lines - 1;
        final lineWidth = isLastLine && lines > 1 
            ? (width ?? 200) * 0.7 
            : width;
            
        return Padding(
          padding: index > 0 ? const EdgeInsets.only(top: 8) : EdgeInsets.zero,
          child: SkeletonContainer(
            width: lineWidth,
            height: height,
            borderRadius: BorderRadius.circular(height / 2),
          ),
        );
      }),
    );
  }
}

class SkeletonAvatar extends StatelessWidget {
  final double radius;

  const SkeletonAvatar({
    super.key,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      width: radius * 2,
      height: radius * 2,
      borderRadius: BorderRadius.circular(radius),
    );
  }
}

// Complex skeleton layouts
class EmployeeCardSkeleton extends StatelessWidget {
  const EmployeeCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLoadingSkeleton(
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const SkeletonAvatar(radius: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonText(width: 120, height: 18),
                        const SizedBox(height: 4),
                        SkeletonText(width: 90, height: 14),
                      ],
                    ),
                  ),
                  SkeletonContainer(width: 60, height: 24),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Info rows
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonText(width: 80, height: 12),
                        const SizedBox(height: 4),
                        SkeletonText(width: 100, height: 14),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonText(width: 70, height: 12),
                        const SizedBox(height: 4),
                        SkeletonText(width: 90, height: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardCardSkeleton extends StatelessWidget {
  const DashboardCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLoadingSkeleton(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SkeletonContainer(width: 40, height: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonText(width: 80, height: 14),
                        const SizedBox(height: 4),
                        SkeletonText(width: 120, height: 20),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SkeletonText(width: double.infinity, height: 12),
              const SizedBox(height: 8),
              SkeletonText(width: 160, height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskCardSkeleton extends StatelessWidget {
  const TaskCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLoadingSkeleton(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SkeletonContainer(width: 12, height: 12),
                  const SizedBox(width: 8),
                  Expanded(child: SkeletonText(width: 100, height: 16)),
                ],
              ),
              const SizedBox(height: 12),
              SkeletonText(width: double.infinity, height: 12, lines: 2),
              const SizedBox(height: 12),
              Row(
                children: [
                  const SkeletonAvatar(radius: 12),
                  const SizedBox(width: 8),
                  SkeletonText(width: 60, height: 12),
                  const Spacer(),
                  SkeletonContainer(width: 50, height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PayslipCardSkeleton extends StatelessWidget {
  const PayslipCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLoadingSkeleton(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SkeletonContainer(width: 48, height: 48),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonText(width: 100, height: 16),
                    const SizedBox(height: 4),
                    SkeletonText(width: 80, height: 14),
                    const SizedBox(height: 4),
                    SkeletonText(width: 120, height: 14),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SkeletonText(width: 60, height: 14),
                  const SizedBox(height: 8),
                  SkeletonContainer(width: 80, height: 32),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}