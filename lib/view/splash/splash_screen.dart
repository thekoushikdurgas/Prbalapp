import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';

// TODO: Add proper theme service integration
// TODO: Add Hive service for persistence
// TODO: Add localization support
// TODO: Add proper app router integration
// TODO: Add error handling for navigation
// TODO: Add connectivity check before navigation
// TODO: Add custom fonts and advanced styling
// TODO: Add sound effects for splash animations
// TODO: Add biometric authentication check
// TODO: Add app update checker

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _progressValue;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Progress animation controller
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo animations
    _logoScale = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // Text animation
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    // Progress animation
    _progressValue = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _startAnimationSequence() async {
    // Start logo animation
    await _logoController.forward();

    // Start text animation
    await _textController.forward();

    // Start progress animation
    await _progressController.forward();

    // Navigate to next screen after animations complete
    await Future.delayed(const Duration(milliseconds: 500));
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    // Add your navigation logic here
    // For example: context.go('/welcome') or context.go('/home')
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0F172A), // Dark slate
                    const Color(0xFF1E293B), // Slate 800
                    const Color(0xFF334155), // Slate 700
                  ]
                : [
                    const Color(0xFFFFFFFF), // White
                    const Color(0xFFF8FAFC), // Slate 50
                    const Color(0xFFF1F5F9), // Slate 100
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Status bar space
              SizedBox(height: 60.h),

              // Main content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo section
                    AnimatedBuilder(
                      animation: _logoController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScale.value,
                          child: Opacity(
                            opacity: _logoOpacity.value,
                            child: Container(
                              width: 120.w,
                              height: 120.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF3B82F6), // Blue 500
                                    const Color(0xFF1D4ED8), // Blue 700
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF3B82F6)
                                        .withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                LineIcons.briefcase,
                                size: 60.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 32.h),

                    // App name and tagline
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textOpacity.value,
                          child: Column(
                            children: [
                              // App name
                              Text(
                                'Prbal',
                                style: TextStyle(
                                  fontSize: 48.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                  letterSpacing: -1.5,
                                ),
                              ),

                              SizedBox(height: 8.h),

                              // Tagline
                              Text(
                                'Your Service Marketplace',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : const Color(0xFF64748B),
                                  letterSpacing: 0.5,
                                ),
                              ),

                              SizedBox(height: 4.h),

                              // Subtitle
                              Text(
                                'Connect • Serve • Thrive',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? Colors.grey[500]
                                      : const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Bottom section with progress
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Column(
                  children: [
                    // Loading text
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textOpacity.value,
                          child: Text(
                            'Setting up your experience...',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.grey[400]
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 16.h),

                    // Progress bar
                    AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return Container(
                          width: double.infinity,
                          height: 4.h,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF374151)
                                : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _progressValue.value,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF3B82F6),
                                    Color(0xFF1D4ED8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 60.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
