import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';
import 'hive_service.dart';

/// User model for authentication (matching API structure)
class AppUser {
  final String id;
  final String username;
  final String email;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final String userType; // 'customer', 'provider', 'admin'
  final String? profilePicture;
  final String? bio;
  final String? location;
  final bool isVerified;
  final double rating;
  final String balance;
  final int totalBookings;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppUser({
    required this.id,
    required this.username,
    required this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    required this.userType,
    this.profilePicture,
    this.bio,
    this.location,
    this.isVerified = false,
    this.rating = 0.0,
    this.balance = '0.00',
    this.totalBookings = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  AppUser copyWith({
    String? id,
    String? username,
    String? email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? userType,
    String? profilePicture,
    String? bio,
    String? location,
    bool? isVerified,
    double? rating,
    String? balance,
    int? totalBookings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userType: userType ?? this.userType,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      balance: balance ?? this.balance,
      totalBookings: totalBookings ?? this.totalBookings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
      'first_name': firstName,
      'last_name': lastName,
      'user_type': userType,
      'profile_picture': profilePicture,
      'bio': bio,
      'location': location,
      'is_verified': isVerified,
      'rating': rating,
      'balance': balance,
      'total_bookings': totalBookings,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      userType: json['user_type'] as String? ?? 'customer',
      profilePicture: json['profile_picture'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      balance: json['balance'] as String? ?? '0.00',
      totalBookings: json['total_bookings'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Get display name
  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    }
    return username;
  }
}

/// Authentication tokens model
class AuthTokens {
  final String accessToken;
  final String refreshToken;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['access'] as String,
      refreshToken: json['refresh'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access': accessToken,
      'refresh': refreshToken,
    };
  }
}

/// Registration response model
class RegistrationResponse {
  final AppUser user;
  final AuthTokens tokens;
  final String message;

  const RegistrationResponse({
    required this.user,
    required this.tokens,
    required this.message,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
      tokens: AuthTokens.fromJson(json['tokens'] as Map<String, dynamic>),
      message: json['message'] as String,
    );
  }
}

/// PIN Status model
class PinStatus {
  final bool hasPinSet;
  final bool isLocked;
  final int attemptsLeft;
  final DateTime? lockoutExpiresAt;

  const PinStatus({
    required this.hasPinSet,
    required this.isLocked,
    required this.attemptsLeft,
    this.lockoutExpiresAt,
  });

  factory PinStatus.fromJson(Map<String, dynamic> json) {
    return PinStatus(
      hasPinSet: json['has_pin_set'] as bool,
      isLocked: json['is_locked'] as bool,
      attemptsLeft: json['attempts_left'] as int,
      lockoutExpiresAt: json['lockout_expires_at'] != null
          ? DateTime.parse(json['lockout_expires_at'] as String)
          : null,
    );
  }
}

/// User Type Detection Response model
class UserTypeResponse {
  final String userId;
  final String username;
  final String userType;
  final String userTypeDisplay;
  final bool isCustomer;
  final bool isProvider;
  final bool isAdmin;

  const UserTypeResponse({
    required this.userId,
    required this.username,
    required this.userType,
    required this.userTypeDisplay,
    required this.isCustomer,
    required this.isProvider,
    required this.isAdmin,
  });

  factory UserTypeResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return UserTypeResponse(
      userId: data['user_id'] as String,
      username: data['username'] as String,
      userType: data['user_type'] as String,
      userTypeDisplay: data['user_type_display'] as String,
      isCustomer: data['is_customer'] as bool,
      isProvider: data['is_provider'] as bool,
      isAdmin: data['is_admin'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'user_type': userType,
      'user_type_display': userTypeDisplay,
      'is_customer': isCustomer,
      'is_provider': isProvider,
      'is_admin': isAdmin,
    };
  }
}

/// User search filters
class UserSearchRequest {
  final String? query;
  final String? userType;
  final String? location;
  final double? minRating;
  final bool? isVerified;
  final String? availability;
  final List<String>? skills;
  final int? page;
  final int? pageSize;

  const UserSearchRequest({
    this.query,
    this.userType,
    this.location,
    this.minRating,
    this.isVerified,
    this.availability,
    this.skills,
    this.page,
    this.pageSize,
  });

  Map<String, dynamic> toJson() {
    return {
      if (query != null) 'query': query,
      if (userType != null) 'user_type': userType,
      if (location != null) 'location': location,
      if (minRating != null) 'min_rating': minRating,
      if (isVerified != null) 'is_verified': isVerified,
      if (availability != null) 'availability': availability,
      if (skills != null) 'skills': skills,
      if (page != null) 'page': page,
      if (pageSize != null) 'page_size': pageSize,
    };
  }
}

/// Authentication service for managing user authentication state
class AuthService extends StateNotifier<AppUser?> {
  final ApiService _apiService;

  AuthService(this._apiService) : super(null);

  /// Current authenticated user
  AppUser? get currentUser => state;

  /// Check if user is authenticated
  bool get isAuthenticated => state != null;

  /// Check if user is verified
  bool get isVerified => state?.isVerified ?? false;

  /// Initialize authentication service
  Future<void> initialize() async {
    // Check if user is already logged in
    if (HiveService.isLoggedIn()) {
      final userData = HiveService.getUserData();
      final accessToken = HiveService.getAuthToken();
      final refreshToken = HiveService.getRefreshToken();

      if (userData != null && accessToken != null) {
        try {
          state = AppUser.fromJson(userData);
          _apiService.setTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
          );
        } catch (e) {
          // Clear invalid stored data
          await logout();
        }
      }
    }
  }

  // Registration Methods

  /// Generic user registration (defaults to customer)
  Future<ApiResponse<RegistrationResponse>> register({
    required String username,
    required String email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
  }) async {
    final response = await _apiService.post<RegistrationResponse>(
      '/auth/register/',
      body: {
        'username': username,
        'email': email,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
      },
      fromJson: (data) => RegistrationResponse.fromJson(data),
    );

    if (response.success && response.data != null) {
      await _handleSuccessfulLogin(response.data!);
    }

    return response;
  }

  /// Customer registration
  Future<ApiResponse<RegistrationResponse>> registerCustomer({
    required String username,
    required String email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
  }) async {
    final response = await _apiService.post<RegistrationResponse>(
      '/auth/register/customer/',
      body: {
        'username': username,
        'email': email,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
      },
      fromJson: (data) => RegistrationResponse.fromJson(data),
    );

    if (response.success && response.data != null) {
      await _handleSuccessfulLogin(response.data!);
    }

    return response;
  }

  /// Provider registration
  Future<ApiResponse<RegistrationResponse>> registerProvider({
    required String username,
    required String email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? bio,
    List<String>? skills,
  }) async {
    final response = await _apiService.post<RegistrationResponse>(
      '/auth/register/provider/',
      body: {
        'username': username,
        'email': email,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (bio != null) 'bio': bio,
        if (skills != null) 'skills': skills,
      },
      fromJson: (data) => RegistrationResponse.fromJson(data),
    );

    if (response.success && response.data != null) {
      await _handleSuccessfulLogin(response.data!);
    }

    return response;
  }

  /// Admin registration
  Future<ApiResponse<RegistrationResponse>> registerAdmin({
    required String username,
    required String email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
  }) async {
    final response = await _apiService.post<RegistrationResponse>(
      '/auth/register/admin/',
      body: {
        'username': username,
        'email': email,
        if (phoneNumber != null) 'phone_number': phoneNumber,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
      },
      fromJson: (data) => RegistrationResponse.fromJson(data),
    );

    if (response.success && response.data != null) {
      await _handleSuccessfulLogin(response.data!);
    }

    return response;
  }

  // Login Methods

  /// Search user by phone number
  Future<ApiResponse<List<AppUser>>> searchUserByPhone(
      String phoneNumber) async {
    return _apiService.get<List<AppUser>>(
      '/auth/search/phone/$phoneNumber/',
      fromJson: (data) => (data['results'] as List)
          .map((user) => AppUser.fromJson(user))
          .toList(),
    );
  }

  /// Generic login
  Future<ApiResponse<RegistrationResponse>> login({
    required String identifier, // username, email, or phone
    required String pin,
  }) async {
    final response = await _apiService.post<RegistrationResponse>(
      '/auth/login/',
      body: {
        'identifier': identifier,
        'pin': pin,
      },
      fromJson: (data) => RegistrationResponse.fromJson(data),
    );

    if (response.success && response.data != null) {
      await _handleSuccessfulLogin(response.data!);
    }

    return response;
  }

  /// Customer login
  Future<ApiResponse<RegistrationResponse>> loginCustomer({
    required String identifier,
    required String pin,
  }) async {
    final response = await _apiService.post<RegistrationResponse>(
      '/auth/login/customer/',
      body: {
        'identifier': identifier,
        'pin': pin,
      },
      fromJson: (data) => RegistrationResponse.fromJson(data),
    );

    if (response.success && response.data != null) {
      await _handleSuccessfulLogin(response.data!);
    }

    return response;
  }

  /// Provider login
  Future<ApiResponse<RegistrationResponse>> loginProvider({
    required String identifier,
    required String pin,
  }) async {
    final response = await _apiService.post<RegistrationResponse>(
      '/auth/login/provider/',
      body: {
        'identifier': identifier,
        'pin': pin,
      },
      fromJson: (data) => RegistrationResponse.fromJson(data),
    );

    if (response.success && response.data != null) {
      await _handleSuccessfulLogin(response.data!);
    }

    return response;
  }

  /// Admin login
  Future<ApiResponse<RegistrationResponse>> loginAdmin({
    required String identifier,
    required String pin,
  }) async {
    final response = await _apiService.post<RegistrationResponse>(
      '/auth/login/admin/',
      body: {
        'identifier': identifier,
        'pin': pin,
      },
      fromJson: (data) => RegistrationResponse.fromJson(data),
    );

    if (response.success && response.data != null) {
      await _handleSuccessfulLogin(response.data!);
    }

    return response;
  }

  // PIN Authentication Methods

  /// PIN login
  Future<ApiResponse<RegistrationResponse>> pinLogin({
    required String identifier,
    required String pin,
  }) async {
    final response = await _apiService.post<RegistrationResponse>(
      '/auth/pin/login/',
      body: {
        'identifier': identifier,
        'pin': pin,
      },
      fromJson: (data) => RegistrationResponse.fromJson(data),
    );

    if (response.success && response.data != null) {
      await _handleSuccessfulLogin(response.data!);
    }

    return response;
  }

  /// Register PIN (generic)
  Future<ApiResponse<Map<String, dynamic>>> registerPin({
    required String pin,
    required String confirmPin,
  }) async {
    return _apiService.post<Map<String, dynamic>>(
      '/auth/pin/register/',
      body: {
        'pin': pin,
        'confirm_pin': confirmPin,
      },
      fromJson: (data) => data,
    );
  }

  /// Register PIN for customer
  Future<ApiResponse<Map<String, dynamic>>> registerCustomerPin({
    required String pin,
    required String confirmPin,
  }) async {
    return _apiService.post<Map<String, dynamic>>(
      '/auth/pin/register/customer/',
      body: {
        'pin': pin,
        'confirm_pin': confirmPin,
      },
      fromJson: (data) => data,
    );
  }

  /// Register PIN for provider
  Future<ApiResponse<Map<String, dynamic>>> registerProviderPin({
    required String pin,
    required String confirmPin,
  }) async {
    return _apiService.post<Map<String, dynamic>>(
      '/auth/pin/register/provider/',
      body: {
        'pin': pin,
        'confirm_pin': confirmPin,
      },
      fromJson: (data) => data,
    );
  }

  /// Change PIN
  Future<ApiResponse<Map<String, dynamic>>> changePin({
    required String currentPin,
    required String newPin,
    required String confirmNewPin,
  }) async {
    return _apiService.post<Map<String, dynamic>>(
      '/auth/pin/change/',
      body: {
        'current_pin': currentPin,
        'new_pin': newPin,
        'confirm_new_pin': confirmNewPin,
      },
      fromJson: (data) => data,
    );
  }

  /// Reset PIN using phone number
  Future<ApiResponse<Map<String, dynamic>>> resetPin({
    required String phoneNumber,
    required String newPin,
    required String confirmNewPin,
  }) async {
    return _apiService.post<Map<String, dynamic>>(
      '/auth/pin/reset/',
      body: {
        'phone_number': phoneNumber,
        'new_pin': newPin,
        'confirm_new_pin': confirmNewPin,
      },
      fromJson: (data) => data,
    );
  }

  /// Get PIN status
  Future<ApiResponse<PinStatus>> getPinStatus() async {
    return _apiService.get<PinStatus>(
      '/auth/pin/status/',
      fromJson: (data) => PinStatus.fromJson(data),
    );
  }

  // Convenience methods for PIN verification screen

  /// Set PIN (alias for registerPin)
  Future<ApiResponse<Map<String, dynamic>>> setPin({
    required String pin,
    required String confirmPin,
  }) async {
    return registerPin(pin: pin, confirmPin: confirmPin);
  }

  /// Login with phone and PIN
  Future<ApiResponse<RegistrationResponse>> loginWithPhonePin({
    required String phoneNumber,
    required String pin,
  }) async {
    return pinLogin(identifier: phoneNumber, pin: pin);
  }

  // Token Management

  /// Refresh access token
  Future<ApiResponse<AuthTokens>> refreshToken() async {
    final response = await _apiService.post<AuthTokens>(
      '/auth/token/refresh/',
      fromJson: (data) => AuthTokens.fromJson(data),
    );

    if (response.success && response.data != null) {
      final tokens = response.data!;
      _apiService.setTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      HiveService.setAuthToken(tokens.accessToken);
      HiveService.setRefreshToken(tokens.refreshToken);
    }

    return response;
  }

  /// List user access tokens
  Future<ApiResponse<List<Map<String, dynamic>>>> getUserTokens({
    bool? activeOnly,
  }) async {
    return _apiService.get<List<Map<String, dynamic>>>(
      '/users/me/tokens/',
      queryParameters:
          activeOnly != null ? {'active_only': '$activeOnly'} : null,
      fromJson: (data) => List<Map<String, dynamic>>.from(data['results']),
    );
  }

  /// Revoke specific access token
  Future<ApiResponse<Map<String, dynamic>>> revokeToken(String tokenId) async {
    return _apiService.delete<Map<String, dynamic>>(
      '/users/me/tokens/$tokenId/',
      fromJson: (data) => data,
    );
  }

  /// Revoke all access tokens
  Future<ApiResponse<Map<String, dynamic>>> revokeAllTokens() async {
    return _apiService.post<Map<String, dynamic>>(
      '/users/me/tokens/revoke_all/',
      fromJson: (data) => data,
    );
  }

  // User Profile Management

  /// Get current user profile
  Future<ApiResponse<AppUser>> getCurrentUserProfile() async {
    return _apiService.get<AppUser>(
      '/users/me/',
      fromJson: (data) => AppUser.fromJson(data),
    );
  }

  /// Get user type detection information
  /// Returns the user type (customer, provider, or admin) based on the authentication token
  Future<ApiResponse<UserTypeResponse>> getUserType() async {
    return _apiService.get<UserTypeResponse>(
      '/auth/user-type/',
      fromJson: (data) => UserTypeResponse.fromJson(data),
    );
  }

  /// Update current user profile
  Future<ApiResponse<AppUser>> updateProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? location,
    String? profilePicture,
  }) async {
    final response = await _apiService.patch<AppUser>(
      '/users/me/',
      body: {
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (bio != null) 'bio': bio,
        if (location != null) 'location': location,
        if (profilePicture != null) 'profile_picture': profilePicture,
      },
      fromJson: (data) => AppUser.fromJson(data),
    );

    if (response.success && response.data != null) {
      state = response.data;
      HiveService.saveUserData(response.data!.toJson());
    }

    return response;
  }

