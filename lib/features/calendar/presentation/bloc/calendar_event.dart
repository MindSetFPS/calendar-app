sealed class CalendarBlocEvent {
  const CalendarBlocEvent();
}

final class CalendarStarted extends CalendarBlocEvent {
  const CalendarStarted();
}

final class CalendarMonthChanged extends CalendarBlocEvent {
  const CalendarMonthChanged(this.month);

  final DateTime month;
}

final class CalendarDaySelected extends CalendarBlocEvent {
  const CalendarDaySelected(this.day);

  final DateTime day;
}
