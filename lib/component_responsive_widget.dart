import 'package:flutter/material.dart';
import 'package:flutter_components/components_context_extension.dart';

class ComponentResponsiveWidget extends StatelessWidget {
  const ComponentResponsiveWidget({
    super.key,
    required this.mobile,
    required this.medium,
    required this.large,
    required this.xLarge,
  });

  final Widget mobile;
  final Widget medium;
  final Widget large;
  final Widget xLarge;

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return mobile;
    } else if (context.isMediumScreen) {
      return medium;
    } else if (context.isLargeScreen) {
      return large;
    } else {
      return xLarge;
    }
  }
}
