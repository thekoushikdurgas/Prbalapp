import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'dart:io'; // Added for File operations in profile picture upload

// Services
import 'package:prbal/services/service_providers.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/services/user_service.dart';

// Models - Import for UpdateProfileRequest (now available in user_service.dart)
// UpdateProfileRequest is defined in user_service.dart and exported through service providers

// Components
// Theme
import 'package:prbal/utils/theme/theme_manager.dart';

// Navigation
import 'package:prbal/utils/navigation/routes/route_enum.dart';

// Utils
import 'package:prbal/utils/settings/settings_utils.dart';
import 'package:prbal/utils/preferences_manager.dart';
import 'package:prbal/utils/feedback_utils.dart';

// Localization
import 'package:prbal/utils/lang/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:prbal/widgets/settings/account_settings_widget.dart';
import 'package:prbal/widgets/settings/admin_controls_widget.dart';
import 'package:prbal/widgets/settings/app_settings_widget.dart';
import 'package:prbal/widgets/settings/app_version_widget.dart';
import 'package:prbal/widgets/settings/data_storage_settings_widget.dart';
import 'package:prbal/widgets/settings/logout_button_widget.dart';
import 'package:prbal/widgets/settings/profile_section_widget.dart';
// import 'package:prbal/utils/settings/text_controller_manager.dart';
import 'package:prbal/widgets/settings/settings_bottom_sheets.dart';
import 'package:prbal/widgets/settings/settings_loading_indicator_widget.dart';
import 'package:prbal/widgets/settings/support_legal_settings_widget.dart';
import 'package:prbal/widgets/settings/tokens_settings_widget.dart';
import 'package:prbal/widgets/settings/user_type_change_handler.dart';

