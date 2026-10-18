import 'package:fpdart/fpdart.dart';

import 'package:calendar/core/error/failure.dart';
import 'package:calendar/features/calendar/domain/entities/calendar_event.dart';

abstract interface class CalendarRepository {
  Future<Either<Failure, List<CalendarEvent>>> getEvents();
}
