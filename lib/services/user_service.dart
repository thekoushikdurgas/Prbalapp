// import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'api_service.dart';

// ================================
// ENUMS AND CONSTANTS
// ================================

/// User types supported by the system
enum UserType {
  customer,
  provider,
  admin;

  String get displayName {
    switch (this) {
      case UserType.customer:
        return 'Customer';
      case UserType.provider:
        return 'Service Provider';
      case UserType.admin:
        return 'Administrator';
    }
  }

  static UserType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'customer':
        return UserType.customer;
      case 'provider':
        return UserType.provider;
      case 'admin':
        return UserType.admin;
      default:
        return UserType.customer;
    }
  }
}

/// Verification types
enum VerificationType {
  identity,
  address,
  professional,
  educational;

  static VerificationType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'identity':
        return VerificationType.identity;
      case 'address':
        return VerificationType.address;
      case 'professional':
        return VerificationType.professional;
      case 'educational':
        return VerificationType.educational;
      default:
        return VerificationType.identity;
    }
  }
}

/// Verification status
enum VerificationStatus {
  pending,
  inProgress,
  verified,
  rejected,
  cancelled,
  expired;

  static VerificationStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return VerificationStatus.pending;
      case 'in_progress':
        return VerificationStatus.inProgress;
      case 'verified':
        return VerificationStatus.verified;
      case 'rejected':
        return VerificationStatus.rejected;
      case 'cancelled':
        return VerificationStatus.cancelled;
      case 'expired':
        return VerificationStatus.expired;
      default:
        return VerificationStatus.pending;
    }
  }
}

// ================================
// DATA MODELS
// ================================

/// User model based on the API response structure
class AppUser {
  final String id;
  final String username;
  final String email;
  final String? phoneNumber;
  final String firstName;
  final String lastName;
  final UserType userType;
  final String? profilePicture;
  final String? bio;
  final String? location;
  final bool isVerified;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final double rating;
  final double balance;
  final int totalBookings;
  final Map<String, String>? skills;
  final Map<String, dynamic>? availability;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool notificationsEnabled;
  final bool biometricsEnabled;
  final bool analyticsEnabled;

  const AppUser({
    required this.id,
    required this.username,
    required this.email,
    this.phoneNumber,
    required this.firstName,
    required this.lastName,
    this.userType = UserType.customer,
    this.profilePicture,
    this.bio,
    this.location,
    this.isVerified = false,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.rating = 0.0,
    this.balance = 0.0,
    this.totalBookings = 0,
    this.skills,
    this.availability,
    required this.createdAt,
    required this.updatedAt,
    this.notificationsEnabled = false,
    this.biometricsEnabled = false,
    this.analyticsEnabled = false,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    debugPrint('🔄 AppUser.fromJson: Parsing user data');
    debugPrint('📊 Raw rating: ${json['rating']} (${json['rating'].runtimeType})');
    debugPrint('💰 Raw balance: ${json['balance']} (${json['balance'].runtimeType})');

    // Helper function to safely parse string or number to double
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return 0.0;
    }

    final rating = parseDouble(json['rating']);
    final balance = parseDouble(json['balance']);

    debugPrint('📊 Parsed rating: $rating');
    debugPrint('💰 Parsed balance: $balance');

    return AppUser(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '${json['username'] ?? 'user'}@placeholder.com',
      phoneNumber: json['phone_number'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      userType: UserType.fromString(json['user_type'] ?? 'customer'),
      profilePicture: json['profile_picture'],
      bio: json['bio'],
      location: json['location'],
      isVerified: json['is_verified'] ?? false,
      isEmailVerified: json['is_email_verified'] ?? false,
      isPhoneVerified: json['is_phone_verified'] ?? false,
      rating: rating,
      balance: balance,
      totalBookings: json['total_bookings'] ?? 0,
      skills: json['skills'] != null ? Map<String, String>.from(json['skills']) : null,
      availability: json['availability'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? json['created_at'] ?? '') ?? DateTime.now(),
      notificationsEnabled: json['notifications_enabled'] ?? false,
      biometricsEnabled: json['biometrics_enabled'] ?? false,
      analyticsEnabled: json['analytics_enabled'] ?? false,
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
      'user_type': userType.name,
      'profile_picture': profilePicture,
      'bio': bio,
      'location': location,
      'is_verified': isVerified,
      'is_email_verified': isEmailVerified,
      'is_phone_verified': isPhoneVerified,
      'rating': rating,
      'balance': balance,
      'total_bookings': totalBookings,
      'skills': skills,
      'availability': availability,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'notifications_enabled': notificationsEnabled,
      'biometrics_enabled': biometricsEnabled,
      'analytics_enabled': analyticsEnabled,
    };
  }

  String get displayName {
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '$firstName $lastName';
    }
    return username;
  }

  AppUser copyWith({
    String? id,
    String? username,
    String? email,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    UserType? userType,
    String? profilePicture,
    String? bio,
    String? location,
    bool? isVerified,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    double? rating,
    double? balance,
    int? totalBookings,
    Map<String, String>? skills,
    Map<String, dynamic>? availability,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? notificationsEnabled,
    bool? biometricsEnabled,
    bool? analyticsEnabled,
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
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      rating: rating ?? this.rating,
      balance: balance ?? this.balance,
      totalBookings: totalBookings ?? this.totalBookings,
      skills: skills ?? this.skills,
      availability: availability ?? this.availability,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
    );
  }
}

/// Authentication tokens
class AuthTokens {
  final String accessToken;
  final String refreshToken;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['access'] ?? '',
      refreshToken: json['refresh'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access': accessToken,
      'refresh': refreshToken,
    };
  }
}

/// PIN registration request
class PinRegistrationRequest {
  final String username;
  final String email;
  final String phoneNumber;
  final String pin;
  final String confirmPin;
  final String firstName;
  final String lastName;
  final String? deviceType;

  const PinRegistrationRequest({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.pin,
    required this.confirmPin,
    required this.firstName,
    required this.lastName,
    this.deviceType = 'mobile',
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
      'pin': pin,
      'confirm_pin': confirmPin,
      'first_name': firstName,
      'last_name': lastName,
      'device_type': deviceType,
    };
  }
}

/// PIN login request
class PinLoginRequest {
  final String phoneNumber;
  final String pin;
  final String? deviceType;

  const PinLoginRequest({
    required this.phoneNumber,
    required this.pin,
    this.deviceType = 'mobile',
  });

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'pin': pin,
      'device_type': deviceType,
    };
  }
}

/// Change PIN request
class ChangePinRequest {
  final String currentPin;
  final String newPin;
  final String confirmNewPin;

  const ChangePinRequest({
    required this.currentPin,
    required this.newPin,
    required this.confirmNewPin,
  });

  Map<String, dynamic> toJson() {
    return {
      'current_pin': currentPin,
      'new_pin': newPin,
      'confirm_new_pin': confirmNewPin,
    };
  }
}

/// Reset PIN request
class ResetPinRequest {
  final String phoneNumber;
  final String newPin;
  final String confirmNewPin;

  const ResetPinRequest({
    required this.phoneNumber,
    required this.newPin,
    required this.confirmNewPin,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'new_pin': newPin,
      'confirm_new_pin': confirmNewPin,
    };
  }
}

/// User profile update request
class UpdateProfileRequest {
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? bio;
  final String? location;

  const UpdateProfileRequest({
    this.username,
    this.firstName,
    this.lastName,
    this.bio,
    this.location,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (username != null) json['username'] = username;
    if (firstName != null) json['first_name'] = firstName;
    if (lastName != null) json['last_name'] = lastName;
    if (bio != null) json['bio'] = bio;
    if (location != null) json['location'] = location;
    return json;
  }
}

/// User search request
class UserSearchRequest {
  final String? searchTerm;
  final List<UserType>? userTypes;
  final String? location;
  final double? minRating;
  final int? page;
  final int? pageSize;

