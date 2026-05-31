import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_components/components_context_extension.dart';

/// Set both:
///
/// [body: navigationShell]
///
/// [extendBody: true] in the scaffold to allow the bottom nav bar to be extended beyond the bottom of the screen.
class ComponentBottomNavBar extends StatelessWidget {
  const ComponentBottomNavBar({
    super.key,
    required this.childrenLeftAligned,
    this.childrenRightAligned,
    this.navbarBlurSigma = 20,
    this.isBackgroundFaded = false,
    this.backgroundFadeHeight,
    this.backgroundFadeBlur = 3,
    this.backgroundFadeSize = 10,
  });

  final List<Widget> childrenLeftAligned;
  final List<Widget>? childrenRightAligned;
  final double navbarBlurSigma;

  final bool isBackgroundFaded;
  final double? backgroundFadeHeight;
  final double backgroundFadeBlur;
  final double backgroundFadeSize;

  @override
  Widget build(BuildContext context) {
    if (isBackgroundFaded) {
      return Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: backgroundFadeHeight ?? context.mediaQueryPadding.bottom + 50,
            child: IgnorePointer(
              child: RepaintBoundary(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: backgroundFadeBlur,
                      sigmaY: backgroundFadeBlur,
                    ),
                    child: Stack(
                      children: [
                        // Fades the alpha of the backdrop blur at the top
                        // edge so the blur ramps in smoothly instead of
                        // ending in a hard line. The bottom edge stays at
                        // full blur since the mask rect extends past it.
                        // See: https://gist.github.com/flar/e6258443da95ae0815a593959f5a701b
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _TopEdgeFadeMaskPainter(fadeSize: backgroundFadeSize),
                          ),
                        ),
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  context.scaffoldBackgroundColor.withValues(alpha: 0.0),
                                  context.scaffoldBackgroundColor,
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
          _buildNavbar(context),
        ],
      );
    }

    return _buildNavbar(context);
  }

  Container _buildNavbar(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.only(left: 12, right: 12, bottom: 0),
      margin: EdgeInsets.only(bottom: 40),
      child: Row(
        children: [
          Container(
            decoration: ShapeDecoration(
              color: context.cardColor.withValues(alpha: context.isLightMode ? 0.1 : 0.5),
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.circular(40),
                side: BorderSide(
                  color: context.primary.withValues(alpha: 0.1),
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
              ),
            ),
            child: ClipRSuperellipse(
              borderRadius: BorderRadius.circular(40),
              child: RepaintBoundary(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: navbarBlurSigma, sigmaY: navbarBlurSigma),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 4,
                      children: childrenLeftAligned,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (childrenRightAligned != null) ...[
            Spacer(),
            Container(
              decoration: ShapeDecoration(
                color: context.cardColor.withValues(alpha: context.isLightMode ? 0.1 : 0.5),
                shape: RoundedSuperellipseBorder(
                  borderRadius: BorderRadius.circular(40),
                  side: BorderSide(
                    color: context.primary.withValues(alpha: 0.1),
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
              ),
              child: ClipRSuperellipse(
                borderRadius: BorderRadius.circular(40),
                child: RepaintBoundary(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: navbarBlurSigma, sigmaY: navbarBlurSigma),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: childrenRightAligned!,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Masks the alpha of a [BackdropFilter]'s blur so its top edge fades in
/// smoothly. Drawn with [BlendMode.dstIn] inside the filter's child, the
/// blurred rect ([TileMode.decal]) keeps the backdrop blur only where the
/// mask has alpha, producing a soft ramp instead of a hard cutoff line.
///
/// The rect is inset by [fadeSize] at the top (the visible ramp) and extended
/// past the bottom so the bottom edge remains at full blur.
class _TopEdgeFadeMaskPainter extends CustomPainter {
  const _TopEdgeFadeMaskPainter({required this.fadeSize});

  final double fadeSize;

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

    final Rect rect = Rect.fromLTRB(
      0,
      fadeSize,
      size.width,
      size.height + fadeSize,
    );
    canvas.drawRect(rect, maskPaint);
  }

  @override
  bool shouldRepaint(covariant _TopEdgeFadeMaskPainter oldDelegate) =>
      oldDelegate.fadeSize != fadeSize;
}
