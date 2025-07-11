import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';

// import 'package:prbal/widget/modern_ui_components.dart';

/// PerformanceMetricsWidget - Modern performance metrics display for admin users
///
/// This widget displays comprehensive performance metrics in a beautiful card layout:
/// - Overall performance score with color-coded indicators
/// - Frame drops, average frame time, and other metrics
/// - Modern elevated card design with proper theming
/// - Visual performance indicators and progress bars
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
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint(
        '📊 PerformanceMetricsWidget: Initializing performance metrics display');

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

    debugPrint('📊 PerformanceMetricsWidget: Animation controller initialized');
    debugPrint(
        '📊 PerformanceMetricsWidget: Performance score: $performanceScore');
  }

  @override
  void dispose() {
    debugPrint('📊 PerformanceMetricsWidget: Disposing animation controller');
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '📊 PerformanceMetricsWidget: Building performance metrics card');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final performanceScore = _getPerformanceScore();

    debugPrint('📊 PerformanceMetricsWidget: Theme is dark: $isDark');
    debugPrint(
        '📊 PerformanceMetricsWidget: Performance score: $performanceScore');

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.9),
            blurRadius: 1,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Performance Score
            _buildPerformanceHeader(isDark, performanceScore),

            SizedBox(height: 24.h),

            // Performance Score Progress Bar
            _buildPerformanceScoreBar(isDark, performanceScore),

            SizedBox(height: 20.h),

            // Performance Metrics Grid
            _buildPerformanceMetrics(isDark),
          ],
        ),
      ),
    );
  }

  /// Builds the performance header with icon and score
  Widget _buildPerformanceHeader(bool isDark, double performanceScore) {
    debugPrint('📊 PerformanceMetricsWidget: Building performance header');

    final performanceColor = _getPerformanceColor(performanceScore);

    return Row(
      children: [
        // Performance Icon
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                performanceColor.withValues(alpha: 0.2),
                performanceColor.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: performanceColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Icon(
            Prbal.tachometer,
            color: performanceColor,
            size: 24.sp,
          ),
        ),

        SizedBox(width: 16.w),

        // Title and Description
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Performance Metrics',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2D3748),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                _getPerformanceDescription(performanceScore),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Performance Score Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                performanceColor.withValues(alpha: 0.2),
                performanceColor.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: performanceColor.withValues(alpha: 0.3),
              width: 1,
            ),
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

  /// Builds the animated performance score progress bar
  Widget _buildPerformanceScoreBar(bool isDark, double performanceScore) {
    debugPrint('📊 PerformanceMetricsWidget: Building performance score bar');

    final performanceColor = _getPerformanceColor(performanceScore);

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
                color: isDark ? Colors.white : const Color(0xFF2D3748),
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
        Container(
          height: 8.h,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[200],
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
                        performanceColor.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Builds the performance metrics grid
  Widget _buildPerformanceMetrics(bool isDark) {
    debugPrint(
        '📊 PerformanceMetricsWidget: Building performance metrics grid');

    final frameDrops = widget.performanceMetrics['frame_drops'] as int? ?? 0;
    final avgFrameTime =
        widget.performanceMetrics['average_frame_time'] as double? ?? 0.0;
    final memoryUsage =
        widget.performanceMetrics['memory_usage'] as double? ?? 0.0;

    return Row(
      children: [
        Expanded(
          child: _buildMetricItem(
            'Frame Drops',
            frameDrops.toString(),
            Prbal.exclamationTriangle,
            frameDrops > 0 ? const Color(0xFFED8936) : const Color(0xFF48BB78),
            isDark,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildMetricItem(
            'Avg Frame Time',
            '${avgFrameTime.toStringAsFixed(1)}ms',
            Prbal.clock,
            avgFrameTime > 16.7
                ? const Color(0xFFED8936)
                : const Color(0xFF48BB78),
            isDark,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildMetricItem(
            'Memory',
            memoryUsage > 0 ? '${memoryUsage.toStringAsFixed(0)}MB' : 'N/A',
            Prbal.microchip,
            const Color(0xFF4299E1),
            isDark,
          ),
        ),
      ],
    );
  }

  /// Builds individual metric item
  Widget _buildMetricItem(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color:
            isDark ? Colors.grey[800]?.withValues(alpha: 0.5) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
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
              color: isDark ? Colors.white : const Color(0xFF2D3748),
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

  /// Gets color based on performance score
  Color _getPerformanceColor(double score) {
    if (score >= 90) return const Color(0xFF48BB78);
    if (score >= 70) return const Color(0xFFED8936);
    return const Color(0xFFE53E3E);
  }

  /// Gets performance description based on score
  String _getPerformanceDescription(double score) {
    if (score >= 90) return 'Excellent performance';
    if (score >= 70) return 'Good performance';
    if (score >= 50) return 'Fair performance';
    return 'Needs optimization';
  }
}
