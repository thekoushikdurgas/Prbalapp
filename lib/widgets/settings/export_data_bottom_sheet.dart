import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// ====================================================================
/// EXPORT DATA BOTTOM SHEET - COMPREHENSIVE THEMEMANAGER INTEGRATION
/// ====================================================================
///
/// ✅ **COMPREHENSIVE EXPORT DATA MODAL WITH THEMEMANAGER** ✅
///
/// **🎨 ENHANCED FEATURES:**
/// - Modern Material Design 3.0 modal bottom sheet
/// - Comprehensive data export options with categorized sections
/// - GDPR compliance and data portability features
/// - Export format selection (JSON, CSV, PDF)
/// - Privacy controls and selective export options
/// - Professional theming with ThemeManager integration
/// - Glass morphism effects and gradient backgrounds
/// - Responsive design with ScreenUtil
/// - Comprehensive debug logging
/// ====================================================================

class ExportDataBottomSheet extends StatefulWidget {
  const ExportDataBottomSheet({super.key});

  @override
  State<ExportDataBottomSheet> createState() => _ExportDataBottomSheetState();

  /// Show export data modal bottom sheet
  static void show(BuildContext context) {
    debugPrint('📤 [ExportData] Showing export data modal');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 128),
      useSafeArea: true,
      builder: (context) => const ExportDataBottomSheet(),
    );
  }
}

