import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import 'package:calendar/core/error/failure.dart';
import 'package:calendar/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:calendar/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_event.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_state.dart';
import 'package:calendar/features/user/domain/entities/user.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._signIn, this._signUp) : super(const AuthState()) {
    on<AuthModeChanged>(_onModeChanged);
    on<AuthPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<AuthSubmitted>(_onSubmitted);
  }

  final SignInUseCase _signIn;
  final SignUpUseCase _signUp;

  void _onModeChanged(AuthModeChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(mode: event.mode, status: AuthStatus.idle));
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
    emit(state.copyWith(status: AuthStatus.submitting));

    final Either<Failure, User> result;
    if (state.mode == AuthMode.signIn) {
      result = await _signIn((email: event.email, password: event.password));
    } else {
      result = await _signUp(
        (name: event.name, email: event.email, password: event.password),
      );
    }

    result.match(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(state.copyWith(status: AuthStatus.success, user: user)),
    );
  }
}
