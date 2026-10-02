import 'package:flutter_components/component_date_picker.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentDateField extends StatelessWidget {
  const ComponentDateField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.hintText = 'Date',
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final String hintText;

  String get _label {
    if (value == null) return hintText;
    final DateTime date = value!;
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pick(BuildContext context) async {
    final DateTime? next = await ComponentDatePicker.show(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (next != null) onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return ComponentGestureClick(
      key: const ValueKey<String>('date-field'),
      semanticsLabel: _label,
      onTap: () => _pick(context),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: ShapeDecoration(
          shape: RoundedSuperellipseBorder(
            borderRadius: AppDecoration.borderRadiusCard,
            side: BorderSide(color: context.componentTheme.borderColorIntense),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.event_available_outlined, color: context.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _label,
                style: context.bodyMedium.copyWith(
                  color: value == null ? context.componentTheme.hintColor : context.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
