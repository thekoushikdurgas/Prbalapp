import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prbal/models/auth/app_user.dart';
import 'package:prbal/models/auth/user_type.dart';

import 'package:prbal/services/api_service.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/services/user_service.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// ProfileSectionWidget - Modern profile section for settings screen
///
/// This widget displays the user's profile information in a modern card layout with:
/// - Profile picture (with fallback to user type icon)
/// - User name and display information
/// - User type badge with color coding
/// - Rating and booking statistics for providers
/// - Edit profile button
/// - Verification status indicator
/// - Modern glass-morphism design with proper theming
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
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint('🎨 ProfileSectionWidget: Initializing profile section');

    // Initialize animations for smooth entrance
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Start entrance animation
    _animationController.forward();
    debugPrint('🎨 ProfileSectionWidget: Animation controller started');
  }

  @override
  void dispose() {
    debugPrint('🎨 ProfileSectionWidget: Disposing animation controller');
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🎨 ProfileSectionWidget: Building profile section');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userData = HiveService.getUserDataSafe();

    debugPrint('🎨 ProfileSectionWidget: Theme is dark: $isDark');
    // debugPrint('🎨 ProfileSectionWidget: User authenticated: ${authState.isAuthenticated}');
    debugPrint(
        '🎨 ProfileSectionWidget: User data available: ${userData != null}');

    // Extract user information with proper fallbacks
    final userInfo = _extractUserInfo(userData);
    debugPrint('🎨 ProfileSectionWidget: Extracted user info: $userInfo');

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: _buildProfileCard(context, isDark, userInfo),
          ),
        );
      },
    );
  }

  /// Builds the main profile card with modern design
  Widget _buildProfileCard(
    BuildContext context,
    bool isDark,
    Map<String, dynamic> userInfo,
  ) {
    debugPrint('🎨 ProfileSectionWidget: Building profile card');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        // Modern glass-morphism effect
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF2D2D2D).withValues(alpha: 0.8),
                  const Color(0xFF1E1E1E).withValues(alpha: 0.9),
                ]
              : [
                  Colors.white.withValues(alpha: 0.9),
                  const Color(0xFFF8F9FA).withValues(alpha: 0.8),
                ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.9),
            blurRadius: 1,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onViewProfile,
          borderRadius: BorderRadius.circular(24.r),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                // Profile Header Row
                _buildProfileHeader(isDark, userInfo),

                // User Stats Row (for providers)
                if (userInfo['userType'] == 'provider') ...[
                  SizedBox(height: 20.h),
                  _buildUserStats(isDark, userInfo),
                ],

                // Verification Status
                if (userInfo['isVerified'] == true) ...[
                  SizedBox(height: 16.h),
                  _buildVerificationBadge(isDark),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the profile header with avatar, name, and edit button
  Widget _buildProfileHeader(bool isDark, Map<String, dynamic> userInfo) {
    debugPrint('🎨 ProfileSectionWidget: Building profile header');

    return Row(
      children: [
        // Profile Avatar
        _buildProfileAvatar(isDark, userInfo),

        SizedBox(width: 20.w),

        // User Information
        Expanded(
          child: _buildUserInfo(isDark, userInfo),
        ),

        // Edit Button
        _buildEditButton(isDark, userInfo),
      ],
    );
  }

  /// Builds the profile avatar with image or fallback icon
  Widget _buildProfileAvatar(bool isDark, Map<String, dynamic> userInfo) {
    debugPrint('🎨 ProfileSectionWidget: Building profile avatar');

    final profilePicture = userInfo['profilePicture'] as String?;
    final userType = userInfo['userType'] as UserType;
    final userTypeColor = ThemeManager.of(context).getUserTypeColor(userType);

    debugPrint('🎨 ProfileSectionWidget: Profile picture URL: $profilePicture');
    debugPrint('🎨 ProfileSectionWidget: User type: $userType');

    return Stack(
      children: [
        // Main Avatar Container (now tappable)
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onProfilePictureEdit != null
                ? () => _showImageSourceDialog()
                : null,
            borderRadius: BorderRadius.circular(40.r),
            child: Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    userTypeColor.withValues(alpha: 0.2),
                    userTypeColor.withValues(alpha: 0.1),
                  ],
                ),
                border: Border.all(
                  color: userTypeColor.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: userTypeColor.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: profilePicture != null && profilePicture.isNotEmpty
                    ? _buildNetworkImage(profilePicture, userType)
                    : _buildFallbackAvatar(userType, userTypeColor),
              ),
            ),
          ),
        ),

        // Edit Button Overlay
        if (widget.onProfilePictureEdit != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: _buildProfileEditButton(isDark, userTypeColor),
          ),
      ],
    );
  }

  /// Builds network image with caching and error handling
  Widget _buildNetworkImage(String imageUrl, UserType userType) {
    debugPrint('🎨 ProfileSectionWidget: Building network image: $imageUrl');

    // Convert relative URL to absolute URL if needed
    final absoluteImageUrl = ApiService.convertToAbsoluteUrl(imageUrl);

    return CachedNetworkImage(
      imageUrl: absoluteImageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) {
        debugPrint('🎨 ProfileSectionWidget: Loading image placeholder');
        return _buildImagePlaceholder();
      },
      errorWidget: (context, url, error) {
        debugPrint('🎨 ProfileSectionWidget: Image load error: $error');
        return _buildFallbackAvatar(
            userType, ThemeManager.of(context).getUserTypeColor(userType));
      },
    );
  }

  /// Builds image loading placeholder
  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey.withValues(alpha: 0.2),
      child: Center(
        child: SizedBox(
          width: 20.w,
          height: 20.h,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds fallback avatar with user.png image
  Widget _buildFallbackAvatar(UserType userType, Color userTypeColor) {
    debugPrint(
        '🎨 ProfileSectionWidget: Building fallback avatar with user.png');

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            userTypeColor.withValues(alpha: 0.1),
            userTypeColor.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/user.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint(
                '🎨 ProfileSectionWidget: Error loading user.png: $error');
            // Fallback to icon if image fails to load
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    userTypeColor.withValues(alpha: 0.3),
                    userTypeColor.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Icon(
                getUserTypeIcon(userType),
                color: userTypeColor,
                size: 36.sp,
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds the profile picture edit button overlay
  Widget _buildProfileEditButton(bool isDark, Color userTypeColor) {
    debugPrint('🎨 ProfileSectionWidget: Building profile edit button');

    return Container(
      width: 28.w,
      height: 28.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            userTypeColor,
            userTypeColor.withValues(alpha: 0.8),
          ],
        ),
        border: Border.all(
          color: isDark ? Colors.white : Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showImageSourceDialog(),
          borderRadius: BorderRadius.circular(14.r),
          child: Icon(
            Prbal.camera,
            color: Colors.white,
            size: 14.sp,
          ),
        ),
      ),
    );
  }

  /// Shows bottom sheet to choose image source (camera or gallery)
  void _showImageSourceDialog() {
    debugPrint('🎨 ProfileSectionWidget: Showing image source bottom sheet');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
                spreadRadius: 0,
              ),
            ],
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
                      color: isDark ? Colors.grey[600] : Colors.grey[300],
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
                      color: isDark ? Colors.white : const Color(0xFF2D3748),
                      letterSpacing: -0.5,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Subtitle
                  Text(
                    'Choose how you\'d like to update your profile picture',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 32.h),

                  // Camera Option
                  _buildImageSourceOption(
                    icon: Prbal.camera,
                    title: 'Take Photo',
                    subtitle: 'Use camera to take a new photo',
                    onTap: () {
                      Navigator.pop(context);
                      widget.onProfilePictureEdit?.call(ImageSource.camera);
                    },
                    isDark: isDark,
                  ),

                  SizedBox(height: 16.h),

                  // Gallery Option
                  _buildImageSourceOption(
                    icon: Prbal.images,
                    title: 'Choose from Gallery',
                    subtitle: 'Select from your photo library',
                    onTap: () {
                      Navigator.pop(context);
                      widget.onProfilePictureEdit?.call(ImageSource.gallery);
                    },
                    isDark: isDark,
                  ),

                  SizedBox(height: 24.h),

                  // Cancel Button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.2)
                                : Colors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),

                  // Bottom padding for devices with home indicator
                  SizedBox(
                      height:
                          MediaQuery.of(context).padding.bottom > 0 ? 8.h : 0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds individual image source option
  Widget _buildImageSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                ),
                child: Icon(
                  icon,
                  color: isDark ? Colors.white : const Color(0xFF2D3748),
                  size: 22.sp,
                ),
              ),

              SizedBox(width: 16.w),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Prbal.angleRight,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                size: 18.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds user information section
  Widget _buildUserInfo(bool isDark, Map<String, dynamic> userInfo) {
    debugPrint('🎨 ProfileSectionWidget: Building user info section');

    final displayName = userInfo['displayName'] as String;
    final username = userInfo['username'] as String?;
    final userType = userInfo['userType'] as UserType;
    final userTypeColor = ThemeManager.of(context).getUserTypeColor(userType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User Name
        Text(
          displayName,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF2D3748),
            letterSpacing: -0.5,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        // Username (if available and different from display name)
        if (username != null &&
            username.isNotEmpty &&
            username != displayName) ...[
          SizedBox(height: 2.h),
          Text(
            '@$username',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              letterSpacing: 0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],

        SizedBox(height: 8.h),

        // User Type Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                userTypeColor.withValues(alpha: 0.15),
                userTypeColor.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: userTypeColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            getUserTypeDisplayName(userType),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: userTypeColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the edit profile button
  Widget _buildEditButton(bool isDark, Map<String, dynamic> userInfo) {
    debugPrint('🎨 ProfileSectionWidget: Building edit button');

    final userTypeColor = ThemeManager.of(context)
        .getUserTypeColor(userInfo['userType'] as UserType);

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            userTypeColor.withValues(alpha: 0.15),
            userTypeColor.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: userTypeColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            debugPrint('🎨 ProfileSectionWidget: Edit button tapped');
            widget.onEditProfile?.call();
          },
          borderRadius: BorderRadius.circular(25.r),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Icon(
              Prbal.edit,
              color: userTypeColor,
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds user statistics row for providers
  Widget _buildUserStats(bool isDark, Map<String, dynamic> userInfo) {
    debugPrint('🎨 ProfileSectionWidget: Building user stats');

    final rating = userInfo['rating'] as double;
    final bookingCount = userInfo['bookingCount'] as int;
    final balance = userInfo['balance'] as double;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            icon: Prbal.star,
            iconColor: const Color(0xFFED8936),
            value: rating.toStringAsFixed(1),
            label: 'Rating',
            isDark: isDark,
          ),
          _buildStatDivider(isDark),
          _buildStatItem(
            icon: Prbal.calendar,
            iconColor: const Color(0xFF4299E1),
            value: bookingCount.toString(),
            label: 'Bookings',
            isDark: isDark,
          ),
          _buildStatDivider(isDark),
          _buildStatItem(
            icon: Prbal.wallet,
            iconColor: const Color(0xFF9F7AEA),
            value: formatBalance(balance),
            label: 'Balance',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  /// Builds individual stat item
  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required bool isDark,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 18.sp,
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Builds divider between stats
  Widget _buildStatDivider(bool isDark) {
    return Container(
      width: 1,
      height: 40.h,
      color: isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.grey.withValues(alpha: 0.2),
    );
  }

  /// Builds verification badge
  Widget _buildVerificationBadge(bool isDark) {
    debugPrint('🎨 ProfileSectionWidget: Building verification badge');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF48BB78),
            Color(0xFF38A169),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF48BB78).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Prbal.checkCircle,
            color: Colors.white,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            'Verified Account',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  /// Extracts user information from API data with proper fallbacks
  Map<String, dynamic> _extractUserInfo(AppUser? userData) {
    debugPrint('🎨 ProfileSectionWidget: Extracting user info from API data');

    if (userData == null) {
      debugPrint(
          '🎨 ProfileSectionWidget: No user data available, using defaults');
      return {
        'displayName': 'Guest User',
        'userType': 'customer',
        'profilePicture': null,
        'rating': 0.0,
        'bookingCount': 0,
        'isVerified': false,
      };
    }

    // Extract names with multiple fallback strategies
    final firstName = userData.firstName;
    final lastName = userData.lastName;
    final username = userData.username;

    String displayName = 'User';
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      displayName = '$firstName $lastName';
    } else if (firstName.isNotEmpty) {
      displayName = firstName;
    } else if (username.isNotEmpty) {
      displayName = username;
    }

    // Extract user type
    final userType = userData.userType;

    // Extract profile picture
    final profilePicture = userData.profilePicture;

    // Extract rating (with type conversion)
    double rating = 0.0;
    final ratingData = userData.rating;
    rating = ratingData.toDouble();

    // Extract booking count
    int bookingCount = 0;
    final bookingData = userData.totalBookings;
    bookingCount = bookingData;

    // Extract verification status
    final isVerified = userData.isVerified;

    // Extract balance (with type conversion)
    double balance = 0.0;
    final balanceData = userData.balance;
    balance = balanceData.toDouble();

    final extractedInfo = {
      'displayName': displayName,
      'username': username,
      'userType': userType,
      'profilePicture': profilePicture,
      'rating': rating,
      'bookingCount': bookingCount,
      'balance': balance,
      'isVerified': isVerified,
    };

    debugPrint('🎨 ProfileSectionWidget: Extracted info: $extractedInfo');
    return extractedInfo;
  }
}
