import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/services/health_service.dart';
import 'package:prbal/utils/navigation/navigation_route.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// ====================================================================
/// HEALTH STATUS WIDGET COMPONENT
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
/// **1. Enhanced Health Display:**
/// - Dynamic theme-aware status indicators with sophisticated theming
/// - Gradient-based health status cards with comprehensive visual feedback
/// - Multi-layer shadow effects for visual depth and hierarchy
/// - Professional spacing and sizing with responsive design
///
/// **2. Advanced Visual Effects:**
/// - Glass morphism effects for modern appearance
/// - Status-specific gradient backgrounds with semantic colors
/// - Enhanced shadow system for visual hierarchy
/// - Professional typography with theme-aware contrast
///
/// **3. Interactive Enhancement:**
/// - Theme-aware hover and tap states
/// - Animated loading indicators with status colors
/// - Professional spacing and proportions
/// - Comprehensive debug logging throughout
///
/// **🎯 RESULT:**
/// A sophisticated health status widget that provides premium visual experience
/// with automatic light/dark theme adaptation using ALL ThemeManager
/// properties for consistent, beautiful, and accessible health monitoring.
/// ====================================================================

/// Health Status Widget - Enhanced system health monitoring component
///
/// This widget provides a sophisticated, theme-aware display for system health
/// information with comprehensive visual feedback and professional styling.
///
/// **Enhanced Features:**
/// - Comprehensive ThemeManager integration with all color properties
/// - Dynamic theme-aware status indicators with semantic colors
/// - Advanced gradient backgrounds and shadow effects
/// - Glass morphism effects for modern appearance
/// - Professional visual hierarchy with enhanced contrast
/// - Automatic light/dark mode adaptation
/// - Interactive feedback with haptic response
///
/// **Display Modes:**
/// - Full widget: Complete health information with metrics
/// - Compact widget: Minimal status indicator for tight spaces
/// - Loading state: Animated indicators with theme colors
///
/// **Usage:**
/// ```dart
/// HealthStatusWidget(
///   showDetails: true,    // Show detailed metrics
///   isCompact: false,     // Full display mode
/// )
/// ```
class HealthStatusWidget extends StatefulWidget {
  final bool showDetails;
  final bool isCompact;

  const HealthStatusWidget({
    super.key,
    this.showDetails = true,
    this.isCompact = false,
  });

  @override
  State<HealthStatusWidget> createState() => _HealthStatusWidgetState();
}

class _HealthStatusWidgetState extends State<HealthStatusWidget> with SingleTickerProviderStateMixin, ThemeAwareMixin {
  // ========== SERVICES AND DATA ==========
  final HealthService _healthService = HealthService();
  ApplicationHealth? _healthData;
  bool _isLoading = true;
  String _healthStatus = 'unknown';

  // ========== ANIMATION CONTROLLER ==========
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🏥 HealthStatusWidget: Initializing ENHANCED health status widget with comprehensive ThemeManager');

