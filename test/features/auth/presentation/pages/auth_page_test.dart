import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:calendar/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:calendar/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:calendar/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:calendar/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:calendar/features/auth/presentation/pages/auth_page.dart';

class MockSignInUseCase extends Mock implements SignInUseCase {}

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

class MockRestoreSessionUseCase extends Mock implements RestoreSessionUseCase {}

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

void main() {
  late MockSignInUseCase signIn;
  late MockSignUpUseCase signUp;
  late MockRestoreSessionUseCase restoreSession;
  late MockSignOutUseCase signOut;

  setUp(() {
    signIn = MockSignInUseCase();
    signUp = MockSignUpUseCase();
    restoreSession = MockRestoreSessionUseCase();
    signOut = MockSignOutUseCase();
  });

  Widget wrap() => MaterialApp(
        home: BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(signIn, signUp, restoreSession, signOut),
          child: const AuthPage(),
        ),
      );

  testWidgets('starts on the sign in view', (tester) async {
    await tester.pumpWidget(wrap());

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('Full name'), findsNothing);
  });

  testWidgets('switches to the sign up view', (tester) async {
    await tester.pumpWidget(wrap());

    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    expect(find.text('Create your account'), findsOneWidget);
    expect(find.text('Forgot password?'), findsNothing);
    expect(find.text('12–128 characters'), findsOneWidget);
    expect(find.text('An uppercase letter'), findsOneWidget);
    expect(find.text('A symbol'), findsOneWidget);
  });

  testWidgets('validates the email and shows the password checklist',
      (tester) async {
    await tester.pumpWidget(wrap());

    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'not-an-email');
    await tester.enterText(find.byType(TextField).at(1), 'short');
    await tester.pump();

    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(find.text('12–128 characters'), findsOneWidget);
    expect(find.text('An uppercase letter'), findsOneWidget);
    expect(find.text('A symbol'), findsOneWidget);
  });
}
