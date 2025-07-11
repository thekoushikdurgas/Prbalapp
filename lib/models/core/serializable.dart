/// Base interface for serializable models
abstract class Serializable {
  /// Convert object to JSON map
  Map<String, dynamic> toJson();

  /// Create object from JSON map
  /// This is implemented by factory constructors in concrete classes
  // T fromJson(Map<String, dynamic> json); // Cannot be static in interface
}

/// Base class for models that provide common serialization utilities
abstract class BaseModel implements Serializable {
  /// Safely parse a double from various types
  static double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Safely parse an integer from various types
  static int parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Safely parse a boolean from various types
  static bool parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is int) return value != 0;
    return false;
  }

  /// Safely parse a DateTime from string
  static DateTime parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  /// Safely parse a DateTime from string with fallback
  static DateTime parseDateTimeWithFallback(dynamic value, dynamic fallback) {
    if (value != null) {
      if (value is DateTime) return value;
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) return parsed;
      }
    }

    // Try fallback
    if (fallback != null) {
      if (fallback is DateTime) return fallback;
      if (fallback is String) {
        final parsed = DateTime.tryParse(fallback);
        if (parsed != null) return parsed;
      }
    }

    return DateTime.now();
  }

  /// Safely parse a string with default value
  static String parseString(dynamic value, [String defaultValue = '']) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    return value.toString();
  }

  /// Safely parse an optional string
  static String? parseOptionalString(dynamic value) {
    if (value == null) return null;
    if (value is String && value.isEmpty) return null;
    if (value is String) return value;
    return value.toString();
  }

  /// Safely parse a Map<String, String> from dynamic
  static Map<String, String>? parseStringMap(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, String>) return value;
    if (value is Map) {
      return Map<String, String>.from(value);
    }
    return null;
  }

  /// Safely parse a Map<String, dynamic> from dynamic
  static Map<String, dynamic>? parseDynamicMap(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  /// Common fields that appear in most API responses
  static const String idField = 'id';
  static const String createdAtField = 'created_at';
  static const String updatedAtField = 'updated_at';
  static const String nameField = 'name';
  static const String descriptionField = 'description';
  static const String isActiveField = 'is_active';
  static const String sortOrderField = 'sort_order';
}

/// Mixin for models that have timestamps
mixin TimestampMixin {
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Parse timestamps from JSON with proper fallback
  static DateTime parseCreatedAt(Map<String, dynamic> json) {
    return BaseModel.parseDateTime(json[BaseModel.createdAtField]);
  }

  static DateTime parseUpdatedAt(Map<String, dynamic> json) {
    return BaseModel.parseDateTimeWithFallback(
      json[BaseModel.updatedAtField],
      json[BaseModel.createdAtField],
    );
  }
}

/// Mixin for models that have sort order
mixin SortableMixin {
  int get sortOrder;

  /// Parse sort order from JSON
  static int parseSortOrder(Map<String, dynamic> json) {
    return BaseModel.parseInt(json[BaseModel.sortOrderField]);
  }
}

/// Mixin for models that have active status
mixin ActiveMixin {
  bool get isActive;

  /// Parse active status from JSON
  static bool parseIsActive(Map<String, dynamic> json) {
    return BaseModel.parseBool(json[BaseModel.isActiveField]);
  }
}

/// Mixin for models that have ID
mixin IdentifiableMixin {
  String get id;

  /// Parse ID from JSON
  static String parseId(Map<String, dynamic> json) {
    return BaseModel.parseString(json[BaseModel.idField]);
  }
}

/// Mixin for models that have name and description
mixin NamedMixin {
  String get name;
  String? get description;

  /// Parse name from JSON
  static String parseName(Map<String, dynamic> json) {
    return BaseModel.parseString(json[BaseModel.nameField]);
  }

  /// Parse description from JSON
  static String? parseDescription(Map<String, dynamic> json) {
    return BaseModel.parseOptionalString(json[BaseModel.descriptionField]);
  }
}

/// Response wrapper for list endpoints
class ListResponse<T extends Serializable> implements Serializable {
  final List<T> results;
  final int count;
  final String? next;
  final String? previous;

  const ListResponse({
    required this.results,
    required this.count,
    this.next,
    this.previous,
  });

  factory ListResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final resultsJson = json['results'] as List<dynamic>? ?? [];
    final results = resultsJson
        .map((item) => fromJsonT(item as Map<String, dynamic>))
        .toList();

    return ListResponse<T>(
      results: results,
      count: BaseModel.parseInt(json['count']),
      next: BaseModel.parseOptionalString(json['next']),
      previous: BaseModel.parseOptionalString(json['previous']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'results': results.map((item) => item.toJson()).toList(),
      'count': count,
      'next': next,
      'previous': previous,
    };
  }
}

/// Request wrapper for create/update operations
abstract class BaseRequest implements Serializable {
  /// Validate the request data
  bool validate();

  /// Get validation errors
  List<String> getValidationErrors();
}
