import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prbal/services/service_management_service.dart';

class EditCategoryModalWidget extends StatefulWidget {
  final ServiceCategory category;
  final VoidCallback onCategoryUpdated;

  const EditCategoryModalWidget({
    super.key,
    required this.category,
    required this.onCategoryUpdated,
  });

  @override
  State<EditCategoryModalWidget> createState() => _EditCategoryModalWidgetState();
}

class _EditCategoryModalWidgetState extends State<EditCategoryModalWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _sortOrderController;
  late ServiceManagementService serviceManagementService;

  late bool _isActive;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Pre-populate form with existing category data
    _nameController = TextEditingController(text: widget.category.name);
    _descriptionController = TextEditingController(text: widget.category.description);
    _sortOrderController = TextEditingController(text: widget.category.sortOrder.toString());
    _isActive = widget.category.isActive;

    debugPrint('✏️ EditCategoryModal: Initialized with category: ${widget.category.name}');
    debugPrint('✏️ → Name: ${widget.category.name}');
    debugPrint('✏️ → Description: ${widget.category.description}');
    debugPrint('✏️ → Sort Order: ${widget.category.sortOrder}');
    debugPrint('✏️ → Is Active: ${widget.category.isActive}');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark ? [const Color(0xFF374151), const Color(0xFF1F2937)] : [Colors.white, const Color(0xFFF8FAFC)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h),
              width: 60.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[600] : Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),

          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withValues(alpha: 0.2),
                      Colors.blue.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.blue.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  LineIcons.edit,
                  color: Colors.blue,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Category',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      'Modify "${widget.category.name}" details',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    LineIcons.times,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Error message
          if (_errorMessage != null)
            Container(
              padding: EdgeInsets.all(12.w),
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.withValues(alpha: 0.1),
                    Colors.red.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(LineIcons.exclamationTriangle, color: Colors.red, size: 20.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
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
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF374151) : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isDark ? Colors.grey[600]! : const Color(0xFFD1D5DB),
                      ),
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Category Name *',
                        labelStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        prefixIcon: Container(
                          padding: EdgeInsets.all(10.w),
                          child: Icon(
                            LineIcons.tag,
                            color: Colors.blue,
                            size: 20.sp,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
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
                  ),

                  SizedBox(height: 16.h),

                  // Description field
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF374151) : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isDark ? Colors.grey[600]! : const Color(0xFFD1D5DB),
                      ),
                    ),
                    child: TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Description *',
                        labelStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        prefixIcon: Container(
                          padding: EdgeInsets.all(10.w),
                          child: Icon(
                            LineIcons.edit,
                            color: Colors.blue,
                            size: 20.sp,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
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
                  ),

                  SizedBox(height: 16.h),

                  // Sort order field
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF374151) : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isDark ? Colors.grey[600]! : const Color(0xFFD1D5DB),
                      ),
                    ),
                    child: TextFormField(
                      controller: _sortOrderController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Sort Order',
                        labelStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        prefixIcon: Container(
                          padding: EdgeInsets.all(10.w),
                          child: Icon(
                            LineIcons.sort,
                            color: Colors.blue,
                            size: 20.sp,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        helperText: 'Lower numbers appear first',
                        helperStyle: TextStyle(
                          color: isDark ? Colors.grey[500] : Colors.grey[500],
                          fontSize: 12.sp,
                        ),
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
                  ),

                  SizedBox(height: 20.h),

                  // Active status switch
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF374151) : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isDark ? Colors.grey[600]! : const Color(0xFFD1D5DB),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                (_isActive ? Colors.green : Colors.orange).withValues(alpha: 0.2),
                                (_isActive ? Colors.green : Colors.orange).withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            _isActive ? LineIcons.checkCircle : LineIcons.pauseCircle,
                            color: _isActive ? Colors.green : Colors.orange,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Active Status',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : const Color(0xFF2D3748),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _isActive
                                    ? 'Category is visible and available to users'
                                    : 'Category is hidden from users',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isActive,
                          onChanged: (value) => setState(() => _isActive = value),
                          activeColor: Colors.green,
                          inactiveThumbColor: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.blue.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateCategory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
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
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LineIcons.save,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Update Category',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Update category using the service management service
  Future<void> _updateCategory() async {
    debugPrint('🔄 EditCategoryModal: Starting category update for: ${widget.category.name}');

    setState(() => _errorMessage = null);

    if (!_formKey.currentState!.validate()) {
      debugPrint('❌ EditCategoryModal: Form validation failed');
      return;
    }

    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final sortOrderText = _sortOrderController.text.trim();
    final sortOrder =
        sortOrderText.isEmpty ? widget.category.sortOrder : int.tryParse(sortOrderText) ?? widget.category.sortOrder;

    // Check if anything actually changed
    final hasChanges = name != widget.category.name ||
        description != widget.category.description ||
        sortOrder != widget.category.sortOrder ||
        _isActive != widget.category.isActive;

    if (!hasChanges) {
      debugPrint('ℹ️ EditCategoryModal: No changes detected, closing modal');
      Navigator.of(context).pop();
      return;
    }

    setState(() => _isLoading = true);

    try {
      debugPrint('🔄 EditCategoryModal: Calling updateCategory API');
      debugPrint('🔄 → Category ID: ${widget.category.id}');
      debugPrint('🔄 → New Name: $name');
      debugPrint('🔄 → New Description: $description');
      debugPrint('🔄 → New Sort Order: $sortOrder');
      debugPrint('🔄 → New Active Status: $_isActive');

      final response = await serviceManagementService.updateCategory(
        categoryId: widget.category.id,
        name: name,
        description: description,
        sortOrder: sortOrder,
        isActive: _isActive,
      );

      if (response.isSuccess && response.data != null) {
        debugPrint('✅ EditCategoryModal: Category updated successfully');
        debugPrint('✅ → Updated Category: ${response.data!.name}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(LineIcons.checkCircle, color: Colors.white, size: 20.sp),
                  SizedBox(width: 12.w),
                  Text(
                    'Category "${response.data!.name}" updated successfully!',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              margin: EdgeInsets.all(16.w),
            ),
          );
        }

        widget.onCategoryUpdated();
        Navigator.of(context).pop();
      } else {
        debugPrint('❌ EditCategoryModal: API error - ${response.message}');
        setState(() {
          _isLoading = false;
          _errorMessage = response.message;
        });
      }
    } catch (e) {
      debugPrint('💥 EditCategoryModal: Exception - $e');
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
