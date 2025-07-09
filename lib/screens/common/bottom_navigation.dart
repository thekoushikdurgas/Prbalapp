import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart' show HapticFeedback;

// Import theme and icon systems
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/icon/icon_constants.dart';

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
import 'package:prbal/services/user_service.dart';

/// BottomNavigation - Dynamic navigation widget with comprehensive ThemeManager integration
///
/// **Enhanced Features:**
/// - **Full ThemeManager Integration**: Uses centralized theme management with automatic light/dark adaptation
/// - **Custom Prbal Icons**: Premium brand-consistent navigation using 3900+ custom Prbal icons
/// - **Advanced Visual Design**: Multi-layer gradients, glass morphism effects, and professional shadows
/// - **User Type Adaptation**: Dynamic navigation based on Provider/Admin/Customer roles
/// - **Performance Optimized**: Prevents memory leaks with content-only screen versions
/// - **Enhanced UX**: Smooth animations, haptic feedback, and interactive visual states
///
/// **ThemeManager Properties Used:**
/// - Background: `surfaceGradient`, `cardBackground`, `surfaceElevated`
/// - Colors: `primaryColor`, `accent1-5`, `textPrimary/Secondary`, `borderColor`
/// - Shadows: `elevatedShadow`, `primaryShadow`, `glassMorphism`
/// - Gradients: `primaryGradient`, `backgroundGradient`, `accent1Gradient`
///
/// **User Types & Enhanced Navigation:**
///
/// **Provider (Service Provider):**
/// - Dashboard: Manage services and bookings (Prbal.home8)
/// - Explore: Find new opportunities (Prbal.explore2)
/// - Orders: Track service requests (Prbal.briefcase2)
/// - Settings: Account management (Prbal.cogOutline)
/// - Theme: Success color scheme with green accents
///
/// **Admin (Administrator):**
/// - Analytics: System metrics and reports (Prbal.dashboard)
/// - Users: Manage user accounts (Prbal.users)
/// - Tools: Content and system management (Prbal.tools)
/// - Settings: System configuration (Prbal.cogOutline)
/// - Theme: Primary color scheme with violet accents
///
/// **Customer (Default):**
/// - Home: Browse available services (Prbal.home8)
/// - Explore: Discover new services (Prbal.explore2)
/// - Bookings: Track your bookings (Prbal.calender)
/// - Profile: Account settings (Prbal.person)
/// - Theme: Info color scheme with blue accents
///
/// **Memory Management:**
/// - Uses content-only versions within BottomNavigation to prevent circular dependency
/// - Full versions only for direct route access
/// - Prevents ListTile widgets from creating excessive AnimationController instances
/// - Includes initialization flag to prevent building before user type is loaded
///
/// **Usage:**
/// ```dart
/// BottomNavigation(
///   initialIndex: 0, // Optional: Starting tab index
///   extra: {'initialTabIndex': 1}, // Optional: Extra data for screens
/// )
/// ```
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

class _BottomNavigationState extends ConsumerState<BottomNavigation> with TickerProviderStateMixin {
  late int currentIndex;
  late UserType _userType; // User type loaded from Hive storage
  bool _isInitialized = false; // Prevents building before user type is loaded

  // Animation controllers for enhanced visual feedback
  late AnimationController _tapAnimationController;
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint('🧭 BottomNavigation: Initializing enhanced bottom navigation component');

    // Initialize animation controllers
    _tapAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Setup animations
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _tapAnimationController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Start glow animation
    _glowController.repeat(reverse: true);

    // Set initial tab index
    currentIndex = widget.initialIndex;
    debugPrint('🧭 BottomNavigation: Initial tab index set to: $currentIndex');

    // Initialize user type once without setState to prevent rebuild loop
    _userType = HiveService.getUserType();
    debugPrint('🧭 BottomNavigation: Loaded user type from Hive: $_userType');
    debugPrint('🧭 BottomNavigation: User type display name: ${HiveService.getUserTypeDisplayName()}');
    debugPrint('🧭 BottomNavigation: User type color: #${HiveService.getUserTypeColor().toRadixString(16)}');

