import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// ====================================================================
/// PRIVACY POLICY BOTTOM SHEET - COMPREHENSIVE THEMEMANAGER INTEGRATION
/// ====================================================================
///
/// ✅ **COMPREHENSIVE PRIVACY POLICY MODAL WITH THEMEMANAGER** ✅
///
/// **🎨 ENHANCED FEATURES:**
/// - Modern Material Design 3.0 modal bottom sheet
/// - Comprehensive privacy policy with categorized sections
/// - Search functionality for finding specific privacy terms
/// - Expandable sections with smooth animations
/// - Data protection and GDPR compliance information
/// - Professional theming with ThemeManager integration
/// - Glass morphism effects and gradient backgrounds
/// - Responsive design with ScreenUtil
/// - Comprehensive debug logging
/// ====================================================================

class PrivacyPolicyBottomSheet extends StatefulWidget {
  const PrivacyPolicyBottomSheet({super.key});

  @override
  State<PrivacyPolicyBottomSheet> createState() => _PrivacyPolicyBottomSheetState();

  /// Show privacy policy modal bottom sheet
  static void show(BuildContext context) {
    debugPrint('🔒 [Privacy] Showing privacy policy modal');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 128),
      useSafeArea: true,
      builder: (context) => const PrivacyPolicyBottomSheet(),
    );
  }
}

