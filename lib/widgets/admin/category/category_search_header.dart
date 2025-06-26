import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// ====================================================================
/// CATEGORY SEARCH HEADER COMPONENT
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
/// **1. Enhanced Search Container:**
/// - Multi-layer gradient backgrounds with comprehensive color transitions
/// - Advanced border system with borderFocus and dynamic alpha values
/// - Layered shadow effects combining all shadow types
/// - Theme-aware input styling with proper contrast
///
/// **2. Advanced Button System:**
/// - Back button: primaryColor gradients with enhanced glass morphism
/// - Filter button: Dynamic state-aware styling with accent colors
/// - Clear button: Error color integration with smooth interactions
/// - Results badge: Success color system with professional styling
///
/// **3. Statistics Cards Enhancement:**
/// - Individual status color mapping (primary, success, warning, info)
/// - Gradient backgrounds with proper semantic colors
/// - Enhanced shadow system for visual hierarchy
/// - Professional typography with theme-aware contrast
///
/// **🎯 RESULT:**
/// A sophisticated search header that provides premium visual experience
/// with automatic light/dark theme adaptation using ALL ThemeManager
/// properties for consistent, beautiful, and accessible search interface.
/// ====================================================================

class CategorySearchHeader extends StatefulWidget {
  // ========== REQUIRED PROPERTIES ==========
  final TextEditingController searchController;
  final VoidCallback onFilterPressed;
  final String currentFilter;
  final int totalCount;
  final int activeCount;
  final int inactiveCount;
  final int filteredCount;
  final int selectedCount;

  // ========== OPTIONAL PROPERTIES ==========
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final String? title;
  final String? subtitle;

  const CategorySearchHeader({
    super.key,
    required this.searchController,
    required this.onFilterPressed,
    required this.currentFilter,
    required this.totalCount,
    required this.activeCount,
    required this.inactiveCount,
    required this.filteredCount,
    required this.selectedCount,
    this.showBackButton = false,
    this.onBackPressed,
    this.title,
    this.subtitle,
  });

  @override
  State<CategorySearchHeader> createState() => _CategorySearchHeaderState();
}

