import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

// Components

// Services
import 'package:prbal/services/authentication_notifier.dart';
import 'package:prbal/widgets/settings/settings_section_widget.dart';

/// AccountSettingsWidget - Reusable account settings section
///
/// This widget provides account-related settings options including:
/// - Business Profile (for providers)
/// - Payment & Billing
/// - Verification status
/// - Account Type management with change functionality
/// - Theme-aware styling for light and dark modes
class AccountSettingsWidget extends StatelessWidget {
  const AccountSettingsWidget({
    super.key,
    required this.userType,
    required this.authState,
    required this.onUserTypeChange,
  });

  final String? userType;
  final AuthenticationState authState;
  final VoidCallback onUserTypeChange;

  @override
  Widget build(BuildContext context) {
    debugPrint('⚙️ AccountSettingsWidget: Building account settings');

    return SettingsSectionWidget(
      title: 'Account',
      children: [
        if (userType == 'provider')
          SettingsItemWidget(
            title: 'Business Profile',
            subtitle: 'Manage your services and portfolio',
            icon: LineIcons.briefcase,
            iconColor: const Color(0xFF48BB78),
            onTap: () {
              debugPrint('⚙️ Business Profile tapped');
              // TODO: Navigate to business profile
            },
          ),
        SettingsItemWidget(
          title: 'Payment & Billing',
          subtitle: 'Manage payment methods and history',
          icon: LineIcons.creditCard,
          iconColor: const Color(0xFF9F7AEA),
          onTap: () {
            debugPrint('⚙️ Payment & Billing tapped');
            // TODO: Navigate to payment settings
          },
        ),
        SettingsItemWidget(
          title: 'Verification',
          subtitle: _isVerified(authState.userData) ? 'Account verified' : 'Complete verification',
          icon: Icons.security,
          iconColor: _isVerified(authState.userData) ? const Color(0xFF48BB78) : const Color(0xFFED8936),
          onTap: () {
            debugPrint('⚙️ Verification tapped');
            // TODO: Navigate to verification
          },
        ),
        // User Type Change - available for all user types
        SettingsItemWidget(
          title: 'Account Type',
          subtitle: 'Currently: ${_getUserTypeDisplayName(userType)} - Tap to change',
          icon: Icons.swap_horiz,
          iconColor: const Color(0xFF667EEA),
          onTap: onUserTypeChange,
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: _getUserTypeColor(userType).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: _getUserTypeColor(userType).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              _getUserTypeDisplayName(userType),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: _getUserTypeColor(userType),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Helper methods for user data extraction
  bool _isVerified(Map<String, dynamic>? userData) {
    if (userData == null) return false;
    final isVerified = userData['is_verified'] ?? userData['isVerified'];
    if (isVerified is bool) return isVerified;
    if (isVerified is String) return isVerified.toLowerCase() == 'true';
    return false;
  }

  Color _getUserTypeColor(String? userType) {
    switch (userType?.toLowerCase()) {
      case 'provider':
        return const Color(0xFF48BB78);
      case 'admin':
        return const Color(0xFF9F7AEA);
      case 'customer':
      case 'taker':
      default:
        return const Color(0xFF4299E1);
    }
  }

  String _getUserTypeDisplayName(String? userType) {
    switch (userType?.toLowerCase()) {
      case 'provider':
        return 'Service Provider';
      case 'admin':
        return 'Administrator';
      case 'customer':
        return 'Customer';
      case 'taker':
        return 'Service Taker';
      default:
        return 'User';
    }
  }
}
