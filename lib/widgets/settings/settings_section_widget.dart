import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// **THEMEMANAGER INTEGRATED** SettingsSectionWidget - Modern settings section container
///
/// **ThemeManager Features Integrated:**
/// - 🎨 Complete color system (primary, accent, neutral, text, status colors)
/// - 🌈 Enhanced gradients (background, surface, glass morphism gradients)
/// - 🎯 Theme-aware shadows (subtle, elevated, primary shadows)
/// - 🔄 Conditional styling with helper methods
/// - 🎭 Professional Material Design 3.0 compliance
/// - 🌓 Automatic light/dark mode adaptation
/// - 📊 Comprehensive debug logging and theme state monitoring
/// - ✨ Enhanced visual feedback with glass morphism effects
///
/// This widget groups related settings items together with:
/// - Section title with proper typography and theme-aware colors
/// - Modern card design with enhanced glass-morphism effect
/// - Automatic dividers between items with gradient styling
/// - Theme-aware styling for light and dark modes
/// - Flexible item layout supporting different widget types
class SettingsSectionWidget extends StatelessWidget with ThemeAwareMixin {
  const SettingsSectionWidget({
    super.key,
    required this.title,
    required this.children,
    this.margin,
    this.showTitle = true,
  });

  /// Section title to be displayed above the items
  final String title;

  /// List of settings items to be displayed in the section
  final List<Widget> children;

  /// Custom margin for the section (optional)
  final EdgeInsets? margin;

