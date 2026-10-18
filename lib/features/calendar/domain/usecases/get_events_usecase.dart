import 'package:fpdart/fpdart.dart';

import 'package:calendar/core/error/failure.dart';
import 'package:calendar/core/usecase/usecase.dart';
import 'package:calendar/features/calendar/domain/entities/calendar_event.dart';
import 'package:calendar/features/calendar/domain/repositories/calendar_repository.dart';

class GetEventsUseCase implements UseCase<List<CalendarEvent>, NoParams> {
  const GetEventsUseCase(this._repository);

  final CalendarRepository _repository;

  @override
  Future<Either<Failure, List<CalendarEvent>>> call(NoParams params) =>
      _repository.getEvents();
}
