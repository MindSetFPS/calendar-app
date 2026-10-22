import 'package:fpdart/fpdart.dart';

import 'package:calendar/core/error/failure.dart';
import 'package:calendar/features/user/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
  });

  /// Returns the persisted session, or `null` when there is no valid token.
  Future<Either<Failure, User?>> restoreSession();

  Future<Either<Failure, void>> signOut();
}
