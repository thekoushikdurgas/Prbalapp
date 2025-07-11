import 'user_type.dart';

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
