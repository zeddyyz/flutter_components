import 'package:flutter/material.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';

class ComponentCard extends StatelessWidget {
  const ComponentCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.isInSheet = false,
    this.displayBorder = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final bool isInSheet;
  final bool displayBorder;

  @override
  Widget build(BuildContext context) {
    return ComponentGestureClick(
      onTap: onTap ?? () {},
      child: Container(
        padding: padding ?? EdgeInsets.all(context.defaultPadding),
        decoration: ShapeDecoration(
          color: isInSheet ? context.bottomSheetCardColor : context.cardColor,
          shape: RoundedSuperellipseBorder(
            borderRadius: AppDecoration.borderRadiusCard,
            side: displayBorder
                ? BorderSide(color: isInSheet ? context.borderColorIntense : context.borderColor)
                : BorderSide.none,
          ),
        ),
        child: child,
      ),
    );
  }
}
