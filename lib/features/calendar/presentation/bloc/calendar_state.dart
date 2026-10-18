import 'package:equatable/equatable.dart';

import 'package:calendar/features/calendar/domain/entities/calendar_event.dart';

enum CalendarStatus { initial, loading, success, failure }

class CalendarState extends Equatable {
  CalendarState({
    this.status = CalendarStatus.initial,
    DateTime? focusedMonth,
    DateTime? selectedDay,
    this.events = const [],
    this.errorMessage,
  })  : focusedMonth = _monthStart(focusedMonth ?? DateTime.now()),
        selectedDay = _dayStart(selectedDay ?? DateTime.now());

  final CalendarStatus status;
  final DateTime focusedMonth;
  final DateTime selectedDay;
  final List<CalendarEvent> events;
  final String? errorMessage;

  static DateTime _monthStart(DateTime date) => DateTime(date.year, date.month);

  static DateTime _dayStart(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  List<CalendarEvent> get eventsForSelectedDay =>
      events.where((event) => event.occursOn(selectedDay)).toList();

  bool hasEventsOn(DateTime day) =>
      events.any((event) => event.occursOn(day));

  CalendarState copyWith({
    CalendarStatus? status,
    DateTime? focusedMonth,
    DateTime? selectedDay,
    List<CalendarEvent>? events,
    String? errorMessage,
  }) {
    return CalendarState(
      status: status ?? this.status,
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDay: selectedDay ?? this.selectedDay,
      events: events ?? this.events,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, focusedMonth, selectedDay, events, errorMessage];
}
