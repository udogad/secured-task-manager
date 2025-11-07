import 'dart:developer' as developer;

/// Environment configuration holder for Secure Task Manager.
///
/// - Exposes typed getters for base URLs, API keys, feature flags.
///
/// In production, you should **inject values at build time**.
/// Example (CI/CD):
///
///   flutter build apk --dart-define=API_BASE_URL=https://api.prod.example.com
///   flutter build web --dart-define=FLAVOR=prod
///
///   Then access them via: const String.fromEnvironment('API_BASE_URL')
class AppEnv {
  static bool _initialized = false;

  /// Initialize environment — must be called before runApp().
  static Future<void> init() async {
    if (_initialized) return;
    // In the future, we might have async initialization here.
    // For now, it's a no-op.
    developer.log('✅ AppEnv initialized');
    _initialized = true;
  }

  /// The current environment (e.g., dev, staging, prod).
  static String get flavor =>
      const String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  /// The base URL for the API.
  static String get apiBaseUrl => const String.fromEnvironment('API_BASE_URL',
      defaultValue: String.fromEnvironment('API_FALLBACK_URL',
          defaultValue: 'https://api.local.dev'));

  /// Whether to use Firebase for authentication and other services.
  static bool get useFirebase =>
      const bool.fromEnvironment('USE_FIREBASE', defaultValue: false);

  /// Whether to enable analytics.
  static bool get enableAnalytics =>
      const bool.fromEnvironment('ENABLE_ANALYTICS', defaultValue: false);

  /// The OpenAI API key.
  static String? get openAiApiKey =>
      const String.fromEnvironment('OPENAI_API_KEY');

  // Firebase
  /// The Firebase API key.
  static String get firebaseApiKey =>
      const String.fromEnvironment('FIREBASE_API_KEY');

  /// The Firebase Auth domain.
  static String get firebaseAuthDomain =>
      const String.fromEnvironment('FIREBASE_AUTH_DOMAIN');

  /// The Firebase project ID.
  static String get firebaseProjectId =>
      const String.fromEnvironment('FIREBASE_PROJECT_ID');

  /// The Firebase storage bucket.
  static String get firebaseStorageBucket =>
      const String.fromEnvironment('FIREBASE_STORAGE_BUCKET');

  /// The Firebase messaging sender ID.
  static String get firebaseMessagingSenderId =>
      const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');

  /// The Firebase App ID.
  static String get firebaseAppId =>
      const String.fromEnvironment('FIREBASE_APP_ID');

  /// The Firebase measurement ID.
  static String get firebaseMeasurementId =>
      const String.fromEnvironment('FIREBASE_MEASUREMENT_ID');

  /// Whether the app is running in production.
  static bool get isProd => flavor == 'prod';

  /// Whether the app is running in development.
  static bool get isDev => flavor == 'dev';
}
