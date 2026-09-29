import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class DatePickerDemoPage extends StatefulWidget {
  const DatePickerDemoPage({super.key});

  @override
  State<DatePickerDemoPage> createState() => _DatePickerDemoPageState();
}

class _DatePickerDemoPageState extends State<DatePickerDemoPage> {
  DateTime _selected = DateTime.now();

  Future<void> _openPicker() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: ComponentDatePicker(
              constraints: const BoxConstraints(maxWidth: 420, maxHeight: 560),
              initialDate: _selected,
              firstDate: DateTime(now.year - 4),
              lastDate: DateTime(now.year + 4),
              onDateSelected: (DateTime date) {},
            ),
          ),
        );
      },
    );
    if (picked == null || !mounted) return;
    setState(() => _selected = picked);
    AlertSnackbar.show(
      title: 'Date selected',
      message: MaterialLocalizations.of(context).formatFullDate(picked),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Date picker',
      children: [
        DemoSection(
          title: 'ComponentDatePicker',
          description: 'Opens in a dialog. Confirm or cancel from the picker.',
          child: Column(
            spacing: 12,
            children: [
              ComponentCard(
                displayBorder: true,
                child: Text(
                  MaterialLocalizations.of(context).formatFullDate(_selected),
                  style: context.body2Heavy,
                ),
              ),
              ComponentButton(
                key: const ValueKey<String>('open-date-picker'),
                buttonType: ButtonType.filled,
                onPressed: _openPicker,
                child: const Text('Choose date'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
