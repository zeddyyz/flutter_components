import 'package:flutter/widgets.dart';

class GestureClick extends StatelessWidget {
  const GestureClick({
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
