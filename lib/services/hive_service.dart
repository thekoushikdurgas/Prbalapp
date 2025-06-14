import 'package:hive_flutter/hive_flutter.dart';

/// Service class for managing Hive database operations
class HiveService {
  const HiveService._();

  // Box names
  static const String _introBoxName = 'intro';
  static const String _authBoxName = 'auth';
  static const String _userBoxName = 'user';
  static const String _syncBoxName = 'sync';
  static const String _offlineBoxName = 'offline';

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
  static const String _syncedServicesKey = 'syncedServices';
  static const String _offlineBidsKey = 'offlineBids';
  static const String _offlineBookingsKey = 'offlineBookings';
  static const String _offlineMessagesKey = 'offlineMessages';

  // Health check tracking keys
  static const String _lastHealthCheckKey = 'lastHealthCheck';
  static const String _healthCheckStatusKey = 'healthCheckStatus';
  static const String _healthCheckResultKey = 'healthCheckResult';

  // Lazy boxes for better performance
  static late Box _introBox;
  static late Box _authBox;
  static late Box _userBox;
  static late Box _syncBox;
  static late Box _offlineBox;

  /// Initialize all Hive boxes
  static Future<void> init() async {
    try {
      await Hive.initFlutter();

      // Open boxes
      _introBox = await Hive.openBox(_introBoxName);
      _authBox = await Hive.openBox(_authBoxName);
      _userBox = await Hive.openBox(_userBoxName);
      _syncBox = await Hive.openBox(_syncBoxName);
      _offlineBox = await Hive.openBox(_offlineBoxName);
    } catch (e) {
      throw Exception('Failed to initialize Hive: $e');
    }
  }

  /// Close all boxes (call this when app is closing)
  static Future<void> close() async {
    try {
      await _introBox.close();
      await _authBox.close();
      await _userBox.close();
      await _syncBox.close();
      await _offlineBox.close();
    } catch (e) {
      throw Exception('Failed to close Hive boxes: $e');
    }
  }

  /// Clear all data (useful for logout or reset)
  static Future<void> clearAll() async {
    try {
      await _introBox.clear();
      await _authBox.clear();
      await _userBox.clear();
      await _syncBox.clear();
      await _offlineBox.clear();
    } catch (e) {
      throw Exception('Failed to clear Hive data: $e');
    }
  }

  // === INTRO/ONBOARDING METHODS ===

  /// Check if user has watched the intro/onboarding
  static bool hasIntroBeenWatched() {
    try {
      return _introBox.get(_introWatchedKey, defaultValue: false) as bool;
    } catch (e) {
      return false;
    }
  }

  /// Mark intro as watched
  static Future<void> setIntroWatched() async {
    try {
      await _introBox.put(_introWatchedKey, true);
    } catch (e) {
      throw Exception('Failed to set intro watched: $e');
    }
  }

  /// Reset intro watched status (for testing or reset functionality)
  static Future<void> resetIntroWatched() async {
    try {
      await _introBox.put(_introWatchedKey, false);
    } catch (e) {
      throw Exception('Failed to reset intro watched: $e');
    }
  }

  // === LANGUAGE SELECTION METHODS ===

  /// Check if user has selected a language
  static bool isLanguageSelected() {
    try {
      return _introBox.get(_languageSelectedKey, defaultValue: false) as bool;
    } catch (e) {
      return false;
    }
  }

  /// Mark language as selected
  static Future<void> setLanguageSelected() async {
    try {
      await _introBox.put(_languageSelectedKey, true);
    } catch (e) {
      throw Exception('Failed to set language selected: $e');
    }
  }

  /// Get selected language code
  static String? getSelectedLanguage() {
    try {
      return _introBox.get(_selectedLanguageKey) as String?;
    } catch (e) {
      return null;
    }
  }

  /// Set selected language
  static Future<void> setSelectedLanguage(String languageCode) async {
    try {
      await _introBox.put(_selectedLanguageKey, languageCode);
      await setLanguageSelected();
    } catch (e) {
      throw Exception('Failed to set selected language: $e');
    }
  }

  /// Reset language selection (for testing or reset functionality)
  static Future<void> resetLanguageSelection() async {
    try {
      await _introBox.put(_languageSelectedKey, false);
      await _introBox.delete(_selectedLanguageKey);
    } catch (e) {
      throw Exception('Failed to reset language selection: $e');
    }
  }

  // === AUTHENTICATION METHODS ===

