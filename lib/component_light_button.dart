import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class ComponentLightButton extends StatelessWidget {
  const ComponentLightButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isModalSheet = false,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final Widget child;
  final bool isModalSheet;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    Color defaultBackgroundColor =
        backgroundColor ??
        (context.isLightMode ? Colors.grey.shade300.withValues(alpha: 0.75) : Colors.grey.shade900);

    Color modalSheetBackgroundColor =
        backgroundColor ?? (context.isLightMode ? Colors.grey.shade300 : Color(0xff2c2c2e));

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
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
      child: isLoading
          ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: foregroundColor ?? context.primary,
              ),
            )
          : child,
    );
  }
}
