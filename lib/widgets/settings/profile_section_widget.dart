import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prbal/services/service_providers.dart';
import 'package:prbal/services/api_service.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// **THEMEMANAGER INTEGRATED** ProfileSectionWidget - Modern profile section for settings screen
///
/// **ThemeManager Features Integrated:**
/// - 🎨 Complete color system (primary, accent, neutral, text, status colors)
/// - 🌈 Enhanced gradients (background, surface, primary, secondary gradients)
/// - 🎯 Theme-aware shadows (subtle, elevated shadows)
/// - 🔄 Conditional styling with helper methods
/// - 🎭 Professional Material Design 3.0 compliance
/// - 🌓 Automatic light/dark mode adaptation
/// - 📊 Comprehensive debug logging and profile monitoring
/// - ✨ Enhanced visual feedback with glass morphism effects
/// - 🧑‍💼 Profile-focused design with professional theming
/// - 🔒 Authentication-aware UI with proper visual states
///
/// This widget displays the user's profile information in a modern card layout with:
/// - Enhanced profile picture with gradient borders (with fallback to user type icon)
/// - Professional user name and display information with theme-aware styling
/// - Enhanced user type badge with gradient color coding
/// - Professional rating and booking statistics with status color integration
/// - Theme-aware edit and view profile buttons with gradient styling
/// - Enhanced verification status indicator with proper theming
/// - Advanced glass-morphism design with comprehensive ThemeManager integration
class ProfileSectionWidget extends ConsumerStatefulWidget {
  const ProfileSectionWidget({
    super.key,
    this.onEditProfile,
    this.onViewProfile,
    this.onProfilePictureEdit,
  });

  /// Callback when edit profile button is tapped
  final VoidCallback? onEditProfile;

  /// Callback when profile card is tapped (for viewing full profile)
  final VoidCallback? onViewProfile;

  /// Callback when profile picture edit is tapped
  final Function(ImageSource)? onProfilePictureEdit;

  @override
  ConsumerState<ProfileSectionWidget> createState() =>
      _ProfileSectionWidgetState();
}

