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
