import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prbal/models/auth/app_user.dart';
import 'package:prbal/models/auth/user_type.dart';
import 'package:prbal/services/api_service.dart';
import 'package:prbal/services/user_service.dart';
import 'package:prbal/services/hive_service.dart';

/// ================================
/// CORE SERVICE PROVIDERS
/// ================================

/// API Service Provider
/// Provides the base HTTP client for all API operations
final apiServiceProvider = Provider<ApiService>((ref) {
  debugPrint('🏗️ AppServices: Initializing ApiService');
  return ApiService();
});

/// User Service Provider
/// Provides user management and authentication operations
final userServiceProvider = Provider<UserService>((ref) {
  debugPrint('🏗️ AppServices: Initializing UserService');
  final apiService = ref.read(apiServiceProvider);
  return UserService(apiService);
});

/// ================================
/// AUTHENTICATION STATE MANAGEMENT
/// ================================

/// Authentication State Model
class AuthenticationState {
  final bool isAuthenticated;
  final bool isLoading;
  final AppUser? user;
  final AuthTokens? tokens;
  final String? error;

  const AuthenticationState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.tokens,
    this.error,
  });

  AuthenticationState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    AppUser? user,
    AuthTokens? tokens,
    String? error,
  }) {
    return AuthenticationState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      tokens: tokens ?? this.tokens,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'AuthState(auth: $isAuthenticated, loading: $isLoading, user: ${user?.username}, hasTokens: ${tokens != null})';
  }
}

/// Authentication State Notifier
/// Manages centralized authentication state across the entire app
class AuthenticationNotifier extends StateNotifier<AuthenticationState> {
  final UserService _userService;

  AuthenticationNotifier(this._userService)
      : super(const AuthenticationState()) {
    debugPrint('🔐 AuthNotifier: Initializing authentication state notifier');
    _initializeFromHive();
  }

