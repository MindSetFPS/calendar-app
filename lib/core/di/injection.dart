import 'package:get_it/get_it.dart';

import 'package:calendar/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:calendar/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:calendar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:calendar/features/auth/domain/repositories/auth_repository.dart';
import 'package:calendar/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:calendar/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:calendar/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:calendar/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:calendar/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:calendar/features/calendar/data/datasources/calendar_local_data_source.dart';
import 'package:calendar/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:calendar/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:calendar/features/calendar/domain/usecases/get_events_usecase.dart';
import 'package:calendar/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:calendar/features/user/data/datasources/user_local_data_source.dart';
import 'package:calendar/features/user/data/repositories/user_repository_impl.dart';
import 'package:calendar/features/user/domain/repositories/user_repository.dart';
import 'package:calendar/features/user/domain/usecases/get_current_user_usecase.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt
    ..registerLazySingleton<UserLocalDataSource>(UserLocalDataSource.new)
    ..registerLazySingleton<AuthLocalDataSource>(AuthLocalDataSource.new)
    ..registerLazySingleton<AuthRemoteDataSource>(AuthRemoteDataSource.new)
    ..registerLazySingleton<CalendarLocalDataSource>(
      CalendarLocalDataSource.new,
    )
    ..registerLazySingleton<UserRepository>(() => UserRepositoryImpl(getIt()))
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getIt(), getIt()),
    )
    ..registerLazySingleton<CalendarRepository>(
      () => CalendarRepositoryImpl(getIt()),
    )
    ..registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(getIt()),
    )
    ..registerLazySingleton<SignInUseCase>(() => SignInUseCase(getIt()))
    ..registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(getIt()))
    ..registerLazySingleton<RestoreSessionUseCase>(
      () => RestoreSessionUseCase(getIt()),
    )
    ..registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(getIt()))
    ..registerLazySingleton<GetEventsUseCase>(() => GetEventsUseCase(getIt()))
    ..registerFactory<AuthBloc>(
      () => AuthBloc(getIt(), getIt(), getIt(), getIt()),
    )
    ..registerFactory<CalendarBloc>(() => CalendarBloc(getIt()));
}
