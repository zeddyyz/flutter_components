import 'package:material_ui/material_ui.dart';
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
            color: color ?? context.borderColor,
            borderRadius: BorderRadius.circular(50),
          ),
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(left: 4),
          alignment: Alignment.center,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 22,
            color: iconColor ?? context.primary,
          ),
        ),
      ),
    );
  }
}
