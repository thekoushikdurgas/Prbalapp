import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// SettingsSectionWidget - Modern settings section container
///
/// This widget groups related settings items together with:
/// - Section title with proper typography
/// - Modern card design with glass-morphism effect
/// - Automatic dividers between items
/// - Theme-aware styling for light and dark modes
/// - Flexible item layout supporting different widget types
class SettingsSectionWidget extends StatelessWidget {
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
    debugPrint('⚙️ SettingsSectionWidget: Building settings section "$title"');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    debugPrint('⚙️ SettingsSectionWidget: Theme is dark: $isDark');
    debugPrint(
        '⚙️ SettingsSectionWidget: Section has ${children.length} items');
    debugPrint('⚙️ SettingsSectionWidget: Show title: $showTitle');

    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          if (showTitle) ...[
            _buildSectionTitle(isDark),
            SizedBox(height: 12.h),
          ],

          // Settings Items Container
          _buildSettingsContainer(isDark),
        ],
      ),
    );
  }

  /// Builds the section title with proper typography
  Widget _buildSectionTitle(bool isDark) {
    debugPrint('⚙️ SettingsSectionWidget: Building section title');

    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 4.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : const Color(0xFF2D3748),
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  /// Builds the modern settings container with glass-morphism effect
  Widget _buildSettingsContainer(bool isDark) {
    debugPrint('⚙️ SettingsSectionWidget: Building settings container');

    return Container(
      decoration: BoxDecoration(
        // Modern glass-morphism effect
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF2D2D2D).withValues(alpha: 0.9),
                  const Color(0xFF1E1E1E).withValues(alpha: 0.95),
                ]
              : [
                  Colors.white.withValues(alpha: 0.95),
                  const Color(0xFFF8F9FA).withValues(alpha: 0.9),
                ],
        ),
        borderRadius: BorderRadius.circular(16.r),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          children: _buildSettingsItems(isDark),
        ),
      ),
    );
  }

  /// Builds the settings items with automatic dividers
  List<Widget> _buildSettingsItems(bool isDark) {
    debugPrint(
        '⚙️ SettingsSectionWidget: Building ${children.length} settings items');

    final List<Widget> items = [];

    for (int i = 0; i < children.length; i++) {
      // Add the settings item
      items.add(children[i]);

      // Add divider between items (except for the last item)
      if (i < children.length - 1) {
        items.add(_buildDivider(isDark));
      }
    }

    return items;
  }

  /// Builds a divider between settings items
  Widget _buildDivider(bool isDark) {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.grey.withValues(alpha: 0.2),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

/// SettingsItemWidget - Modern individual settings item
///
/// This widget represents a single settings item with:
/// - Icon with colored background
/// - Title and subtitle text
/// - Trailing widget (arrow, switch, etc.)
/// - Tap functionality with ripple effect
/// - Modern design with proper spacing
class SettingsItemWidget extends StatelessWidget {
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
    debugPrint('⚙️ SettingsItemWidget: Building settings item "$title"');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    debugPrint('⚙️ SettingsItemWidget: Theme is dark: $isDark');
    debugPrint('⚙️ SettingsItemWidget: Has subtitle: ${subtitle != null}');
    debugPrint('⚙️ SettingsItemWidget: Has trailing: ${trailing != null}');
    debugPrint('⚙️ SettingsItemWidget: Enabled: $enabled');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // Icon Container
              _buildIconContainer(isDark),

              SizedBox(width: 16.w),

              // Content
              Expanded(
                child: _buildContent(isDark),
              ),

              // Trailing Widget
              if (trailing != null) ...[
                SizedBox(width: 12.w),
                trailing!,
              ] else if (onTap != null) ...[
                SizedBox(width: 12.w),
                _buildDefaultTrailing(isDark),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the icon container with colored background
  Widget _buildIconContainer(bool isDark) {
    debugPrint('⚙️ SettingsItemWidget: Building icon container');

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            iconColor.withValues(alpha: 0.15),
            iconColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: enabled ? iconColor : iconColor.withValues(alpha: 0.5),
        size: 20.sp,
      ),
    );
  }

  /// Builds the content section with title and subtitle
  Widget _buildContent(bool isDark) {
    debugPrint('⚙️ SettingsItemWidget: Building content section');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: enabled
                ? (isDark ? Colors.white : const Color(0xFF2D3748))
                : (isDark ? Colors.grey[500] : Colors.grey[400]),
            letterSpacing: -0.2,
          ),
        ),

        // Subtitle (if provided)
        if (subtitle != null) ...[
          SizedBox(height: 2.h),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 12.sp,
              color: enabled
                  ? (isDark ? Colors.grey[400] : Colors.grey[600])
                  : (isDark ? Colors.grey[600] : Colors.grey[500]),
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

  /// Builds the default trailing arrow icon
  Widget _buildDefaultTrailing(bool isDark) {
    debugPrint('⚙️ SettingsItemWidget: Building default trailing arrow');

    return Icon(
      Icons.arrow_forward_ios,
      color: enabled
          ? (isDark ? Colors.grey[400] : Colors.grey[600])
          : (isDark ? Colors.grey[600] : Colors.grey[500]),
      size: 16.sp,
    );
  }
}
