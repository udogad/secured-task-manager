import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// An abstract class for storage operations.
abstract class StorageService {
  /// Reads a value from storage.
  Future<String?> read({required String key});

  /// Writes a value to storage.
  Future<void> write({required String key, required String value});
}

/// A storage service that uses [FlutterSecureStorage].
class SecureStorageService implements StorageService {
  final _storage = const FlutterSecureStorage();

  @override
  Future<String?> read({required String key}) {
    return _storage.read(key: key);
  }

  @override
  Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }
}

/// An instance of the secure storage service.
StorageService get getStorageService => SecureStorageService();
