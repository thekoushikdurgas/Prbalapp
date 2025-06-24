import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

/// CategorySelectionBar - Enhanced modern selection info bar component
///
/// **Purpose**: Displays selection information when categories are selected
///
/// **Key Features**:
/// - Enhanced dark/light theme support with improved contrast
/// - Multiple visual indicators and progress tracking
/// - Modern glassmorphism design with depth
/// - Rich iconography and visual hierarchy
/// - User-friendly actions with clear labels
/// - Smooth animations and haptic feedback
/// - Progress indicator for selection completion
/// - Enhanced accessibility features
class CategorySelectionBar extends StatelessWidget {
  final int selectedCount;
  final int totalCount;
  final VoidCallback onClearSelection;
  final VoidCallback? onSelectAll;
  final String selectionMessage;

  const CategorySelectionBar({
    super.key,
    required this.selectedCount,
    required this.totalCount,
    required this.onClearSelection,
    this.onSelectAll,
    this.selectionMessage = '',
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('📊 CategorySelectionBar: Building enhanced selection bar with $selectedCount/$totalCount selected');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final selectionProgress = selectedCount / totalCount;
    final isAllSelected = selectedCount == totalCount;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF2D3748).withValues(alpha: 0.98), // Brighter slate
                  const Color(0xFF1A202C).withValues(alpha: 0.98), // Brighter dark
                ]
              : [
                  Colors.white.withValues(alpha: 0.95),
                  const Color(0xFFF8FAFC).withValues(alpha: 0.95),
                ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark
              ? primaryColor.withValues(alpha: 0.6)
              : primaryColor.withValues(alpha: 0.3), // Brighter border in dark mode
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.6)
                : primaryColor.withValues(alpha: 0.15), // Deeper shadow in dark mode
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: isDark
                ? primaryColor.withValues(alpha: 0.2)
                : Colors.white.withValues(alpha: 0.8), // Brighter accent shadow
            blurRadius: 8,
            offset: const Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              // ========== MAIN SELECTION INFO ROW ==========
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Enhanced selection icon with animated progress
                  _buildSelectionIcon(isDark, primaryColor, selectionProgress, isAllSelected),

                  SizedBox(width: 16.w), // Reduced spacing from 20.w to 16.w

                  // Enhanced selection info with progress
                  Expanded(
                    child: _buildSelectionInfo(isDark, primaryColor, isAllSelected),
                  ),

                  SizedBox(width: 12.w), // Reduced spacing from 16.w to 12.w

