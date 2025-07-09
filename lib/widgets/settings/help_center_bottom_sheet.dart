import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:prbal/widgets/settings/contact_us_bottom_sheet.dart';

/// ====================================================================
/// HELP CENTER BOTTOM SHEET - COMPREHENSIVE THEMEMANAGER INTEGRATION
/// ====================================================================
///
/// ✅ **COMPREHENSIVE HELP CENTER MODAL WITH THEMEMANAGER** ✅
///
/// **🎨 ENHANCED FEATURES:**
/// - Modern Material Design 3.0 modal bottom sheet
/// - Comprehensive search functionality with real-time filtering
/// - Categorized help sections (Account, Services, Payments, Technical)
/// - Expandable FAQ items with smooth animations
/// - Contact options with direct actions
/// - Professional theming with ThemeManager integration
/// - Glass morphism effects and gradient backgrounds
/// - Responsive design with ScreenUtil
/// - Comprehensive debug logging
/// ====================================================================

class HelpCenterBottomSheet extends StatefulWidget {
  const HelpCenterBottomSheet({super.key});

  @override
  State<HelpCenterBottomSheet> createState() => _HelpCenterBottomSheetState();

  /// Show help center modal bottom sheet
  static void show(BuildContext context) {
    debugPrint('🆘 [HelpCenter] Showing help center modal');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 128),
      useSafeArea: true,
      builder: (context) => const HelpCenterBottomSheet(),
    );
  }
}