  /// Check if user is logged in
  static bool isLoggedIn() {
    try {
      return _authBox.get(_isLoggedInKey, defaultValue: false) as bool;
    } catch (e) {
      return false;
    }
  }

  /// Set user login status
  static Future<void> setLoggedIn(bool isLoggedIn) async {
    try {
      await _authBox.put(_isLoggedInKey, isLoggedIn);
      if (isLoggedIn) {
        await _authBox.put(_lastLoginKey, DateTime.now().toIso8601String());
      }
    } catch (e) {
      throw Exception('Failed to set login status: $e');
    }
  }

  /// Get auth token
  static String? getAuthToken() {
    try {
      return _authBox.get(_authTokenKey) as String?;
    } catch (e) {
      return null;
    }
  }

  /// Set auth token
  static Future<void> setAuthToken(String token) async {
    try {
      await _authBox.put(_authTokenKey, token);
    } catch (e) {
      throw Exception('Failed to set auth token: $e');
    }
  }

  /// Remove auth token
  static Future<void> removeAuthToken() async {
    try {
      await _authBox.delete(_authTokenKey);
    } catch (e) {
      throw Exception('Failed to remove auth token: $e');
    }
  }

  /// Get refresh token
  static String? getRefreshToken() {
    try {
      return _authBox.get(_refreshTokenKey) as String?;
    } catch (e) {
      return null;
    }
  }

  /// Set refresh token
  static Future<void> setRefreshToken(String token) async {
    try {
      await _authBox.put(_refreshTokenKey, token);
    } catch (e) {
      throw Exception('Failed to set refresh token: $e');
    }
  }

  /// Remove refresh token
  static Future<void> removeRefreshToken() async {
    try {
      await _authBox.delete(_refreshTokenKey);
    } catch (e) {
      throw Exception('Failed to remove refresh token: $e');
    }
  }

  /// Get stored phone number
  static String? getPhoneNumber() {
    try {
      return _authBox.get(_phoneNumberKey) as String?;
    } catch (e) {
      return null;
    }
  }

  /// Set phone number
  static Future<void> setPhoneNumber(String phoneNumber) async {
    try {
      await _authBox.put(_phoneNumberKey, phoneNumber);
    } catch (e) {
      throw Exception('Failed to set phone number: $e');
    }
  }

  /// Get last login date
  static DateTime? getLastLogin() {
    try {
      final lastLoginStr = _authBox.get(_lastLoginKey) as String?;
      return lastLoginStr != null ? DateTime.parse(lastLoginStr) : null;
    } catch (e) {
      return null;
    }
  }

  // === USER DATA METHODS ===

  /// Save user data
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      await _userBox.put(_userDataKey, userData);
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  /// Get user data
  static Map<String, dynamic>? getUserData() {
    try {
      final userData = _userBox.get(_userDataKey);
      return userData != null ? Map<String, dynamic>.from(userData) : null;
    } catch (e) {
      return null;
    }
  }

  /// Clear user data
  static Future<void> clearUserData() async {
    try {
      await _userBox.delete(_userDataKey);
    } catch (e) {
      throw Exception('Failed to clear user data: $e');
    }
  }

  // === UTILITY METHODS ===

