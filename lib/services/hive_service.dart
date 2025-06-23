import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Service class for managing Hive database operations
/// Enhanced with comprehensive debug logging for better development experience
class HiveService {
  const HiveService._();

  // Box names
  static const String _introBoxName = 'intro';
  static const String _authBoxName = 'auth';
  static const String _userBoxName = 'user';

  // Keys
  static const String _introWatchedKey = 'introWatched';
  static const String _languageSelectedKey = 'languageSelected';
  static const String _selectedLanguageKey = 'selectedLanguage';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userDataKey = 'userData';
  static const String _authTokenKey = 'authToken';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _phoneNumberKey = 'phoneNumber';
  static const String _lastLoginKey = 'lastLogin';
  static const String _userProfileKey = 'userProfile';

  // Health check tracking keys
  static const String _lastHealthCheckKey = 'lastHealthCheck';
  static const String _healthCheckStatusKey = 'healthCheckStatus';
  static const String _healthCheckResultKey = 'healthCheckResult';

  // Lazy boxes for better performance
  static late Box _introBox;
  static late Box _authBox;
  static late Box _userBox;
  // static late Box _userBox;
  // static late Box _offlineBox;

  /// Initialize all Hive boxes
  static Future<void> init() async {
    debugPrint('📦 HiveService: Initializing Hive database and opening boxes');

    try {
      await Hive.initFlutter();
      debugPrint('📦 HiveService: Hive Flutter initialized successfully');

      _introBox = await Hive.openBox(_introBoxName);
      debugPrint('📦 HiveService: Intro box opened successfully');

      _authBox = await Hive.openBox(_authBoxName);
      debugPrint('📦 HiveService: Auth box opened successfully');

      _userBox = await Hive.openBox(_userBoxName);
      debugPrint('📦 HiveService: User box opened successfully');

      debugPrint('📦 HiveService: All Hive boxes initialized successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to initialize Hive - $e');
      throw Exception('Failed to initialize Hive: $e');
    }
  }

  /// Close all boxes (call this when app is closing)
  static Future<void> close() async {
    debugPrint('📦 HiveService: Closing all Hive boxes');

    try {
      await _introBox.close();
      debugPrint('📦 HiveService: Intro box closed');

      await _authBox.close();
      debugPrint('📦 HiveService: Auth box closed');

      await _userBox.close();
      debugPrint('📦 HiveService: User box closed');

      debugPrint('📦 HiveService: All Hive boxes closed successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to close Hive boxes - $e');
      throw Exception('Failed to close Hive boxes: $e');
    }
  }

  /// Clear all data (useful for logout or reset)
  static Future<void> clearAll() async {
    debugPrint('📦 HiveService: Clearing all Hive data');

    try {
      await _introBox.clear();
      debugPrint('📦 HiveService: Intro box cleared');

      await _authBox.clear();
      debugPrint('📦 HiveService: Auth box cleared');

      await _userBox.clear();
      debugPrint('📦 HiveService: User box cleared');

      debugPrint('📦 HiveService: All Hive data cleared successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to clear Hive data - $e');
      throw Exception('Failed to clear Hive data: $e');
    }
  }

  // === INTRO/ONBOARDING METHODS ===

  /// Check if user has watched the intro/onboarding
  static bool hasIntroBeenWatched() {
    debugPrint('📦 HiveService: Checking if intro has been watched');

    try {
      final result = _introBox.get(_introWatchedKey, defaultValue: false) as bool;
      debugPrint('📦 HiveService: Intro watched status: $result');
      return result;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to check intro watched status - $e');
      return false;
    }
  }

  /// Mark intro as watched
  static Future<void> setIntroWatched() async {
    debugPrint('📦 HiveService: Setting intro as watched');

    try {
      await _introBox.put(_introWatchedKey, true);
      debugPrint('📦 HiveService: Intro marked as watched successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to set intro watched - $e');
      throw Exception('Failed to set intro watched: $e');
    }
  }

