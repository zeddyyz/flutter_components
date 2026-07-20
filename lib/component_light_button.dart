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
    Color defaultBackgroundColor =
        backgroundColor ?? (context.isLightMode ? Colors.grey.shade100 : Colors.grey.shade900);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isModalSheet
            ? (backgroundColor ?? context.bottomSheetCardColor)
            : defaultBackgroundColor,
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
      ),
      child: child,
    );
  }
}
