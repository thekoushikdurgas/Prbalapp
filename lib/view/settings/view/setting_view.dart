import 'package:prbal/components/lisstile/changer_listtile_with_dropdown.dart';
import 'package:prbal/components/dropdown/theme_change_dropdown.dart';
import 'package:prbal/constants/icon/icon_constants.dart';
import 'package:prbal/main.dart';
import 'package:prbal/product/init/lang/locale_keys.g.dart';
import 'package:prbal/product/widget/appbar/setting_appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:prbal/services/auth_service.dart';
import 'package:prbal/product/enum/route_enum.dart';

class SettingView extends ConsumerWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const SettingAppbar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Theme settings
                Card(
                  elevation: 2,
                  shadowColor: colorScheme.shadow,
                  child: ChangerListtileWithDropdown(
                    icon: IconConstants.themeIcon,
                    title: LocaleKeys.themeTheme.tr(),
                    alertTitle: LocaleKeys.themeThemeChoose.tr(),
                    child: const ThemeChangeDropdown(),
                  ),
                ),

                SizedBox(height: 16.h),

                // Localization settings
                Card(
                  elevation: 2,
                  shadowColor: colorScheme.shadow,
                  child: ChangerListtileWithDropdown(
                    icon: IconConstants.localizationIcon,
                    title: LocaleKeys.localizationAppLang.tr(),
                    alertTitle: LocaleKeys.localizationLangChoose.tr(),
                    child: changeLocalWithDropdown(context),
                  ),
                ),

                SizedBox(height: 16.h),

                // Security Section
                if (currentUser != null) ...[
                  Card(
                    elevation: 2,
                    shadowColor: colorScheme.shadow,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.surface,
                            colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        colorScheme.primary,
                                        colorScheme.primaryContainer,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    LineIcons.userShield,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  'Security',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildPinResetTile(context, ref, theme, colorScheme),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinResetTile(BuildContext context, WidgetRef ref,
      ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Icon(
            LineIcons.lock,
            color: colorScheme.primary,
            size: 20.sp,
          ),
        ),
        title: Text(
          'Reset PIN',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Change your security PIN',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            LineIcons.angleRight,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            size: 16.sp,
          ),
        ),
        onTap: () => _showPinResetDialog(context, ref, theme, colorScheme),
      ),
    );
  }

  Future<void> _showPinResetDialog(BuildContext context, WidgetRef ref,
      ThemeData theme, ColorScheme colorScheme) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser?.phoneNumber == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                LineIcons.lock,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Reset PIN',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to reset your PIN?',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'You will be redirected to create a new PIN.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            child: Text(
              'Cancel',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Reset',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Navigate to PIN reset screen
      context.push(
        RouteEnum.pinEntry.rawValue,
        extra: {
          'phoneNumber': currentUser!.phoneNumber!,
          'isNewUser': true, // Treat as new user to set new PIN
        },
      );
    }
  }

  DropdownButton<dynamic> changeLocalWithDropdown(BuildContext context) {
    return DropdownButton(
      value: context.locale,
      items: LocaleVariables.localItems(),
      onChanged: (value) {
        context.setLocale(value);
        Navigator.pop(context);
      },
    );
  }
}
