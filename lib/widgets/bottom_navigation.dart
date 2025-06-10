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
import 'package:prbal/services/app_services.dart';
import 'package:flutter/services.dart' show HapticFeedback;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // final userType = ref.watch(userTypeProvider);
    final isProvider = ref.watch(isProviderProvider);
    final isCustomer = ref.watch(isCustomerProvider);
    final isAdmin = ref.watch(isAdminProvider);

    // Determine user type for screen selection
    String actualUserType = 'customer'; // default
    if (isProvider) {
      actualUserType = 'provider';
    } else if (isAdmin) {
      actualUserType = 'admin';
    } else if (isCustomer) {
      actualUserType = 'customer';
    }

    // Get initial tab index for orders screen if provided
    final initialTabIndex = widget.extra?['initialTabIndex'] as int? ?? 0;

    // Define screens based on user type
    final List<Widget> screens =
        _getScreensForUserType(actualUserType, initialTabIndex);
    final List<NavigationItem> navigationItems =
        _getNavigationItemsForUserType(actualUserType, isDark);

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
                          actualUserType,
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

  List<NavigationItem> _getNavigationItemsForUserType(
      String userType, bool isDark) {
    final Color activeColor = _getUserTypeColor(userType);
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

  Color _getUserTypeColor(String userType) {
    switch (userType) {
      case 'provider':
        return const Color(0xFF10B981); // Emerald
      case 'admin':
        return const Color(0xFF8B5CF6); // Violet
      case 'customer':
      default:
        return const Color(0xFF3B82F6); // Blue
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
