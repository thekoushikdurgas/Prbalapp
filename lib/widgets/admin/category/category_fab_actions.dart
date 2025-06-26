import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// CategoryFabActions - Floating Action Button components with comprehensive ThemeManager integration
///
/// **Purpose**: Provides floating action buttons for category operations with complete ThemeManager theming
///
/// **Key Features**:
/// - Complete ThemeManager integration with all color properties and gradients
/// - Advanced gradient theming with background, surface, primary, secondary, and accent gradients
/// - Theme-aware shadows (primary, elevated, subtle) and glass morphism effects
/// - Add category FAB with enhanced styling and premium visual effects
/// - Bulk actions FAB with comprehensive theming and semantic color usage
/// - Modern Material Design 3.0 styling with dynamic theme adaptation
/// - Enhanced animations, haptic feedback, and visual hierarchy
/// - Comprehensive debug logging for theme operations and performance tracking
/// - Smart visual indicators with theme-consistent styling and semantic colors
/// - Advanced bottom sheet design with glass morphism and gradient backgrounds
/// - Context-aware action tiles with ThemeManager semantic theming
class CategoryFabActions extends StatefulWidget with ThemeAwareMixin {
  final bool hasSelection;
  final int selectedCount;
  final VoidCallback onAddCategory;
  final VoidCallback? onBulkActivate;
  final VoidCallback? onBulkDeactivate;
  final VoidCallback? onBulkExport;
  final VoidCallback? onBulkDelete;
  final Animation<double>? scaleAnimation;

  const CategoryFabActions({
    super.key,
    required this.hasSelection,
    required this.selectedCount,
    required this.onAddCategory,
    this.onBulkActivate,
    this.onBulkDeactivate,
    this.onBulkExport,
    this.onBulkDelete,
    this.scaleAnimation,
  });

  @override
  State<CategoryFabActions> createState() => _CategoryFabActionsState();
}

