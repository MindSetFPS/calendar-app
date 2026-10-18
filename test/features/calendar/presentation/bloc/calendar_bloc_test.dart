import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:calendar/core/error/failure.dart';
import 'package:calendar/core/usecase/usecase.dart';
import 'package:calendar/features/calendar/domain/entities/calendar_event.dart';
import 'package:calendar/features/calendar/domain/usecases/get_events_usecase.dart';
import 'package:calendar/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:calendar/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:calendar/features/calendar/presentation/bloc/calendar_state.dart';

class MockGetEventsUseCase extends Mock implements GetEventsUseCase {}

void main() {
  final start = DateTime(2026, 10, 17, 9);
  final events = <CalendarEvent>[
    CalendarEvent(
      id: 'evt-standup',
      title: 'Team standup',
      start: start,
      end: start.add(const Duration(minutes: 15)),
    ),
  ];

  late MockGetEventsUseCase getEvents;

  setUp(() {
    getEvents = MockGetEventsUseCase();
    registerFallbackValue(const NoParams());
  });

  blocTest<CalendarBloc, CalendarState>(
    'emits loading then success with the events',
    build: () {
      when(() => getEvents(any()))
          .thenAnswer((_) async => Right<Failure, List<CalendarEvent>>(events));
      return CalendarBloc(getEvents);
    },
    act: (bloc) => bloc.add(const CalendarStarted()),
    expect: () => [
      isA<CalendarState>().having(
        (state) => state.status,
        'status',
        CalendarStatus.loading,
      ),
      isA<CalendarState>()
          .having((state) => state.status, 'status', CalendarStatus.success)
          .having((state) => state.events, 'events', events),
    ],
  );

  blocTest<CalendarBloc, CalendarState>(
    'emits loading then failure with the use case message',
    build: () {
      when(() => getEvents(any())).thenAnswer(
        (_) async => const Left<Failure, List<CalendarEvent>>(
          CacheFailure('Could not load your events.'),
        ),
      );
      return CalendarBloc(getEvents);
    },
    act: (bloc) => bloc.add(const CalendarStarted()),
    expect: () => [
      isA<CalendarState>().having(
        (state) => state.status,
        'status',
        CalendarStatus.loading,
      ),
      isA<CalendarState>()
          .having((state) => state.status, 'status', CalendarStatus.failure)
          .having(
            (state) => state.errorMessage,
            'errorMessage',
            'Could not load your events.',
          ),
    ],
  );

  blocTest<CalendarBloc, CalendarState>(
    'updates the focused month when the month changes',
    build: () => CalendarBloc(getEvents),
    act: (bloc) => bloc.add(CalendarMonthChanged(DateTime(2026, 11))),
    expect: () => [
      isA<CalendarState>().having(
        (state) => state.focusedMonth,
        'focusedMonth',
        DateTime(2026, 11),
      ),
    ],
  );

  blocTest<CalendarBloc, CalendarState>(
    'updates the selected day when a day is selected',
    build: () => CalendarBloc(getEvents),
    act: (bloc) => bloc.add(CalendarDaySelected(DateTime(2026, 10, 20))),
    expect: () => [
      isA<CalendarState>().having(
        (state) => state.selectedDay,
        'selectedDay',
        DateTime(2026, 10, 20),
      ),
    ],
  );
}
