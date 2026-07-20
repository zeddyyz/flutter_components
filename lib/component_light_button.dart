import 'package:flutter/material.dart';
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
    //  style: ButtonStyle(
    //       backgroundColor: WidgetStateProperty.all(const Color.fromRGBO(245, 245, 245, 1.0)),
    //       foregroundColor: WidgetStateProperty.all(Colors.black),
    //       fixedSize: WidgetStatePropertyAll(Size(double.maxFinite, context.isMobile ? 52 : 54)),
    //       textStyle: WidgetStatePropertyAll(
    //         TextStyle(
    //           fontSize: context.isMobile ? 16 : 19,
    //           fontWeight: FontWeight.w600,
    //           fontFamily: fontFamily,
    //         ),
    //       ),
    //       shape: WidgetStateProperty.all(
    //         RoundedSuperellipseBorder(borderRadius: AppDecoration.borderRadiusStadium),
    //       ),
    //       splashFactory: NoSplash.splashFactory,
    //     ),
    Color defaultBackgroundColor =
        backgroundColor ?? (context.isLightMode ? Colors.grey.shade100 : Colors.grey.shade900);

    Color modalSheetBackgroundColor =
        backgroundColor ??
        (context.isLightMode ? Colors.grey.shade300.withValues(alpha: 0.8) : Color(0xff2c2c2e));

    return ComponentNoSplashTheme(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isModalSheet ? modalSheetBackgroundColor : defaultBackgroundColor,
          foregroundColor: foregroundColor ?? context.primary,
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
      ),
    );
  }
}
