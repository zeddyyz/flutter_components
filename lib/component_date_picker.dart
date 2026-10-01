import 'package:flutter/services.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

/// A compact month calendar shown in a floating sheet via [ComponentDatePicker.show].
///
/// Tapping a day in range selects it and pops the date. Month paging is
/// clamped to [firstDate]–[lastDate]. Week starts on Sunday so the weekday
/// header and day cells share the same 7-column layout.
class ComponentDatePicker extends StatefulWidget {
  const ComponentDatePicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.accentColor,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Color? accentColor;

  static const BoxConstraints _modalConstraints = BoxConstraints.tightFor(
    width: 400,
    height: 400,
  );

  static Future<DateTime?> show({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    Color? accentColor,
  }) {
    return ComponentResponsiveModal.show<DateTime>(
      context: context,
      title: '',
      showAppBar: false,
      isScrollable: true,
      float: true,
      constraints: _modalConstraints,
      builder: (context) => ComponentDatePicker(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        accentColor: accentColor,
      ),
    );
  }

  @override
  State<ComponentDatePicker> createState() => _ComponentDatePickerState();
}

class _ComponentDatePickerState extends State<ComponentDatePicker> {
  late DateTime _firstDate;
  late DateTime _lastDate;
  late DateTime _selected;
  late DateTime _visibleMonth;
  int _monthDirection = 1;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _firstDate = _dateOnly(widget.firstDate);
    _lastDate = _dateOnly(widget.lastDate);
    _selected = _clamp(_dateOnly(widget.initialDate), _firstDate, _lastDate);
    _visibleMonth = DateTime(_selected.year, _selected.month);
  }

  Color _accent(BuildContext context) => widget.accentColor ?? context.primary;

  Color _accentFill(BuildContext context) =>
      _accent(context).withValues(alpha: context.isLightMode ? 0.08 : 0.16);

  void _goToMonth(int offset) {
    final next = DateTime(_visibleMonth.year, _visibleMonth.month + offset);
    if (!_monthHasSelectableDays(next)) return;
    HapticFeedback.selectionClick();
    setState(() {
      _monthDirection = offset;
      _visibleMonth = next;
    });
  }

  Future<void> _select(DateTime date) async {
    if (_isClosing || !_isSelectable(date)) return;
    setState(() {
      _selected = date;
      _isClosing = true;
    });
    HapticFeedback.selectionClick();
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (!mounted) return;
    Navigator.of(context).pop(date);
  }

  bool _isSelectable(DateTime date) {
    final day = _dateOnly(date);
    return !day.isBefore(_firstDate) && !day.isAfter(_lastDate);
  }

  bool _monthHasSelectableDays(DateTime month) {
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1, 0);
    return !end.isBefore(_firstDate) && !start.isAfter(_lastDate);
  }

  bool get _canGoPrevious =>
      _monthHasSelectableDays(DateTime(_visibleMonth.year, _visibleMonth.month - 1));

  bool get _canGoNext =>
      _monthHasSelectableDays(DateTime(_visibleMonth.year, _visibleMonth.month + 1));

  @override
  Widget build(BuildContext context) {
    final accent = _accent(context);
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: SlideDownBar(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              children: [
                _MonthHeader(
                  label: _visibleMonth.monthYear,
                  canGoPrevious: _canGoPrevious,
                  canGoNext: _canGoNext,
                  accent: accent,
                  fill: _accentFill(context),
                  onPrevious: () => _goToMonth(-1),
                  onNext: () => _goToMonth(1),
                ),
                const SizedBox(height: 16),
                const _WeekdayHeader(),
                const SizedBox(height: 8),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 240),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    layoutBuilder: (currentChild, previousChildren) {
                      return Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          ...previousChildren,
                          ?currentChild,
                        ],
                      );
                    },
                    transitionBuilder: (child, animation) {
                      final isIncoming = child.key == ValueKey(_monthKey);
                      final inbound = Offset(_monthDirection * 0.18, 0);
                      final outbound = Offset(-_monthDirection * 0.18, 0);
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: isIncoming ? inbound : outbound,
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _CalendarMonth(
                      key: ValueKey(_monthKey),
                      month: _visibleMonth,
                      selected: _selected,
                      firstDate: _firstDate,
                      lastDate: _lastDate,
                      accent: accent,
                      onSelect: _select,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String get _monthKey => '${_visibleMonth.year}-${_visibleMonth.month}';
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.label,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.accent,
    required this.fill,
    required this.onPrevious,
    required this.onNext,
  });

  final String label;
  final bool canGoPrevious;
  final bool canGoNext;
  final Color accent;
  final Color fill;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _NavChevron(
          icon: Icons.chevron_left_rounded,
          enabled: canGoPrevious,
          accent: accent,
          fill: fill,
          onTap: onPrevious,
        ),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.bodyBold,
          ),
        ),
        _NavChevron(
          icon: Icons.chevron_right_rounded,
          enabled: canGoNext,
          accent: accent,
          fill: fill,
          onTap: onNext,
        ),
      ],
    );
  }
}

