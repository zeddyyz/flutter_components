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
    this.blurSigma = 20,
  });

  final List<Widget> childrenLeftAligned;
  final List<Widget>? childrenRightAligned;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
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
                  filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
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
                    filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
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
