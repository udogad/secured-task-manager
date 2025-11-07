/// An abstract class for storage operations.
abstract class StorageService {
  /// Reads a value from storage.
  Future<String?> read({required String key});

  /// Writes a value to storage.
  Future<void> write({required String key, required String value});
}

/// A storage service that throws an error when used.
class UnsupportedStorageService implements StorageService {
  @override
  Future<String?> read({required String key}) {
    throw UnimplementedError('Storage is not supported on this platform.');
  }

  @override
  Future<void> write({required String key, required String value}) {
    throw UnimplementedError('Storage is not supported on this platform.');
  }
}

/// An instance of the unsupported storage service.
StorageService get getStorageService => UnsupportedStorageService();
