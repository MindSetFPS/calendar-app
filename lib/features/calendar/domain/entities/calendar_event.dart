import 'package:equatable/equatable.dart';

enum EventCategory { work, personal, health, social, other }

class CalendarEvent extends Equatable {
  const CalendarEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    this.description = '',
    this.location = '',
    this.category = EventCategory.other,
  });

  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime start;
  final DateTime end;
  final EventCategory category;

  Duration get duration => end.difference(start);

  bool occursOn(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    final first = DateTime(start.year, start.month, start.day);
    final last = DateTime(end.year, end.month, end.day);
    return !date.isBefore(first) && !date.isAfter(last);
  }

  @override
  List<Object?> get props =>
      [id, title, description, location, start, end, category];
}
