// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

const _$UserTypeEnumMap = {
  UserType.taker: 'customer',
  UserType.provider: 'provider',
  UserType.admin: 'admin',
};

extension UserTypeExtension on UserType {
  /// Converts UserType enum to JSON value
  String toJson() => _$UserTypeEnumMap[this]!;

  /// Creates UserType enum from JSON value
  static UserType fromJson(String json) {
    switch (json) {
      case 'customer':
        return UserType.taker;
      case 'provider':
        return UserType.provider;
      case 'admin':
        return UserType.admin;
      default:
        throw ArgumentError.value(json, 'json', 'Invalid UserType value');
    }
  }
}

/// Helper methods for UserType serialization
class UserTypeHelper {
  static const Map<UserType, String> _valueMap = _$UserTypeEnumMap;

  /// Get all UserType values
  static List<UserType> get values => UserType.values;

  /// Get UserType from string value
  static UserType? fromString(String? value) {
    if (value == null) return null;
    return _valueMap.entries
        .where((entry) => entry.value == value)
        .map((entry) => entry.key)
        .firstOrNull;
  }

  /// Get string value from UserType
  static String? toStringValue(UserType? userType) {
    if (userType == null) return null;
    return _valueMap[userType];
  }

  /// Check if string is valid UserType value
  static bool isValid(String value) {
    return _valueMap.containsValue(value);
  }
}
