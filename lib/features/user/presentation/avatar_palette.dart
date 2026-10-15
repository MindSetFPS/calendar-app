import 'package:flutter/material.dart';

import 'package:calendar/features/user/domain/entities/user.dart';

const List<Color> _avatarPalette = [
  Color(0xFF6C4DF6),
  Color(0xFFEF5DA8),
  Color(0xFF2BB673),
  Color(0xFFF2994A),
  Color(0xFF2D9CDB),
  Color(0xFF9B51E0),
];

Color avatarColorFor(User user) =>
    _avatarPalette[user.id.hashCode.abs() % _avatarPalette.length];
