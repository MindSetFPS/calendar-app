abstract final class ApiConfig {
  /// Override with:
  /// `flutter run --dart-define=API_BASE_URL=http://<host>:8000/api/v1`
  static const String baseUrl = String.fromEnvironment(
    '',
    defaultValue: 'http://192.168.1.64:8000/api/v1',
  );
}