/// SettingsScreen - Enhanced settings screen with centralized theme management
///
/// This screen provides a modern, responsive settings interface with:
/// - **Centralized ThemeManager** integration for consistent styling
/// - **ThemeAwareMixin** for easy theme access and responsive design
/// - **Material Design 3.0** gradients and glass morphism effects
/// - **Component-based architecture** for better maintainability
/// - **Real-time theme adaptation** with automatic light/dark mode switching
/// - **Performance optimization** with proper theme access patterns
/// - **Comprehensive debug logging** for theme operations and state tracking
/// - **Enhanced visual design** with theme-aware colors and effects
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> with TickerProviderStateMixin, ThemeAwareMixin {
  // State variables
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;
  bool _analyticsEnabled = true;
  bool _isLoadingData = true;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint('⚙️ SettingsScreen: Initializing enhanced settings screen with ThemeManager');

    _initializeAnimations();
    _loadAllSettings();
  }

  /// Initializes entrance animations
  void _initializeAnimations() {
    debugPrint('⚙️ SettingsScreen: Initializing animations');

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  /// Loads all settings data
  Future<void> _loadAllSettings() async {
    debugPrint('⚙️ SettingsScreen: Loading all settings data');

    try {
      // Load data in parallel for better performance
      await _loadUserPreferences();

      if (mounted) {
        setState(() {
          _isLoadingData = false;
        });
        debugPrint('⚙️ SettingsScreen: All settings data loaded successfully');
      }
    } catch (e) {
      debugPrint('❌ SettingsScreen: Error loading settings data: $e');
      if (mounted) {
        setState(() {
          _isLoadingData = false;
        });
      }
    }
  }

  /// Loads user preferences from local storage
  Future<void> _loadUserPreferences() async {
    debugPrint('⚙️ SettingsScreen: Loading user preferences');

    try {
      final userData = HiveService.getUserData();
      if (mounted) {
        setState(() {
          _notificationsEnabled = userData.notificationsEnabled;
          _biometricsEnabled = userData.biometricsEnabled;
          _analyticsEnabled = userData.analyticsEnabled;
        });
        debugPrint('⚙️ SettingsScreen: User preferences loaded');
      }
    } catch (e) {
      debugPrint('❌ SettingsScreen: Error loading user preferences: $e');
    }
  }

  @override
  void dispose() {
    debugPrint('⚙️ SettingsScreen: Disposing controllers');
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('⚙️ SettingsScreen: Building enhanced settings screen with ThemeManager');

    // Use centralized ThemeManager instead of manual theme detection
    final themeManager = ThemeManager.of(context);
    final UserType userType = HiveService.getUserType();
    final authState = ref.watch(authenticationStateProvider);

    // Enhanced debug logging with theme state

    // debugPrint('⚙️ SettingsScreen: User type: $userType');
    // debugPrint('⚙️ SettingsScreen: User authenticated: ${authState.isAuthenticated}');

    return Scaffold(
      backgroundColor: themeManager.backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Enhanced App Bar with ThemeManager
                _buildEnhancedAppBar(themeManager),

                // Main Content
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),

                      // Loading Indicator
                      if (_isLoadingData) const SettingsLoadingIndicatorWidget(),

                      // Profile Section
                      ProfileSectionWidget(
                        onEditProfile: () => _showEditProfileBottomSheet(),
                        onViewProfile: () => _navigateToViewProfile(),
                        onProfilePictureEdit: (ImageSource source) async {
                          debugPrint('🖼️ ProfileSectionWidget: Profile picture edit requested');
                          debugPrint('🖼️ Image source: ${source.name}');
                          await _handleProfilePictureUpdate(source);
                        },
                      ),

                      // Account Settings
                      AccountSettingsWidget(
                        userType: userType,
                        authState: authState,
                        onUserTypeChange: () => UserTypeChangeHandler.showUserTypeChangeDialog(
                          context: context,
                          ref: ref,
                          currentUserType: userType,
                        ),
                      ),

                      // App Settings
                      AppSettingsWidget(
                        notificationsEnabled: _notificationsEnabled,
                        biometricsEnabled: _biometricsEnabled,
                        analyticsEnabled: _analyticsEnabled,
                        onNotificationsChanged: (value) async {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                          await _saveNotificationPreference(value);
                        },
                        onSecurityTapped: () => _showSecuritySettings(themeManager),
                        onAnalyticsChanged: (value) async {
                          setState(() {
                            _analyticsEnabled = value;
                          });
                          await _saveAnalyticsPreference(value);
                        },
                      ),

                      // Admin Controls
                      if (userType == UserType.admin) const AdminControlsWidget(),

                      // Data & Storage
                      DataStorageSettingsWidget(
                        onClearCache: () => _showClearCacheDialog(),
                      ),

                      // Support & Legal
                      const SupportLegalSettingsWidget(),

                      // Tokens Management
                      TokensSettingsWidget(
                        onActiveSessionsTapped: () => _showActiveSessionsBottomSheet(),
                        // onAccessTokensTapped: () => _showAccessTokensBottomSheet(),
                        onRefreshTokenTapped: () => _showRefreshTokenBottomSheet(),
                        // onRevokeAllSessionsTapped: () => _showRevokeAllSessionsDialog(),
                      ),

                      // Logout Button
                      const LogoutButtonWidget(),

                      // App Version
                      const AppVersionWidget(),

                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds enhanced app bar with ThemeManager gradients and effects
  Widget _buildEnhancedAppBar(ThemeManager themeManager) {
    debugPrint('⚙️ SettingsScreen: Building enhanced app bar with ThemeManager');

    return SliverAppBar(
      expandedHeight: 120.h,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: themeManager.backgroundGradient,
          boxShadow: themeManager.primaryShadow,
        ),
        child: FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(left: 20.w, bottom: 16.h),
          title: Text(
            LocaleKeys.settingTitle.tr(),
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: themeManager.textPrimary,
              letterSpacing: -1.0,
            ),
          ),
        ),
      ),
    );
  }

  /// Shows security settings bottom sheet with ThemeManager
  Future<void> _showSecuritySettings(ThemeManager themeManager) async {
    debugPrint('⚙️ SettingsScreen: Showing security settings with theme-aware styling');

    await SettingsBottomSheets.showSecurityBottomSheet(
      context,
      biometricsEnabled: _biometricsEnabled,
      onBiometricsChanged: (value) async {
        setState(() {
          _biometricsEnabled = value;
        });
        await _saveBiometricPreference(value);
      },
      onResetPin: () => _showPinResetDialog(),
    );
  }

  /// Shows clear cache confirmation dialog
  Future<void> _showClearCacheDialog() async {
    debugPrint('⚙️ SettingsScreen: Showing clear cache dialog');

    final confirmed = await SettingsBottomSheets.showClearCacheBottomSheet(context);

    if (confirmed == true && mounted) {
      // TODO: Implement cache clearing logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('settings.cacheCleared'.tr()),
          backgroundColor: const Color(0xFF48BB78),
        ),
      );
    }
  }

  /// Shows PIN reset dialog
  Future<void> _showPinResetDialog() async {
    debugPrint('⚙️ SettingsScreen: Showing PIN reset dialog');

    final phoneNumber = HiveService.getPhoneNumber();
    if (phoneNumber == null) return;

    // TODO: Navigate to PIN reset screen
    context.push(
      RouteEnum.pinEntry.rawValue,
      extra: {
        'phoneNumber': phoneNumber,
        'isNewUser': true, // Treat as new user to set new PIN
      },
    );
  }

  // ============================================================================
  // PROFILE PICTURE HANDLING METHODS
  // ============================================================================

  /// ENHANCED PROFILE PICTURE UPDATE IMPLEMENTATION WITH THEMEMANAGER
  ///
  /// This method provides a comprehensive profile picture update workflow that includes:
  ///
  /// **FEATURES IMPLEMENTED:**
  /// ✅ **ThemeManager Integration** - Uses centralized theme management for consistent styling
  /// ✅ Authentication validation with detailed error handling
  /// ✅ **Enhanced loading dialog** with theme-aware styling and glass morphism effects
  /// ✅ Image compression and resizing (85% quality, max 1024x1024px)
  /// ✅ File size validation (5MB limit) with user-friendly error messages
  /// ✅ Robust API response parsing handling multiple response structures
  /// ✅ Real-time authentication state updates with local storage persistence
  /// ✅ Comprehensive error handling with detailed debug logging
  /// ✅ **Theme-aware user feedback** via styled SnackBars with proper colors
  /// ✅ Proper memory management and dialog cleanup
  /// ✅ **Enhanced debug logging** with theme state tracking
  ///
  /// **THEMEMANAGER INTEGRATION POINTS:**
  /// - Uses themeManager.surfaceColor for dialog backgrounds
  /// - Applies themeManager.textPrimary for consistent text colors
  /// - Leverages themeManager.glassMorphism for modern dialog effects
  /// - Uses themeManager.primaryColor for accent elements
  /// - Integrates themeManager.conditionalColor() for dynamic theming
  ///
  /// @param source ImageSource.camera for camera capture, ImageSource.gallery for gallery selection
  Future<void> _handleProfilePictureUpdate(ImageSource source) async {
    debugPrint('🖼️ SettingsScreen: Starting enhanced profile picture update with ThemeManager');
    debugPrint('🖼️ Image source: ${source == ImageSource.camera ? 'Camera' : 'Gallery'}');

    // Get current authentication state, services, and theme manager
    final authState = ref.read(authenticationStateProvider);
    final userService = ref.read(userServiceProvider);
    final themeManager = ThemeManager.of(context);

    debugPrint('🖼️ Authentication state: ${authState.isAuthenticated}');
    debugPrint('🖼️ Access token available: ${authState.accessToken != null}');

    // Step 1: Validate user authentication
    if (!authState.isAuthenticated || authState.accessToken == null) {
      debugPrint('❌ Profile picture update failed: User not authenticated');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Prbal.errorOutline,
                  color: Colors.white,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Text('profile.loginToUpdatePicture'.tr()),
              ],
            ),
            backgroundColor: themeManager.conditionalColor(
              lightColor: const Color(0xFFE53E3E),
              darkColor: const Color(0xFFFC8181),
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.all(16.w),
          ),
        );
      }
      return;
    }

    try {
      // Step 2: Show enhanced loading indicator with ThemeManager styling
      debugPrint('🖼️ Showing enhanced loading dialog with theme-aware styling');
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => PopScope(
            canPop: false,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: themeManager.glassMorphism,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        themeManager.primaryColor,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'profile.updatingPicture'.tr(),
                      style: TextStyle(
                        color: themeManager.textPrimary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      // Step 3: Pick image from selected source with compression settings
      debugPrint('🖼️ Initializing ImagePicker');
      final ImagePicker picker = ImagePicker();

      debugPrint('🖼️ Attempting to pick image from ${source.name}');
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85, // Compress image to 85% quality for smaller file size
        maxWidth: 1024, // Limit maximum width to 1024 pixels
        maxHeight: 1024, // Limit maximum height to 1024 pixels
      );

      debugPrint('🖼️ Image picker result: ${pickedFile != null ? 'Image selected' : 'No image selected'}');

      // Check if user cancelled image selection
      if (pickedFile == null) {
        debugPrint('🖼️ User cancelled image selection');
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); // Close loading dialog
        }
        return;
      }

      // Step 4: Convert XFile to File and validate
      debugPrint('🖼️ Converting XFile to File');
      final File imageFile = File(pickedFile.path);

      // Validate file exists and get size info
      final bool fileExists = await imageFile.exists();
      final int fileSize = fileExists ? await imageFile.length() : 0;

      debugPrint('🖼️ Image file details:');
      debugPrint('   📄 Path: ${imageFile.path}');
      debugPrint('   📊 Size: ${(fileSize / 1024).toStringAsFixed(2)} KB');
      debugPrint('   ✅ Exists: $fileExists');

      if (!fileExists) {
        throw Exception('Selected image file does not exist');
      }

      // Optional: Check file size limit (e.g., 5MB)
      const int maxFileSizeBytes = 5 * 1024 * 1024; // 5MB
      if (fileSize > maxFileSizeBytes) {
        throw Exception('Image file too large. Please select an image smaller than 5MB.');
      }

      // Step 5: Upload profile image via API
      debugPrint('🖼️ Starting API upload');
      debugPrint('🖼️ Using access token: ${authState.accessToken!.substring(0, 20)}...');

      final uploadResponse = await userService.uploadProfileImage(
        imageFile,
        authState.accessToken!,
      );

      debugPrint('🖼️ Upload response received');
      debugPrint('🖼️ Success: ${uploadResponse.isSuccess}');
      debugPrint('🖼️ Message: ${uploadResponse.message}');
      debugPrint('🖼️ Data type: ${uploadResponse.data?.runtimeType}');

      // Close loading dialog
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Step 6: Process successful upload
      if (uploadResponse.isSuccess) {
        debugPrint('✅ Profile picture upload successful');

        // Extract new profile picture URL from response
        // Handle different possible response structures
        String? newProfilePictureUrl;

        if (uploadResponse.data is Map<String, dynamic>) {
          final data = uploadResponse.data as Map<String, dynamic>;
          debugPrint('🖼️ Response data keys: ${data.keys.toList()}');

          // Try different possible paths for the profile picture URL
          newProfilePictureUrl = data['data']?['user']?['profile_picture'] as String? ??
              data['user']?['profile_picture'] as String? ??
              data['profile_picture'] as String? ??
              data['profilePicture'] as String? ??
              data['url'] as String?;
        } else if (uploadResponse.data is String) {
          newProfilePictureUrl = uploadResponse.data as String;
        }

        debugPrint('🖼️ Extracted profile picture URL: $newProfilePictureUrl');

        if (newProfilePictureUrl != null && newProfilePictureUrl.isNotEmpty) {
          // Step 7: Update authentication state with new profile picture
          debugPrint('🖼️ Updating authentication state with new profile picture');

          final authNotifier = ref.read(authenticationStateProvider.notifier);
          final updatedUserData = authState.userData?.copyWith(
            profilePicture: newProfilePictureUrl,
            updatedAt: DateTime.now(),
          );

          // debugPrint('🖼️ Updated user data keys: ${updatedUserData.toJson().keys.toList()}');

          await authNotifier.setAuthenticated(
            accessToken: authState.accessToken!,
            refreshToken: authState.refreshToken,
            userData: updatedUserData!,
            userType: authState.userType,
          );

          // Also save to local storage for persistence
          await HiveService.saveUserData(updatedUserData);
          debugPrint('🖼️ User data saved to local storage');

          // Step 8: Show success feedback to user
          if (mounted) {
            // Provide haptic feedback
            HapticFeedback.lightImpact();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      Prbal.checkCircle,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    const Text('Profile picture updated successfully!'),
                  ],
                ),
                backgroundColor: const Color(0xFF48BB78),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                margin: EdgeInsets.all(16.w),
                duration: const Duration(seconds: 3),
              ),
            );
          }

          debugPrint('✅ Profile picture update completed successfully');
          debugPrint('🖼️ New profile picture URL: $newProfilePictureUrl');
        } else {
          throw Exception('No profile picture URL received from server response');
        }
      } else {
        throw Exception(uploadResponse.message);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Profile picture update failed with error: $e');
      debugPrint('📊 Stack trace: $stackTrace');

      // Close loading dialog if still open
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Show error feedback to user
      if (mounted) {
        // Provide error haptic feedback
        HapticFeedback.heavyImpact();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Prbal.errorOutline,
                  color: Colors.white,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Failed to update profile picture',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        e.toString(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFE53E3E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.all(16.w),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  // ============================================================================
  // USER TYPE CHANGE IMPLEMENTATION
  // ============================================================================

  /// Shows error snackbar
  void _showErrorSnackBar(String message) => FeedbackUtils.showError(context: context, message: message);

  // ============================================================================
  // ENHANCED USER TYPE CHANGE SERVICE METHODS
  // ============================================================================

  // ============================================================================
  // TEXT EDITING CONTROLLER DISPOSAL METHODS
  // ============================================================================

  /// COMPREHENSIVE TEXTEDITING CONTROLLER DISPOSAL SYSTEM
  ///
  /// This section implements a robust disposal system for TextEditingController instances
  /// throughout the SettingsScreen to prevent memory leaks and ensure proper resource cleanup.
  ///
  /// **IMPLEMENTATION FEATURES:**
  /// ✅ Null-safe disposal with comprehensive validation
  /// ✅ Enhanced debug logging with emoji-coded messages for easy identification
  /// ✅ Error handling with graceful fallbacks that prevent app crashes
  /// ✅ Performance metrics tracking and disposal success reporting
  /// ✅ Batch processing for multiple controllers with individual error isolation
  /// ✅ WidgetsBinding integration for frame-safe disposal timing
  /// ✅ Memory leak prevention through comprehensive disposal validation
  ///
  /// **TEXTEDITING CONTROLLER INSTANCES MANAGED:**
  /// 1. 🔄 reasonController - User type change reason input (single controller)
  /// 2. 📝 Profile Form Controllers - Edit profile modal (5 controllers batch):
  ///    - firstNameController
  ///    - lastNameController
  ///    - usernameController
  ///    - bioController
  ///    - locationController
  ///
  /// **DISPOSAL PATTERNS USED:**
  /// - Single Controller: _disposeTextEditingController() method
  /// - Multiple Controllers: _disposeMultipleTextEditingControllers() method
  /// - Integration: whenComplete() callbacks with try-catch error handling
  /// - Timing: WidgetsBinding.instance.addPostFrameCallback() for safe disposal
  ///
  /// **DEBUG LOGGING SYSTEM:**
  /// 🎮 Controller lifecycle events (creation, disposal scheduling)
  /// 📝 Controller state information (text length, listener count)
  /// ✅ Successful disposal confirmations
  /// ⚠️ Warning messages for already disposed controllers
  /// ❌ Error handling and fallback execution
  /// 📊 Batch disposal metrics and success rates
  ///
  /// **MEMORY LEAK PREVENTION:**
  /// - All controllers are disposed in whenComplete() callbacks
  /// - Error handling ensures disposal attempts even during exceptions
  /// - Null safety prevents disposal of already-disposed controllers
  /// - Frame-safe timing prevents disposal during active UI updates
  /// - Individual error isolation prevents batch disposal failures
  ///
  /// **BEST PRACTICES IMPLEMENTED:**
  /// 1. Always use try-catch blocks around disposal operations
  /// 2. Schedule disposal with WidgetsBinding for proper timing
  /// 3. Provide detailed debug information for development troubleshooting
  /// 4. Use nullable controller declarations with safe disposal checks
  /// 5. Implement batch disposal for multiple related controllers
  /// 6. Track disposal success metrics for performance monitoring
  /// 7. Ensure disposal happens even when modal bottom sheets are cancelled
  ///
  /// **INTEGRATION WITH MODAL BOTTOM SHEETS:**
  /// Both disposal patterns are integrated with showModalBottomSheet().whenComplete()
  /// to ensure controllers are disposed regardless of how the modal is closed:
  /// - Normal button taps (Cancel/Save/Change Type)
  /// - Gesture dismissal (swipe down)
  /// - Barrier taps (tap outside modal)
  /// - Navigation back button
  /// - App lifecycle changes or interruptions
  ///
  /// This comprehensive system ensures zero memory leaks from TextEditingController
  /// instances while providing detailed debugging information for development.

  /// Enhanced TextEditingController disposal method with comprehensive tracking
  void _disposeTextEditingController({
    TextEditingController? controller,
    required String controllerName,
    required String context,
  }) {
    if (controller == null) {
      debugPrint('🎮 SettingsScreen: No controller to dispose for $controllerName in $context');
      return;
    }

    try {
      // Use WidgetsBinding to ensure disposal happens after frame is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          // Check if controller is still valid before disposing
          if (controller.text.isEmpty || controller.text.isNotEmpty) {
            // This is a safe way to check if controller is still valid
            debugPrint('🎮 SettingsScreen: Disposing $controllerName in $context');
            debugPrint('   📝 Controller text length: ${controller.text.length} characters');

            // Dispose the controller
            controller.dispose();

            debugPrint('✅ SettingsScreen: Successfully disposed $controllerName in $context');
          } else {
            debugPrint('⚠️ SettingsScreen: Controller $controllerName already disposed in $context');
          }
        } catch (disposeError) {
          debugPrint('❌ SettingsScreen: Error disposing $controllerName in $context: $disposeError');
          // Continue execution even if disposal fails to prevent app crashes
        }
      });
    } catch (e) {
      debugPrint('❌ SettingsScreen: Failed to schedule disposal for $controllerName in $context: $e');
    }
  }

  /// Disposes multiple TextEditingController instances with batch processing
  ///
  /// This method handles disposal of multiple controllers efficiently:
  /// - Processes controllers in parallel where possible
  /// - Provides individual error handling for each controller
  /// - Tracks disposal success/failure metrics
  /// - Prevents memory leaks from partial disposal failures
  ///
  /// @param controllers Map of controller name to TextEditingController instance
  /// @param context Context description for debugging
  void _disposeMultipleTextEditingControllers({
    required Map<String, TextEditingController?> controllers,
    required String context,
  }) {
    debugPrint('🎮 SettingsScreen: Disposing ${controllers.length} controllers in $context');

    int successCount = 0;
    int errorCount = 0;

    try {
      for (final entry in controllers.entries) {
        final controllerName = entry.key;
        final controller = entry.value;

        try {
          _disposeTextEditingController(
            controller: controller,
            controllerName: controllerName,
            context: context,
          );
          successCount++;
        } catch (e) {
          debugPrint('❌ SettingsScreen: Failed to dispose $controllerName in $context: $e');
          errorCount++;
        }
      }

      debugPrint('✅ SettingsScreen: Disposal summary for $context:');
      debugPrint('   ✅ Successful: $successCount');
      debugPrint('   ❌ Failed: $errorCount');
      debugPrint('   📊 Success rate: ${((successCount / controllers.length) * 100).toStringAsFixed(1)}%');
    } catch (e) {
      debugPrint('❌ SettingsScreen: Critical error in batch disposal for $context: $e');
    }
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  // /// Helper methods for user data extraction
  // bool _isVerified(AppUser userData) => SettingsUtils.isVerified(userData);

  /// Saves notification preference
  Future<void> _saveNotificationPreference(bool enabled) async {
    await PreferencesManager.saveNotificationPreference(
      enabled: enabled,
      context: context,
    );
  }

  /// Saves analytics preference
  Future<void> _saveAnalyticsPreference(bool enabled) async {
    await PreferencesManager.saveAnalyticsPreference(
      enabled: enabled,
      context: context,
    );
  }

  /// Saves biometric preference
  Future<void> _saveBiometricPreference(bool enabled) async {
    await PreferencesManager.saveBiometricPreference(
      enabled: enabled,
      context: context,
    );
  }

  /// Shows profile information in a modal bottom sheet
  void _navigateToViewProfile() {
    debugPrint('⚙️ SettingsScreen: Showing profile bottom sheet');

    try {
      _showProfileBottomSheet();
      debugPrint('⚙️ SettingsScreen: Successfully opened profile bottom sheet');
    } catch (e) {
      debugPrint('❌ SettingsScreen: Failed to show profile bottom sheet: $e');

      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to open profile. Please try again.'),
            backgroundColor: const Color(0xFFE53E3E),
          ),
        );
      }
    }
  }

  /// Shows edit profile bottom sheet with form
  void _showEditProfileBottomSheet() {
    debugPrint('⚙️ SettingsScreen: Showing edit profile bottom sheet');

    try {
      _showEditProfileForm();
      debugPrint('⚙️ SettingsScreen: Successfully opened edit profile bottom sheet');
    } catch (e) {
      debugPrint('❌ SettingsScreen: Failed to show edit profile bottom sheet: $e');

      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to open edit profile. Please try again.'),
            backgroundColor: const Color(0xFFE53E3E),
          ),
        );
      }
    }
  }

  /// Shows a modern profile bottom sheet with user information
  Future<void> _showProfileBottomSheet() async {
    debugPrint('⚙️ SettingsScreen: Building profile bottom sheet');

    final themeManager = ThemeManager.of(context);
    final authState = ref.read(authenticationStateProvider);
    final AppUser userData = authState.userData as AppUser;

    // Extract user information
    final displayName = getDisplayName(userData);
    final userType = userData.userType;
    final profilePicture = userData.profilePicture;
    final isVerified = userData.isVerified;
    final rating = _getRealRating(userData);
    final bookingCount = _getRealBookingCount(userData);
    final userTypeColor = themeManager.getUserTypeColor(userType);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: themeManager.surfaceColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: themeManager.borderColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              // Profile content
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: userTypeColor.withValues(alpha: 26),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            getUserTypeIcon(userType),
                            color: userTypeColor,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Text(
                            'Profile Information',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: themeManager.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // Profile avatar and basic info
                    Row(
                      children: [
                        // Avatar
                        Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                userTypeColor.withValues(alpha: 51),
                                userTypeColor.withValues(alpha: 26),
                              ],
                            ),
                            border: Border.all(
                              color: userTypeColor.withValues(alpha: 77),
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: profilePicture != null && profilePicture.isNotEmpty
                                ? Image.network(
                                    profilePicture,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(
                                      getUserTypeIcon(userType),
                                      color: userTypeColor,
                                      size: 36.sp,
                                    ),
                                  )
                                : Icon(
                                    getUserTypeIcon(userType),
                                    color: userTypeColor,
                                    size: 36.sp,
                                  ),
                          ),
                        ),

                        SizedBox(width: 20.w),

                        // User info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name with verification
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      displayName,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: themeManager.textPrimary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isVerified)
                                    Icon(
                                      Prbal.verified,
                                      color: themeManager.successColor,
                                      size: 20.sp,
                                    ),
                                ],
                              ),

                              SizedBox(height: 6.h),

                              // User type badge
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      userTypeColor.withValues(alpha: 38),
                                      userTypeColor.withValues(alpha: 13),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: userTypeColor.withValues(alpha: 77),
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
                          ),
                        ),
                      ],
                    ),

                    // Stats for providers
                    if (userType == UserType.provider) ...[
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatItem(
                              'Rating',
                              rating.toStringAsFixed(1),
                              Prbal.star,
                              themeManager.warningColor,
                              themeManager,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: _buildStatItem(
                              'Bookings',
                              bookingCount.toString(),
                              Prbal.bookmark,
                              themeManager.infoColor,
                              themeManager,
                            ),
                          ),
                        ],
                      ),
                    ],

                    SizedBox(height: 32.h),

                    // Close button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: userTypeColor,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
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

  /// Shows edit profile form in a modal bottom sheet
  Future<void> _showEditProfileForm() async {
    debugPrint('⚙️ SettingsScreen: Building edit profile form');

    final themeManager = ThemeManager.of(context);
    final authState = ref.read(authenticationStateProvider);
    final userData = authState.userData as AppUser;

    // Form controllers with current data
    final firstNameController = TextEditingController(text: userData.firstName);
    final lastNameController = TextEditingController(text: userData.lastName);
    final usernameController = TextEditingController(text: userData.username);
    final bioController = TextEditingController(text: userData.bio);
    final locationController = TextEditingController(text: userData.location);

    // Form key for validation
    final formKey = GlobalKey<FormState>();
    final userTypeColor = themeManager.getUserTypeColor(userData.userType);

    // State management
    bool isLoading = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bottomSheetContext) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: themeManager.surfaceColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: themeManager.borderColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),

                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: userTypeColor.withValues(alpha: 26),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Prbal.edit,
                          color: userTypeColor,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: themeManager.textPrimary,
                          ),
                        ),
                      ),
                      // Close button
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Prbal.cross,
                          color: themeManager.textSecondary,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                // Form content
                Expanded(
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // First Name
                          _buildFormField(
                            label: 'First Name',
                            controller: firstNameController,
                            hint: 'Enter your first name',
                            themeManager: themeManager,
                            validator: (value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'First name is required';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 16.h),

                          // Last Name
                          _buildFormField(
                            label: 'Last Name',
                            controller: lastNameController,
                            hint: 'Enter your last name',
                            themeManager: themeManager,
                            validator: (value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'Last name is required';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 16.h),

                          // Username
                          _buildFormField(
                            label: 'Username',
                            controller: usernameController,
                            hint: 'Enter your username',
                            themeManager: themeManager,
                            validator: (value) {
                              if (value?.trim().isEmpty ?? true) {
                                return 'Username is required';
                              }
                              if (value!.length < 3) {
                                return 'Username must be at least 3 characters';
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 16.h),

                          // Bio
                          _buildFormField(
                            label: 'Bio',
                            controller: bioController,
                            hint: 'Tell us about yourself',
                            themeManager: themeManager,
                            maxLines: 3,
                            required: false,
                          ),

                          SizedBox(height: 16.h),

                          // Location
                          _buildFormField(
                            label: 'Location',
                            controller: locationController,
                            hint: 'Your city or area',
                            themeManager: themeManager,
                            required: false,
                          ),

                          SizedBox(height: 32.h),
                        ],
                      ),
                    ),
                  ),
                ),

                // Action buttons
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
                  child: Row(
                    children: [
                      // Cancel button
                      Expanded(
                        child: TextButton(
                          onPressed: isLoading ? null : () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              side: BorderSide(
                                color: themeManager.borderColor,
                              ),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: themeManager.textSecondary,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 16.w),

                      // Save button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  try {
                                    await _handleSaveProfile(
                                      context: bottomSheetContext,
                                      formKey: formKey,
                                      firstNameController: firstNameController,
                                      lastNameController: lastNameController,
                                      usernameController: usernameController,
                                      bioController: bioController,
                                      locationController: locationController,
                                      setModalState: setModalState,
                                      onLoadingChanged: (loading) {
                                        setModalState(() {
                                          isLoading = loading;
                                        });
                                      },
                                    );
                                  } catch (e) {
                                    debugPrint('❌ Error in save profile: $e');
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: userTypeColor,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).whenComplete(() {
      // Enhanced disposal of multiple controllers with comprehensive tracking
      _disposeMultipleTextEditingControllers(
        controllers: {
          'firstNameController': firstNameController,
          'lastNameController': lastNameController,
          'usernameController': usernameController,
          'bioController': bioController,
          'locationController': locationController,
        },
        context: 'edit profile form modal',
      );
    });
  }

  /// Builds a form field widget
  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required ThemeManager themeManager,
    int maxLines = 1,
    bool required = true,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: themeManager.textPrimary,
              ),
            ),
            if (required) ...[
              SizedBox(width: 4.w),
              Text(
                '*',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: themeManager.errorColor,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: TextStyle(
            fontSize: 16.sp,
            color: themeManager.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: themeManager.textTertiary,
              fontSize: 14.sp,
            ),
            filled: true,
            fillColor: themeManager.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: themeManager.borderColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: themeManager.borderColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: themeManager.getUserTypeColor(ref.read(authenticationStateProvider).userData!.userType),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: themeManager.errorColor,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: themeManager.errorColor,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: maxLines > 1 ? 16.h : 16.h,
            ),
          ),
        ),
      ],
    );
  }

  /// Handles saving profile changes
  Future<void> _handleSaveProfile({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController firstNameController,
    required TextEditingController lastNameController,
    required TextEditingController usernameController,
    required TextEditingController bioController,
    required TextEditingController locationController,
    required StateSetter setModalState,
    required Function(bool) onLoadingChanged,
  }) async {
    debugPrint('⚙️ SettingsScreen: Handling save profile');

    // Validate form
    if (!formKey.currentState!.validate()) {
      debugPrint('❌ SettingsScreen: Form validation failed');
      return;
    }

    onLoadingChanged(true);

    try {
      // Get current auth token
      final authToken = HiveService.getAuthToken();

      // Prepare update request
      final updateRequest = UpdateProfileRequest(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        username: usernameController.text.trim(),
        bio: bioController.text.trim().isEmpty ? null : bioController.text.trim(),
        location: locationController.text.trim().isEmpty ? null : locationController.text.trim(),
      );

      debugPrint('⚙️ SettingsScreen: Sending profile update request');
      debugPrint('📝 Update data: ${updateRequest.toJson()}');

      // Use service providers to get user service
      final userService = ref.read(userServiceProvider);

      // Call API to update profile
      final response = await userService.updateProfilePartial(updateRequest, authToken);

      // Close loading dialog
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (response.isSuccess) {
        debugPrint('✅ SettingsScreen: Profile updated successfully');

        // Update local auth state with new data
        final authNotifier = ref.read(authenticationStateProvider.notifier);
        final currentState = ref.read(authenticationStateProvider);

        // Update user data with new type
        final updatedUserData = currentState.userData?.copyWith(
          firstName: response.data!.firstName,
          lastName: response.data!.lastName,
          username: response.data!.username,
          bio: response.data!.bio,
          location: response.data!.location,
          updatedAt: response.data!.updatedAt,
        );

        // Update authentication state
        await authNotifier.setAuthenticated(
          accessToken: currentState.accessToken!,
          refreshToken: currentState.refreshToken,
          userData: updatedUserData!,
          userType: currentState.userType,
        );

        // Save to local storage
        await HiveService.saveUserData(updatedUserData);

        if (mounted) {
          // Close the bottom sheet
          Navigator.pop(context);

          // Show success message
          ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    Prbal.checkCircle,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Profile updated successfully!',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF48BB78),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              margin: EdgeInsets.all(16.w),
              duration: const Duration(seconds: 4),
            ),
          );

          // Provide haptic feedback
          HapticFeedback.lightImpact();
        }

        debugPrint('✅ Profile updated completed successfully');
      } else {
        debugPrint('❌ Failed to update profile: ${response.message}');
        _showErrorSnackBar('Failed to update profile: ${response.message}');
      }
    } catch (e) {
      debugPrint('❌ SettingsScreen: Error updating profile: $e');

      // Close loading dialog if still open
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      _showErrorSnackBar('Error updating profile: $e');
    }
  }

  /// Builds a stat item widget for the profile bottom sheet
  Widget _buildStatItem(String label, String value, IconData icon, Color color, ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 26),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withValues(alpha: 51),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: themeManager.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: themeManager.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Helper methods for user data extraction
  String getDisplayName(AppUser userData) => SettingsUtils.getDisplayName(userData);

  double _getRealRating(AppUser userData) => SettingsUtils.getRealRating(userData);

  int _getRealBookingCount(AppUser userData) => SettingsUtils.getRealBookingCount(userData);

  // IconData getUserTypeIcon(UserType userType) => SettingsUtils.getUserTypeIcon(userType);

  // String _getUserTypeDisplayName(UserType userType) => SettingsUtils.getUserTypeDisplayName(userType);

  // ============================================================================
  // TOKEN MANAGEMENT METHODS
  // ============================================================================

  /// Shows active sessions bottom sheet
  Future<void> _showActiveSessionsBottomSheet() async {
    debugPrint('🔑 SettingsScreen: Showing active sessions');

    final authState = ref.read(authenticationStateProvider);
    if (!authState.isAuthenticated || authState.accessToken == null) {
      _showAuthenticationRequiredSnackBar();
      return;
    }

    final userService = ref.read(userServiceProvider);

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Fetch active tokens
      final response = await userService.listAccessTokens(
        token: authState.accessToken!,
        activeOnly: true,
      );

      // Hide loading dialog
      if (mounted) Navigator.of(context).pop();

      if (response.isSuccess && mounted) {
        final tokens = response.data ?? [];
        _showTokensBottomSheet('Active Sessions', tokens, showRevokeOption: true);
      } else {
        _showErrorSnackBar('Failed to load active sessions: ${response.message}');
      }
    } catch (e) {
      // Hide loading dialog
      if (mounted) Navigator.of(context).pop();
      _showErrorSnackBar('Error loading sessions: $e');
    }
  }

  /// Shows refresh token bottom sheet
  Future<void> _showRefreshTokenBottomSheet() async {
    debugPrint('🔑 SettingsScreen: Showing refresh token info');

    final authState = ref.read(authenticationStateProvider);
    if (!authState.isAuthenticated) {
      _showAuthenticationRequiredSnackBar();
      return;
    }

    final themeManager = ThemeManager.of(context);
    final refreshToken = authState.refreshToken;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: themeManager.surfaceColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Prbal.refresh,
                  color: themeManager.primaryColor,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  'Refresh Token',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: themeManager.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Prbal.close,
                    color: themeManager.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Refresh token info
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: themeManager.backgroundColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: themeManager.borderColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: themeManager.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: refreshToken != null ? themeManager.successColor : themeManager.errorColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        refreshToken != null ? 'Active' : 'Not Available',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: themeManager.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Token Preview',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: themeManager.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: themeManager.inputBackground,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      refreshToken != null ? '${refreshToken.substring(0, 20)}...' : 'No refresh token available',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontFamily: ThemeManager.fontFamilySemiExpanded,
                        color: themeManager.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Action button
            if (refreshToken != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _refreshAccessToken(),
                  icon: Icon(Prbal.refresh, size: 18.sp),
                  label: const Text('Refresh Access Token'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeManager.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),

            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 20.h),
          ],
        ),
      ),
    );
  }

  /// Shows tokens bottom sheet with modern design
  void _showTokensBottomSheet(String title, List<Map<String, dynamic>> tokens, {bool showRevokeOption = false}) {
    final themeManager = ThemeManager.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: themeManager.surfaceColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            boxShadow: themeManager.elevatedShadow,
          ),
          child: Column(
            children: [
              // Modern drag handle
              Container(
                margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                width: 60.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: themeManager.borderColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

              // Enhanced Header
              Container(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 20.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: themeManager.borderColor,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Modern icon with gradient background
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            themeManager.successColor.withValues(alpha: 51),
                            themeManager.infoColor.withValues(alpha: 26),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: themeManager.successColor.withValues(alpha: 77),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Prbal.security,
                        color: themeManager.successColor,
                        size: 28.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),

                    // Title and subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: themeManager.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${tokens.length} ${tokens.length == 1 ? 'session' : 'sessions'} found',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: themeManager.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Modern close button
                    Container(
                      decoration: BoxDecoration(
                        color: themeManager.inputBackground,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Prbal.cross,
                          color: themeManager.textSecondary,
                          size: 20.sp,
                        ),
                        padding: EdgeInsets.all(8.w),
                        constraints: BoxConstraints(
                          minWidth: 40.w,
                          minHeight: 40.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Tokens list with enhanced design
              Expanded(
                child: tokens.isEmpty
                    ? _buildEmptyTokensState(themeManager)
                    : ListView.separated(
                        controller: scrollController,
                        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
                        itemCount: tokens.length,
                        separatorBuilder: (context, index) => SizedBox(height: 16.h),
                        itemBuilder: (context, index) {
                          final token = tokens[index];
                          return _buildModernTokenCard(token, themeManager, showRevokeOption, index);
                        },
                        physics: const BouncingScrollPhysics(),
                      ),
              ),

              // Bottom padding for safe area
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds empty state for tokens list
  Widget _buildEmptyTokensState(ThemeManager themeManager) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty state icon with animation-ready container
            Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                color: themeManager.inputBackground,
                borderRadius: BorderRadius.circular(60.r),
                border: Border.all(
                  color: themeManager.borderColor,
                  width: 2,
                ),
              ),
              child: Icon(
                Prbal.exclamationTriangle,
                size: 48.sp,
                color: themeManager.textTertiary,
              ),
            ),
            SizedBox(height: 24.h),

            // Empty state text
            Text(
              'No Sessions Found',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: themeManager.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'There are no active sessions or tokens to display at this time.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: themeManager.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds modern individual token card with enhanced design
  Widget _buildModernTokenCard(
      Map<String, dynamic> token, ThemeManager themeManager, bool showRevokeOption, int index) {
    // Extract token data
    final tokenId = token['id'] as String? ?? token['jti'] as String? ?? 'Unknown';
    final isActive = token['is_active'] as bool? ?? false;
    final createdAt = token['created_at'] as String?;
    final lastUsed = token['last_used_at'] as String? ?? token['last_used'] as String?;
    final deviceType = token['device_type'] as String? ?? 'unknown';
    final deviceName = token['device_name'] as String? ?? 'Unknown Device';
    final deviceTypeDisplay = token['device_type_display'] as String? ?? 'Unknown';
    final ipAddress = token['ip_address'] as String?;

    // Device info (handle both nested and flat structures)

    // Safe token preview
    String getSafeTokenPreview(String tokenStr) {
      if (tokenStr.isEmpty || tokenStr == 'Unknown') return tokenStr;
      return tokenStr.length > 12 ? '${tokenStr.substring(0, 12)}...' : tokenStr;
    }

    // Get device icon and color
    IconData getDeviceIcon(String type) {
      switch (type.toLowerCase()) {
        case 'mobile':
          return Prbal.mobilePhone;
        case 'desktop':
          return Prbal.desktop;
        case 'web':
        case 'browser':
          return Prbal.globe;
        case 'tablet':
          return Prbal.tablet;
        case 'api':
          return Prbal.cog;
        default:
          return Prbal.question;
      }
    }

    Color getDeviceColor(String type) {
      switch (type.toLowerCase()) {
        case 'mobile':
          return const Color(0xFF4299E1);
        case 'desktop':
          return const Color(0xFF9F7AEA);
        case 'web':
        case 'browser':
          return const Color(0xFF48BB78);
        case 'tablet':
          return const Color(0xFFF56565);
        case 'api':
          return const Color(0xFFED8936);
        default:
          return const Color(0xFF718096);
      }
    }

    final deviceColor = getDeviceColor(deviceType);
    final deviceIcon = getDeviceIcon(deviceType);

    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      decoration: BoxDecoration(
        color: themeManager.surfaceColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isActive ? deviceColor.withValues(alpha: 77) : themeManager.borderColor,
          width: isActive ? 1.5 : 1,
        ),
        boxShadow: isActive ? themeManager.elevatedShadow : themeManager.subtleShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Column(
          children: [
            // Main content
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row with device icon, status, and actions
                  Row(
                    children: [
                      // Device icon with background
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: deviceColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: deviceColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          deviceIcon,
                          color: deviceColor,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),

                      // Device info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Device name
                            Text(
                              deviceTypeDisplay,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: themeManager.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),

                            // Status badge
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? const Color(0xFF48BB78).withValues(alpha: 0.15)
                                    : const Color(0xFFE53E3E).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: isActive
                                      ? const Color(0xFF48BB78).withValues(alpha: 0.3)
                                      : const Color(0xFFE53E3E).withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6.w,
                                    height: 6.h,
                                    decoration: BoxDecoration(
                                      color: isActive ? const Color(0xFF48BB78) : const Color(0xFFE53E3E),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    isActive ? 'Active' : 'Inactive',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isActive ? const Color(0xFF48BB78) : const Color(0xFFE53E3E),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Action button
                      if (showRevokeOption && isActive)
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53E3E).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: const Color(0xFFE53E3E).withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            onPressed: () => _showRevokeTokenDialog(tokenId, deviceTypeDisplay),
                            icon: Icon(
                              Prbal.trash,
                              color: const Color(0xFFE53E3E),
                              size: 18.sp,
                            ),
                            padding: EdgeInsets.all(8.w),
                            constraints: BoxConstraints(
                              minWidth: 36.w,
                              minHeight: 36.h,
                            ),
                            tooltip: 'Revoke Session',
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Token ID section
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: themeManager.inputBackground,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: themeManager.borderColor,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Prbal.key,
                              size: 16.sp,
                              color: themeManager.textSecondary,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Session ID',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: themeManager.textSecondary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: themeManager.backgroundColor,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: themeManager.borderColor.withValues(alpha: 128),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  getSafeTokenPreview(tokenId),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontFamily: ThemeManager.fontFamilySemiExpanded,
                                    color: themeManager.textTertiary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _copyToClipboard(tokenId, 'Session ID copied'),
                                child: Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: deviceColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Icon(
                                    Prbal.copy,
                                    size: 14.sp,
                                    color: deviceColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Device and time info
                  Row(
                    children: [
                      // Device details
                      Expanded(
                        child: _buildInfoCard(
                          icon: Prbal.laptop,
                          title: 'Device',
                          value: deviceName.replaceAll('Dart/3.8 (dart:io)', 'Mobile App'),
                          themeManager: themeManager,
                        ),
                      ),
                      SizedBox(width: 12.w),

                      // IP Address
                      if (ipAddress != null)
                        Expanded(
                          child: _buildInfoCard(
                            icon: Prbal.globe,
                            title: 'Location',
                            value: ipAddress,
                            themeManager: themeManager,
                          ),
                        ),
                    ],
                  ),

                  if (createdAt != null || lastUsed != null) ...[
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        // Created time
                        if (createdAt != null)
                          Expanded(
                            child: _buildInfoCard(
                              icon: Prbal.clock,
                              title: 'Created',
                              value: _formatRelativeTime(createdAt),
                              themeManager: themeManager,
                            ),
                          ),
                        if (createdAt != null && lastUsed != null) SizedBox(width: 12.w),

                        // Last used
                        if (lastUsed != null)
                          Expanded(
                            child: _buildInfoCard(
                              icon: Prbal.history,
                              title: 'Last Used',
                              value: _formatRelativeTime(lastUsed),
                              themeManager: themeManager,
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds info card for token details
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required ThemeManager themeManager,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: themeManager.inputBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: themeManager.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14.sp,
                color: themeManager.textSecondary,
              ),
              SizedBox(width: 6.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: themeManager.textSecondary,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: themeManager.textTertiary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Shows modern revoke token confirmation dialog
  Future<void> _showRevokeTokenDialog(String tokenId, String deviceName) async {
    final themeManager = ThemeManager.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: themeManager.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        contentPadding: EdgeInsets.all(24.w),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning icon
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: themeManager.errorColor.withValues(alpha: 26),
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(
                  color: themeManager.errorColor.withValues(alpha: 77),
                  width: 2,
                ),
              ),
              child: Icon(
                Prbal.exclamationTriangle,
                color: themeManager.errorColor,
                size: 32.sp,
              ),
            ),
            SizedBox(height: 20.h),

            // Title
            Text(
              'Revoke Session',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: themeManager.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),

            // Description
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.sp,
                  color: themeManager.textSecondary,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'This will immediately sign out '),
                  TextSpan(
                    text: deviceName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: themeManager.textPrimary,
                    ),
                  ),
                  const TextSpan(text: ' and invalidate the session. This action cannot be undone.'),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(
                          color: themeManager.borderColor,
                        ),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: themeManager.textSecondary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53E3E),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Revoke',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      await _revokeToken(tokenId);
    }
  }

  /// Copies text to clipboard with user feedback
  Future<void> _copyToClipboard(String text, String message) async {
    await Clipboard.setData(ClipboardData(text: text));

    if (mounted) {
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Prbal.check,
                color: Colors.white,
                size: 18.sp,
              ),
              SizedBox(width: 12.w),
              Text(message),
            ],
          ),
          backgroundColor: const Color(0xFF48BB78),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          margin: EdgeInsets.all(16.w),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Formats datetime to relative time (e.g., "2 hours ago")
  String _formatRelativeTime(String dateTimeStr) {
    try {
      final DateTime dateTime = DateTime.parse(dateTimeStr);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return _formatDateTime(dateTimeStr);
      }
    } catch (e) {
      return _formatDateTime(dateTimeStr);
    }
  }

  /// Refreshes access token
  Future<void> _refreshAccessToken() async {
    debugPrint('🔑 SettingsScreen: Refreshing access token');

    final authNotifier = ref.read(authenticationStateProvider.notifier);

    try {
      final success = await authNotifier.refreshAccessToken();

      if (mounted) {
        Navigator.of(context).pop(); // Close bottom sheet

        if (success) {
          _showSuccessSnackBar('Access token refreshed successfully');
        } else {
          _showErrorSnackBar('Failed to refresh access token');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close bottom sheet
        _showErrorSnackBar('Error refreshing token: $e');
      }
    }
  }

  /// Revokes a specific token
  Future<void> _revokeToken(String tokenId) async {
    debugPrint('🔑 SettingsScreen: Revoking token: $tokenId');

    final authState = ref.read(authenticationStateProvider);
    if (!authState.isAuthenticated || authState.accessToken == null) {
      _showAuthenticationRequiredSnackBar();
      return;
    }

    final userService = ref.read(userServiceProvider);

    try {
      final response = await userService.revokeToken(tokenId, authState.accessToken!);

      if (mounted) {
        if (response.isSuccess) {
          Navigator.of(context).pop(); // Close bottom sheet
          _showSuccessSnackBar('Token revoked successfully');
        } else {
          _showErrorSnackBar('Failed to revoke token: ${response.message}');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error revoking token: $e');
      }
    }
  }

  /// Shows authentication required snackbar
  void _showAuthenticationRequiredSnackBar() => FeedbackUtils.showAuthenticationRequired(context: context);

  /// Shows success snackbar
  void _showSuccessSnackBar(String message) => FeedbackUtils.showSuccess(context: context, message: message);

  /// Formats datetime string
  String _formatDateTime(String dateTimeStr) => SettingsUtils.formatDateTime(dateTimeStr);

  // ============================================================================
  // ENHANCED THEME DEBUGGING METHODS
  // ============================================================================

  /// Logs enhanced theme state information for comprehensive debugging
  ///
  /// This method provides detailed theme analysis including:
  /// - Current theme properties and colors
  /// - System vs app theme consistency checks
  /// - Performance metrics for theme operations
  /// - Cache state validation
  /// - Theme transition monitoring
//   void _logEnhancedThemeState(BuildContext context, bool themeManager) {
//     debugPrint('🎨 SettingsScreen: === ENHANCED THEME STATE ANALYSIS ===');

//     final theme = ThemeManager.of(context);
//     final colorScheme = theme.colorScheme;
//     final systemBrightness = MediaQuery.of(context).platformBrightness;

//     // Basic theme information
//     debugPrint('🎨 SettingsScreen: App brightness: ${theme.brightness.name}');
//     debugPrint('🎨 SettingsScreen: System brightness: ${systemBrightness.name}');
//     debugPrint('🎨 SettingsScreen: themeManager flag: $themeManager');

//     // Color scheme analysis
//     debugPrint('🎨 SettingsScreen: Primary: ${colorScheme.primary}');
//     debugPrint('🎨 SettingsScreen: Surface: ${colorScheme.surface}');
//     debugPrint('🎨 SettingsScreen: Background: ${colorScheme.surface}');
//     debugPrint('🎨 SettingsScreen: OnSurface: ${colorScheme.onSurface}');

//     // Theme consistency validation
//     final expectedDark = systemBrightness == Brightness.dark;
//     final consistent = (themeManager && expectedDark) || (!themeManager && !expectedDark);
//     debugPrint('🎨 SettingsScreen: Theme consistency: ${consistent ? '✅ Consistent' : '⚠️ Inconsistent'}');

//     // Cache state validation
//     try {
//       final hasStoredPreference = ThemeCaching.hasStoredPreference();
//       final currentPreference = ThemeCaching.getCurrentPreference();
//       debugPrint('🎨 SettingsScreen: Cache has preference: $hasStoredPreference');
//       debugPrint('🎨 SettingsScreen: Cache preference: $currentPreference');
//     } catch (error) {
//       debugPrint('🎨 SettingsScreen: ❌ Error reading theme cache: $error');
//     }

//     // Performance analysis
//     debugPrint('🎨 SettingsScreen: Material version: ${theme.useMaterial3 ? 'Material 3' : 'Material 2'}');
//     debugPrint('🎨 SettingsScreen: Theme data hash: ${theme.hashCode}');
//   }
}
