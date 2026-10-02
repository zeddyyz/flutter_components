import 'dart:math' as math;

import 'package:flutter_components/components_context_extension.dart';
import 'package:material_ui/material_ui.dart';

/// A thin, iOS-style spinning activity indicator.
class ComponentActivityIndicator extends StatelessWidget {
  const ComponentActivityIndicator({
    super.key,
    this.size = 22,
    this.color,
    this.strokeWidth = 2.2,
  }) : assert(size > 0),
       assert(strokeWidth > 0);

  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return _ActivityIndicatorSpinner(
      size: size,
      color: color ?? context.primary,
      strokeWidth: strokeWidth,
    );
  }
}

class _ActivityIndicatorSpinner extends StatefulWidget {
  const _ActivityIndicatorSpinner({
    required this.size,
    required this.color,
    required this.strokeWidth,
  });

  final double size;
  final Color color;
  final double strokeWidth;

  @override
  State<_ActivityIndicatorSpinner> createState() => _ActivityIndicatorSpinnerState();
}

class _ActivityIndicatorSpinnerState extends State<_ActivityIndicatorSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox.square(
        dimension: widget.size,
        child: RotationTransition(
          turns: _controller,
          child: CustomPaint(
            painter: _ActivityIndicatorTickPainter(
              color: widget.color,
              strokeWidth: widget.strokeWidth,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityIndicatorTickPainter extends CustomPainter {
  const _ActivityIndicatorTickPainter({
    required this.color,
    required this.strokeWidth,
  });

  final Color color;
  final double strokeWidth;

  static const int _tickCount = 12;
  static const List<int> _tickAlphas = <int>[
    255,
    210,
    165,
    125,
    95,
    70,
    52,
    40,
    32,
    28,
    24,
    20,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = math.min(size.width, size.height) / 2;
    final double halfStroke = strokeWidth / 2;
    final RRect tick = RRect.fromLTRBXY(
      -halfStroke,
      -radius * 0.5,
      halfStroke,
      -radius,
      halfStroke,
      halfStroke,
    );
    final Paint paint = Paint()..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    for (int i = 0; i < _tickCount; i++) {
      paint.color = color.withAlpha(_tickAlphas[i]);
      canvas.drawRRect(tick, paint);
      canvas.rotate(math.pi * 2 / _tickCount);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ActivityIndicatorTickPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }

  @override
  bool shouldRebuildSemantics(_ActivityIndicatorTickPainter oldDelegate) => false;
}
