import 'package:prbal/utils/cubit/radio_cubit.dart';
import 'package:prbal/utils/cubit/theme_cubit.dart';
import 'package:prbal/utils/lang/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/string/string_constants.dart';

/// ThemeChangeDropdown - A dropdown dialog for changing application theme
///
/// This widget provides a modal dialog interface for users to select between:
/// - System default theme (follows device settings)
/// - Light theme
/// - Dark theme
///
/// Features:
/// - Radio button selection with state management via RadioCubit
/// - Localized text using easy_localization
/// - Responsive design with screen size constraints
/// - Cancel/OK action buttons for user confirmation
///
/// State Management:
/// - Uses RadioCubit for managing radio button selection state
/// - Integrates with ThemeCubit to apply selected theme changes
class ThemeChangeDropdown extends StatelessWidget {
  const ThemeChangeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('🎨 ThemeChangeDropdown: Building theme selection dialog');

    // Get screen size for responsive constraints
    final screenSize = MediaQuery.of(context).size;
    debugPrint(
        '🎨 ThemeChangeDropdown: Screen size - width: ${screenSize.width}, height: ${screenSize.height}');

    return BlocProvider(
      create: (context) {
        debugPrint(
            '🎨 ThemeChangeDropdown: Creating RadioCubit for state management');
        return RadioCubit();
      },
      child: BlocBuilder<RadioCubit, String>(
        builder: (context, state) {
          debugPrint('🎨 ThemeChangeDropdown: Radio state changed to: $state');

          return IntrinsicWidth(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                // Responsive width constraints - max 80% of screen, min 280 logical pixels
                maxWidth: screenSize.width * 0.8,
                minWidth: 280.w,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // System default radio option
                  _systemRadio(state, context),
                  // Light theme radio option
                  _lightRadio(state, context),
                  // Dark theme radio option
                  _darkRadio(state, context),
                  // Action buttons (Cancel/OK)
                  _actions(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the dark theme radio button option
  ///
  /// [state] - Current radio selection state from RadioCubit
  /// [context] - Build context for theme and localization access
  Widget _darkRadio(String state, BuildContext context) {
    debugPrint('🎨 ThemeChangeDropdown: Building dark theme radio option');

    final isSelected = state == StringConstants.darkRadio;
    debugPrint(
        '🎨 ThemeChangeDropdown: Dark theme option selected: $isSelected');

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      child: ListTile(
        dense: true,
        leading: Radio(
          value: StringConstants.darkRadio,
          groupValue: state,
          onChanged: (value) {
            debugPrint('🎨 ThemeChangeDropdown: Dark theme radio selected');
            context.read<RadioCubit>().changeValue(value.toString());
          },
        ),
        title: Text(
          LocaleKeys.themeDark,
          style: Theme.of(context).textTheme.titleMedium,
        ).tr(),
      ),
    );
  }

  /// Builds the light theme radio button option
  ///
  /// [state] - Current radio selection state from RadioCubit
  /// [context] - Build context for theme and localization access
  Widget _lightRadio(String state, BuildContext context) {
    debugPrint('🎨 ThemeChangeDropdown: Building light theme radio option');

    final isSelected = state == StringConstants.lightRadio;
    debugPrint(
        '🎨 ThemeChangeDropdown: Light theme option selected: $isSelected');

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      child: ListTile(
        dense: true,
        leading: Radio(
          value: StringConstants.lightRadio,
          groupValue: state,
          onChanged: (value) {
            debugPrint('🎨 ThemeChangeDropdown: Light theme radio selected');
            context.read<RadioCubit>().changeValue(value.toString());
          },
        ),
        title: Text(
          LocaleKeys.themeLight,
          style: Theme.of(context).textTheme.titleMedium,
        ).tr(),
      ),
    );
  }

  /// Builds the system default theme radio button option
  ///
  /// [state] - Current radio selection state from RadioCubit
  /// [context] - Build context for theme and localization access
  Widget _systemRadio(String state, BuildContext context) {
    debugPrint(
        '🎨 ThemeChangeDropdown: Building system default theme radio option');

    final isSelected = state == StringConstants.sysRadio;
    debugPrint(
        '🎨 ThemeChangeDropdown: System default theme option selected: $isSelected');

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      child: ListTile(
        dense: true,
        leading: Radio(
          value: StringConstants.sysRadio,
          groupValue: state,
          onChanged: (value) {
            debugPrint(
                '🎨 ThemeChangeDropdown: System default theme radio selected');
            context.read<RadioCubit>().changeValue(value.toString());
          },
        ),
        title: Text(
          LocaleKeys.themeDefault,
          style: Theme.of(context).textTheme.titleMedium,
        ).tr(),
      ),
    );
  }

  /// Builds the action buttons row (Cancel and OK)
  ///
  /// [context] - Build context for navigation and state access
  /// [state] - Current radio selection state to determine theme to apply
  Row _actions(BuildContext context, String state) {
    debugPrint(
        '🎨 ThemeChangeDropdown: Building action buttons with state: $state');

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [_cancelTextButton(context), _okTextButton(state, context)],
    );
  }

  /// Builds the OK button that applies the selected theme
  ///
  /// [state] - Current radio selection to determine which theme to apply
  /// [context] - Build context for theme cubit access and navigation
  TextButton _okTextButton(String state, BuildContext context) {
    debugPrint('🎨 ThemeChangeDropdown: Building OK button');

    return TextButton(
      onPressed: () {
        debugPrint(
            '🎨 ThemeChangeDropdown: OK button pressed with state: $state');

        // Apply the selected theme based on radio state
        switch (state) {
          case StringConstants.lightRadio:
            debugPrint('🎨 ThemeChangeDropdown: Applying light theme');
            BlocProvider.of<ThemeCubit>(context).makelight();
            Navigator.pop(context);
            break;
          case StringConstants.darkRadio:
            debugPrint('🎨 ThemeChangeDropdown: Applying dark theme');
            BlocProvider.of<ThemeCubit>(context).makeDark();
            Navigator.pop(context);
            break;
          default:
            debugPrint('🎨 ThemeChangeDropdown: Applying system default theme');
            BlocProvider.of<ThemeCubit>(context).makeSystem();
            Navigator.pop(context);
            break;
        }
      },
      child: Text(
        LocaleKeys.buttonOk,
        style: Theme.of(context).textTheme.labelLarge,
      ).tr(),
    );
  }

  /// Builds the Cancel button that dismisses the dialog without changes
  ///
  /// [context] - Build context for navigation
  TextButton _cancelTextButton(BuildContext context) {
    debugPrint('🎨 ThemeChangeDropdown: Building Cancel button');

    return TextButton(
      onPressed: () {
        debugPrint(
            '🎨 ThemeChangeDropdown: Cancel button pressed - dismissing dialog');
        Navigator.pop(context);
      },
      child: Text(
        LocaleKeys.buttonCancel,
        style: Theme.of(context).textTheme.labelLarge,
      ).tr(),
    );
  }
}
