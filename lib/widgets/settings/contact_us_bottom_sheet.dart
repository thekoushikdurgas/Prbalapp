import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// ====================================================================
/// CONTACT US BOTTOM SHEET - COMPREHENSIVE THEMEMANAGER INTEGRATION
/// ====================================================================
///
/// ✅ **COMPREHENSIVE CONTACT MODAL WITH THEMEMANAGER** ✅
///
/// **🎨 ENHANCED FEATURES:**
/// - Modern Material Design 3.0 modal bottom sheet
/// - Multiple contact methods (Email, Phone, Chat, Social Media)
/// - Contact form with validation and theming
/// - Business hours and response time information
/// - Quick contact actions with direct functionality
/// - Professional theming with ThemeManager integration
/// - Glass morphism effects and gradient backgrounds
/// - Responsive design with ScreenUtil
/// - Comprehensive debug logging
/// ====================================================================

class ContactUsBottomSheet extends StatefulWidget {
  const ContactUsBottomSheet({super.key});

  @override
  State<ContactUsBottomSheet> createState() => _ContactUsBottomSheetState();

  /// Show contact us modal bottom sheet
  static void show(BuildContext context) {
    debugPrint('📧 [ContactUs] Showing contact us modal');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 128),
      useSafeArea: true,
      builder: (context) => const ContactUsBottomSheet(),
    );
  }
}

