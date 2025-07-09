import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:prbal/utils/localization/project_locales.dart';
import 'package:prbal/services/hive_service.dart';
import 'package:prbal/utils/navigation/routes/route_enum.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
// import 'package:prbal/utils/extension/context/context_extension.dart';

/// LanguageSelectionScreen - Enhanced Multi-Language Support Screen
///
/// This screen provides a comprehensive language selection interface supporting:
/// - English (Primary/Default)
/// - 9 Indian regional languages with native script display
/// - Proper flag representations for each language/region
/// - Enhanced animations and user feedback
/// - Comprehensive debug logging for development
/// - Proper navigation flow based on user state
///
/// **FEATURES:**
/// - Beautiful flag-based language cards
/// - Native script language names
/// - Smooth animations and haptic feedback
/// - Auto-detection of current device locale
/// - Fallback to English for unsupported locales
/// - Comprehensive debug logging throughout
/// - State management with proper error handling
/// - Navigation flow based on intro/login status
///
/// **SUPPORTED LANGUAGES:**
/// 🇺🇸 English (en-US) - Primary/Default
/// 🇮🇳 हिन्दी (Hindi) - National language
/// 🇮🇳 বাংলা (Bengali) - West Bengal region
/// 🇮🇳 తెలుగు (Telugu) - Andhra Pradesh/Telangana
/// 🇮🇳 मराठी (Marathi) - Maharashtra
/// 🇮🇳 தமிழ் (Tamil) - Tamil Nadu
/// 🇮🇳 ગુજરાતી (Gujarati) - Gujarat
/// 🇮🇳 ಕನ್ನಡ (Kannada) - Karnataka
/// 🇮🇳 മലയാളം (Malayalam) - Kerala
/// 🇮🇳 ਪੰਜਾਬੀ (Punjabi) - Punjab
class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends ConsumerState<LanguageSelectionScreen> with TickerProviderStateMixin {
  // Animation controllers for smooth UI transitions
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Selected locale state - defaults to English
  Locale _selectedLocale = const Locale('en', 'US'); // Default to English

  @override
  void initState() {
    super.initState();
    debugPrint('🌐 LanguageSelectionScreen: ========= INITIALIZING =========');
    debugPrint('🌐 LanguageSelectionScreen: Supported languages: ${ProjectLocales.localesMap.length}');

    // Log all supported locales for debugging
    ProjectLocales.logSupportedLocales();

    _initializeAnimations();
    // Don't call _setCurrentLocale here - move to didChangeDependencies for proper context
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('🌐 LanguageSelectionScreen: Dependencies changed → Setting current locale...');
    _setCurrentLocale();
  }

  /// Initialize entrance animations for smooth user experience
  ///
  /// **ANIMATIONS:**
  /// - Fade animation: 0.0 → 1.0 over 800ms with ease-out curve
  /// - Slide animation: Offset(0, 0.5) → Offset.zero with elastic curve
  /// - Staggered timing for smooth sequential animation
  void _initializeAnimations() {
    debugPrint('🎬 LanguageSelectionScreen: Initializing entrance animations');

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Fade animation for overall screen appearance
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    // Slide animation for content sliding up from bottom
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    // Start animations immediately
    _animationController.forward();
    debugPrint('🎬 LanguageSelectionScreen: ✅ Animations started');
  }

