import 'package:material_ui/material_ui.dart';
import 'package:flutter_components/flutter_components.dart';

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
  });

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

                return GestureDetector(
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
                );
              },
            ),

            // const SizedBox(height: 16),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
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