  const UserSearchRequest({
    this.searchTerm,
    this.userTypes,
    this.location,
    this.minRating,
    this.page = 1,
    this.pageSize = 10,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (searchTerm != null) json['search_term'] = searchTerm;
    if (userTypes != null) {
      json['user_types'] = userTypes!.map((type) => type.name).toList();
    }
    if (location != null) json['location'] = location;
    if (minRating != null) json['min_rating'] = minRating;
    if (page != null) json['page'] = page;
    if (pageSize != null) json['page_size'] = pageSize;
    return json;
  }
}

/// Verification model
class Verification {
  final int id;
  final String userId;
  final VerificationType verificationType;
  final String documentType;
  final String? documentNumber;
  final VerificationStatus status;
  final String? documentUrl;
  final String? documentBackUrl;
  final String? adminNotes;
  final String? verifiedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? verifiedAt;

  const Verification({
    required this.id,
    required this.userId,
    required this.verificationType,
    required this.documentType,
    this.documentNumber,
    required this.status,
    this.documentUrl,
    this.documentBackUrl,
    this.adminNotes,
    this.verifiedBy,
    required this.createdAt,
    required this.updatedAt,
    this.verifiedAt,
  });

  factory Verification.fromJson(Map<String, dynamic> json) {
    return Verification(
      id: json['id'] ?? 0,
      userId: json['user'] ?? '',
      verificationType: VerificationType.fromString(json['verification_type'] ?? 'identity'),
      documentType: json['document_type'] ?? '',
      documentNumber: json['document_number'],
      status: VerificationStatus.fromString(json['status'] ?? 'pending'),
      documentUrl: json['document_url'] ?? json['document_link'],
      documentBackUrl: json['document_back_url'],
      adminNotes: json['admin_notes'],
      verifiedBy: json['verified_by'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      verifiedAt: json['verified_at'] != null ? DateTime.tryParse(json['verified_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userId,
      'verification_type': verificationType.name,
      'document_type': documentType,
      'document_number': documentNumber,
      'status': status.name,
      'document_url': documentUrl,
      'document_back_url': documentBackUrl,
      'admin_notes': adminNotes,
      'verified_by': verifiedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'verified_at': verifiedAt?.toIso8601String(),
    };
  }
}

/// Create verification request
class CreateVerificationRequest {
  final VerificationType verificationType;
  final String documentType;
  final String? documentNumber;
  final String? documentLink;
  final String? documentBackLink;
  final String? documentBase64;
  final String? documentBackBase64;

  const CreateVerificationRequest({
    required this.verificationType,
    required this.documentType,
    this.documentNumber,
    this.documentLink,
    this.documentBackLink,
    this.documentBase64,
    this.documentBackBase64,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'verification_type': verificationType.name,
      'document_type': documentType,
    };

    if (documentNumber != null) json['document_number'] = documentNumber;
    if (documentLink != null) json['document_link'] = documentLink;
    if (documentBackLink != null) json['document_back_link'] = documentBackLink;
    if (documentBase64 != null) json['document_base64'] = documentBase64;
    if (documentBackBase64 != null) {
      json['document_back_base64'] = documentBackBase64;
    }

    return json;
  }
}

// ================================
// USER SERVICE
// ================================

/// Comprehensive UserService implementing all Prbal User Management API endpoints
class UserService {
  final ApiService _apiService;

  UserService(this._apiService);

  // ================================
  // AUTHENTICATION ENDPOINTS
  // ================================

  /// PIN-based login
  /// POST /users/auth/login/
  Future<ApiResponse<Map<String, dynamic>>> pinLogin(PinLoginRequest request) async {
    debugPrint('🔐 UserService: PIN Login Request');
    debugPrint('📱 Phone: ${request.phoneNumber}');

    final response = await _apiService.post<Map<String, dynamic>>(
      '/auth/login/',
      body: request.toJson(),
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.isSuccess) {
      debugPrint('✅ PIN Login Success');
      debugPrint('👤 User Type: ${response.data?['user']?['user_type']}');
    } else {
      debugPrint('❌ PIN Login Failed: ${response.message}');
    }

    return response;
  }

  /// PIN-based registration
  /// POST /users/auth/register/
  Future<ApiResponse<Map<String, dynamic>>> pinRegister(PinRegistrationRequest request) async {
    debugPrint('🔐 UserService: PIN Registration Request');
    debugPrint('📱 Phone: ${request.phoneNumber}');
    debugPrint('👤 Username: ${request.username}');

    final response = await _apiService.post<Map<String, dynamic>>(
      '/auth/register/',
      body: request.toJson(),
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.isSuccess) {
      debugPrint('✅ PIN Registration Success');
      debugPrint('👤 User ID: ${response.data?['user']?['id']}');
    } else {
      debugPrint('❌ PIN Registration Failed: ${response.message}');
      debugPrint('🔍 Errors: ${response.errors}');
    }

    return response;
  }

  /// Admin registration
  /// POST /users/auth/admin/register/
  Future<ApiResponse<Map<String, dynamic>>> adminRegister(Map<String, dynamic> request) async {
    debugPrint('🔐 UserService: Admin Registration Request');

    return await _apiService.post<Map<String, dynamic>>(
      '/auth/admin/register/',
      body: request,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Change PIN
  /// POST /users/auth/pin/change/
  Future<ApiResponse<Map<String, dynamic>>> changePin(ChangePinRequest request, String token) async {
    debugPrint('🔐 UserService: Change PIN Request');

    return await _apiService.post<Map<String, dynamic>>(
      '/auth/pin/change/',
      body: request.toJson(),
      token: token,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Reset PIN
  /// POST /users/auth/pin/reset/
  Future<ApiResponse<Map<String, dynamic>>> resetPin(ResetPinRequest request) async {
    debugPrint('🔐 UserService: Reset PIN Request');
    debugPrint('📱 Phone: ${request.phoneNumber}');

    return await _apiService.post<Map<String, dynamic>>(
      '/auth/pin/reset/',
      body: request.toJson(),
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Get PIN status
  /// GET /users/auth/pin/status/
  Future<ApiResponse<Map<String, dynamic>>> getPinStatus(String token) async {
    debugPrint('🔐 UserService: Get PIN Status');

    return await _apiService.get<Map<String, dynamic>>(
      '/auth/pin/status/',
      token: token,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Get user type
  /// GET /users/auth/user-type/
  Future<ApiResponse<Map<String, dynamic>>> getUserType(String token) async {
    debugPrint('🔐 UserService: Get User Type');

    return await _apiService.get<Map<String, dynamic>>(
      '/auth/user-type/',
      token: token,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Get user type change info
  /// GET /users/auth/user-type-change/
  Future<ApiResponse<Map<String, dynamic>>> getUserTypeChangeInfo(String token) async {
    debugPrint('🔐 UserService: Get User Type Change Info');

    final response = await _apiService.get<Map<String, dynamic>>(
      '/auth/user-type-change/',
      token: token,
      fromJson: (json) {
        debugPrint('🔄 UserService: Raw user type change response: $json');
        return json as Map<String, dynamic>;
      },
    );

    if (response.isSuccess) {
      debugPrint('✅ UserService: User type change info retrieved successfully');
      debugPrint('🔄 Response data keys: ${response.data?.keys.toList()}');
    } else {
      debugPrint('❌ UserService: Failed to get user type change info: ${response.message}');
    }

    return response;
  }

  /// Change user type
  /// POST /users/auth/user-type-change/
  Future<ApiResponse<Map<String, dynamic>>> changeUserType(
    Map<String, dynamic> request,
    String token,
  ) async {
    debugPrint('🔐 UserService: Change User Type');
    debugPrint('🔄 To: ${request['to']}');

    return await _apiService.post<Map<String, dynamic>>(
      '/auth/user-type-change/',
      body: request,
      token: token,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Refresh token
  /// POST /users/auth/token/refresh/
  Future<ApiResponse<Map<String, dynamic>>> refreshToken(String refreshToken) async {
    debugPrint('🔐 UserService: Refresh Token');

    return await _apiService.post<Map<String, dynamic>>(
      '/auth/token/refresh/',
      body: {'refresh': refreshToken},
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  // ================================
  // USER PROFILE MANAGEMENT
  // ================================

  /// Get current user profile
  /// GET /users/users/me/
  Future<ApiResponse<AppUser>> getCurrentUserProfile(String token) async {
    debugPrint('👤 UserService: Get Current User Profile');

    final response = await _apiService.get<AppUser>(
      '/users/me/',
      token: token,
      fromJson: (json) {
        try {
          debugPrint('📥 Raw profile response: $json');

          // Handle nested data structure if response has 'data' wrapper
          // AppUser userData;
          if (json is Map<String, dynamic>) {
            if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
              // userData = json['data'] as Map<String, dynamic>;
              // debugPrint('📦 Extracted user data from wrapper: $userData');
              return AppUser.fromJson(json['data']);
            } else {
              // userData = json;
              // debugPrint('📦 Using direct user data: $userData');
              return AppUser.fromJson(json);
            }
          } else {
            throw Exception('Invalid JSON format: expected Map<String, dynamic>, got ${json.runtimeType}');
          }
        } catch (e) {
          debugPrint('❌ Profile parsing error: $e');
          debugPrint('📄 Problematic JSON: $json');
          rethrow;
        }
      },
    );

    if (response.isSuccess) {
      debugPrint('✅ Profile Retrieved: ${response.data?.displayName}');
      debugPrint('📊 User Type: ${response.data?.userType}');
      debugPrint('⭐ Rating: ${response.data?.rating}');
      debugPrint('💰 Balance: ${response.data?.balance}');
    } else {
      debugPrint('❌ Failed to get profile: ${response.message}');
    }

    return response;
  }

  /// Update user profile (full update)
  /// PUT /users/users/me/
  Future<ApiResponse<AppUser>> updateProfile(UpdateProfileRequest request, String token) async {
    debugPrint('👤 UserService: Update Profile (PUT)');
    debugPrint('📝 Fields: ${request.toJson().keys.join(', ')}');

    return await _apiService.put<AppUser>(
      '/users/me/',
      body: request.toJson(),
      token: token,
      fromJson: (json) => AppUser.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Update user profile (partial update)
  /// PATCH /users/users/me/
  Future<ApiResponse<AppUser>> updateProfilePartial(UpdateProfileRequest request, String token) async {
    debugPrint('👤 UserService: Update Profile (PATCH)');
    debugPrint('📝 Fields: ${request.toJson().keys.join(', ')}');

    return await _apiService.patch<AppUser>(
      '/users/me/',
      body: request.toJson(),
      token: token,
      fromJson: (json) => AppUser.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Upload profile image (file)
  /// POST /users/users/profile/image/
  Future<ApiResponse<Map<String, dynamic>>> uploadProfileImage(File imageFile, String token) async {
    debugPrint('👤 UserService: Upload Profile Image');
    debugPrint('📄 File: ${imageFile.path}');

    return await _apiService.uploadFile<Map<String, dynamic>>(
      '/users/profile/image/',
      file: imageFile,
      fieldName: 'profile_image',
      token: token,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Upload profile image (URL or base64)
  /// POST /users/users/profile/image/
  Future<ApiResponse<Map<String, dynamic>>> uploadProfileImageData({
    String? imageLink,
    String? imageBase64,
    required String token,
  }) async {
    debugPrint('👤 UserService: Upload Profile Image Data');

    final body = <String, dynamic>{};
    if (imageLink != null) body['image_link'] = imageLink;
    if (imageBase64 != null) body['image_base64'] = imageBase64;

    return await _apiService.post<Map<String, dynamic>>(
      '/users/profile/image/',
      body: body,
      token: token,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Get public user profile
  /// GET /users/users/{userId}/
  Future<ApiResponse<AppUser>> getPublicProfile(String userId) async {
    debugPrint('👤 UserService: Get Public Profile');
    debugPrint('🆔 User ID: $userId');

    return await _apiService.get<AppUser>(
      '/users/$userId/',
      fromJson: (json) => AppUser.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Deactivate account
  /// POST /users/users/deactivate/
  Future<ApiResponse<Map<String, dynamic>>> deactivateAccount(String token) async {
    debugPrint('👤 UserService: Deactivate Account');

    return await _apiService.post<Map<String, dynamic>>(
      '/users/deactivate/',
      token: token,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  // ================================
  // TOKEN MANAGEMENT
  // ================================

  /// List access tokens
  /// GET /users/users/me/tokens/
  Future<ApiResponse<List<Map<String, dynamic>>>> listAccessTokens({
    String? token,
    bool? activeOnly,
  }) async {
    debugPrint('🔑 UserService: List Access Tokens');
    debugPrint('🔑 Active only: ${activeOnly ?? 'all'}');

    final queryParams = <String, String>{};
    if (activeOnly != null) queryParams['active_only'] = activeOnly.toString();

    return await _apiService.get<List<Map<String, dynamic>>>(
      '/users/me/tokens/',
      queryParams: queryParams,
      token: token,
      fromJson: (json) {
        debugPrint('🔑 Raw token response: $json');
        final data = json as Map<String, dynamic>;
        final tokensData = data['data'] as Map<String, dynamic>? ?? data;
        final tokens = tokensData['tokens'] as List<dynamic>? ?? [];
        debugPrint('🔑 Found ${tokens.length} tokens');
        return tokens.map((token) => token as Map<String, dynamic>).toList();
      },
    );
  }

  /// Revoke specific token
  /// POST /users/users/me/tokens/{tokenId}/revoke/
  Future<ApiResponse<Map<String, dynamic>>> revokeToken(String tokenId, String token) async {
    debugPrint('🔑 UserService: Revoke Token');
    debugPrint('🆔 Token ID: $tokenId');

    return await _apiService.post<Map<String, dynamic>>(
      '/users/me/tokens/$tokenId/revoke/',
      token: token,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Revoke all tokens
  /// POST /users/users/me/tokens/revoke_all/
  Future<ApiResponse<Map<String, dynamic>>> revokeAllTokens(String token) async {
    debugPrint('🔑 UserService: Revoke All Tokens');

    return await _apiService.post<Map<String, dynamic>>(
      '/users/me/tokens/revoke_all/',
      token: token,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  // ================================
  // SOCIAL FEATURES
  // ================================

  /// Like user profile
  /// POST /users/users/{userId}/like/
  Future<ApiResponse<Map<String, dynamic>>> likeUser(String userId, String token) async {
    debugPrint('❤️ UserService: Like User');
    debugPrint('🆔 User ID: $userId');

    return await _apiService.post<Map<String, dynamic>>(
      '/users/$userId/like/',
      token: token,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Pass user profile
  /// POST /users/users/{userId}/pass/
  Future<ApiResponse<Map<String, dynamic>>> passUser(String userId, String token) async {
    debugPrint('👋 UserService: Pass User');
    debugPrint('🆔 User ID: $userId');

    return await _apiService.post<Map<String, dynamic>>(
      '/users/$userId/pass/',
      token: token,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  // ================================
  // USER SEARCH
  // ================================

  /// Search users (GET)
  /// GET /users/users/search/
  Future<ApiResponse<PaginatedResponse<AppUser>>> searchUsersGet({
    String? query,
    String? type,
    int? page,
    int? pageSize,
    String? token,
  }) async {
    debugPrint('🔍 UserService: Search Users (GET)');
    debugPrint('🔎 Query: $query, Type: $type');

    final queryParams = <String, String>{};
    if (query != null) queryParams['q'] = query;
    if (type != null) queryParams['type'] = type;
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return await _apiService.get<PaginatedResponse<AppUser>>(
      '/users/search/',
      queryParams: queryParams,
      token: token,
      fromJson: (json) => PaginatedResponse.fromJson(
        json as Map<String, dynamic>,
        (item) => AppUser.fromJson(item),
      ),
    );
  }

  /// Search users (POST)
  /// POST /users/users/search/
  Future<ApiResponse<PaginatedResponse<AppUser>>> searchUsersPost(
    UserSearchRequest request,
    String token,
  ) async {
    debugPrint('🔍 UserService: Search Users (POST)');
    debugPrint('🔎 Search Term: ${request.searchTerm}');
    debugPrint('👥 User Types: ${request.userTypes?.map((t) => t.name).join(', ')}');

    return await _apiService.post<PaginatedResponse<AppUser>>(
      '/users/search/',
      body: request.toJson(),
      token: token,
      fromJson: (json) => PaginatedResponse.fromJson(
        json as Map<String, dynamic>,
        (item) => AppUser.fromJson(item),
      ),
    );
  }

  /// Search user by phone number
  /// POST /users/users/search/phone/
  Future<AppUser> searchUserByPhone(String phoneNumber) async {
    debugPrint('🔍 UserService: Search User by Phone');
    debugPrint('📱 Phone: $phoneNumber');

    final response = await _apiService.post<AppUser>(
      '/users/search/phone/',
      body: {'phone_number': phoneNumber},
      fromJson: (json) {
        try {
          debugPrint('📥 Raw phone search response: $json');
          final data = json as Map<String, dynamic>;
          final userData = data['user'] as Map<String, dynamic>?;

          if (userData != null) {
            debugPrint('👤 User data found: $userData');
            return AppUser.fromJson(userData);
          } else {
            debugPrint('❌ No user data in response');
            throw Exception('No user data in response');
          }
        } catch (e) {
          debugPrint('❌ Phone search parsing error: $e');
          debugPrint('📄 Problematic JSON: $json');
          throw Exception('Phone search parsing error: $e');
        }
      },
    );

    if (response.isSuccess && response.data != null) {
      debugPrint('✅ User found: ${response.data?.displayName}');
      debugPrint('📊 User Type: ${response.data?.userType}');
      debugPrint('⭐ Rating: ${response.data?.rating}');
    } else {
      debugPrint('❌ User not found or error: ${response.message}');
    }

    return response.data!;
  }

  // ================================
  // VERIFICATION MANAGEMENT
  // ================================

  /// List verifications
  /// GET /users/verifications/
  Future<ApiResponse<PaginatedResponse<Verification>>> listVerifications({
    String? status,
    String? verificationType,
    int? page,
    int? pageSize,
    required String token,
  }) async {
    debugPrint('📋 UserService: List Verifications');

    final queryParams = <String, String>{};
    if (status != null) queryParams['status'] = status;
    if (verificationType != null) {
      queryParams['verification_type'] = verificationType;
    }
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    return await _apiService.get<PaginatedResponse<Verification>>(
      '/users/verifications/',
      queryParams: queryParams,
      token: token,
      fromJson: (json) => PaginatedResponse.fromJson(
        json as Map<String, dynamic>,
        (item) => Verification.fromJson(item),
      ),
    );
  }

  /// Create verification request
  /// POST /users/verifications/
  Future<ApiResponse<Verification>> createVerification(
    CreateVerificationRequest request,
    String token,
  ) async {
    debugPrint('📋 UserService: Create Verification');
    debugPrint('📄 Type: ${request.verificationType.name}');
    debugPrint('📄 Document Type: ${request.documentType}');

    return await _apiService.post<Verification>(
      '/users/verifications/',
      body: request.toJson(),
      token: token,
      fromJson: (json) => Verification.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get verification details
  /// GET /users/verifications/{verificationId}/
  Future<ApiResponse<Verification>> getVerification(int verificationId, String token) async {
    debugPrint('📋 UserService: Get Verification');
    debugPrint('🆔 Verification ID: $verificationId');

    return await _apiService.get<Verification>(
      '/users/verifications/$verificationId/',
      token: token,
      fromJson: (json) => Verification.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Update verification (full)
  /// PUT /users/verifications/{verificationId}/
  Future<ApiResponse<Verification>> updateVerification(
    int verificationId,
    Map<String, dynamic> request,
    String token,
  ) async {
    debugPrint('📋 UserService: Update Verification (PUT)');
    debugPrint('🆔 Verification ID: $verificationId');

    return await _apiService.put<Verification>(
      '/users/verifications/$verificationId/',
      body: request,
      token: token,
      fromJson: (json) => Verification.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Update verification (partial)
  /// PATCH /users/verifications/{verificationId}/
  Future<ApiResponse<Verification>> updateVerificationPartial(
    int verificationId,
    Map<String, dynamic> request,
    String token,
  ) async {
    debugPrint('📋 UserService: Update Verification (PATCH)');
    debugPrint('🆔 Verification ID: $verificationId');

    return await _apiService.patch<Verification>(
      '/users/verifications/$verificationId/',
      body: request,
      token: token,
      fromJson: (json) => Verification.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Delete verification
  /// DELETE /users/verifications/{verificationId}/
  Future<ApiResponse<void>> deleteVerification(int verificationId, String token) async {
    debugPrint('📋 UserService: Delete Verification');
    debugPrint('🆔 Verification ID: $verificationId');

    return await _apiService.delete<void>(
      '/users/verifications/$verificationId/',
      token: token,
    );
  }

  /// Cancel verification
  /// POST /users/verifications/{verificationId}/cancel/
  Future<ApiResponse<Verification>> cancelVerification(int verificationId, String token) async {
    debugPrint('📋 UserService: Cancel Verification');
    debugPrint('🆔 Verification ID: $verificationId');

    return await _apiService.post<Verification>(
      '/users/verifications/$verificationId/cancel/',
      token: token,
      fromJson: (json) => Verification.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Mark verification in progress (Admin)
  /// POST /users/verifications/{verificationId}/mark_in_progress/
  Future<ApiResponse<Verification>> markVerificationInProgress(
    int verificationId,
    String token, {
    String? adminNotes,
  }) async {
    debugPrint('📋 UserService: Mark Verification In Progress');
    debugPrint('🆔 Verification ID: $verificationId');

    final body = <String, dynamic>{};
    if (adminNotes != null) body['admin_notes'] = adminNotes;

    return await _apiService.post<Verification>(
      '/users/verifications/$verificationId/mark_in_progress/',
      body: body,
      token: token,
      fromJson: (json) => Verification.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Mark verification verified (Admin)
  /// POST /users/verifications/{verificationId}/mark_verified/
  Future<ApiResponse<Verification>> markVerificationVerified(
    int verificationId,
    String token, {
    String? adminNotes,
  }) async {
    debugPrint('📋 UserService: Mark Verification Verified');
    debugPrint('🆔 Verification ID: $verificationId');

    final body = <String, dynamic>{};
    if (adminNotes != null) body['admin_notes'] = adminNotes;

    return await _apiService.post<Verification>(
      '/users/verifications/$verificationId/mark_verified/',
      body: body,
      token: token,
      fromJson: (json) => Verification.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Mark verification rejected (Admin)
  /// POST /users/verifications/{verificationId}/mark_rejected/
  Future<ApiResponse<Verification>> markVerificationRejected(
    int verificationId,
    String token, {
    String? adminNotes,
  }) async {
    debugPrint('📋 UserService: Mark Verification Rejected');
    debugPrint('🆔 Verification ID: $verificationId');

    final body = <String, dynamic>{};
    if (adminNotes != null) body['admin_notes'] = adminNotes;

    return await _apiService.post<Verification>(
      '/users/verifications/$verificationId/mark_rejected/',
      body: body,
      token: token,
      fromJson: (json) => Verification.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get verification status summary (Admin)
  /// GET /users/verifications/status_summary/
  Future<ApiResponse<Map<String, dynamic>>> getVerificationStatusSummary(String token) async {
    debugPrint('📋 UserService: Get Verification Status Summary');

    return await _apiService.get<Map<String, dynamic>>(
      '/users/verifications/status_summary/',
      token: token,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Initiate user verification
  /// POST /users/users/verify/
  Future<ApiResponse<Map<String, dynamic>>> initiateUserVerification(
    CreateVerificationRequest request,
    String token,
  ) async {
    debugPrint('📋 UserService: Initiate User Verification');
    debugPrint('📄 Type: ${request.verificationType.name}');

    return await _apiService.post<Map<String, dynamic>>(
      '/users/verify/',
      body: request.toJson(),
      token: token,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  // ================================
  // CONVENIENCE METHODS
  // ================================

  /// Get user tokens for debugging
  Future<ApiResponse<Map<String, dynamic>>> getUserTokens(String token) async {
    debugPrint('🔑 UserService: Get User Tokens (for debugging)');

    return await listAccessTokens(token: token).then((response) {
      if (response.isSuccess) {
        return ApiResponse.success(
          data: {'tokens': response.data ?? []},
          message: 'Tokens retrieved successfully',
        );
      } else {
        return ApiResponse.error(
          message: response.message,
          statusCode: response.statusCode,
          errors: response.errors,
        );
      }
    });
  }

  /// Complete logout process
  Future<ApiResponse<Map<String, dynamic>>> logout(String token) async {
    debugPrint('🔐 UserService: Complete Logout Process');

    try {
      // Revoke all tokens
      final revokeResponse = await revokeAllTokens(token);

      if (revokeResponse.isSuccess) {
        debugPrint('✅ All tokens revoked successfully');
        return ApiResponse.success(
          data: {'logout': true, 'tokens_revoked': true},
          message: 'Logged out successfully',
        );
      } else {
        debugPrint('⚠️ Token revocation failed, but continuing logout');
        return ApiResponse.success(
          data: {'logout': true, 'tokens_revoked': false},
          message: 'Logged out (token revocation failed)',
        );
      }
    } catch (e) {
      debugPrint('❌ Logout error: $e');
      return ApiResponse.error(
        message: 'Logout error: $e',
        statusCode: 500,
      );
    }
  }

  /// Check if user is authenticated (by validating token)
  Future<bool> isAuthenticated(String? token) async {
    if (token == null || token.isEmpty) {
      debugPrint('🔐 UserService: No token provided');
      return false;
    }

    try {
      final response = await getCurrentUserProfile(token);
      final isValid = response.isSuccess;
      debugPrint('🔐 UserService: Token validation result: $isValid');
      return isValid;
    } catch (e) {
      debugPrint('🔐 UserService: Token validation error: $e');
      return false;
    }
  }
}

// =============================================================================
// USER TYPE ICONS
// =============================================================================

/// Get user type icon
IconData getUserTypeIcon(UserType userType) {
  switch (userType) {
    case UserType.admin:
      return Prbal.userSecret;
    case UserType.provider:
      return Prbal.designServices;
    case UserType.customer:
      return Prbal.user;
  }
}

String getUserTypeDisplayName(UserType userType) {
  switch (userType) {
    case UserType.provider:
      return 'Service Provider';
    case UserType.admin:
      return 'Administrator';
    case UserType.customer:
      return 'Customer';
  }
}

String getDisplayName(AppUser user) {
  final firstName = user.firstName;
  final lastName = user.lastName;
  final username = user.username;

  if (firstName.isNotEmpty && lastName.isNotEmpty) {
    return '$firstName $lastName';
  } else if (firstName.isNotEmpty) {
    return firstName;
  } else if (username.isNotEmpty) {
    return username;
  }
  return 'User';
}

// Comprehensive list of countries with codes and flags
List<Map<String, String>> countries = [
  {'name': 'Afghanistan', 'code': '+93', 'flag': '🇦🇫'},
  {'name': 'Åland Islands', 'code': '+358', 'flag': '🇦🇽'},
  {'name': 'Albania', 'code': '+355', 'flag': '🇦🇱'},
  {'name': 'Algeria', 'code': '+213', 'flag': '🇩🇿'},
  {'name': 'American Samoa', 'code': '+1', 'flag': '🇦🇸'},
  {'name': 'Andorra', 'code': '+376', 'flag': '🇦🇩'},
  {'name': 'Angola', 'code': '+244', 'flag': '🇦🇴'},
  {'name': 'Anguilla', 'code': '+1', 'flag': '🇦🇮'},
  {'name': 'Antarctica', 'code': '+672', 'flag': '🇦🇶'},
  {'name': 'Antigua and Barbuda', 'code': '+1', 'flag': '🇦🇬'},
  {'name': 'Argentina', 'code': '+54', 'flag': '🇦🇷'},
  {'name': 'Armenia', 'code': '+374', 'flag': '🇦🇲'},
  {'name': 'Aruba', 'code': '+297', 'flag': '🇦🇼'},
  {'name': 'Australia', 'code': '+61', 'flag': '🇦🇺'},
  {'name': 'Austria', 'code': '+43', 'flag': '🇦🇹'},
  {'name': 'Azerbaijan', 'code': '+994', 'flag': '🇦🇿'},
  {'name': 'Bahamas', 'code': '+1', 'flag': '🇧🇸'},
  {'name': 'Bahrain', 'code': '+973', 'flag': '🇧🇭'},
  {'name': 'Bangladesh', 'code': '+880', 'flag': '🇧🇩'},
  {'name': 'Barbados', 'code': '+1', 'flag': '🇧🇧'},
  {'name': 'Belarus', 'code': '+375', 'flag': '🇧🇾'},
  {'name': 'Belgium', 'code': '+32', 'flag': '🇧🇪'},
  {'name': 'Belize', 'code': '+501', 'flag': '🇧🇿'},
  {'name': 'Benin', 'code': '+229', 'flag': '🇧🇯'},
  {'name': 'Bermuda', 'code': '+1', 'flag': '🇧🇲'},
  {'name': 'Bhutan', 'code': '+975', 'flag': '🇧🇹'},
  {'name': 'Bolivia', 'code': '+591', 'flag': '🇧🇴'},
  {'name': 'Bonaire, Sint Eustatius and Saba', 'code': '+599', 'flag': '🇧🇶'},
  {'name': 'Bosnia and Herzegovina', 'code': '+387', 'flag': '🇧🇦'},
  {'name': 'Botswana', 'code': '+267', 'flag': '🇧🇼'},
  {'name': 'Bouvet Island', 'code': '+47', 'flag': '🇧🇻'},
  {'name': 'Brazil', 'code': '+55', 'flag': '🇧🇷'},
  {'name': 'British Virgin Islands', 'code': '+1', 'flag': '🇻🇬'},
  {'name': 'Brunei', 'code': '+673', 'flag': '🇧🇳'},
  {'name': 'Bulgaria', 'code': '+359', 'flag': '🇧🇬'},
  {'name': 'Burkina Faso', 'code': '+226', 'flag': '🇧🇫'},
  {'name': 'Burundi', 'code': '+257', 'flag': '🇧🇮'},
  {'name': 'Cabo Verde', 'code': '+238', 'flag': '🇨🇻'},
  {'name': 'Cambodia', 'code': '+855', 'flag': '🇰🇭'},
  {'name': 'Cameroon', 'code': '+237', 'flag': '🇨🇲'},
  {'name': 'Canada', 'code': '+1', 'flag': '🇨🇦'},
  {'name': 'Cayman Islands', 'code': '+1', 'flag': '🇰🇾'},
  {'name': 'Central African Republic', 'code': '+236', 'flag': '🇨🇫'},
  {'name': 'Chad', 'code': '+235', 'flag': '🇹🇩'},
  {'name': 'Chile', 'code': '+56', 'flag': '🇨🇱'},
  {'name': 'China', 'code': '+86', 'flag': '🇨🇳'},
  {'name': 'Christmas Island', 'code': '+61', 'flag': '🇨🇽'},
  {'name': 'Cocos (Keeling) Islands', 'code': '+61', 'flag': '🇨🇨'},
  {'name': 'Colombia', 'code': '+57', 'flag': '🇨🇴'},
  {'name': 'Comoros', 'code': '+269', 'flag': '🇰🇲'},
  {'name': 'Congo', 'code': '+242', 'flag': '🇨🇬'},
  {'name': 'Congo (Democratic Republic)', 'code': '+243', 'flag': '🇨🇩'},
  {'name': 'Cook Islands', 'code': '+682', 'flag': '🇨🇰'},
  {'name': 'Costa Rica', 'code': '+506', 'flag': '🇨🇷'},
  {'name': 'Côte d\'Ivoire', 'code': '+225', 'flag': '🇨🇮'},
  {'name': 'Croatia', 'code': '+385', 'flag': '🇭🇷'},
  {'name': 'Cuba', 'code': '+53', 'flag': '🇨🇺'},
  {'name': 'Curaçao', 'code': '+599', 'flag': '🇨🇼'},
  {'name': 'Cyprus', 'code': '+357', 'flag': '🇨🇾'},
  {'name': 'Czech Republic', 'code': '+420', 'flag': '🇨🇿'},
  {'name': 'Denmark', 'code': '+45', 'flag': '🇩🇰'},
  {'name': 'Djibouti', 'code': '+253', 'flag': '🇩🇯'},
  {'name': 'Dominica', 'code': '+1', 'flag': '🇩🇲'},
  {'name': 'Dominican Republic', 'code': '+1', 'flag': '🇩🇴'},
  {'name': 'Ecuador', 'code': '+593', 'flag': '🇪🇨'},
  {'name': 'Egypt', 'code': '+20', 'flag': '🇪🇬'},
  {'name': 'El Salvador', 'code': '+503', 'flag': '🇸🇻'},
  {'name': 'Equatorial Guinea', 'code': '+240', 'flag': '🇬🇶'},
  {'name': 'Eritrea', 'code': '+291', 'flag': '🇪🇷'},
  {'name': 'Estonia', 'code': '+372', 'flag': '🇪🇪'},
  {'name': 'Eswatini', 'code': '+268', 'flag': '🇸🇿'},
  {'name': 'Ethiopia', 'code': '+251', 'flag': '🇪🇹'},
  {'name': 'Falkland Islands', 'code': '+500', 'flag': '🇫🇰'},
  {'name': 'Faroe Islands', 'code': '+298', 'flag': '🇫🇴'},
  {'name': 'Fiji', 'code': '+679', 'flag': '🇫🇯'},
  {'name': 'Finland', 'code': '+358', 'flag': '🇫🇮'},
  {'name': 'France', 'code': '+33', 'flag': '🇫🇷'},
  {'name': 'French Guiana', 'code': '+594', 'flag': '🇬🇫'},
  {'name': 'French Polynesia', 'code': '+689', 'flag': '🇵🇫'},
  {'name': 'French Southern Territories', 'code': '+262', 'flag': '🇹🇫'},
  {'name': 'Gabon', 'code': '+241', 'flag': '🇬🇦'},
  {'name': 'Gambia', 'code': '+220', 'flag': '🇬🇲'},
  {'name': 'Georgia', 'code': '+995', 'flag': '🇬🇪'},
  {'name': 'Germany', 'code': '+49', 'flag': '🇩🇪'},
  {'name': 'Ghana', 'code': '+233', 'flag': '🇬🇭'},
  {'name': 'Gibraltar', 'code': '+350', 'flag': '🇬🇮'},
  {'name': 'Greece', 'code': '+30', 'flag': '🇬🇷'},
  {'name': 'Greenland', 'code': '+299', 'flag': '🇬🇱'},
  {'name': 'Grenada', 'code': '+1', 'flag': '🇬🇩'},
  {'name': 'Guadeloupe', 'code': '+590', 'flag': '🇬🇵'},
  {'name': 'Guam', 'code': '+1', 'flag': '🇬🇺'},
  {'name': 'Guatemala', 'code': '+502', 'flag': '🇬🇹'},
  {'name': 'Guernsey', 'code': '+44', 'flag': '🇬🇬'},
  {'name': 'Guinea', 'code': '+224', 'flag': '🇬🇳'},
  {'name': 'Guinea-Bissau', 'code': '+245', 'flag': '🇬🇼'},
  {'name': 'Guyana', 'code': '+592', 'flag': '🇬🇾'},
  {'name': 'Haiti', 'code': '+509', 'flag': '🇭🇹'},
  {'name': 'Heard Island and McDonald Islands', 'code': '+672', 'flag': '🇭🇲'},
  {'name': 'Holy See', 'code': '+379', 'flag': '🇻🇦'},
  {'name': 'Honduras', 'code': '+504', 'flag': '🇭🇳'},
  {'name': 'Hong Kong', 'code': '+852', 'flag': '🇭🇰'},
  {'name': 'Hungary', 'code': '+36', 'flag': '🇭🇺'},
  {'name': 'Iceland', 'code': '+354', 'flag': '🇮🇸'},
  {'name': 'India', 'code': '+91', 'flag': '🇮🇳'},
  {'name': 'Indonesia', 'code': '+62', 'flag': '🇮🇩'},
  {'name': 'Iran', 'code': '+98', 'flag': '🇮🇷'},
  {'name': 'Iraq', 'code': '+964', 'flag': '🇮🇶'},
  {'name': 'Ireland', 'code': '+353', 'flag': '🇮🇪'},
  {'name': 'Isle of Man', 'code': '+44', 'flag': '🇮🇲'},
  {'name': 'Israel', 'code': '+972', 'flag': '🇮🇱'},
  {'name': 'Italy', 'code': '+39', 'flag': '🇮🇹'},
  {'name': 'Jamaica', 'code': '+1', 'flag': '🇯🇲'},
  {'name': 'Japan', 'code': '+81', 'flag': '🇯🇵'},
  {'name': 'Jersey', 'code': '+44', 'flag': '🇯🇪'},
  {'name': 'Jordan', 'code': '+962', 'flag': '🇯🇴'},
  {'name': 'Kazakhstan', 'code': '+7', 'flag': '🇰🇿'},
  {'name': 'Kenya', 'code': '+254', 'flag': '🇰🇪'},
  {'name': 'Kiribati', 'code': '+686', 'flag': '🇰🇮'},
  {'name': 'Kuwait', 'code': '+965', 'flag': '🇰🇼'},
  {'name': 'Kyrgyzstan', 'code': '+996', 'flag': '🇰🇬'},
  {'name': 'Laos', 'code': '+856', 'flag': '🇱🇦'},
  {'name': 'Latvia', 'code': '+371', 'flag': '🇱🇻'},
  {'name': 'Lebanon', 'code': '+961', 'flag': '🇱🇧'},
  {'name': 'Lesotho', 'code': '+266', 'flag': '🇱🇸'},
  {'name': 'Liberia', 'code': '+231', 'flag': '🇱🇷'},
  {'name': 'Libya', 'code': '+218', 'flag': '🇱🇾'},
  {'name': 'Liechtenstein', 'code': '+423', 'flag': '🇱🇮'},
  {'name': 'Lithuania', 'code': '+370', 'flag': '🇱🇹'},
  {'name': 'Luxembourg', 'code': '+352', 'flag': '🇱🇺'},
  {'name': 'Macao', 'code': '+853', 'flag': '🇲🇴'},
  {'name': 'Madagascar', 'code': '+261', 'flag': '🇲🇬'},
  {'name': 'Malawi', 'code': '+265', 'flag': '🇲🇼'},
  {'name': 'Malaysia', 'code': '+60', 'flag': '🇲🇾'},
  {'name': 'Maldives', 'code': '+960', 'flag': '🇲🇻'},
  {'name': 'Mali', 'code': '+223', 'flag': '🇲🇱'},
  {'name': 'Malta', 'code': '+356', 'flag': '🇲🇹'},
  {'name': 'Marshall Islands', 'code': '+692', 'flag': '🇲🇭'},
  {'name': 'Martinique', 'code': '+596', 'flag': '🇲🇶'},
  {'name': 'Mauritania', 'code': '+222', 'flag': '🇲🇷'},
  {'name': 'Mauritius', 'code': '+230', 'flag': '🇲🇺'},
  {'name': 'Mayotte', 'code': '+262', 'flag': '🇾🇹'},
  {'name': 'Mexico', 'code': '+52', 'flag': '🇲🇽'},
  {'name': 'Micronesia', 'code': '+691', 'flag': '🇫🇲'},
  {'name': 'Moldova', 'code': '+373', 'flag': '🇲🇩'},
  {'name': 'Monaco', 'code': '+377', 'flag': '🇲🇨'},
  {'name': 'Mongolia', 'code': '+976', 'flag': '🇲🇳'},
  {'name': 'Montenegro', 'code': '+382', 'flag': '🇲🇪'},
  {'name': 'Montserrat', 'code': '+1', 'flag': '🇲🇸'},
  {'name': 'Morocco', 'code': '+212', 'flag': '🇲🇦'},
  {'name': 'Mozambique', 'code': '+258', 'flag': '🇲🇿'},
  {'name': 'Myanmar', 'code': '+95', 'flag': '🇲🇲'},
  {'name': 'Namibia', 'code': '+264', 'flag': '🇳🇦'},
  {'name': 'Nauru', 'code': '+674', 'flag': '🇳🇷'},
  {'name': 'Nepal', 'code': '+977', 'flag': '🇳🇵'},
  {'name': 'Netherlands', 'code': '+31', 'flag': '🇳🇱'},
  {'name': 'New Caledonia', 'code': '+687', 'flag': '🇳🇨'},
  {'name': 'New Zealand', 'code': '+64', 'flag': '🇳🇿'},
  {'name': 'Nicaragua', 'code': '+505', 'flag': '🇳🇮'},
  {'name': 'Niger', 'code': '+227', 'flag': '🇳🇪'},
  {'name': 'Nigeria', 'code': '+234', 'flag': '🇳🇬'},
  {'name': 'Niue', 'code': '+683', 'flag': '🇳🇺'},
  {'name': 'Norfolk Island', 'code': '+672', 'flag': '🇳🇫'},
  {'name': 'North Korea', 'code': '+850', 'flag': '🇰🇵'},
  {'name': 'North Macedonia', 'code': '+389', 'flag': '🇲🇰'},
  {'name': 'Northern Mariana Islands', 'code': '+1', 'flag': '🇲🇵'},
  {'name': 'Norway', 'code': '+47', 'flag': '🇳🇴'},
  {'name': 'Oman', 'code': '+968', 'flag': '🇴🇲'},
  {'name': 'Pakistan', 'code': '+92', 'flag': '🇵🇰'},
  {'name': 'Palau', 'code': '+680', 'flag': '🇵🇼'},
  {'name': 'Palestine', 'code': '+970', 'flag': '🇵🇸'},
  {'name': 'Panama', 'code': '+507', 'flag': '🇵🇦'},
  {'name': 'Papua New Guinea', 'code': '+675', 'flag': '🇵🇬'},
  {'name': 'Paraguay', 'code': '+595', 'flag': '🇵🇾'},
  {'name': 'Peru', 'code': '+51', 'flag': '🇵🇪'},
  {'name': 'Philippines', 'code': '+63', 'flag': '🇵🇭'},
  {'name': 'Pitcairn', 'code': '+64', 'flag': '🇵🇳'},
  {'name': 'Poland', 'code': '+48', 'flag': '🇵🇱'},
  {'name': 'Portugal', 'code': '+351', 'flag': '🇵🇹'},
  {'name': 'Puerto Rico', 'code': '+1', 'flag': '🇵🇷'},
  {'name': 'Qatar', 'code': '+974', 'flag': '🇶🇦'},
  {'name': 'Réunion', 'code': '+262', 'flag': '🇷🇪'},
  {'name': 'Romania', 'code': '+40', 'flag': '🇷🇴'},
  {'name': 'Russia', 'code': '+7', 'flag': '🇷🇺'},
  {'name': 'Rwanda', 'code': '+250', 'flag': '🇷🇼'},
  {'name': 'Saint Barthélemy', 'code': '+590', 'flag': '🇧🇱'},
  {'name': 'Saint Helena', 'code': '+290', 'flag': '🇸🇭'},
  {'name': 'Saint Kitts and Nevis', 'code': '+1', 'flag': '🇰🇳'},
  {'name': 'Saint Lucia', 'code': '+1', 'flag': '🇱🇨'},
  {'name': 'Saint Martin (French part)', 'code': '+590', 'flag': '🇲🇫'},
  {'name': 'Saint Pierre and Miquelon', 'code': '+508', 'flag': '🇵🇲'},
  {'name': 'Saint Vincent and the Grenadines', 'code': '+1', 'flag': '🇻🇨'},
  {'name': 'Samoa', 'code': '+685', 'flag': '🇼🇸'},
  {'name': 'San Marino', 'code': '+378', 'flag': '🇸🇲'},
  {'name': 'São Tomé and Príncipe', 'code': '+239', 'flag': '🇸🇹'},
  {'name': 'Saudi Arabia', 'code': '+966', 'flag': '🇸🇦'},
  {'name': 'Senegal', 'code': '+221', 'flag': '🇸🇳'},
  {'name': 'Serbia', 'code': '+381', 'flag': '🇷🇸'},
  {'name': 'Seychelles', 'code': '+248', 'flag': '🇸🇨'},
  {'name': 'Sierra Leone', 'code': '+232', 'flag': '🇸🇱'},
  {'name': 'Singapore', 'code': '+65', 'flag': '🇸🇬'},
  {'name': 'Sint Maarten (Dutch part)', 'code': '+1', 'flag': '🇸🇽'},
  {'name': 'Slovakia', 'code': '+421', 'flag': '🇸🇰'},
  {'name': 'Slovenia', 'code': '+386', 'flag': '🇸🇮'},
  {'name': 'Solomon Islands', 'code': '+677', 'flag': '🇸🇧'},
  {'name': 'Somalia', 'code': '+252', 'flag': '🇸🇴'},
  {'name': 'South Africa', 'code': '+27', 'flag': '🇿🇦'},
  {'name': 'South Georgia and the South Sandwich Islands', 'code': '+500', 'flag': '🇬🇸'},
  {'name': 'South Korea', 'code': '+82', 'flag': '🇰🇷'},
  {'name': 'South Sudan', 'code': '+211', 'flag': '🇸🇸'},
  {'name': 'Spain', 'code': '+34', 'flag': '🇪🇸'},
  {'name': 'Sri Lanka', 'code': '+94', 'flag': '🇱🇰'},
  {'name': 'Sudan', 'code': '+249', 'flag': '🇸🇩'},
  {'name': 'Suriname', 'code': '+597', 'flag': '🇸🇷'},
  {'name': 'Svalbard and Jan Mayen', 'code': '+47', 'flag': '🇸🇯'},
  {'name': 'Sweden', 'code': '+46', 'flag': '🇸🇪'},
  {'name': 'Switzerland', 'code': '+41', 'flag': '🇨🇭'},
  {'name': 'Syria', 'code': '+963', 'flag': '🇸🇾'},
  {'name': 'Taiwan', 'code': '+886', 'flag': '🇹🇼'},
  {'name': 'Tajikistan', 'code': '+992', 'flag': '🇹🇯'},
  {'name': 'Tanzania', 'code': '+255', 'flag': '🇹🇿'},
  {'name': 'Thailand', 'code': '+66', 'flag': '🇹🇭'},
  {'name': 'Timor-Leste', 'code': '+670', 'flag': '🇹🇱'},
  {'name': 'Togo', 'code': '+228', 'flag': '🇹🇬'},
  {'name': 'Tokelau', 'code': '+690', 'flag': '🇹🇰'},
  {'name': 'Tonga', 'code': '+676', 'flag': '🇹🇴'},
  {'name': 'Trinidad and Tobago', 'code': '+1', 'flag': '🇹🇹'},
  {'name': 'Tunisia', 'code': '+216', 'flag': '🇹🇳'},
  {'name': 'Turkey', 'code': '+90', 'flag': '🇹🇷'},
  {'name': 'Turkmenistan', 'code': '+993', 'flag': '🇹🇲'},
  {'name': 'Turks and Caicos Islands', 'code': '+1', 'flag': '🇹🇨'},
  {'name': 'Tuvalu', 'code': '+688', 'flag': '🇹🇻'},
  {'name': 'Uganda', 'code': '+256', 'flag': '🇺🇬'},
  {'name': 'Ukraine', 'code': '+380', 'flag': '🇺🇦'},
  {'name': 'United Arab Emirates', 'code': '+971', 'flag': '🇦🇪'},
  {'name': 'United Kingdom', 'code': '+44', 'flag': '🇬🇧'},
  {'name': 'United States', 'code': '+1', 'flag': '🇺🇸'},
  {'name': 'United States Minor Outlying Islands', 'code': '+1', 'flag': '🇺🇲'},
  {'name': 'Uruguay', 'code': '+598', 'flag': '🇺🇾'},
  {'name': 'US Virgin Islands', 'code': '+1', 'flag': '🇻🇮'},
  {'name': 'Uzbekistan', 'code': '+998', 'flag': '🇺🇿'},
  {'name': 'Vanuatu', 'code': '+678', 'flag': '🇻🇺'},
  {'name': 'Venezuela', 'code': '+58', 'flag': '🇻🇪'},
  {'name': 'Vietnam', 'code': '+84', 'flag': '🇻🇳'},
  {'name': 'Wallis and Futuna', 'code': '+681', 'flag': '🇼🇫'},
  {'name': 'Western Sahara', 'code': '+212', 'flag': '🇪🇭'},
  {'name': 'Yemen', 'code': '+967', 'flag': '🇾🇪'},
  {'name': 'Zambia', 'code': '+260', 'flag': '🇿🇲'},
  {'name': 'Zimbabwe', 'code': '+263', 'flag': '🇿🇼'},
];

/// RANDOM USER DATA GENERATION SYSTEM
///
/// This system generates realistic random user data for new user registration
/// when no user data is provided. It creates consistent, professional-looking
/// names and usernames that feel natural and authentic.
///
/// **FEATURES IMPLEMENTED:**
/// ✅ Curated lists of realistic first and last names
/// ✅ Smart username generation with multiple fallback patterns
/// ✅ Professional email generation based on generated names
/// ✅ Collision-resistant random selection algorithms
/// ✅ Comprehensive debug logging for development tracking
/// ✅ Consistent data generation with proper formatting
///
/// **GENERATION PATTERNS:**
/// - First Names: Curated list of 50+ common international names
/// - Last Names: Curated list of 50+ common surnames
/// - Usernames: Multiple patterns (firstname.lastname, firstname_lastname, etc.)
/// - Emails: Professional format using generated names with common domains
///
/// **DEBUG LOGGING:**
/// All generation steps include comprehensive debug prints with emoji prefixes:
/// - 🎲 Random generation operations
/// - 📝 Generated data values
/// - ✅ Successful generation confirmations
///
/// @returns Map containing generated firstName, lastName, username, email
Map<String, String> generateRandomUserData() {
  debugPrint('🎲 PinVerificationScreen: Generating random user data for new registration');

  final random = Random();

  // Curated lists of realistic names for international users
  final firstNames = [
    'Alex',
    'Sam',
    'Jordan',
    'Taylor',
    'Morgan',
    'Casey',
    'Riley',
    'Avery',
    'Jamie',
    'Blake',
    'Cameron',
    'Drew',
    'Emery',
    'Finley',
    'Hayden',
    'Kendall',
    'Logan',
    'Parker',
    'Quinn',
    'Reese',
    'Sage',
    'Skylar',
    'Aria',
    'Emma',
    'Olivia',
    'Sophia',
    'Isabella',
    'Mia',
    'Luna',
    'Grace',
    'Zoe',
    'Lily',
    'Ella',
    'Chloe',
    'Maya',
    'Nora',
    'Eva',
    'Ruby',
    'Ivy',
    'Liam',
    'Noah',
    'Ethan',
    'Lucas',
    'Mason',
    'Oliver',
    'Elijah',
    'James',
    'Benjamin',
    'Jacob',
    'Michael',
    'William',
    'Daniel',
    'Henry',
    'Jackson',
    'Sebastian',
    'Aiden',
    'Matthew',
    'Samuel',
    'David',
    'Joseph',
    'Carter',
    'Owen',
    'Wyatt',
    'John',
    'Jack',
    'Luke',
    'Jayden',
    'Dylan',
    'Grayson'
  ];

  final lastNames = [
    'Smith',
    'Johnson',
    'Williams',
    'Brown',
    'Jones',
    'Garcia',
    'Miller',
    'Davis',
    'Rodriguez',
    'Martinez',
    'Hernandez',
    'Lopez',
    'Gonzalez',
    'Wilson',
    'Anderson',
    'Thomas',
    'Taylor',
    'Moore',
    'Jackson',
    'Martin',
    'Lee',
    'Perez',
    'Thompson',
    'White',
    'Harris',
    'Sanchez',
    'Clark',
    'Ramirez',
    'Lewis',
    'Robinson',
    'Walker',
    'Young',
    'Allen',
    'King',
    'Wright',
    'Scott',
    'Torres',
    'Nguyen',
    'Hill',
    'Flores',
    'Green',
    'Adams',
    'Nelson',
    'Baker',
    'Hall',
    'Rivera',
    'Campbell',
    'Mitchell',
    'Carter',
    'Roberts',
    'Gomez',
    'Phillips',
    'Evans',
    'Turner',
    'Diaz',
    'Parker',
    'Cruz',
    'Edwards',
    'Collins',
    'Reyes',
    'Stewart',
    'Morris',
    'Morales',
    'Murphy',
    'Cook',
    'Rogers',
    'Gutierrez',
    'Ortiz',
    'Morgan',
    'Cooper',
    'Peterson',
    'Bailey',
    'Reed',
    'Kelly',
    'Howard',
    'Ramos'
  ];

  final emailDomains = [
    'gmail.com',
    'yahoo.com',
    'hotmail.com',
    'outlook.com',
    'icloud.com',
    'mail.com',
    'protonmail.com',
    'tutanota.com',
    'zoho.com',
    'fastmail.com'
  ];

  // Generate random names
  final firstName = firstNames[random.nextInt(firstNames.length)];
  final lastName = lastNames[random.nextInt(lastNames.length)];

  debugPrint('📝 Generated names: $firstName $lastName');

  // Generate username with multiple patterns for variety
  final usernamePatterns = [
    '${firstName.toLowerCase()}.${lastName.toLowerCase()}',
    '${firstName.toLowerCase()}_${lastName.toLowerCase()}',
    '${firstName.toLowerCase()}${lastName.toLowerCase()}',
    '${firstName.toLowerCase()}${lastName.toLowerCase()}${random.nextInt(99) + 1}',
    '${firstName.toLowerCase()}.${lastName.toLowerCase()}${random.nextInt(999) + 100}',
    '${firstName[0].toLowerCase()}${lastName.toLowerCase()}',
    '${firstName.toLowerCase()}${lastName[0].toLowerCase()}${random.nextInt(9999) + 1000}',
  ];

  final username = usernamePatterns[random.nextInt(usernamePatterns.length)];

  debugPrint('📝 Generated username: $username');

  // Generate professional email using generated names
  final emailDomain = emailDomains[random.nextInt(emailDomains.length)];
  final emailPatterns = [
    '${firstName.toLowerCase()}.${lastName.toLowerCase()}@$emailDomain',
    '${firstName.toLowerCase()}_${lastName.toLowerCase()}@$emailDomain',
    '${firstName.toLowerCase()}${lastName.toLowerCase()}@$emailDomain',
    '${firstName[0].toLowerCase()}${lastName.toLowerCase()}@$emailDomain',
    '${firstName.toLowerCase()}.${lastName[0].toLowerCase()}@$emailDomain',
  ];

  final email = emailPatterns[random.nextInt(emailPatterns.length)];

  debugPrint('📝 Generated email: $email');

  final generatedData = {
    'firstName': firstName,
    'lastName': lastName,
    'username': username,
    'email': email,
  };

  debugPrint('✅ Random user data generation completed successfully');
  debugPrint('📊 Generated data summary: $generatedData');

  return generatedData;
}
