import 'package:material_ui/material_ui.dart';

/// Clips the blurred header to either a plain rectangle (default) or a rounded
/// superellipse when a [borderRadius] is supplied. The clip forces a layer
/// boundary so the inner [BackdropFilter] is constrained to the rounded
/// corners instead of painting into them.
class ComponentClippedHeader extends StatelessWidget {
  const ComponentClippedHeader({
    super.key,
    required this.child,
    this.borderRadius,
  });

  final Widget child;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    if (borderRadius == null) {
      return ClipRect(child: child);
    }
    return ClipRSuperellipse(borderRadius: borderRadius!, child: child);
  }
}