class _CategoryFabActionsState extends State<CategoryFabActions>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.05).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.elasticOut),
    );

    // Start animations for enhanced visual feedback
    _pulseController.repeat(reverse: true);

    if (widget.hasSelection) {
      _rotateController.forward();
    }
  }

  @override
  void didUpdateWidget(CategoryFabActions oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update animations based on selection state
    if (widget.hasSelection != oldWidget.hasSelection) {
      if (widget.hasSelection) {
        _rotateController.forward();
      } else {
        _rotateController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    // Comprehensive debug logging for theme operations

    debugPrint(
        '🚀 CategoryFabActions: Building enhanced FAB with comprehensive ThemeManager integration');
    debugPrint(
        '🎨 CategoryFabActions: Theme mode: ${themeManager.themeManager ? 'dark' : 'light'}');
    debugPrint(
        '🚀 CategoryFabActions: hasSelection: ${widget.hasSelection}, selectedCount: ${widget.selectedCount}');
    debugPrint(
        '🌈 CategoryFabActions: Using gradients - Primary: ${themeManager.primaryGradient.colors.length} colors, Surface: ${themeManager.surfaceGradient.colors.length} colors');

    final fabWidget = widget.hasSelection
        ? _buildEnhancedBulkActionsFAB(context, themeManager)
        : _buildEnhancedAddCategoryFAB(context, themeManager);

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _rotateAnimation]),
      builder: (context, child) {
        Widget finalWidget = Transform.scale(
          scale: _pulseAnimation.value,
          child: Transform.rotate(
            angle: widget.hasSelection ? _rotateAnimation.value : 0.0,
            child: fabWidget,
          ),
        );

        if (widget.scaleAnimation != null) {
          finalWidget = ScaleTransition(
            scale: widget.scaleAnimation!,
            child: finalWidget,
          );
        }

        return finalWidget;
      },
    );
  }

  /// Build enhanced bulk actions floating action button with comprehensive ThemeManager styling
  Widget _buildEnhancedBulkActionsFAB(
      BuildContext context, ThemeManager themeManager) {
    debugPrint(
        '⚡ CategoryFabActions: Building enhanced bulk actions FAB for ${widget.selectedCount} selected categories');

    return Container(
      decoration: BoxDecoration(
        gradient: themeManager.primaryGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: themeManager.elevatedShadow,
        border: Border.all(
          color: themeManager.primaryColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          debugPrint('⚡ CategoryFabActions: Enhanced bulk actions FAB pressed');
          HapticFeedback.mediumImpact();
          _showEnhancedBulkActionsBottomSheet(context, themeManager);
        },
        backgroundColor: Colors.transparent,
        foregroundColor: themeManager.textInverted,
        elevation: 0,
        splashColor: themeManager.primaryColor.withValues(alpha: 0.2),
        icon: Container(
          padding: EdgeInsets.all(8.w),
          decoration: themeManager.enhancedGlassMorphism,
          child: Icon(
            Prbal.cog,
            size: 22.sp,
            color: themeManager.textInverted,
          ),
        ),
        label: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            gradient: themeManager.accent1Gradient,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: themeManager.subtleShadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 16.sp,
                color: themeManager.textInverted,
              ),
              SizedBox(width: 6.w),
              Text(
                '${widget.selectedCount}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: themeManager.textInverted,
                ),
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }

  /// Build enhanced add category floating action button with comprehensive ThemeManager styling
  Widget _buildEnhancedAddCategoryFAB(
      BuildContext context, ThemeManager themeManager) {
    debugPrint(
        '➕ CategoryFabActions: Building enhanced add category FAB with comprehensive theming');

    return Container(
      decoration: BoxDecoration(
        gradient: themeManager.secondaryGradient,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: themeManager.elevatedShadow,
        border: Border.all(
          color: themeManager.secondaryColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: FloatingActionButton(
        onPressed: () {
          debugPrint('➕ CategoryFabActions: Enhanced add category FAB pressed');
          HapticFeedback.lightImpact();
          widget.onAddCategory();
        },
        backgroundColor: Colors.transparent,
        foregroundColor: themeManager.textInverted,
        elevation: 0,
        splashColor: themeManager.secondaryColor.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Stack(
          children: [
            // Glass morphism background
            Positioned.fill(
              child: Container(
                decoration: themeManager.glassMorphism,
              ),
            ),

            // Main icon with enhanced styling
            Center(
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  gradient: themeManager.accent3Gradient,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: themeManager.subtleShadow,
                ),
                child: Icon(
                  Prbal.plus,
                  size: 20.sp,
                  color: themeManager.textInverted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show enhanced bulk actions bottom sheet with comprehensive ThemeManager integration
  void _showEnhancedBulkActionsBottomSheet(
      BuildContext context, ThemeManager themeManager) {
    debugPrint(
        '⚡ CategoryFabActions: Showing enhanced bulk actions bottom sheet with comprehensive ThemeManager');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      showDragHandle: false,
      isDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: themeManager.surfaceGradient,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          border: Border.all(
            color: themeManager.borderColor,
            width: 1.5,
          ),
          boxShadow: themeManager.elevatedShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Enhanced drag handle with theming
            _buildEnhancedDragHandle(themeManager),

            // Enhanced header with comprehensive styling
            _buildEnhancedHeader(context, themeManager),

            // Enhanced action options with full theming
            _buildEnhancedActionOptions(context, themeManager),
          ],
        ),
      ),
    );
  }

  /// Build enhanced drag handle with comprehensive ThemeManager styling
  Widget _buildEnhancedDragHandle(ThemeManager themeManager) {
    return Container(
      margin: EdgeInsets.only(top: 16.h, bottom: 12.h),
      child: Column(
        children: [
          // Main drag handle
          Container(
            width: 48.w,
            height: 6.h,
            decoration: BoxDecoration(
              gradient: themeManager.neutralGradient,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: themeManager.subtleShadow,
            ),
          ),

          SizedBox(height: 8.h),

          // Enhanced close indicator
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: themeManager.glassMorphism,
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: themeManager.textTertiary,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  /// Build enhanced header with comprehensive ThemeManager styling
  Widget _buildEnhancedHeader(BuildContext context, ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 20.h),
      decoration: BoxDecoration(
        gradient: themeManager.backgroundGradient,
        border: Border(
          bottom: BorderSide(
            color: themeManager.borderColor,
            width: 1.5,
          ),
        ),
        boxShadow: themeManager.subtleShadow,
      ),
      child: Row(
        children: [
          // Enhanced icon container with glass morphism
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: themeManager.enhancedGlassMorphism,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                gradient: themeManager.primaryGradient,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: themeManager.subtleShadow,
              ),
              child: Icon(
                Prbal.cog,
                color: themeManager.textInverted,
                size: 24.sp,
              ),
            ),
          ),

          SizedBox(width: 20.w),

          // Enhanced text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    gradient: themeManager.accent2Gradient,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: themeManager.subtleShadow,
                  ),
                  child: Text(
                    'Bulk Actions',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: themeManager.textInverted,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: themeManager.surfaceElevated,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: themeManager.borderColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.category_rounded,
                        size: 14.sp,
                        color: themeManager.accent1,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '${widget.selectedCount} categories selected',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: themeManager.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Enhanced close button
          Container(
            decoration: BoxDecoration(
              gradient: themeManager.neutralGradient,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: themeManager.subtleShadow,
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Prbal.cross,
                color: themeManager.textInverted,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build enhanced action options with comprehensive ThemeManager integration
  Widget _buildEnhancedActionOptions(
      BuildContext context, ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 32.h),
      decoration: BoxDecoration(
        gradient: themeManager.backgroundGradient,
      ),
      child: Column(
        children: [
          // Section header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              gradient: themeManager.accent4Gradient,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: themeManager.subtleShadow,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.flash_on_rounded,
                  color: themeManager.textInverted,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: themeManager.textInverted,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Enhanced action tiles
          _buildEnhancedBulkActionTile(
            context,
            'Activate All',
            'Set all selected categories as active',
            Prbal.checkCircle,
            themeManager.successGradient,
            themeManager.successColor,
            themeManager,
            widget.onBulkActivate,
          ),
          SizedBox(height: 16.h),
          _buildEnhancedBulkActionTile(
            context,
            'Deactivate All',
            'Set all selected categories as inactive',
            Prbal.pauseCircle,
            themeManager.warningGradient,
            themeManager.warningColor,
            themeManager,
            widget.onBulkDeactivate,
          ),
          SizedBox(height: 16.h),
          _buildEnhancedBulkActionTile(
            context,
            'Export Selected',
            'Export selected categories data',
            Prbal.download,
            themeManager.infoGradient,
            themeManager.infoColor,
            themeManager,
            widget.onBulkExport,
          ),
          SizedBox(height: 16.h),
          _buildEnhancedBulkActionTile(
            context,
            'Delete All',
            'Permanently delete all selected categories',
            Prbal.trash,
            themeManager.errorGradient,
            themeManager.errorColor,
            themeManager,
            widget.onBulkDelete,
          ),

          SizedBox(height: 16.h),

          // Enhanced footer with theme info
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: themeManager.glassMorphism,
            child: Row(
              children: [
                Icon(
                  Icons.info_rounded,
                  size: 14.sp,
                  color: themeManager.textTertiary,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Actions will be applied to all selected categories',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: themeManager.textTertiary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build enhanced bulk action tile with comprehensive ThemeManager styling
  Widget _buildEnhancedBulkActionTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    LinearGradient gradient,
    Color iconColor,
    ThemeManager themeManager,
    VoidCallback? onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: themeManager.elevatedShadow,
        border: Border.all(
          color: iconColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap != null
              ? () {
                  debugPrint(
                      '⚡ CategoryFabActions: Enhanced bulk action "$title" pressed');
                  Navigator.of(context).pop();
                  HapticFeedback.lightImpact();
                  onTap();
                }
              : null,
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                // Enhanced icon container with glass morphism
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: themeManager.enhancedGlassMorphism,
                  child: Icon(
                    icon,
                    color: themeManager.textInverted,
                    size: 24.sp,
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
                          color: themeManager.textInverted,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color:
                              themeManager.textInverted.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: themeManager.textInverted
                                .withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Enhanced arrow indicator
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: themeManager.textInverted.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Prbal.angleRight,
                    color: themeManager.textInverted,
                    size: 18.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }
}
