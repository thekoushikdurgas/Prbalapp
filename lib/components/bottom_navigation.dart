import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter/services.dart' show HapticFeedback;

// Import all screen files
import 'package:prbal/screens/provider/provider_dashboard.dart';
import 'package:prbal/screens/provider/provider_explore_screen.dart';
import 'package:prbal/screens/provider/provider_orders_screen.dart';
import 'package:prbal/screens/taker/taker_dashboard.dart';
import 'package:prbal/screens/taker/taker_explore_screen.dart';
import 'package:prbal/screens/taker/taker_orders_screen.dart';
import 'package:prbal/screens/admin/admin_dashboard.dart';
import 'package:prbal/screens/admin/admin_users_screen.dart';
import 'package:prbal/screens/settings/settings_screen.dart';
import 'package:prbal/services/hive_service.dart';

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

class _BottomNavigationState extends ConsumerState<BottomNavigation> {
  late int currentIndex;
  late String _userType; // User type loaded from Hive storage
  bool _isInitialized = false; // Prevents building before user type is loaded

  @override
  void initState() {
    super.initState();
    debugPrint('🧭 BottomNavigation: Initializing bottom navigation component');

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
    debugPrint('🧭 BottomNavigation: Initialization complete');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🧭 BottomNavigation: Building navigation UI');

    // Don't build until initialized to prevent memory leaks
    if (!_isInitialized) {
      debugPrint('🧭 BottomNavigation: Not yet initialized, showing empty widget');
      return const SizedBox.shrink();
    }

    // Get screen and theme information
    Size size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Color(0xFF1E1E1E) : Colors.white;
    final activeColor = Color(HiveService.getUserTypeColor());
    final inactiveColor = isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF);

    debugPrint('🧭 BottomNavigation: Screen size: ${size.width}x${size.height}');
    debugPrint('🧭 BottomNavigation: Theme mode: ${isDark ? 'dark' : 'light'}');
    debugPrint('🧭 BottomNavigation: Active color: $activeColor');
    debugPrint('🧭 BottomNavigation: Inactive color: $inactiveColor');

    // Get initial tab index for orders screen if provided
    final initialTabIndex = widget.extra?['initialTabIndex'] as int? ?? 0;
    debugPrint('🧭 BottomNavigation: Orders screen initial tab index: $initialTabIndex');

    // Define screens and navigation items based on user type from Hive
    final List<Widget> screens = _getScreensForUserType(_userType, initialTabIndex);
    final List<IconData> icons = _getIconsForUserType(_userType);

    debugPrint('🧭 BottomNavigation: Generated ${screens.length} screens for user type: $_userType');
    debugPrint('🧭 BottomNavigation: Generated ${icons.length} navigation icons');

    return Scaffold(
      // Use IndexedStack to maintain state across tab switches
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(20.r),
        height: size.width * .155,
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: ListView.builder(
          itemCount: icons.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: size.width * .024),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              debugPrint('🧭 BottomNavigation: Tab $index tapped');

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Animated indicator for active tab
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  margin: EdgeInsets.only(
                    bottom: index == currentIndex ? 0 : size.width * .029,
                    right: size.width * .0422,
                    left: size.width * .0422,
                  ),
                  width: size.width * .128,
                  height: index == currentIndex ? size.width * .014 : 0,
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                ),
                // Navigation icon with color animation
                Icon(
                  icons[index],
                  size: size.width * .076,
                  color: index == currentIndex ? activeColor : inactiveColor,
                ),
                // Bottom spacing
                SizedBox(height: size.width * .03),
              ],
            ),
          ),
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
          const AdminDashboardContent(), // Admin moderation screen (reuse dashboard for now)
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
          LineIcons.home, // Dashboard
          LineIcons.compass, // Explore
          LineIcons.briefcase, // Orders
          LineIcons.cog, // Settings
        ];
      case 'admin':
        return [
          LineIcons.desktop, // Analytics
          LineIcons.users, // Users
          LineIcons.tools, // Moderation
          LineIcons.cog, // Settings
        ];
      case 'customer':
      default:
        return [
          LineIcons.home, // Home
          LineIcons.compass, // Explore
          LineIcons.calendar, // Bookings
          LineIcons.user, // Profile
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
        debugPrint('BottomNavigation: Refreshed user type to: $_userType');
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

        debugPrint('BottomNavigation: Switched to user type: $newUserType');
      }
    } catch (e) {
      debugPrint('BottomNavigation: Failed to switch user type: $e');
    }
  }
}