class _PrivacyPolicyBottomSheetState extends State<PrivacyPolicyBottomSheet>
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
    debugPrint('🔒 [Privacy] Initializing privacy policy');

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
    debugPrint('🔒 [Privacy] Disposed privacy policy resources');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    debugPrint('🔒 [Privacy] Building privacy policy with theme colors:');
    debugPrint('🔒 [Privacy] Background: ${themeManager.backgroundColor}');
    debugPrint('🔒 [Privacy] Surface: ${themeManager.surfaceColor}');
    debugPrint('🔒 [Privacy] Warning: ${themeManager.warningColor}');

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
                gradient: themeManager.backgroundGradient,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: themeManager.shadowDark.withValues(alpha: 102),
                    blurRadius: 24.r,
                    offset: Offset(0, -6.h),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildHeader(themeManager),
                  _buildSearchSection(themeManager),
                  _buildLastUpdated(themeManager),
                  Expanded(
                    child: _buildContent(themeManager),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
        border: Border(
          bottom: BorderSide(
            color: themeManager.borderColor.withValues(alpha: 51),
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
                  themeManager.warningColor.withValues(alpha: 179),
                  themeManager.warningColor,
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
                      themeManager.warningColor,
                      themeManager.warningLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: themeManager.warningColor.withValues(alpha: 51),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Icon(
                  Prbal.shield4,
                  color: themeManager.textInverted,
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
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: themeManager.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'How we protect your data',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: themeManager.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Close button
              InkWell(
                onTap: () {
                  debugPrint('🔒 [Privacy] Close button tapped');
                  Navigator.of(context).pop();
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: themeManager.surfaceColor.withValues(alpha: 128),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: themeManager.borderColor.withValues(alpha: 77),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Prbal.times,
                    color: themeManager.textSecondary,
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

  Widget _buildSearchSection(ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        border: Border(
          bottom: BorderSide(
            color: themeManager.borderColor.withValues(alpha: 51),
            width: 1,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: themeManager.inputBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: themeManager.borderColor.withValues(alpha: 77),
            width: 1,
          ),
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(
            color: themeManager.textPrimary,
            fontSize: 14.sp,
          ),
          decoration: InputDecoration(
            hintText: 'Search privacy terms...',
            hintStyle: TextStyle(
              color: themeManager.textSecondary,
              fontSize: 14.sp,
            ),
            prefixIcon: Icon(
              Prbal.search,
              color: themeManager.textSecondary,
              size: 18.sp,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLastUpdated(ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeManager.warningColor.withValues(alpha: 26),
            themeManager.warningLight.withValues(alpha: 13),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: themeManager.borderColor.withValues(alpha: 51),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Prbal.clock,
            color: themeManager.warningColor,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            'Last updated: December 2024',
            style: TextStyle(
              fontSize: 12.sp,
              color: themeManager.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  themeManager.warningColor,
                  themeManager.warningLight,
                ],
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'GDPR Compliant',
              style: TextStyle(
                fontSize: 10.sp,
                color: themeManager.textInverted,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeManager themeManager) {
    List<PrivacySection> sections = _getPrivacySections();

    // Filter sections based on search
    if (_searchQuery.isNotEmpty) {
      sections = sections.where((section) {
        return section.title.toLowerCase().contains(_searchQuery) ||
            section.content.toLowerCase().contains(_searchQuery) ||
            section.items.any((item) => item.toLowerCase().contains(_searchQuery));
      }).toList();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        return _buildPrivacySection(themeManager, sections[index], index);
      },
    );
  }

  Widget _buildPrivacySection(ThemeManager themeManager, PrivacySection section, int index) {
    final isExpanded = _expandedIndex == index;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: themeManager.borderColor.withValues(alpha: 77),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: themeManager.shadowLight.withValues(alpha: 51),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
              debugPrint('🔒 [Privacy] Section ${section.title} ${isExpanded ? 'collapsed' : 'expanded'}');
            },
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  // Section icon
                  Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          section.color,
                          section.color.withValues(alpha: 179),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      section.icon,
                      color: themeManager.textInverted,
                      size: 18.sp,
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // Section title and description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: themeManager.textPrimary,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          section.description,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: themeManager.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Expand/collapse icon
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Prbal.chevronDown,
                      color: themeManager.textSecondary,
                      size: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: isExpanded ? null : 0,
            child: isExpanded
                ? Container(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 1,
                          margin: EdgeInsets.only(bottom: 12.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                themeManager.borderColor.withValues(alpha: 0),
                                themeManager.borderColor.withValues(alpha: 77),
                                themeManager.borderColor.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),

                        // Main content
                        Text(
                          section.content,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: themeManager.textPrimary,
                            height: 1.5,
                            letterSpacing: 0.2,
                          ),
                        ),

                        if (section.items.isNotEmpty) ...[
                          SizedBox(height: 12.h),
                          ...section.items.map((item) => Padding(
                                padding: EdgeInsets.only(bottom: 6.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 4.w,
                                      height: 4.w,
                                      margin: EdgeInsets.only(top: 6.h, right: 8.w),
                                      decoration: BoxDecoration(
                                        color: section.color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: themeManager.textSecondary,
                                          height: 1.4,
                                          letterSpacing: 0.1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ],
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  List<PrivacySection> _getPrivacySections() {
    final themeManager = ThemeManager.of(context);

    return [
      PrivacySection(
        title: 'Information We Collect',
        description: 'Types of data we gather',
        icon: Prbal.database,
        color: themeManager.infoColor,
        content:
            'We collect information that you provide directly to us, information we collect automatically when you use our services, and information we may receive from third parties.',
        items: [
          'Personal information (name, email, phone number)',
          'Profile information and preferences',
          'Usage data and app interactions',
          'Device information and identifiers',
          'Location data (with your permission)',
          'Communication history and support interactions',
        ],
      ),
      PrivacySection(
        title: 'How We Use Your Information',
        description: 'Purposes of data processing',
        icon: Prbal.cogs,
        color: themeManager.primaryColor,
        content:
            'We use the information we collect to provide, maintain, and improve our services, communicate with you, and ensure the security of our platform.',
        items: [
          'Provide and personalize our services',
          'Process transactions and bookings',
          'Send notifications and updates',
          'Provide customer support',
          'Improve app functionality and user experience',
          'Ensure platform security and prevent fraud',
          'Comply with legal obligations',
        ],
      ),
      PrivacySection(
        title: 'Information Sharing',
        description: 'When and how we share data',
        icon: Prbal.shareAlt,
        color: themeManager.warningColor,
        content:
            'We do not sell your personal information. We may share your information in limited circumstances as described in this policy.',
        items: [
          'With service providers (only necessary data)',
          'For legal compliance and safety',
          'In case of business transfers',
          'With your explicit consent',
          'Aggregated, non-personal data for analytics',
        ],
      ),
      PrivacySection(
        title: 'Data Security',
        description: 'How we protect your information',
        icon: Prbal.lock,
        color: themeManager.successColor,
        content:
            'We implement industry-standard security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
        items: [
          'Encryption of data in transit and at rest',
          'Regular security audits and assessments',
          'Access controls and authentication',
          'Secure data centers and infrastructure',
          'Employee training on data protection',
          'Incident response procedures',
        ],
      ),
      PrivacySection(
        title: 'Your Rights',
        description: 'Control over your personal data',
        icon: Prbal.userCheck,
        color: themeManager.accent2,
        content:
            'You have various rights regarding your personal information, including the ability to access, correct, delete, or restrict the processing of your data.',
        items: [
          'Access your personal information',
          'Correct inaccurate data',
          'Delete your account and data',
          'Export your data (data portability)',
          'Restrict or object to processing',
          'Withdraw consent at any time',
          'File a complaint with supervisory authorities',
        ],
      ),
      PrivacySection(
        title: 'Data Retention',
        description: 'How long we keep your data',
        icon: Prbal.clock,
        color: themeManager.accent3,
        content:
            'We retain your personal information only for as long as necessary to fulfill the purposes outlined in this privacy policy, unless a longer retention period is required by law.',
        items: [
          'Account data: Until account deletion',
          'Transaction records: 7 years for legal compliance',
          'Support communications: 3 years',
          'Usage analytics: 2 years (anonymized)',
          'Marketing data: Until you unsubscribe',
          'Legal hold data: As required by law',
        ],
      ),
      PrivacySection(
        title: 'Cookies & Tracking',
        description: 'Use of cookies and similar technologies',
        icon: Prbal.cookie,
        color: themeManager.accent4,
        content:
            'We use cookies and similar technologies to enhance your experience, analyze usage patterns, and provide personalized content.',
        items: [
          'Essential cookies for app functionality',
          'Analytics cookies to improve services',
          'Preference cookies to remember settings',
          'Advertising cookies (with consent)',
          'Session tokens for authentication',
          'Third-party service integrations',
        ],
      ),
      PrivacySection(
        title: 'International Transfers',
        description: 'Cross-border data processing',
        icon: Prbal.globe,
        color: themeManager.accent5,
        content:
            'Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place for such transfers.',
        items: [
          'Adequate protection standards',
          'Standard contractual clauses',
          'Certification schemes compliance',
          'Regular transfer impact assessments',
          'User notification of transfer practices',
        ],
      ),
      PrivacySection(
        title: 'Children\'s Privacy',
        description: 'Protection of minors',
        icon: Prbal.child,
        color: themeManager.errorColor,
        content:
            'Our services are not intended for children under 13. We do not knowingly collect personal information from children under 13.',
        items: [
          'Age verification procedures',
          'Parental consent requirements',
          'Limited data collection for minors',
          'Enhanced protection measures',
          'Immediate deletion upon discovery',
        ],
      ),
      PrivacySection(
        title: 'Contact Us',
        description: 'Privacy questions and concerns',
        icon: Prbal.envelope,
        color: themeManager.successColor,
        content:
            'If you have any questions about this privacy policy or our data practices, please contact our Data Protection Officer.',
        items: [
          'Email: privacy@prbal.com',
          'Phone: +91-XXX-XXX-XXXX',
          'Address: [Company Address]',
          'Data Protection Officer contact',
          'Response time: 30 days maximum',
          'Escalation procedures available',
        ],
      ),
    ];
  }
}

class PrivacySection {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String content;
  final List<String> items;

  PrivacySection({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.content,
    required this.items,
  });
}
