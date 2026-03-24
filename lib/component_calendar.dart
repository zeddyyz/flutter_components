import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';

class ComponentCalendar extends StatelessWidget {
  const ComponentCalendar({
    super.key,
    required this.month,
    required this.year,
    this.titleColor,
    this.weekdayLabelColor,
    this.dayTextColor,
    this.outsideMonthDayColor,
    this.highlightBackgroundColor,
    this.todayBorderColor,
    this.highlightedRange,
    this.onDayTap,
    this.padding,
    this.showOutsideDays = true,
    this.showTodayOutline = true,
    this.weekdayLabels = _defaultWeekdayLabels,
    this.titleStyle,
    this.weekdayTextStyle,
    this.dayTextStyle,
  }) : assert(month >= 1 && month <= 12, 'month must be between 1 and 12'),
       assert(weekdayLabels.length == 7, 'weekdayLabels must contain 7 values');

  static const List<String> _defaultWeekdayLabels = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
  static const List<String> _monthNames = [
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

  final int month;
  final int year;
  final Color? titleColor;
  final Color? weekdayLabelColor;
  final Color? dayTextColor;
  final Color? outsideMonthDayColor;
  final Color? highlightBackgroundColor;
  final Color? todayBorderColor;
  final DateTimeRange? highlightedRange;
  final ValueChanged<DateTime>? onDayTap;
  final EdgeInsetsGeometry? padding;
  final bool showOutsideDays;
  final bool showTodayOutline;
  final List<String> weekdayLabels;
  final TextStyle? titleStyle;
  final TextStyle? weekdayTextStyle;
  final TextStyle? dayTextStyle;

  @override
  Widget build(BuildContext context) {
    final displayedMonth = DateTime(year, month);
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final previousMonthDays = DateTime(year, month, 0).day;
    final firstDayOffset = firstDayOfMonth.weekday % 7;
    final rowCount = ((firstDayOffset + daysInMonth) / 7).ceil();
    final today = _dateOnly(DateTime.now());
    final isCurrentMonth = today.year == year && today.month == month;

    final resolvedTitleColor = titleColor ?? (context.isDarkMode ? Colors.white : Colors.black);
    final resolvedWeekdayLabelColor = weekdayLabelColor ?? Colors.grey.shade500;
    final resolvedDayTextColor =
        dayTextColor ?? (context.isDarkMode ? Colors.grey.shade300 : Colors.grey.shade800);
    final resolvedOutsideMonthDayColor =
        outsideMonthDayColor ?? (context.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade400);
    final resolvedHighlightBackgroundColor =
        highlightBackgroundColor ??
        (context.isDarkMode
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.05));
    final resolvedTodayBorderColor =
        todayBorderColor ?? (context.isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400);

    return Padding(
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: context.defaultPadding,
          ).copyWith(bottom: context.defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_monthNames[displayedMonth.month - 1]} ${displayedMonth.year}',
            style:
                titleStyle?.copyWith(
                  color: resolvedTitleColor,
                  fontWeight: FontWeight.w600,
                ) ??
                Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: resolvedTitleColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: weekdayLabels
                .map(
                  (label) => Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style:
                            weekdayTextStyle?.copyWith(
                              color: resolvedWeekdayLabelColor,
                              fontWeight: FontWeight.w600,
                            ) ??
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: resolvedWeekdayLabelColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          for (int row = 0; row < rowCount; row++)
            _buildWeekRow(
              context,
              row: row,
              firstDayOffset: firstDayOffset,
              daysInMonth: daysInMonth,
              previousMonthDays: previousMonthDays,
              isCurrentMonth: isCurrentMonth,
              today: today,
              resolvedDayTextColor: resolvedDayTextColor,
              resolvedOutsideMonthDayColor: resolvedOutsideMonthDayColor,
              resolvedHighlightBackgroundColor: resolvedHighlightBackgroundColor,
              resolvedTodayBorderColor: resolvedTodayBorderColor,
            ),
        ],
      ),
    );
  }

  Widget _buildWeekRow(
    BuildContext context, {
    required int row,
    required int firstDayOffset,
    required int daysInMonth,
    required int previousMonthDays,
    required bool isCurrentMonth,
    required DateTime today,
    required Color resolvedDayTextColor,
    required Color resolvedOutsideMonthDayColor,
    required Color resolvedHighlightBackgroundColor,
    required Color resolvedTodayBorderColor,
  }) {
    return SizedBox(
      height: 40,
      child: Row(
        children: List.generate(7, (col) {
          final cellIndex = row * 7 + col;
          final dayOfMonth = cellIndex - firstDayOffset + 1;
          final isOutside = dayOfMonth < 1 || dayOfMonth > daysInMonth;

          late final int displayDay;
          late final DateTime cellDate;

          if (dayOfMonth < 1) {
            displayDay = previousMonthDays + dayOfMonth;
            cellDate = DateTime(year, month - 1, displayDay);
          } else if (dayOfMonth > daysInMonth) {
            displayDay = dayOfMonth - daysInMonth;
            cellDate = DateTime(year, month + 1, displayDay);
          } else {
            displayDay = dayOfMonth;
            cellDate = DateTime(year, month, displayDay);
          }

          final isHighlighted = !isOutside && _isDateHighlighted(cellDate);
          final rangeStart = highlightedRange == null ? null : _dateOnly(highlightedRange!.start);
          final rangeEnd = highlightedRange == null ? null : _dateOnly(highlightedRange!.end);
          final isRangeStart =
              isHighlighted && rangeStart != null && _isSameDate(cellDate, rangeStart);
          final isRangeEnd = isHighlighted && rangeEnd != null && _isSameDate(cellDate, rangeEnd);
          final isToday =
              showTodayOutline && isCurrentMonth && !isOutside && _isSameDate(cellDate, today);

          return Expanded(
            child: _DayCell(
              day: displayDay,
              isOutside: isOutside,
              isHighlighted: isHighlighted,
              isRangeStart: isRangeStart,
              isRangeEnd: isRangeEnd,
              isToday: isToday,
              displayDayNumber: !isOutside || showOutsideDays,
              dayColor: resolvedDayTextColor,
              outsideColor: resolvedOutsideMonthDayColor,
              highlightBg: resolvedHighlightBackgroundColor,
              todayBorderColor: resolvedTodayBorderColor,
              dayTextStyle: dayTextStyle,
              onTap: !isOutside ? () => onDayTap?.call(cellDate) : null,
            ),
          );
        }),
      ),
    );
  }

  bool _isDateHighlighted(DateTime date) {
    if (highlightedRange == null) {
      return false;
    }

    final normalizedDate = _dateOnly(date);
    final rangeStart = _dateOnly(highlightedRange!.start);
    final rangeEnd = _dateOnly(highlightedRange!.end);

    return !normalizedDate.isBefore(rangeStart) && !normalizedDate.isAfter(rangeEnd);
  }

  static DateTime _dateOnly(DateTime value) => DateTime(value.year, value.month, value.day);

  static bool _isSameDate(DateTime left, DateTime right) =>
      left.year == right.year && left.month == right.month && left.day == right.day;
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isOutside,
    required this.isHighlighted,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.isToday,
    required this.displayDayNumber,
    required this.dayColor,
    required this.outsideColor,
    required this.highlightBg,
    required this.todayBorderColor,
    required this.dayTextStyle,
    required this.onTap,
  });

  final int day;
  final bool isOutside;
  final bool isHighlighted;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool isToday;
  final bool displayDayNumber;
  final Color dayColor;
  final Color outsideColor;
  final Color highlightBg;
  final Color todayBorderColor;
  final TextStyle? dayTextStyle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textColor = isOutside ? outsideColor : dayColor;

    BorderRadius? bandRadius;
    if (isRangeStart && isRangeEnd) {
      bandRadius = AppDecoration.borderRadiusXl;
    } else if (isRangeStart) {
      bandRadius = const BorderRadius.horizontal(left: AppDecoration.radiusXl);
    } else if (isRangeEnd) {
      bandRadius = const BorderRadius.horizontal(right: AppDecoration.radiusXl);
    }

    final content = Stack(
      alignment: Alignment.center,
      children: [
        if (isHighlighted)
          Positioned.fill(
            child: Container(
              decoration: ShapeDecoration(
                color: highlightBg,
                shape: RoundedSuperellipseBorder(
                  borderRadius: bandRadius ?? BorderRadius.zero,
                ),
              ),
            ),
          ),
        if (isToday)
          Container(
            width: 32,
            height: 32,
            decoration: ShapeDecoration(
              shape: RoundedSuperellipseBorder(
                borderRadius: AppDecoration.borderRadiusSm,
                side: BorderSide(
                  color: todayBorderColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
        if (displayDayNumber)
          Center(
            child: Text(
              '$day',
              style:
                  dayTextStyle?.copyWith(
                    color: textColor,
                    fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
                  ) ??
                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ),
      ],
    );

    if (onTap == null) {
      return content;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: content,
      ),
    );
  }
}

@Preview(name: 'ComponentCalendar')
Widget previewComponentCalendar() {
  return ComponentCalendar(
    month: 5,
    year: 2026,
    highlightedRange: DateTimeRange(
      start: DateTime(2026, 5, 11),
      end: DateTime(2026, 5, 15),
    ),
    onDayTap: (date) {},
    titleColor: Colors.white,
    highlightBackgroundColor: Colors.white.withValues(alpha: 0.08),
  );
}
