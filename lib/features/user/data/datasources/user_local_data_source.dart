import 'package:calendar/features/user/domain/entities/user.dart';

class UserLocalDataSource {
  const UserLocalDataSource();

  static const User currentUser = User(
    id: 'me',
    name: 'Alex Morgan',
    handle: 'alexmorgan',
    bio: 'Product designer ✨ Coffee, code and long city walks.',
    followers: 1284,
    following: 342,
  );

  User getCurrentUser() => currentUser;
}
