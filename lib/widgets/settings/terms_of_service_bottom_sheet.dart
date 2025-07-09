import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:prbal/widgets/settings/contact_us_bottom_sheet.dart';

/// ====================================================================
/// TERMS OF SERVICE BOTTOM SHEET - COMPREHENSIVE THEMEMANAGER INTEGRATION
/// ====================================================================
///
/// ✅ **COMPREHENSIVE TERMS OF SERVICE MODAL WITH THEMEMANAGER** ✅
///
/// **🎨 ENHANCED FEATURES:**
/// - Modern Material Design 3.0 modal bottom sheet
/// - Comprehensive terms of service with categorized sections
/// - Search functionality for finding specific terms
/// - Expandable sections with smooth animations
/// - Last updated information and version tracking
/// - Professional theming with ThemeManager integration
/// - Glass morphism effects and gradient backgrounds
/// - Responsive design with ScreenUtil
/// - Comprehensive debug logging
/// ====================================================================

class TermsOfServiceBottomSheet extends StatefulWidget {
  const TermsOfServiceBottomSheet({super.key});

  @override
  State<TermsOfServiceBottomSheet> createState() => _TermsOfServiceBottomSheetState();

  /// Show terms of service modal bottom sheet
  static void show(BuildContext context) {
    debugPrint('📋 [Terms] Showing terms of service modal');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 128),
      useSafeArea: true,
      builder: (context) => const TermsOfServiceBottomSheet(),
    );
  }
}

