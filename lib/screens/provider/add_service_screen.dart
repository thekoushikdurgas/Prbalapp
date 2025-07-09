import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/widgets/modern_ui_components.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

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
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Title
            ModernUIComponents.elevatedCard(
              themeManager: ThemeManager.of(context),
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
                    decoration: InputDecoration(
                      hintText: 'e.g., Professional House Cleaning',
                      hintStyle: TextStyle(
                        color: ThemeManager.of(context).textSecondary,
                      ),
                      filled: true,
                      fillColor: ThemeManager.of(context).inputBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                    ),
                    style: TextStyle(
                      color: ThemeManager.of(context).textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Category Selection
            ModernUIComponents.elevatedCard(
              themeManager: ThemeManager.of(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ThemeManager.of(context).textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: ThemeManager.of(context).inputBackground,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        icon: Icon(
                          Prbal.angleDown,
                          color: ThemeManager.of(context).textPrimary,
                        ),
                        style: TextStyle(
                          color: ThemeManager.of(context).textPrimary,
                          fontSize: 16.sp,
                        ),
                        dropdownColor: ThemeManager.of(context).surfaceColor,
                        items: ['Home Services', 'Cleaning', 'Plumbing', 'Electrical', 'Others']
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Description
            ModernUIComponents.elevatedCard(
              themeManager: ThemeManager.of(context),
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
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Describe your service in detail...',
                      hintStyle: TextStyle(
                        color: ThemeManager.of(context).textSecondary,
                      ),
                      filled: true,
                      fillColor: ThemeManager.of(context).inputBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                    ),
                    style: TextStyle(
                      color: ThemeManager.of(context).textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Price
            ModernUIComponents.elevatedCard(
              themeManager: ThemeManager.of(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price (₹)',
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
                    decoration: InputDecoration(
                      hintText: '500',
                      hintStyle: TextStyle(
                        color: ThemeManager.of(context).textSecondary,
                      ),
                      filled: true,
                      fillColor: ThemeManager.of(context).inputBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                    ),
                    style: TextStyle(
                      color: ThemeManager.of(context).textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeManager.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
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
            ),
          ],
        ),
      ),
    );
  }
}