class _ContactUsBottomSheetState extends State<ContactUsBottomSheet> with TickerProviderStateMixin, ThemeAwareMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    debugPrint('📧 [ContactUs] Initializing contact us modal');

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    debugPrint('📧 [ContactUs] Disposed contact us resources');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    debugPrint('📧 [ContactUs] Building contact us with theme colors:');
    debugPrint('📧 [ContactUs] Background: ${themeManager.backgroundColor}');
    debugPrint('📧 [ContactUs] Surface: ${themeManager.surfaceColor}');
    debugPrint('📧 [ContactUs] Success: ${themeManager.successColor}');

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
              gradient: themeManager.successGradient,
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
                  gradient: themeManager.successGradient,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: themeManager.successColor.withValues(alpha: 51),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Icon(
                  Prbal.envelope,
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
                      'Contact Us',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: themeManager.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Get in touch with our team',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: themeManager.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Close button
              GestureDetector(
                onTap: () {
                  debugPrint('📧 [ContactUs] Closing contact us');
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: themeManager.surfaceElevated.withValues(alpha: 128),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: themeManager.borderColor.withValues(alpha: 51),
                    ),
                  ),
                  child: Icon(
                    Icons.close,
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

  Widget _buildContent(ThemeManager themeManager) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Quick contact methods
        SliverToBoxAdapter(
          child: _buildQuickContactMethods(themeManager),
        ),

        // Business hours
        SliverToBoxAdapter(
          child: _buildBusinessHours(themeManager),
        ),

        // Contact form
        SliverToBoxAdapter(
          child: _buildContactForm(themeManager),
        ),

        // Bottom padding
        SliverToBoxAdapter(
          child: SizedBox(height: 20.h),
        ),
      ],
    );
  }

  Widget _buildQuickContactMethods(ThemeManager themeManager) {
    return Container(
      margin: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Contact',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: themeManager.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildContactMethodCard(
                  themeManager,
                  'Email',
                  'support@prbal.com',
                  Prbal.envelope,
                  themeManager.successColor,
                  () {
                    debugPrint('📧 [ContactUs] Email contact tapped');
                    // TODO: Open email app
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildContactMethodCard(
                  themeManager,
                  'Phone',
                  '+91 98765 43210',
                  Prbal.phone,
                  themeManager.infoColor,
                  () {
                    debugPrint('📧 [ContactUs] Phone contact tapped');
                    // TODO: Open phone dialer
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildContactMethodCard(
                  themeManager,
                  'Live Chat',
                  'Available 24/7',
                  Prbal.comments,
                  themeManager.accent2,
                  () {
                    debugPrint('📧 [ContactUs] Live chat tapped');
                    // TODO: Open live chat
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildContactMethodCard(
                  themeManager,
                  'WhatsApp',
                  'Quick support',
                  Prbal.whatsapp,
                  Color(0xFF25D366),
                  () {
                    debugPrint('📧 [ContactUs] WhatsApp contact tapped');
                    // TODO: Open WhatsApp
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethodCard(
    ThemeManager themeManager,
    String title,
    String subtitle,
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
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 26),
              blurRadius: 4.r,
              offset: Offset(0, 2.h),
            ),
          ],
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
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: themeManager.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10.sp,
                color: themeManager.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessHours(ThemeManager themeManager) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: themeManager.borderColor.withValues(alpha: 51),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Prbal.clock,
                color: themeManager.accent3,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Business Hours',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: themeManager.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildBusinessHourRow(themeManager, 'Monday - Friday', '9:00 AM - 6:00 PM'),
          _buildBusinessHourRow(themeManager, 'Saturday', '10:00 AM - 4:00 PM'),
          _buildBusinessHourRow(themeManager, 'Sunday', 'Closed'),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: themeManager.infoColor.withValues(alpha: 26),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Prbal.info,
                  color: themeManager.infoColor,
                  size: 14.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'We typically respond within 24 hours',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: themeManager.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessHourRow(ThemeManager themeManager, String day, String hours) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 12.sp,
              color: themeManager.textSecondary,
            ),
          ),
          Text(
            hours,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: themeManager.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm(ThemeManager themeManager) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: themeManager.borderColor.withValues(alpha: 51),
        ),
        boxShadow: [
          BoxShadow(
            color: themeManager.shadowLight.withValues(alpha: 51),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form header
            Row(
              children: [
                Icon(
                  Prbal.edit,
                  color: themeManager.primaryColor,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Send us a message',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: themeManager.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Name field
            _buildFormField(
              themeManager,
              controller: _nameController,
              label: 'Your Name',
              hint: 'Enter your full name',
              icon: Prbal.user,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),

            SizedBox(height: 16.h),

            // Email field
            _buildFormField(
              themeManager,
              controller: _emailController,
              label: 'Email Address',
              hint: 'Enter your email address',
              icon: Prbal.envelope,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            SizedBox(height: 16.h),

            // Subject field
            _buildFormField(
              themeManager,
              controller: _subjectController,
              label: 'Subject',
              hint: 'Brief description of your inquiry',
              icon: Prbal.tag,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a subject';
                }
                return null;
              },
            ),

            SizedBox(height: 16.h),

            // Message field
            _buildFormField(
              themeManager,
              controller: _messageController,
              label: 'Message',
              hint: 'Tell us how we can help you...',
              icon: Prbal.comments,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your message';
                }
                if (value.trim().length < 10) {
                  return 'Message must be at least 10 characters';
                }
                return null;
              },
            ),

            SizedBox(height: 24.h),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeManager.successColor,
                  foregroundColor: themeManager.textInverted,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 2,
                ),
                child: _isSubmitting
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16.w,
                            height: 16.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                themeManager.textInverted,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Sending...',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Prbal.paperPlane,
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Send Message',
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
      ),
    );
  }

  Widget _buildFormField(
    ThemeManager themeManager, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: themeManager.textPrimary,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: themeManager.textTertiary,
              fontSize: 14.sp,
            ),
            prefixIcon: Icon(
              icon,
              color: themeManager.textSecondary,
              size: 20.sp,
            ),
            filled: true,
            fillColor: themeManager.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: themeManager.borderColor.withValues(alpha: 77),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: themeManager.borderColor.withValues(alpha: 77),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: themeManager.primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: themeManager.errorColor,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
          style: TextStyle(
            color: themeManager.textPrimary,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      debugPrint('📧 [ContactUs] Form validation failed');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    debugPrint('📧 [ContactUs] Submitting contact form');
    debugPrint('📧 [ContactUs] Name: ${_nameController.text}');
    debugPrint('📧 [ContactUs] Email: ${_emailController.text}');
    debugPrint('📧 [ContactUs] Subject: ${_subjectController.text}');
    debugPrint('📧 [ContactUs] Message: ${_messageController.text}');

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isSubmitting = false;
    });

    if (mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Message sent successfully! We\'ll get back to you soon.'),
          backgroundColor: ThemeManager.of(context).successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      );

      // Clear form
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();

      debugPrint('📧 [ContactUs] Contact form submitted successfully');

      // Close modal after a delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }
}
