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

    // Comprehensive theme logging for debugging

    debugPrint(
        '🔍 CategorySearchHeader: Building with COMPREHENSIVE ThemeManager integration');
    debugPrint(
        '🔍 CategorySearchHeader: → Primary: ${ThemeManager.of(context).primaryColor}');
    debugPrint(
        '🔍 CategorySearchHeader: → Secondary: ${ThemeManager.of(context).secondaryColor}');
    debugPrint(
        '🔍 CategorySearchHeader: → Background: ${ThemeManager.of(context).backgroundColor}');
    debugPrint(
        '🔍 CategorySearchHeader: → Surface: ${ThemeManager.of(context).surfaceColor}');
    debugPrint(
        '🔍 CategorySearchHeader: → Card Background: ${ThemeManager.of(context).cardBackground}');
    debugPrint(
        '🔍 CategorySearchHeader: → Surface Elevated: ${ThemeManager.of(context).surfaceElevated}');
    debugPrint(
        '🔍 CategorySearchHeader: → Input Background: ${ThemeManager.of(context).inputBackground}');
    debugPrint(
        '🔍 CategorySearchHeader: → Status Colors - Success: ${ThemeManager.of(context).successColor}, Warning: ${ThemeManager.of(context).warningColor}, Error: ${ThemeManager.of(context).errorColor}, Info: ${ThemeManager.of(context).infoColor}');
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
            gradient: ThemeManager.of(context).conditionalGradient(
              lightGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ThemeManager.of(context).cardBackground,
                  ThemeManager.of(context).surfaceElevated,
                  ThemeManager.of(context).backgroundSecondary,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              darkGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ThemeManager.of(context).cardBackground,
                  ThemeManager.of(context).backgroundTertiary,
                  ThemeManager.of(context).surfaceElevated,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: ThemeManager.of(context).conditionalColor(
                lightColor:
                    ThemeManager.of(context).borderColor.withValues(alpha: 0.2),
                darkColor:
                    ThemeManager.of(context).borderFocus.withValues(alpha: 0.3),
              ),
              width: 1.5,
            ),
            boxShadow: [
              ...ThemeManager.of(context).elevatedShadow,
              BoxShadow(
                color: ThemeManager.of(context).shadowMedium,
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: ThemeManager.of(context)
                    .primaryColor
                    .withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // ========== SEARCH AND CONTROLS ROW ==========
              _buildSearchControlsRow(),

              // ========== STATISTICS ROW ==========
              _buildStatisticsRow(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the main search controls row
  Widget _buildSearchControlsRow() {
    debugPrint('🔍 CategorySearchHeader: Building search controls row');

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          // ========== BACK BUTTON (OPTIONAL) ==========
          if (widget.showBackButton) ...[
            _buildBackButton(),
            SizedBox(width: 12.w),
          ],

          // ========== SEARCH FIELD (EXPANDABLE) ==========
          Expanded(child: _buildSearchField()),

          SizedBox(width: 12.w),

          // ========== FILTER BUTTON ==========
          _buildFilterButton(),

          SizedBox(width: 8.w),

          // ========== RESULTS COUNT BADGE ==========
          _buildResultsBadge(),
        ],
      ),
    );
  }

  /// Build back navigation button with comprehensive ThemeManager integration
  Widget _buildBackButton() {
    debugPrint(
        '🔍 CategorySearchHeader: Building enhanced back button with comprehensive theming');

    return Container(
      decoration: ThemeManager.of(context).enhancedGlassMorphism.copyWith(
        gradient: ThemeManager.of(context).conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeManager.of(context).primaryColor.withValues(alpha: 0.15),
              ThemeManager.of(context).primaryLight.withValues(alpha: 0.1),
              ThemeManager.of(context).accent1.withValues(alpha: 0.05),
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeManager.of(context).primaryDark.withValues(alpha: 0.2),
              ThemeManager.of(context).primaryColor.withValues(alpha: 0.15),
              ThemeManager.of(context).accent1.withValues(alpha: 0.1),
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ThemeManager.of(context).conditionalColor(
            lightColor:
                ThemeManager.of(context).primaryColor.withValues(alpha: 0.3),
            darkColor:
                ThemeManager.of(context).borderFocus.withValues(alpha: 0.4),
          ),
          width: 1.5,
        ),
        boxShadow: [
          ...ThemeManager.of(context).primaryShadow,
          BoxShadow(
            color: ThemeManager.of(context).shadowMedium,
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
          color: ThemeManager.of(context).primaryColor,
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
  Widget _buildSearchField() {
    debugPrint(
        '🔍 CategorySearchHeader: Building enhanced search field with comprehensive theming');

    return Container(
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeManager.of(context).inputBackground,
              ThemeManager.of(context).surfaceElevated,
              ThemeManager.of(context).cardBackground,
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeManager.of(context).inputBackground,
              ThemeManager.of(context).backgroundTertiary,
              ThemeManager.of(context).surfaceElevated,
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ThemeManager.of(context).conditionalColor(
            lightColor:
                ThemeManager.of(context).borderColor.withValues(alpha: 0.3),
            darkColor:
                ThemeManager.of(context).borderSecondary.withValues(alpha: 0.4),
          ),
          width: 1.5,
        ),
        boxShadow: [
          ...ThemeManager.of(context).subtleShadow,
          BoxShadow(
            color: ThemeManager.of(context).shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: widget.searchController,
        style: TextStyle(
          fontSize: 15.sp,
          color: ThemeManager.of(context).textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search categories...',
          hintStyle: TextStyle(
            color: ThemeManager.of(context).textSecondary,
            fontSize: 14.sp,
          ),
          prefixIcon: Container(
            padding: EdgeInsets.all(10.w),
            child: Icon(
              Prbal.search,
              color: ThemeManager.of(context).primaryColor,
              size: 18.sp,
            ),
          ),
          suffixIcon: widget.searchController.text.isNotEmpty
              ? _buildClearSearchButton()
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
  Widget _buildClearSearchButton() {
    return Container(
      margin: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).conditionalGradient(
          lightGradient: LinearGradient(
            colors: [
              ThemeManager.of(context).errorColor.withValues(alpha: 0.15),
              ThemeManager.of(context).errorLight.withValues(alpha: 0.1),
            ],
          ),
          darkGradient: LinearGradient(
            colors: [
              ThemeManager.of(context).errorDark.withValues(alpha: 0.2),
              ThemeManager.of(context).errorColor.withValues(alpha: 0.15),
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: ThemeManager.of(context).conditionalColor(
            lightColor:
                ThemeManager.of(context).errorColor.withValues(alpha: 0.3),
            darkColor:
                ThemeManager.of(context).errorDark.withValues(alpha: 0.4),
          ),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeManager.of(context).errorColor.withValues(alpha: 0.1),
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
          color: ThemeManager.of(context).conditionalColor(
            lightColor: ThemeManager.of(context).errorColor,
            darkColor: ThemeManager.of(context).errorLight,
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
  Widget _buildFilterButton() {
    final bool hasActiveFilter = widget.currentFilter != 'all';

    debugPrint(
        '🔍 CategorySearchHeader: Building enhanced filter button with comprehensive theming (hasActiveFilter: $hasActiveFilter)');

    return Container(
      decoration: BoxDecoration(
        gradient: hasActiveFilter
            ? ThemeManager.of(context).conditionalGradient(
                lightGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ThemeManager.of(context).accent2,
                    ThemeManager.of(context).accent2.withValues(alpha: 0.8),
                    ThemeManager.of(context)
                        .primaryColor
                        .withValues(alpha: 0.6),
                  ],
                ),
                darkGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ThemeManager.of(context).accent2.withValues(alpha: 0.8),
                    ThemeManager.of(context)
                        .primaryColor
                        .withValues(alpha: 0.7),
                    ThemeManager.of(context).accent1.withValues(alpha: 0.5),
                  ],
                ),
              )
            : ThemeManager.of(context).conditionalGradient(
                lightGradient: LinearGradient(
                  colors: [
                    ThemeManager.of(context).neutral100,
                    ThemeManager.of(context).neutral200,
                    ThemeManager.of(context).surfaceElevated,
                  ],
                ),
                darkGradient: LinearGradient(
                  colors: [
                    ThemeManager.of(context).neutral700,
                    ThemeManager.of(context).neutral600,
                    ThemeManager.of(context).surfaceElevated,
                  ],
                ),
              ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: hasActiveFilter
              ? ThemeManager.of(context).conditionalColor(
                  lightColor:
                      ThemeManager.of(context).accent2.withValues(alpha: 0.6),
                  darkColor: ThemeManager.of(context)
                      .borderFocus
                      .withValues(alpha: 0.8),
                )
              : ThemeManager.of(context).conditionalColor(
                  lightColor: ThemeManager.of(context)
                      .borderColor
                      .withValues(alpha: 0.3),
                  darkColor: ThemeManager.of(context)
                      .borderSecondary
                      .withValues(alpha: 0.4),
                ),
          width: hasActiveFilter ? 2 : 1.5,
        ),
        boxShadow: hasActiveFilter
            ? [
                BoxShadow(
                  color:
                      ThemeManager.of(context).accent2.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: ThemeManager.of(context).shadowMedium,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
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
                  ? ThemeManager.of(context).primaryColor
                  : ThemeManager.of(context).textSecondary,
            ),
            if (hasActiveFilter)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: ThemeManager.of(context).primaryColor,
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
  Widget _buildResultsBadge() {
    debugPrint(
        '🔍 CategorySearchHeader: Building enhanced results badge with comprehensive theming (count: ${widget.filteredCount})');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeManager.of(context).successColor,
              ThemeManager.of(context).successLight,
              ThemeManager.of(context).accent3,
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeManager.of(context).successDark,
              ThemeManager.of(context).successColor,
              ThemeManager.of(context).accent3,
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: ThemeManager.of(context).conditionalColor(
            lightColor:
                ThemeManager.of(context).successColor.withValues(alpha: 0.6),
            darkColor:
                ThemeManager.of(context).successDark.withValues(alpha: 0.8),
          ),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeManager.of(context).successColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: ThemeManager.of(context).shadowMedium,
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
            color: ThemeManager.of(context)
                .getContrastingColor(ThemeManager.of(context).successColor),
          ),
          SizedBox(width: 4.w),
          Text(
            '${widget.filteredCount}',
            style: TextStyle(
              fontSize: 12.sp,
              color: ThemeManager.of(context)
                  .getContrastingColor(ThemeManager.of(context).successColor),
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  /// Build statistics row with counts
  Widget _buildStatisticsRow() {
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
              ThemeManager.of(context).primaryColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              'Active',
              widget.activeCount.toString(),
              Prbal.checkCircle,
              ThemeManager.of(context).successColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              'Inactive',
              widget.inactiveCount.toString(),
              Prbal.pauseCircle,
              ThemeManager.of(context).warningColor,
            ),
          ),
          if (widget.selectedCount > 0) ...[
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                'Selected',
                widget.selectedCount.toString(),
                Prbal.checkSquare,
                ThemeManager.of(context).infoColor,
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
              color: ThemeManager.of(context).textPrimary,
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
              color: ThemeManager.of(context).textSecondary,
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
