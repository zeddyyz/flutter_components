import 'package:flutter/widgets.dart';

class ComponentGestureClick extends StatelessWidget {
  const ComponentGestureClick({
    super.key,
    required this.onTap,
    required this.child,
    this.behavior,
    this.semanticsLabel,
  });

  final VoidCallback onTap;
  final Widget child;
  final HitTestBehavior? behavior;

  /// VoiceOver / TalkBack label. Does not make `tap(text:)` work; put a
  /// [ValueKey] on this widget for agent driving.
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    Widget clickChild = child;
    if (semanticsLabel != null) {
      clickChild = Semantics(
        label: semanticsLabel,
        button: true,
        child: child,
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: behavior ?? HitTestBehavior.opaque,
        onTap: onTap,
        child: clickChild,
      ),
    );
  }
}
