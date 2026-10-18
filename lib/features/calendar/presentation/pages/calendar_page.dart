import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:calendar/features/calendar/domain/entities/calendar_event.dart';
import 'package:calendar/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:calendar/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:calendar/features/calendar/presentation/bloc/calendar_state.dart';
import 'package:calendar/features/calendar/presentation/calendar_format.dart';
import 'package:calendar/features/calendar/presentation/pages/event_details_page.dart';
import 'package:calendar/features/calendar/presentation/widgets/event_list_tile.dart';
import 'package:calendar/features/calendar/presentation/widgets/month_grid.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
    context.read<CalendarBloc>().add(const CalendarStarted());
  }

  void _openEvent(CalendarEvent event) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => EventDetailsPage(event: event)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pulse')),
      body: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          switch (state.status) {
            case CalendarStatus.initial:
            case CalendarStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case CalendarStatus.failure:
              return Center(
                child: Text(
                  state.errorMessage ?? 'Something went wrong.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              );
            case CalendarStatus.success:
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _MonthHeader(
                      month: state.focusedMonth,
                      onPrevious: () => context.read<CalendarBloc>().add(
                            CalendarMonthChanged(
                              _addMonths(state.focusedMonth, -1),
                            ),
                          ),
                      onNext: () => context.read<CalendarBloc>().add(
                            CalendarMonthChanged(
                              _addMonths(state.focusedMonth, 1),
                            ),
                          ),
                    ),
                    MonthGrid(
                      focusedMonth: state.focusedMonth,
                      selectedDay: state.selectedDay,
                      hasEventsOn: state.hasEventsOn,
                      onDaySelected: (day) => context.read<CalendarBloc>().add(
                            CalendarDaySelected(day),
                          ),
                    ),
                    const Divider(height: 32),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        formatDayLabel(state.selectedDay),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    if (state.eventsForSelectedDay.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'No events scheduled.',
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      for (final event in state.eventsForSelectedDay)
                        EventListTile(
                          event: event,
                          onTap: () => _openEvent(event),
                        ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}

DateTime _addMonths(DateTime month, int delta) =>
    DateTime(month.year, month.month + delta);

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left),
          tooltip: 'Previous month',
        ),
        Expanded(
          child: Text(
            formatMonthYear(month),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
          tooltip: 'Next month',
        ),
      ],
    );
  }
}
