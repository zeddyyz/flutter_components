import 'package:flutter/services.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class ComponentDatePicker extends StatefulWidget {
  const ComponentDatePicker({
    super.key,
    required this.constraints,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
    this.primaryColor,
    this.secondaryColor,
    this.decoration,
    this.selectedColor,
  }) : iosStyle = false;

  const ComponentDatePicker.iosStyle({
    super.key,
    required this.constraints,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
    this.primaryColor,
    this.secondaryColor,
    this.decoration,
    this.selectedColor,
  }) : iosStyle = true;

  final bool iosStyle;

  final BoxConstraints constraints;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime)? onDateSelected;

  final Color? primaryColor;
  final Color? secondaryColor;
  final Decoration? decoration;
  final Color? selectedColor;

  @override
  State<ComponentDatePicker> createState() => _ComponentDatePickerState();
}

class _ComponentDatePickerState extends State<ComponentDatePicker> {
  late DateTime _selectedDate;
  late DateTime _currentMonth;
  final List<String> _weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onDateSelected?.call(date);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.iosStyle) {
      return DatePickerComponentIOS(
        initialDate: _selectedDate,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        accentColor: widget.primaryColor,
      );
    }
    return ConstrainedBox(
      constraints: widget.constraints,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration:
            widget.decoration ??
            ShapeDecoration(
              color: context.scaffoldBackgroundColor,
              shape: RoundedSuperellipseBorder(
                borderRadius: AppDecoration.iOSModalBorderRadius,
                side: BorderSide(color: context.borderColor),
              ),
            ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Month navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  key: const ValueKey('date-picker-prev'),
                  tooltip: 'Previous month',
                  icon: Icon(Icons.chevron_left, color: context.primary),
                  onPressed: _previousMonth,
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedSuperellipseBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: context.primary.withValues(alpha: 0.2)),
                      ),
                    ),
                  ),
                ),
                Text(
                  '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                  style: TextStyle(
                    color: context.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  key: const ValueKey('date-picker-next'),
                  tooltip: 'Next month',
                  icon: Icon(Icons.chevron_right, color: context.primary),
                  onPressed: _nextMonth,
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedSuperellipseBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: context.primary.withValues(alpha: 0.2)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Weekdays header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _weekdays
                  .map(
                    (day) => SizedBox(
                      width: 36,
                      child: Text(
                        day,
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),

            // Calendar grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: _calculateRequiredGridCells(),
              itemBuilder: (context, index) {
                final int day = index + 1 - _getFirstDayOffset();
                if (day < 1 || day > _getDaysInMonth(_currentMonth.year, _currentMonth.month)) {
                  return const SizedBox();
                }

                final DateTime date = DateTime(_currentMonth.year, _currentMonth.month, day);
                final bool isSelected =
                    _selectedDate.year == date.year &&
                    _selectedDate.month == date.month &&
                    _selectedDate.day == date.day;

                return Semantics(
                  label: MaterialLocalizations.of(context).formatFullDate(date),
                  button: true,
                  child: GestureDetector(
                    key: ValueKey('date-picker-day-${_isoDate(date)}'),
                    onTap: () => _selectDate(date),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? context.borderColor : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          day.toString(),
                          style: TextStyle(
                            color: isSelected
                                ? (widget.selectedColor ?? context.primary)
                                : context.primary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // const SizedBox(height: 16),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  key: const ValueKey('date-picker-cancel'),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: context.bodyHeavy.copyWith(
                      color: widget.secondaryColor ?? context.secondary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  key: const ValueKey('date-picker-confirm'),
                  onPressed: () => Navigator.pop(context, _selectedDate),
                  child: Text(
                    'Confirm',
                    style: context.bodyHeavy.copyWith(
                      color: widget.primaryColor ?? context.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _isoDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _getMonthName(int month) {
    const monthNames = [
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
    return monthNames[month - 1];
  }

  int _getFirstDayOffset() {
    // Get the weekday of the first day (1 = Monday, 7 = Sunday)
    int firstDayWeekday = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;
    // Adjust for our grid layout where Monday is the first column
    return firstDayWeekday - 1;
  }

  int _getDaysInMonth([int? year, int? month]) {
    year ??= _currentMonth.year;
    month ??= _currentMonth.month;

    // Get the days in the month by getting the last day of the month
    return DateTime(year, month + 1, 0).day;
  }

  int _calculateRequiredGridCells() {
    final int firstDayOffset = _getFirstDayOffset();
    final int daysInMonth = _getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final int totalCells = firstDayOffset + daysInMonth;
    // Ensure we have complete rows by rounding up to the next multiple of 7
    final int rows = (totalCells / 7).ceil();
    return rows * 7;
  }
}

/// A compact month calendar shown via [ComponentResponsiveModal.show].
///
/// Tapping a day in range selects it and pops the date. Month paging is
/// clamped to [firstDate]–[lastDate]. Week starts on Sunday so the weekday
/// header and day cells share the same 7-column layout.
class DatePickerComponentIOS extends StatefulWidget {
  const DatePickerComponentIOS({
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

  @override
  State<DatePickerComponentIOS> createState() => _DatePickerComponentIOSState();
}

class _DatePickerComponentIOSState extends State<DatePickerComponentIOS> {
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        kModalToolbarHeight + 12,
        20,
        16,
      ),
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

  /// Medium date matching `DateFormat.yMMMd()` in en, e.g. `Oct 1, 2026`.
  String get yMMMd => '${_abbreviatedMonths[month - 1]} $day, $year';

  /// Month and year matching `DateFormat('MMMM yyyy')`, e.g. `October 2026`.
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
