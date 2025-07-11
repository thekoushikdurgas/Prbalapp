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
    debugPrint('📝 AddServiceScreen: Building add service interface');
    debugPrint(
        '🎨 AddServiceScreen: Theme mode: ${ThemeManager.of(context).themeManager ? 'Dark' : 'Light'}');

    return Scaffold(
      backgroundColor: ThemeManager.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeManager.of(context).surfaceColor,
        title: Text(
          'Add Service',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: ThemeManager.of(context).textPrimary,
          ),
        ),
        iconTheme: IconThemeData(
          color: ThemeManager.of(context).textPrimary,
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
            _buildServiceTitleCard(),
            SizedBox(height: 16.h),

            // Service Description Section
            _buildServiceDescriptionCard(),
            SizedBox(height: 16.h),

            // Service Category Section
            _buildServiceCategoryCard(),
            SizedBox(height: 16.h),

            // Service Price Section
            _buildServicePriceCard(),
            SizedBox(height: 24.h),

            // Submit Button
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  /// Builds the service title input card
  Widget _buildServiceTitleCard() {
    debugPrint('📝 AddServiceScreen: Building service title card');

    return Card(
      color: ThemeManager.of(context).surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: ThemeManager.of(context).borderColor,
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
                color: ThemeManager.of(context).textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _titleController,
              onChanged: (value) {
                debugPrint(
                    '📝 AddServiceScreen: Service title changed: "$value"');
              },
              decoration: InputDecoration(
                hintText: 'e.g., Professional House Cleaning',
                hintStyle: TextStyle(
                  color: ThemeManager.of(context).textTertiary,
                ),
                filled: true,
                fillColor: ThemeManager.of(context).conditionalColor(
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
                    color: ThemeManager.of(context).primaryColor,
                    width: 2,
                  ),
                ),
              ),
              style: TextStyle(
                color: ThemeManager.of(context).textPrimary,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the service description input card
  Widget _buildServiceDescriptionCard() {
    debugPrint('📝 AddServiceScreen: Building service description card');

    return Card(
      color: ThemeManager.of(context).surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: ThemeManager.of(context).borderColor,
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
                color: ThemeManager.of(context).textPrimary,
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
                  color: ThemeManager.of(context).textTertiary,
                ),
                filled: true,
                fillColor: ThemeManager.of(context).conditionalColor(
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
                    color: ThemeManager.of(context).primaryColor,
                    width: 2,
                  ),
                ),
              ),
              style: TextStyle(
                color: ThemeManager.of(context).textPrimary,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the service category selection card
  Widget _buildServiceCategoryCard() {
    debugPrint('📝 AddServiceScreen: Building service category card');

    return Card(
      color: ThemeManager.of(context).surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: ThemeManager.of(context).borderColor,
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
                color: ThemeManager.of(context).textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: ThemeManager.of(context).conditionalColor(
                  lightColor: const Color(0xFFF3F4F6),
                  darkColor: const Color(0xFF374151),
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: DropdownButton<String>(
                value: selectedCategory,
                isExpanded: true,
                underline: const SizedBox(),
                dropdownColor: ThemeManager.of(context).surfaceColor,
                style: TextStyle(
                  color: ThemeManager.of(context).textPrimary,
                  fontSize: 14.sp,
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    debugPrint(
                        '📝 AddServiceScreen: Category changed to: $newValue');
                    setState(() {
                      selectedCategory = newValue;
                    });
                  }
                },
                items: <String>[
                  'Home Services',
                  'Repair Services',
                  'Beauty Services',
                  'Other'
                ].map<DropdownMenuItem<String>>((String value) {
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
  Widget _buildServicePriceCard() {
    debugPrint('📝 AddServiceScreen: Building service price card');

    return Card(
      color: ThemeManager.of(context).surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(
          color: ThemeManager.of(context).borderColor,
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
                color: ThemeManager.of(context).textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                debugPrint(
                    '📝 AddServiceScreen: Service price changed: "$value"');
              },
              decoration: InputDecoration(
                hintText: 'Enter price in ₹',
                hintStyle: TextStyle(
                  color: ThemeManager.of(context).textTertiary,
                ),
                prefixText: '₹ ',
                prefixStyle: TextStyle(
                  color: ThemeManager.of(context).textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                filled: true,
                fillColor: ThemeManager.of(context).conditionalColor(
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
                    color: ThemeManager.of(context).primaryColor,
                    width: 2,
                  ),
                ),
              ),
              style: TextStyle(
                color: ThemeManager.of(context).textPrimary,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the submit button
  Widget _buildSubmitButton() {
    debugPrint('📝 AddServiceScreen: Building submit button');

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () {
          debugPrint('📝 AddServiceScreen: Add Service button pressed');
          debugPrint('📝 AddServiceScreen: Title: "${_titleController.text}"');
          debugPrint(
              '📝 AddServiceScreen: Description: "${_descriptionController.text}"');
          debugPrint('📝 AddServiceScreen: Category: "$selectedCategory"');
          debugPrint('📝 AddServiceScreen: Price: "${_priceController.text}"');

          // TODO: Implement service submission logic
          // This should validate inputs and submit to backend
          _handleServiceSubmission();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeManager.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
          shadowColor:
              ThemeManager.of(context).primaryColor.withValues(alpha: 0.3),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ThemeManager.of(context).errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  /// Shows success snack bar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ThemeManager.of(context).successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
