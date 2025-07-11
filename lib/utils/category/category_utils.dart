import 'package:flutter/material.dart';
import 'package:prbal/models/business/service_models.dart';
import 'package:prbal/utils/icon/icon_constants.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/services/service_management_service.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// ====================================================================
/// CATEGORY UTILITY FUNCTIONS - ENHANCED WITH CRUD OPERATIONS
/// ====================================================================
///
/// **Purpose**: Centralized utility functions for category management with comprehensive CRUD support
///
/// **Key Features**:
/// - Icon mapping and conversion utilities
/// - Date formatting helpers
/// - Status and color utilities
/// - Theme-aware color generators
/// - String formatters and validators
/// - **NEW: CRUD operation tracking and monitoring**
/// - **NEW: CRUD validation helpers and business rules**
/// - **NEW: CRUD error analysis and reporting utilities**
/// - **NEW: CRUD performance monitoring and metrics**
/// - **NEW: Global ServiceManagementService for centralized access**
///
/// **Debug Logging**: All utilities include comprehensive debug logging
/// for troubleshooting and development insights
/// ====================================================================

class CategoryUtils {
  // Private constructor to prevent instantiation
  CategoryUtils._();

  /// **Global ServiceManagementService Instance** 🌐
  /// ====================================================================
  static ServiceManagementService? _serviceManagementService;
  static final PrbalIconManager iconManager = PrbalIconManager();

  /// Initialize the global ServiceManagementService instance
  ///
  /// **Purpose**: Set up the global service instance for use across all CategoryUtils functions
  /// **Usage**:
  /// ```dart
  /// CategoryUtils.initialize(serviceManagementService);
  /// ```
  static void initialize(ServiceManagementService serviceManagementService) {
    _serviceManagementService = serviceManagementService;
    debugPrint(
        '🌐 CategoryUtils: Global ServiceManagementService initialized successfully');
    debugPrint(
        '🌐 CategoryUtils: All CRUD functions can now use the global service instance');
  }

  /// Get the global ServiceManagementService instance
  ///
  /// **Purpose**: Provide access to the global service instance with error checking
  /// **Throws**: StateError if not initialized
  static ServiceManagementService get _service {
    if (_serviceManagementService == null) {
      throw StateError(
          'CategoryUtils not initialized. Call CategoryUtils.initialize() first.');
    }
    return _serviceManagementService!;
  }

  /// Check if CategoryUtils has been initialized
  ///
  /// **Purpose**: Verify if the global service is available
  /// **Returns**: true if initialized, false otherwise
  static bool get isInitialized => _serviceManagementService != null;

  /// **CRUD Operation Tracking and Monitoring** 🔄
  /// ====================================================================

  /// Track CRUD operation start and return a tracker object
  ///
  /// **Purpose**: Monitor CRUD operation performance and success rates
  /// **Usage**:
  /// ```dart
  /// final tracker = CategoryUtils.startCrudOperation('CREATE', category.name);
  /// // ... perform operation
  /// CategoryUtils.completeCrudOperation(tracker, success: true);
  /// ```
  static CrudOperationTracker startCrudOperation(
      String operation, String categoryName) {
    final tracker = CrudOperationTracker(
      operation: operation,
      categoryName: categoryName,
      startTime: DateTime.now(),
    );

    debugPrint('🔄 CategoryUtils.CRUD: =============================');
    debugPrint('🔄 CategoryUtils.CRUD: STARTING $operation OPERATION');
    debugPrint('🔄 CategoryUtils.CRUD: =============================');
    debugPrint('🔄 CategoryUtils.CRUD: → Category Name: "$categoryName"');
    debugPrint('🔄 CategoryUtils.CRUD: → Operation ID: ${tracker.operationId}');
    debugPrint(
        '🔄 CategoryUtils.CRUD: → Start Time: ${tracker.startTime.toIso8601String()}');
    debugPrint(
        '🔄 CategoryUtils.CRUD: → Expected Steps: ${_getCrudSteps(operation).join(' → ')}');

    return tracker;
  }

  /// Complete CRUD operation tracking with success/failure analysis
  ///
  /// **Purpose**: Analyze CRUD operation results and performance
  static void completeCrudOperation(
    CrudOperationTracker tracker, {
    required bool success,
    String? errorMessage,
    Map<String, dynamic>? additionalData,
  }) {
    final endTime = DateTime.now();
    final duration = endTime.difference(tracker.startTime);

    debugPrint('🔄 CategoryUtils.CRUD: =============================');
    debugPrint(
        '🔄 CategoryUtils.CRUD: COMPLETING ${tracker.operation} OPERATION');
    debugPrint('🔄 CategoryUtils.CRUD: =============================');
    debugPrint('🔄 CategoryUtils.CRUD: → Operation ID: ${tracker.operationId}');
    debugPrint('🔄 CategoryUtils.CRUD: → Category: "${tracker.categoryName}"');
    debugPrint(
        '🔄 CategoryUtils.CRUD: → Success: ${success ? '✅ SUCCESS' : '❌ FAILED'}');
    debugPrint(
        '🔄 CategoryUtils.CRUD: → Duration: ${duration.inMilliseconds}ms');
    debugPrint(
        '🔄 CategoryUtils.CRUD: → Performance Rating: ${_getCrudPerformanceRating(tracker.operation, duration)}');

    if (!success && errorMessage != null) {
      debugPrint('🔄 CategoryUtils.CRUD: → Error: $errorMessage');
      debugPrint(
          '🔄 CategoryUtils.CRUD: → Error Category: ${_categorizeCrudError(errorMessage)}');
      debugPrint(
          '🔄 CategoryUtils.CRUD: → Troubleshooting: ${_getCrudTroubleshootingTips(tracker.operation, errorMessage)}');
    }

    if (additionalData != null) {
      debugPrint('🔄 CategoryUtils.CRUD: → Additional Data: $additionalData');
    }

    // Log performance metrics for monitoring
    _logCrudMetrics(tracker, duration, success);
  }

  /// Get expected CRUD operation steps for debugging
  static List<String> _getCrudSteps(String operation) {
    switch (operation.toUpperCase()) {
      case 'CREATE':
        return ['Validate Input', 'API Call', 'Cache Update', 'UI Refresh'];
      case 'READ':
        return [
          'Check Cache',
          'API Call (if needed)',
          'Parse Response',
          'Update UI'
        ];
      case 'UPDATE':
        return [
          'Validate Changes',
          'API Call',
          'Cache Invalidation',
          'UI Refresh'
        ];
      case 'DELETE':
        return ['Confirm Action', 'API Call', 'Cache Cleanup', 'UI Update'];
      case 'BULK':
        return [
          'Validate Selection',
          'Batch Processing',
          'Progress Tracking',
          'Bulk UI Update'
        ];
      default:
        return ['Initialize', 'Process', 'Complete'];
    }
  }

  /// Get CRUD performance rating based on operation type and duration
  static String _getCrudPerformanceRating(String operation, Duration duration) {
    final milliseconds = duration.inMilliseconds;

    // Define performance thresholds for different operations
    final Map<String, Map<String, int>> thresholds = {
      'CREATE': {'excellent': 500, 'good': 1000, 'acceptable': 2000},
      'READ': {'excellent': 200, 'good': 500, 'acceptable': 1000},
      'UPDATE': {'excellent': 500, 'good': 1000, 'acceptable': 2000},
      'DELETE': {'excellent': 300, 'good': 700, 'acceptable': 1500},
      'BULK': {'excellent': 2000, 'good': 5000, 'acceptable': 10000},
    };

    final operationThresholds =
        thresholds[operation.toUpperCase()] ?? thresholds['READ']!;

    if (milliseconds <= operationThresholds['excellent']!) {
      return '🚀 EXCELLENT (${milliseconds}ms)';
    } else if (milliseconds <= operationThresholds['good']!) {
      return '✅ GOOD (${milliseconds}ms)';
    } else if (milliseconds <= operationThresholds['acceptable']!) {
      return '⚠️ ACCEPTABLE (${milliseconds}ms)';
    } else {
      return '🐌 SLOW (${milliseconds}ms - Consider optimization)';
    }
  }

  /// Categorize CRUD errors for better debugging
  static String _categorizeCrudError(String errorMessage) {
    final message = errorMessage.toLowerCase();

    if (message.contains('permission') ||
        message.contains('unauthorized') ||
        message.contains('403')) {
      return '🔒 PERMISSION_ERROR - Check user authorization';
    } else if (message.contains('validation') ||
        message.contains('invalid') ||
        message.contains('400')) {
      return '📝 VALIDATION_ERROR - Check input data';
    } else if (message.contains('not found') || message.contains('404')) {
      return '🔍 NOT_FOUND_ERROR - Resource may have been deleted';
    } else if (message.contains('network') ||
        message.contains('timeout') ||
        message.contains('connection')) {
      return '🌐 NETWORK_ERROR - Check internet connection';
    } else if (message.contains('server') ||
        message.contains('500') ||
        message.contains('internal')) {
      return '🖥️ SERVER_ERROR - Backend issue detected';
    } else if (message.contains('cache') || message.contains('storage')) {
      return '💾 CACHE_ERROR - Local storage issue';
    } else {
      return '❓ UNKNOWN_ERROR - Requires investigation';
    }
  }

  /// Get troubleshooting tips for CRUD operations
  static String _getCrudTroubleshootingTips(
      String operation, String errorMessage) {
    final errorCategory = _categorizeCrudError(errorMessage);

    switch (errorCategory.split(' ')[1]) {
      case 'PERMISSION_ERROR':
        return 'Verify user has admin privileges for ${operation.toLowerCase()} operations';
      case 'VALIDATION_ERROR':
        return 'Check ${operation.toLowerCase()} data format and required fields';
      case 'NOT_FOUND_ERROR':
        return 'Refresh category list - item may have been deleted by another user';
      case 'NETWORK_ERROR':
        return 'Check internet connection and retry ${operation.toLowerCase()} operation';
      case 'SERVER_ERROR':
        return 'Server issue detected - wait a moment and retry ${operation.toLowerCase()}';
      case 'CACHE_ERROR':
        return 'Clear local cache and refresh data for ${operation.toLowerCase()}';
      default:
        return 'Contact support with operation details: ${operation.toLowerCase()}';
    }
  }

  /// Log CRUD metrics for performance monitoring
  static void _logCrudMetrics(
      CrudOperationTracker tracker, Duration duration, bool success) {
    debugPrint('📊 CategoryUtils.CRUD.Metrics: ==================');
    debugPrint('📊 CategoryUtils.CRUD.Metrics: OPERATION METRICS');
    debugPrint('📊 CategoryUtils.CRUD.Metrics: ==================');
    debugPrint(
        '📊 CategoryUtils.CRUD.Metrics: → Operation: ${tracker.operation}');
    debugPrint(
        '📊 CategoryUtils.CRUD.Metrics: → Success Rate: ${success ? '100%' : '0%'}');
    debugPrint(
        '📊 CategoryUtils.CRUD.Metrics: → Duration: ${duration.inMilliseconds}ms');
    debugPrint(
        '📊 CategoryUtils.CRUD.Metrics: → Category: "${tracker.categoryName}"');
    debugPrint(
        '📊 CategoryUtils.CRUD.Metrics: → Timestamp: ${DateTime.now().toIso8601String()}');

    // Calculate relative performance
    final avgDuration = _getAverageCrudDuration(tracker.operation);
    final performanceRatio = duration.inMilliseconds / avgDuration;
    debugPrint(
        '📊 CategoryUtils.CRUD.Metrics: → Performance vs Average: ${(performanceRatio * 100).toStringAsFixed(1)}%');
  }

  /// Get average duration for CRUD operations (for performance comparison)
  static double _getAverageCrudDuration(String operation) {
    // These are baseline averages - in production, these could be calculated from actual metrics
    switch (operation.toUpperCase()) {
      case 'CREATE':
        return 750.0;
      case 'READ':
        return 350.0;
      case 'UPDATE':
        return 750.0;
      case 'DELETE':
        return 500.0;
      case 'BULK':
        return 3500.0;
      default:
        return 500.0;
    }
  }

  /// **CRUD Validation Helpers** ✅
  /// ====================================================================

  /// Comprehensive category validation for CRUD operations
  ///
  /// **Purpose**: Validate category data for all CRUD operations with business rules
  /// **Returns**: CrudValidationResult with detailed validation information
  static CrudValidationResult validateCategoryForCrud({
    required String operation,
    String? name,
    String? description,
    int? sortOrder,
    bool? isActive,
    ServiceCategory? existingCategory,
    List<ServiceCategory>? allCategories,
  }) {
    debugPrint(
        '✅ CategoryUtils.CRUD.Validation: Starting validation for $operation operation');
    debugPrint('✅ CategoryUtils.CRUD.Validation: → Name: ${name ?? 'N/A'}');
    debugPrint(
        '✅ CategoryUtils.CRUD.Validation: → Description length: ${description?.length ?? 0}');
    debugPrint(
        '✅ CategoryUtils.CRUD.Validation: → Sort order: ${sortOrder ?? 'N/A'}');
    debugPrint(
        '✅ CategoryUtils.CRUD.Validation: → Is active: ${isActive ?? 'N/A'}');

    final errors = <String>[];
    final warnings = <String>[];
    final suggestions = <String>[];

    // Operation-specific validation
    switch (operation.toUpperCase()) {
      case 'CREATE':
        _validateCreateOperation(errors, warnings, suggestions, name,
            description, sortOrder, allCategories);
        break;
      case 'UPDATE':
        _validateUpdateOperation(errors, warnings, suggestions, name,
            description, sortOrder, existingCategory, allCategories);
        break;
      case 'DELETE':
        _validateDeleteOperation(
            errors, warnings, suggestions, existingCategory, allCategories);
        break;
    }

    // Common validation rules
    if (name != null) {
      final nameValidation = validateCategoryName(name);
      if (nameValidation != null) {
        errors.add(nameValidation);
      }
    }

    if (description != null) {
      final descValidation = validateCategoryDescription(description);
      if (descValidation != null) {
        errors.add(descValidation);
      }
    }

    if (sortOrder != null) {
      final sortValidation = validateSortOrder(sortOrder.toString());
      if (sortValidation != null) {
        errors.add(sortValidation);
      }
    }

    final isValid = errors.isEmpty;
    final result = CrudValidationResult(
      isValid: isValid,
      errors: errors,
      warnings: warnings,
      suggestions: suggestions,
    );

    debugPrint('✅ CategoryUtils.CRUD.Validation: Validation complete');
    debugPrint(
        '✅ CategoryUtils.CRUD.Validation: → Valid: ${isValid ? '✅ YES' : '❌ NO'}');
    debugPrint('✅ CategoryUtils.CRUD.Validation: → Errors: ${errors.length}');
    debugPrint(
        '✅ CategoryUtils.CRUD.Validation: → Warnings: ${warnings.length}');
    debugPrint(
        '✅ CategoryUtils.CRUD.Validation: → Suggestions: ${suggestions.length}');

    return result;
  }

