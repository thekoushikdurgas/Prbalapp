import 'user_type.dart';
import '../core/serializable.dart';
import '../../utils/debug_logger.dart';

/// User model based on the API response structure
/// This model represents the authenticated user with all profile information
/// and settings used throughout the application.
class AppUser extends BaseModel with IdentifiableMixin, TimestampMixin {
  @override
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
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final bool notificationsEnabled;
  final bool biometricsEnabled;
  final bool analyticsEnabled;

  AppUser({
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
    DebugLogger.json('AppUser.fromJson', json);

    final rating = BaseModel.parseDouble(json['rating']);
    final balance = BaseModel.parseDouble(json['balance']);

    return AppUser(
      id: IdentifiableMixin.parseId(json),
      username: BaseModel.parseString(json['username']),
      email: BaseModel.parseString(
          json['email'], '${json['username'] ?? 'user'}@placeholder.com'),
      phoneNumber: BaseModel.parseOptionalString(json['phone_number']),
      firstName: BaseModel.parseString(json['first_name']),
      lastName: BaseModel.parseString(json['last_name']),
      userType: UserType.fromString(json['user_type'] ?? 'customer'),
      profilePicture: BaseModel.parseOptionalString(json['profile_picture']),
      bio: BaseModel.parseOptionalString(json['bio']),
      location: BaseModel.parseOptionalString(json['location']),
      isVerified: BaseModel.parseBool(json['is_verified']),
      isEmailVerified: BaseModel.parseBool(json['is_email_verified']),
      isPhoneVerified: BaseModel.parseBool(json['is_phone_verified']),
      rating: rating,
      balance: balance,
      totalBookings: BaseModel.parseInt(json['total_bookings']),
      skills: BaseModel.parseStringMap(json['skills']),
      availability: BaseModel.parseDynamicMap(json['availability']),
      createdAt: TimestampMixin.parseCreatedAt(json),
      updatedAt: TimestampMixin.parseUpdatedAt(json),
      notificationsEnabled: BaseModel.parseBool(json['notifications_enabled']),
      biometricsEnabled: BaseModel.parseBool(json['biometrics_enabled']),
      analyticsEnabled: BaseModel.parseBool(json['analytics_enabled']),
    );
  }

  @override
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

  @override
  String toString() {
    return 'AppUser(id: $id, username: $username, userType: ${userType.name}, displayName: $displayName)';
  }
}

/// Authentication tokens
class AuthTokens extends BaseModel {
  final String accessToken;
  final String refreshToken;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: BaseModel.parseString(json['access']),
      refreshToken: BaseModel.parseString(json['refresh']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'access': accessToken,
      'refresh': refreshToken,
    };
  }
}

/// PIN registration request
class PinRegistrationRequest extends BaseRequest {
  final String username;
  final String email;
  final String phoneNumber;
  final String pin;
  final String confirmPin;
  final String firstName;
  final String lastName;
  final String? deviceType;

  PinRegistrationRequest({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.pin,
    required this.confirmPin,
    required this.firstName,
    required this.lastName,
    this.deviceType = 'mobile',
  });

  @override
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

  @override
  bool validate() {
    return getValidationErrors().isEmpty;
  }

  @override
  List<String> getValidationErrors() {
    final errors = <String>[];

    if (username.isEmpty) errors.add('Username is required');
    if (email.isEmpty) errors.add('Email is required');
    if (phoneNumber.isEmpty) errors.add('Phone number is required');
    if (pin.isEmpty) errors.add('PIN is required');
    if (pin.length < 4) errors.add('PIN must be at least 4 characters');
    if (pin != confirmPin) errors.add('PIN confirmation does not match');
    if (firstName.isEmpty) errors.add('First name is required');
    if (lastName.isEmpty) errors.add('Last name is required');

    return errors;
  }
}

/// PIN login request
class PinLoginRequest extends BaseRequest {
  final String phoneNumber;
  final String pin;
  final String? deviceType;

  PinLoginRequest({
    required this.phoneNumber,
    required this.pin,
    this.deviceType = 'mobile',
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'pin': pin,
      'device_type': deviceType,
    };
  }

  @override
  bool validate() {
    return getValidationErrors().isEmpty;
  }

  @override
  List<String> getValidationErrors() {
    final errors = <String>[];

    if (phoneNumber.isEmpty) errors.add('Phone number is required');
    if (pin.isEmpty) errors.add('PIN is required');
    if (pin.length < 4) errors.add('PIN must be at least 4 characters');

    return errors;
  }
}

/// Change PIN request
class ChangePinRequest extends BaseRequest {
  final String currentPin;
  final String newPin;
  final String confirmNewPin;

  ChangePinRequest({
    required this.currentPin,
    required this.newPin,
    required this.confirmNewPin,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'current_pin': currentPin,
      'new_pin': newPin,
      'confirm_new_pin': confirmNewPin,
    };
  }

  @override
  bool validate() {
    return getValidationErrors().isEmpty;
  }

  @override
  List<String> getValidationErrors() {
    final errors = <String>[];

    if (currentPin.isEmpty) errors.add('Current PIN is required');
    if (newPin.isEmpty) errors.add('New PIN is required');
    if (newPin.length < 4) errors.add('New PIN must be at least 4 characters');
    if (newPin != confirmNewPin) {
      errors.add('New PIN confirmation does not match');
    }
    if (currentPin == newPin) {
      errors.add('New PIN must be different from current PIN');
    }

    return errors;
  }
}

/// Reset PIN request
class ResetPinRequest extends BaseRequest {
  final String phoneNumber;
  final String? deviceType;

  ResetPinRequest({
    required this.phoneNumber,
    this.deviceType = 'mobile',
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'device_type': deviceType,
    };
  }

  @override
  bool validate() {
    return getValidationErrors().isEmpty;
  }

  @override
  List<String> getValidationErrors() {
    final errors = <String>[];

    if (phoneNumber.isEmpty) errors.add('Phone number is required');

    return errors;
  }
}
