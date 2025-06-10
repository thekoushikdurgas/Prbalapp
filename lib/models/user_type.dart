import 'package:json_annotation/json_annotation.dart';

part 'user_type.g.dart';

@JsonEnum(valueField: 'value')
enum UserType {
  @JsonValue('customer')
  taker('customer'),

  @JsonValue('provider')
  provider('provider'),

  @JsonValue('admin')
  admin('admin');

  const UserType(this.value);

  final String value;

  /// Get display name for the user type
  String get displayName {
    switch (this) {
      case UserType.taker:
        return 'Customer';
      case UserType.provider:
        return 'Service Provider';
      case UserType.admin:
        return 'Administrator';
    }
  }

  /// Get icon for the user type
  String get icon {
    switch (this) {
      case UserType.taker:
        return '👤';
      case UserType.provider:
        return '🔧';
      case UserType.admin:
        return '👑';
    }
  }

  /// Create UserType from string value
  static UserType fromValue(String value) {
    switch (value.toLowerCase()) {
      case 'customer':
      case 'taker':
        return UserType.taker;
      case 'provider':
        return UserType.provider;
      case 'admin':
        return UserType.admin;
      default:
        throw ArgumentError('Invalid user type: $value');
    }
  }

  /// Convert to string for API calls
  @override
  String toString() => value;
}