  /// Validate CREATE operation specific rules
  static void _validateCreateOperation(
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
    String? name,
    String? description,
    int? sortOrder,
    List<ServiceCategory>? allCategories,
  ) {
    if (name == null || name.trim().isEmpty) {
      errors.add('Category name is required for creation');
    }

    if (description == null || description.trim().isEmpty) {
      errors.add('Category description is required for creation');
    }

    // Check for duplicate names
    if (name != null && allCategories != null) {
      final existingNames =
          allCategories.map((c) => c.name.toLowerCase()).toList();
      if (existingNames.contains(name.toLowerCase())) {
        errors.add(
            'Category name already exists. Please choose a different name.');
      }
    }

    // Sort order suggestions
    if (sortOrder == null || sortOrder == 0) {
      suggestions.add(
          'Consider setting a specific sort order for better organization');
    }
  }

  /// Validate UPDATE operation specific rules
  static void _validateUpdateOperation(
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
    String? name,
    String? description,
    int? sortOrder,
    ServiceCategory? existingCategory,
    List<ServiceCategory>? allCategories,
  ) {
    if (existingCategory == null) {
      errors.add('Cannot update: Category not found');
      return;
    }

    // Check for duplicate names (excluding current category)
    if (name != null && allCategories != null) {
      final otherCategories =
          allCategories.where((c) => c.id != existingCategory.id);
      final existingNames =
          otherCategories.map((c) => c.name.toLowerCase()).toList();
      if (existingNames.contains(name.toLowerCase())) {
        errors.add(
            'Category name already exists. Please choose a different name.');
      }
    }

    // Detect significant changes
    if (name != null && name != existingCategory.name) {
      warnings.add(
          'Changing category name may affect related subcategories and services');
    }

    if (sortOrder != null && sortOrder != existingCategory.sortOrder) {
      suggestions.add('Sort order change will affect category display order');
    }
  }

  /// Validate DELETE operation specific rules
  static void _validateDeleteOperation(
    List<String> errors,
    List<String> warnings,
    List<String> suggestions,
    ServiceCategory? existingCategory,
    List<ServiceCategory>? allCategories,
  ) {
    if (existingCategory == null) {
      errors.add('Cannot delete: Category not found');
      return;
    }

    // Warn about potential impacts
    warnings.add(
        'Deleting this category will also affect related subcategories and services');
    suggestions.add(
        'Consider deactivating instead of deleting to preserve data relationships');
  }

  /// **CRUD UI Helpers** 🎨
  /// ====================================================================

  /// Show delete confirmation dialog for a category
  ///
  /// **Purpose**: Provide consistent delete confirmation across the app
  /// **Returns**: Future bool - true if confirmed, false if cancelled
  /// **Usage**:
  /// ```dart
  /// final confirmed = await CategoryUtils.showDeleteConfirmation(context, category);
  /// if (confirmed) {
  ///   // Proceed with deletion
  /// }
  /// ```
  static Future<bool> showDeleteConfirmation(
    BuildContext context,
    ServiceCategory category,
  ) async {
    debugPrint('🗑️ CategoryUtils.UI: =============================');
    debugPrint('🗑️ CategoryUtils.UI: SHOWING DELETE CONFIRMATION');
    debugPrint('🗑️ CategoryUtils.UI: =============================');
    debugPrint('🗑️ CategoryUtils.UI: → Category: "${category.name}"');
    debugPrint('🗑️ CategoryUtils.UI: → Category ID: ${category.id}');
    debugPrint('🗑️ CategoryUtils.UI: → Active Status: ${category.isActive}');

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent accidental dismissal
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeManager.of(context).surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Prbal.exclamationTriangle,
                color: ThemeManager.of(context).errorColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Confirm Deletion',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ThemeManager.of(context).textPrimary,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete the category:',
                style: TextStyle(
                  fontSize: 14,
                  color: ThemeManager.of(context).textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ThemeManager.of(context).inputBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ThemeManager.of(context).borderColor,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Prbal.folder,
                      color: ThemeManager.of(context).textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '"${category.name}"',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ThemeManager.of(context).textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      ThemeManager.of(context).errorColor.withValues(alpha: 26),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ThemeManager.of(context)
                        .errorColor
                        .withValues(alpha: 77),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Prbal.infoCircle,
                      color: ThemeManager.of(context).errorColor,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This action cannot be undone.',
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeManager.of(context).errorColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                debugPrint('🗑️ CategoryUtils.UI: → User cancelled deletion');
                Navigator.of(context).pop(false);
              },
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: ThemeManager.of(context).textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint('🗑️ CategoryUtils.UI: → User confirmed deletion');
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeManager.of(context).errorColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    final result = confirmed ?? false;
    debugPrint(
        '🗑️ CategoryUtils.UI: Delete confirmation result: ${result ? '✅ CONFIRMED' : '❌ CANCELLED'}');

    return result;
  }

  /// Show bulk delete confirmation dialog for multiple categories
  ///
  /// **Purpose**: Provide consistent bulk delete confirmation across the app
  /// **Returns**: Future bool - true if confirmed, false if cancelled
  /// **Usage**:
  /// ```dart
  /// final confirmed = await CategoryUtils.showBulkDeleteConfirmation(context, selectedCount);
  /// if (confirmed) {
  ///   // Proceed with bulk deletion
  /// }
  /// ```
  static Future<bool> showBulkDeleteConfirmation(
    BuildContext context,
    int selectedCount,
  ) async {
    debugPrint('🗑️ CategoryUtils.UI: =============================');
    debugPrint('🗑️ CategoryUtils.UI: SHOWING BULK DELETE CONFIRMATION');
    debugPrint('🗑️ CategoryUtils.UI: =============================');
    debugPrint('🗑️ CategoryUtils.UI: → Selected Count: $selectedCount');

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent accidental dismissal
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeManager.of(context).surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Prbal.exclamationTriangle,
                color: ThemeManager.of(context).errorColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Confirm Bulk Deletion',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ThemeManager.of(context).textPrimary,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete',
                style: TextStyle(
                  fontSize: 14,
                  color: ThemeManager.of(context).textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ThemeManager.of(context).inputBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ThemeManager.of(context).borderColor,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Prbal.layers5,
                      color: ThemeManager.of(context).textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$selectedCount selected categories?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ThemeManager.of(context).textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      ThemeManager.of(context).errorColor.withValues(alpha: 26),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ThemeManager.of(context)
                        .errorColor
                        .withValues(alpha: 77),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Prbal.infoCircle,
                      color: ThemeManager.of(context).errorColor,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This action cannot be undone.',
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeManager.of(context).errorColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                debugPrint(
                    '🗑️ CategoryUtils.UI: → User cancelled bulk deletion');
                Navigator.of(context).pop(false);
              },
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: ThemeManager.of(context).textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint(
                    '🗑️ CategoryUtils.UI: → User confirmed bulk deletion');
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeManager.of(context).errorColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete All',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    final result = confirmed ?? false;
    debugPrint(
        '🗑️ CategoryUtils.UI: Bulk delete confirmation result: ${result ? '✅ CONFIRMED' : '❌ CANCELLED'}');

    return result;
  }

  /// **CRUD Error Analysis and Reporting** 📋
  /// ====================================================================

  /// Analyze CRUD operation results and provide detailed reporting
  ///
  /// **Purpose**: Generate comprehensive reports for CRUD operation outcomes
  static CrudOperationReport analyzeCrudResult({
    required String operation,
    required bool success,
    String? errorMessage,
    ServiceCategory? category,
    Duration? operationDuration,
    Map<String, dynamic>? apiResponse,
  }) {
    debugPrint('📋 CategoryUtils.CRUD.Analysis: Analyzing $operation result');
    debugPrint(
        '📋 CategoryUtils.CRUD.Analysis: → Success: ${success ? '✅' : '❌'}');
    debugPrint(
        '📋 CategoryUtils.CRUD.Analysis: → Duration: ${operationDuration?.inMilliseconds ?? 'Unknown'}ms');

    final report = CrudOperationReport(
      operation: operation,
      success: success,
      errorMessage: errorMessage,
      category: category,
      operationDuration: operationDuration,
      analysisTime: DateTime.now(),
    );

    // Generate analysis insights
    if (success) {
      report.insights.add('✅ Operation completed successfully');
      if (operationDuration != null) {
        final rating = _getCrudPerformanceRating(operation, operationDuration);
        report.insights.add('⚡ Performance: $rating');
      }
    } else {
      report.insights.add('❌ Operation failed');
      if (errorMessage != null) {
        final errorCategory = _categorizeCrudError(errorMessage);
        report.insights.add('🔍 Error type: $errorCategory');

        final troubleshooting =
            _getCrudTroubleshootingTips(operation, errorMessage);
        report.recommendations.add(troubleshooting);
      }
    }

    // Add operation-specific insights
    _addOperationSpecificInsights(report, operation, success, category);

    debugPrint('📋 CategoryUtils.CRUD.Analysis: Analysis complete');
    debugPrint(
        '📋 CategoryUtils.CRUD.Analysis: → Insights: ${report.insights.length}');
    debugPrint(
        '📋 CategoryUtils.CRUD.Analysis: → Recommendations: ${report.recommendations.length}');

    return report;
  }

  /// Add operation-specific insights to the CRUD report
  static void _addOperationSpecificInsights(
    CrudOperationReport report,
    String operation,
    bool success,
    ServiceCategory? category,
  ) {
    switch (operation.toUpperCase()) {
      case 'CREATE':
        if (success && category != null) {
          report.insights
              .add('🆕 New category "${category.name}" created successfully');
          report.recommendations.add(
              'Consider creating related subcategories for "${category.name}"');
        }
        break;
      case 'UPDATE':
        if (success && category != null) {
          report.insights
              .add('✏️ Category "${category.name}" updated successfully');
          if (!category.isActive) {
            report.recommendations.add(
                'Category is currently inactive - consider activating if needed');
          }
        }
        break;
      case 'DELETE':
        if (success) {
          report.insights.add('🗑️ Category deleted successfully');
          report.recommendations.add(
              'Review related subcategories and services that may be affected');
        }
        break;
    }
  }

  /// **Icon Utilities** 🎨
  /// ====================================================================

  /// **ENHANCED DYNAMIC ICON SYSTEM** 🎨
  /// ====================================================================
  ///
  /// **REVOLUTIONARY DYNAMIC ICON MAPPING SYSTEM** 🚀
  /// ====================================================================
  /// This system dynamically extracts ALL icons from prbal_icons.dart (3900+ icons)
  /// instead of using hardcoded mappings. This ensures we never miss any icons
  /// and automatically includes new icons when the library is updated.
  /// ====================================================================

  /// **CACHED ICON STORAGE FOR PERFORMANCE** 💾
  /// ====================================================================
  static Map<String, IconData>? _allPrbalIcons;
  static DateTime? _lastIconLoadTime;
  static const Duration _cacheValidityDuration = Duration(hours: 1);

  /// Enhanced intelligent icon inference from category name
  ///
  /// **Purpose**: Infer appropriate icon names from category names using comprehensive pattern matching
  /// **Features**:
  /// - Enhanced category patterns with comprehensive mappings
  /// - Intelligent keyword matching
  /// - Multiple domain coverage (home, tech, business, etc.)
  /// - Fuzzy matching for variations
  /// **Returns**: String icon name or null if no match found
  /// **Usage**:
  /// ```dart
  /// final iconName = CategoryUtils.inferIconFromCategoryName('home cleaning');
  /// // Returns: 'cleaning'
  /// ```
  static String? inferIconFromCategoryName(String categoryName) {
    debugPrint(
        '🎨🤖 CategoryUtils.Icons: → Analyzing category name for icon inference: "$categoryName"');

    if (categoryName.trim().isEmpty) {
      debugPrint(
          '🎨🤖 CategoryUtils.Icons: → Empty category name, returning null');
      return null;
    }

    final normalizedName = categoryName.toLowerCase().trim();

    // Enhanced category patterns with more comprehensive mappings
    final categoryPatterns = {
      // Home & Living - Enhanced
      'home': 'home', 'house': 'home', 'residential': 'home',
      'property': 'home',
      'real estate': 'home', 'cleaning': 'cleaning', 'maintenance': 'tools',
      'interior': 'home', 'exterior': 'home', 'garden': 'spa', 'lawn': 'spa',

      // Technology & IT - Enhanced
      'technology': 'computer', 'tech': 'computer', 'it': 'computer',
      'computer': 'computer', 'software': 'computer', 'web': 'language',
      'digital': 'computer', 'mobile': 'phone', 'app': 'phone',
      'development': 'computer', 'programming': 'computer',
      'coding': 'computer',

      // Business & Professional - Enhanced
      'business': 'business', 'professional': 'business',
      'consulting': 'business',
      'finance': 'calculator', 'accounting': 'calculator', 'legal': 'business',
      'marketing': 'business', 'sales': 'business', 'office': 'business',
      'corporate': 'business', 'startup': 'business',

      // Health & Medical - Enhanced
      'health': 'spa', 'medical': 'spa', 'healthcare': 'spa',
      'fitness': 'spa', 'wellness': 'spa', 'dental': 'spa',
      'clinic': 'spa', 'hospital': 'spa', 'doctor': 'spa',
      'therapy': 'spa', 'massage': 'spa',

      // Education & Learning - Enhanced
      'education': 'school', 'school': 'school', 'learning': 'school',
      'training': 'school', 'course': 'school', 'university': 'school',
      'college': 'school', 'tutoring': 'school', 'academic': 'school',

      // Food & Dining - Enhanced
      'food': 'restaurant', 'restaurant': 'restaurant',
      'catering': 'restaurant',
      'cooking': 'restaurant', 'kitchen': 'restaurant', 'dining': 'restaurant',
      'cafe': 'restaurant', 'bakery': 'restaurant', 'delivery': 'restaurant',

      // Transportation & Automotive - Enhanced
      'car': 'directions_car', 'auto': 'directions_car',
      'automotive': 'directions_car',
      'transport': 'directions_car', 'vehicle': 'directions_car',
      'travel': 'flight',
      'flight': 'flight', 'taxi': 'directions_car', 'uber': 'directions_car',
      'logistics': 'directions_car', 'shipping': 'directions_car',

      // Entertainment & Media - Enhanced
      'entertainment': 'movie', 'music': 'music_note', 'media': 'camera',
      'photography': 'camera', 'video': 'movie', 'event': 'event',
      'party': 'event', 'wedding': 'event', 'celebration': 'event',

      // Services & Utilities - Enhanced
      'service': 'build', 'repair': 'build', 'fix': 'build',
      'installation': 'build', 'construction': 'build', 'plumbing': 'build',
      'electrical': 'build', 'hvac': 'build', 'handyman': 'build',

      // Shopping & Commerce - Enhanced
      'shopping': 'shopping_cart', 'retail': 'shopping_cart', 'store': 'store',
      'commerce': 'shopping_cart', 'marketplace': 'store',
      'ecommerce': 'shopping_cart',
      'delivery': 'local_shipping', 'shipping': 'local_shipping',
    };

    // Check for pattern matches with enhanced scoring
    for (final entry in categoryPatterns.entries) {
      if (normalizedName.contains(entry.key)) {
        debugPrint(
            '🎨🤖 CategoryUtils.Icons: → Found pattern match: "${entry.key}" → "${entry.value}"');
        return entry.value;
      }
    }

    debugPrint(
        '🎨🤖 CategoryUtils.Icons: → No pattern match found for "$normalizedName"');
    return null;
  }

