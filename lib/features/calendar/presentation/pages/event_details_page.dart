import 'package:flutter/material.dart';

import 'package:calendar/features/calendar/domain/entities/calendar_event.dart';
import 'package:calendar/features/calendar/presentation/calendar_format.dart';
import 'package:calendar/features/calendar/presentation/event_category_style.dart';

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({super.key, required this.event});

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = eventCategoryColor(event.category);

    return Scaffold(
      appBar: AppBar(title: const Text('Event')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: color.withValues(alpha: 0.2),
                  child: Icon(
                    eventCategoryIcon(event.category),
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  event.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(eventCategoryLabel(event.category)),
                  avatar: Icon(
                    eventCategoryIcon(event.category),
                    size: 18,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _DetailRow(
            icon: Icons.schedule,
            label: '${formatDayLabel(event.start)}\n'
                '${formatTimeRange(event.start, event.end)}',
          ),
          if (event.location.trim().isNotEmpty)
            _DetailRow(icon: Icons.place_outlined, label: event.location),
          if (event.description.trim().isNotEmpty)
            _DetailRow(icon: Icons.notes_outlined, label: event.description),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.onSurfaceVariant),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
