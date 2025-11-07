/// Configuration class for application-wide settings.
class AppConfig {
  // compile-time variables injected with --dart-define
  /// Firebase API key.
  static const String firebaseApiKey =
      String.fromEnvironment('FIREBASE_API_KEY', defaultValue: '');

  /// Firebase Project ID.
  static const String firebaseProjectId =
      String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: '');

  /// Firebase App ID.
  static const String firebaseAppId =
      String.fromEnvironment('FIREBASE_APP_ID', defaultValue: '');
  // Add other keys as needed
}
