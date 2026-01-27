import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration class for managing app environment variables
/// This class provides a centralized way to access environment variables
class EnvConfig {
  // Private constructor to prevent instantiation
  EnvConfig._();

  /// Initialize environment variables
  /// Must be called before accessing any environment variables
  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
  }

  /// Get Supabase URL from environment variables
  static String get supabaseUrl {
    final url = dotenv.env['SUPABASE_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('SUPABASE_URL not found in .env file');
    }
    return url;
  }

  /// Get Supabase Anonymous Key from environment variables
  static String get supabaseAnonKey {
    final key = dotenv.env['SUPABASE_ANON_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('SUPABASE_ANON_KEY not found in .env file');
    }
    return key;
  }

  /// Get API Base URL (optional - for future use)
  static String? get apiBaseUrl => dotenv.env['API_BASE_URL'];

  /// Get API Key (optional - for future use)
  static String? get apiKey => dotenv.env['API_KEY'];

  /// Get App Environment (development, staging, production)
  static String get appEnv => dotenv.env['APP_ENV'] ?? 'development';

  /// Check if running in development mode
  static bool get isDevelopment => appEnv == 'development';

  /// Check if running in production mode
  static bool get isProduction => appEnv == 'production';

  /// Check if running in staging mode
  static bool get isStaging => appEnv == 'staging';
}