class _TermsOfServiceBottomSheetState extends State<TermsOfServiceBottomSheet>
    with TickerProviderStateMixin, ThemeAwareMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  int? _expandedIndex;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint('📋 [Terms] Initializing terms of service');

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 0.3,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
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
    debugPrint('📋 [Terms] Disposed terms of service resources');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('📋 [Terms] Building terms of service with theme colors:');
    debugPrint('📋 [Terms] Background: ${ThemeManager.of(context).backgroundColor}');
    debugPrint('📋 [Terms] Surface: ${ThemeManager.of(context).surfaceColor}');
    debugPrint('📋 [Terms] Accent: ${ThemeManager.of(context).accent2}');

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value * MediaQuery.of(context).size.height),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.92,
              decoration: BoxDecoration(
                gradient: ThemeManager.of(context).backgroundGradient,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ThemeManager.of(context).shadowDark.withValues(alpha: 102),
                    blurRadius: 24.r,
                    offset: Offset(0, -6.h),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildHeader(),
                  _buildSearchSection(),
                  _buildVersionInfo(),
                  Expanded(
                    child: _buildContent(),
                  ),
                ],
              ),
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
              gradient: LinearGradient(
                colors: [
                  ThemeManager.of(context).accent2.withValues(alpha: 179),
                  ThemeManager.of(context).accent2,
                ],
              ),
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
                  gradient: LinearGradient(
                    colors: [
                      ThemeManager.of(context).accent2,
                      ThemeManager.of(context).accent2.withValues(alpha: 204),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeManager.of(context).accent2.withValues(alpha: 51),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Icon(
                  Prbal.file,
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
                      'Terms of Service',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: ThemeManager.of(context).textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Terms and conditions of use',
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
                  debugPrint('📋 [Terms] Closing terms of service');
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
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
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
            hintText: 'Search terms and conditions...',
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

  Widget _buildVersionInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeManager.of(context).infoColor.withValues(alpha: 26),
            ThemeManager.of(context).infoColor.withValues(alpha: 13),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: ThemeManager.of(context).infoColor.withValues(alpha: 51),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Prbal.info,
            color: ThemeManager.of(context).infoColor,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'Version 2.1 • Last updated: December 15, 2024',
              style: TextStyle(
                fontSize: 12.sp,
                color: ThemeManager.of(context).textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final filteredSections = _getFilteredSections();

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: 16.h),
        ),

        // Introduction section
        if (_searchQuery.isEmpty)
          SliverToBoxAdapter(
            child: _buildIntroductionSection(),
          ),

        // Terms sections
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final section = filteredSections[index];
              return _buildTermsSection(section, index);
            },
            childCount: filteredSections.length,
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

  Widget _buildIntroductionSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeManager.of(context).primaryColor.withValues(alpha: 26),
            ThemeManager.of(context).primaryColor.withValues(alpha: 13),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ThemeManager.of(context).primaryColor.withValues(alpha: 51),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Prbal',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: ThemeManager.of(context).textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'These terms of service govern your use of Prbal and its services. By using our platform, you agree to these terms. Please read them carefully.',
            style: TextStyle(
              fontSize: 14.sp,
              color: ThemeManager.of(context).textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSection(TermsSection section, int sectionIndex) {
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
          // Section header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  section.color.withValues(alpha: 26),
                  section.color.withValues(alpha: 13),
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
                  section.icon,
                  color: section.color,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    section.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ThemeManager.of(context).textPrimary,
                    ),
                  ),
                ),
                Text(
                  '${section.items.length} clauses',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: ThemeManager.of(context).textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Terms items
          ...section.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final globalIndex = sectionIndex * 100 + index;

            return _buildTermsItem(item, globalIndex, section.color);
          }),
        ],
      ),
    );
  }

  Widget _buildTermsItem(TermsItem item, int index, Color accentColor) {
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
              debugPrint('📋 [Terms] Terms item ${isExpanded ? "collapsed" : "expanded"}: ${item.title}');
            },
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Container(
                    width: 6.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      item.title,
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
                    padding: EdgeInsets.fromLTRB(34.w, 0, 16.w, 16.h),
                    child: Text(
                      item.content,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: ThemeManager.of(context).textSecondary,
                        height: 1.5,
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
            ThemeManager.of(context).successColor.withValues(alpha: 26),
            ThemeManager.of(context).successColor.withValues(alpha: 13),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ThemeManager.of(context).successColor.withValues(alpha: 51),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Prbal.envelope,
                color: ThemeManager.of(context).successColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Questions about these terms?',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: ThemeManager.of(context).textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'If you have any questions about these terms of service, please contact our legal team.',
            style: TextStyle(
              fontSize: 14.sp,
              color: ThemeManager.of(context).textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    debugPrint('📋 [Terms] Contact legal team tapped');
                    Navigator.of(context).pop();
                    // Open contact form modal
                    ContactUsBottomSheet.show(context);
                  },
                  icon: Icon(
                    Prbal.envelope,
                    size: 16.sp,
                  ),
                  label: Text(
                    'Contact Legal Team',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ThemeManager.of(context).successColor,
                    side: BorderSide(
                      color: ThemeManager.of(context).successColor.withValues(alpha: 128),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<TermsSection> _getFilteredSections() {
    final sections = _getTermsSections();

    if (_searchQuery.isEmpty) {
      return sections;
    }

    return sections
        .map((section) {
          final filteredItems = section.items
              .where((item) =>
                  item.title.toLowerCase().contains(_searchQuery) || item.content.toLowerCase().contains(_searchQuery))
              .toList();

          return TermsSection(
            title: section.title,
            icon: section.icon,
            color: section.color,
            items: filteredItems,
          );
        })
        .where((section) => section.items.isNotEmpty)
        .toList();
  }

  List<TermsSection> _getTermsSections() {
    return [
      TermsSection(
        title: 'Acceptance & Agreement',
        icon: Prbal.handshakeO,
        color: ThemeManager.of(context).primaryColor,
        items: [
          TermsItem(
            title: 'Acceptance of Terms',
            content:
                'By accessing and using Prbal, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
          ),
          TermsItem(
            title: 'Legal Age Requirement',
            content:
                'You must be at least 18 years of age to use this service. By using Prbal, you warrant that you are at least 18 years of age and have the legal capacity to enter into this agreement.',
          ),
          TermsItem(
            title: 'Changes to Terms',
            content:
                'Prbal reserves the right to change these terms of service at any time. We will notify users of significant changes via email or in-app notification. Continued use of the service constitutes acceptance of the modified terms.',
          ),
        ],
      ),
      TermsSection(
        title: 'User Accounts & Registration',
        icon: Prbal.userPlus,
        color: ThemeManager.of(context).accent1,
        items: [
          TermsItem(
            title: 'Account Creation',
            content:
                'To access certain features of Prbal, you must register for an account. You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete.',
          ),
          TermsItem(
            title: 'Account Security',
            content:
                'You are responsible for safeguarding the password and PIN that you use to access the service. You agree not to disclose your password or PIN to any third party and to take sole responsibility for any activities or actions under your account.',
          ),
          TermsItem(
            title: 'Account Termination',
            content:
                'We may terminate or suspend your account and bar access to the service immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever and without limitation, including but not limited to a breach of the terms.',
          ),
        ],
      ),
      TermsSection(
        title: 'Service Usage & Conduct',
        icon: Prbal.cog,
        color: ThemeManager.of(context).accent2,
        items: [
          TermsItem(
            title: 'Permitted Use',
            content:
                'Prbal is a platform for connecting service providers with users seeking services. You may use our service only for lawful purposes and in accordance with these terms. You agree not to use the service in any way that violates any applicable law or regulation.',
          ),
          TermsItem(
            title: 'Prohibited Activities',
            content:
                'You agree not to engage in any of the following prohibited activities: impersonating others, harassment, uploading harmful content, attempting to gain unauthorized access to the service, or interfering with the proper working of the service.',
          ),
          TermsItem(
            title: 'Service Quality Standards',
            content:
                'Service providers agree to maintain professional standards and deliver services as described in their listings. Users agree to provide honest feedback and ratings based on their actual experience with the service.',
          ),
        ],
      ),
      TermsSection(
        title: 'Payments & Billing',
        icon: Prbal.creditCard,
        color: ThemeManager.of(context).successColor,
        items: [
          TermsItem(
            title: 'Payment Processing',
            content:
                'All payments are processed securely through our third-party payment processors. By providing payment information, you authorize us to charge the specified amounts for services booked through the platform.',
          ),
          TermsItem(
            title: 'Refund Policy',
            content:
                'Refunds are available under specific circumstances as outlined in our refund policy. Service providers and users should review cancellation and refund terms before booking or providing services.',
          ),
          TermsItem(
            title: 'Service Fees',
            content:
                'Prbal charges service fees for facilitating transactions between users and service providers. These fees are clearly disclosed before booking confirmation and are non-refundable except as required by law.',
          ),
        ],
      ),
      TermsSection(
        title: 'Privacy & Data Protection',
        icon: Prbal.shield4,
        color: ThemeManager.of(context).warningColor,
        items: [
          TermsItem(
            title: 'Data Collection',
            content:
                'We collect information you provide directly to us, information we obtain automatically when you use our service, and information from third parties. This information is used to provide, maintain, and improve our services.',
          ),
          TermsItem(
            title: 'Data Sharing',
            content:
                'We do not sell, trade, or rent your personal identification information to others. We may share generic aggregated demographic information not linked to any personal identification information regarding visitors and users with our business partners.',
          ),
          TermsItem(
            title: 'Data Security',
            content:
                'We implement a variety of security measures to maintain the safety of your personal information. However, no method of transmission over the Internet or electronic storage is 100% secure, and we cannot guarantee absolute security.',
          ),
        ],
      ),
      TermsSection(
        title: 'Intellectual Property',
        icon: Prbal.copyright,
        color: ThemeManager.of(context).infoColor,
        items: [
          TermsItem(
            title: 'Platform Ownership',
            content:
                'The service and its original content, features, and functionality are and will remain the exclusive property of Prbal and its licensors. The service is protected by copyright, trademark, and other laws.',
          ),
          TermsItem(
            title: 'User Content License',
            content:
                'By posting content to Prbal, you grant us a non-exclusive, worldwide, royalty-free license to use, reproduce, modify, publish, and distribute such content for the purpose of operating and providing the service.',
          ),
          TermsItem(
            title: 'Trademark Usage',
            content:
                'You may not use our trademarks, service marks, or logos without our prior written consent. Any unauthorized use of our intellectual property may violate copyright, trademark, and other laws.',
          ),
        ],
      ),
      TermsSection(
        title: 'Limitation of Liability',
        icon: Prbal.exclamationTriangle,
        color: ThemeManager.of(context).errorColor,
        items: [
          TermsItem(
            title: 'Service Disclaimer',
            content:
                'Prbal acts as an intermediary platform connecting users with service providers. We do not provide the actual services and are not responsible for the quality, safety, or legality of services provided by third parties.',
          ),
          TermsItem(
            title: 'Liability Limitation',
            content:
                'In no event shall Prbal, its directors, employees, or agents be liable for any indirect, incidental, special, consequential, or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses.',
          ),
          TermsItem(
            title: 'Maximum Liability',
            content:
                "Our total liability to you for any claim arising from or relating to this agreement or your use of the service shall not exceed the amount you paid us in the twelve months preceding the claim, or \$100, whichever is greater.",
          ),
        ],
      ),
    ];
  }
}

/// Terms section model
class TermsSection {
  final String title;
  final IconData icon;
  final Color color;
  final List<TermsItem> items;

  TermsSection({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
}

/// Terms item model
class TermsItem {
  final String title;
  final String content;

  TermsItem({
    required this.title,
    required this.content,
  });
}
