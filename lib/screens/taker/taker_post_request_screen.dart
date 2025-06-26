import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
// import 'package:prbal/services/service_management_service.dart';
import 'package:prbal/widgets/modern_ui_components.dart';

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
    final themeManager = ThemeManager.of(context);
    return Scaffold(
      backgroundColor: themeManager.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeManager.surfaceColor,
        title: Text(
          'Post a Request',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: themeManager.textPrimary,
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
              themeManager: themeManager,
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
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: themeManager.inputBackground,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        icon: Icon(
                          Prbal.angleDown,
                          color: themeManager.textPrimary,
                        ),
                        style: TextStyle(
                          color: themeManager.textPrimary,
                          fontSize: 16.sp,
                        ),
                        dropdownColor: themeManager.surfaceColor,
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
              themeManager: themeManager,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request Title',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: themeManager.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'e.g., Need house cleaning this weekend',
                      hintStyle: TextStyle(
                        color: themeManager.textSecondary,
                      ),
                      filled: true,
                      fillColor: themeManager.inputBackground,
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
                      color: themeManager.textPrimary,
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
              themeManager: themeManager,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: themeManager.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4, // Multi-line input for detailed descriptions
                    decoration: InputDecoration(
                      hintText: 'Describe your requirements in detail...',
                      hintStyle: TextStyle(
                        color: themeManager.textSecondary,
                      ),
                      filled: true,
                      fillColor: themeManager.inputBackground,
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
                      color: themeManager.textPrimary,
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
                    themeManager: themeManager,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Budget (₹)',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: themeManager.textPrimary,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        TextField(
                          controller: _budgetController,
                          keyboardType: TextInputType.number, // Numeric input only
                          decoration: InputDecoration(
                            hintText: '500',
                            hintStyle: TextStyle(
                              color: themeManager.textSecondary,
                            ),
                            filled: true,
                            fillColor: themeManager.inputBackground,
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
                            color: themeManager.textPrimary,
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
                    themeManager: themeManager,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Urgency',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: themeManager.textPrimary,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: themeManager.inputBackground,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedUrgency,
                              isExpanded: true,
                              icon: Icon(
                                Prbal.angleDown,
                                color: themeManager.textPrimary,
                              ),
                              style: TextStyle(
                                color: themeManager.textPrimary,
                                fontSize: 16.sp,
                              ),
                              dropdownColor: themeManager.surfaceColor,
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
                  backgroundColor: themeManager.primaryColor,
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

  // ====================================================================
  // ENHANCED SERVICE REQUEST ANALYTICS AND DEBUGGING
  // Enhanced debugging capabilities for existing request methods
  // Based on comprehensive Postman collection analysis
  // ====================================================================

  // /// Enhanced debug logging for service request analytics
  // /// Provides comprehensive business intelligence for service request data
  // void _logServiceRequestAnalytics(
  //     List<ServiceRequest> requests, String operation) {
  //   debugPrint('🔧 ServiceManagementService: 📊 ENHANCED REQUEST ANALYTICS');
  //   debugPrint('🔧 → Operation: $operation');
  //   debugPrint('🔧 → Total Requests Analyzed: ${requests.length}');
  //   debugPrint('🔧 → Analysis Timestamp: ${DateTime.now().toIso8601String()}');

  //   if (requests.isNotEmpty) {
  //     // Enhanced Budget Analysis with market insights
  //     final budgets = requests
  //         .where((r) => r.budgetMax > 0)
  //         .map((r) => r.budgetMax)
  //         .toList();
  //     if (budgets.isNotEmpty) {
  //       final avgBudget = budgets.reduce((a, b) => a + b) / budgets.length;
  //       final maxBudget = budgets.reduce((a, b) => a > b ? a : b);
  //       final minBudget = budgets.reduce((a, b) => a < b ? a : b);
  //       final totalMarketValue = budgets.reduce((a, b) => a + b);

  //       debugPrint('🔧 → 💰 ENHANCED BUDGET ANALYSIS:');
  //       debugPrint('🔧   → Average Budget: ₹${avgBudget.toStringAsFixed(2)}');
  //       debugPrint(
  //           '🔧   → Budget Range: ₹${minBudget.toStringAsFixed(2)} - ₹${maxBudget.toStringAsFixed(2)}');
  //       debugPrint(
  //           '🔧   → Total Market Value: ₹${totalMarketValue.toStringAsFixed(2)}');
  //       debugPrint(
  //           '🔧   → Premium Requests (>₹5000): ${budgets.where((b) => b > 5000).length}');
  //       debugPrint(
  //           '🔧   → Economy Requests (<₹1000): ${budgets.where((b) => b < 1000).length}');
  //       debugPrint(
  //           '🔧   → Mid-range Requests (₹1000-₹5000): ${budgets.where((b) => b >= 1000 && b <= 5000).length}');

  //       // Budget percentile analysis
  //       budgets.sort();
  //       final p50 = budgets[budgets.length ~/ 2];
  //       final p90 = budgets[(budgets.length * 0.9).round() - 1];
  //       debugPrint(
  //           '🔧   → Median Budget (50th percentile): ₹${p50.toStringAsFixed(2)}');
  //       debugPrint('🔧   → 90th Percentile Budget: ₹${p90.toStringAsFixed(2)}');
  //     }

  //     // Enhanced Status Distribution with performance metrics
  //     final statusCounts = <String, int>{};
  //     for (final request in requests) {
  //       statusCounts[request.status] = (statusCounts[request.status] ?? 0) + 1;
  //     }
  //     debugPrint('🔧 → 📈 ENHANCED STATUS DISTRIBUTION:');
  //     statusCounts.forEach((status, count) {
  //       final percentage = (count / requests.length * 100).toStringAsFixed(1);
  //       final emoji = status == 'open'
  //           ? '🟢'
  //           : status == 'assigned'
  //               ? '🟡'
  //               : status == 'completed'
  //                   ? '✅'
  //                   : status == 'cancelled'
  //                       ? '❌'
  //                       : '⚪';
  //       debugPrint('🔧   → $emoji $status: $count requests ($percentage%)');
  //     });

  //     // Conversion funnel analysis
  //     final openRequests = statusCounts['open'] ?? 0;
  //     final assignedRequests = statusCounts['assigned'] ?? 0;
  //     final completedRequests = statusCounts['completed'] ?? 0;
  //     final cancelledRequests = statusCounts['cancelled'] ?? 0;

  //     if (openRequests > 0) {
  //       final assignmentRate =
  //           (assignedRequests / openRequests * 100).toStringAsFixed(1);
  //       final completionRate =
  //           (completedRequests / (assignedRequests + completedRequests) * 100)
  //               .toStringAsFixed(1);
  //       debugPrint('🔧   → Assignment Rate: $assignmentRate%');
  //       debugPrint('🔧   → Completion Rate: $completionRate%');
  //       debugPrint(
  //           '🔧   → Cancellation Rate: ${(cancelledRequests / requests.length * 100).toStringAsFixed(1)}%');
  //     }

  //     // Enhanced Urgency Analysis with business impact
  //     final urgencyCounts = <String, int>{};
  //     final urgencyRevenue = <String, double>{};
  //     for (final request in requests) {
  //       urgencyCounts[request.urgency] =
  //           (urgencyCounts[request.urgency] ?? 0) + 1;
  //       urgencyRevenue[request.urgency] =
  //           (urgencyRevenue[request.urgency] ?? 0) + request.budgetMax;
  //     }
  //     debugPrint('🔧 → ⚡ ENHANCED URGENCY ANALYSIS:');
  //     urgencyCounts.forEach((urgency, count) {
  //       final percentage = (count / requests.length * 100).toStringAsFixed(1);
  //       final revenue = urgencyRevenue[urgency] ?? 0;
  //       final emoji = urgency == 'urgent'
  //           ? '🔴'
  //           : urgency == 'high'
  //               ? '🟡'
  //               : urgency == 'medium'
  //                   ? '🟠'
  //                   : '🟢';
  //       debugPrint(
  //           '🔧   → $emoji $urgency: $count requests ($percentage%, ₹${revenue.toStringAsFixed(2)} potential revenue)');
  //     });

  //     // Enhanced Geographic Analysis with market penetration
  //     // final locations = requests.where((r) => r.location.isNotEmpty).map((r) => r.location).toList();
  //     final locationCounts = <String, int>{};
  //     final locationRevenue = <String, double>{};

  //     for (final request in requests) {
  //       if (request.location.isNotEmpty) {
  //         locationCounts[request.location] =
  //             (locationCounts[request.location] ?? 0) + 1;
  //         locationRevenue[request.location] =
  //             (locationRevenue[request.location] ?? 0) + request.budgetMax;
  //       }
  //     }

  //     debugPrint('🔧 → 🌍 ENHANCED GEOGRAPHIC ANALYSIS:');
  //     debugPrint('🔧   → Unique Locations: ${locationCounts.length}');
  //     debugPrint(
  //         '🔧   → Geographic Coverage: ${(locationCounts.length > 10 ? 'EXCELLENT' : locationCounts.length > 5 ? 'GOOD' : 'LIMITED')}');

  //     final sortedLocations = locationCounts.entries.toList()
  //       ..sort((a, b) => b.value.compareTo(a.value));
  //     for (int i = 0; i < sortedLocations.length && i < 5; i++) {
  //       final entry = sortedLocations[i];
  //       final revenue = locationRevenue[entry.key] ?? 0;
  //       debugPrint(
  //           '🔧   → Top ${i + 1}: ${entry.key} (${entry.value} requests, ₹${revenue.toStringAsFixed(2)} potential)');
  //     }

  //     // Enhanced Time Analysis with velocity metrics
  //     final now = DateTime.now();
  //     final recentRequests = requests
  //         .where((r) => now.difference(r.createdAt).inHours < 24)
  //         .length;
  //     final weeklyRequests =
  //         requests.where((r) => now.difference(r.createdAt).inDays < 7).length;
  //     final monthlyRequests =
  //         requests.where((r) => now.difference(r.createdAt).inDays < 30).length;
  //     final expiringRequests = requests
  //         .where((r) =>
  //             r.expiresAt != null && r.expiresAt!.difference(now).inDays <= 7)
  //         .length;

  //     debugPrint('🔧 → ⏰ ENHANCED TIME-BASED INSIGHTS:');
  //     debugPrint('🔧   → Recent Activity (24h): $recentRequests requests');
  //     debugPrint('🔧   → Weekly Activity (7d): $weeklyRequests requests');
  //     debugPrint('🔧   → Monthly Activity (30d): $monthlyRequests requests');
  //     debugPrint('🔧   → Expiring Soon (7d): $expiringRequests requests');

  //     // Request velocity and trend analysis
  //     if (requests.length > 1) {
  //       final requestTimes = requests.map((r) => r.createdAt).toList()..sort();
  //       final timeGaps = <Duration>[];
  //       for (int i = 1; i < requestTimes.length; i++) {
  //         timeGaps.add(requestTimes[i].difference(requestTimes[i - 1]));
  //       }
  //       if (timeGaps.isNotEmpty) {
  //         final avgGapHours =
  //             timeGaps.map((g) => g.inHours).reduce((a, b) => a + b) /
  //                 timeGaps.length;
  //         final requestsPerDay = 24 / avgGapHours;
  //         debugPrint(
  //             '🔧   → Average Request Interval: ${avgGapHours.toStringAsFixed(1)} hours');
  //         debugPrint(
  //             '🔧   → Request Velocity: ${requestsPerDay.toStringAsFixed(1)} requests/day');
  //         debugPrint(
  //             '🔧   → Market Activity Level: ${requestsPerDay > 10 ? '🔥 HIGH' : requestsPerDay > 5 ? '📈 MODERATE' : '📉 LOW'}');
  //       }
  //     }

  //     // Category analysis if available
  //     final categoryDistribution = <String, int>{};
  //     for (final request in requests) {
  //       final categoryName = request.category['name'] ?? 'Unknown';
  //       categoryDistribution[categoryName] =
  //           (categoryDistribution[categoryName] ?? 0) + 1;
  //     }

  //     if (categoryDistribution.isNotEmpty && categoryDistribution.length > 1) {
  //       debugPrint('🔧 → 📂 CATEGORY DEMAND ANALYSIS:');
  //       final sortedCategories = categoryDistribution.entries.toList()
  //         ..sort((a, b) => b.value.compareTo(a.value));
  //       for (int i = 0; i < sortedCategories.length && i < 5; i++) {
  //         final entry = sortedCategories[i];
  //         final percentage =
  //             (entry.value / requests.length * 100).toStringAsFixed(1);
  //         debugPrint(
  //             '🔧   → ${i + 1}. ${entry.key}: ${entry.value} requests ($percentage%)');
  //       }
  //     }

  //     // Customer behavior insights
  //     final customerIds = requests
  //         .map((r) => r.customer['id'])
  //         .where((id) => id != null)
  //         .toSet();
  //     final repeatCustomers = customerIds.length < requests.length
  //         ? requests.length - customerIds.length
  //         : 0;

  //     debugPrint('🔧 → 👥 CUSTOMER BEHAVIOR INSIGHTS:');
  //     debugPrint('🔧   → Unique Customers: ${customerIds.length}');
  //     debugPrint('🔧   → Repeat Requests: $repeatCustomers');
  //     if (customerIds.isNotEmpty) {
  //       final avgRequestsPerCustomer =
  //           (requests.length / customerIds.length).toStringAsFixed(1);
  //       debugPrint('🔧   → Avg Requests per Customer: $avgRequestsPerCustomer');
  //       debugPrint(
  //           '🔧   → Customer Loyalty: ${double.parse(avgRequestsPerCustomer) > 1.5 ? '🟢 HIGH' : '🟡 MODERATE'}');
  //     }
  //   } else {
  //     debugPrint('🔧 → ⚠️ No requests available for analysis');
  //     debugPrint(
  //         '🔧   → Possible Reasons: Empty dataset, filters too restrictive, or API issues');
  //     debugPrint(
  //         '🔧   → Recommendations: Check filters, verify API connectivity, or expand search criteria');
  //   }

  //   debugPrint('🔧 ServiceManagementService: 📊 Analytics Complete');
  // }

  // /// Enhanced provider matching analytics for AI recommendations
  // /// Analyzes provider recommendation patterns and success rates
  // void _logProviderMatchingAnalytics(
  //     List<Map<String, dynamic>> providers, String requestId) {
  //   debugPrint(
  //       '🔧 ServiceManagementService: 🤖 AI PROVIDER MATCHING ANALYTICS');
  //   debugPrint('🔧 → Request ID: $requestId');
  //   debugPrint('🔧 → Providers Analyzed: ${providers.length}');

  //   if (providers.isNotEmpty) {
  //     // Match score analysis
  //     final scores = providers
  //         .where((p) => p['match_score'] != null)
  //         .map((p) => double.tryParse(p['match_score'].toString()) ?? 0.0)
  //         .toList();

  //     if (scores.isNotEmpty) {
  //       final avgScore = scores.reduce((a, b) => a + b) / scores.length;
  //       final maxScore = scores.reduce((a, b) => a > b ? a : b);
  //       final minScore = scores.reduce((a, b) => a < b ? a : b);

  //       debugPrint('🔧 → 🎯 MATCH SCORE ANALYSIS:');
  //       debugPrint(
  //           '🔧   → Average Match Score: ${avgScore.toStringAsFixed(1)}%');
  //       debugPrint(
  //           '🔧   → Score Range: ${minScore.toStringAsFixed(1)}% - ${maxScore.toStringAsFixed(1)}%');
  //       debugPrint(
  //           '🔧   → High Quality Matches (>80%): ${scores.where((s) => s > 80).length}');
  //       debugPrint(
  //           '🔧   → Acceptable Matches (60-80%): ${scores.where((s) => s >= 60 && s <= 80).length}');
  //       debugPrint(
  //           '🔧   → Low Quality Matches (<60%): ${scores.where((s) => s < 60).length}');
  //     }

  //     // Provider rating analysis
  //     final ratings = providers
  //         .where((p) => p['rating'] != null)
  //         .map((p) => double.tryParse(p['rating'].toString()) ?? 0.0)
  //         .toList();

  //     if (ratings.isNotEmpty) {
  //       final avgRating = ratings.reduce((a, b) => a + b) / ratings.length;
  //       debugPrint('🔧 → ⭐ PROVIDER QUALITY ANALYSIS:');
  //       debugPrint(
  //           '🔧   → Average Provider Rating: ${avgRating.toStringAsFixed(1)}/5.0');
  //       debugPrint(
  //           '🔧   → Premium Providers (>4.5): ${ratings.where((r) => r > 4.5).length}');
  //       debugPrint(
  //           '🔧   → Quality Providers (4.0-4.5): ${ratings.where((r) => r >= 4.0 && r <= 4.5).length}');
  //       debugPrint(
  //           '🔧   → Standard Providers (<4.0): ${ratings.where((r) => r < 4.0).length}');
  //     }

  //     // Distance analysis (if available)
  //     final distances = providers
  //         .where((p) => p['distance_km'] != null)
  //         .map((p) => double.tryParse(p['distance_km'].toString()) ?? 0.0)
  //         .toList();

  //     if (distances.isNotEmpty) {
  //       final avgDistance =
  //           distances.reduce((a, b) => a + b) / distances.length;
  //       debugPrint('🔧 → 📍 PROXIMITY ANALYSIS:');
  //       debugPrint(
  //           '🔧   → Average Distance: ${avgDistance.toStringAsFixed(1)} km');
  //       debugPrint(
  //           '🔧   → Local Providers (<5km): ${distances.where((d) => d < 5).length}');
  //       debugPrint(
  //           '🔧   → Regional Providers (5-15km): ${distances.where((d) => d >= 5 && d <= 15).length}');
  //       debugPrint(
  //           '🔧   → Remote Providers (>15km): ${distances.where((d) => d > 15).length}');
  //     }

  //     // Log top recommendations
  //     debugPrint('🔧 → 🏆 TOP PROVIDER RECOMMENDATIONS:');
  //     for (int i = 0; i < providers.length && i < 5; i++) {
  //       final provider = providers[i];
  //       final username = provider['username'] ?? 'Unknown';
  //       final score = provider['match_score']?.toString() ?? 'N/A';
  //       final rating = provider['rating']?.toString() ?? 'N/A';
  //       final distance = provider['distance_km']?.toString() ?? 'N/A';
  //       debugPrint(
  //           '🔧   → ${i + 1}. $username (Score: $score%, Rating: $rating/5, Distance: ${distance}km)');
  //     }
  //   }
  // }

  // /// Debug helper for request creation validation
  // /// Provides detailed validation feedback for service request creation
  // Map<String, dynamic> _validateServiceRequestInput({
  //   required String title,
  //   required String description,
  //   required String categoryId,
  //   required double budgetMin,
  //   required double budgetMax,
  //   required String urgency,
  //   required String location,
  //   required DateTime requestedDateTime,
  // }) {
  //   debugPrint('🔧 ServiceManagementService: 🔍 SERVICE REQUEST VALIDATION');
  //   debugPrint('🔧 → Validating input parameters...');

  //   final validationErrors = <String>[];
  //   final warnings = <String>[];
  //   final suggestions = <String>[];

  //   // Title validation with enhanced feedback
  //   if (title.trim().isEmpty) {
  //     validationErrors.add('Title cannot be empty');
  //   } else if (title.length < 10) {
  //     warnings.add('Title is quite short - consider adding more details');
  //   } else if (title.length > 200) {
  //     validationErrors.add('Title cannot exceed 200 characters');
  //   }

  //   // Description validation with content analysis
  //   if (description.trim().isEmpty) {
  //     validationErrors.add('Description cannot be empty');
  //   } else if (description.length < 20) {
  //     warnings.add(
  //         'Description is brief - adding more details helps providers understand your needs');
  //   } else if (description.length > 2000) {
  //     validationErrors.add('Description cannot exceed 2000 characters');
  //   }

  //   // Budget validation with market insights
  //   if (budgetMin <= 0) {
  //     validationErrors.add('Minimum budget must be greater than 0');
  //   } else if (budgetMin < 100) {
  //     warnings
  //         .add('Budget seems low - consider if this covers fair compensation');
  //   }

  //   if (budgetMax <= budgetMin) {
  //     validationErrors
  //         .add('Maximum budget must be greater than minimum budget');
  //   } else if (budgetMax > 1000000) {
  //     validationErrors.add('Maximum budget cannot exceed ₹10,00,000');
  //   }

  //   final budgetRange = budgetMax - budgetMin;
  //   if (budgetRange < (budgetMin * 0.2)) {
  //     suggestions
  //         .add('Consider widening budget range to attract more providers');
  //   }

  //   // Urgency validation
  //   if (!['low', 'medium', 'high', 'urgent'].contains(urgency)) {
  //     validationErrors.add('Urgency must be one of: low, medium, high, urgent');
  //   }

  //   // Location validation
  //   if (location.trim().isEmpty) {
  //     validationErrors.add('Location cannot be empty');
  //   } else if (location.length < 5) {
  //     warnings.add(
  //         'Location seems incomplete - be more specific for better provider matching');
  //   }

  //   // Date validation with scheduling insights
  //   final now = DateTime.now();
  //   if (requestedDateTime.isBefore(now)) {
  //     validationErrors.add('Requested date/time cannot be in the past');
  //   } else if (requestedDateTime.difference(now).inHours < 4 &&
  //       urgency != 'urgent') {
  //     warnings.add(
  //         'Short notice request - consider marking as urgent or adjusting timeline');
  //   } else if (requestedDateTime.difference(now).inDays > 30) {
  //     suggestions.add(
  //         'Long-term request - providers may not be available this far in advance');
  //   }

  //   debugPrint('🔧 → Validation Results:');
  //   debugPrint('🔧   → Errors: ${validationErrors.length}');
  //   debugPrint('🔧   → Warnings: ${warnings.length}');
  //   debugPrint('🔧   → Suggestions: ${suggestions.length}');

  //   if (validationErrors.isNotEmpty) {
  //     debugPrint('🔧   → ❌ VALIDATION ERRORS:');
  //     for (var error in validationErrors) {
  //       debugPrint('🔧     → $error');
  //     }
  //   }

  //   if (warnings.isNotEmpty) {
  //     debugPrint('🔧   → ⚠️ WARNINGS:');
  //     for (var warning in warnings) {
  //       debugPrint('🔧     → $warning');
  //     }
  //   }

  //   if (suggestions.isNotEmpty) {
  //     debugPrint('🔧   → 💡 SUGGESTIONS:');
  //     for (var suggestion in suggestions) {
  //       debugPrint('🔧     → $suggestion');
  //     }
  //   }

  //   return {
  //     'valid': validationErrors.isEmpty,
  //     'errors': validationErrors,
  //     'warnings': warnings,
  //     'suggestions': suggestions,
  //     'validation_score':
  //         validationErrors.isEmpty ? (warnings.isEmpty ? 100 : 85) : 0,
  //   };
  // }
}
