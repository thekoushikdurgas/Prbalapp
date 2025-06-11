import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

/// A reusable Lottie loading widget with multiple animation styles
///
/// This widget provides a consistent loading experience across the app
/// using professional Lottie animations with fallback support
class LottieLoadingWidget extends StatefulWidget {
  /// The type of loading animation to display
  final LoadingAnimationType type;

  /// The size of the loading animation
  final double? size;

  /// Custom width override
  final double? width;

  /// Custom height override
  final double? height;

  /// Optional loading text to display below the animation
  final String? loadingText;

  /// Text style for the loading text
  final TextStyle? textStyle;

  /// Whether to show the loading text
  final bool showText;

  /// Animation speed multiplier (1.0 = normal speed)
  final double speed;

  /// Custom color for fallback icon (when Lottie fails to load)
  final Color? fallbackColor;

  const LottieLoadingWidget({
    super.key,
    this.type = LoadingAnimationType.dots,
    this.size,
    this.width,
    this.height,
    this.loadingText,
    this.textStyle,
    this.showText = true,
    this.speed = 1.0,
    this.fallbackColor,
  });

  /// Factory constructor for dots loading animation
  factory LottieLoadingWidget.dots({
    double? size,
    String? loadingText,
    TextStyle? textStyle,
    bool showText = true,
    double speed = 1.0,
  }) {
    return LottieLoadingWidget(
      type: LoadingAnimationType.dots,
      size: size ?? 60.w,
      loadingText: loadingText ?? 'Loading...',
      textStyle: textStyle,
      showText: showText,
      speed: speed,
    );
  }

  /// Factory constructor for service connection animation
  factory LottieLoadingWidget.serviceConnect({
    double? size,
    String? loadingText,
    TextStyle? textStyle,
    bool showText = true,
    double speed = 1.0,
    bool isDark = false,
  }) {
    return LottieLoadingWidget(
      type: isDark ? LoadingAnimationType.serviceConnectDark : LoadingAnimationType.serviceConnectLight,
      size: size ?? 100.w,
      loadingText: loadingText ?? 'Connecting...',
      textStyle: textStyle,
      showText: showText,
      speed: speed,
    );
  }

  /// Factory constructor for success animation
  factory LottieLoadingWidget.success({
    double? size,
    String? loadingText,
    TextStyle? textStyle,
    bool showText = true,
    double speed = 1.0,
  }) {
    return LottieLoadingWidget(
      type: LoadingAnimationType.success,
      size: size ?? 80.w,
      loadingText: loadingText ?? 'Success!',
      textStyle: textStyle,
      showText: showText,
      speed: speed,
    );
  }

  /// Factory constructor for small inline loading
  factory LottieLoadingWidget.inline({
    String? loadingText,
    TextStyle? textStyle,
  }) {
    return LottieLoadingWidget(
      type: LoadingAnimationType.dots,
      width: 80.w,
      height: 20.h,
      loadingText: loadingText,
      textStyle: textStyle,
      showText: loadingText != null,
      speed: 1.2,
    );
  }

  @override
  State<LottieLoadingWidget> createState() => _LottieLoadingWidgetState();
}

class _LottieLoadingWidgetState extends State<LottieLoadingWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String get _animationPath {
    switch (widget.type) {
      case LoadingAnimationType.dots:
        return 'assets/animations/loading_dots.json';
      case LoadingAnimationType.serviceConnectDark:
        return 'assets/animations/splash_dark.json';
      case LoadingAnimationType.serviceConnectLight:
        return 'assets/animations/splash_light.json';
      case LoadingAnimationType.success:
        return 'assets/animations/success_checkmark.json';
    }
  }

  Widget get _fallbackWidget {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = widget.size ?? widget.width ?? 60.w;

    Widget fallbackIcon;
    switch (widget.type) {
      case LoadingAnimationType.dots:
        fallbackIcon = SizedBox(
          width: size,
          height: widget.height ?? size * 0.3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: widget.fallbackColor ?? (isDark ? Colors.white70 : Colors.grey[600]),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
        break;
      case LoadingAnimationType.serviceConnectDark:
      case LoadingAnimationType.serviceConnectLight:
        fallbackIcon = Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF3B82F6).withValues(alpha: 0.8),
                const Color(0xFF1D4ED8).withValues(alpha: 0.9),
              ],
            ),
            borderRadius: BorderRadius.circular(size * 0.5),
          ),
          child: Icon(
            Icons.business,
            size: size * 0.5,
            color: Colors.white,
          ),
        );
        break;
      case LoadingAnimationType.success:
        fallbackIcon = Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF48BB78),
            borderRadius: BorderRadius.circular(size * 0.5),
          ),
          child: Icon(
            Icons.check,
            size: size * 0.5,
            color: Colors.white,
          ),
        );
        break;
    }

    return fallbackIcon;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animation container
        SizedBox(
          width: widget.width ?? widget.size ?? 60.w,
          height: widget.height ?? widget.size ?? 60.w,
          child: _hasError
              ? _fallbackWidget
              : Lottie.asset(
                  _animationPath,
                  controller: _animationController,
                  fit: BoxFit.contain,
                  repeat: widget.type != LoadingAnimationType.success,
                  animate: true,
                  frameRate: FrameRate.max,
                  options: LottieOptions(
                    enableMergePaths: true,
                  ),
                  onLoaded: (composition) {
                    debugPrint('🎬 Lottie loading widget loaded: ${composition.duration}');

                    _animationController.duration = composition.duration;

                    // Adjust speed
                    if (widget.speed != 1.0) {
                      _animationController.duration = Duration(
                        milliseconds: (composition.duration.inMilliseconds / widget.speed).round(),
                      );
                    }

                    // Start animation based on type
                    if (widget.type == LoadingAnimationType.success) {
                      _animationController.forward();
                    } else {
                      _animationController.repeat();
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('❌ Lottie loading widget error: $error');
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _hasError = true;
                        });
                      }
                    });
                    return _fallbackWidget;
                  },
                ),
        ),

        // Loading text
        if (widget.showText && widget.loadingText != null) ...[
          SizedBox(height: 8.h),
          Text(
            widget.loadingText!,
            style: widget.textStyle ??
                TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Types of loading animations available
enum LoadingAnimationType {
  /// Three dots pulsing animation
  dots,

  /// Service connection animation (dark theme)
  serviceConnectDark,

  /// Service connection animation (light theme)
  serviceConnectLight,

  /// Success checkmark animation
  success,
}

/// Extension methods for easy usage
extension LottieLoadingWidgetExtensions on LoadingAnimationType {
  /// Get the appropriate animation path
  String get animationPath {
    switch (this) {
      case LoadingAnimationType.dots:
        return 'assets/animations/loading_dots.json';
      case LoadingAnimationType.serviceConnectDark:
        return 'assets/animations/splash_dark.json';
      case LoadingAnimationType.serviceConnectLight:
        return 'assets/animations/splash_light.json';
      case LoadingAnimationType.success:
        return 'assets/animations/success_checkmark.json';
    }
  }

  /// Whether this animation should repeat
  bool get shouldRepeat {
    switch (this) {
      case LoadingAnimationType.success:
        return false;
      default:
        return true;
    }
  }
}
