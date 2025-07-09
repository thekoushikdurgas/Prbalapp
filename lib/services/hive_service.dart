import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prbal/services/user_service.dart';

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
  /// Note: This implementation uses JSON storage for AppUser objects to avoid
  /// the need for Hive adapters, which simplifies the storage approach
  static Future<void> init() async {
    debugPrint('📦 HiveService: Initializing Hive database and opening boxes');
    debugPrint('📦 HiveService: Using JSON storage approach - no custom adapters needed');

    try {
      await Hive.initFlutter();
      debugPrint('📦 HiveService: Hive Flutter initialized successfully');

      _introBox = await Hive.openBox(_introBoxName);
      debugPrint('📦 HiveService: Intro box opened successfully (${_introBox.keys.length} keys)');

      _authBox = await Hive.openBox(_authBoxName);
      debugPrint('📦 HiveService: Auth box opened successfully (${_authBox.keys.length} keys)');

      _userBox = await Hive.openBox(_userBoxName);
      debugPrint('📦 HiveService: User box opened successfully (${_userBox.keys.length} keys)');

      debugPrint('📦 HiveService: All Hive boxes initialized successfully');
      debugPrint('📦 HiveService: Storage approach: JSON-based (AppUser ↔ Map<String, dynamic>)');
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
  /// This method checks the login flag AND validates that user data actually exists
  /// A user is only considered logged in if both conditions are met
  static bool isLoggedIn() {
    debugPrint('📦 HiveService: ====== COMPREHENSIVE LOGIN STATUS CHECK ======');

    try {
      // Check the basic login flag
      final loginFlag = _authBox.get(_isLoggedInKey, defaultValue: false) as bool;
      debugPrint('📦 HiveService: Basic login flag: $loginFlag');

      if (!loginFlag) {
        debugPrint('📦 HiveService: ❌ User not logged in (login flag is false)');
        return false;
      }

      // Check if user data actually exists
      final hasUserData = _hasUserData();
      debugPrint('📦 HiveService: User data exists: $hasUserData');

      // Check if auth token exists
      final hasAuthToken = _hasAuthToken();
      debugPrint('📦 HiveService: Auth token exists: $hasAuthToken');

      // For a user to be truly logged in, they need:
      // 1. Login flag = true
      // 2. User data must exist
      // Auth token is optional (can be refreshed)
      final isActuallyLoggedIn = loginFlag && hasUserData;

      debugPrint('📦 HiveService: ====== LOGIN STATUS SUMMARY ======');
      debugPrint('📦 HiveService: Login flag: $loginFlag');
      debugPrint('📦 HiveService: Has user data: $hasUserData');
      debugPrint('📦 HiveService: Has auth token: $hasAuthToken');
      debugPrint('📦 HiveService: Final login status: $isActuallyLoggedIn');

      if (loginFlag && !hasUserData) {
        debugPrint('📦 HiveService: ⚠️ INCONSISTENT STATE: Login flag is true but no user data exists');
        debugPrint('📦 HiveService: This suggests a previous login session was not properly cleaned up');
        debugPrint('📦 HiveService: User will be directed to welcome screen to re-authenticate');
      }

      return isActuallyLoggedIn;
    } catch (e) {
      debugPrint('📦 HiveService: ❌ Failed to check login status - $e');
      debugPrint('📦 HiveService: Defaulting to not logged in for safety');
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
  static String getAuthToken() {
    debugPrint('📦 HiveService: Getting auth token');

    try {
      String? token = _authBox.get(_authTokenKey);
      if (token == null) {
        throw Exception('Auth token not found');
      }
      return token;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to get auth token - $e');
      throw Exception('Auth token not found');
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
  /// Stores AppUser data as JSON Map to avoid Hive adapter requirements
  static Future<void> saveUserData(AppUser userData) async {
    debugPrint('📦 HiveService: Saving user data with ${userData.toJson().keys.length} fields');
    debugPrint('📦 HiveService: Converting AppUser to JSON for Hive storage');

    try {
      // Convert AppUser to JSON Map for Hive storage
      final userDataJson = userData.toJson();
      debugPrint('📦 HiveService: User data JSON keys: ${userDataJson.keys.toList()}');
      debugPrint('📦 HiveService: User type in JSON: ${userDataJson['user_type']}');

      await _userBox.put(_userDataKey, userDataJson);
      debugPrint('📦 HiveService: User data saved successfully as JSON');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to save user data - $e');
      throw Exception('Failed to save user data: $e');
    }
  }

  /// Get user data
  /// Retrieves user data from JSON Map and converts back to AppUser
  /// WARNING: This method throws an exception if no user data is found
  /// Use getUserDataSafe() for safer access that returns null instead
  static AppUser getUserData() {
    debugPrint('📦 HiveService: Getting user data (UNSAFE - throws exception)');

    try {
      final userData = _userBox.get(_userDataKey);
      debugPrint('📦 HiveService: Raw user data type: ${userData.runtimeType}');

      if (userData == null) {
        debugPrint('📦 HiveService: No user data found in Hive');
        throw Exception("No user data found");
      }

      // Convert to Map<String, dynamic> if it's not already
      Map<String, dynamic> userDataMap;
      if (userData is Map<String, dynamic>) {
        userDataMap = userData;
      } else if (userData is Map) {
        userDataMap = Map<String, dynamic>.from(userData);
      } else {
        debugPrint('📦 HiveService: Unexpected user data format: ${userData.runtimeType}');
        throw Exception("Invalid user data format");
      }

      debugPrint('📦 HiveService: User data map keys: ${userDataMap.keys.toList()}');
      debugPrint('📦 HiveService: User type from storage: ${userDataMap['user_type']}');

      if (userDataMap.isEmpty) {
        debugPrint('📦 HiveService: User data map is empty');
        throw Exception("User data is empty");
      }

      final appUser = AppUser.fromJson(userDataMap);
      debugPrint('📦 HiveService: Successfully converted JSON to AppUser');
      debugPrint('📦 HiveService: User ID: ${appUser.id}');
      debugPrint('📦 HiveService: User type: ${appUser.userType}');

      return appUser;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to get user data - $e');
      throw Exception("Failed to get user data: $e");
    }
  }

  /// Safely get user data without throwing exceptions
  /// Returns null if no user data is found or if there's an error
  /// This is the preferred method for checking user data existence
  static AppUser? getUserDataSafe() {
    debugPrint('📦 HiveService: ====== SAFELY GETTING USER DATA ======');
    debugPrint('📦 HiveService: This method returns null instead of throwing exceptions');

    try {
      final userData = _userBox.get(_userDataKey);
      debugPrint('📦 HiveService: Raw user data type: ${userData.runtimeType}');
      debugPrint('📦 HiveService: User data exists: ${userData != null}');

      if (userData == null) {
        debugPrint('📦 HiveService: No user data found in Hive - returning null');
        return null;
      }

      // Convert to Map<String, dynamic> if it's not already
      Map<String, dynamic> userDataMap;
      if (userData is Map<String, dynamic>) {
        userDataMap = userData;
        debugPrint('📦 HiveService: Data is already Map<String, dynamic>');
      } else if (userData is Map) {
        userDataMap = Map<String, dynamic>.from(userData);
        debugPrint('📦 HiveService: Converted Map to Map<String, dynamic>');
      } else {
        debugPrint('📦 HiveService: ❌ Unexpected user data format: ${userData.runtimeType}');
        debugPrint('📦 HiveService: Expected Map but got ${userData.runtimeType} - returning null');
        return null;
      }

      debugPrint('📦 HiveService: User data map keys: ${userDataMap.keys.toList()}');
      debugPrint('📦 HiveService: User type from storage: ${userDataMap['user_type']}');
      debugPrint('📦 HiveService: User data map size: ${userDataMap.length} fields');

      if (userDataMap.isEmpty) {
        debugPrint('📦 HiveService: ❌ User data map is empty - returning null');
        return null;
      }

      // Attempt to convert to AppUser
      debugPrint('📦 HiveService: Converting JSON map to AppUser object...');
      final appUser = AppUser.fromJson(userDataMap);

      debugPrint('📦 HiveService: ✅ Successfully converted JSON to AppUser');
      debugPrint('📦 HiveService: User ID: ${appUser.id}');
      debugPrint('📦 HiveService: Username: ${appUser.username}');
      debugPrint('📦 HiveService: User type: ${appUser.userType}');
      debugPrint('📦 HiveService: Display name: ${appUser.firstName} ${appUser.lastName}');
      debugPrint('📦 HiveService: Phone: ${appUser.phoneNumber}');
      debugPrint('📦 HiveService: Email: ${appUser.email}');
      debugPrint('📦 HiveService: Is verified: ${appUser.isVerified}');

      return appUser;
    } catch (e, stackTrace) {
      debugPrint('📦 HiveService: ❌ Error getting user data safely - $e');
      debugPrint('📦 HiveService: Error type: ${e.runtimeType}');
      debugPrint('📦 HiveService: Stack trace preview: ${stackTrace.toString().split('\n').take(2).join('\n')}');
      debugPrint('📦 HiveService: Returning null due to error');
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
          'hasAuthToken': _hasAuthToken(),
          'phoneNumber': getPhoneNumber(),
          'lastLogin': getLastLogin()?.toIso8601String(),
          'authBoxKeys': _authBox.keys.toList(),
        },
        'user': {
          'hasUserData': _hasUserData(),
          'userType': _safeGetUserType(),
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

  /// Helper method to safely check if auth token exists
  static bool _hasAuthToken() {
    try {
      getAuthToken();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Helper method to safely check if user data exists
  static bool _hasUserData() {
    try {
      final userData = _userBox.get(_userDataKey);
      return userData != null;
    } catch (e) {
      return false;
    }
  }

  /// Helper method to safely get user type without throwing
  static String _safeGetUserType() {
    try {
      return getUserType().name;
    } catch (e) {
      return 'unknown';
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
  /// Stores user profile data as JSON Map to avoid Hive adapter requirements
  static Future<void> saveUserProfile(AppUser profileData) async {
    debugPrint('📦 HiveService: Saving user profile with ${profileData.toJson().keys.length} fields');
    debugPrint('📦 HiveService: Converting AppUser profile to JSON for Hive storage');

    try {
      // Convert AppUser to JSON Map for Hive storage
      final profileDataJson = profileData.toJson();
      debugPrint('📦 HiveService: Profile data JSON keys: ${profileDataJson.keys.toList()}');

      await _userBox.put(_userProfileKey, profileDataJson);
      debugPrint('📦 HiveService: User profile saved successfully as JSON');
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
  static UserType getUserType() {
    debugPrint('📦 HiveService: Getting user type');

    try {
      final userData = getUserData();
      // final userType = userData.userType;
      return userData.userType;
    } catch (e) {
      debugPrint('📦 HiveService: Failed to get user type - $e');
      return UserType.customer; // Default fallback
    }
  }

  /// Check if current user is a provider
  static bool isProvider() {
    final result = getUserType() == UserType.provider;
    debugPrint('📦 HiveService: Is provider: $result');
    return result;
  }

  /// Check if current user is a customer
  static bool isCustomer() {
    final userType = getUserType();
    final result = userType == UserType.customer;
    debugPrint('📦 HiveService: Is customer: $result');
    return result;
  }

  /// Check if current user is an admin
  static bool isAdmin() {
    final result = getUserType() == UserType.admin;
    debugPrint('📦 HiveService: Is admin: $result');
    return result;
  }

  // /// Normalize user type to handle variations
  // static String _normalizeUserType(UserType userType) {
  //   if (userType == null) return 'customer';

  //   switch (userType.toLowerCase()) {
  //     case 'provider':
  //       return 'provider';
  //     case 'admin':
  //       return 'admin';
  //     case 'customer':
  //     default:
  //       return 'customer';
  //   }
  // }

  /// Get user type display name
  static String getUserTypeDisplayName() {
    final displayName = switch (getUserType()) {
      UserType.provider => 'Service Provider',
      UserType.admin => 'Administrator',
      UserType.customer => 'Customer',
    };
    debugPrint('📦 HiveService: User type display name: $displayName');
    return displayName;
  }

  /// Get user type color for UI
  static int getUserTypeColor() {
    final color = switch (getUserType()) {
      UserType.provider => 0xFF10B981, // Emerald
      UserType.admin => 0xFF8B5CF6, // Violet
      UserType.customer => 0xFF3B82F6, // Blue
    };
    debugPrint('📦 HiveService: User type color: 0x${color.toRadixString(16).toUpperCase()}');
    return color;
  }

  /// Get user type icon for UI
  static int getUserTypeIconCodePoint() {
    final iconCode = switch (getUserType()) {
      UserType.provider => 0xf0ad, // tools icon
      UserType.admin => 0xf521, // crown icon
      UserType.customer => 0xf2c0, // user icon
    };
    debugPrint('📦 HiveService: User type icon code: 0x${iconCode.toRadixString(16)}');
    return iconCode;
  }

  /// Update user type in stored data
  static Future<void> updateUserType(UserType userType) async {
    try {
      AppUser userData = getUserData();
      userData = userData.copyWith(userType: userType);
      await saveUserData(userData);
      debugPrint('📦 HiveService: User type updated successfully');
    } catch (e) {
      debugPrint('📦 HiveService: Failed to update user type - $e');
      throw Exception('Failed to update user type: $e');
    }
  }

  /// Set user type (alias for updateUserType)
  static Future<void> setUserType(UserType userType) async {
    debugPrint('📦 HiveService: Setting user type: $userType');
    await updateUserType(userType);
  }

  /// Clear user type from stored data
  static Future<void> clearUserType() async {
    debugPrint('📦 HiveService: Clearing user type');

    try {
      AppUser userData = getUserData();
      userData = userData.copyWith(userType: UserType.customer);
      await saveUserData(userData);
      debugPrint('📦 HiveService: User type cleared successfully');
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
