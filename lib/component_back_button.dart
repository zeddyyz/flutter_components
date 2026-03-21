import 'package:flutter/material.dart';
import 'package:flutter_components/shared/gesture_click.dart';

class ModernBackButton extends StatelessWidget {
  const ModernBackButton({
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
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;

    return GestureClick(
      onTap: onTap ?? () => Navigator.pop(context),
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: color ?? (isLightTheme ? Colors.grey.shade200 : Colors.grey.shade900),
            borderRadius: BorderRadius.circular(50),
          ),
          width: 38,
          height: 38,
          margin: const EdgeInsets.only(left: 4),
          alignment: Alignment.center,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
            color: iconColor ?? (isLightTheme ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }
}
