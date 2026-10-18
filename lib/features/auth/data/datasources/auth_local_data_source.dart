import 'package:calendar/features/user/domain/entities/user.dart';

/// Placeholder for the authentication process.
///
/// There is no backend yet, so [signIn] and [signUp] do not contact a server:
/// they fabricate a [User] from the submitted details so the rest of the flow
/// (use cases, repository, BLoC, navigation) can be exercised end to end.
///
/// TODO(auth): replace the bodies below with real network calls once the API
/// exists. The signatures and the returned [User] should stay the same so the
/// layers above do not change.
class AuthLocalDataSource {
  const AuthLocalDataSource();

  User signIn({required String email, required String password}) => _userFrom(
        email: email,
        name: _nameFromEmail(email),
        bio: 'Signed in to Pulse.',
      );

  User signUp({
    required String name,
    required String email,
    required String password,
  }) =>
      _userFrom(email: email, name: name, bio: 'New to Pulse.');

  User _userFrom({
    required String email,
    required String name,
    required String bio,
  }) =>
      User(
        id: email,
        name: name,
        handle: _handleFromEmail(email),
        bio: bio,
      );

  String _handleFromEmail(String email) {
    final local = email.split('@').first;
    final sanitized = local.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '');
    return sanitized.isEmpty ? 'pulseuser' : sanitized;
  }

  String _nameFromEmail(String email) {
    final parts = email
        .split('@')
        .first
        .split(RegExp(r'[._\-]+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'Pulse User';
    return parts
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }
}
