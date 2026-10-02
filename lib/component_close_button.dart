import 'dart:ui';

import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/shared/component_weighted_icon.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentCloseButton extends StatelessWidget {
  const ComponentCloseButton({
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.isBlurred = false,
    this.isInAppBar = false,
  });

  const ComponentCloseButton.blurred({
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
    this.isBlurred = true,
    this.isInAppBar = false,
  });

  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onTap;
  final bool isBlurred;
  final bool isInAppBar;

  static final stadiumBorderRadius = BorderRadius.circular(50);

  @override
  Widget build(BuildContext context) {
    if (isInAppBar) {
      if (isBlurred) {
        return Row(
          mainAxisSize: .min,
          mainAxisAlignment: .end,
          children: [
            const SizedBox(width: 6),
            _buildBlurEffect(context),
          ],
        );
      }

      return Row(
        mainAxisSize: .min,
        mainAxisAlignment: .end,
        children: [
          const SizedBox(width: 6),
          _buildCloseButton(context),
        ],
      );
    }

    if (isBlurred) {
      return _buildBlurEffect(context);
    }

    return _buildCloseButton(context);
  }

  Widget _buildCloseButton(BuildContext context) {
    return ComponentGestureClick(
      key: const ValueKey('modal-close'),
      semanticsLabel: 'Close',
      onTap: onTap ?? () => Navigator.pop(context),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color:
              backgroundColor ??
              (context.isLightMode
                  ? Colors.white.withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.1)),
          shape: BoxShape.circle,
        ),
        alignment: .center,
        child: ComponentWeightedIcon(
          icon: Icons.close_rounded,
          fontWeight: FontWeight.w700,
          fontSize: 24,
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
              sigmaX: 12,
              sigmaY: 12,
            ),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color:
                    backgroundColor ??
                    // context.primary.withValues(alpha: context.isDarkMode ? 0.12 : 0.10),
                    context.iconButtonBackgroundColor.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                size: 26,
                color: foregroundColor ?? context.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