  /// Initialize authentication state from Hive storage
  Future<void> _initializeFromHive() async {
    debugPrint('🔐 AuthNotifier: ====== INITIALIZING FROM HIVE ======');

    try {
      // Check if user is logged in according to HiveService
      final isLoggedIn = HiveService.isLoggedIn();
      debugPrint('🔐 AuthNotifier: HiveService login status: $isLoggedIn');

      if (!isLoggedIn) {
        debugPrint(
            '🔐 AuthNotifier: User not logged in, keeping default state');
        return;
      }

      // Get user data from Hive
      final userData = HiveService.getUserDataSafe();
      if (userData == null) {
        debugPrint('🔐 AuthNotifier: No user data found, clearing login state');
        await HiveService.setLoggedIn(false);
        return;
      }

      // Try to get tokens from Hive
      AuthTokens? tokens;
      try {
        final accessToken = HiveService.getAuthToken();
        final refreshToken = HiveService.getRefreshToken();
        if (accessToken.isNotEmpty) {
          tokens = AuthTokens(
            accessToken: accessToken,
            refreshToken: refreshToken ?? '',
          );
          debugPrint('🔐 AuthNotifier: Tokens retrieved from Hive');
        }
      } catch (e) {
        debugPrint('🔐 AuthNotifier: No valid tokens in Hive: $e');
      }

      // Validate tokens if they exist
      if (tokens != null && tokens.accessToken.isNotEmpty) {
        debugPrint('🔐 AuthNotifier: Validating stored tokens...');
        final isValid = await _userService.isAuthenticated(tokens.accessToken);

        if (isValid) {
          debugPrint(
              '🔐 AuthNotifier: Tokens are valid, setting authenticated state');
          state = AuthenticationState(
            isAuthenticated: true,
            user: userData,
            tokens: tokens,
          );
        } else {
          debugPrint('🔐 AuthNotifier: Tokens invalid, attempting refresh...');
          await _attemptTokenRefresh(tokens.refreshToken, userData);
        }
      } else {
        debugPrint(
            '🔐 AuthNotifier: No tokens available, setting user-only state');
        state = AuthenticationState(
          isAuthenticated: true,
          user: userData,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('🔐 AuthNotifier: Error initializing from Hive: $e');
      debugPrint('🔐 AuthNotifier: Stack trace: $stackTrace');
      state = state.copyWith(error: 'Initialization error: $e');
    }
  }

  /// Attempt to refresh tokens
  Future<void> _attemptTokenRefresh(
      String refreshToken, AppUser userData) async {
    debugPrint('🔄 AuthNotifier: Attempting token refresh...');

    try {
      final response = await _userService.refreshToken(refreshToken);

      if (response.isSuccess && response.data != null) {
        final newTokens = AuthTokens.fromJson(response.data!);
        await _saveTokensToHive(newTokens);

        state = AuthenticationState(
          isAuthenticated: true,
          user: userData,
          tokens: newTokens,
        );
        debugPrint('🔄 AuthNotifier: Token refresh successful');
      } else {
        debugPrint(
            '🔄 AuthNotifier: Token refresh failed, clearing auth state');
        await _clearAuthenticationState();
      }
    } catch (e) {
      debugPrint('🔄 AuthNotifier: Token refresh error: $e');
      await _clearAuthenticationState();
    }
  }

  /// Set authenticated state after successful login/registration
  Future<void> setAuthenticated({
    required AppUser user,
    AuthTokens? tokens,
  }) async {
    debugPrint('🔐 AuthNotifier: ====== SETTING AUTHENTICATED STATE ======');
    debugPrint('🔐 AuthNotifier: User: ${user.username} (${user.userType})');
    debugPrint('🔐 AuthNotifier: Has tokens: ${tokens != null}');

    try {
      // Save to Hive
      await HiveService.setLoggedIn(true);
      await HiveService.saveUserData(user);
      await HiveService.saveUserProfile(user);

      if (tokens != null) {
        await _saveTokensToHive(tokens);
      }

      // Update state
      state = AuthenticationState(
        isAuthenticated: true,
        user: user,
        tokens: tokens,
      );

      debugPrint('🔐 AuthNotifier: Authentication state set successfully');
    } catch (e) {
      debugPrint('🔐 AuthNotifier: Error setting authentication state: $e');
      state = state.copyWith(error: 'Failed to save authentication state: $e');
    }
  }

  /// Update user data while maintaining authentication state
  Future<void> updateUser(AppUser updatedUser) async {
    debugPrint(
        '🔐 AuthNotifier: Updating user data for: ${updatedUser.username}');

    try {
      await HiveService.saveUserData(updatedUser);
      await HiveService.saveUserProfile(updatedUser);

      state = state.copyWith(user: updatedUser);
      debugPrint('🔐 AuthNotifier: User data updated successfully');
    } catch (e) {
      debugPrint('🔐 AuthNotifier: Error updating user data: $e');
      state = state.copyWith(error: 'Failed to update user data: $e');
    }
  }

  /// Update tokens while maintaining user state
  Future<void> updateTokens(AuthTokens newTokens) async {
    debugPrint('🔐 AuthNotifier: Updating authentication tokens');

    try {
      await _saveTokensToHive(newTokens);
      state = state.copyWith(tokens: newTokens);
      debugPrint('🔐 AuthNotifier: Tokens updated successfully');
    } catch (e) {
      debugPrint('🔐 AuthNotifier: Error updating tokens: $e');
      state = state.copyWith(error: 'Failed to update tokens: $e');
    }
  }

  /// Clear authentication state and logout
  Future<void> logout() async {
    debugPrint('🔐 AuthNotifier: ====== PERFORMING LOGOUT ======');

    try {
      // Revoke tokens if available
      if (state.tokens?.accessToken.isNotEmpty == true) {
        debugPrint('🔐 AuthNotifier: Revoking tokens on server...');
        try {
          await _userService.revokeAllTokens(state.tokens!.accessToken);
          debugPrint('🔐 AuthNotifier: Tokens revoked successfully');
        } catch (e) {
          debugPrint('🔐 AuthNotifier: Token revocation failed: $e');
        }
      }

      // Clear local storage
      await _clearAuthenticationState();
      debugPrint('🔐 AuthNotifier: Logout completed successfully');
    } catch (e) {
      debugPrint('🔐 AuthNotifier: Error during logout: $e');
      // Even if there's an error, clear local state
      await _clearAuthenticationState();
    }
  }

  /// Clear authentication state locally
  Future<void> _clearAuthenticationState() async {
    debugPrint('🔐 AuthNotifier: Clearing local authentication state');

    try {
      await HiveService.logout(); // This handles all Hive cleanup
      state = const AuthenticationState();
      debugPrint('🔐 AuthNotifier: Local authentication state cleared');
    } catch (e) {
      debugPrint('🔐 AuthNotifier: Error clearing local state: $e');
      state = const AuthenticationState();
    }
  }

  /// Save tokens to Hive storage
  Future<void> _saveTokensToHive(AuthTokens tokens) async {
    debugPrint('🔐 AuthNotifier: Saving tokens to Hive');

    if (tokens.accessToken.isNotEmpty) {
      await HiveService.setAuthToken(tokens.accessToken);
    }

    if (tokens.refreshToken.isNotEmpty) {
      await HiveService.setRefreshToken(tokens.refreshToken);
    }

    debugPrint('🔐 AuthNotifier: Tokens saved to Hive successfully');
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Get current access token
  String? get currentAccessToken => state.tokens?.accessToken;

  /// Get current user
  AppUser? get currentUser => state.user;

  /// Check if user is authenticated
  bool get isAuthenticated => state.isAuthenticated;

  /// Get user type safely
  UserType get userType => state.user?.userType ?? UserType.customer;
}

/// Authentication State Provider
/// Provides centralized authentication state management
final authenticationStateProvider =
    StateNotifierProvider<AuthenticationNotifier, AuthenticationState>((ref) {
  debugPrint('🏗️ AppServices: Initializing AuthenticationNotifier');
  final userService = ref.read(userServiceProvider);
  return AuthenticationNotifier(userService);
});

/// ================================
/// CONVENIENCE PROVIDERS
/// ================================

/// Current User Provider
/// Provides easy access to current user data
final currentUserProvider = Provider<AppUser?>((ref) {
  final authState = ref.watch(authenticationStateProvider);
  return authState.user;
});

/// Is Authenticated Provider
/// Provides easy access to authentication status
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authenticationStateProvider);
  return authState.isAuthenticated;
});

