import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbal/services/user_service.dart';
import 'package:prbal/services/hive_service.dart';

/// Authentication State Class
///
/// Represents the current authentication state of the user including:
/// - Authentication status
/// - Access and refresh tokens
/// - User data and type
/// - Session management
class AuthenticationState {
  final bool isAuthenticated;
  final String? accessToken;
  final String? refreshToken;
  final AppUser? userData;
  final UserType userType;
  final DateTime? tokenExpiresAt;
  final bool isLoading;
  final String? error;

  const AuthenticationState({
    this.isAuthenticated = false,
    this.accessToken,
    this.refreshToken,
    this.userData,
    required this.userType,
    this.tokenExpiresAt,
    this.isLoading = false,
    this.error,
  });

  /// Create initial/default state
  const AuthenticationState.initial()
      : isAuthenticated = false,
        accessToken = null,
        refreshToken = null,
        userData = null,
        userType = UserType.customer,
        tokenExpiresAt = null,
        isLoading = false,
        error = null;

  /// Create loading state
  AuthenticationState copyWithLoading({bool? isLoading}) {
    return AuthenticationState(
      isAuthenticated: isAuthenticated,
      accessToken: accessToken,
      refreshToken: refreshToken,
      userData: userData,
      userType: userType,
      tokenExpiresAt: tokenExpiresAt,
      isLoading: isLoading ?? this.isLoading,
      error: null, // Clear error on loading
    );
  }

  /// Create state with error
  AuthenticationState copyWithError(String error) {
    return AuthenticationState(
      isAuthenticated: isAuthenticated,
      accessToken: accessToken,
      refreshToken: refreshToken,
      userData: userData,
      userType: userType,
      tokenExpiresAt: tokenExpiresAt,
      isLoading: false,
      error: error,
    );
  }

  /// Create authenticated state
  AuthenticationState copyWithAuthentication({
    required String accessToken,
    String? refreshToken,
    required AppUser userData,
    required UserType userType,
    DateTime? tokenExpiresAt,
  }) {
    return AuthenticationState(
      isAuthenticated: true,
      accessToken: accessToken,
      refreshToken: refreshToken,
      userData: userData,
      userType: userType,
      tokenExpiresAt: tokenExpiresAt,
      isLoading: false,
      error: null,
    );
  }

  /// Create unauthenticated state
  AuthenticationState copyWithLogout() {
    return const AuthenticationState.initial();
  }

  /// Check if token is expired
  bool get isTokenExpired {
    if (tokenExpiresAt == null) return false;
    return DateTime.now().isAfter(tokenExpiresAt!);
  }

  /// Get user display name
  String get displayName {
    final firstName = userData?.firstName;
    final lastName = userData?.lastName;
    final username = userData?.username;

    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName;
    } else if (username != null) {
      return username;
    }

    return 'User';
  }

  @override
  String toString() {
    return 'AuthenticationState(isAuthenticated: $isAuthenticated, userType: $userType, isLoading: $isLoading, error: $error)';
  }
}

/// Authentication Notifier Class
///
/// Manages authentication state using StateNotifier
/// Handles login, logout, token refresh, and state persistence
class AuthenticationNotifier extends StateNotifier<AuthenticationState> {
  final UserService _userService;

  AuthenticationNotifier(this._userService) : super(const AuthenticationState.initial()) {
    debugPrint('🔐 AuthenticationNotifier: Initializing authentication notifier');
  }

