import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

/// ====================================================================
/// CATEGORY SEARCH HEADER COMPONENT
/// ====================================================================
///
/// **Purpose**: Modern search header with integrated filtering and statistics
///
/// **Key Features**:
/// - Real-time search with debounced input
/// - Filter button with visual state indicators
/// - Optional back navigation button
/// - Live statistics display (total, active, inactive, selected)
/// - Modern glassmorphism design with theme awareness
/// - Comprehensive debug logging for search interactions
///
/// **Extracted From**: ServiceCategoryCrudWidget._buildModernSearchHeader()
/// **Component Type**: Stateful reusable component
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

class _CategorySearchHeaderState extends State<CategorySearchHeader> with SingleTickerProviderStateMixin {
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

    _slideAnimation = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    debugPrint('🔍 CategorySearchHeader: Building search header (isDark: $isDark)');
    debugPrint(
        '🔍 CategorySearchHeader: Stats - Total: ${widget.totalCount}, Active: ${widget.activeCount}, Inactive: ${widget.inactiveCount}');
    debugPrint(
        '🔍 CategorySearchHeader: Filter: "${widget.currentFilter}", Filtered: ${widget.filteredCount}, Selected: ${widget.selectedCount}');

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF374151).withValues(alpha: 0.9),
                      const Color(0xFF1F2937).withValues(alpha: 0.8),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.95),
                      const Color(0xFFF8FAFC).withValues(alpha: 0.9),
                    ],
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              // ========== SEARCH AND CONTROLS ROW ==========
              _buildSearchControlsRow(isDark),

              // ========== STATISTICS ROW ==========
              _buildStatisticsRow(isDark),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the main search controls row
  Widget _buildSearchControlsRow(bool isDark) {
    debugPrint('🔍 CategorySearchHeader: Building search controls row');

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          // ========== BACK BUTTON (OPTIONAL) ==========
          if (widget.showBackButton) ...[
            _buildBackButton(isDark),
            SizedBox(width: 12.w),
          ],

          // ========== SEARCH FIELD (EXPANDABLE) ==========
          Expanded(child: _buildSearchField(isDark)),

          SizedBox(width: 12.w),

          // ========== FILTER BUTTON ==========
          _buildFilterButton(isDark),

          SizedBox(width: 8.w),

          // ========== RESULTS COUNT BADGE ==========
          _buildResultsBadge(isDark),
        ],
      ),
    );
  }

  /// Build back navigation button
  Widget _buildBackButton(bool isDark) {
    debugPrint('🔍 CategorySearchHeader: Building back button');

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.15),
            Theme.of(context).primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: IconButton(
        onPressed: () {
          debugPrint('⬅️ CategorySearchHeader: Back button pressed');
          HapticFeedback.lightImpact();
          widget.onBackPressed?.call();
        },
        icon: Icon(
          LineIcons.arrowLeft,
          size: 20.sp,
          color: Theme.of(context).primaryColor,
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

  /// Build the main search field
  Widget _buildSearchField(bool isDark) {
    debugPrint('🔍 CategorySearchHeader: Building search field');

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF1F2937).withValues(alpha: 0.8),
                  const Color(0xFF374151).withValues(alpha: 0.6),
                ]
              : [
                  Colors.white.withValues(alpha: 0.9),
                  const Color(0xFFF8FAFC).withValues(alpha: 0.7),
                ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: widget.searchController,
        style: TextStyle(
          fontSize: 15.sp,
          color: isDark ? Colors.white : const Color(0xFF2D3748),
        ),
        decoration: InputDecoration(
          hintText: 'Search categories...',
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[500] : Colors.grey[400],
            fontSize: 14.sp,
          ),
          prefixIcon: Container(
            padding: EdgeInsets.all(10.w),
            child: Icon(
              LineIcons.search,
              color: Theme.of(context).primaryColor,
              size: 18.sp,
            ),
          ),
          suffixIcon: widget.searchController.text.isNotEmpty ? _buildClearSearchButton() : null,
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

  /// Build clear search button
  Widget _buildClearSearchButton() {
    return Container(
      margin: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: IconButton(
        onPressed: () {
          debugPrint('🗑️ CategorySearchHeader: Clear search button pressed');
          widget.searchController.clear();
          HapticFeedback.lightImpact();
        },
        icon: Icon(
          LineIcons.times,
          color: Colors.grey[600],
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

  /// Build filter button with state indicator
  Widget _buildFilterButton(bool isDark) {
    final bool hasActiveFilter = widget.currentFilter != 'all';

    debugPrint('🔍 CategorySearchHeader: Building filter button (hasActiveFilter: $hasActiveFilter)');

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: hasActiveFilter
              ? [
                  Theme.of(context).primaryColor.withValues(alpha: 0.2),
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
                ]
              : isDark
                  ? [
                      const Color(0xFF374151).withValues(alpha: 0.8),
                      const Color(0xFF1F2937).withValues(alpha: 0.6),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.9),
                      const Color(0xFFF8FAFC).withValues(alpha: 0.7),
                    ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: hasActiveFilter
              ? Theme.of(context).primaryColor.withValues(alpha: 0.3)
              : isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey.withValues(alpha: 0.2),
          width: hasActiveFilter ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: hasActiveFilter
                ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                : isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
              LineIcons.filter,
              size: 18.sp,
              color: hasActiveFilter
                  ? Theme.of(context).primaryColor
                  : isDark
                      ? Colors.grey[400]
                      : Colors.grey[600],
            ),
            if (hasActiveFilter)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
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

  /// Build results count badge
  Widget _buildResultsBadge(bool isDark) {
    debugPrint('🔍 CategorySearchHeader: Building results badge (count: ${widget.filteredCount})');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (isDark ? const Color(0xFF10B981) : const Color(0xFF059669)).withValues(alpha: 0.15),
            (isDark ? const Color(0xFF10B981) : const Color(0xFF059669)).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: (isDark ? const Color(0xFF10B981) : const Color(0xFF059669)).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LineIcons.barChartAlt,
            size: 12.sp,
            color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
          ),
          SizedBox(width: 4.w),
          Text(
            '${widget.filteredCount}',
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Build statistics row with counts
  Widget _buildStatisticsRow(bool isDark) {
    debugPrint('🔍 CategorySearchHeader: Building statistics row');

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total',
              widget.totalCount.toString(),
              LineIcons.database,
              isDark ? const Color(0xFF6366F1) : const Color(0xFF4F46E5),
              isDark,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              'Active',
              widget.activeCount.toString(),
              LineIcons.checkCircle,
              isDark ? const Color(0xFF10B981) : const Color(0xFF059669),
              isDark,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              'Inactive',
              widget.inactiveCount.toString(),
              LineIcons.pauseCircle,
              isDark ? const Color(0xFFF59E0B) : const Color(0xFFD97706),
              isDark,
            ),
          ),
          if (widget.selectedCount > 0) ...[
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                'Selected',
                widget.selectedCount.toString(),
                LineIcons.checkSquare,
                isDark ? const Color(0xFF8B5CF6) : const Color(0xFF7C3AED),
                isDark,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build individual statistic card
  Widget _buildStatCard(String label, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: color,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
