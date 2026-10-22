import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:calendar/core/di/injection.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_state.dart';
import 'package:calendar/features/auth/presentation/pages/auth_page.dart';
import 'package:calendar/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:calendar/features/calendar/presentation/pages/calendar_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.checking:
            return const _Splash();
          case AuthStatus.authenticated:
            return BlocProvider<CalendarBloc>(
              create: (_) => getIt<CalendarBloc>(),
              child: const CalendarPage(),
            );
          case AuthStatus.unauthenticated:
          case AuthStatus.submitting:
          case AuthStatus.failure:
            return const AuthPage();
        }
      },
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
