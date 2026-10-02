import 'package:flutter_components/component_calendar.dart';
import 'package:flutter_components/component_light_button.dart';
import 'package:flutter_components/component_responsive_modal.dart';
import 'package:material_ui/material_ui.dart';

class ComponentDateRangePicker {
  static Future<DateTimeRange?> show({
    required BuildContext context,
    DateTimeRange? initialRange,
    required DateTime firstDate,
    required DateTime lastDate,
  }) {
    return ComponentResponsiveModal.show<DateTimeRange>(
      context: context,
      title: 'Date range',
      float: true,
      constraints: const BoxConstraints(maxWidth: 420, maxHeight: 520),
      builder: (BuildContext modalContext) => _DateRangeBody(
        initialRange: initialRange,
        firstDate: firstDate,
        lastDate: lastDate,
      ),
    );
  }
}

class _DateRangeBody extends StatefulWidget {
  const _DateRangeBody({
    required this.initialRange,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTimeRange? initialRange;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_DateRangeBody> createState() => _DateRangeBodyState();
}

class _DateRangeBodyState extends State<_DateRangeBody> {
  late DateTime _month;
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _start = widget.initialRange == null ? null : _only(widget.initialRange!.start);
    _end = widget.initialRange == null ? null : _only(widget.initialRange!.end);
    _month = DateTime((_start ?? DateTime.now()).year, (_start ?? DateTime.now()).month);
  }

  static DateTime _only(DateTime value) => DateTime(value.year, value.month, value.day);

  void _onDayTap(DateTime day) {
    final DateTime tapped = _only(day);
    setState(() {
      if (_start == null || _end != null) {
        _start = tapped;
        _end = null;
        return;
      }
      if (tapped.isBefore(_start!)) {
        _end = _start;
        _start = tapped;
        return;
      }
      _end = tapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTimeRange? range = _start == null
        ? null
        : DateTimeRange(start: _start!, end: _end ?? _start!);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, kModalToolbarHeight, 8, 16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() => _month = DateTime(_month.year, _month.month - 1)),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() => _month = DateTime(_month.year, _month.month + 1)),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          ComponentCalendar(
            month: _month.month,
            year: _month.year,
            highlightedRange: range,
            onDayTap: _onDayTap,
          ),
          const Spacer(),
          ComponentLightButton(
            key: const ValueKey<String>('date-range-apply'),
            isModalSheet: true,
            onPressed: _start == null || _end == null
                ? () {}
                : () => Navigator.pop(context, DateTimeRange(start: _start!, end: _end!)),
            child: Text(
              _start == null || _end == null ? 'Select two days' : 'Apply range',
            ),
          ),
        ],
      ),
    );
  }
}