  /// Reset intro watched status (for testing or reset functionality)
  static Future<void> resetIntroWatched() async {
    debugPrint('📦 HiveService: Resetting intro watched status');

    try {
      await _introBox.put(_introWatchedKey, false);
      debugPrint('📦 HiveService: Intro watched status reset successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to reset intro watched - $e');
      throw Exception('Failed to reset intro watched: $e');
    }
  }

  // === LANGUAGE SELECTION METHODS ===

  /// Check if user has selected a language
  static bool isLanguageSelected() {
    debugPrint('📦 HiveService: Checking if language has been selected');

    try {
      final result = _introBox.get(_languageSelectedKey, defaultValue: false) as bool;
      debugPrint('📦 HiveService: Language selected status: $result');
      return result;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to check language selected status - $e');
      return false;
    }
  }

  /// Mark language as selected
  static Future<void> setLanguageSelected() async {
    debugPrint('📦 HiveService: Setting language as selected');

    try {
      await _introBox.put(_languageSelectedKey, true);
      debugPrint('📦 HiveService: Language marked as selected successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to set language selected - $e');
      throw Exception('Failed to set language selected: $e');
    }
  }

  /// Get selected language code
  static String? getSelectedLanguage() {
    debugPrint('📦 HiveService: Getting selected language code');

    try {
      final language = _introBox.get(_selectedLanguageKey) as String?;
      debugPrint('📦 HiveService: Selected language: ${language ?? 'none'}');
      return language;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to get selected language - $e');
      return null;
    }
  }

  /// Set selected language
  static Future<void> setSelectedLanguage(String languageCode) async {
    debugPrint('📦 HiveService: Setting selected language: $languageCode');

    try {
      await _introBox.put(_selectedLanguageKey, languageCode);
      await setLanguageSelected();
      debugPrint('📦 HiveService: Language set successfully: $languageCode');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to set selected language - $e');
      throw Exception('Failed to set selected language: $e');
    }
  }

  /// Reset language selection (for testing or reset functionality)
  static Future<void> resetLanguageSelection() async {
    debugPrint('📦 HiveService: Resetting language selection');

    try {
      await _introBox.put(_languageSelectedKey, false);
      await _introBox.delete(_selectedLanguageKey);
      debugPrint('📦 HiveService: Language selection reset successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to reset language selection - $e');
      throw Exception('Failed to reset language selection: $e');
    }
  }

  // === AUTHENTICATION METHODS ===

  /// Check if user is logged in
  static bool isLoggedIn() {
    debugPrint('📦 HiveService: Checking if user is logged in');

    try {
      final result = _authBox.get(_isLoggedInKey, defaultValue: false) as bool;
      debugPrint('📦 HiveService: User login status: $result');
      return result;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to check login status - $e');
      return false;
    }
  }

  /// Set user login status
  static Future<void> setLoggedIn(bool isLoggedIn) async {
    debugPrint('📦 HiveService: Setting user login status: $isLoggedIn');

    try {
      await _authBox.put(_isLoggedInKey, isLoggedIn);
      if (isLoggedIn) {
        await _authBox.put(_lastLoginKey, DateTime.now().toIso8601String());
        debugPrint('📦 HiveService: Last login timestamp updated');
      }
      debugPrint('📦 HiveService: Login status set successfully: $isLoggedIn');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to set login status - $e');
      throw Exception('Failed to set login status: $e');
    }
  }

  /// Get auth token
  static String? getAuthToken() {
    debugPrint('📦 HiveService: Getting auth token');

    try {
      final token = _authBox.get(_authTokenKey) as String?;
      debugPrint('📦 HiveService: Auth token exists: ${token != null}');
      return token;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to get auth token - $e');
      return null;
    }
  }

