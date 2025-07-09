import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:prbal/services/user_service.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

// Components

// Services
//
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
    // required this.authState,
    required this.onUserTypeChange,
    required this.userData,
  });

  final UserType userType;
  final AppUser userData;
  // final AuthenticationState authState;
  final VoidCallback onUserTypeChange;

  @override
  Widget build(BuildContext context) {
    debugPrint('⚙️ AccountSettingsWidget: Building account settings');

    return SettingsSectionWidget(
      title: 'Account',
      children: [
        if (userType == UserType.provider)
          SettingsItemWidget(
            title: 'Business Profile',
            subtitle: 'Manage your services and portfolio',
            icon: Prbal.briefcase,
            iconColor: const Color(0xFF48BB78),
            onTap: () {
              debugPrint('⚙️ Business Profile tapped');
              // TODO: Navigate to business profile
            },
          ),
        SettingsItemWidget(
          title: 'Payment & Billing',
          subtitle: 'Manage payment methods and history',
          icon: Prbal.creditCard,
          iconColor: const Color(0xFF9F7AEA),
          onTap: () {
            debugPrint('⚙️ Payment & Billing tapped');
            // TODO: Navigate to payment settings
          },
        ),
        SettingsItemWidget(
          title: 'Verification',
          subtitle: userData.isVerified ? 'Account verified' : 'Complete verification',
          icon: Icons.security,
          iconColor: userData.isVerified ? const Color(0xFF48BB78) : const Color(0xFFED8936),
          onTap: () {
            debugPrint('⚙️ Verification tapped');
            // TODO: Navigate to verification
          },
        ),
        // User Type Change - available for all user types
        SettingsItemWidget(
          title: 'Account Type',
          subtitle: 'Currently: ${getUserTypeDisplayName(userType)} - Tap to change',
          icon: Icons.swap_horiz,
          iconColor: const Color(0xFF667EEA),
          onTap: onUserTypeChange,
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: ThemeManager.of(context).getUserTypeColor(userType).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: ThemeManager.of(context).getUserTypeColor(userType).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              getUserTypeDisplayName(userType),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: ThemeManager.of(context).getUserTypeColor(userType),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
