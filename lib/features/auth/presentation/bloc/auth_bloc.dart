import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import 'package:calendar/core/error/failure.dart';
import 'package:calendar/core/usecase/usecase.dart';
import 'package:calendar/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:calendar/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:calendar/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:calendar/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_event.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_state.dart';
import 'package:calendar/features/user/domain/entities/user.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._signIn,
    this._signUp,
    this._restoreSession,
    this._signOut,
  ) : super(const AuthState()) {
    on<AuthSessionRequested>(_onSessionRequested);
    on<AuthModeChanged>(_onModeChanged);
    on<AuthPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<AuthSubmitted>(_onSubmitted);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  final SignInUseCase _signIn;
  final SignUpUseCase _signUp;
  final RestoreSessionUseCase _restoreSession;
  final SignOutUseCase _signOut;

  Future<void> _onSessionRequested(
    AuthSessionRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.checking, clearError: true));

    final result = await _restoreSession(const NoParams());

    result.match(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: failure.message,
          clearUser: true,
        ),
      ),
      (user) => emit(
        user == null
            ? state.copyWith(
                status: AuthStatus.unauthenticated,
                clearUser: true,
              )
            : state.copyWith(
                status: AuthStatus.authenticated,
                user: user,
                clearError: true,
              ),
      ),
    );
  }

  void _onModeChanged(AuthModeChanged event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        mode: event.mode,
        status: AuthStatus.unauthenticated,
        clearError: true,
      ),
    );
  }

  void _onPasswordVisibilityToggled(
    AuthPasswordVisibilityToggled event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  Future<void> _onSubmitted(
    AuthSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.submitting, clearError: true));

    final Either<Failure, User> result;
    if (state.mode == AuthMode.signIn) {
      result = await _signIn((email: event.email, password: event.password));
    } else {
      result = await _signUp((email: event.email, password: event.password));
    }

    result.match(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _signOut(const NoParams());
    emit(
      state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        clearError: true,
      ),
    );
  }
}