  /// Set auth token
  static Future<void> setAuthToken(String token) async {
    debugPrint('📦 HiveService: Setting auth token (length: ${token.length})');

    try {
      await _authBox.put(_authTokenKey, token);
      debugPrint('📦 HiveService: Auth token set successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to set auth token - $e');
      throw Exception('Failed to set auth token: $e');
    }
  }

  /// Remove auth token
  static Future<void> removeAuthToken() async {
    debugPrint('📦 HiveService: Removing auth token');

    try {
      await _authBox.delete(_authTokenKey);
      debugPrint('📦 HiveService: Auth token removed successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to remove auth token - $e');
      throw Exception('Failed to remove auth token: $e');
    }
  }

  /// Get refresh token
  static String? getRefreshToken() {
    debugPrint('📦 HiveService: Getting refresh token');

    try {
      final token = _authBox.get(_refreshTokenKey) as String?;
      debugPrint('📦 HiveService: Refresh token exists: ${token != null}');
      return token;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to get refresh token - $e');
      return null;
    }
  }

  /// Set refresh token
  static Future<void> setRefreshToken(String token) async {
    debugPrint('📦 HiveService: Setting refresh token (length: ${token.length})');

    try {
      await _authBox.put(_refreshTokenKey, token);
      debugPrint('📦 HiveService: Refresh token set successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to set refresh token - $e');
      throw Exception('Failed to set refresh token: $e');
    }
  }

  /// Remove refresh token
  static Future<void> removeRefreshToken() async {
    debugPrint('📦 HiveService: Removing refresh token');

    try {
      await _authBox.delete(_refreshTokenKey);
      debugPrint('📦 HiveService: Refresh token removed successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to remove refresh token - $e');
      throw Exception('Failed to remove refresh token: $e');
    }
  }

  /// Get stored phone number
  static String? getPhoneNumber() {
    debugPrint('📦 HiveService: Getting stored phone number');

    try {
      final phoneNumber = _authBox.get(_phoneNumberKey) as String?;
      debugPrint('📦 HiveService: Phone number exists: ${phoneNumber != null}');
      return phoneNumber;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to get phone number - $e');
      return null;
    }
  }

  /// Set phone number
  static Future<void> setPhoneNumber(String phoneNumber) async {
    debugPrint('📦 HiveService: Setting phone number: ${phoneNumber.substring(0, 3)}***');

    try {
      await _authBox.put(_phoneNumberKey, phoneNumber);
      debugPrint('📦 HiveService: Phone number set successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to set phone number - $e');
      throw Exception('Failed to set phone number: $e');
    }
  }

  /// Get last login date
  static DateTime? getLastLogin() {
    debugPrint('📦 HiveService: Getting last login date');

    try {
      final lastLoginStr = _authBox.get(_lastLoginKey) as String?;
      final lastLogin = lastLoginStr != null ? DateTime.parse(lastLoginStr) : null;
      debugPrint('📦 HiveService: Last login: ${lastLogin?.toString().substring(0, 19) ?? 'never'}');
      return lastLogin;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to get last login - $e');
      return null;
    }
  }

  // === USER DATA METHODS ===

  /// Save user data
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    debugPrint('📦 HiveService: Saving user data with ${userData.keys.length} fields');