  /// Initialize authentication state from local storage
  Future<void> initialize() async {
    debugPrint('🔐 AuthenticationNotifier: Initializing authentication state');

    try {
      state = state.copyWithLoading(isLoading: true);

      // Check if user is logged in via Hive
      final isLoggedIn = HiveService.isLoggedIn();

      if (!isLoggedIn) {
        debugPrint('🔐 AuthenticationNotifier: No saved login state found');
        state = const AuthenticationState.initial();
        return;
      }

      // Get saved user data and tokens
      final userData = HiveService.getUserData();
      final UserType userType = HiveService.getUserType();
      // HiveService.getPhoneNumber();
      final authToken = HiveService.getAuthToken();
      final refreshToken = HiveService.getRefreshToken();

      // if (userData != null) {
      //   debugPrint('🔐 AuthenticationNotifier: Restored user data from Hive');
      //   debugPrint('🔐 → User type: $userType');
      //   debugPrint('🔐 → Phone: $phoneNumber');
      //   debugPrint('🔐 → Auth token exists: ✅');
      //   debugPrint('🔐 → Refresh token exists: ${refreshToken != null ? '✅' : '❌'}');

      // Create authenticated state with actual tokens
      state = state.copyWithAuthentication(
        accessToken: authToken,
        refreshToken: refreshToken,
        userData: userData,
        userType: userType,
      );

      debugPrint('🔐 AuthenticationNotifier: Authentication state restored successfully');
      // } else {
      debugPrint('🔐 AuthenticationNotifier: No valid user data or auth token found in Hive');
      // debugPrint('🔐 → User data exists: ${userData.isNotEmpty}');
      // debugPrint('🔐 → Auth token exists: ${authToken != null}');
      state = const AuthenticationState.initial();
      // }
    } catch (e) {
      debugPrint('🔐 AuthenticationNotifier: Error initializing: $e');
      state = state.copyWithError('Failed to initialize authentication: $e');
    }
  }

  /// Set authenticated state
  Future<void> setAuthenticated({
    required String accessToken,
    String? refreshToken,
    required AppUser userData,
    required UserType userType,
    DateTime? tokenExpiresAt,
  }) async {
    debugPrint('🔐 AuthenticationNotifier: Setting authenticated state');
    debugPrint('🔐 → User type: $userType');
    debugPrint('🔐 → Has refresh token: ${refreshToken != null}');

    try {
      // Update state
      state = state.copyWithAuthentication(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userData: userData,
        userType: userType,
        tokenExpiresAt: tokenExpiresAt,
      );

      // Persist to local storage
      await HiveService.setLoggedIn(true);
      await HiveService.saveUserData(userData);
      await HiveService.setUserType(userType);

      // 🔑 CRITICAL FIX: Save auth tokens to Hive
      await HiveService.setAuthToken(accessToken);
      if (refreshToken != null) {
        await HiveService.setRefreshToken(refreshToken);
      }

      // Save phone number if available
      final phoneNumber = userData.phoneNumber;
      if (phoneNumber != null) {
        await HiveService.setPhoneNumber(phoneNumber);
      }

      debugPrint('🔐 AuthenticationNotifier: Authentication state set and persisted');
      debugPrint('🔐 → Auth token saved to Hive: ✅');
      debugPrint('🔐 → Refresh token saved to Hive: ${refreshToken != null ? '✅' : '❌'}');
    } catch (e) {
      debugPrint('🔐 AuthenticationNotifier: Error setting authenticated state: $e');
      state = state.copyWithError('Failed to set authentication: $e');
    }
  }

  /// Logout user
  Future<void> logout() async {
    debugPrint('🔐 AuthenticationNotifier: Logging out user');

    try {
      state = state.copyWithLoading(isLoading: true);

      // Clear local storage
      await HiveService.setLoggedIn(false);
      await HiveService.clearUserData();
      await HiveService.clearUserType();
      await HiveService.clearPhoneNumber();

      // 🔑 CRITICAL FIX: Remove auth tokens from Hive
      await HiveService.removeAuthToken();
      await HiveService.removeRefreshToken();

      // Update state
      state = state.copyWithLogout();

      debugPrint('🔐 AuthenticationNotifier: User logged out successfully');
      debugPrint('🔐 → Auth tokens cleared from Hive: ✅');
    } catch (e) {
      debugPrint('🔐 AuthenticationNotifier: Error during logout: $e');
      state = state.copyWithError('Failed to logout: $e');
    }
  }

