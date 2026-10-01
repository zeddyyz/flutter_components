import 'package:flutter/services.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

enum _PickerLevel { days, years, months }

/// A compact month calendar shown in a floating sheet via [ComponentDatePicker.show].
///
/// Tapping a day in range selects it and pops the date. The month title opens a
/// year grid, then a month grid, then returns to dates. Month paging is clamped
/// to [firstDate]–[lastDate]. Week starts on Sunday so the weekday header and
/// day cells share the same 7-column layout.
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
  late int _pickerYear;
  _PickerLevel _level = _PickerLevel.days;
  int _monthDirection = 1;
  int _levelDirection = 1;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _firstDate = _dateOnly(widget.firstDate);
    _lastDate = _dateOnly(widget.lastDate);
    _selected = _clamp(_dateOnly(widget.initialDate), _firstDate, _lastDate);
    _visibleMonth = DateTime(_selected.year, _selected.month);
    _pickerYear = _visibleMonth.year;
  }

  Color _accent(BuildContext context) => widget.accentColor ?? context.primary;

  Color _accentFill(BuildContext context) =>
      _accent(context).withValues(alpha: context.isLightMode ? 0.08 : 0.16);

  void _goToMonth(int offset) {
    if (_level != _PickerLevel.days) return;
    final next = DateTime(_visibleMonth.year, _visibleMonth.month + offset);
    if (!_monthHasSelectableDays(next)) return;
    HapticFeedback.selectionClick();
    setState(() {
      _monthDirection = offset;
      _visibleMonth = next;
      _pickerYear = next.year;
    });
  }

  void _showYears() {
    HapticFeedback.selectionClick();
    setState(() {
      _levelDirection = _level == _PickerLevel.days ? 1 : -1;
      _pickerYear = _visibleMonth.year;
      _level = _PickerLevel.years;
    });
  }

  void _showMonths(int year) {
    HapticFeedback.selectionClick();
    setState(() {
      _levelDirection = 1;
      _pickerYear = year;
      _level = _PickerLevel.months;
    });
  }

  void _showDays({DateTime? month}) {
    HapticFeedback.selectionClick();
    setState(() {
      _levelDirection = -1;
      if (month != null) {
        _visibleMonth = DateTime(month.year, month.month);
        _pickerYear = month.year;
      }
      _level = _PickerLevel.days;
    });
  }

  void _onTitleTap() {
    switch (_level) {
      case _PickerLevel.days:
        _showYears();
      case _PickerLevel.years:
        _showDays();
      case _PickerLevel.months:
        _showYears();
    }
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

  String get _titleLabel => switch (_level) {
    _PickerLevel.days => _visibleMonth.monthYear,
    _PickerLevel.years => 'Year',
    _PickerLevel.months => '$_pickerYear',
  };

  String get _monthKey => '${_visibleMonth.year}-${_visibleMonth.month}';

  String get _levelKey => switch (_level) {
    _PickerLevel.days => 'days',
    _PickerLevel.years => 'years',
    _PickerLevel.months => 'months-$_pickerYear',
  };

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
                  label: _titleLabel,
                  canGoPrevious: _level == _PickerLevel.days && _canGoPrevious,
                  canGoNext: _level == _PickerLevel.days && _canGoNext,
                  showPrevious: _level != _PickerLevel.years,
                  showNext: _level == _PickerLevel.days,
                  isExpanded: _level != _PickerLevel.days,
                  accent: accent,
                  fill: _accentFill(context),
                  onTitleTap: _onTitleTap,
                  onPrevious: () {
                    if (_level == _PickerLevel.months) {
                      _showYears();
                      return;
                    }
                    _goToMonth(-1);
                  },
                  onNext: () => _goToMonth(1),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
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
                      final isIncoming = child.key == ValueKey(_levelKey);
                      final inbound = Offset(0, _levelDirection * 0.18);
                      final outbound = Offset(0, -_levelDirection * 0.18);
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
                    child: KeyedSubtree(
                      key: ValueKey(_levelKey),
                      child: switch (_level) {
                        _PickerLevel.days => _DaysView(
                          monthKey: _monthKey,
                          monthDirection: _monthDirection,
                          visibleMonth: _visibleMonth,
                          selected: _selected,
                          firstDate: _firstDate,
                          lastDate: _lastDate,
                          accent: accent,
                          onSelect: _select,
                        ),
                        _PickerLevel.years => _YearPicker(
                          firstYear: _firstDate.year,
                          lastYear: _lastDate.year,
                          selectedYear: _visibleMonth.year,
                          currentYear: DateTime.now().year,
                          accent: accent,
                          onSelect: _showMonths,
                        ),
                        _PickerLevel.months => _MonthPicker(
                          year: _pickerYear,
                          selectedMonth: _visibleMonth.year == _pickerYear
                              ? _visibleMonth.month
                              : null,
                          currentMonth: DateTime.now().year == _pickerYear
                              ? DateTime.now().month
                              : null,
                          firstDate: _firstDate,
                          lastDate: _lastDate,
                          accent: accent,
                          onSelect: (month) => _showDays(month: DateTime(_pickerYear, month)),
                        ),
                      },
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
}

class _DaysView extends StatelessWidget {
  const _DaysView({
    required this.monthKey,
    required this.monthDirection,
    required this.visibleMonth,
    required this.selected,
    required this.firstDate,
    required this.lastDate,
    required this.accent,
    required this.onSelect,
  });

  final String monthKey;
  final int monthDirection;
  final DateTime visibleMonth;
  final DateTime selected;
  final DateTime firstDate;
  final DateTime lastDate;
  final Color accent;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              final isIncoming = child.key == ValueKey(monthKey);
              final inbound = Offset(monthDirection * 0.18, 0);
              final outbound = Offset(-monthDirection * 0.18, 0);
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
              key: ValueKey(monthKey),
              month: visibleMonth,
              selected: selected,
              firstDate: firstDate,
              lastDate: lastDate,
              accent: accent,
              onSelect: onSelect,
            ),
          ),
        ),
      ],
    );
  }
}

