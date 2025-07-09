// ====================================================================
// CREATE CATEGORY MODAL WIDGET - Simplified Design
// ====================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/services/service_management_service.dart';
import 'package:prbal/services/api_service.dart';
import 'package:prbal/widgets/admin/category/category_icon_picker.dart';
import 'package:prbal/utils/category/category_utils.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

/// CreateCategoryModalWidget - Enhanced modal for creating categories with advanced icon selection
///
/// **Enhanced Features**:
/// - **Icon Validation**: Real-time validation with visual feedback
/// - **Context-Aware Suggestions**: Smart icon recommendations
/// - **Performance Analytics**: Track icon selection performance
/// - **Enhanced Preview**: Rich visual feedback for icon selection state
/// - **Comprehensive Error Handling**: Detailed validation and error messaging
/// - **Consistency**: Unified experience matching edit modal patterns
class CreateCategoryModalWidget extends ConsumerStatefulWidget {
  final VoidCallback? onCategoryCreated;
  // final ServiceManagementService serviceManagementService;

  const CreateCategoryModalWidget({
    super.key,
    this.onCategoryCreated,
    // required this.serviceManagementService,
  });

  @override
  ConsumerState<CreateCategoryModalWidget> createState() => _CreateCategoryModalWidgetState();
}

class _CreateCategoryModalWidgetState extends ConsumerState<CreateCategoryModalWidget>
    with TickerProviderStateMixin, ThemeAwareMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sortOrderController = TextEditingController();
  late ServiceManagementService serviceManagementService;

  bool _isActive = true;
  bool _isLoading = false;
  String? _selectedIcon;
  int _sortOrder = 0;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _sortOrderController.text = '0';
    // Initialize service management service with API service
    serviceManagementService = ServiceManagementService(ApiService());
    debugPrint('🚀 CreateCategoryModal: ServiceManagementService initialized');

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Start animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward();
      _slideController.forward();
      _scaleController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ========== ENHANCED THEME INTEGRATION ==========

    debugPrint('🎨 CreateCategoryModal: =============================');
    debugPrint('🎨 CreateCategoryModal: BUILDING WITH THEME MANAGER');
    debugPrint('🎨 CreateCategoryModal: =============================');
    debugPrint('🎨 CreateCategoryModal: Primary color: ${ThemeManager.of(context).primaryColor}');
    debugPrint('🎨 CreateCategoryModal: Background: ${ThemeManager.of(context).backgroundColor}');
    debugPrint('🎨 CreateCategoryModal: Surface: ${ThemeManager.of(context).surfaceColor}');

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                gradient: ThemeManager.of(context).backgroundGradient,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                border: Border.all(
                  color: ThemeManager.of(context).borderColor,
                  width: 1,
                ),
                boxShadow: [
                  ...ThemeManager.of(context).elevatedShadow,
                  BoxShadow(
                    color: ThemeManager.of(context).shadowDark,
                    blurRadius: 20.r,
                    offset: Offset(0, -5.h),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildModalHeader(),
                  Expanded(
                    child: _buildModalBody(scrollController),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build modal header with enhanced theme integration
  Widget _buildModalHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).surfaceGradient,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border(
          bottom: BorderSide(
            color: ThemeManager.of(context).dividerColor,
            width: 1,
          ),
        ),
        boxShadow: [
          ...ThemeManager.of(context).subtleShadow,
        ],
      ),
      child: Row(
        children: [
          // Icon container with theme-aware gradient
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: ThemeManager.of(context).primaryGradient,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                ...ThemeManager.of(context).primaryShadow,
                BoxShadow(
                  color: ThemeManager.of(context).primaryColor.withValues(alpha: 51),
                  blurRadius: 8.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Icon(
              Icons.add_rounded,
              size: 24.w,
              color: ThemeManager.of(context).getContrastingColor(ThemeManager.of(context).primaryColor),
            ),
          ),

          SizedBox(width: 16.w),

          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Category',
                  style: ThemeManager.of(context).textTheme.headlineSmall?.copyWith(
                        color: ThemeManager.of(context).textPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Add new service category',
                  style: ThemeManager.of(context).textTheme.bodyMedium?.copyWith(
                        color: ThemeManager.of(context).textSecondary,
                        letterSpacing: 0.3,
                      ),
                ),
              ],
            ),
          ),

          // Close button with theme-aware styling
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                gradient: ThemeManager.of(context).conditionalGradient(
                  lightGradient: LinearGradient(
                    colors: [
                      ThemeManager.of(context).surfaceElevated,
                      ThemeManager.of(context).cardBackground,
                    ],
                  ),
                  darkGradient: LinearGradient(
                    colors: [
                      ThemeManager.of(context).backgroundTertiary,
                      ThemeManager.of(context).surfaceElevated,
                    ],
                  ),
                ),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: ThemeManager.of(context).borderColor,
                  width: 1,
                ),
              ),
              child: IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close_rounded,
                  size: 24.w,
                  color: ThemeManager.of(context).textSecondary,
                ),
                style: IconButton.styleFrom(
                  padding: EdgeInsets.all(8.w),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build modal body with enhanced theme integration
  Widget _buildModalBody(ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.all(24.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildNameField(),
            SizedBox(height: 20.h),
            _buildDescriptionField(),
            SizedBox(height: 20.h),
            _buildIconSelectionSection(),
            SizedBox(height: 20.h),
            _buildStatusToggle(),
            SizedBox(height: 20.h),
            _buildSortOrderField(),
            SizedBox(height: 32.h),
            _buildActionButtons(),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  /// Build name input field with theme-aware styling
  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Name',
          style: ThemeManager.of(context).textTheme.titleMedium?.copyWith(
                color: ThemeManager.of(context).textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            gradient: ThemeManager.of(context).conditionalGradient(
              lightGradient: LinearGradient(
                colors: [
                  ThemeManager.of(context).inputBackground,
                  ThemeManager.of(context).surfaceElevated,
                ],
              ),
              darkGradient: LinearGradient(
                colors: [
                  ThemeManager.of(context).inputBackground,
                  ThemeManager.of(context).backgroundTertiary,
                ],
              ),
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: ThemeManager.of(context).subtleShadow,
          ),
          child: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter category name',
              hintStyle: TextStyle(color: ThemeManager.of(context).textSecondary),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: ThemeManager.of(context).borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: ThemeManager.of(context).borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: ThemeManager.of(context).primaryColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: ThemeManager.of(context).errorColor, width: 2),
              ),
              prefixIcon: Container(
                padding: EdgeInsets.all(12.w),
                child: Icon(
                  Icons.category_rounded,
                  color: ThemeManager.of(context).primaryColor,
                  size: 20.sp,
                ),
              ),
            ),
            style: TextStyle(color: ThemeManager.of(context).textPrimary),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Category name is required';
              }
              if (value.trim().length < 2) {
                return 'Category name must be at least 2 characters';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  /// Build description input field with theme-aware styling
  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: ThemeManager.of(context).textTheme.titleMedium?.copyWith(
                color: ThemeManager.of(context).textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            gradient: ThemeManager.of(context).conditionalGradient(
              lightGradient: LinearGradient(
                colors: [
                  ThemeManager.of(context).inputBackground,
                  ThemeManager.of(context).surfaceElevated,
                ],
              ),
              darkGradient: LinearGradient(
                colors: [
                  ThemeManager.of(context).inputBackground,
                  ThemeManager.of(context).backgroundTertiary,
                ],
              ),
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: ThemeManager.of(context).subtleShadow,
          ),
          child: TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter category description (optional)',
              hintStyle: TextStyle(color: ThemeManager.of(context).textSecondary),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: ThemeManager.of(context).borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: ThemeManager.of(context).borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: ThemeManager.of(context).primaryColor, width: 2),
              ),
              prefixIcon: Container(
                padding: EdgeInsets.all(12.w),
                child: Icon(
                  Icons.description_rounded,
                  color: ThemeManager.of(context).primaryColor,
                  size: 20.sp,
                ),
              ),
            ),
            style: TextStyle(color: ThemeManager.of(context).textPrimary),
          ),
        ),
      ],
    );
  }

  /// Build icon selection section with theme-aware styling
  Widget _buildIconSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                gradient: ThemeManager.of(context).primaryGradient,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.palette_rounded,
                size: 16.sp,
                color: ThemeManager.of(context).getContrastingColor(ThemeManager.of(context).primaryColor),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'Icon Selection',
              style: ThemeManager.of(context).textTheme.titleMedium?.copyWith(
                    color: ThemeManager.of(context).textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                gradient: ThemeManager.of(context).accent1Gradient,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Smart AI',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: ThemeManager.of(context).getContrastingColor(ThemeManager.of(context).accent1),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        // Enhanced icon selection button with theme integration
        _buildSelectedIconDisplay(),
      ],
    );
  }

  /// Build selected icon display with enhanced theme integration
  Widget _buildSelectedIconDisplay() {
    return InkWell(
      onTap: () => _showIconPicker(),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: ThemeManager.of(context).surfaceGradient,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: ThemeManager.of(context).borderColor,
            width: 1,
          ),
          boxShadow: [
            ...ThemeManager.of(context).elevatedShadow,
            BoxShadow(
              color: ThemeManager.of(context).shadowMedium,
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon preview with gradient background
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                gradient: ThemeManager.of(context).primaryGradient,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  ...ThemeManager.of(context).primaryShadow,
                  BoxShadow(
                    color: ThemeManager.of(context).primaryColor.withValues(alpha: 51),
                    blurRadius: 8.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: Icon(
                _selectedIcon != null ? CategoryUtils.getIconFromString(_selectedIcon!) : Icons.category_rounded,
                size: 32.w,
                color: ThemeManager.of(context).getContrastingColor(ThemeManager.of(context).primaryColor),
              ),
            ),

            SizedBox(width: 16.w),

            // Icon information and action
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedIcon != null ? 'Selected Icon' : 'No Icon Selected',
                    style: ThemeManager.of(context).textTheme.titleSmall?.copyWith(
                          color: ThemeManager.of(context).textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_selectedIcon != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      _selectedIcon!,
                      style: ThemeManager.of(context).textTheme.bodySmall?.copyWith(
                            color: ThemeManager.of(context).textSecondary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 6.h),
                  Text(
                    'Tap to ${_selectedIcon != null ? 'change' : 'select'} icon',
                    style: ThemeManager.of(context).textTheme.bodySmall?.copyWith(
                          color: ThemeManager.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            // Action arrow with theme-aware styling
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                gradient: ThemeManager.of(context).conditionalGradient(
                  lightGradient: LinearGradient(
                    colors: [
                      ThemeManager.of(context).primaryColor.withValues(alpha: 26),
                      ThemeManager.of(context).accent1.withValues(alpha: 13),
                    ],
                  ),
                  darkGradient: LinearGradient(
                    colors: [
                      ThemeManager.of(context).primaryColor.withValues(alpha: 51),
                      ThemeManager.of(context).accent1.withValues(alpha: 26),
                    ],
                  ),
                ),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: ThemeManager.of(context).primaryColor.withValues(alpha: 77),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.w,
                color: ThemeManager.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build status toggle with theme-aware styling
  Widget _buildStatusToggle() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).surfaceGradient,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ThemeManager.of(context).borderColor,
          width: 1,
        ),
        boxShadow: ThemeManager.of(context).subtleShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: _isActive
                  ? ThemeManager.of(context).successGradient
                  : ThemeManager.of(context).conditionalGradient(
                      lightGradient: LinearGradient(
                        colors: [ThemeManager.of(context).neutral300, ThemeManager.of(context).neutral400],
                      ),
                      darkGradient: LinearGradient(
                        colors: [ThemeManager.of(context).neutral600, ThemeManager.of(context).neutral700],
                      ),
                    ),
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: _isActive
                      ? ThemeManager.of(context).successColor.withValues(alpha: 51)
                      : ThemeManager.of(context).neutral500.withValues(alpha: 26),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(
              _isActive ? Icons.check_circle_rounded : Icons.pause_circle_rounded,
              size: 20.w,
              color: ThemeManager.of(context).getContrastingColor(
                _isActive ? ThemeManager.of(context).successColor : ThemeManager.of(context).neutral500,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category Status',
                  style: ThemeManager.of(context).textTheme.titleSmall?.copyWith(
                        color: ThemeManager.of(context).textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  _isActive ? 'Active - Visible to users' : 'Inactive - Hidden from users',
                  style: ThemeManager.of(context).textTheme.bodySmall?.copyWith(
                        color: ThemeManager.of(context).textSecondary,
                      ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: _isActive,
            onChanged: (value) {
              HapticFeedback.lightImpact();
              setState(() {
                _isActive = value;
              });
            },
            activeColor: ThemeManager.of(context).primaryColor,
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return ThemeManager.of(context).primaryColor.withValues(alpha: 128);
              }
              return ThemeManager.of(context).borderSecondary;
            }),
          ),
        ],
      ),
    );
  }

  /// Build sort order field with theme-aware styling
  Widget _buildSortOrderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort Order',
          style: ThemeManager.of(context).textTheme.titleMedium?.copyWith(
                color: ThemeManager.of(context).textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            gradient: ThemeManager.of(context).conditionalGradient(
              lightGradient: LinearGradient(
                colors: [
                  ThemeManager.of(context).inputBackground,
                  ThemeManager.of(context).surfaceElevated,
                ],
              ),
              darkGradient: LinearGradient(
                colors: [
                  ThemeManager.of(context).inputBackground,
                  ThemeManager.of(context).backgroundTertiary,
                ],
              ),
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: ThemeManager.of(context).subtleShadow,
          ),
          child: TextFormField(
            initialValue: '0',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: 'Display order (0-999)',
              hintStyle: TextStyle(color: ThemeManager.of(context).textSecondary),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: ThemeManager.of(context).borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: ThemeManager.of(context).borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: ThemeManager.of(context).primaryColor, width: 2),
              ),
              prefixIcon: Container(
                padding: EdgeInsets.all(12.w),
                child: Icon(
                  Icons.sort_rounded,
                  color: ThemeManager.of(context).primaryColor,
                  size: 20.sp,
                ),
              ),
            ),
            style: TextStyle(color: ThemeManager.of(context).textPrimary),
            onChanged: (value) {
              _sortOrder = int.tryParse(value) ?? 0;
            },
            validator: (value) {
              final sortOrder = int.tryParse(value ?? '');
              if (sortOrder == null || sortOrder < 0 || sortOrder > 999) {
                return 'Sort order must be between 0 and 999';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  /// Build action buttons with enhanced theme integration
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Cancel button
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: ThemeManager.of(context).conditionalGradient(
                lightGradient: LinearGradient(
                  colors: [
                    ThemeManager.of(context).surfaceElevated,
                    ThemeManager.of(context).cardBackground,
                  ],
                ),
                darkGradient: LinearGradient(
                  colors: [
                    ThemeManager.of(context).backgroundTertiary,
                    ThemeManager.of(context).surfaceElevated,
                  ],
                ),
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: ThemeManager.of(context).borderColor),
              boxShadow: ThemeManager.of(context).subtleShadow,
            ),
            child: OutlinedButton.icon(
              onPressed: _isLoading
                  ? null
                  : () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).pop();
                    },
              icon: Icon(
                Icons.close_rounded,
                size: 20.w,
                color: ThemeManager.of(context).textSecondary,
              ),
              label: Text(
                'Cancel',
                style: TextStyle(
                  color: ThemeManager.of(context).textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: 16.w),

        // Create button
        Expanded(
          flex: 2,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                gradient: ThemeManager.of(context).primaryGradient,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  ...ThemeManager.of(context).primaryShadow,
                  BoxShadow(
                    color: ThemeManager.of(context).primaryColor.withValues(alpha: 77),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _createCategory,
                icon: _isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ThemeManager.of(context).getContrastingColor(ThemeManager.of(context).primaryColor),
                          ),
                        ),
                      )
                    : Icon(
                        Icons.add_rounded,
                        size: 20.w,
                        color: ThemeManager.of(context).getContrastingColor(ThemeManager.of(context).primaryColor),
                      ),
                label: Text(
                  _isLoading ? 'Creating...' : 'Create Category',
                  style: TextStyle(
                    color: ThemeManager.of(context).getContrastingColor(ThemeManager.of(context).primaryColor),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Show icon picker with theme integration
  Future<void> _showIconPicker() async {
    HapticFeedback.lightImpact();

    debugPrint('🎨 CreateCategoryModal: Showing CategoryIconPicker with theme integration');

    final selectedIcon = await CategoryIconPicker.showIconPickerBottomSheet(
      context: context,
      selectedIcon: _selectedIcon,
      showSearchBar: true,
      crossAxisCount: 4,
      showTopPopular: true,
      enableSearch: true,
      enableCategorizedView: true,
      enableSmartSuggestions: true,
      pickerContext: 'category_create',
    );

    if (selectedIcon != null) {
      setState(() {
        _selectedIcon = selectedIcon;
      });
      debugPrint('🎨 CreateCategoryModal: Icon updated to: $selectedIcon');
    }
  }

  /// Create category with enhanced error handling and theme integration
  Future<void> _createCategory() async {
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('🎨 CreateCategoryModal: Starting category creation process');

      // final serviceManagementService = ref.read(serviceManagementServiceProvider);

      debugPrint(
          '🎨 CreateCategoryModal: Creating category with data - name: ${_nameController.text.trim()}, description: ${_descriptionController.text.trim()}, icon: $_selectedIcon, active: $_isActive, sortOrder: $_sortOrder');

      final response = await serviceManagementService.createCategory(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        iconUrl: _selectedIcon,
        isActive: _isActive,
        sortOrder: _sortOrder,
      );

      if (response.isSuccess && response.data != null) {
        debugPrint('✅ CreateCategoryModal: Category created successfully');

        HapticFeedback.lightImpact();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Category "${_nameController.text}" created successfully!',
                style: TextStyle(color: ThemeManager.of(context).colorScheme.onPrimary),
              ),
              backgroundColor: ThemeManager.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );

          widget.onCategoryCreated?.call();
          Navigator.of(context).pop();
        }
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('❌ CreateCategoryModal: Error creating category - $e');

      if (mounted) {
        HapticFeedback.lightImpact();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to create category: $e',
              style: TextStyle(color: ThemeManager.of(context).colorScheme.onError),
            ),
            backgroundColor: ThemeManager.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    debugPrint('🎨 CreateCategoryModal: Disposing widget and controllers');
    _nameController.dispose();
    _descriptionController.dispose();
    _sortOrderController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }
}