  /// Detect and set current locale based on device settings with comprehensive fallback
  ///
  /// **LOGIC:**
  /// 1. Attempt to get current locale from Flutter context
  /// 2. Check if device locale is supported in our language list
  /// 3. If supported → use device locale
  /// 4. If not supported → fallback to English (en-US)
  /// 5. Update UI state to reflect selected locale
  /// 6. Log all steps for debugging
  void _setCurrentLocale() {
    debugPrint('🌐 LanguageSelectionScreen: === LOCALE DETECTION PROCESS ===');

    try {
      // Step 1: Get current locale from Flutter context (safely)
      final currentLocale = Localizations.maybeLocaleOf(context);
      debugPrint('🌐 LanguageSelectionScreen: Device locale detected: $currentLocale');

      if (currentLocale != null) {
        debugPrint('🌐 LanguageSelectionScreen: Checking if device locale is supported...');

        // Step 2: Check if current locale is in our supported languages
        if (ProjectLocales.isSupported(currentLocale)) {
          debugPrint(
              '🌐 LanguageSelectionScreen: ✅ Device locale IS supported → Using: ${currentLocale.languageCode}-${currentLocale.countryCode}');
          _selectedLocale = currentLocale;
        } else {
          debugPrint('🌐 LanguageSelectionScreen: ⚠️ Device locale NOT supported → Checking language-only match...');

          // Step 3: Try to find a language-only match (e.g., 'hi' matches 'hi-IN')
          final languageOnlyMatch = ProjectLocales.supportedLocales.firstWhere(
            (locale) => locale.languageCode == currentLocale.languageCode,
            orElse: () => ProjectLocales.defaultLocale,
          );

          if (languageOnlyMatch != ProjectLocales.defaultLocale) {
            debugPrint(
                '🌐 LanguageSelectionScreen: ✅ Found language match: ${languageOnlyMatch.languageCode}-${languageOnlyMatch.countryCode}');
            _selectedLocale = languageOnlyMatch;
          } else {
            debugPrint(
                '🌐 LanguageSelectionScreen: ⚠️ No language match → Using default: ${ProjectLocales.defaultLocale.languageCode}-${ProjectLocales.defaultLocale.countryCode}');
            _selectedLocale = ProjectLocales.defaultLocale;
          }
        }
      } else {
        debugPrint(
            '🌐 LanguageSelectionScreen: ⚠️ Device locale not available → Using default: ${ProjectLocales.defaultLocale.languageCode}-${ProjectLocales.defaultLocale.countryCode}');
        _selectedLocale = ProjectLocales.defaultLocale;
      }

      debugPrint(
          '🌐 LanguageSelectionScreen: 🎯 Final selected locale: ${_selectedLocale.languageCode}-${_selectedLocale.countryCode}');
      debugPrint('🌐 LanguageSelectionScreen: 📱 Display name: ${ProjectLocales.getDisplayName(_selectedLocale)}');

      // Step 4: Update UI to reflect selected locale
      if (mounted) {
        setState(() {});
        debugPrint('🌐 LanguageSelectionScreen: ✅ UI updated with selected locale');
      }
    } catch (e) {
      debugPrint('🌐 LanguageSelectionScreen: ❌ Error in locale detection: $e');
      debugPrint('🌐 LanguageSelectionScreen: 🔄 Using fallback default locale');

      // Fallback to default locale on any error
      _selectedLocale = ProjectLocales.defaultLocale;
      if (mounted) {
        setState(() {});
      }
    }

    debugPrint('🌐 LanguageSelectionScreen: ============================================');
  }

