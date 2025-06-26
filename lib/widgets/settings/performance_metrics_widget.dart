import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
// import 'package:prbal/widget/modern_ui_components.dart';

/// **THEMEMANAGER INTEGRATED** PerformanceMetricsWidget - Modern performance metrics display for admin users
///
/// **ThemeManager Features Integrated:**
/// - 🎨 Complete color system (primary, accent, neutral, text, status colors)
/// - 🌈 Enhanced gradients (background, surface, status gradients)
/// - 🎯 Theme-aware shadows (subtle, elevated, primary shadows)
/// - 🔄 Conditional styling with helper methods
/// - 🎭 Professional Material Design 3.0 compliance
/// - 🌓 Automatic light/dark mode adaptation
/// - 📊 Comprehensive debug logging and performance state monitoring
/// - ✨ Enhanced visual feedback with performance indicators and animations
/// - 📈 Performance-focused design with color-coded metrics
///
/// This widget displays comprehensive performance metrics in a beautiful card layout:
/// - Overall performance score with theme-aware color-coded indicators
/// - Frame drops, average frame time, and memory usage metrics
/// - Modern elevated card design with enhanced theming
/// - Visual performance indicators and animated progress bars
/// - Only visible to admin users for monitoring purposes
class PerformanceMetricsWidget extends StatefulWidget {
  const PerformanceMetricsWidget({
    super.key,
    required this.performanceMetrics,
  });

  /// Performance metrics data from PerformanceService
  final Map<String, dynamic> performanceMetrics;

  @override
  State<PerformanceMetricsWidget> createState() =>
      _PerformanceMetricsWidgetState();
}

