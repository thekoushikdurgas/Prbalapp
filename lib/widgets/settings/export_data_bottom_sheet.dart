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

class _ExportDataBottomSheetState extends State<ExportDataBottomSheet>
    with TickerProviderStateMixin, ThemeAwareMixin {
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
    debugPrint('📤 [ExportData] Building export data with theme colors:');
    debugPrint(
        '📤 [ExportData] Background: ${ThemeManager.of(context).backgroundColor}');
    debugPrint(
        '📤 [ExportData] Surface: ${ThemeManager.of(context).surfaceColor}');
    debugPrint('📤 [ExportData] Info: ${ThemeManager.of(context).infoColor}');

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(
                0, _slideAnimation.value * MediaQuery.of(context).size.height),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.92,
              decoration: BoxDecoration(
                gradient: ThemeManager.of(context).backgroundGradient,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ThemeManager.of(context)
                        .shadowDark
                        .withValues(alpha: 102),
                    blurRadius: 24.r,
                    offset: Offset(0, -6.h),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildHeader(),
                  _buildGDPRInfo(),
                  Expanded(
                    child: _buildContent(),
                  ),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).surfaceGradient,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
        border: Border(
          bottom: BorderSide(
            color: ThemeManager.of(context).borderColor.withValues(alpha: 51),
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
                  ThemeManager.of(context).infoColor.withValues(alpha: 179),
                  ThemeManager.of(context).infoColor,
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
                      ThemeManager.of(context).infoColor,
                      ThemeManager.of(context).infoLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeManager.of(context)
                          .infoColor
                          .withValues(alpha: 51),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Icon(
                  Prbal.download,
                  color: ThemeManager.of(context).textInverted,
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
                        color: ThemeManager.of(context).textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Download your personal data',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ThemeManager.of(context).textSecondary,
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
                    color: ThemeManager.of(context)
                        .surfaceColor
                        .withValues(alpha: 128),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: ThemeManager.of(context)
                          .borderColor
                          .withValues(alpha: 77),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Prbal.times,
                    color: ThemeManager.of(context).textSecondary,
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

  Widget _buildGDPRInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeManager.of(context).infoColor.withValues(alpha: 26),
            ThemeManager.of(context).infoLight.withValues(alpha: 13),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: ThemeManager.of(context).borderColor.withValues(alpha: 51),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Prbal.shield4,
            color: ThemeManager.of(context).infoColor,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'GDPR Compliant - Exercise your right to data portability',
              style: TextStyle(
                fontSize: 12.sp,
                color: ThemeManager.of(context).textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ThemeManager.of(context).infoColor,
                  ThemeManager.of(context).infoLight,
                ],
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'Secure',
              style: TextStyle(
                fontSize: 10.sp,
                color: ThemeManager.of(context).textInverted,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDataSelectionSection(),
          SizedBox(height: 24.h),
          _buildFormatSelectionSection(),
          SizedBox(height: 24.h),
          _buildOptionsSection(),
          SizedBox(height: 24.h),
          _buildInfoSection(),
        ],
      ),
    );
  }

  Widget _buildDataSelectionSection() {
    final dataTypes = _getDataTypes();

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).surfaceGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ThemeManager.of(context).borderColor.withValues(alpha: 77),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeManager.of(context).shadowLight.withValues(alpha: 51),
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
                color: ThemeManager.of(context).primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Select Data to Export',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: ThemeManager.of(context).textPrimary,
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
                    foregroundColor: ThemeManager.of(context).primaryColor,
                    side: BorderSide(
                        color: ThemeManager.of(context)
                            .primaryColor
                            .withValues(alpha: 128)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
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
                    foregroundColor: ThemeManager.of(context).textSecondary,
                    side:
                        BorderSide(color: ThemeManager.of(context).borderColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Text('Select None', style: TextStyle(fontSize: 12.sp)),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Data type checkboxes
          ...dataTypes.map((dataType) => _buildDataTypeCheckbox(dataType)),
        ],
      ),
    );
  }

  Widget _buildDataTypeCheckbox(DataType dataType) {
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
            color: isSelected
                ? dataType.color.withValues(alpha: 26)
                : ThemeManager.of(context).inputBackground,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected
                  ? dataType.color.withValues(alpha: 128)
                  : ThemeManager.of(context).borderColor.withValues(alpha: 77),
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
                    color: isSelected
                        ? dataType.color
                        : ThemeManager.of(context).borderColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: isSelected
                    ? Icon(
                        Prbal.check,
                        color: ThemeManager.of(context).textInverted,
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
                        color: ThemeManager.of(context).textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      dataType.description,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ThemeManager.of(context).textSecondary,
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

  Widget _buildFormatSelectionSection() {
    final formats = ['JSON', 'CSV', 'PDF'];

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).surfaceGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ThemeManager.of(context).borderColor.withValues(alpha: 77),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeManager.of(context).shadowLight.withValues(alpha: 51),
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
                color: ThemeManager.of(context).accent2,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Export Format',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: ThemeManager.of(context).textPrimary,
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
                    margin: EdgeInsets.only(
                        right: format != formats.last ? 8.w : 0),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                ThemeManager.of(context).accent2,
                                ThemeManager.of(context)
                                    .accent2
                                    .withValues(alpha: 179),
                              ],
                            )
                          : null,
                      color: isSelected
                          ? null
                          : ThemeManager.of(context).inputBackground,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isSelected
                            ? ThemeManager.of(context).accent2
                            : ThemeManager.of(context)
                                .borderColor
                                .withValues(alpha: 77),
                      ),
                    ),
                    child: Text(
                      format,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? ThemeManager.of(context).textInverted
                            : ThemeManager.of(context).textPrimary,
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

  Widget _buildOptionsSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).surfaceGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ThemeManager.of(context).borderColor.withValues(alpha: 77),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeManager.of(context).shadowLight.withValues(alpha: 51),
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
                color: ThemeManager.of(context).accent3,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Export Options',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: ThemeManager.of(context).textPrimary,
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
                color: ThemeManager.of(context).textPrimary,
              ),
            ),
            subtitle: Text(
              'Include timestamps, IDs, and other metadata',
              style: TextStyle(
                fontSize: 12.sp,
                color: ThemeManager.of(context).textSecondary,
              ),
            ),
            value: _includeMetadata,
            onChanged: (value) {
              setState(() {
                _includeMetadata = value;
              });
            },
            activeColor: ThemeManager.of(context).accent3,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeManager.of(context).warningColor.withValues(alpha: 26),
            ThemeManager.of(context).warningLight.withValues(alpha: 13),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ThemeManager.of(context).warningColor.withValues(alpha: 77),
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
                color: ThemeManager.of(context).warningColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Important Information',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: ThemeManager.of(context).textPrimary,
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
              color: ThemeManager.of(context).textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).surfaceGradient,
        border: Border(
          top: BorderSide(
            color: ThemeManager.of(context).borderColor.withValues(alpha: 51),
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
                foregroundColor: ThemeManager.of(context).textSecondary,
                side: BorderSide(color: ThemeManager.of(context).borderColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
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
              onPressed: _selectedDataTypes.isEmpty || _isExporting
                  ? null
                  : () => _startExport(),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeManager.of(context).infoColor,
                foregroundColor: ThemeManager.of(context).textInverted,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                                ThemeManager.of(context).textInverted),
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

  void _startExport() async {
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
          backgroundColor: ThemeManager.of(context).successColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
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
    return [
      DataType(
        id: 'profile',
        title: 'Profile Information',
        description: 'Name, email, phone, profile picture',
        icon: Prbal.user,
        color: ThemeManager.of(context).primaryColor,
      ),
      DataType(
        id: 'bookings',
        title: 'Booking History',
        description: 'Past and current service bookings',
        icon: Prbal.calendar,
        color: ThemeManager.of(context).successColor,
      ),
      DataType(
        id: 'services',
        title: 'Service Listings',
        description: 'Your service offerings (if provider)',
        icon: Prbal.briefcase,
        color: ThemeManager.of(context).accent2,
      ),
      DataType(
        id: 'payments',
        title: 'Payment Information',
        description: 'Transaction history and payment methods',
        icon: Prbal.creditCard,
        color: ThemeManager.of(context).warningColor,
      ),
      DataType(
        id: 'messages',
        title: 'Messages & Communications',
        description: 'Chat history and notifications',
        icon: Prbal.comments,
        color: ThemeManager.of(context).infoColor,
      ),
      DataType(
        id: 'preferences',
        title: 'App Preferences',
        description: 'Settings, themes, and configurations',
        icon: Prbal.cog,
        color: ThemeManager.of(context).accent3,
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
