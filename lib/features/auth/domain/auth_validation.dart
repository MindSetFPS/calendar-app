final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

const int passwordMinLength = 12;
const int passwordMaxLength = 128;

String? emailValidationError(String value) {
  final email = value.trim();
  if (email.isEmpty) {
    return 'Enter your email address.';
  }
  if (email.length > 254) {
    return 'That email address is too long.';
  }
  if (!_emailPattern.hasMatch(email)) {
    return 'Enter a valid email address.';
  }
  return null;
}

String? signInPasswordError(String value) {
  if (value.isEmpty) {
    return 'Enter your password.';
  }
  if (value.length > passwordMaxLength) {
    return 'Password must be at most $passwordMaxLength characters.';
  }
  return null;
}

/// Password policy mirrored from `app/schemas/user.py`.
List<({String label, bool met})> passwordRequirements(String value) {
  return [
    (
      label: '$passwordMinLength–$passwordMaxLength characters',
      met: value.length >= passwordMinLength && value.length <= passwordMaxLength,
    ),
    (
      label: 'An uppercase letter',
      met: value.contains(RegExp(r'[A-Z]')),
    ),
    (
      label: 'A lowercase letter',
      met: value.contains(RegExp(r'[a-z]')),
    ),
    (
      label: 'A number',
      met: value.contains(RegExp(r'[0-9]')),
    ),
    (
      label: 'A symbol',
      met: value.contains(RegExp(r'[^A-Za-z0-9]')),
    ),
  ];
}

String? signUpPasswordError(String value) {
  if (value.isEmpty) {
    return 'Enter a password.';
  }
  if (passwordRequirements(value).every((requirement) => requirement.met)) {
    return null;
  }
  return 'Password must be $passwordMinLength–$passwordMaxLength characters '
      'long and include an uppercase letter, a lowercase letter, a number '
      'and a symbol.';
}
