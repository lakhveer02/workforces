import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/report_models.dart';

class ChartCard extends StatelessWidget {
  final ChartData data;
  final double height;

  const ChartCard({
    super.key,
    required this.data,
    this.height = 250,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.yuzey,
        borderRadius: BorderRadius.circular(AppTheme.radius12),
        border: Border.all(color: AppTheme.structuralLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context),
          
          // Chart content
          Expanded(
            child: _buildChart(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      decoration: const BoxDecoration(
        color: AppTheme.panel,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radius12),
          topRight: Radius.circular(AppTheme.radius12),
        ),
        border: Border(
          bottom: BorderSide(color: AppTheme.structuralLine),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.primaryStart.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radius8),
            ),
            child: Icon(
              _getChartIcon(),
              color: AppTheme.primaryStart,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.buz,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.soluk,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    if (data.isEmpty) {
      return _buildEmptyState(context);
    }

    switch (data.type) {
      case ChartType.line:
        return _buildLineChart(context);
      case ChartType.bar:
        return _buildBarChart(context);
      case ChartType.pie:
        return _buildPieChart(context);
      case ChartType.area:
        return _buildAreaChart(context);
      case ChartType.donut:
        return _buildDonutChart(context);
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart_outlined,
            size: 48,
            color: AppTheme.soluk.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'No data available',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.soluk.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      child: CustomPaint(
        painter: LineChartPainter(
          dataPoints: data.dataPoints,
          maxValue: data.maxValue,
          minValue: data.minValue,
        ),
        child: Container(),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.dataPoints.map((point) {
                final maxValue = data.maxValue ?? data.dataPoints
                    .map((p) => p.value)
                    .reduce((a, b) => a > b ? a : b);
                
                final heightRatio = point.value / maxValue;
                
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Value label
                        Text(
                          point.value.toInt().toString(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.soluk,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 4),
                        
                        // Bar
                        Container(
                          height: (height - 120) * heightRatio,
                          decoration: BoxDecoration(
                            color: point.color != null
                                ? Color(int.parse(point.color!.replaceAll('#', '0xFF')))
                                : AppTheme.primaryStart,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Label
                        Text(
                          point.label,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.buz,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      child: Row(
        children: [
          // Pie chart
          Expanded(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(
                painter: PieChartPainter(
                  dataPoints: data.dataPoints,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: AppTheme.spaceMedium),
          
          // Legend
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: data.dataPoints.map((point) {
                final color = point.color != null
                    ? Color(int.parse(point.color!.replaceAll('#', '0xFF')))
                    : AppTheme.primaryStart;
                
                final percentage = (point.value / data.totalValue * 100);
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              point.label,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.buz,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.soluk,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaChart(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spaceMedium),
      child: CustomPaint(
        painter: AreaChartPainter(
          dataPoints: data.dataPoints,
          maxValue: data.maxValue,
          minValue: data.minValue,
        ),
        child: Container(),
      ),
    );
  }

  Widget _buildDonutChart(BuildContext context) {
    return _buildPieChart(context); // Similar to pie chart but with center hole
  }

  IconData _getChartIcon() {
    switch (data.type) {
      case ChartType.line:
        return Icons.show_chart;
      case ChartType.bar:
        return Icons.bar_chart;
      case ChartType.pie:
      case ChartType.donut:
        return Icons.pie_chart;
      case ChartType.area:
        return Icons.area_chart;
    }
  }
}

// Custom painters for charts
class LineChartPainter extends CustomPainter {
  final List<ChartDataPoint> dataPoints;
  final double? maxValue;
  final double? minValue;

  LineChartPainter({
    required this.dataPoints,
    this.maxValue,
    this.minValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final paint = Paint()
      ..color = AppTheme.primaryStart
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = AppTheme.primaryStart
      ..style = PaintingStyle.fill;

    final maxVal = maxValue ?? dataPoints.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    final minVal = minValue ?? dataPoints.map((p) => p.value).reduce((a, b) => a < b ? a : b);
    final range = maxVal - minVal;

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < dataPoints.length; i++) {
      final x = (i / (dataPoints.length - 1)) * size.width;
      final y = size.height - ((dataPoints[i].value - minVal) / range) * size.height;
      
      points.add(Offset(x, y));
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw points
    for (final point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PieChartPainter extends CustomPainter {
  final List<ChartDataPoint> dataPoints;

  PieChartPainter({required this.dataPoints});

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width < size.height ? size.width / 2 : size.height / 2;
    final totalValue = dataPoints.fold(0.0, (sum, point) => sum + point.value);

    double startAngle = -90 * (3.14159 / 180); // Start from top

    for (int i = 0; i < dataPoints.length; i++) {
      final point = dataPoints[i];
      final sweepAngle = (point.value / totalValue) * 2 * 3.14159;
      
      final paint = Paint()
        ..color = point.color != null
            ? Color(int.parse(point.color!.replaceAll('#', '0xFF')))
            : Color.lerp(AppTheme.primaryStart, AppTheme.primaryEnd, i / dataPoints.length)!
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 8),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AreaChartPainter extends CustomPainter {
  final List<ChartDataPoint> dataPoints;
  final double? maxValue;
  final double? minValue;

  AreaChartPainter({
    required this.dataPoints,
    this.maxValue,
    this.minValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final maxVal = maxValue ?? dataPoints.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    final minVal = minValue ?? dataPoints.map((p) => p.value).reduce((a, b) => a < b ? a : b);
    final range = maxVal - minVal;

    final path = Path();
    final gradientPath = Path();

    for (int i = 0; i < dataPoints.length; i++) {
      final x = (i / (dataPoints.length - 1)) * size.width;
      final y = size.height - ((dataPoints[i].value - minVal) / range) * size.height;
      
      if (i == 0) {
        path.moveTo(x, y);
        gradientPath.moveTo(x, size.height);
        gradientPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        gradientPath.lineTo(x, y);
      }
    }

    // Close the gradient path
    gradientPath.lineTo(size.width, size.height);
    gradientPath.close();

    // Draw gradient area
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppTheme.primaryStart.withValues(alpha: 0.3),
          AppTheme.primaryStart.withValues(alpha: 0.1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(gradientPath, gradientPaint);

    // Draw line
    final linePaint = Paint()
      ..color = AppTheme.primaryStart
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}