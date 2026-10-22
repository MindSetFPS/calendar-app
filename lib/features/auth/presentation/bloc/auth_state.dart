import 'package:equatable/equatable.dart';

import 'package:calendar/features/user/domain/entities/user.dart';

enum AuthMode { signIn, signUp }

enum AuthStatus {
  checking,
  unauthenticated,
  submitting,
  authenticated,
  failure,
}

class AuthState extends Equatable {
  const AuthState({
    this.mode = AuthMode.signIn,
    this.status = AuthStatus.checking,
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
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      mode: mode ?? this.mode,
      status: status ?? this.status,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      user: clearUser ? null : (user ?? this.user),
    );
  }

  @override
  List<Object?> get props => [mode, status, obscurePassword, errorMessage, user];
}