class _NavChevron extends StatelessWidget {
  const _NavChevron({
    required this.icon,
    required this.enabled,
    required this.accent,
    required this.fill,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final Color accent;
  final Color fill;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.35,
      child: IgnorePointer(
        ignoring: !enabled,
        child: ComponentGestureClick(
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: fill,
              shape: RoundedSuperellipseBorder(
                borderRadius: AppDecoration.borderRadiusMd,
              ),
            ),
            child: Icon(
              icon,
              size: 18,
              color: accent,
            ),
          ),
        ),
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader();

  static const List<String> _labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  Widget build(BuildContext context) {
    final style = context.labelMedium.copyWith(color: context.hintIos);
    return Row(
      children: [
        for (final label in _labels)
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: style,
            ),
          ),
      ],
    );
  }
}

class _CalendarMonth extends StatelessWidget {
  const _CalendarMonth({
    super.key,
    required this.month,
    required this.selected,
    required this.firstDate,
    required this.lastDate,
    required this.accent,
    required this.onSelect,
  });

  final DateTime month;
  final DateTime selected;
  final DateTime firstDate;
  final DateTime lastDate;
  final Color accent;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final today = _dateOnly(DateTime.now());
    final days = _monthCells(month);
    return Column(
      children: [
        for (var row = 0; row < 6; row++)
          Expanded(
            child: Row(
              children: [
                for (var col = 0; col < 7; col++)
                  Expanded(
                    child: _DayCell(
                      date: days[row * 7 + col],
                      selected: selected,
                      today: today,
                      firstDate: firstDate,
                      lastDate: lastDate,
                      accent: accent,
                      onSelect: onSelect,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.selected,
    required this.today,
    required this.firstDate,
    required this.lastDate,
    required this.accent,
    required this.onSelect,
  });

  final DateTime? date;
  final DateTime selected;
  final DateTime today;
  final DateTime firstDate;
  final DateTime lastDate;
  final Color accent;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final day = date;
    if (day == null) return const SizedBox.expand();

    final inRange = !day.isBefore(firstDate) && !day.isAfter(lastDate);
    final isSelected = day == selected;
    final isToday = day == today;

    return Semantics(
      button: true,
      selected: isSelected,
      enabled: inRange,
      label: day.yMMMd,
      child: IgnorePointer(
        ignoring: !inRange,
        child: ComponentGestureClick(
          onTap: () => onSelect(day),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? accent : Colors.transparent,
                shape: BoxShape.circle,
                border: isToday && !isSelected
                    ? Border.all(color: accent.withValues(alpha: 0.45))
                    : null,
              ),
              child: Text(
                '${day.day}',
                style: context.bodyBold.copyWith(
                  color: isSelected
                      ? context.primaryInverse
                      : (inRange ? context.primary : context.hintIos),
                  fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on DateTime {
  static const _abbreviatedMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const _fullMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String get yMMMd => '${_abbreviatedMonths[month - 1]} $day, $year';

  String get monthYear => '${_fullMonths[month - 1]} $year';
}

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime _clamp(DateTime date, DateTime first, DateTime last) {
  if (date.isBefore(first)) return first;
  if (date.isAfter(last)) return last;
  return date;
}

/// Sunday-first month grid, always 6 weeks so height stays stable across months.
List<DateTime?> _monthCells(DateTime month) {
  final first = DateTime(month.year, month.month);
  final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
  final leading = first.weekday % 7;
  return [
    for (var i = 0; i < 42; i++)
      if (i >= leading && i < leading + daysInMonth)
        DateTime(month.year, month.month, i - leading + 1)
      else
        null,
  ];
}
