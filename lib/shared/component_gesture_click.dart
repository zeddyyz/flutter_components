import 'package:flutter/widgets.dart';

class ComponentGestureClick extends StatelessWidget {
  const ComponentGestureClick({
    super.key,
    required this.onTap,
    required this.child,
    this.behavior,
  });

  final VoidCallback onTap;
  final Widget child;
  final HitTestBehavior? behavior;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: behavior,
        onTap: onTap,
        child: child,
      ),
    );
  }
}
