import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentBadge extends StatelessWidget {
  const ComponentBadge({
    super.key,
    this.count,
    this.dot = false,
    this.color,
    this.foregroundColor,
    this.maxCount = 99,
    this.child,
  });

  const ComponentBadge.dot({
    super.key,
    this.color,
    this.child,
  }) : count = null,
       dot = true,
       foregroundColor = null,
       maxCount = 99;

  final int? count;
  final bool dot;
  final Color? color;
  final Color? foregroundColor;
  final int maxCount;
  final Widget? child;

  String? get _label {
    if (dot || count == null) return null;
    if (count! > maxCount) return '$maxCount+';
    return '${count!}';
  }

  @override
  Widget build(BuildContext context) {
    final Color background = color ?? Theme.of(context).primaryColor;
    final Color foreground = foregroundColor ?? Colors.white;
    final String? label = _label;

    final Widget badge = dot
        ? Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
          )
        : Container(
            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: ShapeDecoration(
              color: background,
              shape: RoundedSuperellipseBorder(
                borderRadius: AppDecoration.borderRadiusStadium,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label ?? '',
              style: context.labelBold.copyWith(color: foreground, height: 1),
            ),
          );

    if (child == null) return badge;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        Positioned(
          top: dot ? -1 : -6,
          right: dot ? -1 : -6,
          child: badge,
        ),
      ],
    );
  }
}
