import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:calendar/core/usecase/usecase.dart';
import 'package:calendar/features/calendar/domain/usecases/get_events_usecase.dart';
import 'package:calendar/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:calendar/features/calendar/presentation/bloc/calendar_state.dart';

class CalendarBloc extends Bloc<CalendarBlocEvent, CalendarState> {
  CalendarBloc(this._getEvents) : super(CalendarState()) {
    on<CalendarStarted>(_onStarted);
    on<CalendarMonthChanged>(_onMonthChanged);
    on<CalendarDaySelected>(_onDaySelected);
  }

  final GetEventsUseCase _getEvents;

  Future<void> _onStarted(
    CalendarStarted event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(status: CalendarStatus.loading));

    final result = await _getEvents(const NoParams());

    result.match(
      (failure) => emit(
        state.copyWith(
          status: CalendarStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (events) => emit(
        state.copyWith(status: CalendarStatus.success, events: events),
      ),
    );
  }

  void _onMonthChanged(
    CalendarMonthChanged event,
    Emitter<CalendarState> emit,
  ) {
    emit(state.copyWith(focusedMonth: event.month));
  }

  void _onDaySelected(
    CalendarDaySelected event,
    Emitter<CalendarState> emit,
  ) {
    emit(state.copyWith(selectedDay: event.day, focusedMonth: event.day));
  }
}
