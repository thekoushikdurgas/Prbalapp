import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
// import 'package:prbal/utils/icon/prbal_icons.dart';

class PostRequestScreen extends ConsumerStatefulWidget {
  const PostRequestScreen({super.key});

  @override
  ConsumerState<PostRequestScreen> createState() => _PostRequestScreenState();
}

class _PostRequestScreenState extends ConsumerState<PostRequestScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('📝 PostRequestScreen: Building post request interface');
    debugPrint('📝 PostRequestScreen: Dark mode: ${ThemeManager.of(context).themeManager}');

    return Scaffold(
      backgroundColor: ThemeManager.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeManager.of(context).surfaceColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        title: Text(
          'Post a Request',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: ThemeManager.of(context).textPrimary,
          ),
        ),
        iconTheme: IconThemeData(
          color: ThemeManager.of(context).textPrimary,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Request Title Section
            _buildRequestTitleSection(),
            SizedBox(height: 16.h),

            // Description Section
            _buildDescriptionSection(),
            SizedBox(height: 32.h),

            // Submit Button
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  /// Builds the request title input section with theme-aware styling
  Widget _buildRequestTitleSection() {
    debugPrint('📝 PostRequestScreen: Building request title section');

    return Container(
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).surfaceGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: ThemeManager.of(context).subtleShadow,
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Request Title',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: ThemeManager.of(context).textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                color: ThemeManager.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: ThemeManager.of(context).borderColor,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _titleController,
                onChanged: (value) {
                  debugPrint(
                      '📝 PostRequestScreen: Title changed: "${value.isNotEmpty ? value.substring(0, value.length.clamp(0, 20)) : ''}"');
                },
                decoration: InputDecoration(
                  hintText: 'e.g., Need house cleaning this weekend',
                  hintStyle: TextStyle(
                    color: ThemeManager.of(context).textTertiary,
                    fontSize: 14.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                style: TextStyle(
                  color: ThemeManager.of(context).textPrimary,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the description input section with theme-aware styling
  Widget _buildDescriptionSection() {
    debugPrint('📝 PostRequestScreen: Building description section');

    return Container(
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).surfaceGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: ThemeManager.of(context).subtleShadow,
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: ThemeManager.of(context).textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                color: ThemeManager.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: ThemeManager.of(context).borderColor,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: 4,
                onChanged: (value) {
                  debugPrint('📝 PostRequestScreen: Description changed: ${value.length} characters');
                },
                decoration: InputDecoration(
                  hintText: 'Describe your requirements in detail...',
                  hintStyle: TextStyle(
                    color: ThemeManager.of(context).textTertiary,
                    fontSize: 14.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                style: TextStyle(
                  color: ThemeManager.of(context).textPrimary,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the submit button with theme-aware styling and gradient effects
  Widget _buildSubmitButton() {
    debugPrint('📝 PostRequestScreen: Building submit button');

    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: ThemeManager.of(context).primaryShadow,
      ),
      child: ElevatedButton(
        onPressed: () {
          debugPrint('📝 PostRequestScreen: Submit button pressed');
          debugPrint('📝 PostRequestScreen: Title: "${_titleController.text}"');
          debugPrint('📝 PostRequestScreen: Description: "${_descriptionController.text}"');

          // Validate inputs
          if (_titleController.text.trim().isEmpty) {
            debugPrint('📝 PostRequestScreen: Validation failed - Title is empty');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Please enter a request title',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: ThemeManager.of(context).errorColor,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            );
            return;
          }

          if (_descriptionController.text.trim().isEmpty) {
            debugPrint('📝 PostRequestScreen: Validation failed - Description is empty');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Please enter a description',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: ThemeManager.of(context).errorColor,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            );
            return;
          }

          debugPrint('📝 PostRequestScreen: Validation passed - Submitting request');
          // TODO: Implement actual request submission logic
          _handleRequestSubmission();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
        ),
        child: Text(
          'Post Request',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Handles the request submission process
  void _handleRequestSubmission() {
    debugPrint('📝 PostRequestScreen: Processing request submission');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Request posted successfully!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ThemeManager.of(context).successColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );

    // Clear form
    _titleController.clear();
    _descriptionController.clear();

    debugPrint('📝 PostRequestScreen: Form cleared, request submitted successfully');

    // TODO: Navigate back or to request list
    // Navigator.pop(context);
  }
}
