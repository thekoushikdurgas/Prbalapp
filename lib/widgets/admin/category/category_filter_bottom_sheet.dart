import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// CategoryFilterBottomSheet - Enhanced component with comprehensive ThemeManager integration
///
/// **Purpose**: Encapsulates the modern filter bottom sheet functionality with complete ThemeManager theming
///
/// **Key Features**:
/// - Complete ThemeManager integration with all color properties and gradients
/// - Advanced gradient theming with background, surface, primary, secondary, and accent gradients
/// - Theme-aware shadows (primary, elevated, subtle) and glass morphism effects
/// - Modern Material Design 3.0 bottom sheet with dynamic theme adaptation
/// - Filter options with semantic color usage for all, active, and inactive categories
/// - Enhanced animations, haptic feedback, and visual hierarchy
/// - Comprehensive debug logging for theme operations and performance tracking
/// - Smart visual indicators with theme-consistent styling and semantic colors
/// - Advanced drag handle design with glass morphism and gradient styling
/// - Enhanced header with comprehensive theming and glass morphism containers
/// - Premium footer with theme information and enhanced visual feedback
/// - Context-aware filter tiles with ThemeManager semantic theming
class CategoryFilterBottomSheet extends StatefulWidget with ThemeAwareMixin {
  final String currentFilter;
  final Function(String) onFilterSelected;

  const CategoryFilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.onFilterSelected,
  });

  /// Show the enhanced filter bottom sheet with comprehensive theming
  static Future<void> show({
    required BuildContext context,
    required String currentFilter,
    required Function(String) onFilterSelected,
  }) async {
    debugPrint('🔧 CategoryFilterBottomSheet: Showing enhanced filter bottom sheet with comprehensive ThemeManager');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      showDragHandle: false, // We'll create our own themed drag handle
      isDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) => CategoryFilterBottomSheet(
        currentFilter: currentFilter,
        onFilterSelected: onFilterSelected,
      ),
    );
  }

  @override
  State<CategoryFilterBottomSheet> createState() => _CategoryFilterBottomSheetState();
}

