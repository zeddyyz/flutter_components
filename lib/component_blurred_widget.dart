import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_components/shared/fade_mask_painter.dart';

/// Wraps any [child] with a gradual backdrop blur that soft-fades at one edge.
///
/// The blur layer is decorative only ([IgnorePointer]) so hits pass through to
/// [child]. The blur extends past the child by [overflowExtent] on the faded
/// edge so the soft ramp is not clipped by the child's bounds.
///
/// When [fadeTopEdge] is `true`, blur ramps in from the top edge downward
/// (bottom-nav style). When `false`, blur ramps out toward the bottom edge
/// (app-bar style).
class ComponentBlurredWidget extends StatelessWidget {
  const ComponentBlurredWidget({
    super.key,
    required this.child,
    this.fadeTopEdge = true,
    this.blurSigma = 3,
    this.fadeSize = 10,
    this.overflowExtent = 12,
    this.tintColor,
  });

  final Widget child;

  /// When `true`, fade from the top edge downward. When `false`, fade from the
  /// bottom edge upward.
  final bool fadeTopEdge;

  /// Backdrop blur intensity.
  final double blurSigma;

  /// Softness of the fade ramp at the faded edge. Passed to [FadeMaskPainter].
  final double fadeSize;

  /// How far the blur extends past the child on the faded edge.
  final double overflowExtent;

  /// Optional tint drawn over the blur, fading with the same edge as the blur.
  final Color? tintColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: fadeTopEdge ? -overflowExtent : 0,
          bottom: fadeTopEdge ? 0 : -overflowExtent,
          child: IgnorePointer(
            child: RepaintBoundary(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blurSigma,
                    sigmaY: blurSigma,
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: FadeMaskPainter(
                            fadeSize: fadeSize,
                            isTopEdge: fadeTopEdge,
                          ),
                        ),
                      ),
                      if (tintColor != null)
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: fadeTopEdge
                                    ? [
                                        tintColor!.withValues(alpha: 0.0),
                                        tintColor!,
                                      ]
                                    : [
                                        tintColor!,
                                        tintColor!.withValues(alpha: 0.0),
                                      ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
