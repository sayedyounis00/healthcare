import 'package:flutter/widgets.dart';
import 'package:healthcare/core/config/env_config.dart';
import 'package:healthcare/core/di/injection.dart' as di;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Centralized app initialization class
/// Handles all initialization logic before the app starts
class AppInitializer {
  // Private constructor to prevent instantiation
  AppInitializer._();

  /// Initialize all app dependencies and services
  /// This should be called in main() before runApp()
  static Future<void> initialize() async {
    // Ensure Flutter binding is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize environment variables
    await _initializeEnvironment();

    // Initialize Supabase
    await _initializeSupabase();

    // Initialize dependency injection
    await _initializeDependencyInjection();

    // Add more initialization steps here as needed
    // await _initializeFirebase();
    // await _initializeLocalStorage();
    // await _initializeAnalytics();
  }

  /// Initialize environment variables from .env file
  static Future<void> _initializeEnvironment() async {
    try {
      await EnvConfig.init();
      debugPrint('✅ Environment variables loaded successfully');
    } catch (e) {
      debugPrint('❌ Failed to load environment variables: $e');
      rethrow;
    }
  }

  /// Initialize Supabase with credentials from environment
  static Future<void> _initializeSupabase() async {
    try {
      await Supabase.initialize(
        url: EnvConfig.supabaseUrl,
        anonKey: EnvConfig.supabaseAnonKey,
      );
      debugPrint('✅ Supabase initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize Supabase: $e');
      rethrow;
    }
  }

  /// Initialize dependency injection container
  static Future<void> _initializeDependencyInjection() async {
    try {
      await di.setUp();
      debugPrint('✅ Dependency injection initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize dependency injection: $e');
      rethrow;
    }
  }

  // Add more initialization methods as needed:

  // /// Initialize Firebase services
  // static Future<void> _initializeFirebase() async {
  //   try {
  //     await Firebase.initializeApp();
  //     debugPrint('✅ Firebase initialized successfully');
  //   } catch (e) {
  //     debugPrint('❌ Failed to initialize Firebase: $e');
  //     rethrow;
  //   }
  // }

  // /// Initialize local storage
  // static Future<void> _initializeLocalStorage() async {
  //   try {
  //     await SharedPreferences.getInstance();
  //     debugPrint('✅ Local storage initialized successfully');
  //   } catch (e) {
  //     debugPrint('❌ Failed to initialize local storage: $e');
  //     rethrow;
  //   }
  // }

  // /// Initialize analytics
  // static Future<void> _initializeAnalytics() async {
  //   try {
  //     // Initialize your analytics service here
  //     debugPrint('✅ Analytics initialized successfully');
  //   } catch (e) {
  //     debugPrint('❌ Failed to initialize analytics: $e');
  //     rethrow;
  //   }
  // }
}
