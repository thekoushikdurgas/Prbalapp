import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

// Import all screen files
import 'package:prbal/screens/provider/provider_dashboard.dart';
import 'package:prbal/screens/provider/provider_explore_screen.dart';
import 'package:prbal/screens/provider/provider_orders_screen.dart';
import 'package:prbal/screens/taker/taker_dashboard.dart';
import 'package:prbal/screens/taker/taker_explore_screen.dart';
import 'package:prbal/screens/taker/taker_orders_screen.dart';
import 'package:prbal/screens/admin/admin_dashboard.dart';
import 'package:prbal/screens/admin/admin_users_screen.dart';
import 'package:prbal/screens/main/settings_screen.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:flutter/services.dart' show HapticFeedback;

/// Bottom Navigation widget that dynamically adapts to three user types based on Hive data
///
/// This widget reads user type from HiveService and displays appropriate navigation
/// for each user type:
///
/// **Provider (Service Provider):**
/// - Dashboard: Manage services and bookings
/// - Explore: Find new opportunities
/// - Orders: Track service requests
/// - Settings: Account management
/// Color: Emerald (#10B981)
///
/// **Admin (Administrator):**
/// - Analytics: System metrics and reports
/// - Users: Manage user accounts
/// - Moderation: Content and dispute management
/// - Settings: System configuration
/// Color: Violet (#8B5CF6)
///
/// **Customer (Default):**
/// - Home: Browse available services
/// - Explore: Discover new services
/// - Bookings: Track your bookings
/// - Profile: Account settings
/// Color: Blue (#3B82F6)
///
/// Usage:
/// ```dart
/// BottomNavigation(
///   initialIndex: 0, // Optional: Starting tab index
///   extra: {'initialTabIndex': 1}, // Optional: Extra data for screens
/// )
/// ```
///
/// The user type is automatically determined from HiveService.getUserType()
/// which reads from locally stored user data.
///
/// **Example: Switch user type programmatically**
/// ```dart
/// // Switch to provider
/// await BottomNavigation.switchUserType('provider', context);
///
/// // Switch to admin
/// await BottomNavigation.switchUserType('admin', context);
///
/// // Switch to customer
/// await BottomNavigation.switchUserType('customer', context);
/// ```
///
/// **Example: Check current user type**
/// ```dart
/// String currentType = HiveService.getUserType();
/// bool isProvider = HiveService.isProvider();
/// bool isAdmin = HiveService.isAdmin();
/// bool isCustomer = HiveService.isCustomer();
/// ```
///
/// **Example: Get user type UI properties**
/// ```dart
/// String displayName = HiveService.getUserTypeDisplayName();
/// Color userColor = Color(HiveService.getUserTypeColor());
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