  /// Logout user (clear all auth-related data)
  static Future<void> logout() async {
    try {
      await setLoggedIn(false);
      await removeAuthToken();
      await removeRefreshToken();
      await clearUserData();
      // Note: We don't reset intro watched on logout
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  /// Check if this is a first-time user
  static bool isFirstTimeUser() {
    return !hasIntroBeenWatched();
  }

  /// Get all stored keys for debugging
  static Map<String, dynamic> getDebugInfo() {
    try {
      return {
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
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  /// Check storage health
  static bool isStorageHealthy() {
    try {
      // Try to perform basic operations on each box
      _introBox.containsKey(_introWatchedKey);
      _authBox.containsKey(_isLoggedInKey);
      _userBox.containsKey(_userDataKey);
      _syncBox.containsKey(_userProfileKey);
      _offlineBox.containsKey(_offlineBidsKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  // === SYNC DATA METHODS ===

  /// Save user profile for sync
  static Future<void> saveUserProfile(Map<String, dynamic> profileData) async {
    try {
      await _syncBox.put(_userProfileKey, profileData);
    } catch (e) {
      throw Exception('Failed to save user profile: $e');
    }
  }

  /// Get cached user profile
  static Map<String, dynamic>? getUserProfile() {
    try {
      final profileData = _syncBox.get(_userProfileKey);
      return profileData != null
          ? Map<String, dynamic>.from(profileData)
          : null;
    } catch (e) {
      return null;
    }
  }

  /// Save synced services
  static Future<void> saveSyncedServices(
      Map<String, dynamic> servicesData) async {
    try {
      await _syncBox.put(_syncedServicesKey, servicesData);
    } catch (e) {
      throw Exception('Failed to save synced services: $e');
    }
  }

  /// Get synced services
  static Map<String, dynamic>? getSyncedServices() {
    try {
      final servicesData = _syncBox.get(_syncedServicesKey);
      return servicesData != null
          ? Map<String, dynamic>.from(servicesData)
          : null;
    } catch (e) {
      return null;
    }
  }

  /// Clear all sync data
  static Future<void> clearSyncData() async {
    try {
      await _syncBox.clear();
    } catch (e) {
      throw Exception('Failed to clear sync data: $e');
    }
  }

  // === OFFLINE DATA METHODS ===

  /// Save offline bid
  static Future<void> saveOfflineBid(
      String tempId, Map<String, dynamic> bidData) async {
    try {
      final currentBids = getOfflineBids();
      currentBids[tempId] = bidData;
      await _offlineBox.put(_offlineBidsKey, currentBids);
    } catch (e) {
      throw Exception('Failed to save offline bid: $e');
    }
  }

  /// Get all offline bids
  static Map<String, dynamic> getOfflineBids() {
    try {
      final bidsData = _offlineBox.get(_offlineBidsKey);
      return bidsData != null ? Map<String, dynamic>.from(bidsData) : {};
    } catch (e) {
      return {};
    }
  }

  /// Remove offline bid
  static Future<void> removeOfflineBid(String tempId) async {
    try {
      final currentBids = getOfflineBids();
      currentBids.remove(tempId);
      await _offlineBox.put(_offlineBidsKey, currentBids);
    } catch (e) {
      throw Exception('Failed to remove offline bid: $e');
    }
  }

  /// Save offline booking
  static Future<void> saveOfflineBooking(
      String tempId, Map<String, dynamic> bookingData) async {
    try {
      final currentBookings = getOfflineBookings();
      currentBookings[tempId] = bookingData;
      await _offlineBox.put(_offlineBookingsKey, currentBookings);
    } catch (e) {
      throw Exception('Failed to save offline booking: $e');
    }
  }

  /// Get all offline bookings
  static Map<String, dynamic> getOfflineBookings() {
    try {
      final bookingsData = _offlineBox.get(_offlineBookingsKey);
      return bookingsData != null
          ? Map<String, dynamic>.from(bookingsData)
          : {};
    } catch (e) {
      return {};
    }
  }

  /// Remove offline booking
  static Future<void> removeOfflineBooking(String tempId) async {
    try {
      final currentBookings = getOfflineBookings();
      currentBookings.remove(tempId);
      await _offlineBox.put(_offlineBookingsKey, currentBookings);
    } catch (e) {
      throw Exception('Failed to remove offline booking: $e');
    }
  }

  /// Save offline message
  static Future<void> saveOfflineMessage(
      String tempId, Map<String, dynamic> messageData) async {
    try {
      final currentMessages = getOfflineMessages();
      currentMessages[tempId] = messageData;
      await _offlineBox.put(_offlineMessagesKey, currentMessages);
    } catch (e) {
      throw Exception('Failed to save offline message: $e');
    }
  }

  /// Get all offline messages
  static Map<String, dynamic> getOfflineMessages() {
    try {
      final messagesData = _offlineBox.get(_offlineMessagesKey);
      return messagesData != null
          ? Map<String, dynamic>.from(messagesData)
          : {};
    } catch (e) {
      return {};
    }
  }

  /// Remove offline message
  static Future<void> removeOfflineMessage(String tempId) async {
    try {
      final currentMessages = getOfflineMessages();
      currentMessages.remove(tempId);
      await _offlineBox.put(_offlineMessagesKey, currentMessages);
    } catch (e) {
      throw Exception('Failed to remove offline message: $e');
    }
  }

  /// Get all offline data count for status display
  static Map<String, int> getOfflineDataCounts() {
    return {
      'bids': getOfflineBids().length,
      'bookings': getOfflineBookings().length,
      'messages': getOfflineMessages().length,
    };
  }

  /// Check if there's any pending offline data
  static bool hasPendingOfflineData() {
    final counts = getOfflineDataCounts();
    return counts.values.any((count) => count > 0);
  }

  /// Clear all offline data
  static Future<void> clearOfflineData() async {
    try {
      await _offlineBox.clear();
    } catch (e) {
      throw Exception('Failed to clear offline data: $e');
    }
  }

  /// Save health check timestamp
  static Future<void> saveLastHealthCheck(DateTime timestamp) async {
    try {
      await _syncBox.put(_lastHealthCheckKey, timestamp.millisecondsSinceEpoch);
    } catch (e) {
      throw Exception('Failed to save health check timestamp: $e');
    }
  }

  /// Get last health check timestamp
  static DateTime? getLastHealthCheck() {
    try {
      final timestamp = _syncBox.get(_lastHealthCheckKey);
      return timestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(timestamp)
          : null;
    } catch (e) {
      return null;
    }
  }

  /// Save health check status
  static Future<void> saveHealthCheckStatus(String status) async {
    try {
      await _syncBox.put(_healthCheckStatusKey, status);
    } catch (e) {
      throw Exception('Failed to save health check status: $e');
    }
  }

  /// Get cached health check status
  static String? getHealthCheckStatus() {
    try {
      return _syncBox.get(_healthCheckStatusKey);
    } catch (e) {
      return null;
    }
  }

  /// Save health check result
  static Future<void> saveHealthCheckResult(Map<String, dynamic> result) async {
    try {
      await _syncBox.put(_healthCheckResultKey, result);
    } catch (e) {
      throw Exception('Failed to save health check result: $e');
    }
  }

  /// Get cached health check result
  static Map<String, dynamic>? getHealthCheckResult() {
    try {
      final result = _syncBox.get(_healthCheckResultKey);
      return result != null ? Map<String, dynamic>.from(result) : null;
    } catch (e) {
      return null;
    }
  }

  /// Check if health check is needed (based on time interval)
  static bool isHealthCheckNeeded(
      {Duration interval = const Duration(minutes: 30)}) {
    try {
      final lastCheck = getLastHealthCheck();
      if (lastCheck == null) return true;

      final timeSinceLastCheck = DateTime.now().difference(lastCheck);
      return timeSinceLastCheck >= interval;
    } catch (e) {
      return true; // If we can't determine, better to check
    }
  }

  /// Clear health check data
  static Future<void> clearHealthCheckData() async {
    try {
      await _syncBox.delete(_lastHealthCheckKey);
      await _syncBox.delete(_healthCheckStatusKey);
      await _syncBox.delete(_healthCheckResultKey);
    } catch (e) {
      throw Exception('Failed to clear health check data: $e');
    }
  }

  // === USER TYPE DETECTION METHODS ===

  /// Get user type from stored user data
  static String getUserType() {
    try {
      final userData = getUserData();
      final userType = userData?['userType'] as String?;
      return _normalizeUserType(userType);
    } catch (e) {
      return 'customer'; // Default fallback
    }
  }

  /// Check if current user is a provider
  static bool isProvider() {
    return getUserType() == 'provider';
  }

  /// Check if current user is a customer
  static bool isCustomer() {
    final userType = getUserType();
    return userType == 'customer' || userType == 'taker';
  }

  /// Check if current user is an admin
  static bool isAdmin() {
    return getUserType() == 'admin';
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
    switch (getUserType()) {
      case 'provider':
        return 'Service Provider';
      case 'admin':
        return 'Administrator';
      case 'customer':
      default:
        return 'Customer';
    }
  }

  /// Get user type color for UI
  static int getUserTypeColor() {
    switch (getUserType()) {
      case 'provider':
        return 0xFF10B981; // Emerald
      case 'admin':
        return 0xFF8B5CF6; // Violet
      case 'customer':
      default:
        return 0xFF3B82F6; // Blue
    }
  }

  /// Get user type icon for UI
  static int getUserTypeIconCodePoint() {
    switch (getUserType()) {
      case 'provider':
        return 0xf0ad; // tools icon
      case 'admin':
        return 0xf521; // crown icon
      case 'customer':
      default:
        return 0xf2c0; // user icon
    }
  }

  /// Update user type in stored data
  static Future<void> updateUserType(String userType) async {
    try {
      final userData = getUserData();
      if (userData != null) {
        userData['userType'] = _normalizeUserType(userType);
        await saveUserData(userData);
      }
    } catch (e) {
      throw Exception('Failed to update user type: $e');
    }
  }
}