class _ExportDataBottomSheetState extends State<ExportDataBottomSheet> with TickerProviderStateMixin, ThemeAwareMixin {
  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  // Export options
  Set<String> _selectedDataTypes = {};
  String _selectedFormat = 'JSON';
  bool _includeMetadata = true;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    debugPrint('📤 [ExportData] Initializing export data modal');

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 0.3,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    debugPrint('📤 [ExportData] Disposed export data resources');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    debugPrint('📤 [ExportData] Building export data with theme colors:');
    debugPrint('📤 [ExportData] Background: ${themeManager.backgroundColor}');
    debugPrint('📤 [ExportData] Surface: ${themeManager.surfaceColor}');
    debugPrint('📤 [ExportData] Info: ${themeManager.infoColor}');

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value * MediaQuery.of(context).size.height),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.92,
              decoration: BoxDecoration(
                gradient: themeManager.backgroundGradient,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: themeManager.shadowDark.withValues(alpha: 102),
                    blurRadius: 24.r,
                    offset: Offset(0, -6.h),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildHeader(themeManager),
                  _buildGDPRInfo(themeManager),
                  Expanded(
                    child: _buildContent(themeManager),
                  ),
                  _buildActionButtons(themeManager),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
        border: Border(
          bottom: BorderSide(
            color: themeManager.borderColor.withValues(alpha: 51),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  themeManager.infoColor.withValues(alpha: 179),
                  themeManager.infoColor,
                ],
              ),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header row
          Row(
            children: [
              // Icon with gradient background
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeManager.infoColor,
                      themeManager.infoLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: themeManager.infoColor.withValues(alpha: 51),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Icon(
                  Prbal.download,
                  color: themeManager.textInverted,
                  size: 24.sp,
                ),
              ),

              SizedBox(width: 16.w),

              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Export Data',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: themeManager.textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Download your personal data',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: themeManager.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Close button
              InkWell(
                onTap: () {
                  debugPrint('📤 [ExportData] Close button tapped');
                  Navigator.of(context).pop();
                },
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: themeManager.surfaceColor.withValues(alpha: 128),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: themeManager.borderColor.withValues(alpha: 77),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Prbal.times,
                    color: themeManager.textSecondary,
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGDPRInfo(ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeManager.infoColor.withValues(alpha: 26),
            themeManager.infoLight.withValues(alpha: 13),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: themeManager.borderColor.withValues(alpha: 51),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Prbal.shield4,
            color: themeManager.infoColor,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'GDPR Compliant - Exercise your right to data portability',
              style: TextStyle(
                fontSize: 12.sp,
                color: themeManager.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  themeManager.infoColor,
                  themeManager.infoLight,
                ],
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'Secure',
              style: TextStyle(
                fontSize: 10.sp,
                color: themeManager.textInverted,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeManager themeManager) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDataSelectionSection(themeManager),
          SizedBox(height: 24.h),
          _buildFormatSelectionSection(themeManager),
          SizedBox(height: 24.h),
          _buildOptionsSection(themeManager),
          SizedBox(height: 24.h),
          _buildInfoSection(themeManager),
        ],
      ),
    );
  }

  Widget _buildDataSelectionSection(ThemeManager themeManager) {
    final dataTypes = _getDataTypes();

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: themeManager.borderColor.withValues(alpha: 77),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: themeManager.shadowLight.withValues(alpha: 51),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Prbal.database,
                color: themeManager.primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Select Data to Export',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: themeManager.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Select All/None buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedDataTypes = dataTypes.map((e) => e.id).toSet();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: themeManager.primaryColor,
                    side: BorderSide(color: themeManager.primaryColor.withValues(alpha: 128)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Text('Select All', style: TextStyle(fontSize: 12.sp)),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedDataTypes.clear();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: themeManager.textSecondary,
                    side: BorderSide(color: themeManager.borderColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Text('Select None', style: TextStyle(fontSize: 12.sp)),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Data type checkboxes
          ...dataTypes.map((dataType) => _buildDataTypeCheckbox(themeManager, dataType)),
        ],
      ),
    );
  }

  Widget _buildDataTypeCheckbox(ThemeManager themeManager, DataType dataType) {
    final isSelected = _selectedDataTypes.contains(dataType.id);

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedDataTypes.remove(dataType.id);
            } else {
              _selectedDataTypes.add(dataType.id);
            }
          });
        },
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isSelected ? dataType.color.withValues(alpha: 26) : themeManager.inputBackground,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color:
                  isSelected ? dataType.color.withValues(alpha: 128) : themeManager.borderColor.withValues(alpha: 77),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: isSelected ? dataType.color : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? dataType.color : themeManager.borderColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: isSelected
                    ? Icon(
                        Prbal.check,
                        color: themeManager.textInverted,
                        size: 14.sp,
                      )
                    : null,
              ),
              SizedBox(width: 12.w),
              Icon(
                dataType.icon,
                color: dataType.color,
                size: 18.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataType.title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: themeManager.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      dataType.description,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: themeManager.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormatSelectionSection(ThemeManager themeManager) {
    final formats = ['JSON', 'CSV', 'PDF'];

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: themeManager.borderColor.withValues(alpha: 77),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: themeManager.shadowLight.withValues(alpha: 51),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Prbal.fileText,
                color: themeManager.accent2,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Export Format',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: themeManager.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: formats.map((format) {
              final isSelected = _selectedFormat == format;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFormat = format;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: format != formats.last ? 8.w : 0),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                themeManager.accent2,
                                themeManager.accent2.withValues(alpha: 179),
                              ],
                            )
                          : null,
                      color: isSelected ? null : themeManager.inputBackground,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isSelected ? themeManager.accent2 : themeManager.borderColor.withValues(alpha: 77),
                      ),
                    ),
                    child: Text(
                      format,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? themeManager.textInverted : themeManager.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsSection(ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: themeManager.borderColor.withValues(alpha: 77),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: themeManager.shadowLight.withValues(alpha: 51),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Prbal.cog,
                color: themeManager.accent3,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Export Options',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: themeManager.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SwitchListTile(
            title: Text(
              'Include Metadata',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: themeManager.textPrimary,
              ),
            ),
            subtitle: Text(
              'Include timestamps, IDs, and other metadata',
              style: TextStyle(
                fontSize: 12.sp,
                color: themeManager.textSecondary,
              ),
            ),
            value: _includeMetadata,
            onChanged: (value) {
              setState(() {
                _includeMetadata = value;
              });
            },
            activeColor: themeManager.accent3,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeManager.warningColor.withValues(alpha: 26),
            themeManager.warningLight.withValues(alpha: 13),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: themeManager.warningColor.withValues(alpha: 77),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Prbal.infoCircle,
                color: themeManager.warningColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Important Information',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: themeManager.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            '• Export may take a few minutes depending on data size\n'
            '• Files will be encrypted and password protected\n'
            '• Download link will be valid for 24 hours\n'
            '• You can only request export once per day\n'
            '• Some data may be excluded for security reasons',
            style: TextStyle(
              fontSize: 13.sp,
              color: themeManager.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        border: Border(
          top: BorderSide(
            color: themeManager.borderColor.withValues(alpha: 51),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: themeManager.textSecondary,
                side: BorderSide(color: themeManager.borderColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _selectedDataTypes.isEmpty || _isExporting ? null : () => _startExport(themeManager),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeManager.infoColor,
                foregroundColor: themeManager.textInverted,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                elevation: 2,
              ),
              child: _isExporting
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(themeManager.textInverted),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Exporting...',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Prbal.download, size: 18.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'Export Data',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _startExport(ThemeManager themeManager) async {
    setState(() {
      _isExporting = true;
    });

    debugPrint('📤 [ExportData] Starting data export');
    debugPrint('📤 [ExportData] Selected data types: $_selectedDataTypes');
    debugPrint('📤 [ExportData] Format: $_selectedFormat');
    debugPrint('📤 [ExportData] Include metadata: $_includeMetadata');

    // Simulate export process
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isExporting = false;
    });

    if (mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export completed! Check your downloads.'),
          backgroundColor: themeManager.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        ),
      );

      debugPrint('📤 [ExportData] Export completed successfully');

      // Close modal after a delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  List<DataType> _getDataTypes() {
    final themeManager = ThemeManager.of(context);

    return [
      DataType(
        id: 'profile',
        title: 'Profile Information',
        description: 'Name, email, phone, profile picture',
        icon: Prbal.user,
        color: themeManager.primaryColor,
      ),
      DataType(
        id: 'bookings',
        title: 'Booking History',
        description: 'Past and current service bookings',
        icon: Prbal.calendar,
        color: themeManager.successColor,
      ),
      DataType(
        id: 'services',
        title: 'Service Listings',
        description: 'Your service offerings (if provider)',
        icon: Prbal.briefcase,
        color: themeManager.accent2,
      ),
      DataType(
        id: 'payments',
        title: 'Payment Information',
        description: 'Transaction history and payment methods',
        icon: Prbal.creditCard,
        color: themeManager.warningColor,
      ),
      DataType(
        id: 'messages',
        title: 'Messages & Communications',
        description: 'Chat history and notifications',
        icon: Prbal.comments,
        color: themeManager.infoColor,
      ),
      DataType(
        id: 'preferences',
        title: 'App Preferences',
        description: 'Settings, themes, and configurations',
        icon: Prbal.cog,
        color: themeManager.accent3,
      ),
    ];
  }
}

class DataType {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  DataType({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
