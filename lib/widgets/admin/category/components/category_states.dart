import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';

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
/// - Theme-aware design
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

class _CategoryLoadingStateState extends State<CategoryLoadingState>
    with TickerProviderStateMixin {
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    debugPrint(
        '⏳ CategoryLoadingState: Building loading state (isDark: $isDark)');

    final primaryColor =
        isDark ? const Color(0xFF6366F1) : const Color(0xFF4F46E5);
    final backgroundColor = isDark ? const Color(0xFF1F2937) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final secondaryTextColor =
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

    return Center(
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
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
                            primaryColor.withValues(alpha: 0.2),
                            primaryColor.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: primaryColor.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Prbal.layers5,
                        size: 36.sp,
                        color: primaryColor,
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
                color: textColor,
                letterSpacing: -0.2,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              'Please wait while we fetch the latest category data',
              style: TextStyle(
                fontSize: 14.sp,
                color: secondaryTextColor,
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
                    final animationValue =
                        (_pulseController.value + delay) % 1.0;
                    final opacity =
                        (1.0 - (animationValue * 2 - 1).abs()).clamp(0.3, 1.0);

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: opacity),
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

class _CategoryErrorStateState extends State<CategoryErrorState>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint(
        '❌ CategoryErrorState: Initializing error state with message: "${widget.errorMessage}"');

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    debugPrint('❌ CategoryErrorState: Building error state (isDark: $isDark)');

    final errorColor =
        isDark ? const Color(0xFFF87171) : const Color(0xFFEF4444);
    final backgroundColor = isDark ? const Color(0xFF1F2937) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final secondaryTextColor =
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

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
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: errorColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: errorColor.withValues(alpha: 0.1),
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
                          errorColor.withValues(alpha: 0.2),
                          errorColor.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: errorColor.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Prbal.exclamationTriangle,
                      size: 36.sp,
                      color: errorColor,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Error title
                  Text(
                    'Failed to Load Categories',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
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
                      color: secondaryTextColor,
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
                              errorColor,
                              errorColor.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              debugPrint(
                                  '🔄 CategoryErrorState: Retry button tapped');
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

class _CategoryEmptyStateState extends State<CategoryEmptyState>
    with SingleTickerProviderStateMixin {
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    debugPrint('📭 CategoryEmptyState: Building empty state (isDark: $isDark)');

    final primaryColor =
        isDark ? const Color(0xFF6366F1) : const Color(0xFF4F46E5);
    final backgroundColor = isDark ? const Color(0xFF1F2937) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final secondaryTextColor =
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

    return Center(
      child: Container(
        margin: EdgeInsets.all(24.w),
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Floating illustration
            AnimatedBuilder(
              animation: _floatAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -10 * _floatAnimation.value),
                  child: Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primaryColor.withValues(alpha: 0.2),
                          primaryColor.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30.r),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Prbal.folderOpen,
                      size: 48.sp,
                      color: primaryColor.withValues(alpha: 0.7),
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
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: textColor,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 12.h),

            // Empty state description
            Text(
              'Get started by creating your first service category.\nCategories help organize your services.',
              style: TextStyle(
                fontSize: 15.sp,
                color: secondaryTextColor,
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
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor,
                        primaryColor.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        debugPrint(
                            '➕ CategoryEmptyState: Create category button tapped');
                        HapticFeedback.mediumImpact();
                        widget.onCreateCategory?.call();
                      },
                      borderRadius: BorderRadius.circular(16.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 28.w,
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
                                letterSpacing: -0.2,
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

class _CategoryStatisticCardsState extends State<CategoryStatisticCards>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    debugPrint('📊 CategoryStatisticCards: Initializing statistic cards');
    debugPrint(
        '📊 Total: ${widget.totalCount}, Active: ${widget.activeCount}, Inactive: ${widget.inactiveCount}');

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    debugPrint('📊 CategoryStatisticCards: Building statistic cards');

    final statCards = [
      _StatCardData(
        label: 'Total',
        value: widget.totalCount.toString(),
        icon: Prbal.layers5,
        color: const Color(0xFF6366F1),
      ),
      _StatCardData(
        label: 'Active',
        value: widget.activeCount.toString(),
        icon: Prbal.checkCircle,
        color: const Color(0xFF10B981),
      ),
      _StatCardData(
        label: 'Inactive',
        value: widget.inactiveCount.toString(),
        icon: Prbal.pauseCircle,
        color: const Color(0xFFF59E0B),
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
                      isDark,
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
    bool isDark,
  ) {
    final backgroundColor = isDark ? const Color(0xFF1F2937) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtitleColor =
        isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1.5,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.05),
            backgroundColor,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon container
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.2),
                  color.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              size: 24.sp,
              color: color,
            ),
          ),

          SizedBox(height: 12.h),

          // Value
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: -0.5,
            ),
          ),

          SizedBox(height: 4.h),

          // Label
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: subtitleColor,
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
