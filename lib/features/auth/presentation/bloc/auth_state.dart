import 'package:equatable/equatable.dart';

import 'package:calendar/features/user/domain/entities/user.dart';

enum AuthMode { signIn, signUp }

enum AuthStatus { idle, submitting, success, failure }

class AuthState extends Equatable {
  const AuthState({
    this.mode = AuthMode.signIn,
    this.status = AuthStatus.idle,
    this.obscurePassword = true,
    this.errorMessage,
    this.user,
  });

  final AuthMode mode;
  final AuthStatus status;
  final bool obscurePassword;
  final String? errorMessage;
  final User? user;

  AuthState copyWith({
    AuthMode? mode,
    AuthStatus? status,
    bool? obscurePassword,
    String? errorMessage,
    User? user,
  }) {
    return AuthState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [mode, status, obscurePassword, errorMessage, user];
}
