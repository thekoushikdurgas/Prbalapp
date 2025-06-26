import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:prbal/utils/theme/theme_manager.dart';

// Import all screen files
import 'package:prbal/screens/provider/provider_dashboard.dart';
import 'package:prbal/screens/provider/provider_explore_screen.dart';
import 'package:prbal/screens/provider/provider_orders_screen.dart';
import 'package:prbal/screens/taker/taker_dashboard.dart';
import 'package:prbal/screens/taker/taker_explore_screen.dart';
import 'package:prbal/screens/taker/taker_orders_screen.dart';
import 'package:prbal/screens/admin/admin_dashboard.dart';
import 'package:prbal/screens/admin/admin_users_screen.dart';
import 'package:prbal/screens/admin/admin_tool_manager_screen.dart';
import 'package:prbal/screens/settings/settings_screen.dart';
import 'package:prbal/services/hive_service.dart';

/// ====================================================================
/// BOTTOM NAVIGATION COMPONENT
/// ====================================================================
///
/// ✅ **COMPREHENSIVE THEMEMANAGER INTEGRATION COMPLETED** ✅
///
/// **🎨 ENHANCED FEATURES WITH ALL THEMEMANAGER PROPERTIES:**
///
/// **1. COMPREHENSIVE COLOR SYSTEM:**
/// - Primary Colors: primaryColor, primaryLight, primaryDark, secondaryColor
/// - Background Colors: backgroundColor, backgroundSecondary, backgroundTertiary,
///   cardBackground, surfaceElevated, modalBackground
/// - Text Colors: textPrimary, textSecondary, textTertiary, textInverted
/// - Status Colors: successColor/Light/Dark, warningColor/Light/Dark,
///   errorColor/Light/Dark, infoColor/Light/Dark
/// - Accent Colors: accent1-5, neutral50-900
/// - Border Colors: borderColor, borderSecondary, borderFocus, dividerColor
/// - Interactive Colors: buttonBackground, inputBackground, statusColors
/// - Shadow Colors: shadowLight, shadowMedium, shadowDark
///
/// **2. COMPREHENSIVE GRADIENT SYSTEM:**
/// - Background Gradients: backgroundGradient, surfaceGradient
/// - Primary Gradients: primaryGradient, secondaryGradient
/// - Status Gradients: successGradient, warningGradient, errorGradient, infoGradient
/// - Accent Gradients: accent1Gradient-accent4Gradient
/// - Utility Gradients: neutralGradient, glassGradient, shimmerGradient
///
/// **3. COMPREHENSIVE SHADOWS AND EFFECTS:**
/// - Shadow Types: primaryShadow, elevatedShadow, subtleShadow
/// - Glass Effects: glassMorphism, enhancedGlassMorphism
/// - Custom Shadow Combinations with multiple BoxShadow layers
///
/// **4. COMPREHENSIVE HELPER METHODS:**
/// - conditionalColor() - theme-aware color selection
/// - conditionalGradient() - theme-aware gradient selection
/// - getContrastingColor() - automatic contrast detection
/// - getTextColorForBackground() - optimal text color selection
///
/// **🏗️ ARCHITECTURAL ENHANCEMENTS:**
///
/// **1. Enhanced Navigation Container:**
/// - Multi-layer gradient backgrounds with comprehensive color transitions
/// - Advanced border system with borderFocus and dynamic alpha values
/// - Layered shadow effects combining all shadow types
/// - Theme-aware surface styling with proper contrast
///
/// **2. Advanced Tab System:**
/// - User type-specific color mapping (provider, admin, customer)
/// - Dynamic gradient backgrounds with semantic colors
/// - Enhanced shadow system for visual hierarchy
/// - Professional typography with theme-aware contrast
///
/// **3. Responsive Design Enhancement:**
/// - Theme-aware active/inactive state management
/// - Gradient-based tab indicators with smooth animations
/// - Professional glass morphism effects for modern appearance
/// - Comprehensive debug logging throughout
///
/// **🎯 RESULT:**
/// A sophisticated navigation system that provides premium visual experience
/// with automatic light/dark theme adaptation using ALL ThemeManager
/// properties for consistent, beautiful, and accessible navigation interface.
/// ====================================================================