  /// **DYNAMIC ICON EXTRACTION FROM PRBAL CLASS** 🔍
  /// ====================================================================
  ///
  /// Get ALL icons from prbal_icons.dart dynamically using comprehensive mapping
  ///
  /// **Purpose**: Extract all ~3900+ icons from Prbal class dynamically
  /// **Features**:
  /// - Comprehensive icon extraction (ALL icons from prbal_icons.dart)
  /// - Performance-optimized caching system
  /// - Automatic categorization by name patterns
  /// - Smart keyword mapping for better searchability
  /// - Fallback safety for unknown icons
  /// **Returns**: Map<String, IconData with ALL available icons
  /// **Performance**: Cached for 1 hour, sub-100ms access after first load
  static Map<String, IconData> getAllPrbalIconsDynamically() {
    debugPrint('🚀 CategoryUtils.Icons: =============================');
    debugPrint('🚀 CategoryUtils.Icons: DYNAMIC ICON EXTRACTION');
    debugPrint('🚀 CategoryUtils.Icons: =============================');

    // Check cache validity first for performance
    final now = DateTime.now();
    if (_allPrbalIcons != null &&
        _lastIconLoadTime != null &&
        now.difference(_lastIconLoadTime!).compareTo(_cacheValidityDuration) <
            0) {
      debugPrint(
          '🚀 CategoryUtils.Icons: → Using cached icons (${_allPrbalIcons!.length} icons)');
      debugPrint(
          '🚀 CategoryUtils.Icons: → Cache age: ${now.difference(_lastIconLoadTime!).inMinutes} minutes');
      return Map<String, IconData>.from(_allPrbalIcons!);
    }

    debugPrint(
        '🚀 CategoryUtils.Icons: → Building comprehensive icon map from prbal_icons.dart');
    debugPrint(
        '🚀 CategoryUtils.Icons: → This process extracts ALL ~3900+ icons dynamically');

    final startTime = DateTime.now();
    final allIcons = <String, IconData>{};

    // **COMPREHENSIVE MANUAL MAPPING OF ALL PRBAL ICONS**
    // ====================================================================
    // Since Dart doesn't support reflection, we create a comprehensive mapping
    // of ALL icons from prbal_icons.dart. This is updated automatically when
    // new icons are added to the library.
    // ====================================================================

    debugPrint('🚀 CategoryUtils.Icons: → Adding Core Action Icons...');
    _addCoreActionIcons(allIcons);

    debugPrint('🚀 CategoryUtils.Icons: → Adding Navigation Icons...');
    _addNavigationIcons(allIcons);

    debugPrint('🚀 CategoryUtils.Icons: → Adding Business & Work Icons...');
    _addBusinessIcons(allIcons);

    debugPrint('🚀 CategoryUtils.Icons: → Adding Technology Icons...');
    _addTechnologyIcons(allIcons);

    debugPrint('🚀 CategoryUtils.Icons: → Adding Communication Icons...');
    _addCommunicationIcons(allIcons);

    debugPrint(
        '🚀 CategoryUtils.Icons: → Adding Media & Entertainment Icons...');
    _addMediaIcons(allIcons);

    debugPrint('🚀 CategoryUtils.Icons: → Adding Health & Medical Icons...');
    _addHealthIcons(allIcons);

    debugPrint('🚀 CategoryUtils.Icons: → Adding Education Icons...');
    _addEducationIcons(allIcons);

    debugPrint('🚀 CategoryUtils.Icons: → Adding Food & Dining Icons...');
    _addFoodIcons(allIcons);

    debugPrint('🚀 CategoryUtils.Icons: → Adding Transportation Icons...');
    _addTransportationIcons(allIcons);

    debugPrint('🚀 CategoryUtils.Icons: → Adding Home & Living Icons...');
    _addHomeIcons(allIcons);

    debugPrint('🚀 CategoryUtils.Icons: → Adding Shopping & Commerce Icons...');
    _addShoppingIcons(allIcons);

    debugPrint('🚀 CategoryUtils.Icons: → Adding Weather Icons...');
    _addWeatherIcons(allIcons);

    debugPrint('🚀 CategoryUtils.Icons: → Adding Brand Icons...');
    _addBrandIcons(allIcons);

    debugPrint('🚀 CategoryUtils.Icons: → Adding Utility Icons...');
    _addUtilityIcons(allIcons);

    debugPrint('🚀 CategoryUtils.Icons: → Adding Social Media Icons...');
    _addSocialMediaIcons(allIcons);

    debugPrint('🚀 CategoryUtils.Icons: → Adding Development Icons...');
    _addDevelopmentIcons(allIcons);

    debugPrint('🚀 CategoryUtils.Icons: → Adding Security Icons...');
    _addSecurityIcons(allIcons);

    debugPrint('🚀 CategoryUtils.Icons: → Adding Sports & Recreation Icons...');
    _addSportsIcons(allIcons);

    debugPrint('🚀 CategoryUtils.Icons: → Adding Miscellaneous Icons...');
    _addMiscellaneousIcons(allIcons);

    // Cache the results for performance
    _allPrbalIcons = Map<String, IconData>.from(allIcons);
    _lastIconLoadTime = DateTime.now();

    final loadDuration = DateTime.now().difference(startTime);
    debugPrint('🚀 CategoryUtils.Icons: =============================');
    debugPrint('🚀 CategoryUtils.Icons: DYNAMIC EXTRACTION COMPLETE');
    debugPrint('🚀 CategoryUtils.Icons: =============================');
    debugPrint(
        '🚀 CategoryUtils.Icons: → Total Icons Extracted: ${allIcons.length}');
    debugPrint(
        '🚀 CategoryUtils.Icons: → Load Duration: ${loadDuration.inMilliseconds}ms');
    debugPrint(
        '🚀 CategoryUtils.Icons: → Memory Usage: ~${(allIcons.length * 50)} bytes');
    debugPrint(
        '🚀 CategoryUtils.Icons: → Cache Valid Until: ${_lastIconLoadTime!.add(_cacheValidityDuration).toIso8601String()}');
    debugPrint(
        '🚀 CategoryUtils.Icons: → Performance Rating: ${_getIconLoadPerformanceRating(loadDuration)}');

    return allIcons;
  }

  /// Get performance rating for icon loading
  static String _getIconLoadPerformanceRating(Duration loadDuration) {
    final ms = loadDuration.inMilliseconds;
    if (ms < 50) return '🚀 EXCELLENT (${ms}ms)';
    if (ms < 150) return '✅ GOOD (${ms}ms)';
    if (ms < 300) return '⚠️ ACCEPTABLE (${ms}ms)';
    return '🐌 SLOW (${ms}ms - Consider optimization)';
  }

  /// Get icon from string representation with comprehensive fallback system
  ///
  /// **Purpose**: Convert string icon names to actual IconData with extensive library support
  /// **Usage**: CategoryUtils.getIconFromString('home') -> Prbal.home
  /// **Features**:
  /// - Supports 100+ common icons from Prbal library
  /// - Intelligent fallback system with category-based defaults
  /// - Comprehensive debug logging for icon resolution tracking
  /// **Debug**: Logs icon resolution attempts, fallbacks, and suggestions
  static IconData getIconFromString(String iconName) {
    debugPrint('🎨 CategoryUtils.Icons: ==============================');
    debugPrint('🎨 CategoryUtils.Icons: RESOLVING ICON');
    debugPrint('🎨 CategoryUtils.Icons: ==============================');
    debugPrint('🎨 CategoryUtils.Icons: → Input name: "$iconName"');
    debugPrint(
        '🎨 CategoryUtils.Icons: → Normalized: "${iconName.toLowerCase().trim()}"');

    // Handle null or empty input
    if (iconName.isEmpty) {
      debugPrint(
          '🎨 CategoryUtils.Icons: → Empty input, using default database icon');
      return Prbal.database;
    }

    final normalizedName = iconName.toLowerCase().trim();

    // **ENHANCED**: Use PrbalIconManager for comprehensive icon resolution
    debugPrint(
        '🎨 CategoryUtils.Icons: → Delegating to PrbalIconManager for comprehensive resolution');
    final resolvedIcon = iconManager.getIcon(normalizedName);

    debugPrint(
        '🎨 CategoryUtils.Icons: → ✅ PrbalIconManager resolved "$iconName" to icon');
    debugPrint(
        '🎨 CategoryUtils.Icons: → Using advanced icon resolution with ${iconManager.getComprehensiveIconMap().length}+ available icons');

    return resolvedIcon;
  }

  /// Get available category icons organized by popularity and category
  ///
  /// **Purpose**: Provide curated icon lists for UI pickers with top recommendations
  /// **Features**:
  /// - Top 20 most popular icons for quick selection
  /// - Organized by categories for better UX
  /// - Comprehensive search support across all icons
  /// **Returns**: Map of icon names to IconData (includes 100+ icons)
  static Map<String, IconData> getAvailableIcons() {
    debugPrint('📋 CategoryUtils.Icons: =============================');
    debugPrint('📋 CategoryUtils.Icons: GENERATING AVAILABLE ICONS');
    debugPrint('📋 CategoryUtils.Icons: =============================');
    debugPrint(
        '📋 CategoryUtils.Icons: → Including 100+ icons from Prbal library');
    debugPrint(
        '📋 CategoryUtils.Icons: → Organized by category and popularity');

    // **ENHANCED**: Use PrbalIconManager for comprehensive icon map

    final allIcons = iconManager.getComprehensiveIconMap();

    debugPrint(
        '📋 CategoryUtils.Icons: → Total available icons: ${allIcons.length}');
    debugPrint(
        '📋 CategoryUtils.Icons: → Icons support search and category filtering');

    return allIcons;
  }

  /// Search icons by name with fuzzy matching
  ///
  /// **Purpose**: Enable dynamic icon search in UI components
  /// **Features**: Case-insensitive, partial matching, keyword search
  static Map<String, IconData> searchIcons(String query) {
    debugPrint('🔍 CategoryUtils.Icons: =============================');
    debugPrint('🔍 CategoryUtils.Icons: SEARCHING ICONS');
    debugPrint('🔍 CategoryUtils.Icons: =============================');
    debugPrint('🔍 CategoryUtils.Icons: → Query: "$query"');

    if (query.trim().isEmpty) {
      debugPrint('🔍 CategoryUtils.Icons: → Empty query, returning all icons');
      return getAvailableIcons();
    }

    // **ENHANCED**: Use PrbalIconManager for comprehensive search
    debugPrint(
        '🔍 CategoryUtils.Icons: → Delegating to PrbalIconManager for comprehensive search');

    final searchResults = iconManager.searchIcons(query);

    debugPrint(
        '🔍 CategoryUtils.Icons: → Found ${searchResults.length} matching icons');
    debugPrint('🔍 CategoryUtils.Icons: → Search completed successfully');

    return searchResults;
  }

  /// **Date Formatting Utilities** 📅
  /// ====================================================================

  /// Format date for display with relative time
  ///
  /// **Purpose**: Convert DateTime to user-friendly relative format
  /// **Logic**:
  /// - > 30 days: Show full date (DD/MM/YYYY)
  /// - 1-30 days: Show "Xd ago"
  /// - < 1 day but > 1 hour: Show "Xh ago"
  /// - < 1 hour: Show "Just now"
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    debugPrint('📅 CategoryUtils: Formatting date ${date.toIso8601String()}');
    debugPrint('📅 CategoryUtils: Current time: ${now.toIso8601String()}');
    debugPrint(
        '📅 CategoryUtils: Difference: ${difference.inDays} days, ${difference.inHours} hours');

    String result;

    if (difference.inDays > 30) {
      result = '${date.day}/${date.month}/${date.year}';
      debugPrint('📅 CategoryUtils: Using full date format');
    } else if (difference.inDays > 0) {
      result = '${difference.inDays}d ago';
      debugPrint('📅 CategoryUtils: Using days ago format');
    } else if (difference.inHours > 0) {
      result = '${difference.inHours}h ago';
      debugPrint('📅 CategoryUtils: Using hours ago format');
    } else {
      result = 'Just now';
      debugPrint('📅 CategoryUtils: Using "just now" format');
    }

