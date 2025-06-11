import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prbal/components/modern_ui_components.dart';

/// TakerPostRequestScreen - Screen for customers/takers to post service requests
/// This screen allows users to create a new service request by filling out:
/// - Service category selection
/// - Request title and description
/// - Budget and urgency level
/// All form data is validated before submission
class TakerPostRequestScreen extends ConsumerStatefulWidget {
  const TakerPostRequestScreen({super.key});

  @override
  ConsumerState<TakerPostRequestScreen> createState() => _TakerPostRequestScreenState();
}

class _TakerPostRequestScreenState extends ConsumerState<TakerPostRequestScreen> {
  // Form controllers for capturing user input
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();

  // Default form values - can be modified by user
  String selectedCategory = 'Home Services';
  String selectedUrgency = 'Normal';

  @override
  void initState() {
    super.initState();
    debugPrint('🏠 TakerPostRequestScreen: Screen initialized');
    debugPrint('🏠 TakerPostRequestScreen: Default category set to: $selectedCategory');
    debugPrint('🏠 TakerPostRequestScreen: Default urgency set to: $selectedUrgency');
  }

  @override
  void dispose() {
    debugPrint('🏠 TakerPostRequestScreen: Disposing controllers and cleaning up resources');
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  /// Validates form data before submission
  /// Returns true if all required fields are filled, false otherwise
  bool _validateForm() {
    debugPrint('🏠 TakerPostRequestScreen: Starting form validation');

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final budget = _budgetController.text.trim();

    debugPrint(
        '🏠 TakerPostRequestScreen: Form data - Title: "$title", Description length: ${description.length}, Budget: "$budget"');
    debugPrint('🏠 TakerPostRequestScreen: Form data - Category: "$selectedCategory", Urgency: "$selectedUrgency"');

    if (title.isEmpty) {
      debugPrint('❌ TakerPostRequestScreen: Validation failed - Title is empty');
      return false;
    }

    if (description.isEmpty) {
      debugPrint('❌ TakerPostRequestScreen: Validation failed - Description is empty');
      return false;
    }

    if (budget.isEmpty) {
      debugPrint('❌ TakerPostRequestScreen: Validation failed - Budget is empty');
      return false;
    }

    // Validate budget is a valid number
    final budgetValue = double.tryParse(budget);
    if (budgetValue == null || budgetValue <= 0) {
      debugPrint('❌ TakerPostRequestScreen: Validation failed - Invalid budget value: "$budget"');
      return false;
    }

    debugPrint('✅ TakerPostRequestScreen: Form validation passed');
    return true;
  }

  /// Handles form submission - validates data and processes the request
  void _submitRequest() {
    debugPrint('🏠 TakerPostRequestScreen: Submit button pressed - starting request submission');

    if (!_validateForm()) {
      debugPrint('❌ TakerPostRequestScreen: Submission aborted due to validation failure');
      // TODO: Show user-friendly validation error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields with valid data'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Prepare request data for submission
    final requestData = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'budget': double.parse(_budgetController.text.trim()),
      'category': selectedCategory,
      'urgency': selectedUrgency,
      'timestamp': DateTime.now().toIso8601String(),
    };

    debugPrint('🏠 TakerPostRequestScreen: Request data prepared for submission:');
    debugPrint('📝 Request Details: $requestData');

    // TODO: Implement actual API call to submit request
    // await _apiService.submitServiceRequest(requestData);

    debugPrint('✅ TakerPostRequestScreen: Request submission completed successfully');

    // Show success feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Service request posted successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Clear form after successful submission
    _clearForm();
  }

  /// Clears all form fields and resets to default values
  void _clearForm() {
    debugPrint('🏠 TakerPostRequestScreen: Clearing form and resetting to defaults');
    _titleController.clear();
    _descriptionController.clear();
    _budgetController.clear();
    setState(() {
      selectedCategory = 'Home Services';
      selectedUrgency = 'Normal';
    });
    debugPrint('🏠 TakerPostRequestScreen: Form cleared successfully');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    debugPrint('🏠 TakerPostRequestScreen: Building UI with theme mode: ${isDark ? "Dark" : "Light"}');

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          'Post a Request',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1F2937),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Category Selection Section
            // Allows users to choose the type of service they need
            ModernUIComponents.elevatedCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service Category',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        icon: Icon(
                          LineIcons.angleDown,
                          color: isDark ? Colors.white : const Color(0xFF1F2937),
                        ),
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF1F2937),
                          fontSize: 16.sp,
                        ),
                        dropdownColor: isDark ? const Color(0xFF374151) : Colors.white,
                        items: ['Home Services', 'Cleaning', 'Plumbing', 'Electrical', 'Others']
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                ))
                            .toList(),
                        onChanged: (value) {
                          debugPrint(
                              '🏠 TakerPostRequestScreen: Category changed from "$selectedCategory" to "$value"');
                          setState(() {
                            selectedCategory = value!;
                          });
                          debugPrint('🏠 TakerPostRequestScreen: Category selection updated in UI');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Request Title Input Section
            // Captures the main title/summary of the service request
            ModernUIComponents.elevatedCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request Title',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'e.g., Need house cleaning this weekend',
                      hintStyle: TextStyle(
                        color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                      ),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
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
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                    onChanged: (value) {
                      debugPrint('🏠 TakerPostRequestScreen: Title input changed - Length: ${value.length}');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Detailed Description Input Section
            // Allows users to provide comprehensive details about their service needs
            ModernUIComponents.elevatedCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4, // Multi-line input for detailed descriptions
                    decoration: InputDecoration(
                      hintText: 'Describe your requirements in detail...',
                      hintStyle: TextStyle(
                        color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                      ),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
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
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                    onChanged: (value) {
                      debugPrint('🏠 TakerPostRequestScreen: Description input changed - Length: ${value.length}');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Budget and Urgency Selection Row
            // Side-by-side inputs for budget amount and urgency level
            Row(
              children: [
                // Budget Input Section
                Expanded(
                  child: ModernUIComponents.elevatedCard(
                    isDark: isDark,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Budget (₹)',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF1F2937),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        TextField(
                          controller: _budgetController,
                          keyboardType: TextInputType.number, // Numeric input only
                          decoration: InputDecoration(
                            hintText: '500',
                            hintStyle: TextStyle(
                              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                            ),
                            filled: true,
                            fillColor: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
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
                            color: isDark ? Colors.white : const Color(0xFF1F2937),
                          ),
                          onChanged: (value) {
                            debugPrint('🏠 TakerPostRequestScreen: Budget input changed - Value: "$value"');
                            // Validate budget input in real-time
                            final budgetValue = double.tryParse(value);
                            if (budgetValue != null) {
                              debugPrint('🏠 TakerPostRequestScreen: Valid budget entered: ₹$budgetValue');
                            } else if (value.isNotEmpty) {
                              debugPrint('⚠️ TakerPostRequestScreen: Invalid budget format entered');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                // Urgency Level Selection Section
                Expanded(
                  child: ModernUIComponents.elevatedCard(
                    isDark: isDark,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Urgency',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : const Color(0xFF1F2937),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedUrgency,
                              isExpanded: true,
                              icon: Icon(
                                LineIcons.angleDown,
                                color: isDark ? Colors.white : const Color(0xFF1F2937),
                              ),
                              style: TextStyle(
                                color: isDark ? Colors.white : const Color(0xFF1F2937),
                                fontSize: 16.sp,
                              ),
                              dropdownColor: isDark ? const Color(0xFF374151) : Colors.white,
                              items: ['Low', 'Normal', 'High', 'Urgent']
                                  .map((urgency) => DropdownMenuItem(
                                        value: urgency,
                                        child: Text(urgency),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                debugPrint(
                                    '🏠 TakerPostRequestScreen: Urgency changed from "$selectedUrgency" to "$value"');
                                setState(() {
                                  selectedUrgency = value!;
                                });
                                debugPrint('🏠 TakerPostRequestScreen: Urgency selection updated in UI');
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),

            // Submit Button Section
            // Final action button to post the service request
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint('🏠 TakerPostRequestScreen: Post Request button tapped');
                  _submitRequest();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
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
            ),
          ],
        ),
      ),
    );
  }
}
