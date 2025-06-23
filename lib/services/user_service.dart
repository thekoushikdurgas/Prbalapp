// import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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
  final String? firstName;
  final String? lastName;
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
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.rating = 0.0,
    this.balance = 0.0,
    this.totalBookings = 0,
    this.skills,
    this.availability,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    debugPrint('🔄 AppUser.fromJson: Parsing user data');
    debugPrint(
        '📊 Raw rating: ${json['rating']} (${json['rating'].runtimeType})');
    debugPrint(
        '💰 Raw balance: ${json['balance']} (${json['balance'].runtimeType})');

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
      skills: json['skills'] != null
          ? Map<String, String>.from(json['skills'])
          : null,
      availability: json['availability'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updated_at'] ?? json['created_at'] ?? '') ??
              DateTime.now(),
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
    };
  }

  String get displayName {
    if (firstName != null && lastName != null) {
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
      verificationType:
          VerificationType.fromString(json['verification_type'] ?? 'identity'),
      documentType: json['document_type'] ?? '',
      documentNumber: json['document_number'],
      status: VerificationStatus.fromString(json['status'] ?? 'pending'),
      documentUrl: json['document_url'] ?? json['document_link'],
      documentBackUrl: json['document_back_url'],
      adminNotes: json['admin_notes'],
      verifiedBy: json['verified_by'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      verifiedAt: json['verified_at'] != null
          ? DateTime.tryParse(json['verified_at'])
          : null,
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
  Future<ApiResponse<Map<String, dynamic>>> pinLogin(
      PinLoginRequest request) async {
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
  Future<ApiResponse<Map<String, dynamic>>> pinRegister(
      PinRegistrationRequest request) async {
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
  Future<ApiResponse<Map<String, dynamic>>> adminRegister(
      Map<String, dynamic> request) async {
    debugPrint('🔐 UserService: Admin Registration Request');

    return await _apiService.post<Map<String, dynamic>>(
      '/auth/admin/register/',
      body: request,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  /// Change PIN
  /// POST /users/auth/pin/change/
  Future<ApiResponse<Map<String, dynamic>>> changePin(
      ChangePinRequest request, String token) async {
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
  Future<ApiResponse<Map<String, dynamic>>> resetPin(
      ResetPinRequest request) async {
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
  Future<ApiResponse<Map<String, dynamic>>> getUserTypeChangeInfo(
      String token) async {
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
      debugPrint(
          '❌ UserService: Failed to get user type change info: ${response.message}');
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
  Future<ApiResponse<Map<String, dynamic>>> refreshToken(
      String refreshToken) async {
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
          Map<String, dynamic> userData;
          if (json is Map<String, dynamic>) {
            if (json.containsKey('data') &&
                json['data'] is Map<String, dynamic>) {
              userData = json['data'] as Map<String, dynamic>;
              debugPrint('📦 Extracted user data from wrapper: $userData');
            } else {
              userData = json;
              debugPrint('📦 Using direct user data: $userData');
            }
          } else {
            throw Exception(
                'Invalid JSON format: expected Map<String, dynamic>, got ${json.runtimeType}');
          }

          return AppUser.fromJson(userData);
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
  Future<ApiResponse<AppUser>> updateProfile(
      UpdateProfileRequest request, String token) async {
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
  Future<ApiResponse<AppUser>> updateProfilePartial(
      UpdateProfileRequest request, String token) async {
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
  Future<ApiResponse<Map<String, dynamic>>> uploadProfileImage(
      File imageFile, String token) async {
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
  Future<ApiResponse<Map<String, dynamic>>> deactivateAccount(
      String token) async {
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
  Future<ApiResponse<Map<String, dynamic>>> revokeToken(
      String tokenId, String token) async {
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
  Future<ApiResponse<Map<String, dynamic>>> revokeAllTokens(
      String token) async {
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
  Future<ApiResponse<Map<String, dynamic>>> likeUser(
      String userId, String token) async {
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
  Future<ApiResponse<Map<String, dynamic>>> passUser(
      String userId, String token) async {
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
    debugPrint(
        '👥 User Types: ${request.userTypes?.map((t) => t.name).join(', ')}');

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
  Future<ApiResponse<AppUser?>> searchUserByPhone(String phoneNumber) async {
    debugPrint('🔍 UserService: Search User by Phone');
    debugPrint('📱 Phone: $phoneNumber');

    final response = await _apiService.post<AppUser?>(
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
            return null;
          }
        } catch (e) {
          debugPrint('❌ Phone search parsing error: $e');
          debugPrint('📄 Problematic JSON: $json');
          return null;
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

    return response;
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
  Future<ApiResponse<Verification>> getVerification(
      int verificationId, String token) async {
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
  Future<ApiResponse<void>> deleteVerification(
      int verificationId, String token) async {
    debugPrint('📋 UserService: Delete Verification');
    debugPrint('🆔 Verification ID: $verificationId');

    return await _apiService.delete<void>(
      '/users/verifications/$verificationId/',
      token: token,
    );
  }

  /// Cancel verification
  /// POST /users/verifications/{verificationId}/cancel/
  Future<ApiResponse<Verification>> cancelVerification(
      int verificationId, String token) async {
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
  Future<ApiResponse<Map<String, dynamic>>> getVerificationStatusSummary(
      String token) async {
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
