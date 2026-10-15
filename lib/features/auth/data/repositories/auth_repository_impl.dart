import 'package:fpdart/fpdart.dart';

import 'package:calendar/core/error/failure.dart';
import 'package:calendar/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:calendar/features/auth/domain/repositories/auth_repository.dart';
import 'package:calendar/features/user/domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._localDataSource);

  final AuthLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return Right<Failure, User>(
        _localDataSource.signIn(email: email, password: password),
      );
    } catch (_) {
      return const Left<Failure, User>(
        UnexpectedFailure('Could not sign you in.'),
      );
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      return Right<Failure, User>(
        _localDataSource.signUp(name: name, email: email, password: password),
      );
    } catch (_) {
      return const Left<Failure, User>(
        UnexpectedFailure('Could not create your account.'),
      );
    }
  }
}
