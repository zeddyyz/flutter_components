import 'dart:ui';

import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/shared/component_weighted_icon.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentBackButton extends StatelessWidget {
  const ComponentBackButton({
    super.key,
    this.onTap,
    this.color,
    this.iconColor,
  }) : isBlurred = false;

  const ComponentBackButton.blurred({
    super.key,
    this.onTap,
    this.color,
    this.iconColor,
  }) : isBlurred = true;

  final Function()? onTap;
  final Color? color;
  final Color? iconColor;
  final bool isBlurred;

  @override
  Widget build(BuildContext context) {
    return isBlurred == true ? _buildBackButtonBlurred(context) : _buildBackButton(context);
  }

  Widget _buildBackButtonBlurred(BuildContext context) {
    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: AppDecoration.borderRadiusStadium,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 8,
            sigmaY: 8,
          ),
          child: _buildBackButton(context),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return ComponentGestureClick(
      key: const ValueKey('app-bar-back'),
      semanticsLabel: 'Back',
      onTap: onTap ?? () => Navigator.pop(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? context.primary.withValues(alpha: context.isDarkMode ? 0.12 : 0.10),
          shape: BoxShape.circle,
        ),
        width: 40,
        height: 40,
        alignment: .center,
        child: ComponentWeightedIcon(
          icon: Icons.arrow_back_ios_new_rounded,
          fontWeight: FontWeight.bold,
          fontSize: 22,
          foregroundColor: iconColor ?? context.primary,
        ),
      ),
    );
  }
}
