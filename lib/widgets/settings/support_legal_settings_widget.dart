import 'package:flutter/material.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// Components
import 'package:prbal/widgets/settings/settings_section_widget.dart';

/// SupportLegalSettingsWidget - Reusable support & legal settings section
///
/// This widget provides support and legal related settings options including:
/// - Help Center
/// - Contact Us
/// - Terms of Service
/// - Privacy Policy
/// - Theme-aware styling for light and dark modes
class SupportLegalSettingsWidget extends StatelessWidget {
  const SupportLegalSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('⚙️ SupportLegalSettingsWidget: Building support & legal settings');

    return SettingsSectionWidget(
      title: 'Support & Legal',
      children: [
        SettingsItemWidget(
          title: 'Help Center',
          subtitle: 'Get help and support',
          icon: Prbal.questionCircle,
          iconColor: const Color(0xFF4299E1),
          onTap: () {
            debugPrint('⚙️ Help Center tapped');
            // TODO: Navigate to help center
          },
        ),
        SettingsItemWidget(
          title: 'Contact Us',
          subtitle: 'Get in touch with our team',
          icon: Prbal.envelope,
          iconColor: const Color(0xFF48BB78),
          onTap: () {
            debugPrint('⚙️ Contact Us tapped');
            // TODO: Navigate to contact
          },
        ),
        SettingsItemWidget(
          title: 'Terms of Service',
          subtitle: 'Read our terms and conditions',
          icon: Prbal.file,
          iconColor: const Color(0xFF9F7AEA),
          onTap: () {
            debugPrint('⚙️ Terms of Service tapped');
            // TODO: Navigate to terms
          },
        ),
        SettingsItemWidget(
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          icon: Prbal.shield,
          iconColor: const Color(0xFFED8936),
          onTap: () {
            debugPrint('⚙️ Privacy Policy tapped');
            // TODO: Navigate to privacy policy
          },
        ),
      ],
    );
  }
}
