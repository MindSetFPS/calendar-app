import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:calendar/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:calendar/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:calendar/features/auth/presentation/pages/auth_page.dart';

class MockSignInUseCase extends Mock implements SignInUseCase {}

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

void main() {
  late MockSignInUseCase signIn;
  late MockSignUpUseCase signUp;

  setUp(() {
    signIn = MockSignInUseCase();
    signUp = MockSignUpUseCase();
  });

  Widget wrap() => MaterialApp(
        home: BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(signIn, signUp),
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
    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('Forgot password?'), findsNothing);
  });
}
