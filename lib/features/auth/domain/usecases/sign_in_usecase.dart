import 'package:fpdart/fpdart.dart';

import 'package:calendar/core/error/failure.dart';
import 'package:calendar/core/usecase/usecase.dart';
import 'package:calendar/features/auth/domain/repositories/auth_repository.dart';
import 'package:calendar/features/user/domain/entities/user.dart';

typedef SignInParams = ({String email, String password});

class SignInUseCase implements UseCase<User, SignInParams> {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(SignInParams params) {
    final email = params.email.trim();
    if (email.length < 3 || !email.contains('@')) {
      return Future.value(
        const Left<Failure, User>(
          ValidationFailure('Enter a valid email address.'),
        ),
      );
    }
    if (params.password.length < 6) {
      return Future.value(
        const Left<Failure, User>(
          ValidationFailure('Password must be at least 6 characters.'),
        ),
      );
    }
    return _repository.signIn(email: email, password: params.password);
  }
}
