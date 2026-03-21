import 'package:flutter/material.dart';

class ComponentNoSplashTheme extends StatelessWidget {
  const ComponentNoSplashTheme({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        dividerColor: Colors.transparent,
      ),
      child: child,
    );
  }
}
