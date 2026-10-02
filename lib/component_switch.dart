import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentSwitch extends StatelessWidget {
  const ComponentSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;

  static const Duration _animationDuration = Duration(milliseconds: 180);
  static const double _trackWidth = 51;
  static const double _trackHeight = 31;
  static const double _thumbSize = 28;
  static const double _trackPadding = 1.5;
  static const ValueKey<String> _switchKey = ValueKey<String>('switch');

  bool get _isEnabled => onChanged != null;

  @override
  Widget build(BuildContext context) {
    final Color trackColor = value
        ? (activeColor ?? Theme.of(context).primaryColor)
        : context.componentTheme.chipColor;

    final Widget switchVisual = RepaintBoundary(
      child: AnimatedContainer(
        duration: _animationDuration,
        curve: Curves.easeOut,
        width: _trackWidth,
        height: _trackHeight,
        padding: const EdgeInsets.all(_trackPadding),
        decoration: ShapeDecoration(
          color: trackColor,
          shape: const RoundedSuperellipseBorder(
            borderRadius: AppDecoration.borderRadiusStadium,
          ),
        ),
        child: AnimatedAlign(
          duration: _animationDuration,
          curve: Curves.easeOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: const SizedBox(
            width: _thumbSize,
            height: _thumbSize,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedSuperellipseBorder(
                  borderRadius: AppDecoration.borderRadiusStadium,
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x29000000),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final Widget tappable = _isEnabled
        ? ComponentGestureClick(
            key: _switchKey,
            onTap: () => onChanged!(!value),
            child: switchVisual,
          )
        : AbsorbPointer(
            key: _switchKey,
            child: switchVisual,
          );

    return Opacity(
      opacity: _isEnabled ? 1 : 0.4,
      child: Semantics(
        toggled: value,
        button: true,
        child: tappable,
      ),
    );
  }
}
