import 'dart:ui';

import 'package:flutter/material.dart';

/// Masks the alpha of a [BackdropFilter]'s blur so its top edge fades in
/// smoothly. Drawn with [BlendMode.dstIn] inside the filter's child, the
/// blurred rect ([TileMode.decal]) keeps the backdrop blur only where the
/// mask has alpha, producing a soft ramp instead of a hard cutoff line.
///
/// The rect is inset by [fadeSize] at the top (the visible ramp) and extended
/// past the bottom so the bottom edge remains at full blur.
///
/// The [isTopEdge] is for bottom navbars, where the fade is at the top edge. For other use cases, it can be set to false to fade the bottom edge instead.
class FadeMaskPainter extends CustomPainter {
  const FadeMaskPainter({
    required this.fadeSize,
    this.isTopEdge = true,
  });

  final double fadeSize;
  final bool isTopEdge;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint maskPaint = Paint()
      ..imageFilter = ImageFilter.blur(
        sigmaX: fadeSize,
        sigmaY: fadeSize,
        tileMode: TileMode.decal,
      )
      ..blendMode = BlendMode.dstIn
      // Only the alpha channel is used by dstIn; the color is irrelevant.
      ..color = const Color(0xFF000000);

    final Rect rect = isTopEdge
        ? Rect.fromLTRB(
            0,
            fadeSize,
            size.width,
            size.height + fadeSize,
          )
        : Rect.fromLTRB(
            0,
            -fadeSize,
            size.width,
            size.height - fadeSize - 6,
          );
    canvas.drawRect(rect, maskPaint);
  }

  @override
  bool shouldRepaint(covariant FadeMaskPainter oldDelegate) => oldDelegate.fadeSize != fadeSize;
}