class _YearPicker extends StatelessWidget {
  const _YearPicker({
    required this.firstYear,
    required this.lastYear,
    required this.selectedYear,
    required this.currentYear,
    required this.accent,
    required this.onSelect,
  });

  final int firstYear;
  final int lastYear;
  final int selectedYear;
  final int currentYear;
  final Color accent;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final years = [for (var year = firstYear; year <= lastYear; year++) year];
    return _SelectionGrid(
      itemCount: years.length,
      itemBuilder: (index) {
        final year = years[index];
        return _PickerCell(
          key: ValueKey('date-picker-year-$year'),
          label: '$year',
          semanticLabel: '$year',
          selected: year == selectedYear,
          isCurrent: year == currentYear,
          accent: accent,
          onTap: () => onSelect(year),
        );
      },
    );
  }
}

class _MonthPicker extends StatelessWidget {
  const _MonthPicker({
    required this.year,
    required this.selectedMonth,
    required this.currentMonth,
    required this.firstDate,
    required this.lastDate,
    required this.accent,
    required this.onSelect,
  });

  final int year;
  final int? selectedMonth;
  final int? currentMonth;
  final DateTime firstDate;
  final DateTime lastDate;
  final Color accent;
  final ValueChanged<int> onSelect;

  bool _isEnabled(int month) {
    final start = DateTime(year, month);
    final end = DateTime(year, month + 1, 0);
    return !end.isBefore(firstDate) && !start.isAfter(lastDate);
  }

  @override
  Widget build(BuildContext context) {
    return _SelectionGrid(
      itemCount: 12,
      itemBuilder: (index) {
        final month = index + 1;
        final label = DateTime(year, month).abbreviatedMonth;
        return _PickerCell(
          key: ValueKey('date-picker-month-$year-$month'),
          label: label,
          semanticLabel: DateTime(year, month).monthYear,
          selected: month == selectedMonth,
          isCurrent: month == currentMonth,
          enabled: _isEnabled(month),
          accent: accent,
          onTap: () => onSelect(month),
        );
      },
    );
  }
}

class _SelectionGrid extends StatelessWidget {
  const _SelectionGrid({
    required this.itemCount,
    required this.itemBuilder,
  });

  static const _crossAxisCount = 3;

  final int itemCount;
  final Widget Function(int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    final rows = (itemCount / _crossAxisCount).ceil();
    if (rows <= 5) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            for (var row = 0; row < rows; row++)
              Expanded(
                child: Row(
                  children: [
                    for (var col = 0; col < _crossAxisCount; col++)
                      Expanded(
                        child: () {
                          final index = row * _crossAxisCount + col;
                          if (index >= itemCount) return const SizedBox.expand();
                          return itemBuilder(index);
                        }(),
                      ),
                  ],
                ),
              ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount,
        childAspectRatio: 1.7,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => itemBuilder(index),
    );
  }
}

class _PickerCell extends StatelessWidget {
  const _PickerCell({
    super.key,
    required this.label,
    required this.semanticLabel,
    required this.selected,
    required this.isCurrent,
    required this.accent,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final String semanticLabel;
  final bool selected;
  final bool isCurrent;
  final bool enabled;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      label: semanticLabel,
      child: IgnorePointer(
        ignoring: !enabled,
        child: ComponentGestureClick(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                color: selected ? accent : Colors.transparent,
                shape: RoundedSuperellipseBorder(
                  borderRadius: AppDecoration.borderRadiusMd,
                  side: isCurrent && !selected
                      ? BorderSide(color: accent.withValues(alpha: 0.45))
                      : BorderSide.none,
                ),
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.bodyBold.copyWith(
                  color: selected
                      ? context.primaryInverse
                      : (enabled ? context.primary : context.hintIos),
                  fontWeight: selected || isCurrent ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.label,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.showPrevious,
    required this.showNext,
    required this.isExpanded,
    required this.accent,
    required this.fill,
    required this.onTitleTap,
    required this.onPrevious,
    required this.onNext,
  });

  final String label;
  final bool canGoPrevious;
  final bool canGoNext;
  final bool showPrevious;
  final bool showNext;
  final bool isExpanded;
  final Color accent;
  final Color fill;
  final VoidCallback onTitleTap;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showPrevious)
          _NavChevron(
            icon: Icons.chevron_left_rounded,
            enabled: canGoPrevious || isExpanded,
            accent: accent,
            fill: fill,
            onTap: onPrevious,
          )
        else
          const SizedBox(width: 40, height: 40),
        Expanded(
          child: Center(
            child: ComponentGestureClick(
              key: const ValueKey('date-picker-title'),
              onTap: onTitleTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.bodyBold,
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: accent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showNext)
          _NavChevron(
            icon: Icons.chevron_right_rounded,
            enabled: canGoNext,
            accent: accent,
            fill: fill,
            onTap: onNext,
          )
        else
          const SizedBox(width: 40, height: 40),
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

  String get abbreviatedMonth => _abbreviatedMonths[month - 1];

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