class _PerformanceMetricsWidgetState extends State<PerformanceMetricsWidget>
    with SingleTickerProviderStateMixin, ThemeAwareMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint(
        '📊 [PerformanceMetrics] Initializing performance metrics display');

    // Initialize progress animation for performance score
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    final performanceScore = _getPerformanceScore();
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: performanceScore / 100.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });

    debugPrint('📊 [PerformanceMetrics] Animation controller initialized');
    debugPrint('📊 [PerformanceMetrics] Performance score: $performanceScore');
  }

  @override
  void dispose() {
    debugPrint('📊 [PerformanceMetrics] Disposing animation controller');
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);
    final performanceScore = _getPerformanceScore();

    debugPrint('📊 [PerformanceMetrics] Building performance metrics card');
    debugPrint('📊 [PerformanceMetrics] Performance score: $performanceScore');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        // Enhanced gradient background
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.surfaceColor.withValues(alpha: 242),
              themeManager.backgroundColor.withValues(alpha: 230),
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.surfaceColor.withValues(alpha: 230),
              themeManager.backgroundColor.withValues(alpha: 242),
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: themeManager.elevatedShadow,
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: themeManager.borderColor.withValues(alpha: 128),
            darkColor: themeManager.borderColor.withValues(alpha: 77),
          ),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced header with performance score
            _buildPerformanceHeader(themeManager, performanceScore),

            SizedBox(height: 24.h),

            // Enhanced performance score progress bar
            _buildPerformanceScoreBar(themeManager, performanceScore),

            SizedBox(height: 20.h),

            // Enhanced performance metrics grid
            _buildPerformanceMetrics(themeManager),
          ],
        ),
      ),
    );
  }

  /// Builds the enhanced performance header with comprehensive theme integration
  Widget _buildPerformanceHeader(
      ThemeManager themeManager, double performanceScore) {
    debugPrint('📊 [PerformanceMetrics] Building enhanced performance header');

    final performanceColor =
        _getPerformanceColor(themeManager, performanceScore);

    return Row(
      children: [
        // Enhanced performance icon container
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                performanceColor.withValues(alpha: 51),
                performanceColor.withValues(alpha: 26),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: performanceColor.withValues(alpha: 77),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: performanceColor.withValues(alpha: 51),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Prbal.tachometer,
            color: performanceColor,
            size: 24.sp,
          ),
        ),

        SizedBox(width: 16.w),

        // Enhanced title and description
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Performance Metrics',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: themeManager.conditionalColor(
                    lightColor: themeManager.textPrimary,
                    darkColor: themeManager.textPrimary,
                  ),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                _getPerformanceDescription(performanceScore),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: themeManager.conditionalColor(
                    lightColor: themeManager.textSecondary,
                    darkColor: themeManager.textSecondary,
                  ),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Enhanced performance score badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                performanceColor.withValues(alpha: 51),
                performanceColor.withValues(alpha: 26),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: performanceColor.withValues(alpha: 77),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: performanceColor.withValues(alpha: 26),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            '${performanceScore.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: performanceColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the enhanced animated performance score progress bar
  Widget _buildPerformanceScoreBar(
      ThemeManager themeManager, double performanceScore) {
    debugPrint(
        '📊 [PerformanceMetrics] Building enhanced performance score bar');

    final performanceColor =
        _getPerformanceColor(themeManager, performanceScore);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Overall Performance',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: themeManager.conditionalColor(
                  lightColor: themeManager.textPrimary,
                  darkColor: themeManager.textPrimary,
                ),
              ),
            ),
            Text(
              '${performanceScore.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: performanceColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Enhanced progress bar container
        Container(
          height: 8.h,
          decoration: BoxDecoration(
            color: themeManager.conditionalColor(
              lightColor: themeManager.neutral200,
              darkColor: themeManager.neutral700,
            ),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progressAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        performanceColor,
                        performanceColor.withValues(alpha: 204),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                    boxShadow: [
                      BoxShadow(
                        color: performanceColor.withValues(alpha: 77),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Builds the enhanced performance metrics grid with comprehensive theming
  Widget _buildPerformanceMetrics(ThemeManager themeManager) {
    debugPrint(
        '📊 [PerformanceMetrics] Building enhanced performance metrics grid');

    final frameDrops = widget.performanceMetrics['frame_drops'] as int? ?? 0;
    final avgFrameTime =
        widget.performanceMetrics['average_frame_time'] as double? ?? 0.0;
    final memoryUsage =
        widget.performanceMetrics['memory_usage'] as double? ?? 0.0;

    return Row(
      children: [
        Expanded(
          child: _buildMetricItem(
            themeManager,
            'Frame Drops',
            frameDrops.toString(),
            Prbal.exclamationTriangle,
            frameDrops > 0
                ? themeManager.errorColor
                : themeManager.successColor,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildMetricItem(
            themeManager,
            'Avg Frame Time',
            '${avgFrameTime.toStringAsFixed(1)}ms',
            Prbal.clock,
            avgFrameTime > 16.7
                ? themeManager.warningColor
                : themeManager.successColor,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildMetricItem(
            themeManager,
            'Memory',
            memoryUsage > 0 ? '${memoryUsage.toStringAsFixed(0)}MB' : 'N/A',
            Prbal.microchip,
            themeManager.infoColor,
          ),
        ),
      ],
    );
  }

  /// Builds enhanced individual metric item with comprehensive theme integration
  Widget _buildMetricItem(
    ThemeManager themeManager,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            colors: [
              color.withValues(alpha: 13),
              color.withValues(alpha: 8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          darkGradient: LinearGradient(
            colors: [
              color.withValues(alpha: 26),
              color.withValues(alpha: 13),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withValues(alpha: 77),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 26),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 77),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 16.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: themeManager.conditionalColor(
                      lightColor: themeManager.textSecondary,
                      darkColor: themeManager.textSecondary,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: themeManager.conditionalColor(
                lightColor: themeManager.textPrimary,
                darkColor: themeManager.textPrimary,
              ),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Gets the performance score from metrics
  double _getPerformanceScore() {
    return widget.performanceMetrics['performance_score'] as double? ?? 0.0;
  }

  /// Gets theme-aware color based on performance score
  Color _getPerformanceColor(ThemeManager themeManager, double score) {
    if (score >= 90) return themeManager.successColor;
    if (score >= 70) return themeManager.warningColor;
    return themeManager.errorColor;
  }

  /// Gets performance description based on score
  String _getPerformanceDescription(double score) {
    if (score >= 90) return 'Excellent performance';
    if (score >= 70) return 'Good performance';
    if (score >= 50) return 'Fair performance';
    return 'Needs optimization';
  }
}