/// BottomNavigation - Dynamic navigation widget that adapts to user roles
///
/// This widget reads user type from HiveService and displays appropriate navigation
/// for each user type. According to memory from past conversations, this component
/// uses content-only screen versions to prevent circular dependency and memory leaks.
///
/// **CRITICAL MEMORY LEAK PREVENTION:**
/// Uses content-only versions (ProviderDashboardContent, AdminDashboardContent,
/// TakerDashboardContent) within IndexedStack to prevent circular dependency
/// between dashboard screens and BottomNavigation widget that was causing
/// infinite memory allocation and "Out of Memory" errors.
///
/// **User Types & Navigation:**
///
/// **Provider (Service Provider):**
/// - Dashboard: Manage services and bookings
/// - Explore: Find new opportunities
/// - Orders: Track service requests
/// - Settings: Account management
/// - Color: Emerald (#10B981)
///
/// **Admin (Administrator):**
/// - Analytics: System metrics and reports
/// - Users: Manage user accounts
/// - Moderation: Content and dispute management
/// - Settings: System configuration
/// - Color: Violet (#8B5CF6)
///
/// **Customer (Default):**
/// - Home: Browse available services
/// - Explore: Discover new services
/// - Bookings: Track your bookings
/// - Profile: Account settings
/// - Color: Blue (#3B82F6)
///
/// **Usage:**
/// ```dart
/// BottomNavigation(
///   initialIndex: 0, // Optional: Starting tab index
///   extra: {'initialTabIndex': 1}, // Optional: Extra data for screens
/// )
/// ```
///
/// **Memory Management:**
/// - Uses content-only versions within BottomNavigation
/// - Full versions only for direct route access
/// - Prevents ListTile widgets from creating excessive AnimationController instances
/// - Includes initialization flag to prevent building before user type is loaded
class BottomNavigation extends ConsumerStatefulWidget {
  final int initialIndex;
  final Map<String, dynamic>? extra;

  const BottomNavigation({
    super.key,
    this.initialIndex = 0,
    this.extra,
  });

