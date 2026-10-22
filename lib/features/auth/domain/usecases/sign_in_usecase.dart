import 'package:fpdart/fpdart.dart';

import 'package:calendar/core/error/failure.dart';
import 'package:calendar/core/usecase/usecase.dart';
import 'package:calendar/features/auth/domain/auth_validation.dart';
import 'package:calendar/features/auth/domain/repositories/auth_repository.dart';
import 'package:calendar/features/user/domain/entities/user.dart';

typedef SignInParams = ({String email, String password});

class SignInUseCase implements UseCase<User, SignInParams> {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(SignInParams params) {
    final email = params.email.trim();
    final emailError = emailValidationError(email);
    if (emailError != null) {
      return Future.value(Left<Failure, User>(ValidationFailure(emailError)));
    }
    final passwordError = signInPasswordError(params.password);
    if (passwordError != null) {
      return Future.value(Left<Failure, User>(ValidationFailure(passwordError)));
    }
    return _repository.signIn(email: email, password: params.password);
  }
}
