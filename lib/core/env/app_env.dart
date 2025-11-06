import 'dart:developer' as developer;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration holder for Secure Task Manager.
///
/// - Loads `.env` file at startup (safe for local dev only).
/// - Exposes typed getters for base URLs, API keys, feature flags.
/// - Falls back to sane defaults if `.env` is missing (so the app still runs).
///
/// In production, you should **inject values at build time** instead of shipping a real `.env`
/// file with secrets.  Example (CI/CD):
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
    try {
      await dotenv.load(fileName: '.env');
      developer.log('✅ Loaded .env (${dotenv.env.length} entries)');
    } catch (_) {
      developer.log('⚠️ No .env file found, using defaults');
    }
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
  static String? get openAiApiKey => dotenv.env['OPENAI_API_KEY'];

  /// Whether the app is running in production.
  static bool get isProd => flavor == 'prod';

  /// Whether the app is running in development.
  static bool get isDev => flavor == 'dev';
}