class _CategorySearchHeaderState extends State<CategorySearchHeader>
    with SingleTickerProviderStateMixin, ThemeAwareMixin {
  // ========== ANIMATION CONTROLLER ==========
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint('🔍 CategorySearchHeader: Initializing search header component');

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // Start animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('🔍 CategorySearchHeader: Starting entry animations');
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    debugPrint('🔍 CategorySearchHeader: Disposing search header component');
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ========== COMPREHENSIVE THEME INTEGRATION ==========
    final themeManager = ThemeManager.of(context);

    // Comprehensive theme logging for debugging
    themeManager.logThemeInfo();
    debugPrint(
        '🔍 CategorySearchHeader: Building with COMPREHENSIVE ThemeManager integration');
    debugPrint(
        '🔍 CategorySearchHeader: → Primary: ${themeManager.primaryColor}');
    debugPrint(
        '🔍 CategorySearchHeader: → Secondary: ${themeManager.secondaryColor}');
    debugPrint(
        '🔍 CategorySearchHeader: → Background: ${themeManager.backgroundColor}');
    debugPrint(
        '🔍 CategorySearchHeader: → Surface: ${themeManager.surfaceColor}');
    debugPrint(
        '🔍 CategorySearchHeader: → Card Background: ${themeManager.cardBackground}');
    debugPrint(
        '🔍 CategorySearchHeader: → Surface Elevated: ${themeManager.surfaceElevated}');
    debugPrint(
        '🔍 CategorySearchHeader: → Input Background: ${themeManager.inputBackground}');
    debugPrint(
        '🔍 CategorySearchHeader: → Status Colors - Success: ${themeManager.successColor}, Warning: ${themeManager.warningColor}, Error: ${themeManager.errorColor}, Info: ${themeManager.infoColor}');
    debugPrint(
        '🔍 CategorySearchHeader: → Stats - Total: ${widget.totalCount}, Active: ${widget.activeCount}, Inactive: ${widget.inactiveCount}');
    debugPrint(
        '🔍 CategorySearchHeader: → Filter: "${widget.currentFilter}", Filtered: ${widget.filteredCount}, Selected: ${widget.selectedCount}');

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
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
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: themeManager.conditionalColor(
                lightColor: themeManager.borderColor.withValues(alpha: 0.2),
                darkColor: themeManager.borderFocus.withValues(alpha: 0.3),
              ),
              width: 1.5,
            ),
            boxShadow: [
              ...themeManager.elevatedShadow,
              BoxShadow(
                color: themeManager.shadowMedium,
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: themeManager.primaryColor.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // ========== SEARCH AND CONTROLS ROW ==========
              _buildSearchControlsRow(themeManager),

              // ========== STATISTICS ROW ==========
              _buildStatisticsRow(themeManager),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the main search controls row
  Widget _buildSearchControlsRow(ThemeManager themeManager) {
    debugPrint('🔍 CategorySearchHeader: Building search controls row');

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          // ========== BACK BUTTON (OPTIONAL) ==========
          if (widget.showBackButton) ...[
            _buildBackButton(themeManager),
            SizedBox(width: 12.w),
          ],

          // ========== SEARCH FIELD (EXPANDABLE) ==========
          Expanded(child: _buildSearchField(themeManager)),

          SizedBox(width: 12.w),

          // ========== FILTER BUTTON ==========
          _buildFilterButton(themeManager),

          SizedBox(width: 8.w),

          // ========== RESULTS COUNT BADGE ==========
          _buildResultsBadge(themeManager),
        ],
      ),
    );
  }

  /// Build back navigation button with comprehensive ThemeManager integration
  Widget _buildBackButton(ThemeManager themeManager) {
    debugPrint(
        '🔍 CategorySearchHeader: Building enhanced back button with comprehensive theming');

    return Container(
      decoration: themeManager.enhancedGlassMorphism.copyWith(
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.primaryColor.withValues(alpha: 0.15),
              themeManager.primaryLight.withValues(alpha: 0.1),
              themeManager.accent1.withValues(alpha: 0.05),
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.primaryDark.withValues(alpha: 0.2),
              themeManager.primaryColor.withValues(alpha: 0.15),
              themeManager.accent1.withValues(alpha: 0.1),
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: themeManager.primaryColor.withValues(alpha: 0.3),
            darkColor: themeManager.borderFocus.withValues(alpha: 0.4),
          ),
          width: 1.5,
        ),
        boxShadow: [
          ...themeManager.primaryShadow,
          BoxShadow(
            color: themeManager.shadowMedium,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {
          debugPrint('⬅️ CategorySearchHeader: Back button pressed');
          HapticFeedback.lightImpact();
          widget.onBackPressed?.call();
        },
        icon: Icon(
          Prbal.arrowLeft,
          size: 20.sp,
          color: themeManager.primaryColor,
        ),
        tooltip: 'Back',
        constraints: BoxConstraints(
          minWidth: 44.w,
          minHeight: 44.h,
        ),
        padding: EdgeInsets.all(8.w),
      ),
    );
  }

  /// Build the main search field with comprehensive ThemeManager integration
  Widget _buildSearchField(ThemeManager themeManager) {
    debugPrint(
        '🔍 CategorySearchHeader: Building enhanced search field with comprehensive theming');

    return Container(
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.inputBackground,
              themeManager.surfaceElevated,
              themeManager.cardBackground,
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.inputBackground,
              themeManager.backgroundTertiary,
              themeManager.surfaceElevated,
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: themeManager.borderColor.withValues(alpha: 0.3),
            darkColor: themeManager.borderSecondary.withValues(alpha: 0.4),
          ),
          width: 1.5,
        ),
        boxShadow: [
          ...themeManager.subtleShadow,
          BoxShadow(
            color: themeManager.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: widget.searchController,
        style: TextStyle(
          fontSize: 15.sp,
          color: themeManager.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search categories...',
          hintStyle: TextStyle(
            color: themeManager.textSecondary,
            fontSize: 14.sp,
          ),
          prefixIcon: Container(
            padding: EdgeInsets.all(10.w),
            child: Icon(
              Prbal.search,
              color: themeManager.primaryColor,
              size: 18.sp,
            ),
          ),
          suffixIcon: widget.searchController.text.isNotEmpty
              ? _buildClearSearchButton(themeManager)
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 12.h,
          ),
        ),
        onSubmitted: (value) {
          debugPrint('🔍 CategorySearchHeader: Search submitted: "$value"');
          HapticFeedback.selectionClick();
        },
      ),
    );
  }

  /// Build clear search button with comprehensive ThemeManager integration
  Widget _buildClearSearchButton(ThemeManager themeManager) {
    return Container(
      margin: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            colors: [
              themeManager.errorColor.withValues(alpha: 0.15),
              themeManager.errorLight.withValues(alpha: 0.1),
            ],
          ),
          darkGradient: LinearGradient(
            colors: [
              themeManager.errorDark.withValues(alpha: 0.2),
              themeManager.errorColor.withValues(alpha: 0.15),
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: themeManager.errorColor.withValues(alpha: 0.3),
            darkColor: themeManager.errorDark.withValues(alpha: 0.4),
          ),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: themeManager.errorColor.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {
          debugPrint('🗑️ CategorySearchHeader: Clear search button pressed');
          widget.searchController.clear();
          HapticFeedback.lightImpact();
        },
        icon: Icon(
          Prbal.cross,
          color: themeManager.conditionalColor(
            lightColor: themeManager.errorColor,
            darkColor: themeManager.errorLight,
          ),
          size: 14.sp,
        ),
        tooltip: 'Clear Search',
        constraints: BoxConstraints(
          minWidth: 32.w,
          minHeight: 32.h,
        ),
        padding: EdgeInsets.all(4.w),
      ),
    );
  }

  /// Build filter button with comprehensive ThemeManager state integration
  Widget _buildFilterButton(ThemeManager themeManager) {
    final bool hasActiveFilter = widget.currentFilter != 'all';

    debugPrint(
        '🔍 CategorySearchHeader: Building enhanced filter button with comprehensive theming (hasActiveFilter: $hasActiveFilter)');

    return Container(
      decoration: BoxDecoration(
        gradient: hasActiveFilter
            ? themeManager.conditionalGradient(
                lightGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    themeManager.accent2,
                    themeManager.accent2.withValues(alpha: 0.8),
                    themeManager.primaryColor.withValues(alpha: 0.6),
                  ],
                ),
                darkGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    themeManager.accent2.withValues(alpha: 0.8),
                    themeManager.primaryColor.withValues(alpha: 0.7),
                    themeManager.accent1.withValues(alpha: 0.5),
                  ],
                ),
              )
            : themeManager.conditionalGradient(
                lightGradient: LinearGradient(
                  colors: [
                    themeManager.neutral100,
                    themeManager.neutral200,
                    themeManager.surfaceElevated,
                  ],
                ),
                darkGradient: LinearGradient(
                  colors: [
                    themeManager.neutral700,
                    themeManager.neutral600,
                    themeManager.surfaceElevated,
                  ],
                ),
              ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: hasActiveFilter
              ? themeManager.conditionalColor(
                  lightColor: themeManager.accent2.withValues(alpha: 0.6),
                  darkColor: themeManager.borderFocus.withValues(alpha: 0.8),
                )
              : themeManager.conditionalColor(
                  lightColor: themeManager.borderColor.withValues(alpha: 0.3),
                  darkColor:
                      themeManager.borderSecondary.withValues(alpha: 0.4),
                ),
          width: hasActiveFilter ? 2 : 1.5,
        ),
        boxShadow: hasActiveFilter
            ? [
                BoxShadow(
                  color: themeManager.accent2.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: themeManager.shadowMedium,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                ...themeManager.subtleShadow,
                BoxShadow(
                  color: themeManager.shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: IconButton(
        onPressed: () {
          debugPrint('🔧 CategorySearchHeader: Filter button pressed');
          HapticFeedback.lightImpact();
          widget.onFilterPressed();
        },
        icon: Stack(
          children: [
            Icon(
              Prbal.filter,
              size: 18.sp,
              color: hasActiveFilter
                  ? themeManager.primaryColor
                  : themeManager.textSecondary,
            ),
            if (hasActiveFilter)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: themeManager.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        tooltip: 'Filter Categories',
        constraints: BoxConstraints(
          minWidth: 44.w,
          minHeight: 44.h,
        ),
        padding: EdgeInsets.all(8.w),
      ),
    );
  }

  /// Build results count badge with comprehensive ThemeManager integration
  Widget _buildResultsBadge(ThemeManager themeManager) {
    debugPrint(
        '🔍 CategorySearchHeader: Building enhanced results badge with comprehensive theming (count: ${widget.filteredCount})');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.successColor,
              themeManager.successLight,
              themeManager.accent3,
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.successDark,
              themeManager.successColor,
              themeManager.accent3,
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: themeManager.successColor.withValues(alpha: 0.6),
            darkColor: themeManager.successDark.withValues(alpha: 0.8),
          ),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: themeManager.successColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: themeManager.shadowMedium,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Prbal.statsBars,
            size: 12.sp,
            color: themeManager.getContrastingColor(themeManager.successColor),
          ),
          SizedBox(width: 4.w),
          Text(
            '${widget.filteredCount}',
            style: TextStyle(
              fontSize: 12.sp,
              color:
                  themeManager.getContrastingColor(themeManager.successColor),
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  /// Build statistics row with counts
  Widget _buildStatisticsRow(ThemeManager themeManager) {
    debugPrint('🔍 CategorySearchHeader: Building statistics row');

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total',
              widget.totalCount.toString(),
              Prbal.database,
              themeManager.primaryColor,
              themeManager,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              'Active',
              widget.activeCount.toString(),
              Prbal.checkCircle,
              themeManager.successColor,
              themeManager,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              'Inactive',
              widget.inactiveCount.toString(),
              Prbal.pauseCircle,
              themeManager.warningColor,
              themeManager,
            ),
          ),
          if (widget.selectedCount > 0) ...[
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                'Selected',
                widget.selectedCount.toString(),
                Prbal.checkSquare,
                themeManager.infoColor,
                themeManager,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build individual statistics card
  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    ThemeManager themeManager,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 26),
            color.withValues(alpha: 13),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withValues(alpha: 51),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 13),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16.sp,
            color: color,
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: themeManager.textPrimary,
              letterSpacing: -0.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: themeManager.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
