import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class PickersDemoPage extends StatefulWidget {
  const PickersDemoPage({super.key});

  @override
  State<PickersDemoPage> createState() => _PickersDemoPageState();
}

class _PickersDemoPageState extends State<PickersDemoPage> {
  DateTime? _date;
  TimeOfDay? _time;
  DateTimeRange? _range;

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Pickers',
      children: [
        DemoSection(
          title: 'Date field',
          child: ComponentDateField(
            value: _date,
            firstDate: DateTime(2020),
            lastDate: DateTime(2030),
            onChanged: (DateTime value) => setState(() => _date = value),
          ),
        ),
        DemoSection(
          title: 'Time picker',
          child: FilledButton(
            key: const ValueKey<String>('time-picker-show'),
            onPressed: () async {
              final TimeOfDay? next = await ComponentTimePicker.show(
                context: context,
                initialTime: _time ?? TimeOfDay.now(),
              );
              if (next != null) setState(() => _time = next);
            },
            child: Text(_time == null ? 'Pick a time' : _time!.format(context)),
          ),
        ),
        DemoSection(
          title: 'Date range',
          child: OutlinedButton(
            key: const ValueKey<String>('date-range-show'),
            onPressed: () async {
              final DateTimeRange? next = await ComponentDateRangePicker.show(
                context: context,
                initialRange: _range,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (next != null) setState(() => _range = next);
            },
            child: Text(
              _range == null
                  ? 'Pick a range'
                  : '${_range!.start.toString().split(' ').first} → ${_range!.end.toString().split(' ').first}',
            ),
          ),
        ),
      ],
    );
  }
}
