/// App-wide security and configuration constants
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  /// App Information
  static const String appName = 'Healthcare App';
  static const String appVersion = '1.0.0';

  /// Security Configuration

  /// Minimum password length requirement
  static const int minPasswordLength = 8;

  /// Maximum login attempts before account lockout
  static const int maxLoginAttempts = 5;

  /// Session timeout in minutes
  static const int sessionTimeoutMinutes = 30;

  /// Token refresh interval in minutes
  static const int tokenRefreshMinutes = 15;

  /// API Configuration

  /// API request timeout in seconds
  static const int apiTimeoutSeconds = 30;

  /// Maximum retry attempts for failed requests
  static const int maxRetryAttempts = 3;

  /// Database Configuration

  /// Local database name
  static const String localDbName = 'healthcare.db';

  /// Database version
  static const int dbVersion = 1;

  /// Validation Patterns

  /// Email validation regex pattern
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  /// Phone number validation regex pattern (11+ digits)
  static const String phonePattern = r'^\+?[\d\s-]{11,}$';

  /// Password validation regex (at least 1 uppercase, 1 lowercase, 1 number)
  static const String passwordPattern =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$';

  /// UI Configuration

  /// Default animation duration in milliseconds
  static const int animationDurationMs = 200;

  /// Default border radius
  static const double defaultBorderRadius = 12.0;

  /// Default padding
  static const double defaultPadding = 16.0;

  /// Error Messages

  static const String networkErrorMessage =
      'Network error. Please check your connection.';
  static const String serverErrorMessage =
      'Server error. Please try again later.';
  static const String unauthorizedErrorMessage =
      'Unauthorized. Please login again.';
  static const String validationErrorMessage =
      'Please check your input and try again.';

  /// Success Messages

  static const String loginSuccessMessage = 'Login successful!';
  static const String registrationSuccessMessage = 'Registration successful!';
  static const String updateSuccessMessage = 'Updated successfully!';
  static const String deleteSuccessMessage = 'Deleted successfully!';
}
