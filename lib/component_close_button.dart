import 'dart:ui';

import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

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
    if (isBlurred) {
      return _buildBlurEffect(context);
    }

    return ComponentGestureClick(
      key: const ValueKey('modal-close'),
      semanticsLabel: 'Close',
      onTap: onTap ?? () => Navigator.pop(context),
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          color:
              bgColor ??
              (context.isLightMode
                  ? Colors.white.withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.1)),
          shape: BoxShape.circle,
          borderRadius: stadiumBorderRadius,
        ),
        child: Icon(
          Icons.close_rounded,
          size: 24,
          color: iconColor ?? (context.primary.withValues(alpha: 0.8)),
        ),
      ),
    );
  }

  Widget _buildBlurEffect(BuildContext context) {
    return ComponentGestureClick(
      key: const ValueKey('modal-close'),
      semanticsLabel: 'Close',
      onTap: onTap ?? () => Navigator.pop(context),
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: AppDecoration.borderRadiusStadium,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 8,
              sigmaY: 8,
            ),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color:
                    bgColor ?? context.primary.withValues(alpha: context.isDarkMode ? 0.12 : 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                size: 26,
                color: iconColor ?? context.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
