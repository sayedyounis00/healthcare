class LocalDatabaseException implements Exception {
  final String message;
  LocalDatabaseException(this.message);
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

class SyncException implements Exception {
  final String message;
  SyncException(this.message);
}
