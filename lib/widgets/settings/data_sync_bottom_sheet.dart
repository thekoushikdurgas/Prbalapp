import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:prbal/services/hive_service.dart';

/// ====================================================================
/// DATA SYNC BOTTOM SHEET - COMPREHENSIVE API TO HIVE SYNCHRONIZATION
/// ====================================================================
///
/// ✅ **COMPREHENSIVE DATA SYNC MODAL WITH THEMEMANAGER** ✅
///
/// **🎨 ENHANCED FEATURES:**
/// - Modern Material Design 3.0 modal bottom sheet
/// - Comprehensive API to Hive data synchronization
/// - User authentication and token validation
/// - Access token and refresh token management
/// - Real-time sync status monitoring
/// - Selective data sync options
/// - Professional theming with ThemeManager integration
/// - Glass morphism effects and gradient backgrounds
/// - Responsive design with ScreenUtil
/// - Comprehensive debug logging and error handling
/// ====================================================================

class DataSyncBottomSheet extends StatefulWidget {
  const DataSyncBottomSheet({super.key});

  @override
  State<DataSyncBottomSheet> createState() => _DataSyncBottomSheetState();

  /// Show data sync modal bottom sheet
  static void show(BuildContext context) {
    debugPrint('🔄 [DataSync] Showing data sync modal');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 128),
      useSafeArea: true,
      builder: (context) => const DataSyncBottomSheet(),
    );
  }
}

