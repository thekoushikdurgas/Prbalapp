import 'package:hive_flutter/hive_flutter.dart';
import 'package:prbal/models/auth/app_user.dart';
import 'package:prbal/models/auth/user_type.dart';
import 'package:prbal/utils/debug_logger.dart';

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
    DebugLogger.storage('Initializing Hive database and opening boxes');
    DebugLogger.storage(
        'Using JSON storage approach - no custom adapters needed');

    try {
      await Hive.initFlutter();
      DebugLogger.storage('Hive Flutter initialized successfully');

      _introBox = await Hive.openBox(_introBoxName);
      DebugLogger.storage(
          'Intro box opened successfully (${_introBox.keys.length} keys)');

      _authBox = await Hive.openBox(_authBoxName);
      DebugLogger.storage(
          'Auth box opened successfully (${_authBox.keys.length} keys)');

      _userBox = await Hive.openBox(_userBoxName);
      DebugLogger.storage(
          'User box opened successfully (${_userBox.keys.length} keys)');

      DebugLogger.success('All Hive boxes initialized successfully');
      DebugLogger.storage(
          'Storage approach: JSON-based (AppUser ↔ Map<String, dynamic>)');
    } catch (e) {
      DebugLogger.error('Failed to initialize Hive - $e');
      throw Exception('Failed to initialize Hive: $e');
    }
  }

  /// Close all boxes (call this when app is closing)
  static Future<void> close() async {
    DebugLogger.storage('Closing all Hive boxes');

    try {
      await _introBox.close();
      DebugLogger.storage('Intro box closed');

      await _authBox.close();
      DebugLogger.storage('Auth box closed');

      await _userBox.close();
      DebugLogger.storage('User box closed');

      DebugLogger.success('All Hive boxes closed successfully');
    } catch (e) {
      DebugLogger.error('Failed to close Hive boxes - $e');
      throw Exception('Failed to close Hive boxes: $e');
    }
  }

  /// Clear all data (useful for logout or reset)
  static Future<void> clearAll() async {
    DebugLogger.storage('Clearing all Hive data');

    try {
      await _introBox.clear();
      DebugLogger.storage('Intro box cleared');

      await _authBox.clear();
      DebugLogger.storage('Auth box cleared');

      await _userBox.clear();
      DebugLogger.storage('User box cleared');

      DebugLogger.success('All Hive data cleared successfully');
    } catch (e) {
      DebugLogger.error('Failed to clear Hive data - $e');
      throw Exception('Failed to clear Hive data: $e');
    }
  }

  // === INTRO/ONBOARDING METHODS ===

  /// Check if user has watched the intro/onboarding
  static bool hasIntroBeenWatched() {
    DebugLogger.info('Checking if intro has been watched');

    try {
      final result =
          _introBox.get(_introWatchedKey, defaultValue: false) as bool;
      DebugLogger.info('Intro watched status: $result');
      return result;
    } catch (e) {
      DebugLogger.error('Failed to check intro watched status - $e');
      return false;
    }
  }

  /// Mark intro as watched
  static Future<void> setIntroWatched() async {
    DebugLogger.info('Setting intro as watched');

    try {
      await _introBox.put(_introWatchedKey, true);
      DebugLogger.info('Intro marked as watched successfully');
    } catch (e) {
      DebugLogger.error('Failed to set intro watched - $e');
      throw Exception('Failed to set intro watched: $e');
    }
  }

  /// Reset intro watched status (for testing or reset functionality)
  static Future<void> resetIntroWatched() async {
    DebugLogger.intro('Resetting intro watched status');

    try {
      await _introBox.put(_introWatchedKey, false);
      DebugLogger.intro('Intro watched status reset successfully');
    } catch (e) {
      DebugLogger.error('Failed to reset intro watched - $e');
      throw Exception('Failed to reset intro watched: $e');
    }
  }

  // === LANGUAGE SELECTION METHODS ===

  /// Check if user has selected a language
  static bool isLanguageSelected() {
    DebugLogger.intro('Checking if language has been selected');

    try {
      final result =
          _introBox.get(_languageSelectedKey, defaultValue: false) as bool;
      DebugLogger.intro('Language selected status: $result');
      return result;
    } catch (e) {
      DebugLogger.error('Failed to check language selected status - $e');
      return false;
    }
  }

  /// Mark language as selected
  static Future<void> setLanguageSelected() async {
    DebugLogger.intro('Setting language as selected');

    try {
      await _introBox.put(_languageSelectedKey, true);
      DebugLogger.intro('Language marked as selected successfully');
    } catch (e) {
      DebugLogger.error('Failed to set language selected - $e');
      throw Exception('Failed to set language selected: $e');
    }
  }

  /// Get selected language code
  static String? getSelectedLanguage() {
    DebugLogger.intro('Getting selected language code');

    try {
      final language = _introBox.get(_selectedLanguageKey) as String?;
      DebugLogger.intro('Selected language: ${language ?? 'none'}');
      return language;
    } catch (e) {
      DebugLogger.error('Failed to get selected language - $e');
      return null;
    }
  }

  /// Set selected language
  static Future<void> setSelectedLanguage(String languageCode) async {
    DebugLogger.intro('Setting selected language: $languageCode');

    try {
      await _introBox.put(_selectedLanguageKey, languageCode);
      await setLanguageSelected();
      DebugLogger.intro('Language set successfully: $languageCode');
    } catch (e) {
      DebugLogger.error('Failed to set selected language - $e');
      throw Exception('Failed to set selected language: $e');
    }
  }

  /// Reset language selection (for testing or reset functionality)
  static Future<void> resetLanguageSelection() async {
    DebugLogger.intro('Resetting language selection');

    try {
      await _introBox.put(_languageSelectedKey, false);
      await _introBox.delete(_selectedLanguageKey);
      DebugLogger.intro('Language selection reset successfully');
    } catch (e) {
      DebugLogger.error('Failed to reset language selection - $e');
      throw Exception('Failed to reset language selection: $e');
    }
  }

  // === AUTHENTICATION METHODS ===

  /// Check if user is logged in
  /// This method checks the login flag AND validates that user data actually exists
  /// A user is only considered logged in if both conditions are met
  static bool isLoggedIn() {
    DebugLogger.auth('====== COMPREHENSIVE LOGIN STATUS CHECK ======');

    try {
      // Check the basic login flag
      final loginFlag =
          _authBox.get(_isLoggedInKey, defaultValue: false) as bool;
      DebugLogger.auth('Basic login flag: $loginFlag');

      if (!loginFlag) {
        DebugLogger.auth('❌ User not logged in (login flag is false)');
        return false;
      }

      // Check if user data actually exists
      final hasUserData = _hasUserData();
      DebugLogger.auth('User data exists: $hasUserData');

      // Check if auth token exists
      final hasAuthToken = _hasAuthToken();
      DebugLogger.auth('Auth token exists: $hasAuthToken');

      // For a user to be truly logged in, they need:
      // 1. Login flag = true
      // 2. User data must exist
      // Auth token is optional (can be refreshed)
      final isActuallyLoggedIn = loginFlag && hasUserData;

      DebugLogger.auth('====== LOGIN STATUS SUMMARY ======');
      DebugLogger.auth('Login flag: $loginFlag');
      DebugLogger.auth('Has user data: $hasUserData');
      DebugLogger.auth('Has auth token: $hasAuthToken');
      DebugLogger.auth('Final login status: $isActuallyLoggedIn');

      if (loginFlag && !hasUserData) {
        DebugLogger.auth(
            '⚠️ INCONSISTENT STATE: Login flag is true but no user data exists');
        DebugLogger.auth(
            'This suggests a previous login session was not properly cleaned up');
        DebugLogger.auth(
            'User will be directed to welcome screen to re-authenticate');
      }

      return isActuallyLoggedIn;
    } catch (e) {
      DebugLogger.error('Failed to check login status - $e');
      DebugLogger.error('Defaulting to not logged in for safety');
      return false;
    }
  }

  /// Set user login status
  static Future<void> setLoggedIn(bool isLoggedIn) async {
    DebugLogger.auth('Setting user login status: $isLoggedIn');

    try {
      await _authBox.put(_isLoggedInKey, isLoggedIn);
      if (isLoggedIn) {
        await _authBox.put(_lastLoginKey, DateTime.now().toIso8601String());
        DebugLogger.auth('Last login timestamp updated');
      }
      DebugLogger.auth('Login status set successfully: $isLoggedIn');
    } catch (e) {
      DebugLogger.error('Failed to set login status - $e');
      throw Exception('Failed to set login status: $e');
    }
  }

  /// Get auth token
  static String getAuthToken() {
    DebugLogger.auth('Getting auth token');

    try {
      String? token = _authBox.get(_authTokenKey);
      if (token == null) {
        throw Exception('Auth token not found');
      }
      return token;
    } catch (e) {
      DebugLogger.error('Failed to get auth token - $e');
      throw Exception('Auth token not found');
    }
  }

  /// Get AuthTokens object from Hive
  /// Returns AuthTokens object containing both access and refresh tokens
  static AuthTokens? getAuthTokens() {
    DebugLogger.auth('Getting AuthTokens object');

    try {
      final accessToken = _authBox.get(_authTokenKey) as String?;
      final refreshToken = _authBox.get(_refreshTokenKey) as String?;

      if (accessToken == null || accessToken.isEmpty) {
        DebugLogger.auth('No access token found');
        return null;
      }

      final tokens = AuthTokens(
        accessToken: accessToken,
        refreshToken: refreshToken ?? '',
      );

      DebugLogger.auth('AuthTokens retrieved successfully');
      DebugLogger.auth('Access token length: ${accessToken.length}');
      DebugLogger.auth(
          'Has refresh token: ${refreshToken?.isNotEmpty ?? false}');

      return tokens;
    } catch (e) {
      DebugLogger.error('Failed to get AuthTokens - $e');
      return null;
    }
  }

  /// Save AuthTokens object to Hive
  /// Saves both access and refresh tokens from AuthTokens object
  static Future<void> saveAuthTokens(AuthTokens tokens) async {
    DebugLogger.auth('Saving AuthTokens object');
    DebugLogger.auth('Access token length: ${tokens.accessToken.length}');
    DebugLogger.auth('Has refresh token: ${tokens.refreshToken.isNotEmpty}');

    try {
      if (tokens.accessToken.isNotEmpty) {
        await _authBox.put(_authTokenKey, tokens.accessToken);
        DebugLogger.auth('Access token saved successfully');
      }

      if (tokens.refreshToken.isNotEmpty) {
        await _authBox.put(_refreshTokenKey, tokens.refreshToken);
        DebugLogger.auth('Refresh token saved successfully');
      }

      DebugLogger.auth('AuthTokens saved successfully');
    } catch (e) {
      DebugLogger.error('Failed to save AuthTokens - $e');
      throw Exception('Failed to save AuthTokens: $e');
    }
  }

  /// Set auth token
  static Future<void> setAuthToken(String token) async {
    DebugLogger.auth('Setting auth token (length: ${token.length})');

    try {
      await _authBox.put(_authTokenKey, token);
      DebugLogger.auth('Auth token set successfully');
    } catch (e) {
      DebugLogger.error('Failed to set auth token - $e');
      throw Exception('Failed to set auth token: $e');
    }
  }

  /// Remove auth token
  static Future<void> removeAuthToken() async {
    DebugLogger.auth('Removing auth token');

    try {
      await _authBox.delete(_authTokenKey);
      DebugLogger.auth('Auth token removed successfully');
    } catch (e) {
      DebugLogger.error('Failed to remove auth token - $e');
      throw Exception('Failed to remove auth token: $e');
    }
  }

  /// Get refresh token
  static String? getRefreshToken() {
    DebugLogger.auth('Getting refresh token');

    try {
      final token = _authBox.get(_refreshTokenKey) as String?;
      DebugLogger.auth('Refresh token exists: ${token != null}');
      return token;
    } catch (e) {
      DebugLogger.error('Failed to get refresh token - $e');
      return null;
    }
  }

  /// Set refresh token
  static Future<void> setRefreshToken(String token) async {
    DebugLogger.auth('Setting refresh token (length: ${token.length})');

    try {
      await _authBox.put(_refreshTokenKey, token);
      DebugLogger.auth('Refresh token set successfully');
    } catch (e) {
      DebugLogger.error('Failed to set refresh token - $e');
      throw Exception('Failed to set refresh token: $e');
    }
  }

  /// Remove refresh token
  static Future<void> removeRefreshToken() async {
    DebugLogger.auth('Removing refresh token');

    try {
      await _authBox.delete(_refreshTokenKey);
      DebugLogger.auth('Refresh token removed successfully');
    } catch (e) {
      DebugLogger.error('Failed to remove refresh token - $e');
      throw Exception('Failed to remove refresh token: $e');
    }
  }

  /// Remove all authentication tokens
  /// Clears both access and refresh tokens from storage
  static Future<void> removeAllTokens() async {
    DebugLogger.auth('Removing all authentication tokens');

    try {
      await _authBox.delete(_authTokenKey);
      await _authBox.delete(_refreshTokenKey);
      DebugLogger.auth('All authentication tokens removed successfully');
    } catch (e) {
      DebugLogger.error('Failed to remove all tokens - $e');
      throw Exception('Failed to remove all tokens: $e');
    }
  }

  /// Check if we have valid authentication tokens
  /// Returns true if both access token exists, refresh token is optional
  static bool hasValidTokens() {
    DebugLogger.auth('Checking for valid authentication tokens');

    try {
      final accessToken = _authBox.get(_authTokenKey) as String?;
      final hasAccessToken = accessToken != null && accessToken.isNotEmpty;

      DebugLogger.auth('Has access token: $hasAccessToken');

      if (hasAccessToken) {
        final refreshToken = _authBox.get(_refreshTokenKey) as String?;
        DebugLogger.auth(
            'Has refresh token: ${refreshToken?.isNotEmpty ?? false}');
      }

      return hasAccessToken;
    } catch (e) {
      DebugLogger.error('Error checking tokens: $e');
      return false;
    }
  }

  /// Get stored phone number
  static String? getPhoneNumber() {
    DebugLogger.auth('Getting stored phone number');

    try {
      final phoneNumber = _authBox.get(_phoneNumberKey) as String?;
      DebugLogger.auth('Phone number exists: ${phoneNumber != null}');
      return phoneNumber;
    } catch (e) {
      DebugLogger.error('Failed to get phone number - $e');
      return null;
    }
  }

  /// Set phone number
  static Future<void> setPhoneNumber(String phoneNumber) async {
    DebugLogger.auth('Setting phone number: ${phoneNumber.substring(0, 3)}***');

    try {
      await _authBox.put(_phoneNumberKey, phoneNumber);
      DebugLogger.auth('Phone number set successfully');
    } catch (e) {
      DebugLogger.error('Failed to set phone number - $e');
      throw Exception('Failed to set phone number: $e');
    }
  }

  /// Get last login date
  static DateTime? getLastLogin() {
    DebugLogger.auth('Getting last login date');

    try {
      final lastLoginStr = _authBox.get(_lastLoginKey) as String?;
      final lastLogin =
          lastLoginStr != null ? DateTime.parse(lastLoginStr) : null;
      DebugLogger.auth(
          'Last login: ${lastLogin?.toString().substring(0, 19) ?? 'never'}');
      return lastLogin;
    } catch (e) {
      DebugLogger.error('Failed to get last login - $e');
      return null;
    }
  }

  // === USER DATA METHODS ===

  /// Save user data
  /// Stores AppUser data as JSON Map to avoid Hive adapter requirements
  static Future<void> saveUserData(AppUser userData) async {
    DebugLogger.user(
        'Saving user data with ${userData.toJson().keys.length} fields');
    DebugLogger.user('Converting AppUser to JSON for Hive storage');

    try {
      // Convert AppUser to JSON Map for Hive storage
      final userDataJson = userData.toJson();
      DebugLogger.user('User data JSON keys: ${userDataJson.keys.toList()}');
      DebugLogger.user('User type in JSON: ${userDataJson['user_type']}');

      await _userBox.put(_userDataKey, userDataJson);
      DebugLogger.user('User data saved successfully as JSON');
    } catch (e) {
      DebugLogger.error('Failed to save user data - $e');
      throw Exception('Failed to save user data: $e');
    }
  }

  /// Get user data
  /// Retrieves user data from JSON Map and converts back to AppUser
  /// WARNING: This method throws an exception if no user data is found
  /// Use getUserDataSafe() for safer access that returns null instead
  static AppUser getUserData() {
    DebugLogger.user('Getting user data (UNSAFE - throws exception)');

    try {
      final userData = _userBox.get(_userDataKey);
      DebugLogger.user('Raw user data type: ${userData.runtimeType}');

      if (userData == null) {
        DebugLogger.user('No user data found in Hive');
        throw Exception("No user data found");
      }

      // Convert to Map<String, dynamic> if it's not already
      Map<String, dynamic> userDataMap;
      if (userData is Map<String, dynamic>) {
        userDataMap = userData;
      } else if (userData is Map) {
        userDataMap = Map<String, dynamic>.from(userData);
      } else {
        DebugLogger.user(
            'Unexpected user data format: ${userData.runtimeType}');
        throw Exception("Invalid user data format");
      }

      DebugLogger.user('User data map keys: ${userDataMap.keys.toList()}');
      DebugLogger.user('User type from storage: ${userDataMap['user_type']}');

      if (userDataMap.isEmpty) {
        DebugLogger.user('User data map is empty');
        throw Exception("User data is empty");
      }

      final appUser = AppUser.fromJson(userDataMap);
      DebugLogger.user('Successfully converted JSON to AppUser');
      DebugLogger.user('User ID: ${appUser.id}');
      DebugLogger.user('User type: ${appUser.userType}');

      return appUser;
    } catch (e) {
      DebugLogger.error('Failed to get user data - $e');
      throw Exception("Failed to get user data: $e");
    }
  }

  /// Safely get user data without throwing exceptions
  /// Returns null if no user data is found or if there's an error
  /// This is the preferred method for checking user data existence
  static AppUser? getUserDataSafe() {
    DebugLogger.user('====== SAFELY GETTING USER DATA ======');
    DebugLogger.user('This method returns null instead of throwing exceptions');

    try {
      final userData = _userBox.get(_userDataKey);
      DebugLogger.user('Raw user data type: ${userData.runtimeType}');
      DebugLogger.user('User data exists: ${userData != null}');

      if (userData == null) {
        DebugLogger.user('No user data found in Hive - returning null');
        return null;
      }

      // Convert to Map<String, dynamic> if it's not already
      Map<String, dynamic> userDataMap;
      if (userData is Map<String, dynamic>) {
        userDataMap = userData;
        DebugLogger.user('Data is already Map<String, dynamic>');
      } else if (userData is Map) {
        userDataMap = Map<String, dynamic>.from(userData);
        DebugLogger.user('Converted Map to Map<String, dynamic>');
      } else {
        DebugLogger.user(
            '❌ Unexpected user data format: ${userData.runtimeType}');
        DebugLogger.user(
            'Expected Map but got ${userData.runtimeType} - returning null');
        return null;
      }

      DebugLogger.user('User data map keys: ${userDataMap.keys.toList()}');
      DebugLogger.user('User type from storage: ${userDataMap['user_type']}');
      DebugLogger.user('User data map size: ${userDataMap.length} fields');

      if (userDataMap.isEmpty) {
        DebugLogger.user('❌ User data map is empty - returning null');
        return null;
      }

      // Attempt to convert to AppUser
      DebugLogger.user('Converting JSON map to AppUser object...');
      final appUser = AppUser.fromJson(userDataMap);

      DebugLogger.success('Successfully converted JSON to AppUser');
      DebugLogger.user('User ID: ${appUser.id}');
      DebugLogger.user('Username: ${appUser.username}');
      DebugLogger.user('User type: ${appUser.userType}');
      DebugLogger.user(
          'Display name: ${appUser.firstName} ${appUser.lastName}');
      DebugLogger.user('Phone: ${appUser.phoneNumber}');
      DebugLogger.user('Email: ${appUser.email}');
      DebugLogger.user('Is verified: ${appUser.isVerified}');

      return appUser;
    } catch (e, stackTrace) {
      DebugLogger.error('Error getting user data safely - $e');
      DebugLogger.error('Error type: ${e.runtimeType}');
      DebugLogger.error(
          'Stack trace preview: ${stackTrace.toString().split('\n').take(2).join('\n')}');
      DebugLogger.error('Returning null due to error');
      return null;
    }
  }

  /// Clear user data
  static Future<void> clearUserData() async {
    DebugLogger.user('Clearing user data');

    try {
      await _userBox.delete(_userDataKey);
      DebugLogger.user('User data cleared successfully');
    } catch (e) {
      DebugLogger.error('Failed to clear user data - $e');
      throw Exception('Failed to clear user data: $e');
    }
  }

  // === UTILITY METHODS ===

  /// Logout user (clear all auth-related data)
  /// Enhanced logout with comprehensive cleanup
  static Future<void> logout() async {
    DebugLogger.auth('====== PERFORMING COMPREHENSIVE LOGOUT ======');

    try {
      // Set logged in status to false first
      await setLoggedIn(false);
      DebugLogger.auth('Login status set to false');

      // Remove all authentication tokens
      await removeAllTokens();
      DebugLogger.auth('All authentication tokens removed');

      // Clear user data and profile
      await clearUserData();
      DebugLogger.user('User data cleared');

      // Clear phone number for security
      await clearPhoneNumber();
      DebugLogger.auth('Phone number cleared');

      // Clear health check data (optional)
      try {
        await clearHealthCheckData();
        DebugLogger.user('Health check data cleared');
      } catch (e) {
        DebugLogger.error('Failed to clear health check data: $e');
        // Non-critical, continue
      }

      DebugLogger.auth('====== USER LOGOUT COMPLETED SUCCESSFULLY ======');
      // Note: We don't reset intro watched on logout - this preserves onboarding state
    } catch (e) {
      DebugLogger.error('Failed to logout - $e');
      throw Exception('Failed to logout: $e');
    }
  }

  /// Emergency logout - clears all data without throwing exceptions
  /// Use this when normal logout fails and you need to force clear everything
  static Future<void> emergencyLogout() async {
    DebugLogger.auth('====== PERFORMING EMERGENCY LOGOUT ======');
    DebugLogger.auth('⚠️ This is a forced cleanup that ignores errors');

    try {
      await setLoggedIn(false);
    } catch (e) {
      DebugLogger.auth('Emergency: Failed to set login status: $e');
    }

    try {
      await removeAllTokens();
    } catch (e) {
      DebugLogger.auth('Emergency: Failed to remove tokens: $e');
    }

    try {
      await clearUserData();
    } catch (e) {
      DebugLogger.auth('Emergency: Failed to clear user data: $e');
    }

    try {
      await clearPhoneNumber();
    } catch (e) {
      DebugLogger.auth('Emergency: Failed to clear phone number: $e');
    }

    DebugLogger.auth('====== EMERGENCY LOGOUT COMPLETED ======');
  }

  /// Check if this is a first-time user
  static bool isFirstTimeUser() {
    final result = !hasIntroBeenWatched();
    DebugLogger.intro('Is first-time user: $result');
    return result;
  }

  /// Get all stored keys for debugging
  static Map<String, dynamic> getDebugInfo() {
    DebugLogger.debug('Generating debug information');

    try {
      final debugInfo = {
        'intro': {
          'hasIntroBeenWatched': hasIntroBeenWatched(),
          'introBoxKeys': _introBox.keys.toList(),
        },
        'auth': {
          'isLoggedIn': isLoggedIn(),
          'hasAuthToken': _hasAuthToken(),
          'hasValidTokens': hasValidTokens(),
          'phoneNumber': getPhoneNumber(),
          'lastLogin': getLastLogin()?.toIso8601String(),
          'authBoxKeys': _authBox.keys.toList(),
          'tokenInfo': _getTokenDebugInfo(),
        },
        'user': {
          'hasUserData': _hasUserData(),
          'userType': _safeGetUserType(),
          'userBoxKeys': _userBox.keys.toList(),
        },
      };

      DebugLogger.success('Debug info generated successfully');
      return debugInfo;
    } catch (e) {
      DebugLogger.error('Failed to generate debug info - $e');
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

  /// Helper method to get token debug information
  static Map<String, dynamic> _getTokenDebugInfo() {
    try {
      final accessToken = _authBox.get(_authTokenKey) as String?;
      final refreshToken = _authBox.get(_refreshTokenKey) as String?;

      return {
        'hasAccessToken': accessToken != null && accessToken.isNotEmpty,
        'accessTokenLength': accessToken?.length ?? 0,
        'accessTokenPrefix': accessToken != null && accessToken.length > 10
            ? '${accessToken.substring(0, 10)}...'
            : 'none',
        'hasRefreshToken': refreshToken != null && refreshToken.isNotEmpty,
        'refreshTokenLength': refreshToken?.length ?? 0,
        'refreshTokenPrefix': refreshToken != null && refreshToken.length > 10
            ? '${refreshToken.substring(0, 10)}...'
            : 'none',
      };
    } catch (e) {
      return {
        'error': 'Failed to get token info: $e',
        'hasAccessToken': false,
        'hasRefreshToken': false,
      };
    }
  }

  /// Check storage health
  static bool isStorageHealthy() {
    DebugLogger.debug('Checking storage health');

    try {
      // Try to perform basic operations on each box
      _introBox.containsKey(_introWatchedKey);
      _authBox.containsKey(_isLoggedInKey);
      _userBox.containsKey(_userDataKey);

      DebugLogger.success('Storage health check passed');
      return true;
    } catch (e) {
      DebugLogger.error('Storage health check failed - $e');
      return false;
    }
  }

  // === SYNC DATA METHODS ===

  /// Save user profile for sync
  /// Stores user profile data as JSON Map to avoid Hive adapter requirements
  static Future<void> saveUserProfile(AppUser profileData) async {
    DebugLogger.user(
        'Saving user profile with ${profileData.toJson().keys.length} fields');
    DebugLogger.user('Converting AppUser profile to JSON for Hive storage');

    try {
      // Convert AppUser to JSON Map for Hive storage
      final profileDataJson = profileData.toJson();
      DebugLogger.user(
          'Profile data JSON keys: ${profileDataJson.keys.toList()}');

      await _userBox.put(_userProfileKey, profileDataJson);
      DebugLogger.user('User profile saved successfully as JSON');
    } catch (e) {
      DebugLogger.error('Failed to save user profile - $e');
      throw Exception('Failed to save user profile: $e');
    }
  }

  /// Get cached user profile
  static Map<String, dynamic>? getUserProfile() {
    DebugLogger.user('Getting cached user profile');

    try {
      final profileData = _userBox.get(_userProfileKey);
      final result =
          profileData != null ? Map<String, dynamic>.from(profileData) : null;
      DebugLogger.user('User profile exists: ${result != null}');
      return result;
    } catch (e) {
      DebugLogger.error('Failed to get user profile - $e');
      return null;
    }
  }

  /// Save health check timestamp
  static Future<void> saveLastHealthCheck(DateTime timestamp) async {
    DebugLogger.user(
        'Saving health check timestamp: ${timestamp.toString().substring(0, 19)}');

    try {
      await _userBox.put(_lastHealthCheckKey, timestamp.millisecondsSinceEpoch);
      DebugLogger.user('Health check timestamp saved successfully');
    } catch (e) {
      DebugLogger.error('Failed to save health check timestamp - $e');
      throw Exception('Failed to save health check timestamp: $e');
    }
  }

  /// Get last health check timestamp
  static DateTime? getLastHealthCheck() {
    DebugLogger.user('Getting last health check timestamp');

    try {
      final timestamp = _userBox.get(_lastHealthCheckKey);
      final result = timestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(timestamp)
          : null;
      DebugLogger.user(
          'Last health check: ${result?.toString().substring(0, 19) ?? 'never'}');
      return result;
    } catch (e) {
      DebugLogger.error('Failed to get last health check - $e');
      return null;
    }
  }

  /// Save health check status
  static Future<void> saveHealthCheckStatus(String status) async {
    DebugLogger.user('Saving health check status: $status');

    try {
      await _userBox.put(_healthCheckStatusKey, status);
      DebugLogger.user('Health check status saved successfully');
    } catch (e) {
      DebugLogger.error('Failed to save health check status - $e');
      throw Exception('Failed to save health check status: $e');
    }
  }

  /// Get cached health check status
  static String? getHealthCheckStatus() {
    DebugLogger.user('Getting cached health check status');

    try {
      final status = _userBox.get(_healthCheckStatusKey);
      DebugLogger.user('Health check status: ${status ?? 'unknown'}');
      return status;
    } catch (e) {
      DebugLogger.error('Failed to get health check status - $e');
      return null;
    }
  }

  /// Save health check result
  static Future<void> saveHealthCheckResult(Map<String, dynamic> result) async {
    DebugLogger.user(
        'Saving health check result with ${result.keys.length} fields');

    try {
      await _userBox.put(_healthCheckResultKey, result);
      DebugLogger.user('Health check result saved successfully');
    } catch (e) {
      DebugLogger.error('Failed to save health check result - $e');
      throw Exception('Failed to save health check result: $e');
    }
  }

  /// Get cached health check result
  static Map<String, dynamic>? getHealthCheckResult() {
    DebugLogger.user('Getting cached health check result');

    try {
      final result = _userBox.get(_healthCheckResultKey);
      final data = result != null ? Map<String, dynamic>.from(result) : null;
      DebugLogger.user('Health check result exists: ${data != null}');
      return data;
    } catch (e) {
      DebugLogger.error('Failed to get health check result - $e');
      return null;
    }
  }

  /// Check if health check is needed (based on time interval)
  static bool isHealthCheckNeeded(
      {Duration interval = const Duration(minutes: 30)}) {
    DebugLogger.user(
        'Checking if health check is needed (interval: ${interval.inMinutes} minutes)');

    try {
      final lastCheck = getLastHealthCheck();
      if (lastCheck == null) {
        DebugLogger.user('Health check needed - no previous check found');
        return true;
      }

      final timeSinceLastCheck = DateTime.now().difference(lastCheck);
      final isNeeded = timeSinceLastCheck >= interval;

      DebugLogger.user(
          'Time since last check: ${timeSinceLastCheck.inMinutes} minutes');
      DebugLogger.user('Health check needed: $isNeeded');

      return isNeeded;
    } catch (e) {
      DebugLogger.error('Failed to check if health check needed - $e');
      return true; // If we can't determine, better to check
    }
  }

  /// Clear health check data
  static Future<void> clearHealthCheckData() async {
    DebugLogger.user('Clearing health check data');

    try {
      await _userBox.delete(_lastHealthCheckKey);
      await _userBox.delete(_healthCheckStatusKey);
      await _userBox.delete(_healthCheckResultKey);
      DebugLogger.user('Health check data cleared successfully');
    } catch (e) {
      DebugLogger.error('Failed to clear health check data - $e');
      throw Exception('Failed to clear health check data: $e');
    }
  }

  // === USER TYPE DETECTION METHODS ===

  /// Get user type from stored user data
  static UserType getUserType() {
    DebugLogger.user('Getting user type');

    try {
      final userData = getUserData();
      // final userType = userData.userType;
      return userData.userType;
    } catch (e) {
      DebugLogger.error('Failed to get user type - $e');
      return UserType.customer; // Default fallback
    }
  }

  /// Check if current user is a provider
  static bool isProvider() {
    final result = getUserType() == UserType.provider;
    DebugLogger.user('Is provider: $result');
    return result;
  }

  /// Check if current user is a customer
  static bool isCustomer() {
    final userType = getUserType();
    final result = userType == UserType.customer;
    DebugLogger.user('Is customer: $result');
    return result;
  }

  /// Check if current user is an admin
  static bool isAdmin() {
    final result = getUserType() == UserType.admin;
    DebugLogger.user('Is admin: $result');
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
    DebugLogger.user('User type display name: $displayName');
    return displayName;
  }

  /// Get user type color for UI
  static int getUserTypeColor() {
    final color = switch (getUserType()) {
      UserType.provider => 0xFF10B981, // Emerald
      UserType.admin => 0xFF8B5CF6, // Violet
      UserType.customer => 0xFF3B82F6, // Blue
    };
    DebugLogger.user(
        'User type color: 0x${color.toRadixString(16).toUpperCase()}');
    return color;
  }

  /// Get user type icon for UI
  static int getUserTypeIconCodePoint() {
    final iconCode = switch (getUserType()) {
      UserType.provider => 0xf0ad, // tools icon
      UserType.admin => 0xf521, // crown icon
      UserType.customer => 0xf2c0, // user icon
    };
    DebugLogger.user('User type icon code: 0x${iconCode.toRadixString(16)}');
    return iconCode;
  }

  /// Update user type in stored data
  static Future<void> updateUserType(UserType userType) async {
    try {
      AppUser userData = getUserData();
      userData = userData.copyWith(userType: userType);
      await saveUserData(userData);
      DebugLogger.user('User type updated successfully');
    } catch (e) {
      DebugLogger.error('Failed to update user type - $e');
      throw Exception('Failed to update user type: $e');
    }
  }

  /// Set user type (alias for updateUserType)
  static Future<void> setUserType(UserType userType) async {
    DebugLogger.user('Setting user type: $userType');
    await updateUserType(userType);
  }

  /// Clear user type from stored data
  static Future<void> clearUserType() async {
    DebugLogger.user('Clearing user type');

    try {
      AppUser userData = getUserData();
      userData = userData.copyWith(userType: UserType.customer);
      await saveUserData(userData);
      DebugLogger.user('User type cleared successfully');
    } catch (e) {
      DebugLogger.error('Failed to clear user type - $e');
      throw Exception('Failed to clear user type: $e');
    }
  }

  /// Clear phone number
  static Future<void> clearPhoneNumber() async {
    DebugLogger.auth('Clearing phone number');

    try {
      await _authBox.delete(_phoneNumberKey);
      DebugLogger.auth('Phone number cleared successfully');
    } catch (e) {
      DebugLogger.error('Failed to clear phone number - $e');
      throw Exception('Failed to clear phone number: $e');
    }
  }
}