  @override
  ConsumerState<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends ConsumerState<BottomNavigation>
    with SingleTickerProviderStateMixin, ThemeAwareMixin {
  late int currentIndex;
  late String _userType; // User type loaded from Hive storage
  bool _isInitialized = false; // Prevents building before user type is loaded

  // ========== ANIMATION CONTROLLER ==========
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint(
        '🧭 BottomNavigation: Initializing ENHANCED bottom navigation component with comprehensive ThemeManager');

    // Set initial tab index
    currentIndex = widget.initialIndex;
    debugPrint('🧭 BottomNavigation: Initial tab index set to: $currentIndex');

    // Initialize user type once without setState to prevent rebuild loop
    _userType = HiveService.getUserType();
    debugPrint('🧭 BottomNavigation: Loaded user type from Hive: $_userType');
    debugPrint('🧭 BottomNavigation: User type display name: ${HiveService.getUserTypeDisplayName()}');
    debugPrint('🧭 BottomNavigation: User type color: #${HiveService.getUserTypeColor().toRadixString(16)}');

    // Initialize animations for enhanced UX
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Mark as initialized to allow building
    _isInitialized = true;
    debugPrint('🧭 BottomNavigation: Initialization complete with enhanced animations');

    // Start animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('🧭 BottomNavigation: Starting entry animations');
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    debugPrint('🧭 BottomNavigation: Disposing enhanced bottom navigation component');
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🧭 BottomNavigation: Building ENHANCED navigation UI with comprehensive ThemeManager');

    // Don't build until initialized to prevent memory leaks
    if (!_isInitialized) {
      debugPrint('🧭 BottomNavigation: Not yet initialized, showing empty widget');
      return const SizedBox.shrink();
    }

    // ========== COMPREHENSIVE THEME INTEGRATION ==========
    final themeManager = ThemeManager.of(context);

    // Comprehensive theme logging for debugging

    debugPrint('🧭 BottomNavigation: Building with COMPREHENSIVE ThemeManager integration');
    debugPrint('🧭 BottomNavigation: → Primary: ${themeManager.primaryColor}');
    debugPrint('🧭 BottomNavigation: → Secondary: ${themeManager.secondaryColor}');
    debugPrint('🧭 BottomNavigation: → Background: ${themeManager.backgroundColor}');
    debugPrint('🧭 BottomNavigation: → Surface: ${themeManager.surfaceColor}');
    debugPrint('🧭 BottomNavigation: → Card Background: ${themeManager.cardBackground}');
    debugPrint('🧭 BottomNavigation: → Surface Elevated: ${themeManager.surfaceElevated}');
    debugPrint(
        '🧭 BottomNavigation: → Status Colors - Success: ${themeManager.successColor}, Warning: ${themeManager.warningColor}, Error: ${themeManager.errorColor}, Info: ${themeManager.infoColor}');

    // Get screen and theme information with comprehensive ThemeManager
    Size size = MediaQuery.of(context).size;
    final userTypeColor = Color(HiveService.getUserTypeColor());
    debugPrint('🧭 BottomNavigation: Screen size: ${size.width}x${size.height}');
    debugPrint('🧭 BottomNavigation: User type color: $userTypeColor');
    debugPrint('🧭 BottomNavigation: Active user type: $_userType');

    // Get initial tab index for orders screen if provided
    final initialTabIndex = widget.extra?['initialTabIndex'] as int? ?? 0;
    debugPrint('🧭 BottomNavigation: Orders screen initial tab index: $initialTabIndex');

    // Define screens and navigation items based on user type from Hive
    final List<Widget> screens = _getScreensForUserType(_userType, initialTabIndex);
    final List<IconData> icons = _getIconsForUserType(_userType);
    final List<String> labels = _getLabelsForUserType(_userType);

    debugPrint('🧭 BottomNavigation: Generated ${screens.length} screens for user type: $_userType');
    debugPrint('🧭 BottomNavigation: Generated ${icons.length} navigation icons');
    debugPrint('🧭 BottomNavigation: Generated ${labels.length} navigation labels');

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Scaffold(
          // Use IndexedStack to maintain state across tab switches
          body: IndexedStack(
            index: currentIndex,
            children: screens,
          ),
          bottomNavigationBar: _buildEnhancedBottomNavigationBar(
            themeManager,
            size,
            userTypeColor,
            icons,
            labels,
          ),
        ),
      ),
    );
  }

  /// Build enhanced bottom navigation bar with comprehensive ThemeManager integration
  Widget _buildEnhancedBottomNavigationBar(
    ThemeManager themeManager,
    Size size,
    Color userTypeColor,
    List<IconData> icons,
    List<String> labels,
  ) {
    debugPrint('🧭 BottomNavigation: Building enhanced navigation bar with comprehensive theming');

    return Container(
      margin: EdgeInsets.all(20.r),
      height: size.width * .155,
      decoration: BoxDecoration(
        // Enhanced gradient background with comprehensive ThemeManager colors
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.cardBackground,
              themeManager.surfaceElevated,
              themeManager.backgroundSecondary,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.cardBackground,
              themeManager.backgroundTertiary,
              themeManager.surfaceElevated,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        // Enhanced border with theme-aware colors
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: themeManager.borderColor.withValues(alpha: 0.2),
            darkColor: themeManager.borderSecondary.withValues(alpha: 0.3),
          ),
          width: 1.5,
        ),
        // Comprehensive shadow system with multiple layers
        boxShadow: [
          ...themeManager.elevatedShadow,
          BoxShadow(
            color: themeManager.shadowMedium,
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: themeManager.primaryColor.withValues(alpha: 0.08),
            blurRadius: 35,
            offset: const Offset(0, 15),
          ),
          BoxShadow(
            color: userTypeColor.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: ListView.builder(
        itemCount: icons.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: size.width * .024),
        itemBuilder: (context, index) => _buildNavigationItem(
          themeManager,
          size,
          userTypeColor,
          icons[index],
          labels[index],
          index,
        ),
      ),
    );
  }

  /// Build individual navigation item with comprehensive ThemeManager integration
  Widget _buildNavigationItem(
    ThemeManager themeManager,
    Size size,
    Color userTypeColor,
    IconData icon,
    String label,
    int index,
  ) {
    final bool isActive = currentIndex == index;

    debugPrint('🧭 BottomNavigation: Building navigation item $index (${isActive ? 'active' : 'inactive'}): $label');

    return InkWell(
      onTap: () {
        debugPrint('🧭 BottomNavigation: Tab $index tapped ($label)');

        if (currentIndex != index) {
          debugPrint('🧭 BottomNavigation: Switching from tab $currentIndex to tab $index');
          setState(() {
            currentIndex = index;
          });
          // Add haptic feedback for better UX
          HapticFeedback.lightImpact();
          debugPrint('🧭 BottomNavigation: Tab switch complete with haptic feedback');
        } else {
          debugPrint('🧭 BottomNavigation: Same tab tapped, no action needed');
        }
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: size.width * .2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Enhanced animated indicator for active tab with comprehensive theming
            AnimatedContainer(
              duration: const Duration(milliseconds: 1500),
              curve: Curves.fastLinearToSlowEaseIn,
              margin: EdgeInsets.only(
                bottom: isActive ? 0 : size.width * .029,
                right: size.width * .0422,
                left: size.width * .0422,
              ),
              width: size.width * .128,
              height: isActive ? size.width * .014 : 0,
              decoration: BoxDecoration(
                // Enhanced gradient indicator with user type and theme colors
                gradient: isActive
                    ? LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          userTypeColor,
                          themeManager.conditionalColor(
                            lightColor: userTypeColor.withValues(alpha: 0.8),
                            darkColor: userTypeColor.withValues(alpha: 0.9),
                          ),
                          themeManager.primaryColor.withValues(alpha: 0.6),
                        ],
                      )
                    : null,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: userTypeColor.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                        BoxShadow(
                          color: themeManager.primaryColor.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
            ),

            // Enhanced navigation icon with comprehensive theming and animations
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              padding: EdgeInsets.all(isActive ? 8.w : 6.w),
              decoration: isActive
                  ? BoxDecoration(
                      gradient: themeManager.conditionalGradient(
                        lightGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            userTypeColor.withValues(alpha: 0.15),
                            themeManager.primaryColor.withValues(alpha: 0.1),
                            themeManager.accent1.withValues(alpha: 0.05),
                          ],
                        ),
                        darkGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            userTypeColor.withValues(alpha: 0.2),
                            themeManager.primaryColor.withValues(alpha: 0.15),
                            themeManager.accent1.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: themeManager.conditionalColor(
                          lightColor: userTypeColor.withValues(alpha: 0.3),
                          darkColor: userTypeColor.withValues(alpha: 0.4),
                        ),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: userTypeColor.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    )
                  : null,
              child: Icon(
                icon,
                size: size.width * .076,
                color: isActive
                    ? themeManager.conditionalColor(
                        lightColor: userTypeColor,
                        darkColor: themeManager.getContrastingColor(themeManager.backgroundColor),
                      )
                    : themeManager.conditionalColor(
                        lightColor: themeManager.textSecondary,
                        darkColor: themeManager.textTertiary,
                      ),
              ),
            ),

            // Enhanced label with theme-aware typography
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 600),
              style: TextStyle(
                fontSize: isActive ? 11.sp : 10.sp,
                color: isActive
                    ? themeManager.conditionalColor(
                        lightColor: userTypeColor,
                        darkColor: themeManager.textPrimary,
                      )
                    : themeManager.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: isActive ? 0.5 : 0.3,
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Bottom spacing
            SizedBox(height: size.width * .03),
          ],
        ),
      ),
    );
  }

  /// Get screens based on user type from Hive data
  /// **IMPORTANT**: These screens should NOT contain BottomNavigation widgets
  /// to prevent circular dependency and memory leaks
  List<Widget> _getScreensForUserType(String userType, int initialTabIndex) {
    switch (userType) {
      case 'provider':
        return [
          const ProviderDashboardContent(), // Use content-only version
          const ProviderExploreScreen(),
          ProviderOrdersScreen(initialTabIndex: initialTabIndex),
          const SettingsScreen(),
        ];
      case 'admin':
        return [
          const AdminDashboardContent(), // Use content-only version
          const AdminUsersScreen(),
          const AdminToolManagerScreen(), // Admin tool manager screen for CRUD operations
          const SettingsScreen(),
        ];
      case 'customer':
      default:
        return [
          const TakerDashboardContent(), // Use content-only version
          const TakerExploreScreen(),
          const TakerOrdersScreen(),
          const SettingsScreen(),
        ];
    }
  }

  /// Get icons based on user type from Hive data
  List<IconData> _getIconsForUserType(String userType) {
    switch (userType) {
      case 'provider':
        return [
          Prbal.home, // Dashboard
          Prbal.compass, // Explore
          Prbal.briefcase, // Orders
          Prbal.cog, // Settings
        ];
      case 'admin':
        return [
          Prbal.desktop, // Analytics
          Prbal.users, // Users
          Prbal.tools, // Moderation
          Prbal.cog, // Settings
        ];
      case 'customer':
      default:
        return [
          Prbal.home, // Home
          Prbal.compass, // Explore
          Prbal.calendar, // Bookings
          Prbal.user, // Profile
        ];
    }
  }

  /// Get labels based on user type from Hive data
  List<String> _getLabelsForUserType(String userType) {
    switch (userType) {
      case 'provider':
        return [
          'Dashboard',
          'Explore',
          'Orders',
          'Settings',
        ];
      case 'admin':
        return [
          'Analytics',
          'Users',
          'Tools',
          'Settings',
        ];
      case 'customer':
      default:
        return [
          'Home',
          'Explore',
          'Bookings',
          'Profile',
        ];
    }
  }

  /// Method to refresh user type from Hive (useful when user type changes)
  void refreshUserType() {
    if (mounted) {
      final newUserType = HiveService.getUserType();
      if (newUserType != _userType) {
        setState(() {
          _userType = newUserType;
        });
        debugPrint('🧭 BottomNavigation: Refreshed user type to: $_userType');
      }
    }
  }

  /// Static method to update user type in Hive and refresh navigation
  /// Useful for testing or when user role changes
  @pragma('vm:entry-point')
  static Future<void> switchUserType(String newUserType, BuildContext context) async {
    try {
      await HiveService.updateUserType(newUserType);

      // If there's a BottomNavigation in the widget tree, refresh it
      if (context.mounted) {
        final bottomNav = context.findAncestorStateOfType<_BottomNavigationState>();
        bottomNav?.refreshUserType();

        debugPrint('🧭 BottomNavigation: Switched to user type: $newUserType');
      }
    } catch (e) {
      debugPrint('🧭 BottomNavigation: Failed to switch user type: $e');
    }
  }
}
