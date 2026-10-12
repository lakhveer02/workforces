import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure and persistent storage service for the application
/// Handles both secure storage (tokens, sensitive data) and preferences (theme, settings)
class AppStorage {
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Storage keys
  static const String _keyAuthToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserData = 'user_data';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLanguage = 'language';
  static const String _keyNotificationSettings = 'notification_settings';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyLastSyncTime = 'last_sync_time';

  // ===== SECURE STORAGE (Tokens, Sensitive Data) =====

  /// Store authentication token securely
  static Future<void> storeAuthToken(String token) async {
    try {
      await _secureStorage.write(key: _keyAuthToken, value: token);
    } catch (e) {
      // Fallback to SharedPreferences for iOS Simulator compatibility
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${_keyAuthToken}_fallback', token);
    }
  }

  /// Get authentication token
  static Future<String?> getAuthToken() async {
    try {
      return await _secureStorage.read(key: _keyAuthToken);
    } catch (e) {
      // Fallback to SharedPreferences for iOS Simulator compatibility
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('${_keyAuthToken}_fallback');
    }
  }

  /// Store refresh token securely
  static Future<void> storeRefreshToken(String token) async {
    try {
      await _secureStorage.write(key: _keyRefreshToken, value: token);
    } catch (e) {
      // Fallback to SharedPreferences for iOS Simulator compatibility
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${_keyRefreshToken}_fallback', token);
    }
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _keyRefreshToken);
    } catch (e) {
      // Fallback to SharedPreferences for iOS Simulator compatibility
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('${_keyRefreshToken}_fallback');
    }
  }

  /// Store user data securely
  static Future<void> storeUserData(Map<String, dynamic> userData) async {
    try {
      final jsonString = jsonEncode(userData);
      await _secureStorage.write(key: _keyUserData, value: jsonString);
    } catch (e) {
      // Fallback to SharedPreferences for iOS Simulator compatibility
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(userData);
      await prefs.setString('${_keyUserData}_fallback', jsonString);
    }
  }

  /// Get user data
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final jsonString = await _secureStorage.read(key: _keyUserData);
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      // Fallback to SharedPreferences for iOS Simulator compatibility
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('${_keyUserData}_fallback');
      if (jsonString != null) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return null;
    }
  }

  /// Clear all authentication data
  static Future<void> clearAuthData() async {
    try {
      await _secureStorage.delete(key: _keyAuthToken);
      await _secureStorage.delete(key: _keyRefreshToken);
      await _secureStorage.delete(key: _keyUserData);
    } catch (e) {
      // Fallback: clear from SharedPreferences too
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('${_keyAuthToken}_fallback');
      await prefs.remove('${_keyRefreshToken}_fallback');
      await prefs.remove('${_keyUserData}_fallback');
    }
  }

  /// Check if user is logged in (has valid auth token)
  static Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // ===== SHARED PREFERENCES (Settings, Preferences) =====

  /// Store theme mode preference
  static Future<void> setThemeMode(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeMode, themeMode);
  }

  /// Get theme mode preference
  static Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyThemeMode) ?? 'system'; // Default to system theme
  }

  /// Store language preference
  static Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, languageCode);
  }

  /// Get language preference
  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage) ?? 'en'; // Default to English
  }

  /// Store notification settings
  static Future<void> setNotificationSettings(Map<String, bool> settings) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(settings);
    await prefs.setString(_keyNotificationSettings, jsonString);
  }

  /// Get notification settings
  static Future<Map<String, bool>> getNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyNotificationSettings);
    if (jsonString != null) {
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((key, value) => MapEntry(key, value as bool));
    }
    
    // Default notification settings
    return {
      'push_notifications': true,
      'email_notifications': true,
      'leave_reminders': true,
      'attendance_alerts': true,
      'task_updates': true,
      'payroll_notifications': true,
    };
  }

  /// Store onboarding completion status
  static Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, completed);
  }

  /// Check if onboarding is completed
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  /// Store biometric authentication preference
  static Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyBiometricEnabled, enabled);
  }

  /// Check if biometric authentication is enabled
  static Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyBiometricEnabled) ?? false;
  }

  /// Store last sync time
  static Future<void> setLastSyncTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastSyncTime, time.toIso8601String());
  }

  /// Get last sync time
  static Future<DateTime?> getLastSyncTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timeString = prefs.getString(_keyLastSyncTime);
    if (timeString != null) {
      return DateTime.parse(timeString);
    }
    return null;
  }

  /// Clear all application data (logout)
  static Future<void> clearAllData() async {
    // Clear secure storage
    await clearAuthData();
    
    // Clear shared preferences (but keep user preferences like theme, language)
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyNotificationSettings);
    await prefs.remove(_keyLastSyncTime);
    await prefs.remove(_keyOnboardingCompleted);
    await prefs.remove(_keyBiometricEnabled);
  }

  /// Clear only user session data (keep app settings)
  static Future<void> clearSessionData() async {
    await clearAuthData();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLastSyncTime);
  }

  // ===== UTILITY METHODS =====

  /// Check if storage is available and accessible
  static Future<bool> isStorageAvailable() async {
    try {
      await SharedPreferences.getInstance();
      // Instead of readAll() which can crash on iOS Simulator, 
      // try a simple write/read/delete test
      const testKey = '_test_key_availability';
      await _secureStorage.write(key: testKey, value: 'test');
      await _secureStorage.read(key: testKey);
      await _secureStorage.delete(key: testKey);
      return true;
    } catch (e) {
      // Secure storage not available (likely iOS Simulator), but SharedPreferences should work
      try {
        await SharedPreferences.getInstance();
        return true; // At least SharedPreferences is available
      } catch (e) {
        return false;
      }
    }
  }

  /// Get storage size information (debugging purposes)
  static Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Map<String, String>? secureKeys;
      
      try {
        secureKeys = await _secureStorage.readAll();
      } catch (e) {
        secureKeys = {}; // Secure storage not available (iOS Simulator)
      }
      
      return {
        'shared_preferences_keys': prefs.getKeys().length,
        'secure_storage_keys': secureKeys.keys.length,
        'secure_storage_available': secureKeys.isNotEmpty,
        'auth_token_exists': await getAuthToken() != null,
        'user_data_exists': await getUserData() != null,
        'theme_mode': await getThemeMode(),
        'language': await getLanguage(),
        'last_sync': await getLastSyncTime(),
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}