class _HelpCenterBottomSheetState extends State<HelpCenterBottomSheet> with TickerProviderStateMixin, ThemeAwareMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  int? _expandedIndex;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint('🆘 [HelpCenter] Initializing help center');

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    debugPrint('🆘 [HelpCenter] Disposed help center resources');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🆘 [HelpCenter] Building help center with theme colors:');
    debugPrint('🆘 [HelpCenter] Background: ${ThemeManager.of(context).backgroundColor}');
    debugPrint('🆘 [HelpCenter] Surface: ${ThemeManager.of(context).surfaceColor}');
    debugPrint('🆘 [HelpCenter] Primary: ${ThemeManager.of(context).primaryColor}');

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              gradient: ThemeManager.of(context).backgroundGradient,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeManager.of(context).shadowDark.withValues(alpha: 77),
                  blurRadius: 20.r,
                  offset: Offset(0, -4.h),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildHeader(),
                _buildSearchSection(),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).surfaceGradient,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
        border: Border(
          bottom: BorderSide(
            color: ThemeManager.of(context).borderColor.withValues(alpha: 51),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              gradient: ThemeManager.of(context).primaryGradient,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header row
          Row(
            children: [
              // Icon with gradient background
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  gradient: ThemeManager.of(context).infoGradient,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeManager.of(context).infoColor.withValues(alpha: 51),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Icon(
                  Prbal.questionCircle,
                  color: ThemeManager.of(context).textInverted,
                  size: 24.sp,
                ),
              ),

              SizedBox(width: 16.w),

              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Help Center',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: ThemeManager.of(context).textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Get help and find answers',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ThemeManager.of(context).textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Close button
              GestureDetector(
                onTap: () {
                  debugPrint('🆘 [HelpCenter] Closing help center');
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: ThemeManager.of(context).surfaceElevated.withValues(alpha: 128),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: ThemeManager.of(context).borderColor.withValues(alpha: 51),
                    ),
                  ),
                  child: Icon(
                    Icons.close,
                    color: ThemeManager.of(context).textSecondary,
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Container(
        decoration: BoxDecoration(
          color: ThemeManager.of(context).inputBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ThemeManager.of(context).borderColor.withValues(alpha: 77),
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeManager.of(context).shadowLight.withValues(alpha: 51),
              blurRadius: 4.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search help topics...',
            hintStyle: TextStyle(
              color: ThemeManager.of(context).textTertiary,
              fontSize: 14.sp,
            ),
            prefixIcon: Icon(
              Prbal.search,
              color: ThemeManager.of(context).textSecondary,
              size: 20.sp,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                    child: Icon(
                      Icons.clear,
                      color: ThemeManager.of(context).textSecondary,
                      size: 20.sp,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
          style: TextStyle(
            color: ThemeManager.of(context).textPrimary,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final filteredCategories = _getFilteredCategories();

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        if (_searchQuery.isEmpty) ...[
          // Quick actions when not searching
          SliverToBoxAdapter(
            child: _buildQuickActions(),
          ),
        ],

        // Help categories
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final category = filteredCategories[index];
              return _buildHelpCategory(category, index);
            },
            childCount: filteredCategories.length,
          ),
        ),

        // Contact section
        SliverToBoxAdapter(
          child: _buildContactSection(),
        ),

        // Bottom padding
        SliverToBoxAdapter(
          child: SizedBox(height: 20.h),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: ThemeManager.of(context).textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'Contact Support',
                  Prbal.envelope,
                  ThemeManager.of(context).successColor,
                  () => debugPrint('🆘 [HelpCenter] Contact support tapped'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildQuickActionCard(
                  'Report Issue',
                  Prbal.exclamationTriangle,
                  ThemeManager.of(context).warningColor,
                  () => debugPrint('🆘 [HelpCenter] Report issue tapped'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color accentColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              accentColor.withValues(alpha: 26),
              accentColor.withValues(alpha: 13),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: accentColor.withValues(alpha: 51),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: accentColor,
              size: 24.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: ThemeManager.of(context).textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpCategory(HelpCategory category, int categoryIndex) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).surfaceGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ThemeManager.of(context).borderColor.withValues(alpha: 51),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeManager.of(context).shadowLight.withValues(alpha: 51),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  category.color.withValues(alpha: 26),
                  category.color.withValues(alpha: 13),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  category.icon,
                  color: category.color,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    category.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ThemeManager.of(context).textPrimary,
                    ),
                  ),
                ),
                Text(
                  '${category.items.length} topics',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: ThemeManager.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // FAQ items
          ...category.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final globalIndex = categoryIndex * 100 + index;

            return _buildFAQItem(item, globalIndex, category.color);
          }),
        ],
      ),
    );
  }

  Widget _buildFAQItem(FAQItem item, int index, Color accentColor) {
    final isExpanded = _expandedIndex == index;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: ThemeManager.of(context).borderColor.withValues(alpha: 26),
          ),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
              debugPrint('🆘 [HelpCenter] FAQ item ${isExpanded ? "collapsed" : "expanded"}: ${item.question}');
            },
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.question,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: ThemeManager.of(context).textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: accentColor,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: isExpanded ? null : 0,
            child: isExpanded
                ? Container(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    child: Text(
                      item.answer,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: ThemeManager.of(context).textSecondary,
                        height: 1.4,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeManager.of(context).primaryColor.withValues(alpha: 26),
            ThemeManager.of(context).primaryColor.withValues(alpha: 13),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ThemeManager.of(context).primaryColor.withValues(alpha: 51),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Still need help?',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: ThemeManager.of(context).textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Our support team is here to help you',
            style: TextStyle(
              fontSize: 14.sp,
              color: ThemeManager.of(context).textSecondary,
            ),
          ),
          SizedBox(height: 16.h),

          // Contact button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                debugPrint('🆘 [HelpCenter] Contact support button tapped');
                Navigator.of(context).pop();
                // Open contact form modal
                ContactUsBottomSheet.show(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeManager.of(context).primaryColor,
                foregroundColor: ThemeManager.of(context).textInverted,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Prbal.envelope,
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Contact Support',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<HelpCategory> _getFilteredCategories() {
    final categories = _getHelpCategories();

    if (_searchQuery.isEmpty) {
      return categories;
    }

    return categories
        .map((category) {
          final filteredItems = category.items
              .where((item) =>
                  item.question.toLowerCase().contains(_searchQuery) ||
                  item.answer.toLowerCase().contains(_searchQuery))
              .toList();

          return HelpCategory(
            title: category.title,
            icon: category.icon,
            color: category.color,
            items: filteredItems,
          );
        })
        .where((category) => category.items.isNotEmpty)
        .toList();
  }

  List<HelpCategory> _getHelpCategories() {
    return [
      HelpCategory(
        title: 'Account & Profile',
        icon: Prbal.user,
        color: ThemeManager.of(context).accent1,
        items: [
          FAQItem(
            question: 'How do I update my profile information?',
            answer:
                'Go to Settings > Profile to update your personal information, including name, email, and profile picture.',
          ),
          FAQItem(
            question: 'How do I change my password?',
            answer:
                'Navigate to Settings > Security to change your password. You\'ll need to enter your current password first.',
          ),
          FAQItem(
            question: 'How do I verify my account?',
            answer:
                'Account verification is done through phone number confirmation. Check your SMS for the verification code.',
          ),
        ],
      ),
      HelpCategory(
        title: 'Services & Bookings',
        icon: Prbal.briefcase,
        color: ThemeManager.of(context).accent2,
        items: [
          FAQItem(
            question: 'How do I book a service?',
            answer:
                'Browse available services, select your preferred provider, choose a time slot, and confirm your booking.',
          ),
          FAQItem(
            question: 'Can I cancel my booking?',
            answer: 'Yes, you can cancel bookings up to 24 hours before the scheduled time through the Orders section.',
          ),
          FAQItem(
            question: 'How do I become a service provider?',
            answer:
                'Switch to Provider mode in Settings and complete the verification process to start offering services.',
          ),
        ],
      ),
      HelpCategory(
        title: 'Payments & Billing',
        icon: Prbal.creditCard,
        color: ThemeManager.of(context).successColor,
        items: [
          FAQItem(
            question: 'What payment methods are accepted?',
            answer: 'We accept credit cards, debit cards, UPI, and wallet payments for secure transactions.',
          ),
          FAQItem(
            question: 'How do I get a refund?',
            answer:
                'Refunds are processed automatically for cancelled services. Contact support for other refund requests.',
          ),
          FAQItem(
            question: 'Where can I see my payment history?',
            answer:
                'Check your payment history in Settings > Payments or in the Orders section for booking-specific payments.',
          ),
        ],
      ),
      HelpCategory(
        title: 'Technical Support',
        icon: Prbal.cog,
        color: ThemeManager.of(context).warningColor,
        items: [
          FAQItem(
            question: 'The app is not working properly',
            answer:
                'Try closing and reopening the app. If the issue persists, check for app updates in your app store.',
          ),
          FAQItem(
            question: 'I\'m not receiving notifications',
            answer: 'Check your device notification settings and ensure Prbal has permission to send notifications.',
          ),
          FAQItem(
            question: 'How do I report a bug?',
            answer:
                'Use the "Report Issue" option in the help center or contact our support team with details about the problem.',
          ),
        ],
      ),
    ];
  }
}

/// Help category model
class HelpCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<FAQItem> items;

  HelpCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
}

/// FAQ item model
class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}
