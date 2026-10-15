import 'package:fpdart/fpdart.dart';

import 'package:calendar/core/error/failure.dart';
import 'package:calendar/features/user/data/datasources/user_local_data_source.dart';
import 'package:calendar/features/user/domain/entities/user.dart';
import 'package:calendar/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this._localDataSource);

  final UserLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      return Right(_localDataSource.getCurrentUser());
    } catch (_) {
      return const Left(CacheFailure('Could not load your profile.'));
    }
  }
}
