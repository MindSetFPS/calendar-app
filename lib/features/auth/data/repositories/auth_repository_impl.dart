import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

import 'package:calendar/core/error/failure.dart';
import 'package:calendar/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:calendar/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:calendar/features/auth/domain/repositories/auth_repository.dart';
import 'package:calendar/features/user/domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );
      await _localDataSource.saveToken(session.accessToken);
      return Right(session.user);
    } on AuthApiException catch (error) {
      return Left(_failureFrom(error));
    } catch (error, stackTrace) {
      debugPrint('Auth sign-in error: $error\n$stackTrace');
      return const Left(UnexpectedFailure('Could not sign you in.'));
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _remoteDataSource.signUp(
        email: email,
        password: password,
      );
      await _localDataSource.saveToken(session.accessToken);
      return Right(session.user);
    } on AuthApiException catch (error) {
      return Left(_failureFrom(error));
    } catch (error, stackTrace) {
      debugPrint('Auth sign-up error: $error\n$stackTrace');
      return const Left(UnexpectedFailure('Could not create your account.'));
    }
  }

  @override
  Future<Either<Failure, User?>> restoreSession() async {
    try {
      final token = await _localDataSource.readToken();
      if (token == null || token.isEmpty) {
        return const Right(null);
      }
      final user = await _remoteDataSource.currentUser(token);
      return Right(user);
    } on AuthApiException catch (error) {
      if (error.statusCode == 401 || error.statusCode == 403) {
        await _localDataSource.clearToken();
        return const Right(null);
      }
      return Left(_failureFrom(error));
    } catch (error, stackTrace) {
      debugPrint('Auth session restore error: $error\n$stackTrace');
      return const Left(UnexpectedFailure('Could not restore your session.'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      // The backend uses stateless JWTs and exposes no logout endpoint, so
      // logging out means discarding the token on this device.
      await _localDataSource.clearToken();
      return const Right(null);
    } catch (error, stackTrace) {
      debugPrint('Auth sign-out error: $error\n$stackTrace');
      return const Left(UnexpectedFailure('Could not log you out.'));
    }
  }

  Failure _failureFrom(AuthApiException error) {
    switch (error.statusCode) {
      case null:
        return NetworkFailure(error.message);
      case 401:
        return const AuthFailure(
          'Incorrect email or password.',
          statusCode: 401,
        );
      case 403:
        return const AuthFailure(
          'This account is disabled.',
          statusCode: 403,
        );
      case 409:
        return const AuthFailure(
          'An account with this email already exists.',
          statusCode: 409,
        );
      case 422:
        return const AuthFailure(
          'Check your details and try again.',
          statusCode: 422,
        );
      default:
        return AuthFailure(error.message, statusCode: error.statusCode);
    }
  }
}
