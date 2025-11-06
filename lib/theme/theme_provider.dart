import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:secure_task_manager/main.dart';

final _themeKey = 'theme_mode';
final _accentKey = 'accent_color';

/// Provides and manages the current [ThemeMode] of the application.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

/// A [Notifier] that controls the [ThemeMode] of the application.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  late SharedPreferences _prefs;

  @override
  ThemeMode build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    final stored = _prefs.getString(_themeKey);
    if (stored != null) {
      return ThemeMode.values.firstWhere((e) => e.toString() == stored,
          orElse: () => ThemeMode.system);
    }
    return ThemeMode.system;
  }

  /// Sets the current [ThemeMode] and persists it.
  void setMode(ThemeMode m) {
    state = m;
    _prefs.setString(_themeKey, m.toString());
  }
}

/// Provides and manages the accent color of the application.
final accentColorProvider = NotifierProvider<AccentColorNotifier, int>(
  AccentColorNotifier.new,
);

/// A [Notifier] that controls the accent color of the application.
class AccentColorNotifier extends Notifier<int> {
  late SharedPreferences _prefs;

  @override
  int build() {
    _prefs = ref.watch(sharedPreferencesProvider);
    final stored = _prefs.getInt(_accentKey);
    return stored ?? 0xFF00897B;
  }

  /// Sets the current accent [Color] and persists it.
  void setAccent(Color c) {
    // ignore: deprecated_member_use
    state = c.value;
    _prefs.setInt(_accentKey, state);
  }
}
