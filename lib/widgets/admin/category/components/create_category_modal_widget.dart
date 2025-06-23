// ====================================================================
// CREATE CATEGORY MODAL WIDGET - Simplified Design
// ====================================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prbal/services/service_management_service.dart';

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
  State<CreateCategoryModalWidget> createState() => _CreateCategoryModalWidgetState();
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

  @override
  void initState() {
    super.initState();
    _sortOrderController.text = '0';
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
              Icon(LineIcons.plus, color: Theme.of(context).primaryColor),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Create Category',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(LineIcons.times),
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
                  Icon(LineIcons.exclamationTriangle, color: Colors.red),
                  SizedBox(width: 8.w),
                  Expanded(child: Text(_errorMessage!, style: TextStyle(color: Colors.red))),
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
                      prefixIcon: Icon(LineIcons.tag),
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
                      prefixIcon: Icon(LineIcons.edit),
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
                      prefixIcon: Icon(LineIcons.sort),
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

                  // Active status
                  SwitchListTile(
                    title: Text('Active Status'),
                    subtitle: Text(
                        _isActive ? 'Category will be visible immediately' : 'Category will be hidden until activated'),
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
    final sortOrder = sortOrderText.isEmpty ? 0 : int.tryParse(sortOrderText) ?? 0;

    setState(() => _isLoading = true);

    try {
      final response = await serviceManagementService.createCategory(
        name: name,
        description: description,
        sortOrder: sortOrder,
        isActive: _isActive,
      );

      if (response.isSuccess && response.data != null) {
        debugPrint('✅ CreateCategoryModal: Category created successfully');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Category "${response.data!.name}" created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }

        widget.onCategoryCreated();
        Navigator.of(context).pop();
      } else {
        debugPrint('❌ CreateCategoryModal: API error - ${response.message}');
        setState(() {
          _isLoading = false;
          _errorMessage = response.message;
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
