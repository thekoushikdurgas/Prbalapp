import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prbal/services/service_management_service.dart';

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

  /// Initialize the global ServiceManagementService instance
  ///
  /// **Purpose**: Set up the global service instance for use across all CategoryUtils functions
  /// **Usage**:
  /// ```dart
  /// CategoryUtils.initialize(serviceManagementService);
  /// ```
  static void initialize(ServiceManagementService serviceManagementService) {
    _serviceManagementService = serviceManagementService;
    debugPrint('🌐 CategoryUtils: Global ServiceManagementService initialized successfully');
    debugPrint('🌐 CategoryUtils: All CRUD functions can now use the global service instance');
  }

  /// Get the global ServiceManagementService instance
  ///
  /// **Purpose**: Provide access to the global service instance with error checking
  /// **Throws**: StateError if not initialized
  static ServiceManagementService get _service {
    if (_serviceManagementService == null) {
      throw StateError('CategoryUtils not initialized. Call CategoryUtils.initialize() first.');
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
  static CrudOperationTracker startCrudOperation(String operation, String categoryName) {
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
    debugPrint('🔄 CategoryUtils.CRUD: → Start Time: ${tracker.startTime.toIso8601String()}');
    debugPrint('🔄 CategoryUtils.CRUD: → Expected Steps: ${_getCrudSteps(operation).join(' → ')}');

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
    debugPrint('🔄 CategoryUtils.CRUD: COMPLETING ${tracker.operation} OPERATION');
    debugPrint('🔄 CategoryUtils.CRUD: =============================');
    debugPrint('🔄 CategoryUtils.CRUD: → Operation ID: ${tracker.operationId}');
    debugPrint('🔄 CategoryUtils.CRUD: → Category: "${tracker.categoryName}"');
    debugPrint('🔄 CategoryUtils.CRUD: → Success: ${success ? '✅ SUCCESS' : '❌ FAILED'}');
    debugPrint('🔄 CategoryUtils.CRUD: → Duration: ${duration.inMilliseconds}ms');
    debugPrint(
        '🔄 CategoryUtils.CRUD: → Performance Rating: ${_getCrudPerformanceRating(tracker.operation, duration)}');

    if (!success && errorMessage != null) {
      debugPrint('🔄 CategoryUtils.CRUD: → Error: $errorMessage');
      debugPrint('🔄 CategoryUtils.CRUD: → Error Category: ${_categorizeCrudError(errorMessage)}');
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
        return ['Check Cache', 'API Call (if needed)', 'Parse Response', 'Update UI'];
      case 'UPDATE':
        return ['Validate Changes', 'API Call', 'Cache Invalidation', 'UI Refresh'];
      case 'DELETE':
        return ['Confirm Action', 'API Call', 'Cache Cleanup', 'UI Update'];
      case 'BULK':
        return ['Validate Selection', 'Batch Processing', 'Progress Tracking', 'Bulk UI Update'];
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

    final operationThresholds = thresholds[operation.toUpperCase()] ?? thresholds['READ']!;

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

    if (message.contains('permission') || message.contains('unauthorized') || message.contains('403')) {
      return '🔒 PERMISSION_ERROR - Check user authorization';
    } else if (message.contains('validation') || message.contains('invalid') || message.contains('400')) {
      return '📝 VALIDATION_ERROR - Check input data';
    } else if (message.contains('not found') || message.contains('404')) {
      return '🔍 NOT_FOUND_ERROR - Resource may have been deleted';
    } else if (message.contains('network') || message.contains('timeout') || message.contains('connection')) {
      return '🌐 NETWORK_ERROR - Check internet connection';
    } else if (message.contains('server') || message.contains('500') || message.contains('internal')) {
      return '🖥️ SERVER_ERROR - Backend issue detected';
    } else if (message.contains('cache') || message.contains('storage')) {
      return '💾 CACHE_ERROR - Local storage issue';
    } else {
      return '❓ UNKNOWN_ERROR - Requires investigation';
    }
  }

  /// Get troubleshooting tips for CRUD operations
  static String _getCrudTroubleshootingTips(String operation, String errorMessage) {
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
  static void _logCrudMetrics(CrudOperationTracker tracker, Duration duration, bool success) {
    debugPrint('📊 CategoryUtils.CRUD.Metrics: ==================');
    debugPrint('📊 CategoryUtils.CRUD.Metrics: OPERATION METRICS');
    debugPrint('📊 CategoryUtils.CRUD.Metrics: ==================');
    debugPrint('📊 CategoryUtils.CRUD.Metrics: → Operation: ${tracker.operation}');
    debugPrint('📊 CategoryUtils.CRUD.Metrics: → Success Rate: ${success ? '100%' : '0%'}');
    debugPrint('📊 CategoryUtils.CRUD.Metrics: → Duration: ${duration.inMilliseconds}ms');
    debugPrint('📊 CategoryUtils.CRUD.Metrics: → Category: "${tracker.categoryName}"');
    debugPrint('📊 CategoryUtils.CRUD.Metrics: → Timestamp: ${DateTime.now().toIso8601String()}');

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
    debugPrint('✅ CategoryUtils.CRUD.Validation: Starting validation for $operation operation');
    debugPrint('✅ CategoryUtils.CRUD.Validation: → Name: ${name ?? 'N/A'}');
    debugPrint('✅ CategoryUtils.CRUD.Validation: → Description length: ${description?.length ?? 0}');
    debugPrint('✅ CategoryUtils.CRUD.Validation: → Sort order: ${sortOrder ?? 'N/A'}');
    debugPrint('✅ CategoryUtils.CRUD.Validation: → Is active: ${isActive ?? 'N/A'}');

    final errors = <String>[];
    final warnings = <String>[];
    final suggestions = <String>[];

    // Operation-specific validation
    switch (operation.toUpperCase()) {
      case 'CREATE':
        _validateCreateOperation(errors, warnings, suggestions, name, description, sortOrder, allCategories);
        break;
      case 'UPDATE':
        _validateUpdateOperation(
            errors, warnings, suggestions, name, description, sortOrder, existingCategory, allCategories);
        break;
      case 'DELETE':
        _validateDeleteOperation(errors, warnings, suggestions, existingCategory, allCategories);
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
    debugPrint('✅ CategoryUtils.CRUD.Validation: → Valid: ${isValid ? '✅ YES' : '❌ NO'}');
    debugPrint('✅ CategoryUtils.CRUD.Validation: → Errors: ${errors.length}');
    debugPrint('✅ CategoryUtils.CRUD.Validation: → Warnings: ${warnings.length}');
    debugPrint('✅ CategoryUtils.CRUD.Validation: → Suggestions: ${suggestions.length}');

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
      final existingNames = allCategories.map((c) => c.name.toLowerCase()).toList();
      if (existingNames.contains(name.toLowerCase())) {
        errors.add('Category name already exists. Please choose a different name.');
      }
    }

    // Sort order suggestions
    if (sortOrder == null || sortOrder == 0) {
      suggestions.add('Consider setting a specific sort order for better organization');
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
      final otherCategories = allCategories.where((c) => c.id != existingCategory.id);
      final existingNames = otherCategories.map((c) => c.name.toLowerCase()).toList();
      if (existingNames.contains(name.toLowerCase())) {
        errors.add('Category name already exists. Please choose a different name.');
      }
    }

    // Detect significant changes
    if (name != null && name != existingCategory.name) {
      warnings.add('Changing category name may affect related subcategories and services');
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
    warnings.add('Deleting this category will also affect related subcategories and services');
    suggestions.add('Consider deactivating instead of deleting to preserve data relationships');
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
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF374151) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                LineIcons.exclamationTriangle,
                color: Colors.red,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Confirm Deletion',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
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
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF4B5563) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      LineIcons.folder,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '"${category.name}"',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF2D3748),
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
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      LineIcons.infoCircle,
                      color: Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This action cannot be undone.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[700],
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
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
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
    debugPrint('🗑️ CategoryUtils.UI: Delete confirmation result: ${result ? '✅ CONFIRMED' : '❌ CANCELLED'}');

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
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF374151) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                LineIcons.exclamationTriangle,
                color: Colors.red,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Confirm Bulk Deletion',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
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
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF4B5563) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      LineIcons.layerGroup,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$selectedCount selected categories?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : const Color(0xFF2D3748),
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
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      LineIcons.infoCircle,
                      color: Colors.red,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This action cannot be undone.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[700],
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
                debugPrint('🗑️ CategoryUtils.UI: → User cancelled bulk deletion');
                Navigator.of(context).pop(false);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint('🗑️ CategoryUtils.UI: → User confirmed bulk deletion');
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
    debugPrint('🗑️ CategoryUtils.UI: Bulk delete confirmation result: ${result ? '✅ CONFIRMED' : '❌ CANCELLED'}');

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
    debugPrint('📋 CategoryUtils.CRUD.Analysis: → Success: ${success ? '✅' : '❌'}');
    debugPrint('📋 CategoryUtils.CRUD.Analysis: → Duration: ${operationDuration?.inMilliseconds ?? 'Unknown'}ms');

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

        final troubleshooting = _getCrudTroubleshootingTips(operation, errorMessage);
        report.recommendations.add(troubleshooting);
      }
    }

    // Add operation-specific insights
    _addOperationSpecificInsights(report, operation, success, category);

    debugPrint('📋 CategoryUtils.CRUD.Analysis: Analysis complete');
    debugPrint('📋 CategoryUtils.CRUD.Analysis: → Insights: ${report.insights.length}');
    debugPrint('📋 CategoryUtils.CRUD.Analysis: → Recommendations: ${report.recommendations.length}');

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
          report.insights.add('🆕 New category "${category.name}" created successfully');
          report.recommendations.add('Consider creating related subcategories for "${category.name}"');
        }
        break;
      case 'UPDATE':
        if (success && category != null) {
          report.insights.add('✏️ Category "${category.name}" updated successfully');
          if (!category.isActive) {
            report.recommendations.add('Category is currently inactive - consider activating if needed');
          }
        }
        break;
      case 'DELETE':
        if (success) {
          report.insights.add('🗑️ Category deleted successfully');
          report.recommendations.add('Review related subcategories and services that may be affected');
        }
        break;
    }
  }

  /// **Icon Utilities** 🎨
  /// ====================================================================

  /// Get icon from string representation
  ///
  /// **Purpose**: Convert string icon names to actual IconData
  /// **Usage**: CategoryUtils.getIconFromString('home') -> LineIcons.home
  /// **Debug**: Logs icon resolution attempts and fallbacks
  static IconData getIconFromString(String iconName) {
    debugPrint('🎨 CategoryUtils: Resolving icon for name: "$iconName"');

    final icon = switch (iconName.toLowerCase()) {
      'home' => LineIcons.home,
      'car' => LineIcons.car,
      'tools' => LineIcons.tools,
      'heart' => LineIcons.heart,
      'computer' => LineIcons.laptop,
      'health' => LineIcons.heartbeat,
      'education' => LineIcons.graduationCap,
      'food' => LineIcons.utensils,
      'shopping' => LineIcons.shoppingCart,
      'travel' => LineIcons.plane,
      'sports' => LineIcons.footballBall,
      'music' => LineIcons.music,
      'photography' => LineIcons.camera,
      'technology' => LineIcons.microchip,
      'finance' => LineIcons.dollarSign,
      _ => LineIcons.list, // Default fallback
    };

    if (iconName.toLowerCase() != 'list' && icon == LineIcons.list) {
      debugPrint('⚠️ CategoryUtils: Unknown icon "$iconName", using default list icon');
    } else {
      debugPrint('✅ CategoryUtils: Successfully resolved icon "$iconName"');
    }

    return icon;
  }

  /// Get available category icons with their names
  ///
  /// **Purpose**: Provide a list of all available icons for UI pickers
  /// **Returns**: Map of icon names to IconData
  static Map<String, IconData> getAvailableIcons() {
    debugPrint('📋 CategoryUtils: Generating available icons list');

    return {
      'home': LineIcons.home,
      'car': LineIcons.car,
      'tools': LineIcons.tools,
      'heart': LineIcons.heart,
      'computer': LineIcons.laptop,
      'health': LineIcons.heartbeat,
      'education': LineIcons.graduationCap,
      'food': LineIcons.utensils,
      'shopping': LineIcons.shoppingCart,
      'travel': LineIcons.plane,
      'sports': LineIcons.footballBall,
      'music': LineIcons.music,
      'photography': LineIcons.camera,
      'technology': LineIcons.microchip,
      'finance': LineIcons.dollarSign,
      'list': LineIcons.list,
    };
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
    debugPrint('📅 CategoryUtils: Difference: ${difference.inDays} days, ${difference.inHours} hours');

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
    debugPrint('📅 CategoryUtils: Formatting full date: ${date.toIso8601String()}');

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
  /// **Returns**: Color based on active state and theme mode
  static Color getStatusColor(bool isActive, bool isDark) {
    debugPrint('🎨 CategoryUtils: Getting status color for active=$isActive, isDark=$isDark');

    final Color color;
    if (isActive) {
      color = isDark ? const Color(0xFF10B981) : const Color(0xFF059669); // Green
      debugPrint('🎨 CategoryUtils: Using active (green) color');
    } else {
      color = isDark ? const Color(0xFFF59E0B) : const Color(0xFFD97706); // Orange/Yellow
      debugPrint('🎨 CategoryUtils: Using inactive (orange) color');
    }

    return color;
  }

  /// Get category icon color
  ///
  /// **Purpose**: Determine icon color based on category state and theme
  static Color getCategoryIconColor(ServiceCategory category, bool isDark) {
    debugPrint('🎨 CategoryUtils: Getting icon color for category "${category.name}"');
    debugPrint('🎨 CategoryUtils: Category isActive=${category.isActive}, isDark=$isDark');

    if (category.isActive) {
      // Use primary color for active categories
      debugPrint('🎨 CategoryUtils: Using primary color for active category');
      return isDark ? const Color(0xFF6366F1) : const Color(0xFF4F46E5);
    } else {
      // Use grey for inactive categories
      debugPrint('🎨 CategoryUtils: Using grey color for inactive category');
      return isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
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
      debugPrint('❌ CategoryUtils: Name too short (${trimmedName.length} chars)');
      return 'Category name must be at least 3 characters';
    }

    if (trimmedName.length > 50) {
      debugPrint('❌ CategoryUtils: Name too long (${trimmedName.length} chars)');
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
    debugPrint('✅ CategoryUtils: Validating category description length: ${description?.length ?? 0}');

    if (description == null || description.trim().isEmpty) {
      debugPrint('❌ CategoryUtils: Description is empty');
      return 'Category description is required';
    }

    final trimmedDescription = description.trim();

    if (trimmedDescription.length < 10) {
      debugPrint('❌ CategoryUtils: Description too short (${trimmedDescription.length} chars)');
      return 'Description must be at least 10 characters';
    }

    if (trimmedDescription.length > 200) {
      debugPrint('❌ CategoryUtils: Description too long (${trimmedDescription.length} chars)');
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
        .map((word) => word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');

    debugPrint('📝 CategoryUtils: Capitalized result: "$result"');
    return result;
  }

  /// Truncate text with ellipsis
  ///
  /// **Purpose**: Ensure text fits in UI constraints
  static String truncateText(String text, int maxLength) {
    debugPrint('📝 CategoryUtils: Truncating text (length=${text.length}, max=$maxLength)');

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
  static List<ServiceCategory> applySearchFilter(List<ServiceCategory> categories, String searchQuery) {
    debugPrint('🔍 CategoryUtils: Applying search filter with query: "$searchQuery"');
    debugPrint('🔍 CategoryUtils: Input categories count: ${categories.length}');

    if (searchQuery.trim().isEmpty) {
      debugPrint('🔍 CategoryUtils: Empty search query, returning all categories');
      return categories;
    }

    final searchLower = searchQuery.toLowerCase().trim();
    debugPrint('🔍 CategoryUtils: Normalized search query: "$searchLower"');

    final filtered = categories.where((category) {
      final nameMatch = category.name.toLowerCase().contains(searchLower);
      final descMatch = category.description.toLowerCase().contains(searchLower);
      final matches = nameMatch || descMatch;

      debugPrint('🔍 CategoryUtils: Category "${category.name}" - name:$nameMatch, desc:$descMatch, matches:$matches');
      return matches;
    }).toList();

    debugPrint('🔍 CategoryUtils: Search filter completed - ${filtered.length} categories matched');
    return filtered;
  }

  /// Apply status filter to categories
  ///
  /// **Purpose**: Filter categories by active/inactive status
  static List<ServiceCategory> applyStatusFilter(List<ServiceCategory> categories, String statusFilter) {
    debugPrint('🔍 CategoryUtils: Applying status filter: "$statusFilter"');
    debugPrint('🔍 CategoryUtils: Input categories count: ${categories.length}');

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
        debugPrint('🔍 CategoryUtils: Showing all categories (no status filter)');
        break;
    }

    debugPrint('🔍 CategoryUtils: Status filter completed - ${filtered.length} categories matched');
    return filtered;
  }

  /// **Statistics Utilities** 📊
  /// ====================================================================

  /// Calculate category statistics
  ///
  /// **Purpose**: Generate statistics for dashboard display
  static Map<String, int> calculateStatistics(List<ServiceCategory> categories) {
    debugPrint('📊 CategoryUtils: Calculating statistics for ${categories.length} categories');

    final total = categories.length;
    final active = categories.where((cat) => cat.isActive).length;
    final inactive = total - active;

    final stats = {
      'total': total,
      'active': active,
      'inactive': inactive,
    };

    debugPrint('📊 CategoryUtils: Statistics calculated - Total: $total, Active: $active, Inactive: $inactive');
    return stats;
  }

  /// Get performance metrics
  ///
  /// **Purpose**: Calculate performance metrics for monitoring
  static Map<String, double> calculatePerformanceMetrics(List<ServiceCategory> categories) {
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

    final avgSortOrder = categories.map((cat) => cat.sortOrder.toDouble()).reduce((a, b) => a + b) / total;

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
        useCache: useCache,
      );

      final duration = DateTime.now().difference(startTime);
      debugPrint('📊 CategoryUtils.CRUD: API call completed in ${duration.inMilliseconds}ms');

      if (response.isSuccess && response.data != null) {
        final categories = response.data!;
        debugPrint('📊 CategoryUtils.CRUD: Received ${categories.length} categories');

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
          performanceMetrics: {'activeRate': 0.0, 'avgSortOrder': 0.0, 'totalCategories': 0.0},
          loadDuration: duration,
          totalCount: 0,
          activeCount: 0,
          inactiveCount: 0,
          errorMessage: response.message,
        );

        // Complete CRUD operation tracking with failure
        completeCrudOperation(tracker, success: false, errorMessage: response.message);

        return result;
      }
    } catch (e) {
      final duration = DateTime.now().difference(startTime);
      debugPrint('❌ CategoryUtils.CRUD: Exception loading categories - $e');

      final result = CategoryLoadResult(
        isSuccess: false,
        categories: [],
        statistics: {'total': 0, 'active': 0, 'inactive': 0},
        performanceMetrics: {'activeRate': 0.0, 'avgSortOrder': 0.0, 'totalCategories': 0.0},
        loadDuration: duration,
        totalCount: 0,
        activeCount: 0,
        inactiveCount: 0,
        errorMessage: 'Failed to load categories: $e',
      );

      // Complete CRUD operation tracking with exception
      completeCrudOperation(tracker, success: false, errorMessage: e.toString());

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
    debugPrint('🔄 CategoryUtils.CRUD: → Current Status: ${category.isActive ? 'ACTIVE' : 'INACTIVE'}');
    debugPrint('🔄 CategoryUtils.CRUD: → New Status: ${newStatus ? 'ACTIVE' : 'INACTIVE'}');
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
        debugPrint('✅ CategoryUtils.CRUD: Category status updated successfully');

        // Show success message with CategoryUtils text formatting
        if (context.mounted) {
          final displayName = capitalizeWords(category.name);
          final truncatedName = truncateText(displayName, 20);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Category "$truncatedName" ${newStatus ? 'activated' : 'deactivated'} successfully'),
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
        debugPrint('❌ CategoryUtils.CRUD: Failed to update category status: ${response.message}');

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
        completeCrudOperation(tracker, success: false, errorMessage: response.message);

        return false;
      }
    } catch (e) {
      debugPrint('❌ CategoryUtils.CRUD: Exception updating category status: $e');

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
      completeCrudOperation(tracker, success: false, errorMessage: e.toString());

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
        debugPrint('✅ CategoryUtils.CRUD: Category "${category.name}" deleted successfully');

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
          debugPrint('🗑️ CategoryUtils.CRUD: → Removing category from selection...');
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
        debugPrint('❌ CategoryUtils.CRUD: Failed to delete category: ${response.message}');

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
        completeCrudOperation(tracker, success: false, errorMessage: response.message);

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
      completeCrudOperation(tracker, success: false, errorMessage: e.toString());

      return false;
    } finally {
      if (context.mounted) {
        onLoadingStateChange(false);
      }
    }
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