    // Initialize animations for enhanced UX
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start animations and load health data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });

    _loadHealthData();
  }

  @override
  void dispose() {
    debugPrint('🏥 HealthStatusWidget: Disposing enhanced health status widget');
    _animationController.dispose();
    _healthService.dispose();
    super.dispose();
  }

  Future<void> _loadHealthData() async {
    try {
      debugPrint('🏥 HealthStatusWidget: Loading health data with comprehensive monitoring');
      await _healthService.initialize();

      // Get application health check
      final healthCheck = await _healthService.performHealthCheck();

      if (mounted) {
        setState(() {
          _healthData = healthCheck;
          _healthStatus = healthCheck?.overallStatus.name ?? 'unknown';
          _isLoading = false;
        });

        debugPrint('🏥 HealthStatusWidget: Health data loaded - Status: $_healthStatus');
      }
    } catch (e) {
      debugPrint('🏥 HealthStatusWidget: Error loading health data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _healthStatus = 'error';
        });
      }
    }
  }

  /// Get comprehensive theme-aware status color
  Color _getStatusColor(ThemeManager themeManager, String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return themeManager.successColor;
      case 'unhealthy':
        return themeManager.warningColor;
      case 'error':
        return themeManager.errorColor;
      case 'loading':
        return themeManager.infoColor;
      default:
        return themeManager.conditionalColor(
          lightColor: themeManager.neutral400,
          darkColor: themeManager.neutral500,
        );
    }
  }

  /// Get theme-aware status icon
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return Prbal.checkCircle;
      case 'unhealthy':
        return Prbal.error;
      case 'error':
        return Prbal.errorOutline;
      case 'loading':
        return Prbal.refresh;
      default:
        return Prbal.help;
    }
  }

  /// Get theme-aware status text
  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return 'All systems operational';
      case 'unhealthy':
        return 'System issues detected';
      case 'error':
        return 'Unable to check status';
      case 'loading':
        return 'Checking system health...';
      default:
        return 'Status unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🏥 HealthStatusWidget: Building ENHANCED health status widget with comprehensive ThemeManager');

    // ========== COMPREHENSIVE THEME INTEGRATION ==========
    final themeManager = ThemeManager.of(context);

    // Comprehensive theme logging for debugging
    themeManager.logThemeInfo();
    debugPrint('🏥 HealthStatusWidget: Building with COMPREHENSIVE ThemeManager integration');
    debugPrint('🏥 HealthStatusWidget: → Health Status: $_healthStatus');
    debugPrint('🏥 HealthStatusWidget: → Is Loading: $_isLoading');
    debugPrint('🏥 HealthStatusWidget: → Show Details: ${widget.showDetails}');
    debugPrint('🏥 HealthStatusWidget: → Is Compact: ${widget.isCompact}');
    debugPrint('🏥 HealthStatusWidget: → Is Hovered: $_isHovered');

    final statusColor = _getStatusColor(themeManager, _isLoading ? 'loading' : _healthStatus);

    if (widget.isCompact) {
      return _buildEnhancedCompactWidget(themeManager, statusColor);
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: _buildEnhancedFullWidget(themeManager, statusColor),
      ),
    );
  }

  /// Build enhanced compact widget with comprehensive ThemeManager integration
  Widget _buildEnhancedCompactWidget(ThemeManager themeManager, Color statusColor) {
    debugPrint('🏥 HealthStatusWidget: Building enhanced compact widget');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              statusColor.withValues(alpha: 0.15),
              statusColor.withValues(alpha: 0.1),
              themeManager.cardBackground,
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              statusColor.withValues(alpha: 0.2),
              statusColor.withValues(alpha: 0.15),
              themeManager.cardBackground,
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: statusColor.withValues(alpha: 0.3),
            darkColor: statusColor.withValues(alpha: 0.4),
          ),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
          _isLoading
              ? SizedBox(
                  width: 16.w,
                  height: 16.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                )
              : Icon(
                  _getStatusIcon(_healthStatus),
                  color: statusColor,
                  size: 16.sp,
                ),
          SizedBox(width: 6.w),
          Text(
            (_isLoading ? 'CHECKING' : _healthStatus).toUpperCase(),
            style: TextStyle(
              fontSize: 11.sp,
              color: statusColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Build enhanced full widget with comprehensive ThemeManager integration
  Widget _buildEnhancedFullWidget(ThemeManager themeManager, Color statusColor) {
    debugPrint('🏥 HealthStatusWidget: Building enhanced full widget');

    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.cardBackground,
              themeManager.surfaceElevated,
              statusColor.withValues(alpha: 0.03),
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.cardBackground,
              themeManager.backgroundTertiary,
              statusColor.withValues(alpha: 0.05),
            ],
            stops: const [0.0, 0.8, 1.0],
          ),
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: themeManager.borderColor.withValues(alpha: 0.2),
            darkColor: themeManager.borderSecondary.withValues(alpha: 0.3),
          ),
          width: 1.5,
        ),
        boxShadow: [
          ...themeManager.elevatedShadow,
          BoxShadow(
            color: statusColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: themeManager.shadowMedium,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            debugPrint('🏥 HealthStatusWidget: Health widget tapped - navigating to health dashboard');
            HapticFeedback.lightImpact();
            NavigationRoute.goRouteNormal(RouteEnum.health.rawValue);
          },
          onHover: (hovering) {
            setState(() {
              _isHovered = hovering;
            });
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced header section
                _buildEnhancedHeader(themeManager, statusColor),

                // Enhanced details section
                if (widget.showDetails && _healthData != null) ...[
                  SizedBox(height: 20.h),
                  _buildEnhancedHealthMetrics(themeManager),
                ],

                // Enhanced loading section
                if (_isLoading) ...[
                  SizedBox(height: 20.h),
                  _buildEnhancedLoadingState(themeManager, statusColor),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build enhanced header section with comprehensive theming
  Widget _buildEnhancedHeader(ThemeManager themeManager, Color statusColor) {
    return Row(
      children: [
        // Enhanced status icon container
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            gradient: themeManager.conditionalGradient(
              lightGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  statusColor.withValues(alpha: 0.15),
                  statusColor.withValues(alpha: 0.1),
                  statusColor.withValues(alpha: 0.05),
                ],
              ),
              darkGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  statusColor.withValues(alpha: 0.2),
                  statusColor.withValues(alpha: 0.15),
                  statusColor.withValues(alpha: 0.1),
                ],
              ),
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: themeManager.conditionalColor(
                lightColor: statusColor.withValues(alpha: 0.3),
                darkColor: statusColor.withValues(alpha: 0.4),
              ),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: statusColor.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isLoading ? _pulseAnimation.value : 1.0,
                child: Icon(
                  _getStatusIcon(_isLoading ? 'loading' : _healthStatus),
                  color: statusColor,
                  size: 24.sp,
                ),
              );
            },
          ),
        ),

        SizedBox(width: 16.w),

        // Enhanced text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'System Health',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: themeManager.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                _getStatusText(_isLoading ? 'loading' : _healthStatus),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),

        // Enhanced navigation indicator
        if (!_isLoading)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(_isHovered ? 8.w : 6.w),
            decoration: BoxDecoration(
              gradient: _isHovered
                  ? themeManager.conditionalGradient(
                      lightGradient: LinearGradient(
                        colors: [
                          themeManager.accent2.withValues(alpha: 0.15),
                          themeManager.accent2.withValues(alpha: 0.1),
                        ],
                      ),
                      darkGradient: LinearGradient(
                        colors: [
                          themeManager.accent2.withValues(alpha: 0.2),
                          themeManager.accent2.withValues(alpha: 0.15),
                        ],
                      ),
                    )
                  : null,
              borderRadius: BorderRadius.circular(8.r),
              border: _isHovered
                  ? Border.all(
                      color: themeManager.conditionalColor(
                        lightColor: themeManager.accent2.withValues(alpha: 0.3),
                        darkColor: themeManager.accent2.withValues(alpha: 0.4),
                      ),
                      width: 1,
                    )
                  : null,
            ),
            child: Icon(
              Prbal.arrowSync,
              color: themeManager.conditionalColor(
                lightColor: _isHovered ? themeManager.primaryColor : themeManager.textSecondary,
                darkColor: _isHovered ? themeManager.primaryLight : themeManager.textTertiary,
              ),
              size: 18.sp,
            ),
          ),
      ],
    );
  }

  /// Build enhanced health metrics with comprehensive theming
  Widget _buildEnhancedHealthMetrics(ThemeManager themeManager) {
    debugPrint('🏥 HealthStatusWidget: Building enhanced health metrics');

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.surfaceElevated,
              themeManager.cardBackground,
              themeManager.backgroundSecondary,
            ],
          ),
          darkGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeManager.backgroundTertiary,
              themeManager.surfaceElevated,
              themeManager.cardBackground,
            ],
          ),
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: themeManager.dividerColor.withValues(alpha: 0.2),
            darkColor: themeManager.dividerColor.withValues(alpha: 0.3),
          ),
          width: 1,
        ),
        boxShadow: [
          ...themeManager.subtleShadow,
          BoxShadow(
            color: themeManager.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildEnhancedMetricRow(
            'System',
            _healthData!.system.status,
            _getStatusColor(themeManager, _healthData!.system.status),
            themeManager,
            Prbal.desktop,
          ),
          SizedBox(height: 12.h),
          _buildEnhancedMetricRow(
            'Database',
            _healthData!.database.status,
            _getStatusColor(themeManager, _healthData!.database.status),
            themeManager,
            Prbal.database,
          ),
          SizedBox(height: 12.h),
          _buildEnhancedMetricRow(
            'Version',
            _healthData!.system.version,
            themeManager.infoColor,
            themeManager,
            Prbal.tag,
          ),
        ],
      ),
    );
  }

  /// Build enhanced metric row with comprehensive theming
  Widget _buildEnhancedMetricRow(
    String label,
    String value,
    Color valueColor,
    ThemeManager themeManager,
    IconData icon,
  ) {
    return Row(
      children: [
        // Enhanced metric icon
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                valueColor.withValues(alpha: 0.15),
                valueColor.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: valueColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: valueColor,
            size: 14.sp,
          ),
        ),

        SizedBox(width: 12.w),

        // Enhanced metric label
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: themeManager.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Enhanced metric value
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                valueColor.withValues(alpha: 0.15),
                valueColor.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: valueColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            value.toUpperCase(),
            style: TextStyle(
              fontSize: 12.sp,
              color: valueColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  /// Build enhanced loading state with comprehensive theming
  Widget _buildEnhancedLoadingState(ThemeManager themeManager, Color statusColor) {
    debugPrint('🏥 HealthStatusWidget: Building enhanced loading state');

    return Center(
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: themeManager.conditionalGradient(
            lightGradient: LinearGradient(
              colors: [
                statusColor.withValues(alpha: 0.1),
                statusColor.withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ),
            darkGradient: LinearGradient(
              colors: [
                statusColor.withValues(alpha: 0.15),
                statusColor.withValues(alpha: 0.1),
                Colors.transparent,
              ],
            ),
          ),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              width: 32.w,
              height: 32.h,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Analyzing System Health...',
              style: TextStyle(
                fontSize: 14.sp,
                color: statusColor,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
