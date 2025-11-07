import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:shared_preferences/shared_preferences.dart';
import 'core/env/app_env.dart';
import 'app.dart';
import 'firebase_options.dart';

/// Provides an instance of [SharedPreferences] for the application.
final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

Future<SharedPreferences> _initializeDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Initialize environment
  await AppEnv.init();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  return await SharedPreferences.getInstance();
}

Future<void> main() async {
  final sharedPreferences = await _initializeDependencies();

  runApp(ProviderScope(overrides: [
    sharedPreferencesProvider.overrideWithValue(sharedPreferences),
  ], child: const App()));
}
