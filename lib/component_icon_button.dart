import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentIconButton extends StatelessWidget {
  const ComponentIconButton({
    super.key,
    required this.icon,
    this.label,
    required this.onPressed,
    this.isFilled = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  final Widget icon;
  final Widget? label;
  final bool isFilled;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return IconButton(
        onPressed: onPressed,
        icon: icon,
        style: IconButton.styleFrom(
          backgroundColor: isFilled ? backgroundColor ?? context.iconButtonBackgroundColor : null,
          foregroundColor: isFilled ? foregroundColor ?? context.primary : null,
          shape: RoundedRectangleBorder(
            borderRadius: AppDecoration.borderRadiusStadium,
          ),
          elevation: 0,
          splashFactory: NoSplash.splashFactory,
          enabledMouseCursor: SystemMouseCursors.click,
        ),
      );
    }

    return TextButton.icon(
      onPressed: onPressed,
      label: label!,
      icon: icon,
      style: TextButton.styleFrom(
        backgroundColor: isFilled ? backgroundColor ?? context.iconButtonBackgroundColor : null,
        foregroundColor: isFilled ? foregroundColor ?? context.primary : null,
        shape: RoundedSuperellipseBorder(
          borderRadius: AppDecoration.borderRadiusStadium,
        ),
        elevation: 0,
        splashFactory: NoSplash.splashFactory,
        enabledMouseCursor: SystemMouseCursors.click,
        fixedSize: const Size(double.infinity, 40),
        padding: EdgeInsets.only(
          left: 12,
          top: 12,
          bottom: 12,
          right: 18,
        ),
      ),
    );
  }
}