class _BottomNavigationState extends ConsumerState<BottomNavigation>
    with TickerProviderStateMixin {
  late int currentIndex;
  late AnimationController _animationController;
  late Animation<double> _animation;
  String _userType = 'customer'; // Default user type

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    // Get user type from Hive on initialization
    _loadUserType();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Load user type from Hive service
  void _loadUserType() {
    setState(() {
      _userType = HiveService.getUserType();
    });

    debugPrint('BottomNavigation: Loaded user type from Hive: $_userType');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get initial tab index for orders screen if provided
    final initialTabIndex = widget.extra?['initialTabIndex'] as int? ?? 0;

    // Define screens and navigation items based on user type from Hive
    final List<Widget> screens =
        _getScreensForUserType(_userType, initialTabIndex);
    final List<NavigationItem> navigationItems =
        _getNavigationItemsForUserType(_userType, isDark);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 50 * (1 - _animation.value)),
            child: Opacity(
              opacity: _animation.value,
              child: Container(
                margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.r),
                  child: Container(
                    height: 70.h,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        navigationItems.length,
                        (index) => _buildNavigationItem(
                          navigationItems[index],
                          index,
                          isDark,
                          _userType,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Get screens based on user type from Hive data
  List<Widget> _getScreensForUserType(String userType, int initialTabIndex) {
    switch (userType) {
      case 'provider':
        return [
          const ProviderDashboard(),
          const ProviderExploreScreen(),
          ProviderOrdersScreen(initialTabIndex: initialTabIndex),
          const SettingsScreen(),
        ];
      case 'admin':
        return [
          const AdminDashboard(),
          const AdminUsersScreen(),
          const AdminDashboard(), // Admin moderation screen (reuse dashboard for now)
          const SettingsScreen(),
        ];
      case 'customer':
      default:
        return [
          const TakerDashboard(),
          const TakerExploreScreen(),
          const TakerOrdersScreen(),
          const SettingsScreen(),
        ];
    }
  }

  /// Get navigation items based on user type from Hive data
  List<NavigationItem> _getNavigationItemsForUserType(
      String userType, bool isDark) {
    final Color activeColor = Color(HiveService.getUserTypeColor());
    final Color inactiveColor =
        isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF);

    switch (userType) {
      case 'provider':
        return [
          NavigationItem(
            icon: LineIcons.home,
            activeIcon: LineIcons.home,
            label: 'Dashboard',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          NavigationItem(
            icon: LineIcons.search,
            activeIcon: LineIcons.search,
            label: 'Explore',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          NavigationItem(
            icon: LineIcons.briefcase,
            activeIcon: LineIcons.briefcase,
            label: 'Orders',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          NavigationItem(
            icon: LineIcons.cog,
            activeIcon: LineIcons.cog,
            label: 'Settings',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ];
      case 'admin':
        return [
          NavigationItem(
            icon: LineIcons.desktop,
            activeIcon: LineIcons.desktop,
            label: 'Analytics',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          NavigationItem(
            icon: LineIcons.users,
            activeIcon: LineIcons.users,
            label: 'Users',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          NavigationItem(
            icon: LineIcons.tools,
            activeIcon: LineIcons.tools,
            label: 'Moderation',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          NavigationItem(
            icon: LineIcons.cog,
            activeIcon: LineIcons.cog,
            label: 'Settings',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ];
      case 'customer':
      default:
        return [
          NavigationItem(
            icon: LineIcons.home,
            activeIcon: LineIcons.home,
            label: 'Home',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          NavigationItem(
            icon: LineIcons.compass,
            activeIcon: LineIcons.compass,
            label: 'Explore',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          NavigationItem(
            icon: LineIcons.clipboard,
            activeIcon: LineIcons.clipboard,
            label: 'Bookings',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
          NavigationItem(
            icon: LineIcons.user,
            activeIcon: LineIcons.user,
            label: 'Profile',
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ];
    }
  }

  Widget _buildNavigationItem(
    NavigationItem item,
    int index,
    bool isDark,
    String userType,
  ) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        if (currentIndex != index) {
          setState(() {
            currentIndex = index;
          });

          // Add haptic feedback
          HapticFeedback.lightImpact();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16.w : 12.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? item.activeColor.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Background circle for active state
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSelected ? 36.w : 0,
                  height: isSelected ? 36.h : 0,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? item.activeColor.withValues(alpha: 0.2)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
                // Icon
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    key: ValueKey(isSelected),
                    color: isSelected ? item.activeColor : item.inactiveColor,
                    size: isSelected ? 24.sp : 22.sp,
                  ),
                ),
              ],
            ),

            // Label (only show when selected)
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: isSelected
                  ? Container(
                      margin: EdgeInsets.only(left: 8.w),
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: item.activeColor,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  /// Method to refresh user type from Hive (useful when user type changes)
  void refreshUserType() {
    _loadUserType();
  }

  /// Static method to update user type in Hive and refresh navigation
  /// Useful for testing or when user role changes
  static Future<void> switchUserType(
      String newUserType, BuildContext context) async {
    try {
      await HiveService.updateUserType(newUserType);

      // If there's a BottomNavigation in the widget tree, refresh it
      if (context.mounted) {
        final bottomNav =
            context.findAncestorStateOfType<_BottomNavigationState>();
        bottomNav?.refreshUserType();

        debugPrint('BottomNavigation: Switched to user type: $newUserType');
      }
    } catch (e) {
      debugPrint('BottomNavigation: Failed to switch user type: $e');
    }
  }
}

class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Color activeColor;
  final Color inactiveColor;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.activeColor,
    required this.inactiveColor,
  });
}