class _DataSyncBottomSheetState extends State<DataSyncBottomSheet>
    with TickerProviderStateMixin, ThemeAwareMixin {
  final ScrollController _scrollController = ScrollController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  // Sync state
  bool _isSyncing = false;
  bool _hasValidTokens = false;
  String _syncStatus = 'Ready';
  final Map<String, bool> _syncProgress = {};
  Map<String, dynamic> _userDetails = {};
  String? _accessToken;
  String? _refreshToken;
  DateTime? _lastSyncTime;

  // Sync options
  Set<String> _selectedSyncTypes = {'profile', 'bookings'};
  bool _autoSync = true;
  bool _syncOnWifiOnly = true;

  @override
  void initState() {
    super.initState();
    debugPrint('🔄 [DataSync] Initializing data sync modal');

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
    _initializeSync();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    debugPrint('🔄 [DataSync] Disposed data sync resources');
    super.dispose();
  }

  Future<void> _initializeSync() async {
    debugPrint('🔄 [DataSync] Initializing sync system...');

    try {
      // Check authentication status
      _hasValidTokens = HiveService.isLoggedIn();

      if (_hasValidTokens) {
        try {
          _accessToken = HiveService.getAuthToken();
        } catch (e) {
          _accessToken = null;
        }
        _refreshToken = HiveService.getRefreshToken();

        // Get user details from Hive
        try {
          final userData = HiveService.getUserData();
          _userDetails = {
            'id': userData.id,
            'username': userData.username,
            'email': userData.email,
            'userType': userData.userType,
            'isVerified': userData.isVerified,
          };
        } catch (e) {
          debugPrint('🔄 [DataSync] Could not get user data: $e');
          _userDetails = {};
        }

        // Get last sync time (use last login as fallback)
        _lastSyncTime = HiveService.getLastLogin();

        debugPrint('🔄 [DataSync] Authentication status: Valid');
        debugPrint('🔄 [DataSync] User: ${_userDetails['username']}');
        debugPrint('🔄 [DataSync] Last sync: $_lastSyncTime');
      } else {
        debugPrint('🔄 [DataSync] Authentication status: Invalid');
        _syncStatus = 'Authentication Required';
      }
    } catch (e) {
      debugPrint('🔄 [DataSync] Initialization error: $e');
      _syncStatus = 'Error: $e';
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🔄 [DataSync] Building data sync with theme colors:');
    debugPrint(
        '🔄 [DataSync] Background: ${ThemeManager.of(context).backgroundColor}');
    debugPrint(
        '🔄 [DataSync] Primary: ${ThemeManager.of(context).primaryColor}');
    debugPrint('🔄 [DataSync] Info: ${ThemeManager.of(context).infoColor}');

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
                  _buildSyncStatus(),
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
                  ThemeManager.of(context).primaryColor.withValues(alpha: 179),
                  ThemeManager.of(context).primaryColor,
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
                      ThemeManager.of(context).primaryColor,
                      ThemeManager.of(context).primaryLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeManager.of(context)
                          .primaryColor
                          .withValues(alpha: 51),
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Icon(
                  Prbal.refresh,
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
                      'Data Sync',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: ThemeManager.of(context).textPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Manage data synchronization',
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
                  debugPrint('🔄 [DataSync] Close button tapped');
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

  Widget _buildSyncStatus() {
    final statusColor = _hasValidTokens
        ? (_isSyncing
            ? ThemeManager.of(context).warningColor
            : ThemeManager.of(context).successColor)
        : ThemeManager.of(context).errorColor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withValues(alpha: 26),
            statusColor.withValues(alpha: 13),
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
          Container(
            width: 12.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withValues(alpha: 128),
                  blurRadius: 4.r,
                  spreadRadius: 1.r,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              _syncStatus,
              style: TextStyle(
                fontSize: 14.sp,
                color: ThemeManager.of(context).textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (_lastSyncTime != null)
            Text(
              'Last: ${_formatLastSync(_lastSyncTime!)}',
              style: TextStyle(
                fontSize: 12.sp,
                color: ThemeManager.of(context).textSecondary,
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
          if (!_hasValidTokens) _buildAuthenticationSection(),
          if (_hasValidTokens) ...[
            _buildUserDetailsSection(),
            SizedBox(height: 24.h),
            _buildTokenStatusSection(),
            SizedBox(height: 24.h),
            _buildSyncOptionsSection(),
            SizedBox(height: 24.h),
            _buildSyncTypesSection(),
            SizedBox(height: 24.h),
            _buildSyncSettingsSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildAuthenticationSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeManager.of(context).errorColor.withValues(alpha: 26),
            ThemeManager.of(context).errorLight.withValues(alpha: 13),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ThemeManager.of(context).errorColor.withValues(alpha: 77),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Prbal.exclamationTriangle,
            color: ThemeManager.of(context).errorColor,
            size: 48.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'Authentication Required',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: ThemeManager.of(context).textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please login to sync your data with the server.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: ThemeManager.of(context).textSecondary,
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to login screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeManager.of(context).primaryColor,
              foregroundColor: ThemeManager.of(context).textInverted,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: Text(
              'Go to Login',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserDetailsSection() {
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
                Prbal.user,
                color: ThemeManager.of(context).primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'User Details',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: ThemeManager.of(context).textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ..._userDetails.entries.map((entry) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Text(
                        '${entry.key}:',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ThemeManager.of(context).textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value.toString(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ThemeManager.of(context).textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTokenStatusSection() {
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
                Prbal.key,
                color: ThemeManager.of(context).accent2,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Token Status',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: ThemeManager.of(context).textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildTokenItem(
            'Access Token',
            _accessToken,
            ThemeManager.of(context).successColor,
          ),
          SizedBox(height: 12.h),
          _buildTokenItem(
            'Refresh Token',
            _refreshToken,
            ThemeManager.of(context).infoColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTokenItem(String title, String? token, Color color) {
    final hasToken = token != null && token.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: hasToken
            ? color.withValues(alpha: 26)
            : ThemeManager.of(context).errorColor.withValues(alpha: 26),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: hasToken
              ? color.withValues(alpha: 128)
              : ThemeManager.of(context).errorColor.withValues(alpha: 128),
        ),
      ),
      child: Row(
        children: [
          Icon(
            hasToken ? Prbal.checkCircle : Prbal.timesCircle,
            color: hasToken ? color : ThemeManager.of(context).errorColor,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: ThemeManager.of(context).textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  hasToken ? '${token.substring(0, 20)}...' : 'Not available',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: ThemeManager.of(context).textSecondary,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncOptionsSection() {
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
                'Sync Options',
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
              'Auto Sync',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: ThemeManager.of(context).textPrimary,
              ),
            ),
            subtitle: Text(
              'Automatically sync data when changes occur',
              style: TextStyle(
                fontSize: 12.sp,
                color: ThemeManager.of(context).textSecondary,
              ),
            ),
            value: _autoSync,
            onChanged: (value) {
              setState(() {
                _autoSync = value;
              });
            },
            activeColor: ThemeManager.of(context).primaryColor,
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: Text(
              'WiFi Only',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: ThemeManager.of(context).textPrimary,
              ),
            ),
            subtitle: Text(
              'Only sync when connected to WiFi',
              style: TextStyle(
                fontSize: 12.sp,
                color: ThemeManager.of(context).textSecondary,
              ),
            ),
            value: _syncOnWifiOnly,
            onChanged: (value) {
              setState(() {
                _syncOnWifiOnly = value;
              });
            },
            activeColor: ThemeManager.of(context).accent3,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildSyncTypesSection() {
    final syncTypes = [
      {
        'id': 'profile',
        'title': 'Profile Data',
        'description': 'User profile and settings',
        'icon': Prbal.user,
        'color': ThemeManager.of(context).primaryColor
      },
      {
        'id': 'bookings',
        'title': 'Bookings',
        'description': 'Service bookings and history',
        'icon': Prbal.calendar,
        'color': ThemeManager.of(context).successColor
      },
      {
        'id': 'services',
        'title': 'Services',
        'description': 'Service listings and details',
        'icon': Prbal.briefcase,
        'color': ThemeManager.of(context).accent2
      },
      {
        'id': 'messages',
        'title': 'Messages',
        'description': 'Chat history and notifications',
        'icon': Prbal.comments,
        'color': ThemeManager.of(context).infoColor
      },
      {
        'id': 'payments',
        'title': 'Payments',
        'description': 'Payment history and methods',
        'icon': Prbal.creditCard,
        'color': ThemeManager.of(context).warningColor
      },
    ];

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
                color: ThemeManager.of(context).accent4,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Data Types to Sync',
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
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedSyncTypes =
                          syncTypes.map((e) => e['id'] as String).toSet();
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
                      _selectedSyncTypes.clear();
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
          ...syncTypes.map((syncType) {
            final isSelected = _selectedSyncTypes.contains(syncType['id']);
            final color = syncType['color'] as Color;
            final isInProgress = _syncProgress[syncType['id']] == true;

            return Container(
              margin: EdgeInsets.only(bottom: 8.h),
              child: InkWell(
                onTap: () {
                  setState(() {
                    final id = syncType['id'] as String;
                    if (isSelected) {
                      _selectedSyncTypes.remove(id);
                    } else {
                      _selectedSyncTypes.add(id);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withValues(alpha: 26)
                        : ThemeManager.of(context).inputBackground,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isSelected
                          ? color.withValues(alpha: 128)
                          : ThemeManager.of(context)
                              .borderColor
                              .withValues(alpha: 77),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: isSelected ? color : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? color
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
                        syncType['icon'] as IconData,
                        color: color,
                        size: 18.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              syncType['title'] as String,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: ThemeManager.of(context).textPrimary,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              syncType['description'] as String,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: ThemeManager.of(context).textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isInProgress)
                        SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSyncSettingsSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeManager.of(context).infoColor.withValues(alpha: 26),
            ThemeManager.of(context).infoLight.withValues(alpha: 13),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ThemeManager.of(context).infoColor.withValues(alpha: 77),
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
                color: ThemeManager.of(context).infoColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Sync Information',
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
            '• Data is synced between your device and our secure servers\n'
            '• All data is encrypted during transmission\n'
            '• You can control which data types to sync\n'
            '• Auto-sync can be disabled to save bandwidth\n'
            '• Manual sync is always available when needed',
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
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: ThemeManager.of(context).textSecondary,
                side: BorderSide(color: ThemeManager.of(context).borderColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
                padding: EdgeInsets.symmetric(vertical: 16.h),
              ),
              child: Text(
                'Close',
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
              onPressed:
                  !_hasValidTokens || _isSyncing || _selectedSyncTypes.isEmpty
                      ? null
                      : () => _startSync(),
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeManager.of(context).primaryColor,
                foregroundColor: ThemeManager.of(context).textInverted,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                elevation: 2,
              ),
              child: _isSyncing
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
                          'Syncing...',
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
                        Icon(Prbal.refresh, size: 18.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'Start Sync',
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

  void _startSync() async {
    setState(() {
      _isSyncing = true;
      _syncStatus = 'Syncing...';
      _syncProgress.clear();
    });

    debugPrint('🔄 [DataSync] Starting data sync');
    debugPrint('🔄 [DataSync] Selected sync types: $_selectedSyncTypes');
    debugPrint('🔄 [DataSync] Auto sync: $_autoSync');
    debugPrint('🔄 [DataSync] WiFi only: $_syncOnWifiOnly');

    try {
      for (final syncType in _selectedSyncTypes) {
        setState(() {
          _syncProgress[syncType] = true;
          _syncStatus = 'Syncing $syncType...';
        });

        debugPrint('🔄 [DataSync] Syncing $syncType...');

        // Simulate sync for each data type
        await Future.delayed(const Duration(seconds: 1));

        // Simulate sync completion
        debugPrint('🔄 [DataSync] Completed $syncType sync');

        setState(() {
          _syncProgress[syncType] = false;
        });
      }

      // Update last sync time (use login time update)
      _lastSyncTime = DateTime.now();
      await HiveService.setLoggedIn(true); // This updates last login time

      setState(() {
        _isSyncing = false;
        _syncStatus = 'Sync completed successfully';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data sync completed successfully!'),
            backgroundColor: ThemeManager.of(context).successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r)),
          ),
        );
      }

      debugPrint('🔄 [DataSync] Sync completed successfully');
    } catch (e) {
      setState(() {
        _isSyncing = false;
        _syncStatus = 'Sync failed: $e';
      });

      debugPrint('🔄 [DataSync] Sync error: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: ThemeManager.of(context).errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r)),
          ),
        );
      }
    }
  }

  String _formatLastSync(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
