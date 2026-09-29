import 'package:example/gallery/demo_scaffold.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class CalendarDemoPage extends StatefulWidget {
  const CalendarDemoPage({super.key});

  @override
  State<CalendarDemoPage> createState() => _CalendarDemoPageState();
}

class _CalendarDemoPageState extends State<CalendarDemoPage> {
  late int _month = DateTime.now().month;
  late int _year = DateTime.now().year;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  DateTimeRange? get _range {
    if (_rangeStart == null) return null;
    return DateTimeRange(start: _rangeStart!, end: _rangeEnd ?? _rangeStart!);
  }

  void _onDayTap(DateTime day) {
    setState(() {
      if (_rangeStart == null || _rangeEnd != null) {
        _rangeStart = day;
        _rangeEnd = null;
        return;
      }
      if (day.isBefore(_rangeStart!)) {
        _rangeEnd = _rangeStart;
        _rangeStart = day;
      } else {
        _rangeEnd = day;
      }
    });
  }

  void _shiftMonth(int delta) {
    setState(() {
      final DateTime next = DateTime(_year, _month + delta);
      _month = next.month;
      _year = next.year;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Calendar',
      children: [
        DemoSection(
          title: 'ComponentCalendar',
          description: 'Tap a day to start a range, tap again to end it.',
          child: ComponentCard(
            displayBorder: true,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    children: [
                      IconButton(
                        key: const ValueKey<String>('calendar-prev'),
                        tooltip: 'Previous month',
                        onPressed: () => _shiftMonth(-1),
                        icon: const Icon(Icons.chevron_left_rounded),
                      ),
                      const Spacer(),
                      IconButton(
                        key: const ValueKey<String>('calendar-next'),
                        tooltip: 'Next month',
                        onPressed: () => _shiftMonth(1),
                        icon: const Icon(Icons.chevron_right_rounded),
                      ),
                    ],
                  ),
                ),
                ComponentCalendar(
                  month: _month,
                  year: _year,
                  highlightedRange: _range,
                  onDayTap: _onDayTap,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
