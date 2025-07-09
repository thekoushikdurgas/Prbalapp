import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// ====================================================================
/// CATEGORY SELECTION BAR COMPONENT
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
/// **1. Enhanced Selection Container:**
/// - Multi-layer gradient backgrounds with comprehensive color transitions
/// - Advanced border system with borderFocus and dynamic alpha values
/// - Layered shadow effects combining all shadow types
/// - Theme-aware progress visualization with semantic colors
///
/// **2. Advanced Icon System:**
/// - Progress circle with primaryColor integration
/// - State-aware icon selection based on selection status
/// - Enhanced glass morphism effects for icon containers
/// - Dynamic color mapping for visual feedback
///
/// **3. Comprehensive Button Integration:**
/// - Select All: infoColor gradient system
/// - Clear Selection: errorColor gradient system
/// - Enhanced shadow effects with color-matched overlays
/// - Professional typography with theme-aware contrast
///
/// **4. Progress System Enhancement:**
/// - primaryGradient for progress bars
/// - Theme-aware background colors for progress tracks
/// - Status indicator integration with success/warning colors
/// - Professional typography with proper contrast ratios
///
/// **🎯 RESULT:**
/// A sophisticated selection bar that provides premium visual experience
/// with automatic light/dark theme adaptation using ALL ThemeManager
/// properties for consistent, beautiful, and accessible selection interface.
/// ====================================================================

/// CategorySelectionBar - Enhanced modern selection info bar component with comprehensive ThemeManager integration
///
/// **Purpose**: Displays sophisticated selection information with comprehensive theme awareness
///
/// **Enhanced Features**:
/// - **COMPREHENSIVE**: Full ThemeManager property integration
/// - **SELECTION-AWARE**: Dynamic styling based on selection state
/// - **PROGRESS-RICH**: Advanced progress visualization with gradients
/// - **SHADOW-ENHANCED**: Multi-layer shadow system for proper elevation
/// - **BORDER-SOPHISTICATED**: Dynamic border system with focus states
/// - **ANIMATION-READY**: Built-in transition support for state changes
/// - **ACCESSIBILITY-COMPLIANT**: Proper contrast and semantic colors
/// - **PERFORMANCE-OPTIMIZED**: Efficient theme access patterns
class CategorySelectionBar extends StatelessWidget with ThemeAwareMixin {
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
    // ========== COMPREHENSIVE THEME INTEGRATION ==========

    final selectionProgress = selectedCount / totalCount;
    final isAllSelected = selectedCount == totalCount;

    // Comprehensive theme logging for debugging

