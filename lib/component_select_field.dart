import 'package:flutter_components/component_action_sheet.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentSelectOption<T> {
  const ComponentSelectOption({required this.value, required this.label});

  final T value;
  final String label;
}

class ComponentSelectField<T> extends StatelessWidget {
  const ComponentSelectField({
    super.key,
    required this.options,
    required this.onChanged,
    this.value,
    this.hintText = 'Select',
    this.icon,
  });

  final List<ComponentSelectOption<T>> options;
  final ValueChanged<T> onChanged;
  final T? value;
  final String hintText;
  final Widget? icon;

  String? get _selectedLabel {
    for (final ComponentSelectOption<T> option in options) {
      if (option.value == value) return option.label;
    }
    return null;
  }

  Future<void> _open(BuildContext context) {
    return ComponentActionSheet.show(
      context: context,
      title: hintText,
      actions: [
        for (final ComponentSelectOption<T> option in options)
          ComponentActionSheetAction(
            label: option.label,
            onPressed: () => onChanged(option.value),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? selected = _selectedLabel;
    return ComponentGestureClick(
      key: const ValueKey<String>('select-field'),
      semanticsLabel: selected ?? hintText,
      onTap: () => _open(context),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: ShapeDecoration(
          shape: RoundedSuperellipseBorder(
            borderRadius: AppDecoration.borderRadiusCard,
            side: BorderSide(
              color: context.componentTheme.borderColorIntense,
            ),
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Text(
                selected ?? hintText,
                style: context.bodyMedium.copyWith(
                  color: selected == null ? context.componentTheme.hintColor : context.primary,
                ),
              ),
            ),
            Icon(Icons.expand_more_rounded, color: context.hintIntense),
          ],
        ),
      ),
    );
  }
}
