import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
// import 'package:prbal/utils/icon/prbal_icons.dart';

class AddServiceScreen extends ConsumerStatefulWidget {
  const AddServiceScreen({super.key});

  @override
  ConsumerState<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends ConsumerState<AddServiceScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String selectedCategory = 'Home Services';

  @override
  void initState() {
    super.initState();
    debugPrint('📝 AddServiceScreen: Initializing add service screen');
  }

  @override
  void dispose() {
    debugPrint('📝 AddServiceScreen: Disposing controllers');
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    debugPrint('📝 AddServiceScreen: Building add service interface');
    debugPrint('🎨 AddServiceScreen: Theme mode: ${themeManager.themeManager ? 'Dark' : 'Light'}');

    return Scaffold(
      backgroundColor: themeManager.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeManager.surfaceColor,
        title: Text(
          'Add Service',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: themeManager.textPrimary,
          ),
        ),
        iconTheme: IconThemeData(
          color: themeManager.textPrimary,
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Title Section
            _buildServiceTitleCard(themeManager),
            SizedBox(height: 16.h),

            // Service Description Section
            _buildServiceDescriptionCard(themeManager),
            SizedBox(height: 16.h),

            // Service Category Section
            _buildServiceCategoryCard(themeManager),
            SizedBox(height: 16.h),

            // Service Price Section
            _buildServicePriceCard(themeManager),
            SizedBox(height: 24.h),

            // Submit Button
            _buildSubmitButton(themeManager),
          ],
        ),
      ),
    );
  }

  /// Builds the service title input card
  Widget _buildServiceTitleCard(ThemeManager themeManager) {
    debugPrint('📝 AddServiceScreen: Building service title card');

    return Card(
      color: themeManager.surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: themeManager.borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Title',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: themeManager.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _titleController,
              onChanged: (value) {
                debugPrint('📝 AddServiceScreen: Service title changed: "$value"');
              },
              decoration: InputDecoration(
                hintText: 'e.g., Professional House Cleaning',
                hintStyle: TextStyle(
                  color: themeManager.textTertiary,
                ),
                filled: true,
                fillColor: themeManager.conditionalColor(
                  lightColor: const Color(0xFFF3F4F6),
                  darkColor: const Color(0xFF374151),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: themeManager.primaryColor,
                    width: 2,
                  ),
                ),
              ),
              style: TextStyle(
                color: themeManager.textPrimary,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the service description input card
  Widget _buildServiceDescriptionCard(ThemeManager themeManager) {
    debugPrint('📝 AddServiceScreen: Building service description card');

    return Card(
      color: themeManager.surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: themeManager.borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Description',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: themeManager.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              onChanged: (value) {
                debugPrint(
                    '📝 AddServiceScreen: Service description changed: "${value.substring(0, value.length > 50 ? 50 : value.length)}..."');
              },
              decoration: InputDecoration(
                hintText: 'Describe your service in detail...',
                hintStyle: TextStyle(
                  color: themeManager.textTertiary,
                ),
                filled: true,
                fillColor: themeManager.conditionalColor(
                  lightColor: const Color(0xFFF3F4F6),
                  darkColor: const Color(0xFF374151),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: themeManager.primaryColor,
                    width: 2,
                  ),
                ),
              ),
              style: TextStyle(
                color: themeManager.textPrimary,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the service category selection card
  Widget _buildServiceCategoryCard(ThemeManager themeManager) {
    debugPrint('📝 AddServiceScreen: Building service category card');

    return Card(
      color: themeManager.surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: themeManager.borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Category',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: themeManager.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: themeManager.conditionalColor(
                  lightColor: const Color(0xFFF3F4F6),
                  darkColor: const Color(0xFF374151),
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: DropdownButton<String>(
                value: selectedCategory,
                isExpanded: true,
                underline: const SizedBox(),
                dropdownColor: themeManager.surfaceColor,
                style: TextStyle(
                  color: themeManager.textPrimary,
                  fontSize: 14.sp,
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    debugPrint('📝 AddServiceScreen: Category changed to: $newValue');
                    setState(() {
                      selectedCategory = newValue;
                    });
                  }
                },
                items: <String>['Home Services', 'Repair Services', 'Beauty Services', 'Other']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the service price input card
  Widget _buildServicePriceCard(ThemeManager themeManager) {
    debugPrint('📝 AddServiceScreen: Building service price card');

    return Card(
      color: themeManager.surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: themeManager.borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Price',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: themeManager.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                debugPrint('📝 AddServiceScreen: Service price changed: "$value"');
              },
              decoration: InputDecoration(
                hintText: 'Enter price in ₹',
                hintStyle: TextStyle(
                  color: themeManager.textTertiary,
                ),
                prefixText: '₹ ',
                prefixStyle: TextStyle(
                  color: themeManager.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                filled: true,
                fillColor: themeManager.conditionalColor(
                  lightColor: const Color(0xFFF3F4F6),
                  darkColor: const Color(0xFF374151),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: themeManager.primaryColor,
                    width: 2,
                  ),
                ),
              ),
              style: TextStyle(
                color: themeManager.textPrimary,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the submit button
  Widget _buildSubmitButton(ThemeManager themeManager) {
    debugPrint('📝 AddServiceScreen: Building submit button');

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () {
          debugPrint('📝 AddServiceScreen: Add Service button pressed');
          debugPrint('📝 AddServiceScreen: Title: "${_titleController.text}"');
          debugPrint('📝 AddServiceScreen: Description: "${_descriptionController.text}"');
          debugPrint('📝 AddServiceScreen: Category: "$selectedCategory"');
          debugPrint('📝 AddServiceScreen: Price: "${_priceController.text}"');

          // TODO: Implement service submission logic
          // This should validate inputs and submit to backend
          _handleServiceSubmission();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: themeManager.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
          shadowColor: themeManager.primaryColor.withValues(alpha: 0.3),
        ),
        child: Text(
          'Add Service',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Handles the service submission logic
  void _handleServiceSubmission() {
    debugPrint('📝 AddServiceScreen: Processing service submission...');

    // Basic validation
    if (_titleController.text.trim().isEmpty) {
      debugPrint('❌ AddServiceScreen: Service title is empty');
      _showErrorSnackBar('Please enter a service title');
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      debugPrint('❌ AddServiceScreen: Service description is empty');
      _showErrorSnackBar('Please enter a service description');
      return;
    }

    if (_priceController.text.trim().isEmpty) {
      debugPrint('❌ AddServiceScreen: Service price is empty');
      _showErrorSnackBar('Please enter a service price');
      return;
    }

    debugPrint('✅ AddServiceScreen: All validations passed');
    debugPrint('📤 AddServiceScreen: Submitting service data to backend...');

    // TODO: Implement actual API call here
    _showSuccessSnackBar('Service added successfully!');
  }

  /// Shows error snack bar
  void _showErrorSnackBar(String message) {
    final themeManager = ThemeManager.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: themeManager.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  /// Shows success snack bar
  void _showSuccessSnackBar(String message) {
    final themeManager = ThemeManager.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: themeManager.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
