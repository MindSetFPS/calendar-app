import 'package:fpdart/fpdart.dart';

import 'package:calendar/core/error/failure.dart';
import 'package:calendar/core/usecase/usecase.dart';
import 'package:calendar/features/auth/domain/auth_validation.dart';
import 'package:calendar/features/auth/domain/repositories/auth_repository.dart';
import 'package:calendar/features/user/domain/entities/user.dart';

typedef SignUpParams = ({String email, String password});

class SignUpUseCase implements UseCase<User, SignUpParams> {
  const SignUpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(SignUpParams params) {
    final email = params.email.trim();
    final emailError = emailValidationError(email);
    if (emailError != null) {
      return Future.value(Left<Failure, User>(ValidationFailure(emailError)));
    }
    final passwordError = signUpPasswordError(params.password);
    if (passwordError != null) {
      return Future.value(Left<Failure, User>(ValidationFailure(passwordError)));
    }
    return _repository.signUp(email: email, password: params.password);
  }
}