  /// Whether to show the section title
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);
    
    debugPrint('🎨 [SettingsSection] Building section "$title"');
    debugPrint('🎯 [SettingsSection] Theme: ${Theme.of(context).brightness}');
    debugPrint('📊 [SettingsSection] ${children.length} items, Show title: $showTitle');

    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced section title
          if (showTitle) ...[
            _buildSectionTitle(themeManager),
            SizedBox(height: 12.h),
          ],

          // Enhanced settings container
          _buildSettingsContainer(themeManager),
        ],
      ),
    );
  }

  /// Builds the section title with comprehensive theme integration
  Widget _buildSectionTitle(ThemeManager themeManager) {
    debugPrint('🎨 [SettingsSection] Building enhanced section title');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            colors: [
              themeManager.accent1.withValues(alpha: 13),
              Colors.transparent,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          darkGradient: LinearGradient(
            colors: [
              themeManager.accent1.withValues(alpha: 26),
              Colors.transparent,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 20.h,
            decoration: BoxDecoration(
              gradient: themeManager.primaryGradient,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: themeManager.conditionalColor(
                lightColor: themeManager.textPrimary,
                darkColor: themeManager.textPrimary,
              ),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the modern settings container with enhanced glass-morphism effect
  Widget _buildSettingsContainer(ThemeManager themeManager) {
    debugPrint('🎨 [SettingsSection] Building enhanced container with glass morphism');

    return Container(
      decoration: BoxDecoration(
        // Enhanced glass-morphism effect with ThemeManager gradients
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
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: themeManager.elevatedShadow,
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: themeManager.borderColor.withValues(alpha: 128),
            darkColor: themeManager.borderColor.withValues(alpha: 77),
          ),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          children: _buildSettingsItems(themeManager),
        ),
      ),
    );
  }

  /// Builds the settings items with automatic dividers
  List<Widget> _buildSettingsItems(ThemeManager themeManager) {
    debugPrint('🎨 [SettingsSection] Building ${children.length} enhanced settings items');

    final List<Widget> items = [];

    for (int i = 0; i < children.length; i++) {
      // Add the settings item
      items.add(children[i]);

      // Add enhanced divider between items (except for the last item)
      if (i < children.length - 1) {
        items.add(_buildDivider(themeManager));
      }
    }

    return items;
  }

  /// Builds an enhanced divider between settings items
  Widget _buildDivider(ThemeManager themeManager) {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            themeManager.conditionalColor(
              lightColor: themeManager.borderColor.withValues(alpha: 77),
              darkColor: themeManager.borderColor.withValues(alpha: 51),
            ),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

/// **THEMEMANAGER INTEGRATED** SettingsItemWidget - Modern individual settings item
///
/// **ThemeManager Features Integrated:**
/// - 🎨 Complete color system integration for all visual elements
/// - 🌈 Enhanced gradients for icon containers and interactive states
/// - 🎯 Theme-aware shadows and elevation effects
/// - 🔄 Conditional styling with professional theming
/// - 🎭 Material Design 3.0 compliance with enhanced accessibility
/// - 🌓 Automatic light/dark mode adaptation
/// - 📊 Comprehensive debug logging throughout
/// - ✨ Enhanced visual feedback with ripple effects and state management
///
/// This widget represents a single settings item with:
/// - Icon with colored background and gradient effects
/// - Title and subtitle text with theme-aware typography
/// - Trailing widget (arrow, switch, etc.) with proper theming
/// - Tap functionality with enhanced ripple effect
/// - Modern design with proper spacing and accessibility
class SettingsItemWidget extends StatelessWidget with ThemeAwareMixin {
  const SettingsItemWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconColor,
    this.trailing,
    this.onTap,
    this.enabled = true,
  });

  /// Main title text for the settings item
  final String title;

  /// Optional subtitle text for additional description
  final String? subtitle;

  /// Icon to be displayed on the left
  final IconData icon;

  /// Color for the icon and its background
  final Color iconColor;

  /// Optional trailing widget (arrow, switch, etc.)
  final Widget? trailing;

  /// Callback when the item is tapped
  final VoidCallback? onTap;

  /// Whether the item is enabled for interaction
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);
    
    debugPrint('🎨 [SettingsItem] Building item "$title"');
    debugPrint('🎯 [SettingsItem] Enabled: $enabled, Has subtitle: ${subtitle != null}');
    debugPrint('📊 [SettingsItem] Has trailing: ${trailing != null}, Has onTap: ${onTap != null}');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16.r),
        splashColor: themeManager.conditionalColor(
          lightColor: themeManager.primaryColor.withValues(alpha: 26),
          darkColor: themeManager.primaryColor.withValues(alpha: 51),
        ),
        highlightColor: themeManager.conditionalColor(
          lightColor: themeManager.accent1.withValues(alpha: 13),
          darkColor: themeManager.accent1.withValues(alpha: 26),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // Enhanced icon container
              _buildIconContainer(themeManager),

              SizedBox(width: 16.w),

              // Enhanced content
              Expanded(
                child: _buildContent(themeManager),
              ),

              // Enhanced trailing widget
              if (trailing != null) ...[
                SizedBox(width: 12.w),
                trailing!,
              ] else if (onTap != null) ...[
                SizedBox(width: 12.w),
                _buildDefaultTrailing(themeManager),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the enhanced icon container with gradient background
  Widget _buildIconContainer(ThemeManager themeManager) {
    debugPrint('🎨 [SettingsItem] Building enhanced icon container');

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: enabled ? [
            iconColor.withValues(alpha: 26),
            iconColor.withValues(alpha: 13),
          ] : [
            themeManager.neutral300.withValues(alpha: 26),
            themeManager.neutral300.withValues(alpha: 13),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: enabled 
            ? iconColor.withValues(alpha: 77)
            : themeManager.neutral300.withValues(alpha: 77),
          width: 1,
        ),
        boxShadow: enabled ? [
          BoxShadow(
            color: iconColor.withValues(alpha: 26),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ] : [],
      ),
      child: Icon(
        icon,
        color: enabled ? iconColor : themeManager.neutral400,
        size: 20.sp,
      ),
    );
  }

  /// Builds the enhanced content section with theme-aware typography
  Widget _buildContent(ThemeManager themeManager) {
    debugPrint('🎨 [SettingsItem] Building enhanced content section');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced title
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: enabled
                ? themeManager.conditionalColor(
                    lightColor: themeManager.textPrimary,
                    darkColor: themeManager.textPrimary,
                  )
                : themeManager.conditionalColor(
                    lightColor: themeManager.textDisabled,
                    darkColor: themeManager.textDisabled,
                  ),
            letterSpacing: -0.2,
          ),
        ),

        // Enhanced subtitle (if provided)
        if (subtitle != null) ...[
          SizedBox(height: 2.h),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 12.sp,
              color: enabled
                  ? themeManager.conditionalColor(
                      lightColor: themeManager.textSecondary,
                      darkColor: themeManager.textSecondary,
                    )
                  : themeManager.conditionalColor(
                      lightColor: themeManager.textDisabled,
                      darkColor: themeManager.textDisabled,
                    ),
              fontWeight: FontWeight.w400,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  /// Builds the enhanced default trailing arrow with theme integration
  Widget _buildDefaultTrailing(ThemeManager themeManager) {
    debugPrint('🎨 [SettingsItem] Building enhanced trailing arrow');

    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            colors: [
              themeManager.neutral200.withValues(alpha: 77),
              themeManager.neutral200.withValues(alpha: 51),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          darkGradient: LinearGradient(
            colors: [
              themeManager.neutral700.withValues(alpha: 77),
              themeManager.neutral700.withValues(alpha: 51),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        Prbal.arrowSync,
        color: enabled
            ? themeManager.conditionalColor(
                lightColor: themeManager.textSecondary,
                darkColor: themeManager.textSecondary,
              )
            : themeManager.conditionalColor(
                lightColor: themeManager.textDisabled,
                darkColor: themeManager.textDisabled,
              ),
        size: 16.sp,
      ),
    );
  }
}