  @override
  void dispose() {
    debugPrint('🌐 LanguageSelectionScreen: Disposing animation controller');
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🌐 LanguageSelectionScreen: Building UI with ThemeManager colors');
    debugPrint('🌐 LanguageSelectionScreen: Background: ${ThemeManager.of(context).backgroundColor}');
    debugPrint('🌐 LanguageSelectionScreen: Surface: ${ThemeManager.of(context).surfaceColor}');
    debugPrint(
        '🌐 LanguageSelectionScreen: Current selected locale: ${_selectedLocale.languageCode}-${_selectedLocale.countryCode}');

    return Scaffold(
      backgroundColor: ThemeManager.of(context).backgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildBody(context),
            ),
          );
        },
      ),
    );
  }

  /// Set default language (English) and continue to next screen
  ///
  /// **USAGE:**
  /// - Called when user presses back/skip button
  /// - Provides fallback for users who don't want to select language
  /// - Ensures app always has a valid language setting
  ///
  /// **PROCESS:**
  /// 1. Set English as default language in local storage
  /// 2. Log the operation for debugging
  /// 3. Navigate to appropriate next screen
  /// 4. Handle errors gracefully
  void _setDefaultLanguageAndContinue(BuildContext context) async {
    debugPrint('🌐 LanguageSelectionScreen: === SETTING DEFAULT LANGUAGE ===');

    try {
      // Set English as default if no language is selected
      await HiveService.setSelectedLanguage('en-US');
      debugPrint('🌐 LanguageSelectionScreen: ✅ Default language (en-US) saved successfully');
      debugPrint('🌐 LanguageSelectionScreen: → Continuing to next screen...');

      _navigateToNextScreen(context);
    } catch (e) {
      debugPrint('🌐 LanguageSelectionScreen: ❌ Error setting default language: $e');
      debugPrint('🌐 LanguageSelectionScreen: → Continuing anyway (language can be set later)');

      // Even if there's an error saving language, continue to next screen
      // Language selection can be done later in settings
      _navigateToNextScreen(context);
    }
  }

  /// Navigate to the appropriate next screen based on user state
  ///
  /// **NAVIGATION LOGIC:**
  /// 1. Check if intro has been watched → If not, go to onboarding
  /// 2. Check if user is logged in → If not, go to welcome/auth screen
  /// 3. If both complete → go to home screen
  ///
  /// **DEBUGGING:**
  /// - Logs each navigation decision for troubleshooting
  /// - Shows current user state for context
  void _navigateToNextScreen(BuildContext context) {
    debugPrint('🌐 LanguageSelectionScreen: === NAVIGATION DECISION PROCESS ===');

    // Get current user state from Hive storage
    final hasIntroBeenWatched = HiveService.hasIntroBeenWatched();
    final isLoggedIn = HiveService.isLoggedIn();

    debugPrint('🌐 LanguageSelectionScreen: User state analysis:');
    debugPrint('🌐 LanguageSelectionScreen:   📚 Intro watched: $hasIntroBeenWatched');
    debugPrint('🌐 LanguageSelectionScreen:   🔐 Logged in: $isLoggedIn');

    // Decision tree for navigation
    if (!hasIntroBeenWatched) {
      debugPrint('🌐 LanguageSelectionScreen: 🎯 Decision: Navigate to onboarding (intro not watched)');
      context.go(RouteEnum.onboarding.rawValue);
    } else if (!isLoggedIn) {
      debugPrint('🌐 LanguageSelectionScreen: 🎯 Decision: Navigate to welcome (not logged in)');
      context.go(RouteEnum.welcome.rawValue);
    } else {
      debugPrint('🌐 LanguageSelectionScreen: 🎯 Decision: Navigate to home (user ready)');
      context.go(RouteEnum.home.rawValue);
    }

    debugPrint('🌐 LanguageSelectionScreen: ================================================');
  }

  /// Builds the main body content with header and language list
  ///
  /// **LAYOUT:**
  /// - Column structure with scrollable content at top
  /// - Header section with app branding and description
  /// - Language selection grid/list (scrollable)
  /// - Apply button strictly positioned at bottom
  /// - Proper spacing and padding throughout
  Widget _buildBody(
    BuildContext context,
  ) {
    debugPrint('🌐 LanguageSelectionScreen: Building main body content with bottom-fixed apply button');

    return Column(
      children: [
        // Scrollable content area
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _buildHeader(),
                // SizedBox(height: 32.h),
                _buildLanguageList(),
                SizedBox(height: 20.h), // Reduced spacing since button is now separate
              ],
            ),
          ),
        ),

        // Fixed buttons at bottom
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: ThemeManager.of(context).backgroundColor,
            border: Border(
              top: BorderSide(
                color: ThemeManager.of(context).borderColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildApplyButton(context),
              SizedBox(width: 5.w),
              _buildSkipButton(context),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the language selection list with all supported languages
  ///
  /// **DESIGN:**
  /// - Modern card container with shadows
  /// - Individual language items with flags and native names
  /// - Smooth selection animations
  /// - Proper dividers between items
  /// - Theme-aware styling throughout
  Widget _buildLanguageList() {
    debugPrint('🌐 LanguageSelectionScreen: Building language list with ${ProjectLocales.localesMap.length} languages');

    return Column(
      children: ProjectLocales.localesMap.entries
          .map((entry) => _buildLanguageItem(
                locale: entry.key,
                name: entry.value,
                flag: _getFlagForLocale(entry.key),
                isLast: entry == ProjectLocales.localesMap.entries.last,
              ))
          .toList(),
    );
  }

  /// Builds individual language selection item with enhanced design
  ///
  /// **PARAMETERS:**
  /// - locale: The Locale object for this language
  /// - name: Display name (e.g., "हिन्दी (Hindi)")
  /// - flag: Flag emoji for the language/region
  /// - themeManager: Current theme state
  /// - isLast: Whether this is the last item (for border handling)
  ///
  /// **FEATURES:**
  /// - Smooth tap animations with haptic feedback
  /// - Visual selection indicator
  /// - Flag emoji with proper styling
  /// - Native script language names
  /// - Proper typography and spacing
  /// - Theme-aware colors and styling
  Widget _buildLanguageItem({
    required Locale locale,
    required String name,
    required String flag,
    required bool isLast,
  }) {
    final isSelected = _selectedLocale == locale;
    debugPrint(
        '🌐 LanguageSelectionScreen: Building language item: ${locale.languageCode}-${locale.countryCode} (Selected: $isSelected)');

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            debugPrint('🌐 LanguageSelectionScreen: Language tapped: ${locale.languageCode}-${locale.countryCode}');
            debugPrint('🌐 LanguageSelectionScreen: Display name: $name');

            setState(() {
              _selectedLocale = locale;
            });

            // Provide haptic feedback for better UX
            HapticFeedback.lightImpact();
            debugPrint('🌐 LanguageSelectionScreen: ✅ Language selection updated with haptic feedback');
          },
          borderRadius: BorderRadius.vertical(
            top: locale == ProjectLocales.localesMap.keys.first ? Radius.circular(20.r) : Radius.zero,
            bottom: isLast ? Radius.circular(20.r) : Radius.zero,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: ThemeManager.of(context).surfaceColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                // Flag container with modern styling
                SizedBox(
                  width: 48.w,
                  height: 48.h,
                  child: Center(
                    child: Text(
                      flag,
                      style: TextStyle(fontSize: 24.sp),
                    ),
                  ),
                ),

                SizedBox(width: 16.w),

                // Language name and code information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Language display name with native script
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: ThemeManager.of(context).textPrimary,
                        ),
                      ),
                      // SizedBox(height: 4.h),

                      // // Language code for developers/debugging
                      // Text(
                      //   '${locale.languageCode.toUpperCase()}-${locale.countryCode}',
                      //   style: TextStyle(
                      //     fontSize: 12.sp,
                      //     color: ThemeManager.of(context).textSecondary,
                      //   ),
                      // ),
                    ],
                  ),
                ),

                // Selection indicator with smooth animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? ThemeManager.of(context).primaryColor : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? ThemeManager.of(context).primaryColor : ThemeManager.of(context).textTertiary,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Prbal.check,
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

  /// Builds the apply button with gradient styling and proper states
  ///
  /// **FEATURES:**
  /// - Full-width gradient button with brand colors
  /// - Smooth hover and press animations
  /// - Proper icon and text spacing
  /// - Theme-aware shadows and styling
  /// - Handles language application logic
  Widget _buildApplyButton(
    BuildContext context,
  ) {
    debugPrint('🌐 LanguageSelectionScreen: Building apply button');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child:
          // Material(
          InkWell(
        onTap: () {
          debugPrint('🌐 LanguageSelectionScreen: Apply button tapped');
          _applyLanguageSelection(context);
        },
        borderRadius: BorderRadius.circular(10.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Prbal.check,
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
      // ),
    );
  }

  /// Builds the skip button with outline styling
  ///
  /// **FEATURES:**
  /// - Full-width outline button with theme colors
  /// - Subtle styling to complement the apply button
  /// - Proper icon and text spacing
  /// - Theme-aware colors and borders
  /// - Sets default language and continues navigation
  Widget _buildSkipButton(
    BuildContext context,
  ) {
    debugPrint('🌐 LanguageSelectionScreen: Building skip button');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        // gradient: ThemeManager.of(context).primaryGradient,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ThemeManager.of(context).borderColor,
          width: 1.5,
        ),
      ),
      child:
          // Material(
          //   color: Colors.transparent,
          //   child:
          InkWell(
        onTap: () {
          debugPrint('🌐 LanguageSelectionScreen: Skip button tapped (bottom)');
          _setDefaultLanguageAndContinue(context);
        },
        borderRadius: BorderRadius.circular(10.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Prbal.arrowRight,
              color: ThemeManager.of(context).textSecondary,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              'Skip',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: ThemeManager.of(context).textSecondary,
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  /// Enhanced flag mapping for Indian languages and regions
  ///
  /// **MAPPING LOGIC:**
  /// - English (en): 🇺🇸 United States flag
  /// - All Indian languages: 🇮🇳 Indian flag
  /// - Fallback: 🌐 Globe icon for unknown languages
  ///
  /// **SUPPORTED LANGUAGES:**
  /// 🇺🇸 en (English)
  /// 🇮🇳 hi (Hindi) - National language
  /// 🇮🇳 bn (Bengali) - West Bengal
  /// 🇮🇳 te (Telugu) - Andhra Pradesh/Telangana
  /// 🇮🇳 mr (Marathi) - Maharashtra
  /// 🇮🇳 ta (Tamil) - Tamil Nadu
  /// 🇮🇳 gu (Gujarati) - Gujarat
  /// 🇮🇳 kn (Kannada) - Karnataka
  /// 🇮🇳 ml (Malayalam) - Kerala
  /// 🇮🇳 pa (Punjabi) - Punjab
  String _getFlagForLocale(Locale locale) {
    final languageCode = locale.languageCode;
    debugPrint('🌐 LanguageSelectionScreen: Getting flag for language: $languageCode');

    String flag;

    switch (languageCode) {
      // English - US flag
      case 'en':
        flag = '🇺🇸';
        break;

      // All Indian languages - Indian flag
      case 'hi': // Hindi
      case 'bn': // Bengali
      case 'te': // Telugu
      case 'mr': // Marathi
      case 'ta': // Tamil
      case 'gu': // Gujarati
      case 'kn': // Kannada
      case 'ml': // Malayalam
      case 'pa': // Punjabi
        flag = '🇮🇳';
        break;

      // Fallback for any unknown languages
      default:
        flag = '🌐';
        debugPrint('🌐 LanguageSelectionScreen: ⚠️ Unknown language code: $languageCode, using globe icon');
        break;
    }

    debugPrint('🌐 LanguageSelectionScreen: Flag for $languageCode: $flag');
    return flag;
  }

  /// Apply the selected language with comprehensive error handling and user feedback
  ///
  /// **PROCESS:**
  /// 1. Convert selected locale to storage format (language-COUNTRY)
  /// 2. Save language preference to local storage
  /// 3. Show success feedback with haptic response
  /// 4. Navigate to next screen after short delay
  /// 5. Handle errors gracefully with user notifications
  ///
  /// **ERROR HANDLING:**
  /// - Storage errors are caught and logged
  /// - User receives appropriate error messages
  /// - App continues to function even if language saving fails
  void _applyLanguageSelection(BuildContext context) async {
    debugPrint('🌐 LanguageSelectionScreen: === APPLYING LANGUAGE SELECTION ===');
    debugPrint(
        '🌐 LanguageSelectionScreen: Selected locale: ${_selectedLocale.languageCode}-${_selectedLocale.countryCode}');
    debugPrint('🌐 LanguageSelectionScreen: Display name: ${ProjectLocales.getDisplayName(_selectedLocale)}');

    try {
      // Step 1: Convert locale to storage format
      final languageCode = '${_selectedLocale.languageCode}-${_selectedLocale.countryCode}';
      debugPrint('🌐 LanguageSelectionScreen: Storage format: $languageCode');

      // Step 2: Save the selected language to local storage
      debugPrint('🌐 LanguageSelectionScreen: Saving language to local storage...');
      await HiveService.setSelectedLanguage(languageCode);
      debugPrint('🌐 LanguageSelectionScreen: ✅ Language saved successfully');

      // Step 2.5: Apply locale change using EasyLocalization
      debugPrint('🌐 LanguageSelectionScreen: Applying locale change with EasyLocalization...');

      if (context.mounted) {
        try {
          // Change the app's locale immediately using EasyLocalization
          await context.setLocale(_selectedLocale);
          debugPrint('🌐 LanguageSelectionScreen: ✅ EasyLocalization locale changed successfully');
          debugPrint(
              '🌐 LanguageSelectionScreen: 🎯 App now using: ${_selectedLocale.languageCode}-${_selectedLocale.countryCode}');
        } catch (localeError) {
          debugPrint('🌐 LanguageSelectionScreen: ⚠️ EasyLocalization setLocale failed: $localeError');
          debugPrint('🌐 LanguageSelectionScreen: 🔄 Continuing anyway - locale may change on next app start');
        }
      }

      // Step 3: Provide haptic feedback for successful action
      HapticFeedback.mediumImpact();
      debugPrint('🌐 LanguageSelectionScreen: ✅ Haptic feedback provided');

      // Step 4: Show success notification to user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Prbal.check,
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
            backgroundColor: ThemeManager.of(context).successColor, // Success green
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.only(
              bottom: 100.h,
              left: 16.w,
              right: 16.w,
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        debugPrint('🌐 LanguageSelectionScreen: ✅ Success notification shown');
      }

      // Step 5: Navigate to next screen after short delay for UX
      debugPrint('🌐 LanguageSelectionScreen: Waiting 1 second before navigation...');
      await Future.delayed(const Duration(milliseconds: 1000));

      if (context.mounted) {
        debugPrint('🌐 LanguageSelectionScreen: 🎯 Language applied: $languageCode');
        _navigateToNextScreen(context);
      }

      debugPrint('🌐 LanguageSelectionScreen: ✅ Language application completed successfully');
    } catch (e) {
      debugPrint('🌐 LanguageSelectionScreen: ❌ Error saving language selection: $e');

      // Show error notification to user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  Prbal.exclamationTriangle,
                  color: Colors.white,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  'Failed to save language selection',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            backgroundColor: ThemeManager.of(context).errorColor, // Error red
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            margin: EdgeInsets.only(
              bottom: 100.h,
              left: 16.w,
              right: 16.w,
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        debugPrint('🌐 LanguageSelectionScreen: ❌ Error notification shown');
      }

      // Continue to next screen anyway - language can be set later in settings
      debugPrint('🌐 LanguageSelectionScreen: → Continuing to next screen despite error');
      _navigateToNextScreen(context);
    }

    debugPrint('🌐 LanguageSelectionScreen: ===============================================');
  }
}