  /// Deactivate account
  Future<ApiResponse<Map<String, dynamic>>> deactivateAccount() async {
    return _apiService.post<Map<String, dynamic>>(
      '/users/me/deactivate/',
      fromJson: (data) => data,
    );
  }

  /// Get public user profile
  Future<ApiResponse<AppUser>> getUserProfile(String userId) async {
    return _apiService.get<AppUser>(
      '/users/$userId/',
      fromJson: (data) => AppUser.fromJson(data),
    );
  }

  // User Search

  /// Search users with filters
  Future<ApiResponse<List<AppUser>>> searchUsers(
      UserSearchRequest request) async {
    return _apiService.post<List<AppUser>>(
      '/users/search/',
      body: request.toJson(),
      fromJson: (data) => (data['results'] as List)
          .map((user) => AppUser.fromJson(user))
          .toList(),
    );
  }

  /// Logout user
  Future<ApiResponse<Map<String, dynamic>>> logout() async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/auth/logout/',
      fromJson: (data) => data,
    );

    // Clear local data regardless of API response
    await _clearLocalUserData();

    return response;
  }

  /// Sign out (alias for logout)
  Future<void> signOut() async {
    await logout();
  }

  /// Get current user (direct access to state)
  AppUser? getCurrentUser() {
    return state;
  }

  /// Handle successful login by storing user data and tokens
  Future<void> _handleSuccessfulLogin(
      RegistrationResponse loginResponse) async {
    state = loginResponse.user;
    _apiService.setTokens(
      accessToken: loginResponse.tokens.accessToken,
      refreshToken: loginResponse.tokens.refreshToken,
    );

    // Save to local storage
    HiveService.saveUserData(loginResponse.user.toJson());
    HiveService.setAuthToken(loginResponse.tokens.accessToken);
    HiveService.setRefreshToken(loginResponse.tokens.refreshToken);
    HiveService.setLoggedIn(true);
  }

  /// Clear all local user data
  Future<void> _clearLocalUserData() async {
    state = null;
    _apiService.setTokens();
    HiveService.setLoggedIn(false);
    HiveService.clearUserData();
    HiveService.removeAuthToken();
    HiveService.removeRefreshToken();
  }
}

/// Provider for AuthService
final authServiceProvider = StateNotifierProvider<AuthService, AppUser?>((ref) {
  return AuthService(ApiService());
});

/// Convenience providers for common auth states
final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(authServiceProvider);
  return user != null;
});

final isVerifiedProvider = Provider<bool>((ref) {
  final user = ref.watch(authServiceProvider);
  return user?.isVerified ?? false;
});

final currentUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(authServiceProvider);
});
