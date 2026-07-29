import 'package:flutter/widgets.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';

class ComponentPill extends StatelessWidget {
  const ComponentPill({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.gradient,
    this.icon,
  });

  final String text;
  final Function() onTap;
  final Color? color;

  /// Example:
  /// LinearGradient(
  ///   colors: [
  ///     ApotexColorPalette.brightBlue.withValues(alpha: 0.1),
  ///     ApotexColorPalette.brightBlue.withValues(alpha: 0.5),
  ///   ],
  ///   begin: Alignment.topLeft,
  ///   end: Alignment.bottomRight,
  /// ),
  final LinearGradient? gradient;

  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    Color baseColor = color ?? context.colorScheme.primary;
    Color backgroundColor = baseColor.withValues(alpha: 0.15);
    Color borderColor = baseColor.withValues(alpha: 0.5);

    return ComponentGestureClick(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: backgroundColor,
          gradient: gradient,
          shape: RoundedSuperellipseBorder(
            borderRadius: AppDecoration.borderRadiusStadium,
            side: BorderSide(
              color: borderColor,
              width: 1.5,
            ),
          ),
        ),
        child: Row(
          spacing: 12,
          mainAxisAlignment: .center,
          mainAxisSize: .min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                text,
                style: context.textTheme.labelLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ?icon,
          ],
        ),
      ),
    );
  }
}