  /// Refresh access token
  Future<bool> refreshAccessToken() async {
    debugPrint('🔐 AuthenticationNotifier: Attempting to refresh access token');

    if (state.refreshToken == null) {
      debugPrint('🔐 AuthenticationNotifier: No refresh token available');
      return false;
    }

    try {
      state = state.copyWithLoading(isLoading: true);

      // Use UserService to refresh token
      final response = await _userService.refreshToken(state.refreshToken!);

      if (response.isSuccess && response.data != null) {
        final newAccessToken = response.data!['access_token'] ?? response.data!['accessToken'];
        final newRefreshToken = response.data!['refresh_token'] ?? response.data!['refreshToken'];

        if (newAccessToken != null) {
          // Update state with new tokens
          state = state.copyWithAuthentication(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken ?? state.refreshToken,
            userData: state.userData!,
            userType: state.userType,
          );

          // 🔑 CRITICAL FIX: Update tokens in Hive storage
          await HiveService.setAuthToken(newAccessToken);
          if (newRefreshToken != null) {
            await HiveService.setRefreshToken(newRefreshToken);
          }

          debugPrint('🔐 AuthenticationNotifier: Access token refreshed successfully');
          debugPrint('🔐 → Updated auth token in Hive: ✅');
          debugPrint('🔐 → Updated refresh token in Hive: ${newRefreshToken != null ? '✅' : '❌'}');
          return true;
        }
      }

      debugPrint('🔐 AuthenticationNotifier: Token refresh failed: ${response.message}');
      return false;
    } catch (e) {
      debugPrint('🔐 AuthenticationNotifier: Error refreshing token: $e');
      state = state.copyWithError('Failed to refresh token: $e');
      return false;
    }
  }

  /// Update user data
  Future<void> updateUserData(AppUser newUserData) async {
    debugPrint('🔐 AuthenticationNotifier: Updating user data');

    try {
      if (!state.isAuthenticated) {
        debugPrint('🔐 AuthenticationNotifier: Cannot update user data - not authenticated');
        return;
      }

      // Merge new data with existing data
      final updatedUserData = newUserData;

      // Update state
      state = state.copyWithAuthentication(
        accessToken: state.accessToken!,
        refreshToken: state.refreshToken,
        userData: updatedUserData,
        userType: state.userType,
        tokenExpiresAt: state.tokenExpiresAt,
      );

      // Persist to local storage
      await HiveService.saveUserData(updatedUserData);

      debugPrint('🔐 AuthenticationNotifier: User data updated successfully');
    } catch (e) {
      debugPrint('🔐 AuthenticationNotifier: Error updating user data: $e');
      state = state.copyWithError('Failed to update user data: $e');
    }
  }

  /// Clear error state
  void clearError() {
    if (state.error != null) {
      state = AuthenticationState(
        isAuthenticated: state.isAuthenticated,
        accessToken: state.accessToken,
        refreshToken: state.refreshToken,
        userData: state.userData,
        userType: state.userType,
        tokenExpiresAt: state.tokenExpiresAt,
        isLoading: state.isLoading,
        error: null,
      );
    }
  }

  /// Check if user has specific role
  bool hasRole(UserType role) {
    return state.userType == role;
  }

  /// Check if user is provider
  bool get isProvider => hasRole(UserType.provider);

  /// Check if user is customer
  bool get isCustomer => hasRole(UserType.customer);

  /// Check if user is admin
  bool get isAdmin => hasRole(UserType.admin);

  /// 🐛 DEBUG: Get authentication debug info
  Map<String, dynamic> getAuthDebugInfo() {
    final authToken = HiveService.getAuthToken();
    final refreshToken = HiveService.getRefreshToken();
    final userData = HiveService.getUserData();
    final isLoggedIn = HiveService.isLoggedIn();
    final userType = HiveService.getUserType();

    return {
      'state_authenticated': state.isAuthenticated,
      'hive_logged_in': isLoggedIn,
      'hive_auth_token': authToken,
      'hive_auth_token_length': authToken.length,
      'hive_refresh_token': refreshToken,
      'hive_user_data': userData,
      'hive_user_type': userType,
      'state_user_type': state.userType,
      'auth_tokens_match': state.accessToken == authToken,
      'debug_timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// 🐛 DEBUG: Print authentication status
  void debugAuthStatus() {
    final debugInfo = getAuthDebugInfo();
    debugPrint('🔐 AUTHENTICATION DEBUG STATUS:');
    debugInfo.forEach((key, value) {
      debugPrint('🔐 → $key: $value');
    });
  }
}
