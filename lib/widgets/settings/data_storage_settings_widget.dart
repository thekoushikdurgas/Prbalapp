import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// Components
import 'package:prbal/widgets/settings/settings_section_widget.dart';
import 'package:prbal/widgets/settings/settings_bottom_sheets.dart';

/// DataStorageSettingsWidget - Reusable data storage settings section
///
/// This widget provides data and storage related settings options including:
/// - Storage Usage display
/// - Clear Cache functionality
/// - Export Data options
/// - Data Sync settings
/// - Theme-aware styling for light and dark modes
class DataStorageSettingsWidget extends StatelessWidget {
  const DataStorageSettingsWidget({
    super.key,
    required this.onClearCache,
  });

  final VoidCallback onClearCache;

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '⚙️ DataStorageSettingsWidget: Building data & storage settings');

    return SettingsSectionWidget(
      title: 'Data & Storage',
      children: [
        SettingsItemWidget(
          title: 'Storage Usage',
          subtitle: 'View app storage and cache usage',
          icon: Icons.storage,
          iconColor: const Color(0xFF38B2AC),
          onTap: () => SettingsBottomSheets.showStorageBottomSheet(context),
        ),
        SettingsItemWidget(
          title: 'Clear Cache',
          subtitle: 'Free up space by clearing cached data',
          icon: Icons.cleaning_services,
          iconColor: const Color(0xFFED8936),
          onTap: onClearCache,
        ),
        SettingsItemWidget(
          title: 'Export Data',
          subtitle: 'Download your personal data',
          icon: Icons.download,
          iconColor: const Color(0xFF4299E1),
          onTap: () {},
        ),
        SettingsItemWidget(
          title: 'Data Sync',
          subtitle: 'Manage data synchronization settings',
          icon: Icons.sync,
          iconColor: const Color(0xFF9F7AEA),
          onTap: () {},
        ),
      ],
    );
  }
}