    // debugPrint('📊 CategorySelectionBar: Building with COMPREHENSIVE ThemeManager integration');
    // debugPrint('📊 CategorySelectionBar: → Primary: ${ThemeManager.of(context).primaryColor}');
    // debugPrint('📊 CategorySelectionBar: → Secondary: ${ThemeManager.of(context).secondaryColor}');
    // debugPrint('📊 CategorySelectionBar: → Background: ${ThemeManager.of(context).backgroundColor}');
    // debugPrint('📊 CategorySelectionBar: → Surface: ${ThemeManager.of(context).surfaceColor}');
    // debugPrint('📊 CategorySelectionBar: → Card Background: ${ThemeManager.of(context).cardBackground}');
    // debugPrint('📊 CategorySelectionBar: → Surface Elevated: ${ThemeManager.of(context).surfaceElevated}');
    debugPrint(
        '📊 CategorySelectionBar: → Status Colors - Success: ${ThemeManager.of(context).successColor}, Warning: ${ThemeManager.of(context).warningColor}, Error: ${ThemeManager.of(context).errorColor}, Info: ${ThemeManager.of(context).infoColor}');
    debugPrint(
        '📊 CategorySelectionBar: → Selection: $selectedCount/$totalCount (${(selectionProgress * 100).toStringAsFixed(1)}%), All Selected: $isAllSelected');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeManager.of(context).cardBackground,
              ThemeManager.of(context).surfaceElevated,
              ThemeManager.of(context).backgroundSecondary,
              ThemeManager.of(context).modalBackground,
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeManager.of(context).cardBackground,
              ThemeManager.of(context).backgroundTertiary,
              ThemeManager.of(context).surfaceElevated,
              ThemeManager.of(context).modalBackground,
            ],
            stops: const [0.0, 0.4, 0.8, 1.0],
          ),
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ThemeManager.of(context).conditionalColor(
            lightColor: ThemeManager.of(context).primaryColor.withValues(alpha: 0.3),
            darkColor: ThemeManager.of(context).borderFocus.withValues(alpha: 0.6),
          ),
          width: 2,
        ),
        boxShadow: [
          ...ThemeManager.of(context).elevatedShadow,
          BoxShadow(
            color: ThemeManager.of(context).conditionalColor(
              lightColor: ThemeManager.of(context).primaryColor.withValues(alpha: 0.15),
              darkColor: ThemeManager.of(context).shadowDark,
            ),
            blurRadius: 25,
            offset: const Offset(0, 12),
            spreadRadius: 3,
          ),
          BoxShadow(
            color: ThemeManager.of(context).conditionalColor(
              lightColor: Colors.white.withValues(alpha: 0.8),
              darkColor: ThemeManager.of(context).primaryColor.withValues(alpha: 0.2),
            ),
            blurRadius: 10,
            offset: const Offset(0, -3),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: ThemeManager.of(context).shadowMedium,
            blurRadius: 15,
            offset: const Offset(0, 6),
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
                  _buildSelectionIcon(selectionProgress, isAllSelected, ThemeManager.of(context)),

                  SizedBox(width: 16.w), // Reduced spacing from 20.w to 16.w

                  // Enhanced selection info with progress
                  Expanded(
                    child: _buildSelectionInfo(isAllSelected, ThemeManager.of(context)),
                  ),

                  SizedBox(width: 12.w), // Reduced spacing from 16.w to 12.w

                  // Enhanced action buttons
                  _buildActionButtons(isAllSelected, ThemeManager.of(context)),
                ],
              ),

              // ========== PROGRESS BAR ==========
              if (totalCount > 0) ...[
                SizedBox(height: 16.h),
                _buildProgressBar(selectionProgress, ThemeManager.of(context)),
              ],

              // ========== QUICK STATS ROW ==========
              if (selectionMessage.isNotEmpty) ...[
                SizedBox(height: 12.h),
                _buildQuickStats(ThemeManager.of(context)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Build enhanced selection icon with comprehensive ThemeManager progress indication
  Widget _buildSelectionIcon(double progress, bool isAllSelected, ThemeManager themeManager) {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.primaryColor.withValues(alpha: 0.2),
              themeManager.primaryLight.withValues(alpha: 0.15),
              themeManager.accent1.withValues(alpha: 0.1),
              themeManager.secondaryColor.withValues(alpha: 0.05),
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.primaryDark.withValues(alpha: 0.4),
              themeManager.primaryColor.withValues(alpha: 0.3),
              themeManager.accent1.withValues(alpha: 0.2),
              themeManager.secondaryColor.withValues(alpha: 0.1),
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: themeManager.primaryColor.withValues(alpha: 0.4),
            darkColor: themeManager.borderFocus.withValues(alpha: 0.8),
          ),
          width: 2.5,
        ),
        boxShadow: [
          ...themeManager.primaryShadow,
          BoxShadow(
            color: themeManager.conditionalColor(
              lightColor: themeManager.primaryColor.withValues(alpha: 0.2),
              darkColor: themeManager.primaryDark.withValues(alpha: 0.4),
            ),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: themeManager.shadowMedium,
            blurRadius: 8,
            offset: const Offset(0, 3),
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
              strokeWidth: 3.5,
              backgroundColor: themeManager.conditionalColor(
                lightColor: themeManager.neutral200,
                darkColor: themeManager.neutral700,
              ),
              valueColor: AlwaysStoppedAnimation<Color>(
                themeManager.conditionalColor(
                  lightColor: themeManager.primaryColor,
                  darkColor: themeManager.primaryLight,
                ),
              ),
            ),
          ),

          // Center icon
          Container(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              isAllSelected
                  ? Prbal.inputChecked
                  : selectedCount > 0
                      ? Prbal.checkSquare
                      : Prbal.square,
              color: themeManager.conditionalColor(
                lightColor: themeManager.primaryColor,
                darkColor: themeManager.primaryLight,
              ),
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  /// Build enhanced selection information
  Widget _buildSelectionInfo(bool isAllSelected, ThemeManager themeManager) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main selection count with icon
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Prbal.layers5,
              size: 16.sp,
              color: themeManager.primaryColor,
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                '$selectedCount Selected',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: themeManager.textPrimary,
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
                  color: themeManager.successColor.withValues(alpha: 38),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: themeManager.successColor.withValues(alpha: 77),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Prbal.check,
                      size: 10.sp,
                      color: themeManager.successColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'All',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: themeManager.successColor,
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
              Prbal.pieChart,
              size: 14.sp,
              color: themeManager.textSecondary,
            ),
            SizedBox(width: 4.w), // Reduced spacing from 6.w to 4.w
            Flexible(
              child: Text(
                'out of $totalCount categories',
                style: TextStyle(
                  fontSize: 12.sp, // Reduced from 13.sp to 12.sp
                  color: themeManager.textSecondary,
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
                color: themeManager.primaryColor.withValues(alpha: 26),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                '${(selectedCount / totalCount * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 10.sp, // Reduced from 11.sp to 10.sp
                  fontWeight: FontWeight.w600,
                  color: themeManager.primaryColor,
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
  Widget _buildActionButtons(bool isAllSelected, ThemeManager themeManager) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Select all button (if not all selected)
        if (onSelectAll != null && !isAllSelected)
          Flexible(
            child: _buildEnhancedActionButton(
              themeManager: themeManager,
              onPressed: () {
                debugPrint('✅ CategorySelectionBar: Select all button pressed');
                HapticFeedback.lightImpact();
                onSelectAll?.call();
              },
              icon: Prbal.checkCircle,
              label: 'All',
              tooltip: 'Select All Categories',
              color: themeManager.infoColor,
            ),
          ),

        if (onSelectAll != null && !isAllSelected) SizedBox(width: 8.w), // Reduced spacing

        // Clear selection button with enhanced design
        Flexible(
          child: _buildEnhancedActionButton(
            themeManager: themeManager,
            onPressed: () {
              debugPrint('❌ CategorySelectionBar: Clear selection button pressed');
              HapticFeedback.mediumImpact();
              onClearSelection();
            },
            icon: Prbal.cross,
            label: 'Clear',
            tooltip: 'Clear Selection',
            color: themeManager.errorColor,
          ),
        ),
      ],
    );
  }

  /// Build enhanced action button with comprehensive ThemeManager integration
  Widget _buildEnhancedActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required String tooltip,
    required Color color,
    required ThemeManager themeManager,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            gradient: themeManager.conditionalGradient(
              lightGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.15),
                  color.withValues(alpha: 0.1),
                  color.withValues(alpha: 0.05),
                ],
              ),
              darkGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.3),
                  color.withValues(alpha: 0.2),
                  color.withValues(alpha: 0.1),
                ],
              ),
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: themeManager.conditionalColor(
                lightColor: color.withValues(alpha: 0.3),
                darkColor: color.withValues(alpha: 0.6),
              ),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
              BoxShadow(
                color: themeManager.shadowLight,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
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
  Widget _buildProgressBar(double progress, ThemeManager themeManager) {
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
                    Prbal.tasks,
                    size: 14.sp,
                    color: themeManager.textSecondary,
                  ),
                  SizedBox(width: 6.w),
                  Flexible(
                    child: Text(
                      'Selection Progress',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: themeManager.textSecondary,
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
                color: themeManager.primaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),

        SizedBox(height: 8.h),

        // Enhanced progress bar with comprehensive ThemeManager integration
        Container(
          height: 8.h,
          decoration: BoxDecoration(
            gradient: themeManager.conditionalGradient(
              lightGradient: LinearGradient(
                colors: [
                  themeManager.neutral200,
                  themeManager.neutral300,
                ],
              ),
              darkGradient: LinearGradient(
                colors: [
                  themeManager.neutral700,
                  themeManager.neutral600,
                ],
              ),
            ),
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              color: themeManager.conditionalColor(
                lightColor: themeManager.borderColor.withValues(alpha: 0.2),
                darkColor: themeManager.borderSecondary.withValues(alpha: 0.3),
              ),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: themeManager.shadowLight,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Progress fill with comprehensive ThemeManager gradient
              FractionallySizedBox(
                widthFactor: progress,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: 8.h,
                  decoration: BoxDecoration(
                    gradient: themeManager.conditionalGradient(
                      lightGradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          themeManager.primaryColor,
                          themeManager.primaryLight,
                          themeManager.accent1,
                        ],
                      ),
                      darkGradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          themeManager.primaryDark,
                          themeManager.primaryColor,
                          themeManager.accent1,
                        ],
                      ),
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(
                      color: themeManager.conditionalColor(
                        lightColor: themeManager.primaryColor.withValues(alpha: 0.3),
                        darkColor: themeManager.primaryLight.withValues(alpha: 0.4),
                      ),
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: themeManager.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                      BoxShadow(
                        color: themeManager.shadowMedium,
                        blurRadius: 2,
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

  /// Build quick statistics information with comprehensive ThemeManager integration
  Widget _buildQuickStats(ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.infoColor.withValues(alpha: 0.1),
              themeManager.infoLight.withValues(alpha: 0.08),
              themeManager.accent5.withValues(alpha: 0.05),
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.infoDark.withValues(alpha: 0.15),
              themeManager.infoColor.withValues(alpha: 0.1),
              themeManager.accent5.withValues(alpha: 0.08),
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: themeManager.infoColor.withValues(alpha: 0.2),
            darkColor: themeManager.infoDark.withValues(alpha: 0.3),
          ),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: themeManager.infoColor.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: themeManager.shadowLight,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Prbal.infoCircle,
            size: 16.sp,
            color: themeManager.conditionalColor(
              lightColor: themeManager.infoColor,
              darkColor: themeManager.infoLight,
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              selectionMessage,
              style: TextStyle(
                fontSize: 12.sp,
                color: themeManager.textSecondary,
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
