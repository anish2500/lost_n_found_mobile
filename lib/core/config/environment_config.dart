import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

/// Environment configuration for API endpoints
/// This allows easy switching between different environments
class EnvironmentConfig {
  EnvironmentConfig._();

  /// Get the appropriate API base URL based on platform and environment
  static String getBaseUrl() {
    // Detect platform
    if (kIsWeb) {
      // Web platform
      return _getWebUrl();
    } else if (Platform.isAndroid) {
      // Android platform
      return _getAndroidUrl();
    } else if (Platform.isIOS) {
      // iOS platform
      return _getIOSUrl();
    } else {
      // Fallback
      return 'http://localhost:3000/api/v1';
    }
  }

  /// Get URL for Flutter Web platform
  /// On web, 10.0.2.2 doesn't work - use localhost or your actual server IP
  static String _getWebUrl() {
    // For development on web (local machine):
    return 'http://localhost:3000/api/v1';

    // For production or remote server:
    // return 'https://your-api-server.com/api/v1';
  }

  /// Get URL for Android platform
  /// Use 10.0.2.2 for emulator, or actual IP for physical device
  static String _getAndroidUrl() {
    // For Android Emulator:
    return 'http://10.0.2.2:3000/api/v1';

    // For physical device, use your computer's local IP:
    // return 'http://192.168.x.x:3000/api/v1';
  }

  /// Get URL for iOS platform
  /// iOS simulator can use localhost, physical device needs actual IP
  static String _getIOSUrl() {
    // For iOS Simulator:
    return 'http://localhost:3000/api/v1';

    // For physical device, use your computer's local IP:
    // return 'http://192.168.x.x:3000/api/v1';
  }
}
