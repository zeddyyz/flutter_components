import 'dart:math' as math;

import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

const Duration _kProgressAnimationDuration = Duration(milliseconds: 280);
const Curve _kProgressAnimationCurve = Curves.easeOutCubic;

class ComponentProgressBar extends StatelessWidget {
  const ComponentProgressBar({
    super.key,
    required this.value,
    this.color,
    this.backgroundColor,
    this.height = 6,
  }) : assert(value >= 0 && value <= 1, 'value must be between 0 and 1');

  final double value;
  final Color? color;
  final Color? backgroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRSuperellipse(
      borderRadius: AppDecoration.borderRadiusStadium,
      child: SizedBox(
        height: height,
        child: Stack(
          fit: .expand,
          children: [
            ColoredBox(color: backgroundColor ?? context.componentTheme.chipColor),
            AnimatedFractionallySizedBox(
              duration: _kProgressAnimationDuration,
              curve: _kProgressAnimationCurve,
              alignment: .centerLeft,
              widthFactor: value,
              child: ColoredBox(color: color ?? Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}

class ComponentProgressRing extends StatelessWidget {
  const ComponentProgressRing({
    super.key,
    required this.value,
    this.size = 48,
    this.strokeWidth = 4,
    this.color,
    this.backgroundColor,
    this.child,
  }) : assert(value >= 0 && value <= 1, 'value must be between 0 and 1');

  final double value;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: value),
        duration: _kProgressAnimationDuration,
        curve: _kProgressAnimationCurve,
        builder: (BuildContext context, double animatedValue, Widget? child) {
          return RepaintBoundary(
            child: CustomPaint(
              painter: _RingPainter(
                value: animatedValue,
                strokeWidth: strokeWidth,
                color: color ?? Theme.of(context).primaryColor,
                backgroundColor: backgroundColor ?? context.componentTheme.chipColor,
              ),
              child: child,
            ),
          );
        },
        child: child == null ? null : Center(child: child),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.value,
    required this.strokeWidth,
    required this.color,
    required this.backgroundColor,
  });

  final double value;
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Paint background = Paint()
      ..color = backgroundColor
      ..style = .stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = .round;

    final Paint foreground = Paint()
      ..color = color
      ..style = .stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = .round;

    canvas.drawArc(rect, 0, math.pi * 2, false, background);
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * value, false, foreground);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
