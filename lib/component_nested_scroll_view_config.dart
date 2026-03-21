import 'package:flutter/material.dart';

class ComponentNestedScrollViewConfig extends StatelessWidget {
  final Widget child;

  const ComponentNestedScrollViewConfig({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyMaterialScrollBehavior(),
      child: child,
    );
  }
}

class MyMaterialScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return child;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return GlowingOverscrollIndicator(
          axisDirection: details.direction,
          color: Theme.of(context).colorScheme.secondary,
          showTrailing: false,
          showLeading: false,
          child: child,
        );
    }
  }
}
