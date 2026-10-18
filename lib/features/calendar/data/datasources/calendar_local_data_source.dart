import 'package:calendar/features/calendar/domain/entities/calendar_event.dart';

/// Placeholder source of calendar events.
///
/// There is no backend yet, so this returns a small in-memory set seeded
/// relative to today so the calendar always has something to show.
///
/// TODO(calendar): replace with a real network/remote data source once the API
/// exists. Keep returning [CalendarEvent]s sorted by start time.
class CalendarLocalDataSource {
  const CalendarLocalDataSource();

  List<CalendarEvent> getEvents() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return <CalendarEvent>[
      CalendarEvent(
        id: 'evt-standup',
        title: 'Team standup',
        start: today.add(const Duration(hours: 9)),
        end: today.add(const Duration(hours: 9, minutes: 15)),
        location: 'Zoom',
        category: EventCategory.work,
        description: 'Daily sync with the product team.',
      ),
      CalendarEvent(
        id: 'evt-design-review',
        title: 'Design review',
        start: today.add(const Duration(hours: 11)),
        end: today.add(const Duration(hours: 12)),
        location: 'Studio B',
        category: EventCategory.work,
        description: 'Walk through the new calendar flows.',
      ),
      CalendarEvent(
        id: 'evt-lunch',
        title: 'Lunch with Sam',
        start: today.add(const Duration(hours: 13)),
        end: today.add(const Duration(hours: 14)),
        location: 'Riverside Cafe',
        category: EventCategory.social,
        description: 'Catch up over lunch.',
      ),
      CalendarEvent(
        id: 'evt-gym',
        title: 'Gym session',
        start: today.add(const Duration(days: 1, hours: 18)),
        end: today.add(const Duration(days: 1, hours: 19)),
        location: 'FitHub',
        category: EventCategory.health,
        description: 'Leg day.',
      ),
      CalendarEvent(
        id: 'evt-dentist',
        title: 'Dentist appointment',
        start: today.add(const Duration(days: 3, hours: 9)),
        end: today.add(const Duration(days: 3, hours: 9, minutes: 45)),
        location: 'Smile Clinic',
        category: EventCategory.health,
        description: 'Six month checkup.',
      ),
      CalendarEvent(
        id: 'evt-book-club',
        title: 'Book club',
        start: today.add(const Duration(days: 6, hours: 19)),
        end: today.add(const Duration(days: 6, hours: 20, minutes: 30)),
        location: 'Central Library',
        category: EventCategory.social,
        description: 'Discussing this month sci-fi picks.',
      ),
    ]..sort((a, b) => a.start.compareTo(b.start));
  }
}