    // Mark as initialized to allow building
    _isInitialized = true;
    debugPrint('🧭 BottomNavigation: Enhanced initialization complete with ThemeManager support');
  }

  @override
  void dispose() {
    _tapAnimationController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🧭 BottomNavigation: Building enhanced navigation UI with ThemeManager');

    // Don't build until initialized to prevent memory leaks
    if (!_isInitialized) {
      debugPrint('🧭 BottomNavigation: Not yet initialized, showing empty widget');
      return const SizedBox.shrink();
    }

    // Get ThemeManager instance for centralized theme management

    ThemeManager.of(context).logThemeInfo();

    // Get screen size for responsive design
    Size size = MediaQuery.of(context).size;
    debugPrint('🧭 BottomNavigation: Screen size: ${size.width}x${size.height}');
    debugPrint('🧭 BottomNavigation: Theme mode: ${ThemeManager.of(context).themeManager ? 'dark' : 'light'}');

    // Get user type specific colors using ThemeManager
    final userTypeColor = _getUserTypeThemeColor(_userType);
    debugPrint('🧭 BottomNavigation: User type color from ThemeManager: $userTypeColor');

    // Get initial tab index for orders screen if provided
    final initialTabIndex = widget.extra?['initialTabIndex'] as int? ?? 0;
    debugPrint('🧭 BottomNavigation: Orders screen initial tab index: $initialTabIndex');

    // Define screens and navigation items based on user type from Hive
    final List<Widget> screens = _getScreensForUserType(_userType, initialTabIndex);
    final List<NavigationItem> navigationItems = _getNavigationItemsForUserType(_userType);

    debugPrint('🧭 BottomNavigation: Generated ${screens.length} screens for user type: $_userType');
    debugPrint('🧭 BottomNavigation: Generated ${navigationItems.length} navigation items with ThemeManager styling');

    return Scaffold(
      // backgroundColor: ThemeManager.of(context).transparent.withValues(alpha: 0.0),
      // Use IndexedStack to maintain state across tab switches
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(20.r),
        height: size.width * .175,
        decoration: BoxDecoration(
          // color: ThemeManager.of(context).transparent.withValues(alpha: 0.0),
          // Enhanced gradient background using ThemeManager
          gradient: ThemeManager.of(context).conditionalGradient(
            lightGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ThemeManager.of(context).surfaceElevated,
                ThemeManager.of(context).cardBackground,
              ],
            ),
            darkGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ThemeManager.of(context).surfaceElevated,
                ThemeManager.of(context).modalBackground,
              ],
            ),
          ),
          // Premium glass morphism border
          border: Border.all(
            color: ThemeManager.of(context).borderColor.withValues(alpha: 0.2),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(50.r),
          boxShadow: [
            // Primary shadow using ThemeManager
            ...ThemeManager.of(context).elevatedShadow,
            // Additional glow effect for current user type
            BoxShadow(
              color: userTypeColor.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 5),
              spreadRadius: 2,
            ),
          ],
        ),
        child: ListView.builder(
          itemCount: navigationItems.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: size.width * .024),
          itemBuilder: (context, index) => _buildNavigationItem(
            context,
            navigationItems[index],
            index,
            size,
            userTypeColor,
          ),
        ),
      ),
    );
  }

  /// Build enhanced navigation item with ThemeManager styling and animations
  Widget _buildNavigationItem(
    BuildContext context,
    NavigationItem item,
    int index,
    Size size,
    Color userTypeColor,
  ) {
    final isActive = index == currentIndex;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isActive ? _scaleAnimation.value : 1.0,
          child: InkWell(
            onTap: () => _handleTabTap(index),
            onTapDown: (_) => _tapAnimationController.forward(),
            onTapUp: (_) => _tapAnimationController.reverse(),
            onTapCancel: () => _tapAnimationController.reverse(),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            borderRadius: BorderRadius.circular(25.r),
            child: SizedBox(
              width: size.width * .2,
              // padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                mainAxisAlignment: isActive ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
                children: [
                  // Enhanced animated indicator for active tab
                  _buildActiveIndicator(isActive, size, userTypeColor),

                  // Enhanced navigation icon with glow effect
                  _buildNavigationIcon(item, isActive, size, userTypeColor),

                  // Bottom spacing
                  SizedBox(height: size.width * .01),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build enhanced active tab indicator with gradient and animation
  Widget _buildActiveIndicator(
    bool isActive,
    Size size,
    Color userTypeColor,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1500),
      curve: Curves.fastLinearToSlowEaseIn,
      width: size.width * .128,
      height: isActive ? size.width * .014 : 0,
      decoration: BoxDecoration(
        // Enhanced gradient indicator using ThemeManager
        gradient: isActive
            ? LinearGradient(
                colors: [
                  userTypeColor,
                  userTypeColor.withValues(alpha: 0.7),
                ],
              )
            : null,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
        // boxShadow: isActive
        //     ? [
        //         BoxShadow(
        //           color: userTypeColor.withValues(alpha: 0.4),
        //           blurRadius: 8,
        //           offset: const Offset(0, 2),
        //         ),
        //       ]
        //     : null,
      ),
    );
  }

  /// Build enhanced navigation icon with glow and color animations
  Widget _buildNavigationIcon(
    NavigationItem item,
    bool isActive,
    Size size,
    Color userTypeColor,
  ) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(isActive ? 8.w : 4.w),
          decoration: isActive
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      userTypeColor.withValues(alpha: 0.1 * _glowAnimation.value),
                      Colors.transparent,
                    ],
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: userTypeColor.withValues(alpha: 0.2 * _glowAnimation.value),
                  //     blurRadius: 12,
                  //     spreadRadius: 2,
                  //   ),
                  // ],
                )
              : null,
          child: Icon(
            item.icon,
            size: isActive ? size.width * .08 : size.width * .085,
            color: isActive ? userTypeColor : ThemeManager.of(context).textSecondary,
          ),
        );
      },
    );
  }

  /// Handle tab tap with enhanced feedback and animation
  void _handleTabTap(int index) {
    debugPrint('🧭 BottomNavigation: Tab $index tapped');

    if (currentIndex != index) {
      debugPrint('🧭 BottomNavigation: Switching from tab $currentIndex to tab $index');

      setState(() {
        currentIndex = index;
      });

      // Enhanced haptic feedback for better UX
      HapticFeedback.lightImpact();

      debugPrint('🧭 BottomNavigation: Tab switch complete with enhanced haptic feedback');
    } else {
      debugPrint('🧭 BottomNavigation: Same tab tapped, no action needed');

      // Light feedback for same tab tap
      HapticFeedback.selectionClick();
    }
  }

  /// Get user type specific theme color using ThemeManager
  Color _getUserTypeThemeColor(UserType userType) {
    switch (userType) {
      case UserType.provider:
        return ThemeManager.of(context).successColor; // Green for providers
      case UserType.admin:
        return ThemeManager.of(context).primaryColor; // Primary violet for admins
      case UserType.customer:
        return ThemeManager.of(context).infoColor; // Blue for customers
    }
  }

  /// Get screens based on user type from Hive data
  /// **IMPORTANT**: These screens should NOT contain BottomNavigation widgets
  /// to prevent circular dependency and memory leaks
  List<Widget> _getScreensForUserType(UserType userType, int initialTabIndex) {
    switch (userType) {
      case UserType.provider:
        return [
          const ProviderDashboardContent(), // Use content-only version
          const ProviderExploreScreen(),
          ProviderOrdersScreen(initialTabIndex: initialTabIndex),
          const SettingsScreen(),
        ];
      case UserType.admin:
        return [
          const AdminDashboardContent(), // Use content-only version
          const AdminUsersScreen(),
          const AdminToolManagerScreen(), // Admin tool manager screen for CRUD operations
          const SettingsScreen(),
        ];
      case UserType.customer:
        return [
          const TakerDashboardContent(), // Use content-only version
          const TakerExploreScreen(),
          const TakerOrdersScreen(),
          const SettingsScreen(),
        ];
    }
  }

  /// Get enhanced navigation items with Prbal icons and ThemeManager integration
  List<NavigationItem> _getNavigationItemsForUserType(
    UserType userType,
  ) {
    final iconManager = PrbalIconManager();

    switch (userType) {
      case UserType.provider:
        iconManager.debugLogIconUsage('provider_navigation_icons');
        return [
          NavigationItem(icon: Prbal.home8, label: 'Dashboard'),
          NavigationItem(icon: Prbal.explore2, label: 'Explore'),
          NavigationItem(icon: Prbal.briefcase2, label: 'Orders'),
          NavigationItem(icon: Prbal.cogOutline, label: 'Settings'),
        ];
      case UserType.admin:
        iconManager.debugLogIconUsage('admin_navigation_icons');
        return [
          NavigationItem(icon: Prbal.dashboard, label: 'Analytics'),
          NavigationItem(icon: Prbal.users, label: 'Users'),
          NavigationItem(icon: Prbal.tools, label: 'Tools'),
          NavigationItem(icon: Prbal.cogOutline, label: 'Settings'),
        ];
      case UserType.customer:
        iconManager.debugLogIconUsage('customer_navigation_icons');
        return [
          NavigationItem(icon: Prbal.home8, label: 'Home'),
          NavigationItem(icon: Prbal.explore2, label: 'Explore'),
          NavigationItem(icon: Prbal.calender, label: 'Bookings'),
          NavigationItem(icon: Prbal.person, label: 'Profile'),
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
        debugPrint('🧭 BottomNavigation: Refreshed user type to: $_userType with ThemeManager integration');
      }
    }
  }

  /// Static method to update user type in Hive and refresh navigation
  /// Useful for testing or when user role changes
  @pragma('vm:entry-point')
  static Future<void> switchUserType(UserType newUserType, BuildContext context) async {
    try {
      await HiveService.updateUserType(newUserType);

      // If there's a BottomNavigation in the widget tree, refresh it
      if (context.mounted) {
        final bottomNav = context.findAncestorStateOfType<_BottomNavigationState>();
        bottomNav?.refreshUserType();

        debugPrint('🧭 BottomNavigation: Switched to user type: $newUserType with enhanced ThemeManager support');
      }
    } catch (e) {
      debugPrint('🧭 BottomNavigation: Failed to switch user type: $e');
    }
  }
}

/// Navigation item data class for enhanced organization
class NavigationItem {
  final IconData icon;
  final String label;

  const NavigationItem({
    required this.icon,
    required this.label,
  });
}
