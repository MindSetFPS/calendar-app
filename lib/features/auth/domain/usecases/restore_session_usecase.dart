import 'package:fpdart/fpdart.dart';

import 'package:calendar/core/error/failure.dart';
import 'package:calendar/core/usecase/usecase.dart';
import 'package:calendar/features/auth/domain/repositories/auth_repository.dart';
import 'package:calendar/features/user/domain/entities/user.dart';

class RestoreSessionUseCase implements UseCase<User?, NoParams> {
  const RestoreSessionUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User?>> call(NoParams params) =>
      _repository.restoreSession();
}
