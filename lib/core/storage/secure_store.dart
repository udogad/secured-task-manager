import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A utility class for securely storing and retrieving data.
class SecureStore {
  static const _keyName = 'hive_key_v1';
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Ensure a 32-byte key exists for Hive encryption; create if missing.
  static Future<List<int>> ensureHiveKey() async {
    final existing = await _storage.read(key: _keyName);
    if (existing != null) {
      return _decode(existing);
    }
    final rnd = Random.secure();
    final key = List<int>.generate(32, (_) => rnd.nextInt(256));
    await _storage.write(key: _keyName, value: _encode(key));
    return key;
  }

  static String _encode(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  static List<int> _decode(String hex) {
    final out = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      out.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return out;
  }
}
