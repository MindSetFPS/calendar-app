import 'package:flutter/material.dart';

import 'package:calendar/features/calendar/domain/entities/calendar_event.dart';

Color eventCategoryColor(EventCategory category) => switch (category) {
      EventCategory.work => const Color(0xFF6C4DF6),
      EventCategory.personal => const Color(0xFF2D9CDB),
      EventCategory.health => const Color(0xFF2BB673),
      EventCategory.social => const Color(0xFFEF5DA8),
      EventCategory.other => const Color(0xFFF2994A),
    };

IconData eventCategoryIcon(EventCategory category) => switch (category) {
      EventCategory.work => Icons.work_outline,
      EventCategory.personal => Icons.person_outline,
      EventCategory.health => Icons.favorite_border,
      EventCategory.social => Icons.people_outline,
      EventCategory.other => Icons.event_outlined,
    };

String eventCategoryLabel(EventCategory category) => switch (category) {
      EventCategory.work => 'Work',
      EventCategory.personal => 'Personal',
      EventCategory.health => 'Health',
      EventCategory.social => 'Social',
      EventCategory.other => 'Other',
    };
