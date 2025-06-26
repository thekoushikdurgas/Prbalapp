import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/cubit/theme_cubit.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:easy_localization/easy_localization.dart';

/// **Enhanced ThemeSelectorWidget** - Advanced theme selection with ThemeManager integration
///
/// **Features Showcased**:
/// 🎨 **Centralized ThemeManager** - Complete theme management integration
/// 🌈 **Advanced Gradients** - Primary, secondary, background, and surface gradients
/// ✨ **Glass Morphism Effects** - Modern UI with glass morphism design
/// 🎯 **Conditional Colors** - Dynamic color adaptation based on theme
/// 📱 **Material Design 3.0** - Latest design guidelines implementation
/// 🔧 **Enhanced Debug Logging** - Comprehensive theme state tracking
/// 🎪 **Animation Ready** - Smooth transitions and state changes
/// 💫 **Shadow Effects** - Primary and elevated shadow implementations
class ThemeSelectorWidget extends StatefulWidget {
  const ThemeSelectorWidget({super.key});

  @override
  State<ThemeSelectorWidget> createState() => _ThemeSelectorWidgetState();
}

class _ThemeSelectorWidgetState extends State<ThemeSelectorWidget> with TickerProviderStateMixin, ThemeAwareMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint('🎨 ThemeSelectorWidget: Initializing enhanced theme selector with ThemeManager');

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    debugPrint('🎨 ThemeSelectorWidget: Disposing animation controller');
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🎨 ThemeSelectorWidget: Building enhanced theme selector with ThemeManager');

    // Use centralized ThemeManager instead of manual theme detection
    final themeManager = ThemeManager.of(context);

    // Enhanced debug logging with theme state

    debugPrint('🎨 ThemeSelectorWidget: Primary color: ${themeManager.primaryColor}');
    debugPrint('🎨 ThemeSelectorWidget: Background gradient: ${themeManager.backgroundGradient}');

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: _buildEnhancedThemeSelector(themeManager),
          ),
        );
      },
    );
  }

  /// Builds enhanced theme selector with advanced ThemeManager features
  Widget _buildEnhancedThemeSelector(ThemeManager themeManager) {
    debugPrint('🎨 ThemeSelectorWidget: Building enhanced theme selector container');

    return Container(
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.all(24.w),
      decoration: themeManager.glassMorphism.copyWith(
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: themeManager.elevatedShadow,
        // Enhanced gradient background using ThemeManager
        gradient: themeManager.surfaceGradient,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Enhanced header with gradient text and icon
          _buildEnhancedHeader(themeManager),

          SizedBox(height: 24.h),

          // Theme options with advanced styling
          _buildAdvancedThemeOptions(themeManager),

          SizedBox(height: 20.h),

          // Enhanced preview cards
          _buildThemePreviewCards(themeManager),
        ],
      ),
    );
  }

  /// Builds enhanced header with gradient styling
  Widget _buildEnhancedHeader(ThemeManager themeManager) {
    debugPrint('🎨 ThemeSelectorWidget: Building enhanced header');

    return Row(
      children: [
        // Gradient icon container
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            gradient: themeManager.primaryGradient,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: themeManager.primaryShadow,
          ),
          child: Icon(
            Prbal.palette,
            size: 24.sp,
            color: Colors.white,
          ),
        ),

        SizedBox(width: 16.w),

        // Enhanced header text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'theme.selectTheme'.tr(),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: themeManager.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'theme.selectDescription'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: themeManager.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds advanced theme options with ThemeManager integration
  Widget _buildAdvancedThemeOptions(ThemeManager themeManager) {
    debugPrint('🎨 ThemeSelectorWidget: Building advanced theme options');

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        debugPrint('🎨 ThemeSelectorWidget: Current theme mode: ${themeMode.name}');

        return Column(
          children: [
            // Light Theme Option
            _buildThemeOption(
              themeManager,
              title: 'theme.light'.tr(),
              description: 'theme.lightDescription'.tr(),
              icon: Prbal.sun,
              isSelected: themeMode == ThemeMode.light,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF4F46E5),
                ],
              ),
              onTap: () => _selectTheme(ThemeMode.light, themeManager),
            ),

            SizedBox(height: 12.h),

            // Dark Theme Option
            _buildThemeOption(
              themeManager,
              title: 'theme.dark'.tr(),
              description: 'theme.darkDescription'.tr(),
              icon: Prbal.moon,
              isSelected: themeMode == ThemeMode.dark,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF8B5CF6),
                  Color(0xFF7C3AED),
                ],
              ),
              onTap: () => _selectTheme(ThemeMode.dark, themeManager),
            ),

            SizedBox(height: 12.h),

            // System Theme Option
            _buildThemeOption(
              themeManager,
              title: 'theme.system'.tr(),
              description: 'theme.systemDescription'.tr(),
              icon: Prbal.settings,
              isSelected: themeMode == ThemeMode.system,
              gradient: themeManager.secondaryGradient,
              onTap: () => _selectTheme(ThemeMode.system, themeManager),
            ),
          ],
        );
      },
    );
  }

  /// Builds individual theme option with advanced styling
  Widget _buildThemeOption(
    ThemeManager themeManager, {
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: isSelected ? gradient : null,
          color: isSelected ? null : themeManager.surfaceColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? Colors.transparent : themeManager.borderColor,
            width: 2,
          ),
          boxShadow: isSelected ? themeManager.elevatedShadow : themeManager.primaryShadow,
        ),
        child: Row(
          children: [
            // Icon with conditional styling
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : themeManager.conditionalColor(
                        lightColor: Color(0xFFF3F4F6),
                        darkColor: Color(0xFF374151),
                      ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                size: 20.sp,
                color: isSelected ? Colors.white : themeManager.textSecondary,
              ),
            ),

            SizedBox(width: 16.w),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : themeManager.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isSelected ? Colors.white.withValues(alpha: 0.9) : themeManager.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Selection indicator
            if (isSelected)
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Prbal.check,
                  size: 16.sp,
                  color: Color(0xFF10B981),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds theme preview cards showcasing ThemeManager capabilities
  Widget _buildThemePreviewCards(ThemeManager themeManager) {
    debugPrint('🎨 ThemeSelectorWidget: Building theme preview cards');

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: themeManager.backgroundGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: themeManager.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview header
          Text(
            'theme.preview'.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: themeManager.textSecondary,
            ),
          ),

          SizedBox(height: 12.h),

          // Preview elements
          Row(
            children: [
              // Primary gradient preview
              Expanded(
                child: _buildPreviewCard(
                  themeManager,
                  title: 'Primary',
                  gradient: themeManager.primaryGradient,
                ),
              ),

              SizedBox(width: 8.w),

              // Secondary gradient preview
              Expanded(
                child: _buildPreviewCard(
                  themeManager,
                  title: 'Secondary',
                  gradient: themeManager.secondaryGradient,
                ),
              ),

              SizedBox(width: 8.w),

              // Surface gradient preview
              Expanded(
                child: _buildPreviewCard(
                  themeManager,
                  title: 'Surface',
                  gradient: themeManager.surfaceGradient,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds individual preview card
  Widget _buildPreviewCard(
    ThemeManager themeManager, {
    required String title,
    required Gradient gradient,
  }) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: themeManager.primaryShadow,
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Handles theme selection with enhanced feedback
  void _selectTheme(ThemeMode themeMode, ThemeManager themeManager) {
    debugPrint('🎨 ThemeSelectorWidget: Selecting theme: ${themeMode.name}');

    // Trigger animation feedback
    _animationController.reverse().then((_) {
      _animationController.forward();
    });

    // Update theme using BLoC with correct method names
    final themeCubit = context.read<ThemeCubit>();
    switch (themeMode) {
      case ThemeMode.light:
        themeCubit.makelight();
        break;
      case ThemeMode.dark:
        themeCubit.makeDark();
        break;
      case ThemeMode.system:
        themeCubit.makeSystem();
        break;
    }

    // Log the change with ThemeManager

    debugPrint('🎨 ThemeSelectorWidget: Theme changed to: ${themeMode.name}');
  }
}
