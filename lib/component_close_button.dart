import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';

class ComponentCloseButton extends StatelessWidget {
  const ComponentCloseButton({
    super.key,
    this.bgColor,
    this.iconColor,
    this.onTap,
    this.isBlurred = false,
  });

  const ComponentCloseButton.blurred({
    super.key,
    this.bgColor,
    this.iconColor,
    this.onTap,
    this.isBlurred = true,
  });

  final Color? bgColor;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool isBlurred;

  static final stadiumBorderRadius = BorderRadius.circular(50);

  @override
  Widget build(BuildContext context) {
    final viewWidth = MediaQuery.sizeOf(context).width;
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    bool largeScreen = kIsWeb || (viewWidth > 920 && viewWidth <= 1200);

    if (isBlurred) {
      return _buildBlurEffect(context, isLightTheme: isLightTheme);
    }

    return ComponentGestureClick(
      onTap: onTap ?? () => Navigator.pop(context),
      child: Container(
        height: 34,
        width: !largeScreen ? 34 : 80,
        decoration: BoxDecoration(
          color: bgColor ?? (isLightTheme ? Colors.grey.shade200 : Colors.grey.shade900),
          shape: !largeScreen ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: !largeScreen ? null : stadiumBorderRadius,
        ),
        child: !largeScreen
            ? Icon(
                Icons.close_rounded,
                size: 22,
                color: iconColor ?? (isLightTheme ? Colors.black : Colors.white),
              )
            : Row(
                spacing: 8,
                mainAxisAlignment: .center,
                children: [
                  Icon(
                    Icons.close_rounded,
                    size: 22,
                    color: iconColor ?? (isLightTheme ? Colors.black : Colors.white),
                  ),
                  Text(
                    'Close',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildBlurEffect(BuildContext context, {required bool isLightTheme}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap ?? () => Navigator.pop(context),
        child: ClipRRect(
          borderRadius: stadiumBorderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ),
            child: Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color:
                    bgColor?.withValues(alpha: 0.1) ??
                    (isLightTheme
                        ? Colors.grey.shade200
                        : Colors.grey.shade900.withValues(alpha: 0.1)),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                size: 22,
                color: iconColor ?? (isLightTheme ? Colors.black : Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