class _ProfileSectionWidgetState extends ConsumerState<ProfileSectionWidget>
    with SingleTickerProviderStateMixin, ThemeAwareMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    debugPrint('🧑‍💼 [ProfileSection] Initializing enhanced profile section');

    // Initialize animations for smooth entrance
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Start entrance animation
    _animationController.forward();
    debugPrint(
        '🎬 [ProfileSection] Animation controller started with 800ms duration');
  }

  @override
  void dispose() {
    debugPrint('🧑‍💼 [ProfileSection] Disposing animation controller');
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '🧑‍💼 [ProfileSection] Building enhanced profile section with ThemeManager');

    // Use centralized ThemeManager instead of manual theme detection
    final themeManager = ThemeManager.of(context);
    final authState = ref.watch(authenticationStateProvider);

    // Enhanced debug logging with theme state
    debugPrint(
        '🔒 [ProfileSection] Authentication state: ${authState.isAuthenticated}');

    if (!authState.isAuthenticated) {
      return _buildSignInPrompt(themeManager);
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      padding: EdgeInsets.all(24.w),
      decoration: themeManager.glassMorphism.copyWith(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: themeManager.elevatedShadow,
      ),
      child: Column(
        children: [
          // Profile Header with enhanced styling
          _buildEnhancedProfileHeader(themeManager, authState),

          SizedBox(height: 20.h),

          // Profile Stats with theme-aware cards
          _buildEnhancedProfileStats(themeManager, authState),

          SizedBox(height: 20.h),

          // Action Buttons with gradient styling
          _buildEnhancedActionButtons(themeManager),
        ],
      ),
    );
  }

  /// Builds enhanced profile header with ThemeManager styling
  Widget _buildEnhancedProfileHeader(
      ThemeManager themeManager, dynamic authState) {
    debugPrint('🧑‍💼 ProfileSectionWidget: Building enhanced profile header');

    return Row(
      children: [
        // Enhanced profile picture with gradient border
        Container(
          decoration: BoxDecoration(
            gradient: themeManager.primaryGradient,
            borderRadius: BorderRadius.circular(35.r),
            boxShadow: themeManager.primaryShadow,
          ),
          padding: EdgeInsets.all(3.w),
          child: GestureDetector(
            onTap: () => _showProfilePictureOptions(themeManager),
            child: Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: themeManager.surfaceColor,
                borderRadius: BorderRadius.circular(32.r),
                border: Border.all(
                  color: themeManager.borderColor,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32.r),
                child: _buildProfileImage(themeManager, authState),
              ),
            ),
          ),
        ),

        SizedBox(width: 16.w),

        // Enhanced profile info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name with theme-aware styling
              Text(
                _getDisplayName(authState),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: themeManager.textPrimary,
                  letterSpacing: -0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 4.h),

              // User type badge with gradient
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: themeManager.secondaryGradient,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: themeManager.primaryShadow,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getUserTypeIcon(authState.userData?['user_type']),
                      size: 14.sp,
                      color: Colors.white,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      _getUserTypeDisplayName(authState.userData?['user_type']),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8.h),

              // Enhanced rating display
              if (_hasValidRating(authState))
                _buildEnhancedRatingDisplay(themeManager, authState),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds enhanced profile stats with theme-aware cards
  Widget _buildEnhancedProfileStats(
      ThemeManager themeManager, dynamic authState) {
    debugPrint('🧑‍💼 ProfileSectionWidget: Building enhanced profile stats');

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: themeManager.borderColor,
          width: 1,
        ),
        boxShadow: themeManager.primaryShadow,
      ),
      child: Row(
        children: [
          // Bookings stat
          Expanded(
            child: _buildStatCard(
              themeManager,
              icon: Prbal.calendar,
              label: 'profile.bookings'.tr(),
              value: _getRealBookingCount(authState).toString(),
              gradient: themeManager.primaryGradient,
            ),
          ),

          SizedBox(width: 12.w),

          // Rating stat
          Expanded(
            child: _buildStatCard(
              themeManager,
              icon: Prbal.star,
              label: 'profile.rating'.tr(),
              value: _getRealRating(authState).toStringAsFixed(1),
              gradient: themeManager.secondaryGradient,
            ),
          ),

          SizedBox(width: 12.w),

          // Balance stat
          Expanded(
            child: _buildStatCard(
              themeManager,
              icon: Prbal.wallet,
              label: 'profile.balance'.tr(),
              value:
                  '₹${(authState.userData?['balance'] ?? 0).toStringAsFixed(0)}',
              gradient: themeManager.conditionalGradient(
                lightGradient: LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFEE5A52)]),
                darkGradient: LinearGradient(
                    colors: [Color(0xFFFF8A80), Color(0xFFFF5722)]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds individual stat card with gradient styling
  Widget _buildStatCard(
    ThemeManager themeManager, {
    required IconData icon,
    required String label,
    required String value,
    required Gradient gradient,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: themeManager.primaryShadow,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 18.sp,
            color: Colors.white,
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds enhanced action buttons with gradient styling
  Widget _buildEnhancedActionButtons(ThemeManager themeManager) {
    debugPrint('🧑‍💼 ProfileSectionWidget: Building enhanced action buttons');

    return Row(
      children: [
        // Edit Profile Button
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: themeManager.primaryGradient,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: themeManager.primaryShadow,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onEditProfile,
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Prbal.edit,
                        size: 16.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'profile.editProfile'.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: 12.w),

        // View Profile Button
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: themeManager.primaryColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12.r),
              color: themeManager.surfaceColor,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onViewProfile,
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Prbal.profile,
                        size: 16.sp,
                        color: themeManager.primaryColor,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'profile.viewProfile'.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: themeManager.primaryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds sign-in prompt with theme-aware styling
  Widget _buildSignInPrompt(ThemeManager themeManager) {
    debugPrint('🧑‍💼 ProfileSectionWidget: Building sign-in prompt');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      padding: EdgeInsets.all(24.w),
      decoration: themeManager.glassMorphism.copyWith(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              gradient: themeManager.primaryGradient,
              borderRadius: BorderRadius.circular(40.r),
              boxShadow: themeManager.elevatedShadow,
            ),
            child: Icon(
              Prbal.person,
              size: 40.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'profile.signInToAccess'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: themeManager.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'profile.signInDescription'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              color: themeManager.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Shows profile picture options bottom sheet
  void _showProfilePictureOptions(ThemeManager themeManager) {
    debugPrint('🧑‍💼 ProfileSectionWidget: Showing profile picture options');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            gradient: themeManager.surfaceGradient,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            boxShadow: themeManager.elevatedShadow,
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag Handle
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: themeManager.borderColor,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Title
                  Text(
                    'Update Profile Picture',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: themeManager.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Camera Option
                  _buildImageSourceOption(
                    themeManager,
                    icon: Prbal.camera,
                    title: 'Take Photo',
                    subtitle: 'Use camera to take a new photo',
                    onTap: () {
                      Navigator.pop(context);
                      widget.onProfilePictureEdit?.call(ImageSource.camera);
                    },
                  ),

                  SizedBox(height: 16.h),

                  // Gallery Option
                  _buildImageSourceOption(
                    themeManager,
                    icon: Prbal.images,
                    title: 'Choose from Gallery',
                    subtitle: 'Select from your photo library',
                    onTap: () {
                      Navigator.pop(context);
                      widget.onProfilePictureEdit?.call(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds image source option
  Widget _buildImageSourceOption(
    ThemeManager themeManager, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: themeManager.surfaceColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: themeManager.borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  gradient: themeManager.primaryGradient,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: Colors.white, size: 22.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: themeManager.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: themeManager.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds profile image with network caching
  Widget _buildProfileImage(ThemeManager themeManager, dynamic authState) {
    debugPrint('🧑‍💼 ProfileSectionWidget: Building profile image');

    final profilePicture = authState.userData?['profile_picture'] as String?;
    final userType = authState.userData?['user_type'] as String?;

    if (profilePicture != null && profilePicture.isNotEmpty) {
      final absoluteImageUrl = ApiService.convertToAbsoluteUrl(profilePicture);

      return CachedNetworkImage(
        imageUrl: absoluteImageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: themeManager.surfaceColor,
          child: Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(themeManager.primaryColor),
              strokeWidth: 2,
            ),
          ),
        ),
        errorWidget: (context, url, error) =>
            _buildFallbackAvatar(themeManager, userType),
      );
    } else {
      return _buildFallbackAvatar(themeManager, userType);
    }
  }

  /// Builds fallback avatar with user.png image
  Widget _buildFallbackAvatar(ThemeManager themeManager, String? userType) {
    debugPrint(
        '🧑‍💼 ProfileSectionWidget: Building fallback avatar with user.png');

    return Container(
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/logo/user.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint(
                '🧑‍💼 ProfileSectionWidget: Error loading user.png: $error');
            return Container(
              decoration: BoxDecoration(
                gradient: themeManager.primaryGradient,
              ),
              child: Icon(
                _getUserTypeIcon(userType),
                color: Colors.white,
                size: 32.sp,
              ),
            );
          },
        ),
      ),
    );
  }

  /// Gets display name from auth state
  String _getDisplayName(dynamic authState) {
    final userData = authState.userData;
    if (userData == null) return 'Guest User';

    final firstName =
        userData['first_name'] as String? ?? userData['firstName'] as String?;
    final lastName =
        userData['last_name'] as String? ?? userData['lastName'] as String?;
    final username = userData['username'] as String?;

    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName;
    } else if (username != null) {
      return username;
    }

    return 'User';
  }

  /// Checks if user has valid rating
  bool _hasValidRating(dynamic authState) {
    final userData = authState.userData;
    if (userData == null) return false;

    final rating = _getRealRating(authState);
    return rating > 0.0;
  }

  /// Builds enhanced rating display
  Widget _buildEnhancedRatingDisplay(
      ThemeManager themeManager, dynamic authState) {
    final rating = _getRealRating(authState);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient:
              LinearGradient(colors: [Color(0xFFED8936), Color(0xFFDD6B20)]),
          darkGradient:
              LinearGradient(colors: [Color(0xFFFBD38D), Color(0xFFED8936)]),
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Prbal.star, size: 12.sp, color: Colors.white),
          SizedBox(width: 4.w),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Gets real rating from auth state
  double _getRealRating(dynamic authState) {
    final userData = authState.userData;
    if (userData == null) return 0.0;

    final ratingData = userData['rating'];
    if (ratingData is double) {
      return ratingData;
    } else if (ratingData is int) {
      return ratingData.toDouble();
    } else if (ratingData is String) {
      return double.tryParse(ratingData) ?? 0.0;
    }

    return 0.0;
  }

  /// Gets real booking count from auth state
  int _getRealBookingCount(dynamic authState) {
    final userData = authState.userData;
    if (userData == null) return 0;

    final bookingData = userData['total_bookings'] ??
        userData['totalBookings'] ??
        userData['booking_count'];
    if (bookingData is int) {
      return bookingData;
    } else if (bookingData is String) {
      return int.tryParse(bookingData) ?? 0;
    }

    return 0;
  }

  /// Gets icon for user type
  IconData _getUserTypeIcon(String? userType) {
    switch (userType) {
      case 'provider':
        return Prbal.tools;
      case 'customer':
        return Prbal.user;
      case 'admin':
        return Prbal.graduationCap1;
      default:
        return Prbal.user;
    }
  }

  /// Gets display name for user type
  String _getUserTypeDisplayName(String? userType) {
    switch (userType) {
      case 'provider':
        return 'Service Provider';
      case 'customer':
        return 'Customer';
      case 'admin':
        return 'Administrator';
      default:
        return 'User';
    }
  }
}
