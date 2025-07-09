import 'package:flutter/material.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// Components
import 'package:prbal/widgets/settings/settings_section_widget.dart';

/// AdminControlsWidget - Reusable admin controls section
///
/// This widget provides admin-specific settings options including:
/// - User Management
/// - Content Moderation
/// - Analytics & Reports
/// - System Settings
/// - Theme-aware styling for light and dark modes
class AdminControlsWidget extends StatelessWidget {
  const AdminControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('⚙️ AdminControlsWidget: Building admin controls');

    return SettingsSectionWidget(
      title: 'Admin Controls',
      children: [
        SettingsItemWidget(
          title: 'User Management',
          subtitle: 'Manage users and permissions',
          icon: Prbal.users,
          iconColor: const Color(0xFF4299E1),
          onTap: () {
            debugPrint('⚙️ User Management tapped');
            // TODO: Navigate to user management
          },
        ),
        SettingsItemWidget(
          title: 'Content Moderation',
          subtitle: 'Review and moderate content',
          icon: Icons.security,
          iconColor: const Color(0xFF48BB78),
          onTap: () {
            debugPrint('⚙️ Content Moderation tapped');
            // TODO: Navigate to content moderation
          },
        ),
        SettingsItemWidget(
          title: 'Analytics & Reports',
          subtitle: 'View platform analytics',
          icon: Icons.bar_chart,
          iconColor: const Color(0xFF9F7AEA),
          onTap: () {
            debugPrint('⚙️ Analytics & Reports tapped');
            // TODO: Navigate to analytics
          },
        ),
        SettingsItemWidget(
          title: 'System Settings',
          subtitle: 'Configure platform settings',
          icon: Prbal.cog,
          iconColor: const Color(0xFFED8936),
          onTap: () {
            debugPrint('⚙️ System Settings tapped');
            // TODO: Navigate to system settings
          },
        ),
      ],
    );
  }
}
