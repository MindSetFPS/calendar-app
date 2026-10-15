import 'package:calendar/features/auth/presentation/bloc/auth_state.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class AuthModeChanged extends AuthEvent {
  const AuthModeChanged(this.mode);

  final AuthMode mode;
}

final class AuthPasswordVisibilityToggled extends AuthEvent {
  const AuthPasswordVisibilityToggled();
}

final class AuthSubmitted extends AuthEvent {
  const AuthSubmitted({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}
