// ====================================================================
// CREATE CATEGORY MODAL WIDGET - Simplified Design
// ====================================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/services/service_management_service.dart';
import 'package:prbal/services/api_service.dart';
import 'package:prbal/widgets/admin/category/components/category_icon_picker.dart';

/// CreateCategoryModalWidget - Simple modal for creating categories
class CreateCategoryModalWidget extends StatefulWidget {
  final VoidCallback onCategoryCreated;
  // final ServiceManagementService serviceManagementService;

  const CreateCategoryModalWidget({
    super.key,
    required this.onCategoryCreated,
    // required this.serviceManagementService,
  });

  @override
  State<CreateCategoryModalWidget> createState() =>
      _CreateCategoryModalWidgetState();
}

class _CreateCategoryModalWidgetState extends State<CreateCategoryModalWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sortOrderController = TextEditingController();
  late ServiceManagementService serviceManagementService;

  bool _isActive = true;
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _sortOrderController.text = '0';
    // Initialize service management service with API service
    serviceManagementService = ServiceManagementService(ApiService());
    debugPrint('🚀 CreateCategoryModal: ServiceManagementService initialized');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Prbal.plus, color: Theme.of(context).primaryColor),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Category',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Add a new service category with icon',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Prbal.cross),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Error message
          if (_errorMessage != null)
            Container(
              padding: EdgeInsets.all(12.w),
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 30),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.red),
              ),
              child: Row(
                children: [
                  Icon(Prbal.exclamationTriangle, color: Colors.red),
                  SizedBox(width: 8.w),
                  Expanded(
                      child: Text(_errorMessage!,
                          style: TextStyle(color: Colors.red))),
                ],
              ),
            ),

          // Form
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Name field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Category Name *',
                      prefixIcon: Icon(Prbal.tag),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Category name is required';
                      }
                      if (value.trim().length < 3) {
                        return 'Name must be at least 3 characters';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16.h),

                  // Description field
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description *',
                      prefixIcon: Icon(Prbal.edit),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Description is required';
                      }
                      if (value.trim().length < 10) {
                        return 'Description must be at least 10 characters';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16.h),

                  // Sort order field
                  TextFormField(
                    controller: _sortOrderController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Sort Order',
                      prefixIcon: Icon(Prbal.sort),
                      border: OutlineInputBorder(),
                      helperText: 'Lower numbers appear first',
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final sortOrder = int.tryParse(value);
                        if (sortOrder == null || sortOrder < 0) {
                          return 'Must be a positive number';
                        }
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16.h),

                  // Icon Picker Section
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: Theme.of(context)
                            .dividerColor
                            .withValues(alpha: 128),
                      ),
                    ),
                    child: CategoryIconPicker(
                      selectedIcon: _selectedIcon,
                      onIconSelected: (icon) {
                        setState(() {
                          _selectedIcon = icon;
                        });
                        debugPrint(
                            '🎨 CreateCategoryModal: Icon selected: ${icon ?? 'none'}');
                      },
                      showSearchBar: true,
                      crossAxisCount: 4,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Active status
                  SwitchListTile(
                    title: Text('Active Status'),
                    subtitle: Text(_isActive
                        ? 'Category will be visible immediately'
                        : 'Category will be hidden until activated'),
                    value: _isActive,
                    onChanged: (value) => setState(() => _isActive = value),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('Create'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Create category
  Future<void> _createCategory() async {
    debugPrint('🚀 CreateCategoryModal: Starting category creation');

    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) {
      debugPrint('❌ CreateCategoryModal: Form validation failed');
      return;
    }

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final sortOrderText = _sortOrderController.text.trim();
    final sortOrder =
        sortOrderText.isEmpty ? 0 : int.tryParse(sortOrderText) ?? 0;

    setState(() => _isLoading = true);

    try {
      final response = await serviceManagementService.createCategory(
        name: name,
        description: description,
        iconUrl: _selectedIcon, // ✨ Now passing selected icon as iconUrl to API
        sortOrder: sortOrder,
        isActive: _isActive,
      );

      if (response.isSuccess && response.data != null) {
        debugPrint('✅ CreateCategoryModal: Category created successfully');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Category "${response.data!.name}" created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }

        widget.onCategoryCreated();
        Navigator.of(context).pop();
      } else {
        debugPrint('❌ CreateCategoryModal: API error - ${response.message}');

        // Enhanced error handling with validation details
        String errorMessage = response.message;
        final validationErrors = <String>[];

        // Check for validation errors in the response.errors
        if (response.errors != null && response.errors!.isNotEmpty) {
          debugPrint(
              '❌ CreateCategoryModal: Validation errors found in response.errors');

          response.errors!.forEach((field, messages) {
            if (messages is List) {
              for (final message in messages) {
                validationErrors.add('$field: $message');
                debugPrint('❌ → Validation error - $field: $message');
              }
            } else {
              validationErrors.add('$field: $messages');
              debugPrint('❌ → Validation error - $field: $messages');
            }
          });
        }

        // Also check for nested validation errors in response data
        // API returns: {"data": {"validation_errors": {"field": ["error"]}}}
        try {
          debugPrint('❌ CreateCategoryModal: Full response analysis...');

          // Try to parse the nested structure by checking the debug logs
          // Since we see the validation error in logs, we can provide more specific error messages
          if (response.message.contains('validation failed')) {
            if (_selectedIcon != null) {
              validationErrors.add(
                  'Icon: Selected icon "$_selectedIcon" could not be processed');
              validationErrors
                  .add('Hint: Try selecting a different icon or leave blank');
            }
            validationErrors.add('Please check all fields and try again');
          }

          // Add field-specific validation hints
          if (response.message.toLowerCase().contains('name')) {
            validationErrors.add(
                'Name: Please ensure the name is unique and follows naming rules');
          }
          if (response.message.toLowerCase().contains('description')) {
            validationErrors
                .add('Description: Please provide a more detailed description');
          }
        } catch (e) {
          debugPrint(
              '❌ CreateCategoryModal: Error parsing response details - $e');
        }

        if (validationErrors.isNotEmpty) {
          errorMessage = validationErrors.join('\n• ');
          errorMessage = '• $errorMessage';
        }

        setState(() {
          _isLoading = false;
          _errorMessage = errorMessage;
        });
      }
    } catch (e) {
      debugPrint('💥 CreateCategoryModal: Exception - $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred: $e';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _sortOrderController.dispose();
    super.dispose();
  }
}
