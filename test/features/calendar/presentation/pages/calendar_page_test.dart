import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:calendar/core/error/failure.dart';
import 'package:calendar/core/usecase/usecase.dart';
import 'package:calendar/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:calendar/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:calendar/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:calendar/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:calendar/features/calendar/domain/entities/calendar_event.dart';
import 'package:calendar/features/calendar/domain/usecases/get_events_usecase.dart';
import 'package:calendar/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:calendar/features/calendar/presentation/pages/calendar_page.dart';
import 'package:calendar/features/calendar/presentation/pages/event_details_page.dart';

class MockGetEventsUseCase extends Mock implements GetEventsUseCase {}

class MockSignInUseCase extends Mock implements SignInUseCase {}

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

class MockRestoreSessionUseCase extends Mock implements RestoreSessionUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

void main() {
  late MockGetEventsUseCase getEvents;
  late AuthBloc authBloc;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final events = <CalendarEvent>[
    CalendarEvent(
      id: 'evt-standup',
      title: 'Team standup',
      start: today.add(const Duration(hours: 9)),
      end: today.add(const Duration(hours: 9, minutes: 15)),
      location: 'Zoom',
      category: EventCategory.work,
      description: 'Daily sync with the product team.',
    ),
  ];

  setUp(() {
    getEvents = MockGetEventsUseCase();
    authBloc = AuthBloc(
      MockSignInUseCase(),
      MockSignUpUseCase(),
      MockRestoreSessionUseCase(),
      MockSignOutUseCase(),
    );
    registerFallbackValue(const NoParams());
    when(() => getEvents(any()))
        .thenAnswer((_) async => Right<Failure, List<CalendarEvent>>(events));
  });

  Widget wrap() => MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<CalendarBloc>(
            create: (_) => CalendarBloc(getEvents),
          ),
        ],
        child: const MaterialApp(home: CalendarPage()),
      );

  testWidgets('opens the event details when an event is tapped', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Team standup'), findsOneWidget);

    await tester.ensureVisible(find.text('Team standup'));
    await tester.tap(find.text('Team standup'));
    await tester.pumpAndSettle();

    expect(find.byType(EventDetailsPage), findsOneWidget);
    expect(find.text('Daily sync with the product team.'), findsOneWidget);
    expect(find.text('Zoom'), findsOneWidget);
  });
}
