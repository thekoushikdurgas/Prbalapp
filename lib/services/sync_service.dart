import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';
import 'hive_service.dart';
import 'package:flutter/foundation.dart';

/// Sync metadata model
class SyncMetadata {
  final DateTime syncTimestamp;
  final DateTime? expiresAfter;

  const SyncMetadata({
    required this.syncTimestamp,
    this.expiresAfter,
  });

  factory SyncMetadata.fromJson(Map<String, dynamic> json) {
    return SyncMetadata(
      syncTimestamp: DateTime.parse(json['sync_timestamp'] as String),
      expiresAfter: json['expires_after'] != null
          ? DateTime.parse(json['expires_after'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sync_timestamp': syncTimestamp.toIso8601String(),
      if (expiresAfter != null)
        'expires_after': expiresAfter!.toIso8601String(),
    };
  }
}

/// User profile model for sync
class SyncUserProfile {
  final String id;
  final String username;
  final String? firstName;
  final String? lastName;
  final String email;
  final String userType;
  final String? phoneNumber;
  final String? profilePicture;
  final String? bio;
  final String? location;
  final bool isVerified;
  final double rating;
  final String balance;
  final DateTime dateJoined;
  final DateTime? lastLogin;

  const SyncUserProfile({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
    required this.email,
    required this.userType,
    this.phoneNumber,
    this.profilePicture,
    this.bio,
    this.location,
    this.isVerified = false,
    this.rating = 0.0,
    this.balance = '0.00',
    required this.dateJoined,
    this.lastLogin,
  });

  factory SyncUserProfile.fromJson(Map<String, dynamic> json) {
    return SyncUserProfile(
      id: json['id'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String,
      userType: json['user_type'] as String,
      phoneNumber: json['phone_number'] as String?,
      profilePicture: json['profile_picture'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      balance: json['balance'] as String? ?? '0.00',
      dateJoined: DateTime.parse(json['date_joined'] as String),
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'user_type': userType,
      'phone_number': phoneNumber,
      'profile_picture': profilePicture,
      'bio': bio,
      'location': location,
      'is_verified': isVerified,
      'rating': rating,
      'balance': balance,
      'date_joined': dateJoined.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }
}

/// Service model for sync
class SyncService {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String location;
  final String? image;
  final bool isActive;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncServiceProviderModel provider;
  final SyncServiceCategory category;

  const SyncService({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.currency = 'INR',
    required this.location,
    this.image,
    this.isActive = true,
    this.isFeatured = false,
    required this.createdAt,
    required this.updatedAt,
    required this.provider,
    required this.category,
  });

  factory SyncService.fromJson(Map<String, dynamic> json) {
    return SyncService(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'INR',
      location: json['location'] as String,
      image: json['image'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      provider: SyncServiceProviderModel.fromJson(
          json['provider'] as Map<String, dynamic>),
      category: SyncServiceCategory.fromJson(
          json['category'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'currency': currency,
      'location': location,
      'image': image,
      'is_active': isActive,
      'is_featured': isFeatured,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'provider': provider.toJson(),
      'category': category.toJson(),
    };
  }
}

/// Service provider model for sync
class SyncServiceProviderModel {
  final String id;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? profilePicture;
  final double rating;
  final bool isVerified;

  const SyncServiceProviderModel({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.rating = 0.0,
    this.isVerified = false,
  });

  factory SyncServiceProviderModel.fromJson(Map<String, dynamic> json) {
    return SyncServiceProviderModel(
      id: json['id'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      profilePicture: json['profile_picture'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isVerified: json['is_verified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'profile_picture': profilePicture,
      'rating': rating,
      'is_verified': isVerified,
    };
  }
}

/// Service category model for sync
class SyncServiceCategory {
  final String id;
  final String name;
  final String? description;
  final String? icon;

  const SyncServiceCategory({
    required this.id,
    required this.name,
    this.description,
    this.icon,
  });

  factory SyncServiceCategory.fromJson(Map<String, dynamic> json) {
    return SyncServiceCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
    };
  }
}

/// Services response model with sync metadata
class SyncServicesResponse {
  final List<SyncService> services;
  final SyncMetadata syncMetadata;

  const SyncServicesResponse({
    required this.services,
    required this.syncMetadata,
  });

  factory SyncServicesResponse.fromJson(Map<String, dynamic> json) {
    return SyncServicesResponse(
      services: (json['services'] as List)
          .map((item) => SyncService.fromJson(item as Map<String, dynamic>))
          .toList(),
      syncMetadata: SyncMetadata.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'services': services.map((service) => service.toJson()).toList(),
      ...syncMetadata.toJson(),
    };
  }
}

/// Offline bid model
class OfflineBid {
  final String clientTempId;
  final String service;
  final double amount;
  final String message;
  final String duration;
  final String currency;
  final DateTime? scheduledDateTime;

  const OfflineBid({
    required this.clientTempId,
    required this.service,
    required this.amount,
    required this.message,
    required this.duration,
    this.currency = 'INR',
    this.scheduledDateTime,
  });

  factory OfflineBid.fromJson(Map<String, dynamic> json) {
    return OfflineBid(
      clientTempId: json['client_temp_id'] as String,
      service: json['service'] as String,
      amount: (json['amount'] as num).toDouble(),
      message: json['message'] as String,
      duration: json['duration'] as String,
      currency: json['currency'] as String? ?? 'INR',
      scheduledDateTime: json['scheduled_date_time'] != null
          ? DateTime.parse(json['scheduled_date_time'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_temp_id': clientTempId,
      'service': service,
      'amount': amount,
      'message': message,
      'duration': duration,
      'currency': currency,
      if (scheduledDateTime != null)
        'scheduled_date_time': scheduledDateTime!.toIso8601String(),
    };
  }
}

/// Offline booking model
class OfflineBooking {
  final String clientTempId;
  final String service;
  final String provider;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final double amount;
  final String address;
  final String? requirements;

  const OfflineBooking({
    required this.clientTempId,
    required this.service,
    required this.provider,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.amount,
    required this.address,
    this.requirements,
  });

  factory OfflineBooking.fromJson(Map<String, dynamic> json) {
    return OfflineBooking(
      clientTempId: json['client_temp_id'] as String,
      service: json['service'] as String,
      provider: json['provider'] as String,
      bookingDate: DateTime.parse(json['booking_date'] as String),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      amount: (json['amount'] as num).toDouble(),
      address: json['address'] as String,
      requirements: json['requirements'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_temp_id': clientTempId,
      'service': service,
      'provider': provider,
      'booking_date': bookingDate.toIso8601String().split('T')[0],
      'start_time': startTime,
      'end_time': endTime,
      'amount': amount,
      'address': address,
      if (requirements != null) 'requirements': requirements,
    };
  }
}

/// Offline message model
class OfflineMessage {
  final String clientTempId;
  final String thread;
  final String content;
  final String messageType;

  const OfflineMessage({
    required this.clientTempId,
    required this.thread,
    required this.content,
    this.messageType = 'text',
  });

  factory OfflineMessage.fromJson(Map<String, dynamic> json) {
    return OfflineMessage(
      clientTempId: json['client_temp_id'] as String,
      thread: json['thread'] as String,
      content: json['content'] as String,
      messageType: json['message_type'] as String? ?? 'text',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_temp_id': clientTempId,
      'thread': thread,
      'content': content,
      'message_type': messageType,
    };
  }
}

/// Upload changes request model
class UploadChangesRequest {
  final DateTime timestamp;
  final List<OfflineBid>? bids;
  final List<OfflineBooking>? bookings;
  final List<OfflineMessage>? messages;

  const UploadChangesRequest({
    required this.timestamp,
    this.bids,
    this.bookings,
    this.messages,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      if (bids != null) 'bids': bids!.map((bid) => bid.toJson()).toList(),
      if (bookings != null)
        'bookings': bookings!.map((booking) => booking.toJson()).toList(),
      if (messages != null)
        'messages': messages!.map((message) => message.toJson()).toList(),
    };
  }
}

/// Processed item model for upload response
class ProcessedItem {
  final String clientTempId;
  final String serverId;
  final Map<String, dynamic> data;

  const ProcessedItem({
    required this.clientTempId,
    required this.serverId,
    required this.data,
  });

  factory ProcessedItem.fromJson(Map<String, dynamic> json) {
    return ProcessedItem(
      clientTempId: json['client_temp_id'] as String,
      serverId: json['server_id'] as String,
      data: json['data'] as Map<String, dynamic>,
    );
  }
}

/// Upload error model
class UploadError {
  final String clientTempId;
  final String error;
  final Map<String, dynamic>? details;

  const UploadError({
    required this.clientTempId,
    required this.error,
    this.details,
  });

  factory UploadError.fromJson(Map<String, dynamic> json) {
    return UploadError(
      clientTempId: json['client_temp_id'] as String,
      error: json['error'] as String,
      details: json['details'] as Map<String, dynamic>?,
    );
  }
}

/// Upload response model
class UploadChangesResponse {
  final bool success;
  final List<ProcessedItem> processedBids;
  final List<ProcessedItem> processedBookings;
  final List<ProcessedItem> processedMessages;
  final List<UploadError> errors;
  final DateTime syncTimestamp;

  const UploadChangesResponse({
    required this.success,
    required this.processedBids,
    required this.processedBookings,
    required this.processedMessages,
    required this.errors,
    required this.syncTimestamp,
  });

  factory UploadChangesResponse.fromJson(Map<String, dynamic> json) {
    final processed = json['processed'] as Map<String, dynamic>;

    return UploadChangesResponse(
      success: json['success'] as bool,
      processedBids: (processed['bids'] as List? ?? [])
          .map((item) => ProcessedItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      processedBookings: (processed['bookings'] as List? ?? [])
          .map((item) => ProcessedItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      processedMessages: (processed['messages'] as List? ?? [])
          .map((item) => ProcessedItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      errors: (processed['errors'] as List? ?? [])
          .map((item) => UploadError.fromJson(item as Map<String, dynamic>))
          .toList(),
      syncTimestamp: DateTime.parse(json['sync_timestamp'] as String),
    );
  }
}

/// Service filters for sync
class SyncServiceFilters {
  final String? category;
  final String? location;
  final double? maxPrice;
  final String? search;
  final String? ordering;
  final int? limit;

  const SyncServiceFilters({
    this.category,
    this.location,
    this.maxPrice,
    this.search,
    this.ordering,
    this.limit,
  });

  Map<String, String> toQueryParameters() {
    final params = <String, String>{};

    if (category != null) params['category'] = category!;
    if (location != null) params['location'] = location!;
    if (maxPrice != null) params['max_price'] = maxPrice.toString();
    if (search != null) params['search'] = search!;
    if (ordering != null) params['ordering'] = ordering!;
    if (limit != null) params['limit'] = limit.toString();

    return params;
  }
}

// VERIFICATION MODELS

/// Verification status enum
enum VerificationStatus {
  unverified,
  pending,
  inProgress,
  verified,
  rejected,
  expired;

  String get value {
    switch (this) {
      case VerificationStatus.unverified:
        return 'unverified';
      case VerificationStatus.pending:
        return 'pending';
      case VerificationStatus.inProgress:
        return 'in_progress';
      case VerificationStatus.verified:
        return 'verified';
      case VerificationStatus.rejected:
        return 'rejected';
      case VerificationStatus.expired:
        return 'expired';
    }
  }

  static VerificationStatus fromString(String value) {
    switch (value) {
      case 'unverified':
        return VerificationStatus.unverified;
      case 'pending':
        return VerificationStatus.pending;
      case 'in_progress':
        return VerificationStatus.inProgress;
      case 'verified':
        return VerificationStatus.verified;
      case 'rejected':
        return VerificationStatus.rejected;
      case 'expired':
        return VerificationStatus.expired;
      default:
        return VerificationStatus.unverified;
    }
  }
}

/// Verification type enum
enum VerificationType {
  identity,
  address,
  professional,
  educational,
  background,
  business,
  banking,
  other;

  String get value {
    switch (this) {
      case VerificationType.identity:
        return 'identity';
      case VerificationType.address:
        return 'address';
      case VerificationType.professional:
        return 'professional';
      case VerificationType.educational:
        return 'educational';
      case VerificationType.background:
        return 'background';
      case VerificationType.business:
        return 'business';
      case VerificationType.banking:
        return 'banking';
      case VerificationType.other:
        return 'other';
    }
  }

  static VerificationType fromString(String value) {
    switch (value) {
      case 'identity':
        return VerificationType.identity;
      case 'address':
        return VerificationType.address;
      case 'professional':
        return VerificationType.professional;
      case 'educational':
        return VerificationType.educational;
      case 'background':
        return VerificationType.background;
      case 'business':
        return VerificationType.business;
      case 'banking':
        return VerificationType.banking;
      case 'other':
        return VerificationType.other;
      default:
        return VerificationType.other;
    }
  }
}

/// Document type enum
enum DocumentType {
  passport,
  nationalId,
  driversLicense,
  utilityBill,
  bankStatement,
  rentalAgreement,
  professionalCert,
  businessLicense,
  degree,
  transcript,
  other;

  String get value {
    switch (this) {
      case DocumentType.passport:
        return 'passport';
      case DocumentType.nationalId:
        return 'national_id';
      case DocumentType.driversLicense:
        return 'drivers_license';
      case DocumentType.utilityBill:
        return 'utility_bill';
      case DocumentType.bankStatement:
        return 'bank_statement';
      case DocumentType.rentalAgreement:
        return 'rental_agreement';
      case DocumentType.professionalCert:
        return 'professional_cert';
      case DocumentType.businessLicense:
        return 'business_license';
      case DocumentType.degree:
        return 'degree';
      case DocumentType.transcript:
        return 'transcript';
      case DocumentType.other:
        return 'other';
    }
  }

  static DocumentType fromString(String value) {
    switch (value) {
      case 'passport':
        return DocumentType.passport;
      case 'national_id':
        return DocumentType.nationalId;
      case 'drivers_license':
        return DocumentType.driversLicense;
      case 'utility_bill':
        return DocumentType.utilityBill;
      case 'bank_statement':
        return DocumentType.bankStatement;
      case 'rental_agreement':
        return DocumentType.rentalAgreement;
      case 'professional_cert':
        return DocumentType.professionalCert;
      case 'business_license':
        return DocumentType.businessLicense;
      case 'degree':
        return DocumentType.degree;
      case 'transcript':
        return DocumentType.transcript;
      case 'other':
        return DocumentType.other;
      default:
        return DocumentType.other;
    }
  }
}

/// Verification model
class Verification {
  final String id;
  final String userId;
  final VerificationType verificationType;
  final DocumentType documentType;
  final VerificationStatus status;
  final String? documentFile;
  final String? documentBackFile;
  final String? documentNumber;
  final String? verificationNotes;
  final String? rejectionReason;
  final String? externalReferenceId;
  final String? verifiedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? verifiedAt;

  const Verification({
    required this.id,
    required this.userId,
    required this.verificationType,
    required this.documentType,
    required this.status,
    this.documentFile,
    this.documentBackFile,
    this.documentNumber,
    this.verificationNotes,
    this.rejectionReason,
    this.externalReferenceId,
    this.verifiedBy,
    required this.createdAt,
    required this.updatedAt,
    this.verifiedAt,
  });

  factory Verification.fromJson(Map<String, dynamic> json) {
    return Verification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      verificationType:
          VerificationType.fromString(json['verification_type'] as String),
      documentType: DocumentType.fromString(json['document_type'] as String),
      status: VerificationStatus.fromString(json['status'] as String),
      documentFile: json['document_file'] as String?,
      documentBackFile: json['document_back_file'] as String?,
      documentNumber: json['document_number'] as String?,
      verificationNotes: json['verification_notes'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      externalReferenceId: json['external_reference_id'] as String?,
      verifiedBy: json['verified_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'verification_type': verificationType.value,
      'document_type': documentType.value,
      'status': status.value,
      'document_file': documentFile,
      'document_back_file': documentBackFile,
      'document_number': documentNumber,
      'verification_notes': verificationNotes,
      'rejection_reason': rejectionReason,
      'external_reference_id': externalReferenceId,
      'verified_by': verifiedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'verified_at': verifiedAt?.toIso8601String(),
    };
  }
}

/// Create verification request model
class CreateVerificationRequest {
  final VerificationType verificationType;
  final DocumentType documentType;
  final String documentFile;
  final String? documentBackFile;
  final String? documentNumber;

  const CreateVerificationRequest({
    required this.verificationType,
    required this.documentType,
    required this.documentFile,
    this.documentBackFile,
    this.documentNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'verification_type': verificationType.value,
      'document_type': documentType.value,
      'document_file': documentFile,
      if (documentBackFile != null) 'document_back_file': documentBackFile,
      if (documentNumber != null) 'document_number': documentNumber,
    };
  }
}

/// Update verification request model
class UpdateVerificationRequest {
  final VerificationStatus? status;
  final String? verificationNotes;
  final String? rejectionReason;
  final String? externalReferenceId;

  const UpdateVerificationRequest({
    this.status,
    this.verificationNotes,
    this.rejectionReason,
    this.externalReferenceId,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (status != null) json['status'] = status!.value;
    if (verificationNotes != null) {
      json['verification_notes'] = verificationNotes;
    }
    if (rejectionReason != null) json['rejection_reason'] = rejectionReason;
    if (externalReferenceId != null) {
      json['external_reference_id'] = externalReferenceId;
    }
    return json;
  }
}

/// Verification action request model
class VerificationActionRequest {
  final String? verificationNotes;
  final String? rejectionReason;

  const VerificationActionRequest({
    this.verificationNotes,
    this.rejectionReason,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (verificationNotes != null) {
      json['verification_notes'] = verificationNotes;
    }
    if (rejectionReason != null) json['rejection_reason'] = rejectionReason;
    return json;
  }
}

/// Verification filters for querying
class VerificationFilters {
  final VerificationType? verificationType;
  final DocumentType? documentType;
  final VerificationStatus? status;
  final String? ordering;
  final int? limit;
  final int? offset;

  const VerificationFilters({
    this.verificationType,
    this.documentType,
    this.status,
    this.ordering,
    this.limit,
    this.offset,
  });

  Map<String, String> toQueryParameters() {
    final params = <String, String>{};

    if (verificationType != null) {
      params['verification_type'] = verificationType!.value;
    }
    if (documentType != null) params['document_type'] = documentType!.value;
    if (status != null) params['status'] = status!.value;
    if (ordering != null) params['ordering'] = ordering!;
    if (limit != null) params['limit'] = limit.toString();
    if (offset != null) params['offset'] = offset.toString();

    return params;
  }
}

/// Verification status summary response model
class VerificationStatusSummary {
  final Map<String, int> statusCounts;
  final Map<String, int> typeCounts;
  final int totalVerifications;

  const VerificationStatusSummary({
    required this.statusCounts,
    required this.typeCounts,
    required this.totalVerifications,
  });

  factory VerificationStatusSummary.fromJson(Map<String, dynamic> json) {
    return VerificationStatusSummary(
      statusCounts: Map<String, int>.from(json['status_counts'] as Map),
      typeCounts: Map<String, int>.from(json['type_counts'] as Map),
      totalVerifications: json['total_verifications'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_counts': statusCounts,
      'type_counts': typeCounts,
      'total_verifications': totalVerifications,
    };
  }
}

/// Verification list response model
class VerificationListResponse {
  final List<Verification> results;
  final int count;
  final String? next;
  final String? previous;

  const VerificationListResponse({
    required this.results,
    required this.count,
    this.next,
    this.previous,
  });

  factory VerificationListResponse.fromJson(Map<String, dynamic> json) {
    return VerificationListResponse(
      results: (json['results'] as List)
          .map((item) => Verification.fromJson(item as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((verification) => verification.toJson()).toList(),
      'count': count,
      'next': next,
      'previous': previous,
    };
  }
}

/// Sync Service for managing offline functionality and data synchronization
class SyncServiceProvider extends StateNotifier<List<SyncService>?> {
  final ApiService _apiService;

  SyncServiceProvider(this._apiService) : super(null);

  /// Current synced services
  List<SyncService>? get syncedServices => state;

  /// Check if services are synced
  bool get hasServices => state != null && state!.isNotEmpty;

  // Profile Sync Methods

  /// Download user profile for offline use
  /// GET /api/v1/sync/profile/
  Future<ApiResponse<SyncUserProfile>> downloadUserProfile() async {
    try {
      if (kDebugMode) {
        debugPrint('SyncService: Downloading user profile for offline use');
      }

      final response = await _apiService.get<SyncUserProfile>(
        '/sync/profile/',
        fromJson: (data) => SyncUserProfile.fromJson(data),
      );

      if (response.success && response.data != null) {
        // Cache profile data locally
        await _cacheUserProfile(response.data!);

        if (kDebugMode) {
          debugPrint(
              'SyncService: User profile downloaded and cached successfully');
        }
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error downloading user profile - $e');
      }
      return ApiResponse.error(
          'Failed to download user profile: ${e.toString()}');
    }
  }

  // Service Sync Methods

  /// Download all services for offline browsing
  /// GET /api/v1/sync/services/
  Future<ApiResponse<SyncServicesResponse>> downloadServices({
    SyncServiceFilters? filters,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('SyncService: Downloading all services for offline use');
      }

      final queryParams = filters?.toQueryParameters() ?? {};

      final response = await _apiService.get<SyncServicesResponse>(
        '/sync/services/',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (data) => SyncServicesResponse.fromJson(data),
      );

      if (response.success && response.data != null) {
        // Update state with synced services
        state = response.data!.services;

        // Cache services data locally
        await _cacheServices(response.data!);

        if (kDebugMode) {
          debugPrint(
              'SyncService: ${response.data!.services.length} services downloaded and cached');
        }
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error downloading services - $e');
      }
      return ApiResponse.error('Failed to download services: ${e.toString()}');
    }
  }

  /// Download services by category
  /// GET /api/v1/sync/services/?category={categoryId}
  Future<ApiResponse<SyncServicesResponse>> downloadServicesByCategory(
    String categoryId, {
    String ordering = '-created_at',
  }) async {
    if (kDebugMode) {
      debugPrint('SyncService: Downloading services for category: $categoryId');
    }

    return downloadServices(
      filters: SyncServiceFilters(
        category: categoryId,
        ordering: ordering,
      ),
    );
  }

  /// Download services by location
  /// GET /api/v1/sync/services/?location={location}
  Future<ApiResponse<SyncServicesResponse>> downloadServicesByLocation(
    String location, {
    String ordering = 'price',
  }) async {
    if (kDebugMode) {
      debugPrint('SyncService: Downloading services for location: $location');
    }

    return downloadServices(
      filters: SyncServiceFilters(
        location: location,
        ordering: ordering,
      ),
    );
  }

  /// Download limited services for fast sync
  /// GET /api/v1/sync/services/?limit={limit}
  Future<ApiResponse<SyncServicesResponse>> downloadLimitedServices({
    int limit = 50,
    String ordering = '-created_at',
  }) async {
    if (kDebugMode) {
      debugPrint('SyncService: Downloading limited services (limit: $limit)');
    }

    return downloadServices(
      filters: SyncServiceFilters(
        limit: limit,
        ordering: ordering,
      ),
    );
  }

  /// Download services with advanced filters
  /// GET /api/v1/sync/services/ with multiple query parameters
  Future<ApiResponse<SyncServicesResponse>> downloadServicesWithFilters({
    String? category,
    String? location,
    double? maxPrice,
    String? search,
    String? ordering,
    int? limit,
  }) async {
    if (kDebugMode) {
      debugPrint('SyncService: Downloading services with custom filters');
    }

    return downloadServices(
      filters: SyncServiceFilters(
        category: category,
        location: location,
        maxPrice: maxPrice,
        search: search,
        ordering: ordering,
        limit: limit,
      ),
    );
  }

  /// Download services with advanced filters (alias for downloadServicesWithFilters)
  Future<ApiResponse<SyncServicesResponse>>
      downloadServicesWithAdvancedFilters({
    String? category,
    String? location,
    double? maxPrice,
    String? search,
    String? ordering,
    int? limit,
  }) async {
    return downloadServicesWithFilters(
      category: category,
      location: location,
      maxPrice: maxPrice,
      search: search,
      ordering: ordering,
      limit: limit,
    );
  }

  // Upload Methods

  /// Upload all offline changes to backend
  /// POST /api/v1/sync/upload/
  Future<ApiResponse<UploadChangesResponse>> uploadOfflineChanges(
    UploadChangesRequest request,
  ) async {
    try {
      if (kDebugMode) {
        debugPrint('SyncService: Uploading offline changes');
        debugPrint('Bids: ${request.bids?.length ?? 0}');
        debugPrint('Bookings: ${request.bookings?.length ?? 0}');
        debugPrint('Messages: ${request.messages?.length ?? 0}');
      }

      final response = await _apiService.post<UploadChangesResponse>(
        '/sync/upload/',
        body: request.toJson(),
        fromJson: (data) => UploadChangesResponse.fromJson(data),
      );

      if (response.success && response.data != null) {
        // Clear uploaded offline data from local storage
        await _clearUploadedOfflineData(response.data!);

        if (kDebugMode) {
          debugPrint('SyncService: Offline changes uploaded successfully');
          debugPrint('Processed bids: ${response.data!.processedBids.length}');
          debugPrint(
              'Processed bookings: ${response.data!.processedBookings.length}');
          debugPrint(
              'Processed messages: ${response.data!.processedMessages.length}');
          debugPrint('Errors: ${response.data!.errors.length}');
        }
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error uploading offline changes - $e');
      }
      return ApiResponse.error(
          'Failed to upload offline changes: ${e.toString()}');
    }
  }

  /// Upload only bids created offline
  /// POST /api/v1/sync/upload/ (bids only)
  Future<ApiResponse<UploadChangesResponse>> uploadOfflineBids(
    List<OfflineBid> bids,
  ) async {
    if (kDebugMode) {
      debugPrint('SyncService: Uploading ${bids.length} offline bids');
    }

    return uploadOfflineChanges(
      UploadChangesRequest(
        timestamp: DateTime.now(),
        bids: bids,
      ),
    );
  }

  /// Upload only bookings created offline
  /// POST /api/v1/sync/upload/ (bookings only)
  Future<ApiResponse<UploadChangesResponse>> uploadOfflineBookings(
    List<OfflineBooking> bookings,
  ) async {
    if (kDebugMode) {
      debugPrint('SyncService: Uploading ${bookings.length} offline bookings');
    }

    return uploadOfflineChanges(
      UploadChangesRequest(
        timestamp: DateTime.now(),
        bookings: bookings,
      ),
    );
  }

  /// Upload only messages sent offline
  /// POST /api/v1/sync/upload/ (messages only)
  Future<ApiResponse<UploadChangesResponse>> uploadOfflineMessages(
    List<OfflineMessage> messages,
  ) async {
    if (kDebugMode) {
      debugPrint('SyncService: Uploading ${messages.length} offline messages');
    }

    return uploadOfflineChanges(
      UploadChangesRequest(
        timestamp: DateTime.now(),
        messages: messages,
      ),
    );
  }

  /// Upload mixed offline data from Hive storage
  /// Automatically collects all pending offline data and uploads it
  Future<ApiResponse<UploadChangesResponse>>
      uploadAllPendingOfflineData() async {
    try {
      if (kDebugMode) {
        debugPrint(
            'SyncService: Collecting all pending offline data for upload');
      }

      // Get all offline data from Hive
      final offlineBids = HiveService.getOfflineBids();
      final offlineBookings = HiveService.getOfflineBookings();
      final offlineMessages = HiveService.getOfflineMessages();

      if (offlineBids.isEmpty &&
          offlineBookings.isEmpty &&
          offlineMessages.isEmpty) {
        if (kDebugMode) {
          debugPrint('SyncService: No offline data to upload');
        }
        return ApiResponse.success(
          UploadChangesResponse(
            success: true,
            processedBids: [],
            processedBookings: [],
            processedMessages: [],
            errors: [],
            syncTimestamp: DateTime.now(),
          ),
          message: 'No offline data to upload',
        );
      }

      // Create upload request
      final request = UploadChangesRequest(
        timestamp: DateTime.now(),
        bids: offlineBids.entries
            .map((e) => OfflineBid.fromJson(e.value))
            .toList(),
        bookings: offlineBookings.entries
            .map((e) => OfflineBooking.fromJson(e.value))
            .toList(),
        messages: offlineMessages.entries
            .map((e) => OfflineMessage.fromJson(e.value))
            .toList(),
      );

      return await uploadOfflineChanges(request);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error collecting pending offline data - $e');
      }
      return ApiResponse.error(
          'Failed to collect pending offline data: ${e.toString()}');
    }
  }

  // Local Storage Helper Methods

  /// Cache user profile locally
  Future<void> _cacheUserProfile(SyncUserProfile profile) async {
    try {
      await HiveService.saveUserProfile(profile.toJson());
      if (kDebugMode) {
        debugPrint('SyncService: User profile cached locally');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error caching user profile - $e');
      }
    }
  }

  /// Cache services locally
  Future<void> _cacheServices(SyncServicesResponse servicesResponse) async {
    try {
      await HiveService.saveSyncedServices(servicesResponse.toJson());
      if (kDebugMode) {
        debugPrint('SyncService: Services cached locally');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error caching services - $e');
      }
    }
  }

  /// Clear uploaded offline data from local storage
  Future<void> _clearUploadedOfflineData(UploadChangesResponse response) async {
    try {
      // Clear successfully processed items
      for (final bid in response.processedBids) {
        await HiveService.removeOfflineBid(bid.clientTempId);
      }

      for (final booking in response.processedBookings) {
        await HiveService.removeOfflineBooking(booking.clientTempId);
      }

      for (final message in response.processedMessages) {
        await HiveService.removeOfflineMessage(message.clientTempId);
      }

      if (kDebugMode) {
        debugPrint(
            'SyncService: Uploaded offline data cleared from local storage');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error clearing uploaded data - $e');
      }
    }
  }

  /// Load cached services from local storage
  Future<void> loadCachedServices() async {
    try {
      final cachedData = HiveService.getSyncedServices();
      if (cachedData != null) {
        final servicesResponse = SyncServicesResponse.fromJson(cachedData);
        state = servicesResponse.services;

        if (kDebugMode) {
          debugPrint(
              'SyncService: Loaded ${servicesResponse.services.length} cached services');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error loading cached services - $e');
      }
    }
  }

  /// Get cached user profile
  Future<SyncUserProfile?> getCachedUserProfile() async {
    try {
      final cachedData = HiveService.getUserProfile();
      if (cachedData != null) {
        return SyncUserProfile.fromJson(cachedData);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error getting cached user profile - $e');
      }
    }
    return null;
  }

  /// Check if sync data is expired
  bool isSyncDataExpired(SyncMetadata metadata) {
    if (metadata.expiresAfter == null) return false;
    return DateTime.now().isAfter(metadata.expiresAfter!);
  }

  /// Clear all cached sync data
  Future<void> clearAllSyncData() async {
    try {
      await HiveService.clearSyncData();
      state = null;

      if (kDebugMode) {
        debugPrint('SyncService: All sync data cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error clearing sync data - $e');
      }
    }
  }

  /// Initialize sync service
  Future<void> initialize() async {
    await loadCachedServices();
  }

  // VERIFICATION METHODS

  /// List verification requests
  /// GET /api/v1/verifications/
  Future<ApiResponse<VerificationListResponse>> getVerifications({
    VerificationFilters? filters,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('SyncService: Fetching verification requests');
      }

      final queryParams = filters?.toQueryParameters() ?? {};

      final response = await _apiService.get<VerificationListResponse>(
        '/verifications/',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (data) => VerificationListResponse.fromJson(data),
      );

      if (response.success && response.data != null) {
        if (kDebugMode) {
          debugPrint(
              'SyncService: Fetched ${response.data!.results.length} verification requests');
        }
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error fetching verifications - $e');
      }
      return ApiResponse.error(
          'Failed to fetch verifications: ${e.toString()}');
    }
  }

  /// Create a new verification request
  /// POST /api/v1/verifications/
  Future<ApiResponse<Verification>> createVerification(
    CreateVerificationRequest request,
  ) async {
    try {
      if (kDebugMode) {
        debugPrint('SyncService: Creating verification request');
        debugPrint('Type: ${request.verificationType.value}');
        debugPrint('Document Type: ${request.documentType.value}');
      }

      final response = await _apiService.post<Verification>(
        '/verifications/',
        body: request.toJson(),
        fromJson: (data) => Verification.fromJson(data),
      );

      if (response.success && response.data != null) {
        if (kDebugMode) {
          debugPrint(
              'SyncService: Verification request created successfully with ID: ${response.data!.id}');
        }
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error creating verification - $e');
      }
      return ApiResponse.error(
          'Failed to create verification: ${e.toString()}');
    }
  }

  /// Get verification details by ID
  /// GET /api/v1/verifications/{id}/
  Future<ApiResponse<Verification>> getVerificationById(String id) async {
    try {
      if (kDebugMode) {
        debugPrint('SyncService: Fetching verification details for ID: $id');
      }

      final response = await _apiService.get<Verification>(
        '/verifications/$id/',
        fromJson: (data) => Verification.fromJson(data),
      );

      if (response.success && response.data != null) {
        if (kDebugMode) {
          debugPrint(
              'SyncService: Verification details fetched - Status: ${response.data!.status.value}');
        }
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error fetching verification details - $e');
      }
      return ApiResponse.error(
          'Failed to fetch verification details: ${e.toString()}');
    }
  }

  /// Update verification (partial update)
  /// PATCH /api/v1/verifications/{id}/
  Future<ApiResponse<Verification>> updateVerificationPartial(
    String id,
    UpdateVerificationRequest request,
  ) async {
    try {
      if (kDebugMode) {
        debugPrint('SyncService: Updating verification (partial) with ID: $id');
      }

      final response = await _apiService.patch<Verification>(
        '/verifications/$id/',
        body: request.toJson(),
        fromJson: (data) => Verification.fromJson(data),
      );

      if (response.success && response.data != null) {
        if (kDebugMode) {
          debugPrint('SyncService: Verification updated successfully');
        }
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error updating verification - $e');
      }
      return ApiResponse.error(
          'Failed to update verification: ${e.toString()}');
    }
  }

  /// Update verification (full update)
  /// PUT /api/v1/verifications/{id}/
  Future<ApiResponse<Verification>> updateVerificationFull(
    String id,
    UpdateVerificationRequest request,
  ) async {
    try {
      if (kDebugMode) {
        debugPrint('SyncService: Updating verification (full) with ID: $id');
      }

      final response = await _apiService.put<Verification>(
        '/verifications/$id/',
        body: request.toJson(),
        fromJson: (data) => Verification.fromJson(data),
      );

      if (response.success && response.data != null) {
        if (kDebugMode) {
          debugPrint('SyncService: Verification updated successfully');
        }
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error updating verification - $e');
      }
      return ApiResponse.error(
          'Failed to update verification: ${e.toString()}');
    }
  }

  /// Delete verification
  /// DELETE /api/v1/verifications/{id}/
  Future<ApiResponse<void>> deleteVerification(String id) async {
    try {
      if (kDebugMode) {
        debugPrint('SyncService: Deleting verification with ID: $id');
      }

      final response = await _apiService.delete<void>(
        '/verifications/$id/',
      );

      if (response.success) {
        if (kDebugMode) {
          debugPrint('SyncService: Verification deleted successfully');
        }
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error deleting verification - $e');
      }
      return ApiResponse.error(
          'Failed to delete verification: ${e.toString()}');
    }
  }

  /// Cancel verification
  /// POST /api/v1/verifications/{id}/cancel/
  Future<ApiResponse<Verification>> cancelVerification(String id) async {
    try {
      if (kDebugMode) {
        debugPrint('SyncService: Cancelling verification with ID: $id');
      }

      final response = await _apiService.post<Verification>(
        '/verifications/$id/cancel/',
        fromJson: (data) => Verification.fromJson(data),
      );

      if (response.success && response.data != null) {
        if (kDebugMode) {
          debugPrint('SyncService: Verification cancelled successfully');
        }
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error cancelling verification - $e');
      }
      return ApiResponse.error(
          'Failed to cancel verification: ${e.toString()}');
    }
  }

  /// Mark verification as in progress (Admin only)
  /// POST /api/v1/verifications/{id}/mark_in_progress/
  Future<ApiResponse<Verification>> markVerificationInProgress(
    String id, {
    String? notes,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint(
            'SyncService: Marking verification in progress with ID: $id');
      }

      final request = VerificationActionRequest(verificationNotes: notes);

      final response = await _apiService.post<Verification>(
        '/verifications/$id/mark_in_progress/',
        body: request.toJson(),
        fromJson: (data) => Verification.fromJson(data),
      );

      if (response.success && response.data != null) {
        if (kDebugMode) {
          debugPrint('SyncService: Verification marked as in progress');
        }
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error marking verification in progress - $e');
      }
      return ApiResponse.error(
          'Failed to mark verification in progress: ${e.toString()}');
    }
  }

  /// Mark verification as verified (Admin only)
  /// POST /api/v1/verifications/{id}/mark_verified/
  Future<ApiResponse<Verification>> markVerificationVerified(
    String id, {
    String? notes,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint(
            'SyncService: Marking verification as verified with ID: $id');
      }

      final request = VerificationActionRequest(verificationNotes: notes);

      final response = await _apiService.post<Verification>(
        '/verifications/$id/mark_verified/',
        body: request.toJson(),
        fromJson: (data) => Verification.fromJson(data),
      );

      if (response.success && response.data != null) {
        if (kDebugMode) {
          debugPrint('SyncService: Verification marked as verified');
        }
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error marking verification as verified - $e');
      }
      return ApiResponse.error(
          'Failed to mark verification as verified: ${e.toString()}');
    }
  }

  /// Mark verification as rejected (Admin only)
  /// POST /api/v1/verifications/{id}/mark_rejected/
  Future<ApiResponse<Verification>> markVerificationRejected(
    String id, {
    required String rejectionReason,
    String? notes,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint(
            'SyncService: Marking verification as rejected with ID: $id');
        debugPrint('Reason: $rejectionReason');
      }

      final request = VerificationActionRequest(
        rejectionReason: rejectionReason,
        verificationNotes: notes,
      );

      final response = await _apiService.post<Verification>(
        '/verifications/$id/mark_rejected/',
        body: request.toJson(),
        fromJson: (data) => Verification.fromJson(data),
      );

      if (response.success && response.data != null) {
        if (kDebugMode) {
          debugPrint('SyncService: Verification marked as rejected');
        }
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error marking verification as rejected - $e');
      }
      return ApiResponse.error(
          'Failed to mark verification as rejected: ${e.toString()}');
    }
  }

  /// Get verification status summary (Admin only)
  /// GET /api/v1/verifications/status_summary/
  Future<ApiResponse<VerificationStatusSummary>>
      getVerificationStatusSummary() async {
    try {
      if (kDebugMode) {
        debugPrint('SyncService: Fetching verification status summary');
      }

      final response = await _apiService.get<VerificationStatusSummary>(
        '/verifications/status_summary/',
        fromJson: (data) => VerificationStatusSummary.fromJson(data),
      );

      if (response.success && response.data != null) {
        if (kDebugMode) {
          debugPrint(
              'SyncService: Status summary fetched - Total: ${response.data!.totalVerifications}');
        }
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error fetching status summary - $e');
      }
      return ApiResponse.error(
          'Failed to fetch status summary: ${e.toString()}');
    }
  }

  // Convenience methods for specific verification queries

  /// Get pending verifications (Admin)
  Future<ApiResponse<VerificationListResponse>> getPendingVerifications({
    int? limit,
    int? offset,
  }) async {
    if (kDebugMode) {
      debugPrint('SyncService: Fetching pending verifications');
    }

    return getVerifications(
      filters: VerificationFilters(
        status: VerificationStatus.pending,
        ordering: 'created_at',
        limit: limit,
        offset: offset,
      ),
    );
  }

  /// Get in-progress verifications (Admin)
  Future<ApiResponse<VerificationListResponse>> getInProgressVerifications({
    int? limit,
    int? offset,
  }) async {
    if (kDebugMode) {
      debugPrint('SyncService: Fetching in-progress verifications');
    }

    return getVerifications(
      filters: VerificationFilters(
        status: VerificationStatus.inProgress,
        ordering: '-updated_at',
        limit: limit,
        offset: offset,
      ),
    );
  }

  /// Get user's own verification status
  Future<ApiResponse<VerificationListResponse>> getMyVerificationStatus({
    int? limit,
    int? offset,
  }) async {
    if (kDebugMode) {
      debugPrint('SyncService: Fetching user verification status');
    }

    return getVerifications(
      filters: VerificationFilters(
        ordering: '-created_at',
        limit: limit,
        offset: offset,
      ),
    );
  }

  /// Get identity verifications only
  Future<ApiResponse<VerificationListResponse>> getIdentityVerifications({
    int? limit,
    int? offset,
  }) async {
    if (kDebugMode) {
      debugPrint('SyncService: Fetching identity verifications');
    }

    return getVerifications(
      filters: VerificationFilters(
        verificationType: VerificationType.identity,
        ordering: '-created_at',
        limit: limit,
        offset: offset,
      ),
    );
  }

  /// Get verified documents
  Future<ApiResponse<VerificationListResponse>> getVerifiedDocuments({
    int? limit,
    int? offset,
  }) async {
    if (kDebugMode) {
      debugPrint('SyncService: Fetching verified documents');
    }

    return getVerifications(
      filters: VerificationFilters(
        status: VerificationStatus.verified,
        ordering: '-verified_at',
        limit: limit,
        offset: offset,
      ),
    );
  }

  /// Get verifications by type
  Future<ApiResponse<VerificationListResponse>> getVerificationsByType(
    VerificationType type, {
    int? limit,
    int? offset,
  }) async {
    if (kDebugMode) {
      debugPrint('SyncService: Fetching verifications by type: ${type.value}');
    }

    return getVerifications(
      filters: VerificationFilters(
        verificationType: type,
        ordering: '-created_at',
        limit: limit,
        offset: offset,
      ),
    );
  }

  /// Get verifications by status
  Future<ApiResponse<VerificationListResponse>> getVerificationsByStatus(
    VerificationStatus status, {
    int? limit,
    int? offset,
  }) async {
    if (kDebugMode) {
      debugPrint(
          'SyncService: Fetching verifications by status: ${status.value}');
    }

    return getVerifications(
      filters: VerificationFilters(
        status: status,
        ordering: '-updated_at',
        limit: limit,
        offset: offset,
      ),
    );
  }

  /// Get verifications by document type
  Future<ApiResponse<VerificationListResponse>> getVerificationsByDocumentType(
    DocumentType documentType, {
    int? limit,
    int? offset,
  }) async {
    if (kDebugMode) {
      debugPrint(
          'SyncService: Fetching verifications by document type: ${documentType.value}');
    }

    return getVerifications(
      filters: VerificationFilters(
        documentType: documentType,
        ordering: '-created_at',
        limit: limit,
        offset: offset,
      ),
    );
  }

  /// Helper method to create identity verification
  Future<ApiResponse<Verification>> createIdentityVerification({
    required DocumentType documentType,
    required String documentFile,
    String? documentBackFile,
    String? documentNumber,
  }) async {
    if (kDebugMode) {
      debugPrint('SyncService: Creating identity verification');
    }

    return createVerification(
      CreateVerificationRequest(
        verificationType: VerificationType.identity,
        documentType: documentType,
        documentFile: documentFile,
        documentBackFile: documentBackFile,
        documentNumber: documentNumber,
      ),
    );
  }

  /// Helper method to create address verification
  Future<ApiResponse<Verification>> createAddressVerification({
    required DocumentType documentType,
    required String documentFile,
    String? documentNumber,
  }) async {
    if (kDebugMode) {
      debugPrint('SyncService: Creating address verification');
    }

    return createVerification(
      CreateVerificationRequest(
        verificationType: VerificationType.address,
        documentType: documentType,
        documentFile: documentFile,
        documentNumber: documentNumber,
      ),
    );
  }

  /// Helper method to create professional verification
  Future<ApiResponse<Verification>> createProfessionalVerification({
    required DocumentType documentType,
    required String documentFile,
    String? documentBackFile,
    String? documentNumber,
  }) async {
    if (kDebugMode) {
      debugPrint('SyncService: Creating professional verification');
    }

    return createVerification(
      CreateVerificationRequest(
        verificationType: VerificationType.professional,
        documentType: documentType,
        documentFile: documentFile,
        documentBackFile: documentBackFile,
        documentNumber: documentNumber,
      ),
    );
  }

  // Sync Status and Management Methods

  /// Get sync service status information
  Map<String, dynamic> getSyncStatus() {
    final offlineCounts = HiveService.getOfflineDataCounts();
    final hasPendingData = HiveService.hasPendingOfflineData();

    return {
      'has_synced_services': hasServices,
      'synced_services_count': state?.length ?? 0,
      'offline_data_counts': offlineCounts,
      'has_pending_data': hasPendingData,
      'storage_healthy': HiveService.isStorageHealthy(),
      'total_pending_items':
          offlineCounts.values.fold(0, (sum, count) => sum + count),
      'last_sync_time': DateTime.now().toIso8601String(),
    };
  }

  /// Check if network is available and sync if needed
  Future<void> syncOnConnectivityRestore() async {
    try {
      if (kDebugMode) {
        debugPrint(
            'SyncService: Network connectivity restored, checking for pending data');
      }

      // Upload any pending offline data first
      if (HiveService.hasPendingOfflineData()) {
        await uploadAllPendingOfflineData();
      }

      // Refresh cached services if they're old (older than 1 hour)
      final cachedData = HiveService.getSyncedServices();
      if (cachedData != null) {
        final metadata = SyncMetadata.fromJson(cachedData);
        final hoursSinceSync =
            DateTime.now().difference(metadata.syncTimestamp).inHours;

        if (hoursSinceSync > 1) {
          if (kDebugMode) {
            debugPrint(
                'SyncService: Cached data is $hoursSinceSync hours old, refreshing...');
          }
          await downloadLimitedServices(limit: 30);
        }
      } else {
        // No cached data, perform initial sync
        if (kDebugMode) {
          debugPrint(
              'SyncService: No cached data found, performing initial sync...');
        }
        await downloadLimitedServices(limit: 30);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error during connectivity restore sync - $e');
      }
    }
  }

  /// Perform full sync (profile + services)
  Future<Map<String, dynamic>> performFullSync({
    int serviceLimit = 100,
    bool includeProfile = true,
  }) async {
    final results = <String, dynamic>{
      'profile_sync': {'success': false, 'message': ''},
      'services_sync': {'success': false, 'message': ''},
      'upload_sync': {'success': false, 'message': ''},
      'overall_success': false,
    };

    try {
      if (kDebugMode) {
        debugPrint('SyncService: Starting full sync...');
      }

      // 1. Upload pending offline data first
      if (HiveService.hasPendingOfflineData()) {
        if (kDebugMode) {
          debugPrint('SyncService: Uploading pending offline data...');
        }
        final uploadResponse = await uploadAllPendingOfflineData();
        results['upload_sync'] = {
          'success': uploadResponse.success,
          'message': uploadResponse.message ?? 'Upload completed',
          'processed_items': (uploadResponse.data?.processedBids.length ?? 0) +
              (uploadResponse.data?.processedBookings.length ?? 0) +
              (uploadResponse.data?.processedMessages.length ?? 0),
        };
      } else {
        results['upload_sync'] = {
          'success': true,
          'message': 'No pending offline data',
          'processed_items': 0,
        };
      }

      // 2. Download user profile
      if (includeProfile) {
        if (kDebugMode) {
          debugPrint('SyncService: Downloading user profile...');
        }
        final profileResponse = await downloadUserProfile();
        results['profile_sync'] = {
          'success': profileResponse.success,
          'message': profileResponse.message ??
              (profileResponse.success
                  ? 'Profile synced'
                  : 'Profile sync failed'),
        };
      } else {
        results['profile_sync'] = {
          'success': true,
          'message': 'Profile sync skipped',
        };
      }

      // 3. Download services
      if (kDebugMode) {
        debugPrint('SyncService: Downloading services...');
      }
      final servicesResponse =
          await downloadLimitedServices(limit: serviceLimit);
      results['services_sync'] = {
        'success': servicesResponse.success,
        'message': servicesResponse.message ??
            (servicesResponse.success
                ? 'Services synced'
                : 'Services sync failed'),
        'services_count': servicesResponse.data?.services.length ?? 0,
      };

      // Overall success
      results['overall_success'] = results['profile_sync']['success'] &&
          results['services_sync']['success'] &&
          results['upload_sync']['success'];

      if (kDebugMode) {
        debugPrint(
            'SyncService: Full sync completed - Success: ${results['overall_success']}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SyncService: Error during full sync - $e');
      }
      results['error'] = e.toString();
    }

    return results;
  }

  /// Quick sync - limited services only
  Future<ApiResponse<SyncServicesResponse>> performQuickSync({
    int limit = 20,
  }) async {
    if (kDebugMode) {
      debugPrint('SyncService: Performing quick sync (limit: $limit)');
    }

    // Upload pending data first if any exists
    if (HiveService.hasPendingOfflineData()) {
      await uploadAllPendingOfflineData();
    }

    // Download limited services
    return await downloadLimitedServices(limit: limit);
  }

  /// Sync by specific criteria
  Future<ApiResponse<SyncServicesResponse>> performConditionalSync({
    String? category,
    String? location,
    double? maxPrice,
    int limit = 50,
  }) async {
    if (kDebugMode) {
      debugPrint('SyncService: Performing conditional sync with filters');
    }

    return await downloadServicesWithFilters(
      category: category,
      location: location,
      maxPrice: maxPrice,
      limit: limit,
      ordering: '-created_at',
    );
  }
}

/// Provider for SyncService
final syncServiceProvider =
    StateNotifierProvider<SyncServiceProvider, List<SyncService>?>(
  (ref) => SyncServiceProvider(ApiService()),
);