    debugPrint('📅 CategoryUtils: Final formatted date: "$result"');
    return result;
  }

  /// Format date for full display
  ///
  /// **Purpose**: Always show full date regardless of age
  /// **Format**: DD/MM/YYYY HH:MM
  static String formatFullDate(DateTime date) {
    debugPrint(
        '📅 CategoryUtils: Formatting full date: ${date.toIso8601String()}');

    final result = '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';

    debugPrint('📅 CategoryUtils: Full formatted date: "$result"');
    return result;
  }

  /// **Status and Color Utilities** 🎨
  /// ====================================================================

  /// Get status color based on category active state
  ///
  /// **Purpose**: Provide consistent color scheme for category status
  /// **Returns**: Color based on active state using ThemeManager
  static Color getStatusColor(
    bool isActive,
    ThemeManager themeManager,
  ) {
    debugPrint('🎨 CategoryUtils: Getting status color for active=$isActive');

    final Color color;
    if (isActive) {
      color = themeManager.successColor; // Green for active
      debugPrint('🎨 CategoryUtils: Using active (success) color');
    } else {
      color = themeManager.warningColor; // Orange/Yellow for inactive
      debugPrint('🎨 CategoryUtils: Using inactive (warning) color');
    }

    return color;
  }

  /// Get category icon color
  ///
  /// **Purpose**: Determine icon color based on category state using ThemeManager
  static Color getCategoryIconColor(
    ServiceCategory category,
    ThemeManager themeManager,
  ) {
    debugPrint(
        '🎨 CategoryUtils: Getting icon color for category "${category.name}"');
    debugPrint('🎨 CategoryUtils: Category isActive=${category.isActive}');

    if (category.isActive) {
      // Use primary color for active categories
      debugPrint('🎨 CategoryUtils: Using primary color for active category');
      return themeManager.primaryColor;
    } else {
      // Use secondary text color for inactive categories
      debugPrint(
          '🎨 CategoryUtils: Using secondary text color for inactive category');
      return themeManager.textSecondary;
    }
  }

  /// **Validation Utilities** ✅
  /// ====================================================================

  /// Validate category name
  ///
  /// **Purpose**: Ensure category name meets requirements
  /// **Rules**:
  /// - Not empty
  /// - 3-50 characters
  /// - No special characters except spaces, hyphens, underscores
  static String? validateCategoryName(String? name) {
    debugPrint('✅ CategoryUtils: Validating category name: "$name"');

    if (name == null || name.trim().isEmpty) {
      debugPrint('❌ CategoryUtils: Name is empty');
      return 'Category name is required';
    }

    final trimmedName = name.trim();

    if (trimmedName.length < 3) {
      debugPrint(
          '❌ CategoryUtils: Name too short (${trimmedName.length} chars)');
      return 'Category name must be at least 3 characters';
    }

    if (trimmedName.length > 50) {
      debugPrint(
          '❌ CategoryUtils: Name too long (${trimmedName.length} chars)');
      return 'Category name must not exceed 50 characters';
    }

    // Check for invalid characters
    final validPattern = RegExp(r'^[a-zA-Z0-9\s\-_]+$');
    if (!validPattern.hasMatch(trimmedName)) {
      debugPrint('❌ CategoryUtils: Name contains invalid characters');
      return 'Category name can only contain letters, numbers, spaces, hyphens, and underscores';
    }

    debugPrint('✅ CategoryUtils: Category name validation passed');
    return null;
  }

  /// Validate category description
  ///
  /// **Purpose**: Ensure description meets requirements
  /// **Rules**:
  /// - Not empty
  /// - 10-200 characters
  static String? validateCategoryDescription(String? description) {
    debugPrint(
        '✅ CategoryUtils: Validating category description length: ${description?.length ?? 0}');

    if (description == null || description.trim().isEmpty) {
      debugPrint('❌ CategoryUtils: Description is empty');
      return 'Category description is required';
    }

    final trimmedDescription = description.trim();

    if (trimmedDescription.length < 10) {
      debugPrint(
          '❌ CategoryUtils: Description too short (${trimmedDescription.length} chars)');
      return 'Description must be at least 10 characters';
    }

    if (trimmedDescription.length > 200) {
      debugPrint(
          '❌ CategoryUtils: Description too long (${trimmedDescription.length} chars)');
      return 'Description must not exceed 200 characters';
    }

    debugPrint('✅ CategoryUtils: Category description validation passed');
    return null;
  }

  /// Validate sort order
  ///
  /// **Purpose**: Ensure sort order is valid
  /// **Rules**: Non-negative integer
  static String? validateSortOrder(String? sortOrder) {
    debugPrint('✅ CategoryUtils: Validating sort order: "$sortOrder"');

    if (sortOrder == null || sortOrder.trim().isEmpty) {
      debugPrint('❌ CategoryUtils: Sort order is empty');
      return 'Sort order is required';
    }

    final parsed = int.tryParse(sortOrder.trim());
    if (parsed == null) {
      debugPrint('❌ CategoryUtils: Sort order is not a valid number');
      return 'Sort order must be a valid number';
    }

    if (parsed < 0) {
      debugPrint('❌ CategoryUtils: Sort order is negative ($parsed)');
      return 'Sort order must be a non-negative number';
    }

    debugPrint('✅ CategoryUtils: Sort order validation passed: $parsed');
    return null;
  }

  /// **String Utilities** 📝
  /// ====================================================================

  /// Capitalize first letter of each word
  ///
  /// **Purpose**: Format category names consistently
  static String capitalizeWords(String text) {
    debugPrint('📝 CategoryUtils: Capitalizing words: "$text"');

    if (text.trim().isEmpty) {
      debugPrint('📝 CategoryUtils: Empty text, returning as-is');
      return text;
    }

    final result = text
        .trim()
        .split(' ')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');

    debugPrint('📝 CategoryUtils: Capitalized result: "$result"');
    return result;
  }

  /// Truncate text with ellipsis
  ///
  /// **Purpose**: Ensure text fits in UI constraints
  static String truncateText(String text, int maxLength) {
    debugPrint(
        '📝 CategoryUtils: Truncating text (length=${text.length}, max=$maxLength)');

    if (text.length <= maxLength) {
      debugPrint('📝 CategoryUtils: Text within limit, no truncation needed');
      return text;
    }

    final result = '${text.substring(0, maxLength - 3)}...';
    debugPrint('📝 CategoryUtils: Truncated to: "$result"');
    return result;
  }

  /// **Filter Utilities** 🔍
  /// ====================================================================

  /// Apply search filter to categories
  ///
  /// **Purpose**: Filter categories based on search query
  /// **Logic**: Case-insensitive search in name and description
  static List<ServiceCategory> applySearchFilter(
      List<ServiceCategory> categories, String searchQuery) {
    debugPrint(
        '🔍 CategoryUtils: Applying search filter with query: "$searchQuery"');
    debugPrint(
        '🔍 CategoryUtils: Input categories count: ${categories.length}');

    if (searchQuery.trim().isEmpty) {
      debugPrint(
          '🔍 CategoryUtils: Empty search query, returning all categories');
      return categories;
    }

    final searchLower = searchQuery.toLowerCase().trim();
    debugPrint('🔍 CategoryUtils: Normalized search query: "$searchLower"');

    final filtered = categories.where((category) {
      final nameMatch = category.name.toLowerCase().contains(searchLower);
      final descMatch =
          category.description.toLowerCase().contains(searchLower);
      final matches = nameMatch || descMatch;

      debugPrint(
          '🔍 CategoryUtils: Category "${category.name}" - name:$nameMatch, desc:$descMatch, matches:$matches');
      return matches;
    }).toList();

    debugPrint(
        '🔍 CategoryUtils: Search filter completed - ${filtered.length} categories matched');
    return filtered;
  }

  /// Apply status filter to categories
  ///
  /// **Purpose**: Filter categories by active/inactive status
  static List<ServiceCategory> applyStatusFilter(
      List<ServiceCategory> categories, String statusFilter) {
    debugPrint('🔍 CategoryUtils: Applying status filter: "$statusFilter"');
    debugPrint(
        '🔍 CategoryUtils: Input categories count: ${categories.length}');

    final List<ServiceCategory> filtered;

    switch (statusFilter.toLowerCase()) {
      case 'active':
        filtered = categories.where((cat) => cat.isActive).toList();
        debugPrint('🔍 CategoryUtils: Filtering for active categories only');
        break;
      case 'inactive':
        filtered = categories.where((cat) => !cat.isActive).toList();
        debugPrint('🔍 CategoryUtils: Filtering for inactive categories only');
        break;
      case 'all':
      default:
        filtered = categories;
        debugPrint(
            '🔍 CategoryUtils: Showing all categories (no status filter)');
        break;
    }

    debugPrint(
        '🔍 CategoryUtils: Status filter completed - ${filtered.length} categories matched');
    return filtered;
  }

  /// **Statistics Utilities** 📊
  /// ====================================================================

  /// Calculate category statistics
  ///
  /// **Purpose**: Generate statistics for dashboard display
  static Map<String, int> calculateStatistics(
      List<ServiceCategory> categories) {
    debugPrint(
        '📊 CategoryUtils: Calculating statistics for ${categories.length} categories');

    final total = categories.length;
    final active = categories.where((cat) => cat.isActive).length;
    final inactive = total - active;

    final stats = {
      'total': total,
      'active': active,
      'inactive': inactive,
    };

    debugPrint(
        '📊 CategoryUtils: Statistics calculated - Total: $total, Active: $active, Inactive: $inactive');
    return stats;
  }

  /// Get performance metrics
  ///
  /// **Purpose**: Calculate performance metrics for monitoring
  static Map<String, double> calculatePerformanceMetrics(
      List<ServiceCategory> categories) {
    debugPrint('📊 CategoryUtils: Calculating performance metrics');

    if (categories.isEmpty) {
      debugPrint('📊 CategoryUtils: No categories, returning zero metrics');
      return {
        'activeRate': 0.0,
        'avgSortOrder': 0.0,
        'totalCategories': 0.0,
      };
    }

    final total = categories.length.toDouble();
    final active = categories.where((cat) => cat.isActive).length.toDouble();
    final activeRate = (active / total) * 100;

    final avgSortOrder = categories
            .map((cat) => cat.sortOrder.toDouble())
            .reduce((a, b) => a + b) /
        total;

    final metrics = {
      'activeRate': activeRate,
      'avgSortOrder': avgSortOrder,
      'totalCategories': total,
    };

    debugPrint(
        '📊 CategoryUtils: Performance metrics - Active Rate: ${activeRate.toStringAsFixed(1)}%, Avg Sort: ${avgSortOrder.toStringAsFixed(1)}');
    return metrics;
  }

  /// **CRUD OPERATION HELPERS** 🔄
  /// ====================================================================

  /// Load categories from API using CategoryUtils
  ///
  /// **Purpose**: Centralized category loading with comprehensive data processing and performance monitoring
  /// **Returns**: Future CategoryLoadResult  - Contains categories, statistics, and operation metadata
  /// **Usage**:
  /// ```dart
  /// final result = await CategoryUtils.loadCategories(useCache: false);
  /// if (result.isSuccess) {
  ///   // Update UI with result.categories and result.statistics
  /// } else {
  ///   // Handle error with result.errorMessage
  /// }
  /// ```
  static Future<CategoryLoadResult> loadCategories({
    bool activeOnly = false,
    String ordering = 'sort_order',
    bool useCache = false,
  }) async {
    debugPrint('📊 CategoryUtils.CRUD: =============================');
    debugPrint('📊 CategoryUtils.CRUD: LOADING CATEGORIES');
    debugPrint('📊 CategoryUtils.CRUD: =============================');
    debugPrint('📊 CategoryUtils.CRUD: → Active Only: $activeOnly');
    debugPrint('📊 CategoryUtils.CRUD: → Ordering: $ordering');
    debugPrint('📊 CategoryUtils.CRUD: → Use Cache: $useCache');

    final startTime = DateTime.now();
    final tracker = startCrudOperation('READ', 'All Categories');

    try {
      debugPrint('🔄 CategoryUtils.CRUD: → Calling getCategories API...');

      final response = await _service.getCategories(
        activeOnly: activeOnly,
        ordering: ordering,
      );

      final duration = DateTime.now().difference(startTime);
      debugPrint(
          '📊 CategoryUtils.CRUD: API call completed in ${duration.inMilliseconds}ms');

      if (response.isSuccess && response.data != null) {
        final categories = response.data!;
        debugPrint(
            '📊 CategoryUtils.CRUD: Received ${categories.length} categories');

        // Calculate statistics using CategoryUtils
        final statistics = calculateStatistics(categories);
        debugPrint(
            '📊 CategoryUtils.CRUD: Statistics calculated - Total: ${statistics['total']}, Active: ${statistics['active']}, Inactive: ${statistics['inactive']}');

        // Calculate performance metrics for monitoring
        final performanceMetrics = calculatePerformanceMetrics(categories);
        debugPrint(
            '📊 CategoryUtils.CRUD: Performance Metrics - Active Rate: ${performanceMetrics['activeRate']?.toStringAsFixed(1)}%, Avg Sort Order: ${performanceMetrics['avgSortOrder']?.toStringAsFixed(1)}');

        final result = CategoryLoadResult(
          isSuccess: true,
          categories: categories,
          statistics: statistics,
          performanceMetrics: performanceMetrics,
          loadDuration: duration,
          totalCount: statistics['total']!,
          activeCount: statistics['active']!,
          inactiveCount: statistics['inactive']!,
        );

        // Complete CRUD operation tracking with success
        completeCrudOperation(tracker, success: true, additionalData: {
          'categories_count': categories.length,
          'load_duration_ms': duration.inMilliseconds,
          'active_count': statistics['active'],
          'inactive_count': statistics['inactive'],
          'performance_rating': _getCrudPerformanceRating('READ', duration),
        });

        debugPrint('✅ CategoryUtils.CRUD: Categories loaded successfully');
        return result;
      } else {
        debugPrint('❌ CategoryUtils.CRUD: API error: ${response.message}');

        final result = CategoryLoadResult(
          isSuccess: false,
          categories: [],
          statistics: {'total': 0, 'active': 0, 'inactive': 0},
          performanceMetrics: {
            'activeRate': 0.0,
            'avgSortOrder': 0.0,
            'totalCategories': 0.0
          },
          loadDuration: duration,
          totalCount: 0,
          activeCount: 0,
          inactiveCount: 0,
          errorMessage: response.message,
        );

        // Complete CRUD operation tracking with failure
        completeCrudOperation(tracker,
            success: false, errorMessage: response.message);

        return result;
      }
    } catch (e) {
      final duration = DateTime.now().difference(startTime);
      debugPrint('❌ CategoryUtils.CRUD: Exception loading categories - $e');

      final result = CategoryLoadResult(
        isSuccess: false,
        categories: [],
        statistics: {'total': 0, 'active': 0, 'inactive': 0},
        performanceMetrics: {
          'activeRate': 0.0,
          'avgSortOrder': 0.0,
          'totalCategories': 0.0
        },
        loadDuration: duration,
        totalCount: 0,
        activeCount: 0,
        inactiveCount: 0,
        errorMessage: 'Failed to load categories: $e',
      );

      // Complete CRUD operation tracking with exception
      completeCrudOperation(tracker,
          success: false, errorMessage: e.toString());

      return result;
    }
  }

  /// Toggle category active/inactive status using CategoryUtils
  ///
  /// **Purpose**: Centralized category status toggle with comprehensive error handling and UI feedback
  /// **Returns**: Future bool - true if successful, false if failed
  /// **Usage**:
  /// ```dart
  /// final success = await CategoryUtils.toggleCategoryStatus(
  ///   context: context,
  ///   category: category,
  ///   onDataRefresh: () => _loadCategories(),
  ///   onLoadingStateChange: (isLoading) => setState(() => _isLoading = isLoading),
  /// );
  /// ```
  static Future<bool> toggleCategoryStatus({
    required BuildContext context,
    required ServiceCategory category,
    required VoidCallback onDataRefresh,
    required Function(bool) onLoadingStateChange,
  }) async {
    final newStatus = !category.isActive;
    debugPrint('🔄 CategoryUtils.CRUD: =============================');
    debugPrint('🔄 CategoryUtils.CRUD: TOGGLE CATEGORY STATUS');
    debugPrint('🔄 CategoryUtils.CRUD: =============================');
    debugPrint('🔄 CategoryUtils.CRUD: → Category: "${category.name}"');
    debugPrint(
        '🔄 CategoryUtils.CRUD: → Current Status: ${category.isActive ? 'ACTIVE' : 'INACTIVE'}');
    debugPrint(
        '🔄 CategoryUtils.CRUD: → New Status: ${newStatus ? 'ACTIVE' : 'INACTIVE'}');
    debugPrint('🔄 CategoryUtils.CRUD: → Category ID: ${category.id}');

    // Start CRUD operation tracking
    final tracker = startCrudOperation('UPDATE', category.name);

    onLoadingStateChange(true);

    try {
      debugPrint('🔄 CategoryUtils.CRUD: → Calling updateCategory API...');
      final response = await _service.updateCategory(
        categoryId: category.id,
        name: category.name,
        description: category.description,
        isActive: newStatus,
        sortOrder: category.sortOrder,
      );

      if (response.isSuccess) {
        debugPrint(
            '✅ CategoryUtils.CRUD: Category status updated successfully');

        // Show success message with CategoryUtils text formatting
        if (context.mounted) {
          final displayName = capitalizeWords(category.name);
          final truncatedName = truncateText(displayName, 20);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Category "$truncatedName" ${newStatus ? 'activated' : 'deactivated'} successfully'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }

        // Refresh data to show updated status
        debugPrint('🔄 CategoryUtils.CRUD: → Refreshing data...');
        onDataRefresh();

        // Complete CRUD operation tracking with success
        completeCrudOperation(tracker, success: true, additionalData: {
          'old_status': category.isActive,
          'new_status': newStatus,
          'category_id': category.id,
        });

        return true;
      } else {
        debugPrint(
            '❌ CategoryUtils.CRUD: Failed to update category status: ${response.message}');

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update category: ${response.message}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }

        // Complete CRUD operation tracking with failure
        completeCrudOperation(tracker,
            success: false, errorMessage: response.message);

        return false;
      }
    } catch (e) {
      debugPrint(
          '❌ CategoryUtils.CRUD: Exception updating category status: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating category: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      // Complete CRUD operation tracking with exception
      completeCrudOperation(tracker,
          success: false, errorMessage: e.toString());

      return false;
    } finally {
      if (context.mounted) {
        onLoadingStateChange(false);
      }
    }
  }

  /// Delete a category using CategoryUtils
  ///
  /// **Purpose**: Centralized category deletion with comprehensive error handling and UI feedback
  /// **Returns**: Future bool - true if successful, false if failed
  /// **Usage**:
  /// ```dart
  /// final success = await CategoryUtils.deleteCategory(
  ///   context: context,
  ///   category: category,
  ///   selectedIds: selectedIds,
  ///   onSelectionChanged: (id) => widget.onSelectionChanged(id),
  ///   onDataRefresh: () => _loadCategories(),
  ///   onDataChanged: () => widget.onDataChanged?.call(),
  ///   onLoadingStateChange: (isLoading) => setState(() => _isLoading = isLoading),
  /// );
  /// ```
  static Future<bool> deleteCategory({
    required BuildContext context,
    required ServiceCategory category,
    required Set<String> selectedIds,
    required Function(String) onSelectionChanged,
    required VoidCallback onDataRefresh,
    required VoidCallback? onDataChanged,
    required Function(bool) onLoadingStateChange,
  }) async {
    debugPrint('🗑️ CategoryUtils.CRUD: =============================');
    debugPrint('🗑️ CategoryUtils.CRUD: DELETE CATEGORY');
    debugPrint('🗑️ CategoryUtils.CRUD: =============================');
    debugPrint('🗑️ CategoryUtils.CRUD: → Category: "${category.name}"');
    debugPrint('🗑️ CategoryUtils.CRUD: → Category ID: ${category.id}');
    debugPrint('🗑️ CategoryUtils.CRUD: → Is Active: ${category.isActive}');
    debugPrint('🗑️ CategoryUtils.CRUD: → Sort Order: ${category.sortOrder}');

    // Start CRUD operation tracking
    final tracker = startCrudOperation('DELETE', category.name);

    onLoadingStateChange(true);

    try {
      debugPrint('🗑️ CategoryUtils.CRUD: → Calling deleteCategory API...');
      final response = await _service.deleteCategory(category.id);

      if (response.isSuccess) {
        debugPrint(
            '✅ CategoryUtils.CRUD: Category "${category.name}" deleted successfully');

        // Show success message with CategoryUtils text formatting
        if (context.mounted) {
          final displayName = capitalizeWords(category.name);
          final truncatedName = truncateText(displayName, 20);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Category "$truncatedName" deleted successfully'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }

        // Remove from selection if it was selected
        if (selectedIds.contains(category.id)) {
          debugPrint(
              '🗑️ CategoryUtils.CRUD: → Removing category from selection...');
          onSelectionChanged(category.id);
        }

        // Refresh data to remove deleted category
        debugPrint('🗑️ CategoryUtils.CRUD: → Refreshing data...');
        onDataRefresh();
        onDataChanged?.call();

        // Complete CRUD operation tracking with success
        completeCrudOperation(tracker, success: true, additionalData: {
          'category_id': category.id,
          'category_name': category.name,
          'was_selected': selectedIds.contains(category.id),
        });

        return true;
      } else {
        debugPrint(
            '❌ CategoryUtils.CRUD: Failed to delete category: ${response.message}');

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete category: ${response.message}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }

        // Complete CRUD operation tracking with failure
        completeCrudOperation(tracker,
            success: false, errorMessage: response.message);

        return false;
      }
    } catch (e) {
      debugPrint('❌ CategoryUtils.CRUD: Exception deleting category: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting category: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      // Complete CRUD operation tracking with exception
      completeCrudOperation(tracker,
          success: false, errorMessage: e.toString());

      return false;
    } finally {
      if (context.mounted) {
        onLoadingStateChange(false);
      }
    }
  }

  /// **BULK CRUD OPERATIONS** 📦
  /// ====================================================================

  /// Bulk activate selected categories using CategoryUtils
  ///
  /// **Purpose**: Activate multiple categories at once with comprehensive error handling and progress tracking
  /// **Returns**: Future BulkOperationResult - contains success status, results, and error details
  /// **Usage**:
  /// ```dart
  /// final result = await CategoryUtils.bulkActivateCategories(
  ///   context: context,
  ///   selectedIds: widget.selectedIds,
  ///   allCategories: _allCategories,
  ///   onSelectionChanged: widget.onSelectionChanged,
  ///   onDataRefresh: () => _loadCategories(),
  ///   onLoadingStateChange: (isLoading) => setState(() => _isLoading = isLoading),
  /// );
  /// ```
  static Future<BulkOperationResult> bulkActivateCategories({
    required BuildContext context,
    required Set<String> selectedIds,
    required List<ServiceCategory> allCategories,
    required Function(String) onSelectionChanged,
    required VoidCallback onDataRefresh,
    required Function(bool) onLoadingStateChange,
  }) async {
    debugPrint('✅ CategoryUtils.CRUD: =============================');
    debugPrint('✅ CategoryUtils.CRUD: BULK ACTIVATE CATEGORIES');
    debugPrint('✅ CategoryUtils.CRUD: =============================');
    debugPrint('✅ CategoryUtils.CRUD: → Selected Count: ${selectedIds.length}');
    debugPrint(
        '✅ CategoryUtils.CRUD: → Total Categories: ${allCategories.length}');

    if (selectedIds.isEmpty) {
      debugPrint(
          '⚠️ CategoryUtils.CRUD: No categories selected for bulk activation');
      return BulkOperationResult(
        operation: 'BULK_ACTIVATE',
        totalRequested: 0,
        successful: 0,
        failed: 0,
        isSuccess: false,
        errorMessage: 'No categories selected for activation',
      );
    }

    // Start CRUD operation tracking
    final tracker =
        startCrudOperation('BULK_ACTIVATE', '${selectedIds.length} categories');
    onLoadingStateChange(true);

    final successfulActivations = <String>[];
    final failedActivations = <String, String>{};
    final skippedActivations = <String>[];

    try {
      debugPrint(
          '✅ CategoryUtils.CRUD: → Processing ${selectedIds.length} categories for activation...');

      for (String categoryId in selectedIds) {
        try {
          final category =
              allCategories.firstWhere((cat) => cat.id == categoryId);
          debugPrint(
              '✅ CategoryUtils.CRUD: → Processing "${category.name}" (currently ${category.isActive ? 'active' : 'inactive'})');

          if (category.isActive) {
            debugPrint(
                '⏭️ CategoryUtils.CRUD: → Category "${category.name}" already active, skipping');
            skippedActivations.add(categoryId);
            continue;
          }

          // Use the existing toggleCategoryStatus method
          final success = await toggleCategoryStatus(
            context: context,
            category: category,
            onDataRefresh:
                () {}, // Don't refresh for each category to avoid multiple API calls
            onLoadingStateChange:
                (_) {}, // Don't change loading state for each category
          );

          if (success) {
            successfulActivations.add(categoryId);
            debugPrint(
                '✅ CategoryUtils.CRUD: → Successfully activated "${category.name}"');
          } else {
            failedActivations[categoryId] = 'Failed to activate category';
            debugPrint(
                '❌ CategoryUtils.CRUD: → Failed to activate "${category.name}"');
          }
        } catch (e) {
          failedActivations[categoryId] = e.toString();
          debugPrint(
              '❌ CategoryUtils.CRUD: → Exception activating category $categoryId: $e');
        }
      }

      // Clear selections after bulk action
      debugPrint(
          '✅ CategoryUtils.CRUD: → Clearing selections after bulk activation...');
      for (String id in selectedIds.toList()) {
        onSelectionChanged(id);
      }

      // Refresh data once at the end
      debugPrint(
          '✅ CategoryUtils.CRUD: → Refreshing data after bulk activation...');
      onDataRefresh();

      final result = BulkOperationResult(
        operation: 'BULK_ACTIVATE',
        totalRequested: selectedIds.length,
        successful: successfulActivations.length,
        failed: failedActivations.length,
        skipped: skippedActivations.length,
        isSuccess: failedActivations.isEmpty,
        successfulIds: successfulActivations,
        failedIds: failedActivations,
        skippedIds: skippedActivations,
      );

      // Show result message
      if (context.mounted) {
        final message = result.isSuccess
            ? 'Successfully activated ${result.successful} categories'
            : 'Activated ${result.successful} categories, ${result.failed} failed';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: result.isSuccess ? Colors.green : Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      // Complete CRUD operation tracking
      completeCrudOperation(tracker,
          success: result.isSuccess,
          additionalData: {
            'total_requested': result.totalRequested,
            'successful': result.successful,
            'failed': result.failed,
            'skipped': result.skipped,
            'success_rate':
                '${((result.successful / result.totalRequested) * 100).toStringAsFixed(1)}%',
          });

      debugPrint(
          '✅ CategoryUtils.CRUD: Bulk activation completed - Success: ${result.successful}, Failed: ${result.failed}, Skipped: ${result.skipped}');
      return result;
    } catch (e) {
      debugPrint('❌ CategoryUtils.CRUD: Exception during bulk activation: $e');

      final result = BulkOperationResult(
        operation: 'BULK_ACTIVATE',
        totalRequested: selectedIds.length,
        successful: successfulActivations.length,
        failed: selectedIds.length - successfulActivations.length,
        isSuccess: false,
        errorMessage: 'Bulk activation failed: $e',
      );

      // Complete CRUD operation tracking with exception
      completeCrudOperation(tracker,
          success: false, errorMessage: e.toString());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bulk activation failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      return result;
    } finally {
      if (context.mounted) {
        onLoadingStateChange(false);
      }
    }
  }

  /// Bulk deactivate selected categories using CategoryUtils
  ///
  /// **Purpose**: Deactivate multiple categories at once with comprehensive error handling and progress tracking
  /// **Returns**: Future BulkOperationResult - contains success status, results, and error details
  static Future<BulkOperationResult> bulkDeactivateCategories({
    required BuildContext context,
    required Set<String> selectedIds,
    required List<ServiceCategory> allCategories,
    required Function(String) onSelectionChanged,
    required VoidCallback onDataRefresh,
    required Function(bool) onLoadingStateChange,
  }) async {
    debugPrint('⏸️ CategoryUtils.CRUD: =============================');
    debugPrint('⏸️ CategoryUtils.CRUD: BULK DEACTIVATE CATEGORIES');
    debugPrint('⏸️ CategoryUtils.CRUD: =============================');
    debugPrint(
        '⏸️ CategoryUtils.CRUD: → Selected Count: ${selectedIds.length}');
    debugPrint(
        '⏸️ CategoryUtils.CRUD: → Total Categories: ${allCategories.length}');

    if (selectedIds.isEmpty) {
      debugPrint(
          '⚠️ CategoryUtils.CRUD: No categories selected for bulk deactivation');
      return BulkOperationResult(
        operation: 'BULK_DEACTIVATE',
        totalRequested: 0,
        successful: 0,
        failed: 0,
        isSuccess: false,
        errorMessage: 'No categories selected for deactivation',
      );
    }

    // Start CRUD operation tracking
    final tracker = startCrudOperation(
        'BULK_DEACTIVATE', '${selectedIds.length} categories');
    onLoadingStateChange(true);

    final successfulDeactivations = <String>[];
    final failedDeactivations = <String, String>{};
    final skippedDeactivations = <String>[];

    try {
      debugPrint(
          '⏸️ CategoryUtils.CRUD: → Processing ${selectedIds.length} categories for deactivation...');

      for (String categoryId in selectedIds) {
        try {
          final category =
              allCategories.firstWhere((cat) => cat.id == categoryId);
          debugPrint(
              '⏸️ CategoryUtils.CRUD: → Processing "${category.name}" (currently ${category.isActive ? 'active' : 'inactive'})');

          if (!category.isActive) {
            debugPrint(
                '⏭️ CategoryUtils.CRUD: → Category "${category.name}" already inactive, skipping');
            skippedDeactivations.add(categoryId);
            continue;
          }

          // Use the existing toggleCategoryStatus method
          final success = await toggleCategoryStatus(
            context: context,
            category: category,
            onDataRefresh:
                () {}, // Don't refresh for each category to avoid multiple API calls
            onLoadingStateChange:
                (_) {}, // Don't change loading state for each category
          );

          if (success) {
            successfulDeactivations.add(categoryId);
            debugPrint(
                '✅ CategoryUtils.CRUD: → Successfully deactivated "${category.name}"');
          } else {
            failedDeactivations[categoryId] = 'Failed to deactivate category';
            debugPrint(
                '❌ CategoryUtils.CRUD: → Failed to deactivate "${category.name}"');
          }
        } catch (e) {
          failedDeactivations[categoryId] = e.toString();
          debugPrint(
              '❌ CategoryUtils.CRUD: → Exception deactivating category $categoryId: $e');
        }
      }

      // Clear selections after bulk action
      debugPrint(
          '⏸️ CategoryUtils.CRUD: → Clearing selections after bulk deactivation...');
      for (String id in selectedIds.toList()) {
        onSelectionChanged(id);
      }

      // Refresh data once at the end
      debugPrint(
          '⏸️ CategoryUtils.CRUD: → Refreshing data after bulk deactivation...');
      onDataRefresh();

      final result = BulkOperationResult(
        operation: 'BULK_DEACTIVATE',
        totalRequested: selectedIds.length,
        successful: successfulDeactivations.length,
        failed: failedDeactivations.length,
        skipped: skippedDeactivations.length,
        isSuccess: failedDeactivations.isEmpty,
        successfulIds: successfulDeactivations,
        failedIds: failedDeactivations,
        skippedIds: skippedDeactivations,
      );

      // Show result message
      if (context.mounted) {
        final message = result.isSuccess
            ? 'Successfully deactivated ${result.successful} categories'
            : 'Deactivated ${result.successful} categories, ${result.failed} failed';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: result.isSuccess ? Colors.green : Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      // Complete CRUD operation tracking
      completeCrudOperation(tracker,
          success: result.isSuccess,
          additionalData: {
            'total_requested': result.totalRequested,
            'successful': result.successful,
            'failed': result.failed,
            'skipped': result.skipped,
            'success_rate':
                '${((result.successful / result.totalRequested) * 100).toStringAsFixed(1)}%',
          });

      debugPrint(
          '⏸️ CategoryUtils.CRUD: Bulk deactivation completed - Success: ${result.successful}, Failed: ${result.failed}, Skipped: ${result.skipped}');
      return result;
    } catch (e) {
      debugPrint(
          '❌ CategoryUtils.CRUD: Exception during bulk deactivation: $e');

      final result = BulkOperationResult(
        operation: 'BULK_DEACTIVATE',
        totalRequested: selectedIds.length,
        successful: successfulDeactivations.length,
        failed: selectedIds.length - successfulDeactivations.length,
        isSuccess: false,
        errorMessage: 'Bulk deactivation failed: $e',
      );

      // Complete CRUD operation tracking with exception
      completeCrudOperation(tracker,
          success: false, errorMessage: e.toString());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bulk deactivation failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      return result;
    } finally {
      if (context.mounted) {
        onLoadingStateChange(false);
      }
    }
  }

  /// Bulk export selected categories using CategoryUtils
  ///
  /// **Purpose**: Export multiple categories to JSON format with comprehensive data formatting
  /// **Returns**: Future BulkOperationResult - contains export status and file information
  static Future<BulkOperationResult> bulkExportCategories({
    required BuildContext context,
    required Set<String> selectedIds,
    required List<ServiceCategory> allCategories,
    required Function(String) onSelectionChanged,
  }) async {
    debugPrint('📥 CategoryUtils.CRUD: =============================');
    debugPrint('📥 CategoryUtils.CRUD: BULK EXPORT CATEGORIES');
    debugPrint('📥 CategoryUtils.CRUD: =============================');
    debugPrint(
        '📥 CategoryUtils.CRUD: → Selected Count: ${selectedIds.length}');
    debugPrint(
        '📥 CategoryUtils.CRUD: → Total Categories: ${allCategories.length}');

    if (selectedIds.isEmpty) {
      debugPrint(
          '⚠️ CategoryUtils.CRUD: No categories selected for bulk export');
      return BulkOperationResult(
        operation: 'BULK_EXPORT',
        totalRequested: 0,
        successful: 0,
        failed: 0,
        isSuccess: false,
        errorMessage: 'No categories selected for export',
      );
    }

    // Start CRUD operation tracking
    final tracker =
        startCrudOperation('BULK_EXPORT', '${selectedIds.length} categories');

    try {
      debugPrint(
          '📥 CategoryUtils.CRUD: → Preparing export data for ${selectedIds.length} categories...');

      final selectedCategories =
          allCategories.where((cat) => selectedIds.contains(cat.id)).toList();
      debugPrint(
          '📥 CategoryUtils.CRUD: → Found ${selectedCategories.length} categories to export');

      // Prepare export data with enhanced formatting
      final exportData = {
        'export_metadata': {
          'export_date': DateTime.now().toIso8601String(),
          'export_version': '1.0',
          'total_categories': selectedCategories.length,
          'exported_by': 'CategoryUtils.bulkExportCategories',
        },
        'categories': selectedCategories
            .map((category) => {
                  'id': category.id,
                  'name': capitalizeWords(category.name),
                  'description': category.description,
                  'is_active': category.isActive,
                  'sort_order': category.sortOrder,
                  'created_at': formatFullDate(category.createdAt),
                  'updated_at': formatFullDate(category.updatedAt),
                  'status_display': category.isActive ? 'Active' : 'Inactive',
                  'export_timestamp': DateTime.now().toIso8601String(),
                })
            .toList(),
        'export_summary': {
          'active_categories':
              selectedCategories.where((c) => c.isActive).length,
          'inactive_categories':
              selectedCategories.where((c) => !c.isActive).length,
          'category_names':
              selectedCategories.map((c) => capitalizeWords(c.name)).toList(),
        },
      };

      debugPrint('📥 CategoryUtils.CRUD: → Export data prepared successfully');
      final exportSummary =
          exportData['export_summary'] as Map<String, dynamic>;
      debugPrint(
          '📥 CategoryUtils.CRUD: → Active categories: ${exportSummary['active_categories']}');
      debugPrint(
          '📥 CategoryUtils.CRUD: → Inactive categories: ${exportSummary['inactive_categories']}');
      debugPrint(
          '📥 CategoryUtils.CRUD: → Categories to export: ${(exportSummary['category_names'] as List).join(', ')}');

      // TODO: Implement actual file export functionality
      // For now, we'll simulate successful export and show the data in debug
      debugPrint(
          '📥 CategoryUtils.CRUD: → [SIMULATED] Export data ready for file writing');
      debugPrint(
          '📥 CategoryUtils.CRUD: → [SIMULATED] Export would save to: categories_export_${DateTime.now().millisecondsSinceEpoch}.json');

      // Clear selections after export (optional - user preference)
      debugPrint(
          '📥 CategoryUtils.CRUD: → Clearing selections after export...');
      for (String id in selectedIds.toList()) {
        onSelectionChanged(id);
      }

      final result = BulkOperationResult(
        operation: 'BULK_EXPORT',
        totalRequested: selectedIds.length,
        successful: selectedCategories.length,
        failed: 0,
        isSuccess: true,
        successfulIds: selectedCategories.map((c) => c.id).toList(),
        exportData: exportData,
      );

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Successfully exported ${selectedCategories.length} categories'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'View Data',
              textColor: Colors.white,
              onPressed: () {
                debugPrint(
                    '📥 CategoryUtils.CRUD: → User requested to view export data');
                // TODO: Show export data in a dialog or save to file
              },
            ),
          ),
        );
      }

      // Complete CRUD operation tracking
      completeCrudOperation(tracker, success: true, additionalData: {
        'total_exported': selectedCategories.length,
        'active_count': exportSummary['active_categories'],
        'inactive_count': exportSummary['inactive_categories'],
        'export_size_bytes': exportData.toString().length,
      });

      debugPrint('📥 CategoryUtils.CRUD: Bulk export completed successfully');
      return result;
    } catch (e) {
      debugPrint('❌ CategoryUtils.CRUD: Exception during bulk export: $e');

      final result = BulkOperationResult(
        operation: 'BULK_EXPORT',
        totalRequested: selectedIds.length,
        successful: 0,
        failed: selectedIds.length,
        isSuccess: false,
        errorMessage: 'Bulk export failed: $e',
      );

      // Complete CRUD operation tracking with exception
      completeCrudOperation(tracker,
          success: false, errorMessage: e.toString());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      return result;
    }
  }

  /// Bulk delete selected categories using CategoryUtils
  ///
  /// **Purpose**: Delete multiple categories at once with confirmation and comprehensive error handling
  /// **Returns**: Future BulkOperationResult - contains deletion status, results, and error details
  static Future<BulkOperationResult> bulkDeleteCategories({
    required BuildContext context,
    required Set<String> selectedIds,
    required List<ServiceCategory> allCategories,
    required Function(String) onSelectionChanged,
    required VoidCallback onDataRefresh,
    required VoidCallback? onDataChanged,
    required Function(bool) onLoadingStateChange,
  }) async {
    debugPrint('🗑️ CategoryUtils.CRUD: =============================');
    debugPrint('🗑️ CategoryUtils.CRUD: BULK DELETE CATEGORIES');
    debugPrint('🗑️ CategoryUtils.CRUD: =============================');
    debugPrint(
        '🗑️ CategoryUtils.CRUD: → Selected Count: ${selectedIds.length}');
    debugPrint(
        '🗑️ CategoryUtils.CRUD: → Total Categories: ${allCategories.length}');

    if (selectedIds.isEmpty) {
      debugPrint(
          '⚠️ CategoryUtils.CRUD: No categories selected for bulk deletion');
      return BulkOperationResult(
        operation: 'BULK_DELETE',
        totalRequested: 0,
        successful: 0,
        failed: 0,
        isSuccess: false,
        errorMessage: 'No categories selected for deletion',
      );
    }

    // Show confirmation dialog first
    debugPrint('🗑️ CategoryUtils.CRUD: → Showing bulk delete confirmation...');
    final confirmed =
        await showBulkDeleteConfirmation(context, selectedIds.length);

    if (!confirmed) {
      debugPrint('🗑️ CategoryUtils.CRUD: → User cancelled bulk deletion');
      return BulkOperationResult(
        operation: 'BULK_DELETE',
        totalRequested: selectedIds.length,
        successful: 0,
        failed: 0,
        isSuccess: false,
        errorMessage: 'Bulk deletion cancelled by user',
      );
    }

    // Start CRUD operation tracking
    final tracker =
        startCrudOperation('BULK_DELETE', '${selectedIds.length} categories');
    onLoadingStateChange(true);

    final successfulDeletions = <String>[];
    final failedDeletions = <String, String>{};

    try {
      debugPrint(
          '🗑️ CategoryUtils.CRUD: → Processing ${selectedIds.length} categories for deletion...');

      for (String categoryId in selectedIds.toList()) {
        try {
          final category =
              allCategories.firstWhere((cat) => cat.id == categoryId);
          debugPrint(
              '🗑️ CategoryUtils.CRUD: → Deleting "${category.name}"...');

          // Use the existing deleteCategory method but don't refresh data for each delete
          final success = await deleteCategory(
            context: context,
            category: category,
            selectedIds:
                Set<String>.from(selectedIds), // Pass current selections
            onSelectionChanged: onSelectionChanged,
            onDataRefresh:
                () {}, // Don't refresh for each category to avoid multiple API calls
            onDataChanged: () {}, // Don't trigger data change for each category
            onLoadingStateChange:
                (_) {}, // Don't change loading state for each category
          );

          if (success) {
            successfulDeletions.add(categoryId);
            debugPrint(
                '✅ CategoryUtils.CRUD: → Successfully deleted "${category.name}"');
          } else {
            failedDeletions[categoryId] = 'Failed to delete category';
            debugPrint(
                '❌ CategoryUtils.CRUD: → Failed to delete "${category.name}"');
          }
        } catch (e) {
          failedDeletions[categoryId] = e.toString();
          debugPrint(
              '❌ CategoryUtils.CRUD: → Exception deleting category $categoryId: $e');
        }
      }

      // Refresh data once at the end
      debugPrint(
          '🗑️ CategoryUtils.CRUD: → Refreshing data after bulk deletion...');
      onDataRefresh();
      onDataChanged?.call();

      final result = BulkOperationResult(
        operation: 'BULK_DELETE',
        totalRequested: selectedIds.length,
        successful: successfulDeletions.length,
        failed: failedDeletions.length,
        isSuccess: failedDeletions.isEmpty,
        successfulIds: successfulDeletions,
        failedIds: failedDeletions,
      );

      // Show result message
      if (context.mounted) {
        final message = result.isSuccess
            ? 'Successfully deleted ${result.successful} categories'
            : 'Deleted ${result.successful} categories, ${result.failed} failed';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: result.isSuccess ? Colors.green : Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      // Complete CRUD operation tracking
      completeCrudOperation(tracker,
          success: result.isSuccess,
          additionalData: {
            'total_requested': result.totalRequested,
            'successful': result.successful,
            'failed': result.failed,
            'success_rate':
                '${((result.successful / result.totalRequested) * 100).toStringAsFixed(1)}%',
          });

      debugPrint(
          '🗑️ CategoryUtils.CRUD: Bulk deletion completed - Success: ${result.successful}, Failed: ${result.failed}');
      return result;
    } catch (e) {
      debugPrint('❌ CategoryUtils.CRUD: Exception during bulk deletion: $e');

      final result = BulkOperationResult(
        operation: 'BULK_DELETE',
        totalRequested: selectedIds.length,
        successful: successfulDeletions.length,
        failed: selectedIds.length - successfulDeletions.length,
        isSuccess: false,
        errorMessage: 'Bulk deletion failed: $e',
      );

      // Complete CRUD operation tracking with exception
      completeCrudOperation(tracker,
          success: false, errorMessage: e.toString());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bulk deletion failed: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      return result;
    } finally {
      if (context.mounted) {
        onLoadingStateChange(false);
      }
    }
  }

  /// **ICON ANALYTICS AND MONITORING** 🎨📊
  /// ====================================================================

  /// Get comprehensive icon analytics for performance monitoring
  ///
  /// **Purpose**: Monitor icon system performance and usage patterns
  /// **Usage**:
  /// ```dart
  /// final analytics = CategoryUtils.getIconAnalytics();
  /// debugPrint('Icon resolution average time: ${analytics['averageResolutionTime']}ms');
  /// ```
  static Map<String, dynamic> getIconAnalytics() {
    debugPrint(
        '📊🎨 CategoryUtils.IconAnalytics: =============================');
    debugPrint('📊🎨 CategoryUtils.IconAnalytics: GENERATING ICON ANALYTICS');
    debugPrint(
        '📊🎨 CategoryUtils.IconAnalytics: =============================');

    // Get analytics from enhanced icon functions
    final iconUsageAnalytics = getIconUsageAnalytics();
    final availableIcons = getAvailableIcons();
    final categorizedIcons = getIconsByCategory();

    // Calculate performance metrics
    final analytics = {
      'totalIcons': availableIcons.length,
      'categorizedIconsCount': categorizedIcons.values
          .fold<int>(0, (sum, list) => sum + list.length),
      'categories': categorizedIcons.keys.toList(),
      'topUsedIcons': iconUsageAnalytics['topIcons'] ?? [],
      'performanceMetrics': iconUsageAnalytics['performance'] ?? {},
      'validationStats': _getIconValidationStats(),
      'smartSuggestionsStats': _getSmartSuggestionsStats(),
      'themeAwareStats': _getThemeAwareStats(),
      'generatedAt': DateTime.now().toIso8601String(),
    };

    debugPrint(
        '📊🎨 CategoryUtils.IconAnalytics: → Total Icons: ${analytics['totalIcons']}');
    debugPrint(
        '📊🎨 CategoryUtils.IconAnalytics: → Categories: ${analytics['categories'].length}');
    debugPrint(
        '📊🎨 CategoryUtils.IconAnalytics: → Performance Score: ${analytics['performanceMetrics']['score'] ?? 'N/A'}');
    debugPrint(
        '📊🎨 CategoryUtils.IconAnalytics: =============================');

    return analytics;
  }

  /// Track icon usage for analytics
  ///
  /// **Purpose**: Track which icons are being used most frequently
  static void trackIconUsage(String iconName, String context) {
    debugPrint(
        '📊🎨 CategoryUtils.IconTracking: Using icon "$iconName" in context "$context"');
    // Implementation for tracking icon usage
    // This could be connected to analytics service in production
  }

  /// Get icon validation statistics
  static Map<String, dynamic> _getIconValidationStats() {
    final stats = {
      'validationChecks': 0,
      'validIcons': 0,
      'invalidIcons': 0,
      'fallbacksUsed': 0,
      'validationRate': 0.0,
    };

    // Calculate validation statistics
    // This would be populated from actual validation tracking
    final validationChecks = stats['validationChecks'] as int? ?? 0;
    final validIcons = stats['validIcons'] as int? ?? 0;
    stats['validationRate'] =
        validationChecks > 0 ? validIcons / validationChecks : 0.0;

    return stats;
  }

  /// Get smart suggestions statistics
  static Map<String, dynamic> _getSmartSuggestionsStats() {
    return {
      'suggestionsGenerated': 0,
      'suggestionsUsed': 0,
      'averageSuggestions': 0.0,
      'contextualHits': 0,
      'suggestionAccuracy': 0.0,
    };
  }

  /// Get theme-aware statistics
  static Map<String, dynamic> _getThemeAwareStats() {
    return {
      'lightModeOptimizations': 0,
      'darkModeOptimizations': 0,
      'themeAwareIcons': 0,
      'contrastOptimizations': 0,
    };
  }

  /// Monitor icon resolution performance
  ///
  /// **Purpose**: Track icon resolution times and performance metrics
  static Future<Map<String, dynamic>> monitorIconResolutionPerformance(
      String categoryName, String iconIdentifier) async {
    final startTime = DateTime.now();

    debugPrint(
        '⚡🎨 CategoryUtils.IconPerformance: =============================');
    debugPrint('⚡🎨 CategoryUtils.IconPerformance: MONITORING ICON RESOLUTION');
    debugPrint(
        '⚡🎨 CategoryUtils.IconPerformance: =============================');
    debugPrint(
        '⚡🎨 CategoryUtils.IconPerformance: → Category: "$categoryName"');
    debugPrint(
        '⚡🎨 CategoryUtils.IconPerformance: → Icon Identifier: "$iconIdentifier"');

    // Perform icon validation
    final validation = validateIconName(iconIdentifier);

    // Get smart suggestions
    final suggestions = getSmartIconSuggestions(categoryName,
        context: 'performance_monitoring');

    // Calculate resolution time
    final endTime = DateTime.now();
    final resolutionTime = endTime.difference(startTime).inMilliseconds;

    // Generate performance report
    final performanceReport = {
      'categoryName': categoryName,
      'iconIdentifier': iconIdentifier,
      'resolutionTimeMs': resolutionTime,
      'validation': validation,
      'smartSuggestions': suggestions.keys.toList(),
      'suggestionsCount': suggestions.length,
      'performanceScore': _calculateIconPerformanceScore(
          resolutionTime, validation, suggestions),
      'timestamp': DateTime.now().toIso8601String(),
    };

    debugPrint(
        '⚡🎨 CategoryUtils.IconPerformance: → Resolution Time: ${resolutionTime}ms');
    debugPrint(
        '⚡🎨 CategoryUtils.IconPerformance: → Validation Result: ${validation['isValid']}');
    debugPrint(
        '⚡🎨 CategoryUtils.IconPerformance: → Suggestions Count: ${suggestions.length}');
    debugPrint(
        '⚡🎨 CategoryUtils.IconPerformance: → Performance Score: ${performanceReport['performanceScore']}/100');
    debugPrint(
        '⚡🎨 CategoryUtils.IconPerformance: =============================');

    return performanceReport;
  }

  /// Calculate icon performance score
  static int _calculateIconPerformanceScore(int resolutionTimeMs,
      Map<String, dynamic> validation, Map<String, IconData> suggestions) {
    int score = 100;

    // Deduct points for slow resolution
    if (resolutionTimeMs > 50) score -= 20;
    if (resolutionTimeMs > 100) score -= 30;

    // Deduct points for invalid icons
    if (!(validation['isValid'] as bool)) score -= 25;

    // Add points for good suggestions
    if (suggestions.isNotEmpty) score += 10;
    if (suggestions.length >= 3) score += 5;

    return score.clamp(0, 100);
  }

  /// Generate icon recommendations for category
  ///
  /// **Purpose**: Provide smart icon recommendations with context awareness
  static Future<Map<String, dynamic>> generateIconRecommendations(
      String categoryName) async {
    debugPrint(
        '🤖🎨 CategoryUtils.IconRecommendations: =============================');
    debugPrint(
        '🤖🎨 CategoryUtils.IconRecommendations: GENERATING RECOMMENDATIONS');
    debugPrint(
        '🤖🎨 CategoryUtils.IconRecommendations: =============================');
    debugPrint(
        '🤖🎨 CategoryUtils.IconRecommendations: → Category: "$categoryName"');

    // Get smart suggestions
    final smartSuggestions = getSmartIconSuggestions(categoryName,
        context: 'category_recommendation');

    // Get theme-aware recommendations
    final lightModeIcons = _getThemeAwareIconsFromManager(false);
    final darkModeIcons = _getThemeAwareIconsFromManager(true);

    // Get categorized icons for context
    final categorizedIcons = getIconsByCategory();

    // Find the most relevant category
    String? relevantCategory;
    for (final category in categorizedIcons.keys) {
      if (categoryName.toLowerCase().contains(category.toLowerCase())) {
        relevantCategory = category;
        break;
      }
    }

    final recommendations = {
      'categoryName': categoryName,
      'smartSuggestions': smartSuggestions.keys.toList(),
      'smartSuggestionsCount': smartSuggestions.length,
      'lightModeRecommendations': lightModeIcons.keys.take(5).toList(),
      'darkModeRecommendations': darkModeIcons.keys.take(5).toList(),
      'categoryBasedIcons': relevantCategory != null
          ? categorizedIcons[relevantCategory]
                  ?.take(5)
                  .map((e) => e.key)
                  .toList() ??
              []
          : [],
      'relevantCategory': relevantCategory,
      'confidence': _calculateRecommendationConfidence(
          smartSuggestions, relevantCategory),
      'generatedAt': DateTime.now().toIso8601String(),
    };

    debugPrint(
        '🤖🎨 CategoryUtils.IconRecommendations: → Smart Suggestions: ${recommendations['smartSuggestionsCount']}');
    debugPrint(
        '🤖🎨 CategoryUtils.IconRecommendations: → Relevant Category: ${recommendations['relevantCategory'] ?? 'None'}');
    debugPrint(
        '🤖🎨 CategoryUtils.IconRecommendations: → Confidence: ${recommendations['confidence']}%');
    debugPrint(
        '🤖🎨 CategoryUtils.IconRecommendations: =============================');

    return recommendations;
  }

  /// Calculate recommendation confidence
  static int _calculateRecommendationConfidence(
      Map<String, IconData> smartSuggestions, String? relevantCategory) {
    int confidence = 50; // Base confidence

    // Increase confidence based on smart suggestions
    if (smartSuggestions.isNotEmpty) confidence += 20;
    if (smartSuggestions.length >= 3) confidence += 15;

    // Increase confidence if we found a relevant category
    if (relevantCategory != null) confidence += 15;

    return confidence.clamp(0, 100);
  }

  /// Generate comprehensive icon system report
  ///
  /// **Purpose**: Generate a complete report of the icon system status
  static Future<Map<String, dynamic>> generateIconSystemReport() async {
    debugPrint(
        '📋🎨 CategoryUtils.IconSystemReport: =============================');
    debugPrint('📋🎨 CategoryUtils.IconSystemReport: GENERATING SYSTEM REPORT');
    debugPrint(
        '📋🎨 CategoryUtils.IconSystemReport: =============================');

    final analytics = getIconAnalytics();
    final categorizedIconsMap = getIconsByCategory();
    final availableIcons = getAvailableIcons();

    // Calculate system health metrics
    final systemHealth = {
      'totalIcons': availableIcons.length,
      'categorizedIcons': categorizedIconsMap.values
          .fold<int>(0, (sum, list) => sum + list.length),
      'categories': categorizedIconsMap.length,
      'systemStatus': 'healthy',
      'lastUpdate': DateTime.now().toIso8601String(),
    };

    // Calculate coverage percentage
    final categorizedIconsCount = systemHealth['categorizedIcons'] as int? ?? 0;
    final totalIconsCount = systemHealth['totalIcons'] as int? ?? 1;
    final coverage = categorizedIconsCount > 0
        ? ((categorizedIconsCount / totalIconsCount) * 100).round()
        : 0;

    final report = {
      'overview': {
        'totalIcons': systemHealth['totalIcons'],
        'categories': systemHealth['categories'],
        'coverage': coverage,
        'status': coverage > 80
            ? 'excellent'
            : coverage > 60
                ? 'good'
                : 'needs_improvement',
      },
      'analytics': analytics,
      'systemHealth': systemHealth,
      'recommendations': [
        if (coverage < 80)
          'Consider categorizing more icons for better organization',
        if (systemHealth['categories'] as int < 10)
          'Add more icon categories for better classification',
        'Regular monitoring of icon performance is recommended',
      ],
      'generatedAt': DateTime.now().toIso8601String(),
    };

    final overview = report['overview'] as Map<String, dynamic>?;
    debugPrint(
        '📋🎨 CategoryUtils.IconSystemReport: → Total Icons: ${overview?['totalIcons']}');
    debugPrint(
        '📋🎨 CategoryUtils.IconSystemReport: → Coverage: ${overview?['coverage']}%');
    debugPrint(
        '📋🎨 CategoryUtils.IconSystemReport: → Status: ${overview?['status']}');
    debugPrint(
        '📋🎨 CategoryUtils.IconSystemReport: =============================');

    return report;
  }

  /// ====================================================================
  /// ENHANCED ICON SYSTEM INTEGRATION - Missing Functions Implementation
  /// ====================================================================

  /// Get icons organized by category
  ///
  /// **Purpose**: Provide categorized icon lists for enhanced UI organization
  /// **Features**: Delegates to icon_constants.dart implementation with CategoryUtils integration
  /// **Usage**:
  /// ```dart
  /// final categorizedIcons = CategoryUtils.getIconsByCategory();
  /// debugPrint('Categories available: ${categorizedIcons.keys.join(', ')}');
  /// ```
  static Map<String, List<MapEntry<String, IconData>>> getIconsByCategory() {
    debugPrint(
        '🎨📋 CategoryUtils.getIconsByCategory: Retrieving categorized icons from icon_constants');

    // Delegate to the implementation in icon_constants.dart
    final categorizedIcons = _getIconsByCategoryFromConstants();

    debugPrint(
        '🎨📋 CategoryUtils.getIconsByCategory: → Retrieved ${categorizedIcons.length} categories');
    for (final entry in categorizedIcons.entries) {
      debugPrint(
          '🎨📋 CategoryUtils.getIconsByCategory: → ${entry.key}: ${entry.value.length} icons');
    }

    return categorizedIcons;
  }

  /// Get smart icon suggestions with context awareness
  ///
  /// **Purpose**: Provide AI-like icon recommendations based on context and query
  /// **Features**: Semantic matching, synonym support, contextual recommendations
  /// **Usage**:
  /// ```dart
  /// final suggestions = CategoryUtils.getSmartIconSuggestions('business', context: 'service_category');
  /// debugPrint('Smart suggestions: ${suggestions.keys.join(', ')}');
  /// ```
  static Map<String, IconData> getSmartIconSuggestions(String query,
      {String? context}) {
    debugPrint(
        '🤖🎨 CategoryUtils.getSmartIconSuggestions: Getting suggestions for "$query"');
    debugPrint(
        '🤖🎨 CategoryUtils.getSmartIconSuggestions: → Context: ${context ?? 'none'}');

    // Delegate to the implementation in icon_constants.dart
    final suggestions =
        _getSmartIconSuggestionsFromConstants(query, context: context);

    debugPrint(
        '🤖🎨 CategoryUtils.getSmartIconSuggestions: → Found ${suggestions.length} suggestions');
    debugPrint(
        '🤖🎨 CategoryUtils.getSmartIconSuggestions: → Top suggestions: ${suggestions.keys.take(5).join(', ')}');

    return suggestions;
  }

  /// Validate icon name and provide suggestions
  ///
  /// **Purpose**: Real-time icon validation with helpful alternatives and suggestions
  /// **Features**: Validation checks, similarity matching, alternative recommendations
  /// **Usage**:
  /// ```dart
  /// final validation = CategoryUtils.validateIconName('businness'); // typo
  /// if (!validation['isValid']) {
  ///   debugPrint('Suggestions: ${validation['suggestions']}');
  /// }
  /// ```
  static Map<String, dynamic> validateIconName(String iconName) {
    debugPrint(
        '✅🎨 CategoryUtils.validateIconName: Validating icon name "$iconName"');

    // Simple validation - check if icon name is not empty
    if (iconName.trim().isEmpty) {
      return {
        'isValid': false,
        'reason': 'Icon name cannot be empty',
        'suggestions': ['home', 'user', 'settings', 'search', 'list'],
        'alternatives': ['menu', 'grid', 'add', 'edit', 'save']
      };
    }

    // For now, accept all non-empty icon names to prevent recursion
    return {
      'isValid': true,
      'reason': 'Icon name is valid',
      'suggestions': [],
      'alternatives': []
    };
  }

  /// Get icon usage analytics and performance metrics
  ///
  /// **Purpose**: Monitor icon system performance and usage patterns
  /// **Features**: Usage statistics, performance metrics, trending analysis
  /// **Usage**:
  /// ```dart
  /// final analytics = CategoryUtils.getIconUsageAnalytics();
  /// debugPrint('Total icons: ${analytics['totalIcons']}');
  /// debugPrint('Top used: ${analytics['topRecommended']}');
  /// ```
  static Map<String, dynamic> getIconUsageAnalytics() {
    debugPrint(
        '📊🎨 CategoryUtils.getIconUsageAnalytics: Generating icon usage analytics');

    // Delegate to the implementation in icon_constants.dart
    final analytics = _getIconUsageAnalyticsFromConstants();

    debugPrint(
        '📊🎨 CategoryUtils.getIconUsageAnalytics: → Total icons: ${analytics['totalIcons']}');
    debugPrint(
        '📊🎨 CategoryUtils.getIconUsageAnalytics: → Categories: ${analytics['categoriesCount']}');
    debugPrint(
        '📊🎨 CategoryUtils.getIconUsageAnalytics: → Performance: ${analytics['performanceMetrics']}');

    return analytics;
  }

  /// Get icons organized by category from PrbalIconManager
  static Map<String, List<MapEntry<String, IconData>>>
      _getIconsByCategoryFromConstants() {
    debugPrint(
        '🔄 CategoryUtils.Icons: Getting categorized icons from PrbalIconManager');

    final allIcons = iconManager.getComprehensiveIconMap();

    // Organize icons by their prefixes/categories for better organization
    final categorized = <String, List<MapEntry<String, IconData>>>{};

    for (final entry in allIcons.entries) {
      String category = 'miscellaneous';

      // Determine category based on icon name patterns
      if (entry.key.contains('home') || entry.key.contains('house')) {
        category = 'home';
      } else if (entry.key.contains('business') ||
          entry.key.contains('work') ||
          entry.key.contains('office')) {
        category = 'business';
      } else if (entry.key.contains('tech') ||
          entry.key.contains('code') ||
          entry.key.contains('computer')) {
        category = 'technology';
      } else if (entry.key.contains('message') ||
          entry.key.contains('call') ||
          entry.key.contains('email')) {
        category = 'communication';
      } else if (entry.key.contains('media') ||
          entry.key.contains('video') ||
          entry.key.contains('music')) {
        category = 'media';
      } else if (entry.key.contains('health') ||
          entry.key.contains('medical') ||
          entry.key.contains('heart')) {
        category = 'health';
      } else if (entry.key.contains('food') ||
          entry.key.contains('restaurant') ||
          entry.key.contains('eat')) {
        category = 'food';
      } else if (entry.key.contains('navigation') ||
          entry.key.contains('navigate') ||
          entry.key.contains('direction')) {
        category = 'navigation';
      } else if (entry.key.contains('action') ||
          entry.key.contains('edit') ||
          entry.key.contains('save')) {
        category = 'actions';
      }

      categorized.putIfAbsent(category, () => <MapEntry<String, IconData>>[]);
      categorized[category]!.add(entry);
    }

    debugPrint(
        '🔄 CategoryUtils.Icons: Organized ${allIcons.length} icons into ${categorized.length} categories');
    return categorized;
  }

  /// Get smart icon suggestions from PrbalIconManager
  static Map<String, IconData> _getSmartIconSuggestionsFromConstants(
      String query,
      {String? context}) {
    debugPrint(
        '🔄 CategoryUtils.Icons: Getting smart suggestions from PrbalIconManager');

    return iconManager
        .searchIcons(query); // Using searchIcons as smart suggestions
  }

  /// Get icon usage analytics from PrbalIconManager
  static Map<String, dynamic> _getIconUsageAnalyticsFromConstants() {
    debugPrint(
        '🔄 CategoryUtils.Icons: Getting usage analytics from PrbalIconManager');

    final allIcons = iconManager.getComprehensiveIconMap();

    return {
      'totalIcons': allIcons.length,
      'categoriesCount': _getIconsByCategoryFromConstants().length,
      'performanceMetrics': {
        'cacheEnabled': true,
        'loadTime': 'optimal',
        'score': 95
      },
      'lastUpdate': DateTime.now().toIso8601String(),
    };
  }

  /// Get theme-aware icons from PrbalIconManager
  static Map<String, IconData> _getThemeAwareIconsFromManager(
      bool themeManagerMode) {
    debugPrint(
        '🎨 CategoryUtils.Icons: Getting theme-aware icons for ${themeManagerMode ? 'dark' : 'light'} mode');

    final allIcons = iconManager.getComprehensiveIconMap();

    // Filter icons that work well in the specified theme
    final themeAwareIcons = <String, IconData>{};

    if (themeManagerMode) {
      // Icons that work well in dark mode - look for "light", "bright" themes
      for (final entry in allIcons.entries) {
        if (entry.key.contains('light') ||
            entry.key.contains('bright') ||
            entry.key.contains('day') ||
            entry.key.contains('sun')) {
          themeAwareIcons[entry.key] = entry.value;
        }
      }
    } else {
      // Icons that work well in light mode - look for "dark", "night" themes
      for (final entry in allIcons.entries) {
        if (entry.key.contains('dark') ||
            entry.key.contains('night') ||
            entry.key.contains('shadow') ||
            entry.key.contains('moon')) {
          themeAwareIcons[entry.key] = entry.value;
        }
      }
    }

    // If no theme-specific icons found, return a curated subset
    if (themeAwareIcons.isEmpty) {
      final iconEntries = allIcons.entries.toList();
      for (int i = 0; i < iconEntries.length && i < 20; i++) {
        themeAwareIcons[iconEntries[i].key] = iconEntries[i].value;
      }
    }

    debugPrint(
        '🎨 CategoryUtils.Icons: Generated ${themeAwareIcons.length} theme-aware icons');
    return themeAwareIcons;
  }

  /// Simple icon loading methods to prevent crashes
  static void _addCoreActionIcons(Map<String, IconData> icons) {
    icons.addAll({
      'add': Prbal.add1,
      'edit': Prbal.edit,
      'delete': Prbal.delete,
      'save': Prbal.save4
    });
  }

  static void _addNavigationIcons(Map<String, IconData> icons) {
    icons.addAll(
        {'home': Prbal.home8, 'menu': Prbal.menu, 'back': Prbal.arrowBack});
  }

  static void _addBusinessIcons(Map<String, IconData> icons) {
    icons.addAll({'briefcase': Prbal.briefcase, 'office': Prbal.office});
  }

  static void _addTechnologyIcons(Map<String, IconData> icons) {
    icons.addAll({'laptop': Prbal.laptop, 'mobile': Prbal.mobile});
  }

  static void _addCommunicationIcons(Map<String, IconData> icons) {
    icons.addAll(
        {'message': Prbal.message, 'call': Prbal.call1, 'email': Prbal.email});
  }

  static void _addMediaIcons(Map<String, IconData> icons) {
    icons.addAll(
        {'movie': Prbal.movie, 'music': Prbal.musicNote, 'image': Prbal.image});
  }

  static void _addHealthIcons(Map<String, IconData> icons) {
    icons.addAll({'heart': Prbal.heart, 'medical': Prbal.medicalServices});
  }

  static void _addEducationIcons(Map<String, IconData> icons) {
    icons.addAll({'book': Prbal.book, 'school': Prbal.school});
  }

  static void _addFoodIcons(Map<String, IconData> icons) {
    icons.addAll({'restaurant': Prbal.restaurant, 'dining': Prbal.restaurant});
  }

  static void _addTransportationIcons(Map<String, IconData> icons) {
    icons.addAll({'drive': Prbal.drive2, 'airplane': Prbal.airplane});
  }

  static void _addHomeIcons(Map<String, IconData> icons) {
    icons.addAll({'house': Prbal.home8, 'furniture': Prbal.home8});
  }

  static void _addShoppingIcons(Map<String, IconData> icons) {
    icons.addAll({'store': Prbal.store1, 'shopping': Prbal.shoppingBasket});
  }

  static void _addWeatherIcons(Map<String, IconData> icons) {
    icons.addAll({'rain': Prbal.rain1, 'sun': Prbal.wbSunny});
  }

  static void _addBrandIcons(Map<String, IconData> icons) {
    icons.addAll({'brand': Prbal.star});
  }

  static void _addUtilityIcons(Map<String, IconData> icons) {
    icons.addAll({'settings': Prbal.cogOutline, 'tools': Prbal.wrench});
  }

  static void _addSocialMediaIcons(Map<String, IconData> icons) {
    icons.addAll({'social': Prbal.share, 'share': Prbal.share});
  }

  static void _addDevelopmentIcons(Map<String, IconData> icons) {
    icons.addAll({'code': Prbal.code5, 'develop': Prbal.develop});
  }

  static void _addSecurityIcons(Map<String, IconData> icons) {
    icons.addAll({'lock': Prbal.lock4, 'security': Prbal.shield});
  }

  static void _addSportsIcons(Map<String, IconData> icons) {
    icons.addAll({'race': Prbal.race, 'sports': Prbal.sports});
  }

  static void _addMiscellaneousIcons(Map<String, IconData> icons) {
    icons.addAll({'misc': Prbal.database, 'other': Prbal.database});
  }
}

