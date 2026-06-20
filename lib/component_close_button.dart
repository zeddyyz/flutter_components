import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';

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
    bool largeScreen = kIsWeb || (viewWidth > 920 && viewWidth <= 1200);

    if (isBlurred) {
      return _buildBlurEffect(context);
    }

    return ComponentGestureClick(
      onTap: onTap ?? () => Navigator.pop(context),
      child: Container(
        height: 38,
        width: !largeScreen ? 38 : 86,
        decoration: BoxDecoration(
          color:
              bgColor ??
              (context.isLightMode
                  ? Colors.white.withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.1)),
          shape: !largeScreen ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: !largeScreen ? null : stadiumBorderRadius,
        ),
        child: !largeScreen
            ? Icon(
                Icons.close_rounded,
                size: 24,
                color: iconColor ?? (context.primary.withValues(alpha: 0.8)),
              )
            : Row(
                spacing: 8,
                mainAxisAlignment: .center,
                children: [
                  Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: iconColor ?? (context.primary.withValues(alpha: 0.8)),
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

  Widget _buildBlurEffect(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap ?? () => Navigator.pop(context),
        child: RepaintBoundary(
          child: ClipRRect(
            borderRadius: AppDecoration.borderRadiusStadium,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color:
                      bgColor?.withValues(alpha: 0.5) ??
                      context.iconButtonBackgroundColor.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.isLightMode ? context.borderColorIntense : context.borderColor,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 24,
                  color: iconColor ?? context.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
