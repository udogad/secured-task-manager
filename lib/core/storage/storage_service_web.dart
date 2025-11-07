import 'package:shared_preferences/shared_preferences.dart';

/// An abstract class for storage operations.
abstract class StorageService {
  /// Reads a value from storage.
  Future<String?> read({required String key});

  /// Writes a value to storage.
  Future<void> write({required String key, required String value});
}

/// A storage service that uses [SharedPreferences].
class WebStorageService implements StorageService {
  @override
  Future<String?> read({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<void> write({required String key, required String value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}

/// An instance of the web storage service.
StorageService get getStorageService => WebStorageService();
