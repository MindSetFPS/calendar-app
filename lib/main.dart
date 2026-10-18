import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:calendar/core/di/injection.dart';
import 'package:calendar/core/routing/app_routes.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:calendar/features/auth/presentation/pages/auth_page.dart';
import 'package:calendar/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:calendar/features/calendar/presentation/pages/calendar_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C4DF6)),
        useMaterial3: true,
      ),
      home: BlocProvider<AuthBloc>(
        create: (_) => getIt<AuthBloc>(),
        child: const AuthPage(),
      ),
      routes: {
        AppRoutes.home: (_) => BlocProvider<CalendarBloc>(
              create: (_) => getIt<CalendarBloc>(),
              child: const CalendarPage(),
            ),
      },
    );
  }
}