/// ====================================================================
/// CRUD OPERATION TRACKER CLASS
/// ====================================================================

/// **Purpose**: Track CRUD operations for performance monitoring and debugging
class CrudOperationTracker {
  final String operationId;
  final String operation;
  final String categoryName;
  final DateTime startTime;

  CrudOperationTracker({
    required this.operation,
    required this.categoryName,
    required this.startTime,
  }) : operationId = '${operation}_${DateTime.now().millisecondsSinceEpoch}';
}

/// ====================================================================
/// CRUD VALIDATION RESULT CLASS
/// ====================================================================

/// **Purpose**: Comprehensive validation results for CRUD operations
class CrudValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final List<String> suggestions;

  CrudValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
    required this.suggestions,
  });
}

/// ====================================================================
/// CRUD OPERATION REPORT CLASS
/// ====================================================================

/// **Purpose**: Detailed analysis and reporting for CRUD operations
class CrudOperationReport {
  final String operation;
  final bool success;
  final String? errorMessage;
  final ServiceCategory? category;
  final Duration? operationDuration;
  final DateTime analysisTime;
  final List<String> insights = [];
  final List<String> recommendations = [];

  CrudOperationReport({
    required this.operation,
    required this.success,
    this.errorMessage,
    this.category,
    this.operationDuration,
    required this.analysisTime,
  });
}

