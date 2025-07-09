import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// Components
import 'package:prbal/widgets/settings/settings_section_widget.dart';

/// TokensSettingsWidget - Reusable tokens settings section
///
/// This widget provides security token management options including:
/// - Active Sessions
/// - Access Tokens
/// - Refresh Token
/// - Revoke All Sessions
/// - Theme-aware styling for light and dark modes
class TokensSettingsWidget extends StatelessWidget {
  const TokensSettingsWidget({
    super.key,
    required this.onActiveSessionsTapped,
    // required this.onAccessTokensTapped,
    required this.onRefreshTokenTapped,
    // required this.onRevokeAllSessionsTapped,
  });

  final VoidCallback onActiveSessionsTapped;
  // final VoidCallback onAccessTokensTapped;
  final VoidCallback onRefreshTokenTapped;
  // final VoidCallback onRevokeAllSessionsTapped;

  @override
  Widget build(BuildContext context) {
    debugPrint('⚙️ TokensSettingsWidget: Building tokens settings');

    return SettingsSectionWidget(
      title: 'Security Tokens',
      children: [
        SettingsItemWidget(
          title: 'Active Sessions',
          subtitle: 'Manage your active login sessions',
          icon: Icons.devices,
          iconColor: const Color(0xFF4299E1),
          onTap: onActiveSessionsTapped,
        ),
        // SettingsItemWidget(
        //   title: 'Access Tokens',
        //   subtitle: 'View and manage your access tokens',
        //   icon: Icons.vpn_key,
        //   iconColor: const Color(0xFF48BB78),
        //   onTap: onAccessTokensTapped,
        // ),
        SettingsItemWidget(
          title: 'Refresh Token',
          subtitle: 'Manage your refresh token',
          icon: Icons.refresh,
          iconColor: const Color(0xFF9F7AEA),
          onTap: onRefreshTokenTapped,
        ),
        // SettingsItemWidget(
        //   title: 'Revoke All Sessions',
        //   subtitle: 'Sign out from all devices',
        //   icon: Icons.logout,
        //   iconColor: const Color(0xFFE53E3E),
        //   onTap: onRevokeAllSessionsTapped,
        // ),
      ],
    );
  }
}
