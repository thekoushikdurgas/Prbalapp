import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// ====================================================================
/// CATEGORY STATE COMPONENTS
/// ====================================================================
///
/// **Purpose**: Reusable state components for different loading states
///
/// **Components Included**:
/// - CategoryLoadingState: Modern loading indicator with animations
/// - CategoryErrorState: Error state with retry functionality
/// - CategoryEmptyState: Empty state with call-to-action
/// - CategoryStatisticCards: Statistics overview cards
///
/// **Features**:
/// - Consistent Material Design 3.0 styling
/// - **ENHANCED**: Centralized ThemeManager integration
/// - Smooth animations and transitions
/// - Comprehensive debug logging
/// - Accessibility support
/// ====================================================================

/// Loading state component with modern animations
class CategoryLoadingState extends StatefulWidget {
  const CategoryLoadingState({super.key});

  @override
  State<CategoryLoadingState> createState() => _CategoryLoadingStateState();
}

class _CategoryLoadingStateState extends State<CategoryLoadingState> with TickerProviderStateMixin, ThemeAwareMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint('⏳ CategoryLoadingState: Initializing loading animations');

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.linear,
    ));

    _pulseController.repeat(reverse: true);
    _rotateController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    // ========== ENHANCED THEME INTEGRATION ==========
    final themeManager = ThemeManager.of(context);
    themeManager.logThemeInfo();

    debugPrint('⏳ CategoryLoadingState: Building loading state with ThemeManager');
    debugPrint('⏳ CategoryLoadingState: Theme brightness: ${themeManager.themeManager ? 'dark' : 'light'}');

    return Center(
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: themeManager.surfaceGradient,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: themeManager.elevatedShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated loading icon
            AnimatedBuilder(
              animation: Listenable.merge([_pulseAnimation, _rotateAnimation]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Transform.rotate(
                    angle: _rotateAnimation.value * 2 * 3.14159,
                    child: Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            themeManager.primaryColor.withValues(alpha: 51),
                            themeManager.primaryColor.withValues(alpha: 26),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: themeManager.primaryColor.withValues(alpha: 77),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Prbal.layers5,
                        size: 36.sp,
                        color: themeManager.primaryColor,
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 24.h),

            // Loading text
            Text(
              'Loading Categories',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: themeManager.textPrimary,
                letterSpacing: -0.2,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              'Please wait while we fetch the latest category data',
              style: TextStyle(
                fontSize: 14.sp,
                color: themeManager.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 24.h),

            // Loading dots indicator
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final delay = index * 0.3;
                    final animationValue = (_pulseController.value + delay) % 1.0;
                    final opacity = (1.0 - (animationValue * 2 - 1).abs()).clamp(0.3, 1.0);

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: themeManager.primaryColor.withValues(alpha: opacity),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('⏳ CategoryLoadingState: Disposing loading animations');
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }
}

/// Error state component with retry functionality
class CategoryErrorState extends StatefulWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const CategoryErrorState({
    super.key,
    required this.errorMessage,
    this.onRetry,
  });

  @override
  State<CategoryErrorState> createState() => _CategoryErrorStateState();
}

class _CategoryErrorStateState extends State<CategoryErrorState> with SingleTickerProviderStateMixin, ThemeAwareMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint('❌ CategoryErrorState: Initializing error state with message: "${widget.errorMessage}"');

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _shakeController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ========== ENHANCED THEME INTEGRATION ==========
    final themeManager = ThemeManager.of(context);

    debugPrint('❌ CategoryErrorState: Building error state with ThemeManager');
    debugPrint('❌ CategoryErrorState: Theme brightness: ${themeManager.themeManager ? 'dark' : 'light'}');

    return Center(
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              20 * _shakeAnimation.value * (1 - _shakeAnimation.value) * 4,
              0,
            ),
            child: Container(
              margin: EdgeInsets.all(24.w),
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: themeManager.surfaceGradient,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: themeManager.errorColor.withValues(alpha: 77),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: themeManager.errorColor.withValues(alpha: 26),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Error icon
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          themeManager.errorColor.withValues(alpha: 51),
                          themeManager.errorColor.withValues(alpha: 26),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: themeManager.errorColor.withValues(alpha: 77),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Prbal.exclamationTriangle,
                      size: 36.sp,
                      color: themeManager.errorColor,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Error title
                  Text(
                    'Failed to Load Categories',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: themeManager.textPrimary,
                      letterSpacing: -0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 12.h),

                  // Error message
                  Text(
                    widget.errorMessage,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: themeManager.textSecondary,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  if (widget.onRetry != null) ...[
                    SizedBox(height: 24.h),

                    // Retry button
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              themeManager.errorColor,
                              themeManager.errorColor.withValues(alpha: 204),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              debugPrint('🔄 CategoryErrorState: Retry button tapped');
                              HapticFeedback.mediumImpact();
                              widget.onRetry?.call();
                            },
                            borderRadius: BorderRadius.circular(12.r),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 12.h,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Prbal.redo,
                                    size: 18.sp,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Try Again',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('❌ CategoryErrorState: Disposing error state');
    _shakeController.dispose();
    super.dispose();
  }
}

/// Empty state component with call-to-action
class CategoryEmptyState extends StatefulWidget {
  final VoidCallback? onCreateCategory;

  const CategoryEmptyState({
    super.key,
    this.onCreateCategory,
  });

  @override
  State<CategoryEmptyState> createState() => _CategoryEmptyStateState();
}

class _CategoryEmptyStateState extends State<CategoryEmptyState> with SingleTickerProviderStateMixin, ThemeAwareMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint('📭 CategoryEmptyState: Initializing empty state');

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _floatAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    _floatController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    // ========== ENHANCED THEME INTEGRATION ==========
    final themeManager = ThemeManager.of(context);

    debugPrint('📭 CategoryEmptyState: Building empty state with ThemeManager');
    debugPrint('📭 CategoryEmptyState: Theme brightness: ${themeManager.themeManager ? 'dark' : 'light'}');

    return Center(
      child: Container(
        margin: EdgeInsets.all(24.w),
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          gradient: themeManager.surfaceGradient,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: themeManager.elevatedShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Floating empty icon
            AnimatedBuilder(
              animation: _floatAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, 10 * _floatAnimation.value),
                  child: Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          themeManager.primaryColor.withValues(alpha: 26),
                          themeManager.primaryColor.withValues(alpha: 13),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(
                        color: themeManager.primaryColor.withValues(alpha: 51),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Prbal.folderOpen,
                      size: 48.sp,
                      color: themeManager.primaryColor,
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 32.h),

            // Empty state title
            Text(
              'No Categories Found',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: themeManager.textPrimary,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12.h),

            // Empty state description
            Text(
              'Create your first category to organize your services and get started with managing your business offerings.',
              style: TextStyle(
                fontSize: 16.sp,
                color: themeManager.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            if (widget.onCreateCategory != null) ...[
              SizedBox(height: 32.h),

              // Create category button
              Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: themeManager.primaryGradient,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: themeManager.primaryColor.withValues(alpha: 51),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        debugPrint('➕ CategoryEmptyState: Create category button tapped');
                        HapticFeedback.lightImpact();
                        widget.onCreateCategory?.call();
                      },
                      borderRadius: BorderRadius.circular(16.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.w,
                          vertical: 16.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Prbal.plus,
                              size: 20.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'Create First Category',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('📭 CategoryEmptyState: Disposing empty state');
    _floatController.dispose();
    super.dispose();
  }
}

/// Statistics overview cards component
class CategoryStatisticCards extends StatefulWidget {
  final int totalCount;
  final int activeCount;
  final int inactiveCount;

  const CategoryStatisticCards({
    super.key,
    required this.totalCount,
    required this.activeCount,
    required this.inactiveCount,
  });

  @override
  State<CategoryStatisticCards> createState() => _CategoryStatisticCardsState();
}

class _CategoryStatisticCardsState extends State<CategoryStatisticCards> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    debugPrint('📊 CategoryStatisticCards: Initializing statistic cards');
    debugPrint('📊 Total: ${widget.totalCount}, Active: ${widget.activeCount}, Inactive: ${widget.inactiveCount}');

    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 600 + (index * 200)),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ));
    }).toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < _controllers.length; i++) {
        Future.delayed(Duration(milliseconds: i * 150), () {
          if (mounted) {
            _controllers[i].forward();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ========== ENHANCED THEME INTEGRATION ==========
    final themeManager = ThemeManager.of(context);
    themeManager.logThemeInfo();

    debugPrint('📊 CategoryStatisticCards: Building statistic cards with comprehensive ThemeManager');
    debugPrint('📊 CategoryStatisticCards: → Primary: ${themeManager.primaryColor}');
    debugPrint('📊 CategoryStatisticCards: → Background: ${themeManager.backgroundColor}');
    debugPrint('📊 CategoryStatisticCards: → Surface: ${themeManager.surfaceColor}');

    final statCards = [
      _StatCardData(
        label: 'Total',
        value: widget.totalCount.toString(),
        icon: Prbal.layers5,
        color: themeManager.primaryColor,
      ),
      _StatCardData(
        label: 'Active',
        value: widget.activeCount.toString(),
        icon: Prbal.checkCircle,
        color: themeManager.successColor,
      ),
      _StatCardData(
        label: 'Inactive',
        value: widget.inactiveCount.toString(),
        icon: Prbal.pauseCircle,
        color: themeManager.warningColor,
      ),
    ];

    return Row(
      children: statCards.asMap().entries.map((entry) {
        final index = entry.key;
        final statCard = entry.value;

        return Expanded(
          child: AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Transform.scale(
                scale: _animations[index].value,
                child: Transform.translate(
                  offset: Offset(
                    0,
                    50 * (1 - _animations[index].value),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: index < statCards.length - 1 ? 12.w : 0,
                    ),
                    child: _buildStatCard(
                      statCard.label,
                      statCard.value,
                      statCard.icon,
                      statCard.color,
                      themeManager,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    ThemeManager themeManager,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.cardBackground,
              themeManager.surfaceElevated,
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.cardBackground,
              themeManager.backgroundTertiary,
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: color.withValues(alpha: 51),
          width: 1.5,
        ),
        boxShadow: [
          ...themeManager.subtleShadow,
          BoxShadow(
            color: color.withValues(alpha: 26),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon container with enhanced theming
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 51),
                  color.withValues(alpha: 26),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 26),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 24.sp,
              color: color,
            ),
          ),

          SizedBox(height: 12.h),

          // Value with enhanced typography
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: themeManager.textPrimary,
              letterSpacing: -0.5,
            ),
          ),

          SizedBox(height: 4.h),

          // Label with theme-aware styling
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: themeManager.textSecondary,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('📊 CategoryStatisticCards: Disposing statistic cards');
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class _StatCardData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCardData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}
