import 'package:flutter/material.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';

class ComponentBackButton extends StatelessWidget {
  const ComponentBackButton({
    super.key,
    this.onTap,
    this.color,
    this.iconColor,
  });

  final Function()? onTap;
  final Color? color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return ComponentGestureClick(
      onTap: onTap ?? () => Navigator.pop(context),
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            // color: color ?? (isLightTheme ? Colors.grey.shade200 : Colors.grey.shade900),
            color:
                color ??
                (context.isLightMode
                    ? Colors.white.withValues(alpha: 0.8)
                    : Colors.white.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(50),
          ),
          width: 38,
          height: 38,
          margin: const EdgeInsets.only(left: 4),
          alignment: Alignment.center,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
            color: iconColor ?? (context.isLightMode ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }
}