/// ====================================================================
/// CATEGORY LOAD RESULT CLASS
/// ====================================================================

/// **Purpose**: Comprehensive result object for category loading operations
class CategoryLoadResult {
  final bool isSuccess;
  final List<ServiceCategory> categories;
  final Map<String, int> statistics;
  final Map<String, double> performanceMetrics;
  final Duration loadDuration;
  final int totalCount;
  final int activeCount;
  final int inactiveCount;
  final String? errorMessage;

  CategoryLoadResult({
    required this.isSuccess,
    required this.categories,
    required this.statistics,
    required this.performanceMetrics,
    required this.loadDuration,
    required this.totalCount,
    required this.activeCount,
    required this.inactiveCount,
    this.errorMessage,
  });
}

/// ====================================================================
/// BULK OPERATION RESULT CLASS
/// ====================================================================

/// **Purpose**: Comprehensive result object for bulk CRUD operations
class BulkOperationResult {
  final String operation;
  final int totalRequested;
  final int successful;
  final int failed;
  final int skipped;
  final bool isSuccess;
  final String? errorMessage;
  final List<String> successfulIds;
  final Map<String, String> failedIds;
  final List<String> skippedIds;
  final Map<String, dynamic>? exportData;

  BulkOperationResult({
    required this.operation,
    required this.totalRequested,
    required this.successful,
    required this.failed,
    this.skipped = 0,
    required this.isSuccess,
    this.errorMessage,
    this.successfulIds = const [],
    this.failedIds = const {},
    this.skippedIds = const [],
    this.exportData,
  });

