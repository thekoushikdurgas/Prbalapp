import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Utils
import 'package:prbal/utils/settings/settings_utils.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// **THEMEMANAGER INTEGRATED** Reusable token card widget for displaying token information
///
/// **ThemeManager Features Integrated:**
/// - 🎨 Complete color system (primary, accent, neutral, text, status colors)
/// - 🌈 Enhanced gradients (surface, neutral, status gradients)
/// - 🎯 Theme-aware shadows (subtle, elevated shadows)
/// - 🔄 Conditional styling with helper methods
/// - 🎭 Professional Material Design 3.0 compliance
/// - 🌓 Automatic light/dark mode adaptation
/// - 📊 Comprehensive debug logging and token state monitoring
/// - ✨ Enhanced visual feedback with status indicators and security theming
/// - 🔒 Security-focused design with token masking and device information display
class TokenCardWidget extends StatelessWidget with ThemeAwareMixin {
  final Map<String, dynamic> token;
  final bool showRevokeOption;
  final VoidCallback? onRevoke;

  const TokenCardWidget({
    super.key,
    required this.token,
    this.showRevokeOption = false,
    this.onRevoke,
  });

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);
    final jti = token['jti'] as String? ?? 'Unknown';
    final isActive = token['is_active'] as bool? ?? false;
    final createdAt = token['created_at'] as String?;
    final lastUsed = token['last_used'] as String?;
    final deviceInfo = token['device_info'] as Map<String, dynamic>?;

    // 📊 Debug logging
    debugPrint(
        '🔐 [TokenCard] Building token card for JTI: ${jti.substring(0, 8)}...');
    debugPrint('🎯 [TokenCard] Status: ${isActive ? "Active" : "Inactive"}');
    debugPrint(
        '📊 [TokenCard] Show revoke: $showRevokeOption, Has device info: ${deviceInfo != null}');

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
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
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: themeManager.conditionalColor(
            lightColor: themeManager.borderColor.withValues(alpha: 128),
            darkColor: themeManager.borderColor.withValues(alpha: 77),
          ),
          width: 1,
        ),
        boxShadow: themeManager.subtleShadow,
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced token status header
            _buildStatusHeader(themeManager, isActive, jti),

            SizedBox(height: 12.h),

            // Enhanced token information
            _buildTokenInfo(themeManager, jti, createdAt, lastUsed),

            // Enhanced device info section
            if (deviceInfo != null) ...[
              SizedBox(height: 12.h),
              _buildDeviceInfo(themeManager, deviceInfo),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds the enhanced status header with theme integration
  Widget _buildStatusHeader(
      ThemeManager themeManager, bool isActive, String jti) {
    debugPrint('🔐 [TokenCard] Building enhanced status header');

    return Row(
      children: [
        // Enhanced status indicator
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isActive
                  ? [
                      themeManager.successColor.withValues(alpha: 26),
                      themeManager.successColor.withValues(alpha: 13),
                    ]
                  : [
                      themeManager.errorColor.withValues(alpha: 26),
                      themeManager.errorColor.withValues(alpha: 13),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isActive
                  ? themeManager.successColor.withValues(alpha: 77)
                  : themeManager.errorColor.withValues(alpha: 77),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: isActive
                      ? themeManager.successColor
                      : themeManager.errorColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isActive
                              ? themeManager.successColor
                              : themeManager.errorColor)
                          .withValues(alpha: 77),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? themeManager.successColor
                      : themeManager.errorColor,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // Enhanced revoke button
        if (showRevokeOption && isActive && onRevoke != null)
          Container(
            decoration: BoxDecoration(
              gradient: themeManager.errorGradient,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: themeManager.errorColor.withValues(alpha: 51),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onRevoke,
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  child: Text(
                    'Revoke',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Builds the enhanced token information section
  Widget _buildTokenInfo(ThemeManager themeManager, String jti,
      String? createdAt, String? lastUsed) {
    debugPrint('🔐 [TokenCard] Building enhanced token info');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced token ID with security styling
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: themeManager.conditionalGradient(
              lightGradient: LinearGradient(
                colors: [
                  themeManager.neutral100.withValues(alpha: 128),
                  themeManager.neutral100.withValues(alpha: 77),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              darkGradient: LinearGradient(
                colors: [
                  themeManager.neutral800.withValues(alpha: 128),
                  themeManager.neutral800.withValues(alpha: 77),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: themeManager.conditionalColor(
                lightColor: themeManager.neutral300.withValues(alpha: 128),
                darkColor: themeManager.neutral600.withValues(alpha: 128),
              ),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.security,
                size: 16.sp,
                color: themeManager.conditionalColor(
                  lightColor: themeManager.accent1,
                  darkColor: themeManager.accent1,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Token ID: ${jti.substring(0, 8)}••••',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                  color: themeManager.conditionalColor(
                    lightColor: themeManager.textPrimary,
                    darkColor: themeManager.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 8.h),

        // Enhanced timestamps with better layout
        if (createdAt != null || lastUsed != null)
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              gradient: themeManager.conditionalGradient(
                lightGradient: LinearGradient(
                  colors: [
                    themeManager.infoColor.withValues(alpha: 13),
                    themeManager.infoColor.withValues(alpha: 8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                darkGradient: LinearGradient(
                  colors: [
                    themeManager.infoColor.withValues(alpha: 26),
                    themeManager.infoColor.withValues(alpha: 13),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (createdAt != null)
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14.sp,
                        color: themeManager.infoColor,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Created: ${SettingsUtils.formatDateTime(createdAt)}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: themeManager.conditionalColor(
                            lightColor: themeManager.textSecondary,
                            darkColor: themeManager.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (lastUsed != null) ...[
                  if (createdAt != null) SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14.sp,
                        color: themeManager.accent2,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Last used: ${SettingsUtils.formatDateTime(lastUsed)}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: themeManager.conditionalColor(
                            lightColor: themeManager.textSecondary,
                            darkColor: themeManager.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  /// Builds the enhanced device information section
  Widget _buildDeviceInfo(
      ThemeManager themeManager, Map<String, dynamic> deviceInfo) {
    debugPrint('🔐 [TokenCard] Building enhanced device info');

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: themeManager.conditionalGradient(
          lightGradient: LinearGradient(
            colors: [
              themeManager.warningColor.withValues(alpha: 13),
              themeManager.warningColor.withValues(alpha: 8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          darkGradient: LinearGradient(
            colors: [
              themeManager.warningColor.withValues(alpha: 26),
              themeManager.warningColor.withValues(alpha: 13),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: themeManager.warningColor.withValues(alpha: 77),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Device info header
          Row(
            children: [
              Icon(
                Icons.devices,
                size: 16.sp,
                color: themeManager.warningColor,
              ),
              SizedBox(width: 6.w),
              Text(
                'Device Information',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: themeManager.warningColor,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // Device details
          if (deviceInfo['ip_address'] != null)
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 12.sp,
                  color: themeManager.conditionalColor(
                    lightColor: themeManager.textTertiary,
                    darkColor: themeManager.textTertiary,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  'IP: ${deviceInfo['ip_address']}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontFamily: 'monospace',
                    color: themeManager.conditionalColor(
                      lightColor: themeManager.textSecondary,
                      darkColor: themeManager.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          if (deviceInfo['user_agent'] != null) ...[
            if (deviceInfo['ip_address'] != null) SizedBox(height: 4.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.phone_android,
                  size: 12.sp,
                  color: themeManager.conditionalColor(
                    lightColor: themeManager.textTertiary,
                    darkColor: themeManager.textTertiary,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    'Device: ${SettingsUtils.parseUserAgent(deviceInfo['user_agent'])}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: themeManager.conditionalColor(
                        lightColor: themeManager.textSecondary,
                        darkColor: themeManager.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
