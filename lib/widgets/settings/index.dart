/// Settings Components Index
///
/// This file exports all the settings-related widgets for easy importing.
/// The settings screen has been redesigned with a component-based architecture
/// for better maintainability, reusability, and modern UI design.
///
/// ## Component Architecture:
///
/// ### Core Components:
/// - **ProfileSectionWidget**: Modern profile display with user info, stats, and verification
/// - **SettingsSectionWidget**: Container for grouping related settings items
/// - **SettingsItemWidget**: Individual settings items with icons and actions
/// - **LogoutButtonWidget**: Complete logout functionality with confirmation
///
/// ### Settings Section Components:
/// - **AccountSettingsWidget**: Account-related settings (business profile, payment, verification)
/// - **AppSettingsWidget**: Application settings (notifications, security, theme, language)
/// - **AdminControlsWidget**: Admin-specific controls (user management, content moderation)
/// - **DataStorageSettingsWidget**: Data and storage settings (cache, export, sync)
/// - **SupportLegalSettingsWidget**: Support and legal links (help, contact, terms, privacy)
/// - **TokensSettingsWidget**: Security token management (sessions, tokens, revocation)
///
/// ### UI Components:
/// - **SettingsLoadingIndicatorWidget**: Consistent loading indicator for settings
/// - **AppVersionWidget**: App version footer display
/// - **ProfileFormFieldWidget**: Reusable form fields for profile editing
/// - **ProfileStatItemWidget**: Statistics display for user profiles
///
/// ### Handler Components:
/// - **UserTypeChangeHandler**: Comprehensive user type change management
///
/// ### Admin Components:
/// - **SystemHealthWidget**: System health monitoring for admin users
/// - **PerformanceMetricsWidget**: App performance metrics display
///
/// ### Additional Components:
/// - **SettingAppbar**: Localized app bar for settings screens
/// - **SettingsBottomSheets**: Collection of bottom sheet dialogs
/// - **ModernAppBarWidget**: Modern gradient app bar component
/// - **ProfilePictureHandler**: Profile picture update functionality
///
/// ## Usage:
/// ```dart
/// import 'package:prbal/widget/settings/index.dart';
///
/// // Use any component directly
/// ProfileSectionWidget(...)
/// SettingsSectionWidget(...)
/// AccountSettingsWidget(...)
/// AppSettingsWidget(...)
/// ```
library;

// Core Profile Component
export 'profile_section_widget.dart';
export 'profile_picture_handler.dart';

// Settings Structure Components
export 'settings_section_widget.dart';
export 'settings_loading_indicator_widget.dart';

// Settings Section Components
export 'account_settings_widget.dart';
export 'app_settings_widget.dart';
export 'admin_controls_widget.dart';
export 'data_storage_settings_widget.dart';
export 'support_legal_settings_widget.dart';
export 'tokens_settings_widget.dart';

// Form and Display Components
export 'profile_form_field_widget.dart';
export 'profile_stat_item_widget.dart';
export 'app_version_widget.dart';

// Handler Components
export 'user_type_change_handler.dart';

// Admin Components
export 'system_health_widget.dart';
export 'performance_metrics_widget.dart';

// UI Components
export 'setting_appbar.dart';
export 'modern_app_bar_widget.dart';
export 'logout_button_widget.dart';
export 'settings_bottom_sheets.dart';