    try {
      await _userBox.put(_userDataKey, userData);
      debugPrint('📦 HiveService: User data saved successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to save user data - $e');
      throw Exception('Failed to save user data: $e');
    }
  }

  /// Get user data
  static Map<String, dynamic>? getUserData() {
    debugPrint('📦 HiveService: Getting user data');

    try {
      final userData = _userBox.get(_userDataKey);
      final result = userData != null ? Map<String, dynamic>.from(userData) : null;
      debugPrint('📦 HiveService: User data exists: ${result != null}');
      if (result != null) {
        debugPrint('📦 HiveService: User data fields: ${result.keys.toList()}');
      }
      return result;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to get user data - $e');
      return null;
    }
  }

  /// Clear user data
  static Future<void> clearUserData() async {
    debugPrint('📦 HiveService: Clearing user data');

    try {
      await _userBox.delete(_userDataKey);
      debugPrint('📦 HiveService: User data cleared successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to clear user data - $e');
      throw Exception('Failed to clear user data: $e');
    }
  }

  // === UTILITY METHODS ===

  /// Logout user (clear all auth-related data)
  static Future<void> logout() async {
    debugPrint('📦 HiveService: Performing user logout');

    try {
      await setLoggedIn(false);
      await removeAuthToken();
      await removeRefreshToken();
      await clearUserData();
      debugPrint('📦 HiveService: User logout completed successfully');
      // Note: We don't reset intro watched on logout
    } catch (e) {
      debugPrint('📦 HiveService: Failed to logout - $e');
      throw Exception('Failed to logout: $e');
    }
  }

  /// Check if this is a first-time user
  static bool isFirstTimeUser() {
    final result = !hasIntroBeenWatched();
    debugPrint('📦 HiveService: Is first-time user: $result');
    return result;
  }

  /// Get all stored keys for debugging
  static Map<String, dynamic> getDebugInfo() {
    debugPrint('📦 HiveService: Generating debug information');

    try {
      final debugInfo = {
        'intro': {
          'hasIntroBeenWatched': hasIntroBeenWatched(),
          'introBoxKeys': _introBox.keys.toList(),
        },
        'auth': {
          'isLoggedIn': isLoggedIn(),
          'hasAuthToken': getAuthToken() != null,
          'phoneNumber': getPhoneNumber(),
          'lastLogin': getLastLogin()?.toIso8601String(),
          'authBoxKeys': _authBox.keys.toList(),
        },
        'user': {
          'hasUserData': getUserData() != null,
          'userBoxKeys': _userBox.keys.toList(),
        },
      };

      debugPrint('📦 HiveService: Debug info generated successfully');
      return debugInfo;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to generate debug info - $e');
      return {'error': e.toString()};
    }
  }

  /// Check storage health
  static bool isStorageHealthy() {
    debugPrint('📦 HiveService: Checking storage health');

    try {
      // Try to perform basic operations on each box
      _introBox.containsKey(_introWatchedKey);
      _authBox.containsKey(_isLoggedInKey);
      _userBox.containsKey(_userDataKey);

      debugPrint('📦 HiveService: Storage health check passed');
      return true;
    } catch (e) {
      debugPrint('📦 HiveService: Storage health check failed - $e');
      return false;
    }
  }

  // === SYNC DATA METHODS ===

  /// Save user profile for sync
  static Future<void> saveUserProfile(Map<String, dynamic> profileData) async {
    debugPrint('📦 HiveService: Saving user profile with ${profileData.keys.length} fields');

    try {
      await _userBox.put(_userProfileKey, profileData);
      debugPrint('📦 HiveService: User profile saved successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to save user profile - $e');
      throw Exception('Failed to save user profile: $e');
    }
  }

  /// Get cached user profile
  static Map<String, dynamic>? getUserProfile() {
    debugPrint('📦 HiveService: Getting cached user profile');

    try {
      final profileData = _userBox.get(_userProfileKey);
      final result = profileData != null ? Map<String, dynamic>.from(profileData) : null;
      debugPrint('📦 HiveService: User profile exists: ${result != null}');
      return result;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to get user profile - $e');
      return null;
    }
  }

  /// Save health check timestamp
  static Future<void> saveLastHealthCheck(DateTime timestamp) async {
    debugPrint('📦 HiveService: Saving health check timestamp: ${timestamp.toString().substring(0, 19)}');

    try {
      await _userBox.put(_lastHealthCheckKey, timestamp.millisecondsSinceEpoch);
      debugPrint('📦 HiveService: Health check timestamp saved successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to save health check timestamp - $e');
      throw Exception('Failed to save health check timestamp: $e');
    }
  }

  /// Get last health check timestamp
  static DateTime? getLastHealthCheck() {
    debugPrint('📦 HiveService: Getting last health check timestamp');

    try {
      final timestamp = _userBox.get(_lastHealthCheckKey);
      final result = timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
      debugPrint('📦 HiveService: Last health check: ${result?.toString().substring(0, 19) ?? 'never'}');
      return result;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to get last health check - $e');
      return null;
    }
  }

  /// Save health check status
  static Future<void> saveHealthCheckStatus(String status) async {
    debugPrint('📦 HiveService: Saving health check status: $status');

    try {
      await _userBox.put(_healthCheckStatusKey, status);
      debugPrint('📦 HiveService: Health check status saved successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to save health check status - $e');
      throw Exception('Failed to save health check status: $e');
    }
  }

  /// Get cached health check status
  static String? getHealthCheckStatus() {
    debugPrint('📦 HiveService: Getting cached health check status');

    try {
      final status = _userBox.get(_healthCheckStatusKey);
      debugPrint('📦 HiveService: Health check status: ${status ?? 'unknown'}');
      return status;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to get health check status - $e');
      return null;
    }
  }

  /// Save health check result
  static Future<void> saveHealthCheckResult(Map<String, dynamic> result) async {
    debugPrint('📦 HiveService: Saving health check result with ${result.keys.length} fields');

    try {
      await _userBox.put(_healthCheckResultKey, result);
      debugPrint('📦 HiveService: Health check result saved successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to save health check result - $e');
      throw Exception('Failed to save health check result: $e');
    }
  }

  /// Get cached health check result
  static Map<String, dynamic>? getHealthCheckResult() {
    debugPrint('📦 HiveService: Getting cached health check result');

    try {
      final result = _userBox.get(_healthCheckResultKey);
      final data = result != null ? Map<String, dynamic>.from(result) : null;
      debugPrint('📦 HiveService: Health check result exists: ${data != null}');
      return data;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to get health check result - $e');
      return null;
    }
  }

  /// Check if health check is needed (based on time interval)
  static bool isHealthCheckNeeded({Duration interval = const Duration(minutes: 30)}) {
    debugPrint('📦 HiveService: Checking if health check is needed (interval: ${interval.inMinutes} minutes)');

    try {
      final lastCheck = getLastHealthCheck();
      if (lastCheck == null) {
        debugPrint('📦 HiveService: Health check needed - no previous check found');
        return true;
      }

      final timeSinceLastCheck = DateTime.now().difference(lastCheck);
      final isNeeded = timeSinceLastCheck >= interval;

      debugPrint('📦 HiveService: Time since last check: ${timeSinceLastCheck.inMinutes} minutes');
      debugPrint('📦 HiveService: Health check needed: $isNeeded');

      return isNeeded;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to check if health check needed - $e');
      return true; // If we can't determine, better to check
    }
  }

  /// Clear health check data
  static Future<void> clearHealthCheckData() async {
    debugPrint('📦 HiveService: Clearing health check data');

    try {
      await _userBox.delete(_lastHealthCheckKey);
      await _userBox.delete(_healthCheckStatusKey);
      await _userBox.delete(_healthCheckResultKey);
      debugPrint('📦 HiveService: Health check data cleared successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to clear health check data - $e');
      throw Exception('Failed to clear health check data: $e');
    }
  }

  // === USER TYPE DETECTION METHODS ===

  /// Get user type from stored user data
  static String getUserType() {
    debugPrint('📦 HiveService: Getting user type');

    try {
      final userData = getUserData();
      final userType = userData?['userType'] as String?;
      final normalizedType = _normalizeUserType(userType);
      debugPrint('📦 HiveService: User type: $normalizedType (raw: $userType)');
      return normalizedType;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to get user type - $e');
      return 'customer'; // Default fallback
    }
  }

  /// Check if current user is a provider
  static bool isProvider() {
    final result = getUserType() == 'provider';
    debugPrint('📦 HiveService: Is provider: $result');
    return result;
  }

  /// Check if current user is a customer
  static bool isCustomer() {
    final userType = getUserType();
    final result = userType == 'customer' || userType == 'taker';
    debugPrint('📦 HiveService: Is customer: $result');
    return result;
  }

  /// Check if current user is an admin
  static bool isAdmin() {
    final result = getUserType() == 'admin';
    debugPrint('📦 HiveService: Is admin: $result');
    return result;
  }

  /// Normalize user type to handle variations
  static String _normalizeUserType(String? userType) {
    if (userType == null) return 'customer';

    switch (userType.toLowerCase()) {
      case 'provider':
        return 'provider';
      case 'admin':
        return 'admin';
      case 'customer':
      case 'taker':
      default:
        return 'customer';
    }
  }

  /// Get user type display name
  static String getUserTypeDisplayName() {
    final displayName = switch (getUserType()) {
      'provider' => 'Service Provider',
      'admin' => 'Administrator',
      'customer' => 'Customer',
      _ => 'Customer',
    };
    debugPrint('📦 HiveService: User type display name: $displayName');
    return displayName;
  }

  /// Get user type color for UI
  static int getUserTypeColor() {
    final color = switch (getUserType()) {
      'provider' => 0xFF10B981, // Emerald
      'admin' => 0xFF8B5CF6, // Violet
      'customer' => 0xFF3B82F6, // Blue
      _ => 0xFF3B82F6, // Blue
    };
    debugPrint('📦 HiveService: User type color: 0x${color.toRadixString(16).toUpperCase()}');
    return color;
  }

  /// Get user type icon for UI
  static int getUserTypeIconCodePoint() {
    final iconCode = switch (getUserType()) {
      'provider' => 0xf0ad, // tools icon
      'admin' => 0xf521, // crown icon
      'customer' => 0xf2c0, // user icon
      _ => 0xf2c0, // user icon
    };
    debugPrint('📦 HiveService: User type icon code: 0x${iconCode.toRadixString(16)}');
    return iconCode;
  }

  /// Update user type in stored data
  static Future<void> updateUserType(String userType) async {
    final normalizedType = _normalizeUserType(userType);
    debugPrint('📦 HiveService: Updating user type to: $normalizedType (from: $userType)');

    try {
      final userData = getUserData();
      if (userData != null) {
        userData['userType'] = normalizedType;
        await saveUserData(userData);
        debugPrint('📦 HiveService: User type updated successfully');
      } else {
        debugPrint('📦 HiveService: No user data found, cannot update user type');
      }
    } catch (e) {
      debugPrint('📦 HiveService: Failed to update user type - $e');
      throw Exception('Failed to update user type: $e');
    }
  }

  /// Set user type (alias for updateUserType)
  static Future<void> setUserType(String userType) async {
    debugPrint('📦 HiveService: Setting user type: $userType');
    await updateUserType(userType);
  }

  /// Clear user type from stored data
  static Future<void> clearUserType() async {
    debugPrint('📦 HiveService: Clearing user type');

    try {
      final userData = getUserData();
      if (userData != null) {
        userData.remove('userType');
        await saveUserData(userData);
        debugPrint('📦 HiveService: User type cleared successfully');
      } else {
        debugPrint('📦 HiveService: No user data found, nothing to clear');
      }
    } catch (e) {
      debugPrint('📦 HiveService: Failed to clear user type - $e');
      throw Exception('Failed to clear user type: $e');
    }
  }

  /// Clear phone number
  static Future<void> clearPhoneNumber() async {
    debugPrint('📦 HiveService: Clearing phone number');

    try {
      await _authBox.delete(_phoneNumberKey);
      debugPrint('📦 HiveService: Phone number cleared successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to clear phone number - $e');
      throw Exception('Failed to clear phone number: $e');
    }
  }
}
