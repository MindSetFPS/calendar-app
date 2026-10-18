import 'package:flutter/material.dart';

import 'package:calendar/features/calendar/domain/entities/calendar_event.dart';
import 'package:calendar/features/calendar/presentation/calendar_format.dart';
import 'package:calendar/features/calendar/presentation/event_category_style.dart';

class EventListTile extends StatelessWidget {
  const EventListTile({super.key, required this.event, required this.onTap});

  final CalendarEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = eventCategoryColor(event.category);
    final subtitle = event.location.trim().isEmpty
        ? formatTimeRange(event.start, event.end)
        : '${formatTimeRange(event.start, event.end)} · ${event.location}';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(eventCategoryIcon(event.category), color: color),
        ),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
