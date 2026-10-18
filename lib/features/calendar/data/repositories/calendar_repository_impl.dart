import 'package:fpdart/fpdart.dart';

import 'package:calendar/core/error/failure.dart';
import 'package:calendar/features/calendar/data/datasources/calendar_local_data_source.dart';
import 'package:calendar/features/calendar/domain/entities/calendar_event.dart';
import 'package:calendar/features/calendar/domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  const CalendarRepositoryImpl(this._localDataSource);

  final CalendarLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<CalendarEvent>>> getEvents() async {
    try {
      return Right(_localDataSource.getEvents());
    } catch (_) {
      return const Left(CacheFailure('Could not load your events.'));
    }
  }
}
