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
    this.isLoading = false,
  });

  final Widget icon;
  final Widget? label;
  final bool isFilled;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final Color indicatorColor = foregroundColor ?? context.primary;
    final Widget iconChild = isLoading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: indicatorColor,
            ),
          )
        : icon;

    if (label == null) {
      return IconButton(
        onPressed: isLoading ? null : onPressed,
        icon: iconChild,
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
      onPressed: isLoading ? null : onPressed,
      label: label!,
      icon: iconChild,
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
