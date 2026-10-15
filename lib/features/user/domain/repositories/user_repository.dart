import 'package:fpdart/fpdart.dart';

import 'package:calendar/core/error/failure.dart';
import 'package:calendar/features/user/domain/entities/user.dart';

abstract interface class UserRepository {
  Future<Either<Failure, User>> getCurrentUser();
}
