import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:calendar/core/di/injection.dart';
import 'package:calendar/core/error/failure.dart';
import 'package:calendar/core/usecase/usecase.dart';
import 'package:calendar/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:calendar/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:calendar/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:calendar/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:calendar/features/calendar/presentation/pages/calendar_page.dart';
import 'package:calendar/features/user/domain/entities/user.dart';
import 'package:calendar/main.dart';

class MockSignInUseCase extends Mock implements SignInUseCase {}

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

class MockRestoreSessionUseCase extends Mock implements RestoreSessionUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

void main() {
  late MockSignInUseCase signIn;
  late MockSignUpUseCase signUp;
  late MockRestoreSessionUseCase restoreSession;
  late MockSignOutUseCase signOut;

  setUp(() async {
    await getIt.reset();
    await configureDependencies();
    registerFallbackValue(const NoParams());

    signIn = MockSignInUseCase();
    signUp = MockSignUpUseCase();
    restoreSession = MockRestoreSessionUseCase();
    signOut = MockSignOutUseCase();

    when(() => restoreSession(any()))
        .thenAnswer((_) async => const Right<Failure, User?>(null));

    await getIt.unregister<AuthBloc>();
    getIt.registerFactory<AuthBloc>(
      () => AuthBloc(signIn, signUp, restoreSession, signOut),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('boots into the auth page', (tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign in'), findsWidgets);
  });

  testWidgets('signs in and lands on the calendar', (tester) async {
    const user = User(
      id: 'alex@example.com',
      name: 'Alex',
      handle: 'alex',
      bio: 'Pulse member',
    );
    when(() => signIn((email: 'alex@example.com', password: 'secret1')))
        .thenAnswer((_) async => const Right<Failure, User>(user));

    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'alex@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'secret1');
    await tester.pump();

    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.byType(CalendarPage), findsOneWidget);
    expect(find.text('Team standup'), findsOneWidget);
  });
}
