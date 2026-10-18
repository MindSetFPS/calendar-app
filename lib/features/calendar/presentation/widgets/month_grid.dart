import 'package:flutter/material.dart';

import 'package:calendar/features/calendar/presentation/calendar_format.dart';

class MonthGrid extends StatelessWidget {
  const MonthGrid({
    super.key,
    required this.focusedMonth,
    required this.selectedDay,
    required this.hasEventsOn,
    required this.onDaySelected,
  });

  final DateTime focusedMonth;
  final DateTime selectedDay;
  final bool Function(DateTime day) hasEventsOn;
  final ValueChanged<DateTime> onDaySelected;

  static const List<String> _weekdayLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstOfMonth = DateTime(focusedMonth.year, focusedMonth.month);
    final gridStart = DateTime(
      firstOfMonth.year,
      firstOfMonth.month,
      1 - (firstOfMonth.weekday - DateTime.monday),
    );
    final today = DateTime.now();

    return Column(
      children: [
        Row(
          children: [
            for (final label in _weekdayLabels)
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: theme.textTheme.labelMedium
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (var i = 0; i < 42; i++)
              () {
                final day =
                    DateTime(gridStart.year, gridStart.month, gridStart.day + i);
                return _DayCell(
                  day: day,
                  inMonth: day.month == focusedMonth.month &&
                      day.year == focusedMonth.year,
                  selected: isSameDay(day, selectedDay),
                  today: isSameDay(day, today),
                  hasEvents: hasEventsOn(day),
                  onTap: () => onDaySelected(day),
                );
              }(),
          ],
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.inMonth,
    required this.selected,
    required this.today,
    required this.hasEvents,
    required this.onTap,
  });

  final DateTime day;
  final bool inMonth;
  final bool selected;
  final bool today;
  final bool hasEvents;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color textColor;
    if (selected) {
      textColor = scheme.onPrimary;
    } else if (inMonth) {
      textColor = scheme.onSurface;
    } else {
      textColor = scheme.onSurfaceVariant.withValues(alpha: 0.5);
    }

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Center(
        child: Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected
                ? scheme.primary
                : today
                    ? scheme.primaryContainer
                    : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${day.day}',
                style: TextStyle(
                  color: textColor,
                  fontWeight:
                      selected || today ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              if (hasEvents)
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  height: 5,
                  width: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? scheme.onPrimary : scheme.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