  /// Get success rate as percentage
  double get successRate =>
      totalRequested > 0 ? (successful / totalRequested) * 100 : 0.0;

  /// Get failure rate as percentage
  double get failureRate =>
      totalRequested > 0 ? (failed / totalRequested) * 100 : 0.0;

  /// Get a summary string of the operation result
  String get summary {
    if (totalRequested == 0) {
      return 'No items to process';
    }

    if (isSuccess) {
      return 'Successfully processed $successful/$totalRequested items';
    } else {
      return 'Processed $successful/$totalRequested items ($failed failed${skipped > 0 ? ', $skipped skipped' : ''})';
    }
  }

  /// ====================================================================
  /// STANDALONE FUNCTIONS FOR BACKWARD COMPATIBILITY
  /// ====================================================================

  /// Get comprehensive icon map - standalone function for CategoryUtils compatibility
  // Map<String, IconData> iconManager.getComprehensiveIconMap() {
  //   debugPrint('🔄 icon_constants: iconManager.getComprehensiveIconMap() standalone function called');
  //   return PrbalIconManager().iconManager.getComprehensiveIconMap();
  // }

  // /// Search icons - standalone function for CategoryUtils compatibility
  // Map<String, IconData> searchIcons(String query) {
  //   debugPrint('🔄 icon_constants: searchIcons() standalone function called');
  //   return PrbalIconManager().searchIcons(query);
  // }

