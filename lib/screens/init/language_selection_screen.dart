import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:go_router/go_router.dart';

import 'package:prbal/utils/localization/project_locales.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';
// import 'package:prbal/utils/extension/context/context_extension.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Locale _selectedLocale = const Locale('en', 'US'); // Default to English

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    // Don't call _setCurrentLocale here - move to didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('🌐 Language Selection: Setting current locale...');
    _setCurrentLocale();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  void _setCurrentLocale() {
    try {
      // Get current locale from the app - safely handle if not yet available
      final currentLocale = Localizations.maybeLocaleOf(context);
      debugPrint('🌐 Current device locale: $currentLocale');

      if (currentLocale != null) {
        _selectedLocale = ProjectLocales.localesMap.keys.firstWhere(
            (locale) => locale == currentLocale,
            orElse: () => const Locale('en', 'US'));
      } else {
        // Default to English if locale not yet available
        _selectedLocale = const Locale('en', 'US');
      }

      debugPrint('🌐 Selected locale set to: $_selectedLocale');

      // Trigger rebuild to show the selected locale
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('❌ Error setting current locale: $e');
      // Fallback to default locale
      _selectedLocale = const Locale('en', 'US');
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0A0A0A) : const Color(0xFFFAFAFA),
      appBar: _buildAppBar(context, isDark),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildBody(context, isDark),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          // For now, set a default language and continue to next screen
          // This provides a fallback if users try to go back
          _setDefaultLanguageAndContinue(context);
        },
        icon: Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E1E1E).withValues(alpha: 0.8)
                : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5E5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            LineIcons.arrowLeft,
            color: isDark ? Colors.white : Colors.black,
            size: 20.sp,
          ),
        ),
      ),
      title: Text(
        'Language Settings',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      centerTitle: true,
      actions: [
        // Add skip button for better UX
        TextButton(
          onPressed: () => _setDefaultLanguageAndContinue(context),
          child: Text(
            'Skip',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6366F1),
            ),
          ),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  /// Set default language and continue to next screen
  void _setDefaultLanguageAndContinue(BuildContext context) async {
    try {
      // Set English as default if no language is selected
      await HiveService.setSelectedLanguage('en-US');
      debugPrint('🌐 Default language set → continuing to next screen');
      _navigateToNextScreen(context);
    } catch (e) {
      debugPrint('Error setting default language: $e');
      // Even if there's an error, continue to next screen
      _navigateToNextScreen(context);
    }
  }

  /// Navigate to the appropriate next screen based on user state
  void _navigateToNextScreen(BuildContext context) {
    final hasIntroBeenWatched = HiveService.hasIntroBeenWatched();
    final isLoggedIn = HiveService.isLoggedIn();

    if (!hasIntroBeenWatched) {
      debugPrint('🌐 → navigating to onboarding');
      context.go(RouteEnum.onboarding.rawValue);
    } else if (!isLoggedIn) {
      debugPrint('🌐 → navigating to welcome');
      context.go(RouteEnum.welcome.rawValue);
    } else {
      debugPrint('🌐 → navigating to home');
      context.go(RouteEnum.home.rawValue);
    }
  }

  Widget _buildBody(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDark),
          SizedBox(height: 32.h),
          _buildLanguageList(isDark),
          SizedBox(height: 40.h),
          _buildApplyButton(context, isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5E5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF6366F1),
                  const Color(0xFF8B5CF6),
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              LineIcons.language,
              color: Colors.white,
              size: 32.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Choose Your Language',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Select your preferred language for the app interface',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageList(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5E5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: ProjectLocales.localesMap.entries
            .map((entry) => _buildLanguageItem(
                  locale: entry.key,
                  name: entry.value,
                  flag: _getFlagForLocale(entry.key),
                  isDark: isDark,
                  isLast: entry == ProjectLocales.localesMap.entries.last,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildLanguageItem({
    required Locale locale,
    required String name,
    required String flag,
    required bool isDark,
    required bool isLast,
  }) {
    final isSelected = _selectedLocale == locale;

    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: isDark
                      ? const Color(0xFF2A2A2A)
                      : const Color(0xFFE5E5E5),
                  width: 1,
                ),
              ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedLocale = locale;
            });
            HapticFeedback.lightImpact();
          },
          borderRadius: BorderRadius.vertical(
            top: locale == ProjectLocales.localesMap.keys.first
                ? Radius.circular(20.r)
                : Radius.zero,
            bottom: isLast ? Radius.circular(20.r) : Radius.zero,
          ),
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                // Flag
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF2A2A2A)
                          : const Color(0xFFE5E5E5),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      flag,
                      style: TextStyle(fontSize: 24.sp),
                    ),
                  ),
                ),

                SizedBox(width: 16.w),

                // Language name and code
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${locale.languageCode.toUpperCase()}-${locale.countryCode}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),

                // Selection indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF6366F1)
                          : isDark
                              ? const Color(0xFF4B5563)
                              : const Color(0xFFD1D5DB),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16.sp,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _applyLanguageSelection(context);
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LineIcons.check,
                  color: Colors.white,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  'Apply Language',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getFlagForLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return '🇺🇸';
      case 'tr':
        return '🇹🇷';
      default:
        return '🌐';
    }
  }

  void _applyLanguageSelection(BuildContext context) async {
    try {
      // Save the selected language
      final languageCode =
          '${_selectedLocale.languageCode}-${_selectedLocale.countryCode}';
      await HiveService.setSelectedLanguage(languageCode);

      // TODO: Implement locale change logic
      // This would typically involve updating a provider/state management
      // and restarting the app with the new locale

      HapticFeedback.mediumImpact();

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                LineIcons.check,
                color: Colors.white,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Language updated successfully',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          margin: EdgeInsets.all(16.w),
        ),
      );

      // Navigate to next screen after a short delay
      await Future.delayed(const Duration(milliseconds: 1000));
      if (context.mounted) {
        debugPrint('🌐 Language applied: $languageCode');
        _navigateToNextScreen(context);
      }
    } catch (e) {
      debugPrint('Error saving language selection: $e');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save language selection'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