/// User Type Provider
/// Provides easy access to current user type
final userTypeProvider = Provider<UserType>((ref) {
  final authState = ref.watch(authenticationStateProvider);
  return authState.user?.userType ?? UserType.customer;
});

/// Current Access Token Provider
/// Provides easy access to current access token
final currentAccessTokenProvider = Provider<String?>((ref) {
  final authState = ref.watch(authenticationStateProvider);
  return authState.tokens?.accessToken;
});

/// ================================
/// APP INITIALIZATION
/// ================================

/// Note: App initialization is now handled in main.dart _initializeAppServices()
/// This includes HiveService.init() and other core service setup
/// Authentication state initialization happens automatically via provider constructors

/// ================================
/// SERVICE UTILITIES
/// ================================

/// Service Utilities Class
/// Provides utility methods for service operations
class ServiceUtils {
  const ServiceUtils._();

  /// Refresh user data from API
  static Future<bool> refreshUserData(WidgetRef ref) async {
    debugPrint('🔄 ServiceUtils: Refreshing user data from API...');

    try {
      final authNotifier = ref.read(authenticationStateProvider.notifier);
      final userService = ref.read(userServiceProvider);
      final currentToken = authNotifier.currentAccessToken;

      if (currentToken == null) {
        debugPrint('🔄 ServiceUtils: No access token available');
        return false;
      }

      final response = await userService.getCurrentUserProfile(currentToken);

      if (response.isSuccess && response.data != null) {
        await authNotifier.updateUser(response.data!);
        debugPrint('🔄 ServiceUtils: User data refreshed successfully');
        return true;
      } else {
        debugPrint(
            '🔄 ServiceUtils: Failed to refresh user data: ${response.message}');
        return false;
      }
    } catch (e) {
      debugPrint('🔄 ServiceUtils: Error refreshing user data: $e');
      return false;
    }
  }

  /// Update profile picture
  static Future<bool> updateProfilePicture(
      WidgetRef ref, String newProfilePictureUrl) async {
    debugPrint('🔄 ServiceUtils: Updating profile picture...');

    try {
      final authNotifier = ref.read(authenticationStateProvider.notifier);
      final currentUser = authNotifier.currentUser;

      if (currentUser == null) {
        debugPrint('🔄 ServiceUtils: No current user available');
        return false;
      }

      final updatedUser = currentUser.copyWith(
        profilePicture: newProfilePictureUrl,
        updatedAt: DateTime.now(),
      );

      await authNotifier.updateUser(updatedUser);
      debugPrint('🔄 ServiceUtils: Profile picture updated successfully');
      return true;
    } catch (e) {
      debugPrint('🔄 ServiceUtils: Error updating profile picture: $e');
      return false;
    }
  }

  /// Validate and refresh tokens if needed
  static Future<bool> validateTokens(WidgetRef ref) async {
    debugPrint('🔄 ServiceUtils: Validating authentication tokens...');

    try {
      final authNotifier = ref.read(authenticationStateProvider.notifier);
      final userService = ref.read(userServiceProvider);
      final currentToken = authNotifier.currentAccessToken;

      if (currentToken == null) {
        debugPrint('🔄 ServiceUtils: No access token to validate');
        return false;
      }

      final isValid = await userService.isAuthenticated(currentToken);

      if (isValid) {
        debugPrint('🔄 ServiceUtils: Tokens are valid');
        return true;
      } else {
        debugPrint('🔄 ServiceUtils: Tokens invalid, attempting refresh...');
        // Token refresh logic would go here
        return false;
      }
    } catch (e) {
      debugPrint('🔄 ServiceUtils: Error validating tokens: $e');
      return false;
    }
  }
}

/// ================================
/// DEBUG UTILITIES
/// ================================

/// Debug information provider for development
final debugInfoProvider = Provider<Map<String, dynamic>>((ref) {
  final authState = ref.watch(authenticationStateProvider);
  final hiveDebugInfo = HiveService.getDebugInfo();

  return {
    'authState': {
      'isAuthenticated': authState.isAuthenticated,
      'isLoading': authState.isLoading,
      'hasUser': authState.user != null,
      'hasTokens': authState.tokens != null,
      'userType': authState.user?.userType.name,
      'username': authState.user?.username,
      'error': authState.error,
    },
    'hive': hiveDebugInfo,
    'timestamp': DateTime.now().toIso8601String(),
  };
});
