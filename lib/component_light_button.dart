import 'package:material_ui/material_ui.dart';
import 'package:flutter_components/flutter_components.dart';

class ComponentLightButton extends StatelessWidget {
  const ComponentLightButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isModalSheet = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  final VoidCallback onPressed;
  final Widget child;
  final bool isModalSheet;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    Color defaultBackgroundColor =
        backgroundColor ?? (context.isLightMode ? Colors.grey.shade100 : Colors.grey.shade900);

    Color modalSheetBackgroundColor =
        backgroundColor ??
        (context.isLightMode ? Colors.grey.shade300.withValues(alpha: 0.8) : Color(0xff2c2c2e));

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isModalSheet ? modalSheetBackgroundColor : defaultBackgroundColor,
        foregroundColor: foregroundColor ?? context.primary,
        shadowColor: Colors.transparent,
        overlayColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        fixedSize: Size(double.maxFinite, context.isMobile ? 52 : 54),
        textStyle: TextStyle(
          fontSize: context.isMobile ? 16 : 19,
          fontWeight: FontWeight.w600,
          fontFamily: context.textTheme.bodySmall!.fontFamily,
        ),
        shape: RoundedSuperellipseBorder(
          borderRadius: AppDecoration.borderRadiusStadium,
        ),
        splashFactory: NoSplash.splashFactory,
        elevation: 0,
        enabledMouseCursor: SystemMouseCursors.click,
      ),
      child: child,
    );
  }
}
