import 'package:fpdart/fpdart.dart';

import 'package:calendar/core/error/failure.dart';
import 'package:calendar/core/usecase/usecase.dart';
import 'package:calendar/features/auth/domain/repositories/auth_repository.dart';
import 'package:calendar/features/user/domain/entities/user.dart';

typedef SignUpParams = ({String name, String email, String password});

class SignUpUseCase implements UseCase<User, SignUpParams> {
  const SignUpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(SignUpParams params) {
    final name = params.name.trim();
    if (name.isEmpty) {
      return Future.value(
        const Left<Failure, User>(ValidationFailure('Enter your name.')),
      );
    }
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
    return _repository.signUp(
      name: name,
      email: email,
      password: params.password,
    );
  }
}
