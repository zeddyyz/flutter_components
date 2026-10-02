import 'package:flutter_components/component_responsive_modal.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/shared/component_gesture_click.dart';
import 'package:flutter_components/utilities/app_decoration.dart';
import 'package:material_ui/material_ui.dart';

class ComponentTimePicker {
  static Future<TimeOfDay?> show({
    required BuildContext context,
    required TimeOfDay initialTime,
  }) {
    return ComponentResponsiveModal.show<TimeOfDay>(
      context: context,
      title: 'Time',
      float: true,
      constraints: const BoxConstraints(maxWidth: 400, maxHeight: 360),
      builder: (BuildContext modalContext) => _TimePickerBody(initialTime: initialTime),
    );
  }
}

class _TimePickerBody extends StatefulWidget {
  const _TimePickerBody({required this.initialTime});

  final TimeOfDay initialTime;

  @override
  State<_TimePickerBody> createState() => _TimePickerBodyState();
}

class _TimePickerBodyState extends State<_TimePickerBody> {
  late int _hour = widget.initialTime.hourOfPeriod == 0 ? 12 : widget.initialTime.hourOfPeriod;
  late int _minute = widget.initialTime.minute;
  late bool _isPm = widget.initialTime.period == DayPeriod.pm;

  TimeOfDay get _time {
    int hour = _hour % 12;
    if (_isPm) hour += 12;
    return TimeOfDay(hour: hour, minute: _minute);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, kModalToolbarHeight + 8, 20, 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _Wheel(
                label: 'Hour',
                value: _hour,
                min: 1,
                max: 12,
                onChanged: (int value) => setState(() => _hour = value),
              )),
              const SizedBox(width: 12),
              Expanded(child: _Wheel(
                label: 'Minute',
                value: _minute,
                min: 0,
                max: 59,
                onChanged: (int value) => setState(() => _minute = value),
              )),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _PeriodChip(label: 'AM', selected: !_isPm, onTap: () => setState(() => _isPm = false)),
              const SizedBox(width: 8),
              _PeriodChip(label: 'PM', selected: _isPm, onTap: () => setState(() => _isPm = true)),
              const Spacer(),
              TextButton(
                key: const ValueKey<String>('time-picker-done'),
                onPressed: () => Navigator.pop(context, _time),
                child: const Text('Done'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Wheel extends StatelessWidget {
  const _Wheel({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: context.labelMedium.copyWith(color: context.hintIntense)),
        const SizedBox(height: 8),
        SizedBox(
          height: 140,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 40,
            perspective: 0.003,
            diameterRatio: 1.4,
            controller: FixedExtentScrollController(initialItem: value - min),
            onSelectedItemChanged: (int index) => onChanged(min + index),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: max - min + 1,
              builder: (BuildContext context, int index) {
                final int number = min + index;
                return Center(
                  child: Text(
                    number.toString().padLeft(2, '0'),
                    style: context.body3Heavy,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ComponentGestureClick(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          color: selected ? Theme.of(context).primaryColor : context.componentTheme.chipColor,
          shape: RoundedSuperellipseBorder(borderRadius: AppDecoration.borderRadiusStadium),
        ),
        child: Text(
          label,
          style: context.labelHeavy.copyWith(color: selected ? Colors.white : context.primary),
        ),
      ),
    );
  }
}
