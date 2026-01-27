
class LocalDatabaseException implements Exception {
  final String message;
  LocalDatabaseException(this.message);
}
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}