                  // Enhanced action buttons
                  _buildActionButtons(isDark, primaryColor, isAllSelected),
                ],
              ),

              // ========== PROGRESS BAR ==========
              if (totalCount > 0) ...[
                SizedBox(height: 16.h),
                _buildProgressBar(isDark, primaryColor, selectionProgress),
              ],

              // ========== QUICK STATS ROW ==========
              if (selectionMessage.isNotEmpty) ...[
                SizedBox(height: 12.h),
                _buildQuickStats(isDark),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Build enhanced selection icon with progress indication
  Widget _buildSelectionIcon(bool isDark, Color primaryColor, double progress, bool isAllSelected) {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withValues(alpha: isDark ? 0.4 : 0.2), // Brighter gradient in dark mode
            primaryColor.withValues(alpha: isDark ? 0.2 : 0.05), // Enhanced secondary color
          ],
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: primaryColor.withValues(alpha: isDark ? 0.8 : 0.4), // Much brighter border in dark mode
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: isDark ? 0.4 : 0.2), // Brighter shadow in dark mode
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress circle
          SizedBox(
            width: 50.w,
            height: 50.w,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 3,
              backgroundColor: isDark
                  ? Colors.grey[600]!.withValues(alpha: 0.6)
                  : Colors.grey[300]!.withValues(alpha: 0.5), // Brighter background in dark mode
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),

          // Center icon
          Container(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              isAllSelected
                  ? LineIcons.checkSquareAlt
                  : selectedCount > 0
                      ? LineIcons.checkSquare
                      : LineIcons.square,
              color: primaryColor,
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  /// Build enhanced selection information
  Widget _buildSelectionInfo(bool isDark, Color primaryColor, bool isAllSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main selection count with icon
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LineIcons.layerGroup,
              size: 16.sp,
              color: primaryColor,
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                '$selectedCount Selected',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1F2937), // Ultra bright white text in dark mode
                  letterSpacing: -0.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isAllSelected) ...[
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LineIcons.check,
                      size: 10.sp,
                      color: Colors.green,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'All',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),

        SizedBox(height: 6.h),

        // Selection ratio with enhanced styling
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LineIcons.pieChart,
              size: 14.sp,
              color: isDark ? Colors.grey[300] : Colors.grey[600], // Brighter icon in dark mode
            ),
            SizedBox(width: 4.w), // Reduced spacing from 6.w to 4.w
            Flexible(
              child: Text(
                'out of $totalCount categories',
                style: TextStyle(
                  fontSize: 12.sp, // Reduced from 13.sp to 12.sp
                  color: isDark ? Colors.grey[300] : Colors.grey[600], // Brighter text in dark mode
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 6.w), // Reduced spacing from 8.w to 6.w
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h), // Reduced padding
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                '${(selectedCount / totalCount * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 10.sp, // Reduced from 11.sp to 10.sp
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build enhanced action buttons with better labels
  Widget _buildActionButtons(bool isDark, Color primaryColor, bool isAllSelected) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Select all button (if not all selected)
        if (onSelectAll != null && !isAllSelected)
          Flexible(
            child: _buildEnhancedActionButton(
              onPressed: () {
                debugPrint('✅ CategorySelectionBar: Select all button pressed');
                HapticFeedback.lightImpact();
                onSelectAll?.call();
              },
              icon: LineIcons.doubleCheck,
              label: 'All',
              tooltip: 'Select All Categories',
              color: Colors.blue,
              isDark: isDark,
            ),
          ),

        if (onSelectAll != null && !isAllSelected) SizedBox(width: 8.w), // Reduced spacing

        // Clear selection button with enhanced design
        Flexible(
          child: _buildEnhancedActionButton(
            onPressed: () {
              debugPrint('❌ CategorySelectionBar: Clear selection button pressed');
              HapticFeedback.mediumImpact();
              onClearSelection();
            },
            icon: LineIcons.times,
            label: 'Clear',
            tooltip: 'Clear Selection',
            color: isDark ? Colors.red[400]! : Colors.red[600]!,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  /// Build enhanced action button with label
  Widget _buildEnhancedActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required String tooltip,
    required Color color,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: isDark ? 0.3 : 0.15), // Brighter action button gradients
                color.withValues(alpha: isDark ? 0.15 : 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: color.withValues(alpha: isDark ? 0.6 : 0.3), // Brighter action button borders
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build progress bar with enhanced styling
  Widget _buildProgressBar(bool isDark, Color primaryColor, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar label
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LineIcons.tasks,
                    size: 14.sp,
                    color: isDark ? Colors.grey[300] : Colors.grey[600], // Brighter text in dark mode
                  ),
                  SizedBox(width: 6.w),
                  Flexible(
                    child: Text(
                      'Selection Progress',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.grey[300] : Colors.grey[600], // Brighter text in dark mode
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),

        SizedBox(height: 8.h),

        // Enhanced progress bar
        Container(
          height: 6.h,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.grey[600]!.withValues(alpha: 0.8)
                : Colors.grey[200]!.withValues(alpha: 0.8), // Brighter progress background
            borderRadius: BorderRadius.circular(3.r),
          ),
          child: Stack(
            children: [
              // Progress fill with gradient
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        primaryColor.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(3.r),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: isDark ? 0.6 : 0.4), // Brighter progress shadow
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build quick stats with icons
  Widget _buildQuickStats(bool isDark) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[700]!.withValues(alpha: 0.6)
            : Colors.grey[100]!.withValues(alpha: 0.8), // Brighter quick stats background
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark
              ? Colors.grey[600]!.withValues(alpha: 0.8)
              : Colors.grey[300]!.withValues(alpha: 0.5), // Brighter border
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LineIcons.infoCircle,
            size: 16.sp,
            color: isDark ? Colors.blue[300] : Colors.blue[600], // Brighter info icon in dark mode
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              selectionMessage,
              style: TextStyle(
                fontSize: 12.sp,
                color: isDark ? Colors.grey[200] : Colors.grey[700], // Brighter quick stats text
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
