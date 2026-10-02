import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentCheckbox extends StatelessWidget {
  const ComponentCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onChanged != null;
    final Color fill = value ? Theme.of(context).primaryColor : Colors.transparent;
    final Color border = value ? Theme.of(context).primaryColor : context.componentTheme.borderColorIntense;

    final Widget box = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      width: 22,
      height: 22,
      decoration: ShapeDecoration(
        color: fill,
        shape: RoundedSuperellipseBorder(
          borderRadius: AppDecoration.borderRadiusSm,
          side: BorderSide(color: border, width: 1.5),
        ),
      ),
      child: value
          ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
          : const SizedBox.shrink(),
    );

    final Widget content = label == null
        ? box
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              box,
              const SizedBox(width: 10),
              Flexible(child: Text(label!, style: context.bodyMedium)),
            ],
          );

    if (!enabled) {
      return Opacity(opacity: 0.4, child: content);
    }

    return ComponentGestureClick(
      semanticsLabel: label ?? (value ? 'Checked' : 'Unchecked'),
      onTap: () => onChanged!(!value),
      child: content,
    );
  }
}
