import 'package:flutter/material.dart';

import 'package:calendar/features/user/domain/entities/user.dart';
import 'package:calendar/features/user/presentation/avatar_palette.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.user, this.radius = 20});

  final User user;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: avatarColorFor(user),
      child: Text(
        user.initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }
}