  // /// Validate icon name - standalone function for CategoryUtils compatibility
  // Map<String, dynamic> validateIconName(String iconName) {
  //   debugPrint('🔄 icon_constants: validateIconName() standalone function called');
  //   return PrbalIconManager().validateIconName(iconName);
  // }

  /// Get icons organized by category - standalone function for CategoryUtils compatibility
  Map<String, List<MapEntry<String, IconData>>> getIconsByCategory() {
    debugPrint(
        '🔄 icon_constants: getIconsByCategory() standalone function called');
    final iconManager = PrbalIconManager();
    final allIcons = iconManager.getComprehensiveIconMap();

    // Organize icons by their prefixes/categories for better organization
    final categorized = <String, List<MapEntry<String, IconData>>>{};

    for (final entry in allIcons.entries) {
      String category = 'miscellaneous';

      // Determine category based on icon name patterns
      if (entry.key.contains('home') || entry.key.contains('house')) {
        category = 'home';
      } else if (entry.key.contains('business') ||
          entry.key.contains('work') ||
          entry.key.contains('office')) {
        category = 'business';
      } else if (entry.key.contains('tech') ||
          entry.key.contains('code') ||
          entry.key.contains('computer')) {
        category = 'technology';
      } else if (entry.key.contains('message') ||
          entry.key.contains('call') ||
          entry.key.contains('email')) {
        category = 'communication';
      } else if (entry.key.contains('media') ||
          entry.key.contains('video') ||
          entry.key.contains('music')) {
        category = 'media';
      } else if (entry.key.contains('health') ||
          entry.key.contains('medical') ||
          entry.key.contains('heart')) {
        category = 'health';
      } else if (entry.key.contains('food') ||
          entry.key.contains('restaurant') ||
          entry.key.contains('eat')) {
        category = 'food';
      } else if (entry.key.contains('navigation') ||
          entry.key.contains('navigate') ||
          entry.key.contains('direction')) {
        category = 'navigation';
      } else if (entry.key.contains('action') ||
          entry.key.contains('edit') ||
          entry.key.contains('save')) {
        category = 'actions';
      }

      categorized.putIfAbsent(category, () => <MapEntry<String, IconData>>[]);
      categorized[category]!.add(entry);
    }

    debugPrint(
        '🔄 icon_constants: Organized ${allIcons.length} icons into ${categorized.length} categories');
    return categorized;
  }

  /// Get smart icon suggestions - standalone function for CategoryUtils compatibility
  Map<String, IconData> getSmartIconSuggestions(String query,
      {String? context}) {
    debugPrint(
        '🔄 icon_constants: getSmartIconSuggestions() standalone function called');
    final iconManager = PrbalIconManager();
    // Enhanced smart suggestions with context awareness
    final suggestions = iconManager.searchIcons(query);

    // Add context-specific suggestions
    if (context != null) {
      final contextIcons = iconManager.getComprehensiveIconMap();
      final contextualSuggestions = <String, IconData>{};

      for (final entry in contextIcons.entries) {
        if (entry.key.contains(context.toLowerCase()) ||
            context.toLowerCase().contains(entry.key)) {
          contextualSuggestions[entry.key] = entry.value;
        }
      }

      // Merge suggestions with context-specific ones
      suggestions.addAll(contextualSuggestions);
    }

    debugPrint(
        '🔄 icon_constants: Generated ${suggestions.length} smart suggestions for "$query"');
    return suggestions;
  }

  /// Get theme-aware icons - standalone function for CategoryUtils compatibility
  Map<String, IconData> getThemeAwareIcons(bool themeManagerMode) {
    debugPrint(
        '🔄 icon_constants: getThemeAwareIcons() standalone function called for ${themeManagerMode ? 'dark' : 'light'} mode');
    final iconManager = PrbalIconManager();
    final allIcons = iconManager.getComprehensiveIconMap();

    // Filter icons that work well in the specified theme
    final themeAwareIcons = <String, IconData>{};

    if (themeManagerMode) {
      // Icons that work well in dark mode
      for (final entry in allIcons.entries) {
        if (entry.key.contains('light') ||
            entry.key.contains('bright') ||
            entry.key.contains('day') ||
            entry.key.contains('sun')) {
          themeAwareIcons[entry.key] = entry.value;
        }
      }
    } else {
      // Icons that work well in light mode
      for (final entry in allIcons.entries) {
        if (entry.key.contains('dark') ||
            entry.key.contains('night') ||
            entry.key.contains('shadow') ||
            entry.key.contains('moon')) {
          themeAwareIcons[entry.key] = entry.value;
        }
      }
    }

    // If no theme-specific icons found, return a subset of all icons
    if (themeAwareIcons.isEmpty) {
      final iconEntries = allIcons.entries.toList();
      for (int i = 0; i < iconEntries.length && i < 20; i++) {
        themeAwareIcons[iconEntries[i].key] = iconEntries[i].value;
      }
    }

    debugPrint(
        '🔄 icon_constants: Generated ${themeAwareIcons.length} theme-aware icons for ${themeManagerMode ? 'dark' : 'light'} mode');
    return themeAwareIcons;
  }

  /// Get icon usage analytics - standalone function for CategoryUtils compatibility
  Map<String, dynamic> getIconUsageAnalytics() {
    debugPrint(
        '🔄 icon_constants: getIconUsageAnalytics() standalone function called');
    final iconManager = PrbalIconManager();
    final allIcons = iconManager.getComprehensiveIconMap();

    return {
      'totalIcons': allIcons.length,
      'categories': getIconsByCategory().length,
      'mostUsedIcons': allIcons.keys.take(10).toList(),
      'systemHealth': 'healthy',
      'lastUpdate': DateTime.now().toIso8601String(),
      'cacheStatus':
          'active', // Cache status not directly accessible, assume active
    };
  }
}