class _CategoryFilterBottomSheetState extends State<CategoryFilterBottomSheet> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // COMPREHENSIVE DEBUG LOGGING FOR ALL THEMEMANAGER OPERATIONS

    ThemeManager.of(context).logGradientInfo();
    ThemeManager.of(context).logAllColors();
    debugPrint('🔧 CategoryFilterBottomSheet: =============================');
    debugPrint('🔧 CategoryFilterBottomSheet: BUILDING WITH ALL THEMEMANAGER ITEMS');
    debugPrint('🔧 CategoryFilterBottomSheet: =============================');
    debugPrint('🎨 CategoryFilterBottomSheet: Theme mode: ${ThemeManager.of(context).themeManager ? 'dark' : 'light'}');
    debugPrint(
        '🌈 CategoryFilterBottomSheet: Using ALL gradients - Background: ${ThemeManager.of(context).backgroundGradient.colors.length} colors, Surface: ${ThemeManager.of(context).surfaceGradient.colors.length} colors');
    debugPrint(
        '🎨 CategoryFilterBottomSheet: Core colors - Primary: ${ThemeManager.of(context).primaryColor}, Secondary: ${ThemeManager.of(context).secondaryColor}, Background: ${ThemeManager.of(context).backgroundColor}');
    debugPrint(
        '🌟 CategoryFilterBottomSheet: Interactive colors - Button: ${ThemeManager.of(context).buttonBackground}, Input: ${ThemeManager.of(context).inputBackground}');
    debugPrint(
        '📊 CategoryFilterBottomSheet: Status colors - Online: ${ThemeManager.of(context).statusOnline}, Offline: ${ThemeManager.of(context).statusOffline}, Error: ${ThemeManager.of(context).errorColor}');
    debugPrint('🔧 CategoryFilterBottomSheet: Current filter: ${widget.currentFilter}');

    return AnimatedBuilder(
      animation: Listenable.merge([_slideAnimation, _fadeAnimation]),
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.65,
              ),
              decoration: BoxDecoration(
                gradient: ThemeManager.of(context).conditionalGradient(
                  lightGradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ThemeManager.of(context).modalBackground,
                      ThemeManager.of(context).cardBackground,
                      ThemeManager.of(context).surfaceElevated,
                    ],
                  ),
                  darkGradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ThemeManager.of(context).backgroundTertiary,
                      ThemeManager.of(context).surfaceColor,
                      ThemeManager.of(context).backgroundSecondary,
                    ],
                  ),
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                border: Border.all(
                  color: ThemeManager.of(context).borderFocus,
                  width: 1.5,
                ),
                boxShadow: [
                  ...ThemeManager.of(context).elevatedShadow,
                  ...ThemeManager.of(context).primaryShadow,
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ========== ENHANCED DRAG HANDLE WITH THEMEMANAGER ==========
                  _buildEnhancedDragHandle(),

                  // ========== ENHANCED HEADER WITH COMPREHENSIVE STYLING ==========
                  _buildEnhancedHeader(context),

                  // ========== ENHANCED FILTER OPTIONS WITH FULL THEMING ==========
                  _buildEnhancedFilterOptions(context),

                  // ========== ENHANCED FOOTER WITH THEME INFO ==========
                  _buildEnhancedFooter(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build enhanced drag handle with ALL ThemeManager styling
  Widget _buildEnhancedDragHandle() {
    debugPrint('🎯 CategoryFilterBottomSheet: Building enhanced drag handle with ALL ThemeManager properties');
    debugPrint(
        '🎨 CategoryFilterBottomSheet: Using shimmer gradient: ${ThemeManager.of(context).shimmerGradient.colors.length} colors');
    debugPrint(
        '🌟 CategoryFilterBottomSheet: Semantic colors - Rating: ${ThemeManager.of(context).ratingColor}, Verified: ${ThemeManager.of(context).verifiedColor}');

    return Container(
      margin: EdgeInsets.only(top: 16.h, bottom: 12.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).glassGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ThemeManager.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Enhanced main drag handle with shimmer effect
          Container(
            width: 48.w,
            height: 6.h,
            decoration: BoxDecoration(
              gradient: ThemeManager.of(context).shimmerGradient,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                ...ThemeManager.of(context).subtleShadow,
                BoxShadow(
                  color: ThemeManager.of(context).shadowMedium,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          // Enhanced close indicator with ALL theme properties
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: ThemeManager.of(context).withThemeAlpha(ThemeManager.of(context).surfaceColor, 0.8),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: ThemeManager.of(context).conditionalColor(
                  lightColor: ThemeManager.of(context).neutral200,
                  darkColor: ThemeManager.of(context).neutral700,
                ),
              ),
              boxShadow: ThemeManager.of(context).elevatedShadow,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: ThemeManager.of(context).getTextColorForBackground(ThemeManager.of(context).surfaceColor),
                  size: 16.sp,
                ),
                SizedBox(width: 4.w),
                Container(
                  width: 4.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: ThemeManager.of(context).accent5,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build enhanced header with ALL ThemeManager styling
  Widget _buildEnhancedHeader(
    BuildContext context,
  ) {
    debugPrint('📋 CategoryFilterBottomSheet: Building enhanced header with ALL ThemeManager integration');
    debugPrint(
        '🎨 CategoryFilterBottomSheet: Brand colors - Primary Light: ${ThemeManager.of(context).primaryLight}, Primary Dark: ${ThemeManager.of(context).primaryDark}');
    debugPrint(
        '🌟 CategoryFilterBottomSheet: Status colors - Away: ${ThemeManager.of(context).statusAway}, Busy: ${ThemeManager.of(context).statusBusy}');
    debugPrint(
        '💎 CategoryFilterBottomSheet: Interactive colors - Button Hover: ${ThemeManager.of(context).buttonBackgroundHover}, Input Focus: ${ThemeManager.of(context).inputBackgroundFocused}');

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 20.h),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeManager.of(context).primaryLight,
              ThemeManager.of(context).secondaryLight,
              ThemeManager.of(context).backgroundTertiary,
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeManager.of(context).primaryDark,
              ThemeManager.of(context).secondaryDark,
              ThemeManager.of(context).backgroundSecondary,
            ],
          ),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
        border: Border(
          bottom: BorderSide(
            color: ThemeManager.of(context).getContrastingColor(ThemeManager.of(context).primaryColor),
            width: 2.0,
          ),
        ),
        boxShadow: [
          ...ThemeManager.of(context).subtleShadow,
          BoxShadow(
            color: ThemeManager.of(context).shadowDark,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ========== ENHANCED FILTER ICON WITH ALL THEMEMANAGER FEATURES ==========
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: ThemeManager.of(context).glassGradient,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: ThemeManager.of(context).withThemeAlpha(ThemeManager.of(context).verifiedColor, 0.5),
                width: 2,
              ),
              boxShadow: [
                ...ThemeManager.of(context).elevatedShadow,
                BoxShadow(
                  color: ThemeManager.of(context).shadowLight,
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                gradient: ThemeManager.of(context).conditionalGradient(
                  lightGradient: ThemeManager.of(context).accent4Gradient,
                  darkGradient: ThemeManager.of(context).accent3Gradient,
                ),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: ThemeManager.of(context).newIndicator,
                  width: 1,
                ),
                boxShadow: [
                  ...ThemeManager.of(context).primaryShadow,
                  BoxShadow(
                    color: ThemeManager.of(context).favoriteColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Prbal.filter,
                color: ThemeManager.of(context).getContrastingColor(ThemeManager.of(context).accent4),
                size: 24.sp,
              ),
            ),
          ),

          SizedBox(width: 20.w),

          // ========== ENHANCED TITLE SECTION WITH THEMING ==========
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    gradient: ThemeManager.of(context).accent2Gradient,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: ThemeManager.of(context).subtleShadow,
                  ),
                  child: Text(
                    'Filter Categories',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: ThemeManager.of(context).textInverted,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: ThemeManager.of(context).surfaceElevated,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: ThemeManager.of(context).borderColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.tune_rounded,
                        size: 14.sp,
                        color: ThemeManager.of(context).accent1,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          'Choose category status to display',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: ThemeManager.of(context).textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 16.w),

          // ========== ENHANCED CLOSE BUTTON WITH ALL THEMEMANAGER FEATURES ==========
          Container(
            decoration: BoxDecoration(
              gradient: ThemeManager.of(context).conditionalGradient(
                lightGradient: ThemeManager.of(context).errorGradient,
                darkGradient: ThemeManager.of(context).warningGradient,
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: ThemeManager.of(context).statusBusy,
                width: 2,
              ),
              boxShadow: [
                ...ThemeManager.of(context).elevatedShadow,
                BoxShadow(
                  color: ThemeManager.of(context).shadowMedium,
                  blurRadius: 6,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  debugPrint('🔧 CategoryFilterBottomSheet: Enhanced close button with ALL features pressed');
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop();
                },
                borderRadius: BorderRadius.circular(16.r),
                splashColor: ThemeManager.of(context).withThemeAlpha(ThemeManager.of(context).errorColor, 0.3),
                highlightColor:
                    ThemeManager.of(context).withThemeAlpha(ThemeManager.of(context).buttonBackgroundHover, 0.2),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  constraints: BoxConstraints(
                    minWidth: 44.w,
                    minHeight: 44.h,
                  ),
                  child: Icon(
                    Prbal.cross,
                    color: ThemeManager.of(context).getContrastingColor(ThemeManager.of(context).errorColor),
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build enhanced filter options with comprehensive ThemeManager integration
  Widget _buildEnhancedFilterOptions(
    BuildContext context,
  ) {
    debugPrint('🎯 CategoryFilterBottomSheet: Building enhanced filter options with comprehensive ThemeManager');

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: ThemeManager.of(context).backgroundGradient,
        ),
        child: Column(
          children: [
            // Section header
            Container(
              margin: EdgeInsets.all(24.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: ThemeManager.of(context).accent4Gradient,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: ThemeManager.of(context).subtleShadow,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_alt_rounded,
                    color: ThemeManager.of(context).textInverted,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Filter Options',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: ThemeManager.of(context).textInverted,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            // Enhanced filter options list
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 24.h),
                children: [
                  // ========== ALL CATEGORIES OPTION WITH ALL THEMEMANAGER FEATURES ==========
                  _buildEnhancedFilterOption(
                    context,
                    title: 'All Categories',
                    subtitle: 'Show both active and inactive categories',
                    icon: Prbal.list,
                    value: 'all',
                    gradient: ThemeManager.of(context).conditionalGradient(
                      lightGradient: ThemeManager.of(context).infoGradient,
                      darkGradient: ThemeManager.of(context).accent5 != ThemeManager.of(context).infoColor
                          ? LinearGradient(
                              colors: [ThemeManager.of(context).accent5, ThemeManager.of(context).infoColor])
                          : ThemeManager.of(context).infoGradient,
                    ),
                    iconColor: ThemeManager.of(context).newIndicator,
                    statusColor: ThemeManager.of(context).statusOnline,
                  ),

                  SizedBox(height: 16.h),

                  // ========== ACTIVE CATEGORIES OPTION WITH ALL THEMEMANAGER FEATURES ==========
                  _buildEnhancedFilterOption(
                    context,
                    title: 'Active Categories',
                    subtitle: 'Show only active categories',
                    icon: Prbal.checkCircle,
                    value: 'active',
                    gradient: ThemeManager.of(context).conditionalGradient(
                      lightGradient: ThemeManager.of(context).successGradient,
                      darkGradient: LinearGradient(
                          colors: [ThemeManager.of(context).successDark, ThemeManager.of(context).verifiedColor]),
                    ),
                    iconColor: ThemeManager.of(context).statusOnline,
                    statusColor: ThemeManager.of(context).verifiedColor,
                  ),

                  SizedBox(height: 16.h),

                  // ========== INACTIVE CATEGORIES OPTION WITH ALL THEMEMANAGER FEATURES ==========
                  _buildEnhancedFilterOption(
                    context,
                    title: 'Inactive Categories',
                    subtitle: 'Show only inactive categories',
                    icon: Prbal.pauseCircle,
                    value: 'inactive',
                    gradient: ThemeManager.of(context).conditionalGradient(
                      lightGradient: ThemeManager.of(context).warningGradient,
                      darkGradient: LinearGradient(
                          colors: [ThemeManager.of(context).statusAway, ThemeManager.of(context).warningDark]),
                    ),
                    iconColor: ThemeManager.of(context).statusOffline,
                    statusColor: ThemeManager.of(context).statusAway,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build enhanced filter option with ALL ThemeManager styling
  Widget _buildEnhancedFilterOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required LinearGradient gradient,
    required Color iconColor,
    required Color statusColor,
  }) {
    final isSelected = widget.currentFilter == value;

    debugPrint('🎯 CategoryFilterBottomSheet: Building filter option "$title" with ALL ThemeManager features');
    debugPrint(
        '🎨 CategoryFilterBottomSheet: Using neutral colors - 300: ${ThemeManager.of(context).neutral300}, 600: ${ThemeManager.of(context).neutral600}, 900: ${ThemeManager.of(context).neutral900}');

    return Container(
      decoration: BoxDecoration(
        gradient: isSelected
            ? gradient
            : ThemeManager.of(context).conditionalGradient(
                lightGradient: LinearGradient(
                  colors: [
                    ThemeManager.of(context).neutral50,
                    ThemeManager.of(context).neutral100,
                    ThemeManager.of(context).neutral200
                  ],
                ),
                darkGradient: LinearGradient(
                  colors: [
                    ThemeManager.of(context).neutral700,
                    ThemeManager.of(context).neutral600,
                    ThemeManager.of(context).neutral500
                  ],
                ),
              ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: isSelected
            ? [
                ...ThemeManager.of(context).elevatedShadow,
                ...ThemeManager.of(context).primaryShadow,
                BoxShadow(
                  color: statusColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : [
                ...ThemeManager.of(context).subtleShadow,
                BoxShadow(
                  color: ThemeManager.of(context).shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
        border: Border.all(
          color: isSelected
              ? ThemeManager.of(context).getContrastingColor(statusColor)
              : ThemeManager.of(context).conditionalColor(
                  lightColor: ThemeManager.of(context).neutral300,
                  darkColor: ThemeManager.of(context).neutral700,
                ),
          width: isSelected ? 3.0 : 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            debugPrint(
                '🔧 CategoryFilterBottomSheet: Enhanced filter option with ALL ThemeManager features selected: $value');
            HapticFeedback.selectionClick();
            widget.onFilterSelected(value);
            Navigator.of(context).pop();
          },
          borderRadius: BorderRadius.circular(20.r),
          splashColor: ThemeManager.of(context).withThemeAlpha(statusColor, 0.3),
          highlightColor: ThemeManager.of(context).withThemeAlpha(ThemeManager.of(context).buttonBackgroundHover, 0.2),
          hoverColor: ThemeManager.of(context).withThemeAlpha(ThemeManager.of(context).buttonBackgroundPressed, 0.1),
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                // Enhanced icon container with glass morphism
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: isSelected
                      ? ThemeManager.of(context).enhancedGlassMorphism
                      : ThemeManager.of(context).glassMorphism,
                  child: Icon(
                    icon,
                    size: 24.sp,
                    color: isSelected ? ThemeManager.of(context).textInverted : iconColor,
                  ),
                ),

                SizedBox(width: 20.w),

                // Enhanced text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              isSelected ? ThemeManager.of(context).textInverted : ThemeManager.of(context).textPrimary,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ThemeManager.of(context).textInverted.withValues(alpha: 0.1)
                              : ThemeManager.of(context).surfaceElevated,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: isSelected
                                ? ThemeManager.of(context).textInverted.withValues(alpha: 0.9)
                                : ThemeManager.of(context).textSecondary,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 16.w),

                // Enhanced selection indicator
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    gradient: isSelected ? ThemeManager.of(context).accent1Gradient : null,
                    color: isSelected ? null : ThemeManager.of(context).surfaceElevated,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : ThemeManager.of(context).borderColor,
                    ),
                  ),
                  child: Icon(
                    isSelected ? Icons.check_rounded : Icons.radio_button_unchecked_rounded,
                    size: 18.sp,
                    color: isSelected ? ThemeManager.of(context).textInverted : ThemeManager.of(context).textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build enhanced footer with ALL ThemeManager features
  Widget _buildEnhancedFooter() {
    debugPrint('🎯 CategoryFilterBottomSheet: Building footer with ALL ThemeManager properties');
    debugPrint(
        '🎨 CategoryFilterBottomSheet: Interactive states - Disabled: ${ThemeManager.of(context).buttonBackgroundDisabled}, Input disabled: ${ThemeManager.of(context).inputBackgroundDisabled}');
    debugPrint(
        '🌟 CategoryFilterBottomSheet: Semantic indicators - Rating: ${ThemeManager.of(context).ratingColor}, Favorite: ${ThemeManager.of(context).favoriteColor}');

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ThemeManager.of(context).backgroundTertiary,
              ThemeManager.of(context).surfaceElevated,
              ThemeManager.of(context).cardBackground,
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ThemeManager.of(context).backgroundSecondary,
              ThemeManager.of(context).modalBackground,
              ThemeManager.of(context).neutral800,
            ],
          ),
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
        border: Border(
          top: BorderSide(
            color: ThemeManager.of(context).dividerColor,
            width: 2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeManager.of(context).shadowDark,
            blurRadius: 8,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Filter summary
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: ThemeManager.of(context).glassMorphism,
            child: Row(
              children: [
                Icon(
                  Icons.info_rounded,
                  size: 14.sp,
                  color: ThemeManager.of(context).accent3,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Current filter: ${_getFilterDisplayName(widget.currentFilter)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: ThemeManager.of(context).textTertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          // Additional info
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: ThemeManager.of(context).backgroundSecondary,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: ThemeManager.of(context).borderSecondary),
            ),
            child: Text(
              'Filters apply immediately to the category list',
              style: TextStyle(
                fontSize: 11.sp,
                color: ThemeManager.of(context).textQuaternary,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Get display name for filter value
  String _getFilterDisplayName(String filter) {
    switch (filter) {
      case 'all':
        return 'All Categories';
      case 'active':
        return 'Active Categories';
      case 'inactive':
        return 'Inactive Categories';
      default:
        return 'Unknown Filter';
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}
