import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:calendar/core/error/failure.dart';
import 'package:calendar/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:calendar/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_event.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_state.dart';
import 'package:calendar/features/user/domain/entities/user.dart';

class MockSignInUseCase extends Mock implements SignInUseCase {}

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

void main() {
  const user = User(
    id: 'alex@example.com',
    name: 'Alex',
    handle: 'alex',
    bio: 'New to Pulse.',
  );

  late MockSignInUseCase signIn;
  late MockSignUpUseCase signUp;

  setUp(() {
    signIn = MockSignInUseCase();
    signUp = MockSignUpUseCase();
  });

  blocTest<AuthBloc, AuthState>(
    'emits submitting then success when sign in succeeds',
    build: () {
      when(() => signIn((email: 'alex@example.com', password: 'secret1')))
          .thenAnswer((_) async => const Right<Failure, User>(user));
      return AuthBloc(signIn, signUp);
    },
    act: (bloc) => bloc.add(
      const AuthSubmitted(
        name: '',
        email: 'alex@example.com',
        password: 'secret1',
      ),
    ),
    expect: () => [
      isA<AuthState>().having(
        (state) => state.status,
        'status',
        AuthStatus.submitting,
      ),
      isA<AuthState>()
          .having((state) => state.status, 'status', AuthStatus.success)
          .having((state) => state.user, 'user', user),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits submitting then failure with the use case message',
    build: () {
      when(() => signIn((email: 'alex@example.com', password: 'secret1')))
          .thenAnswer(
        (_) async => const Left<Failure, User>(
          ValidationFailure('Enter a valid email address.'),
        ),
      );
      return AuthBloc(signIn, signUp);
    },
    act: (bloc) => bloc.add(
      const AuthSubmitted(
        name: '',
        email: 'alex@example.com',
        password: 'secret1',
      ),
    ),
    expect: () => [
      isA<AuthState>().having(
        (state) => state.status,
        'status',
        AuthStatus.submitting,
      ),
      isA<AuthState>()
          .having((state) => state.status, 'status', AuthStatus.failure)
          .having(
            (state) => state.errorMessage,
            'errorMessage',
            'Enter a valid email address.',
          ),
    ],
  );
}
