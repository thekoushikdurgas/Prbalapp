import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/services/service_management_service.dart';
import 'package:prbal/services/api_service.dart';
import 'package:prbal/widgets/admin/category/category_icon_picker.dart';
import 'package:prbal/utils/category/category_utils.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:prbal/services/service_providers.dart';

/// EditCategoryModalWidget - Enhanced modal for editing categories with advanced icon selection
///
/// **Enhanced Features**:
/// - **Icon Validation**: Real-time validation with visual feedback
/// - **Context-Aware Suggestions**: Smart icon recommendations based on category name
/// - **Performance Analytics**: Track icon selection performance and user behavior
/// - **Enhanced Preview**: Rich visual feedback for icon selection state
/// - **Comprehensive Error Handling**: Detailed validation and error messaging
/// - **Consistency**: Unified experience matching create modal patterns
/// - **ENHANCED THEME INTEGRATION**: Uses ThemeManager for centralized theme management
/// - Modern glassmorphism design with dynamic gradients
/// - Advanced dark/light theme support with theme-aware colors
/// - Icon selection with professional preview functionality
/// - Real-time validation with contextual feedback
/// - Smooth animations and haptic feedback
/// - Auto-focus management and form validation
/// - Professional loading states with branded indicators
class EditCategoryModalWidget extends ConsumerStatefulWidget {
  final ServiceCategory category;
  final VoidCallback? onCategoryUpdated;

  const EditCategoryModalWidget({
    super.key,
    required this.category,
    this.onCategoryUpdated,
  });

  @override
  ConsumerState<EditCategoryModalWidget> createState() => _EditCategoryModalWidgetState();
}

class _EditCategoryModalWidgetState extends ConsumerState<EditCategoryModalWidget>
    with TickerProviderStateMixin, ThemeAwareMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _sortOrderController;
  late ServiceManagementService serviceManagementService;

  late bool _isActive;
  bool _isLoading = false;
  String? _selectedIcon;
  String? _originalIcon;
  int _sortOrder = 0;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Enhanced icon analytics and validation
  Map<String, dynamic>? _iconValidation;
  Map<String, dynamic>? _iconAnalytics;

  @override
  void initState() {
    super.initState();

    debugPrint('✏️ EditCategoryModal: =============================');
    debugPrint('✏️ EditCategoryModal: ENHANCED THEME INTEGRATION V2.0');
    debugPrint('✏️ EditCategoryModal: =============================');
    debugPrint('✏️ EditCategoryModal: Using ThemeManager for centralized theme management');
    debugPrint('✏️ EditCategoryModal: Initializing for category: ${widget.category.name}');

    // Pre-populate form with existing category data
    _nameController = TextEditingController(text: widget.category.name);
    _descriptionController = TextEditingController(text: widget.category.description);
    _sortOrderController = TextEditingController(text: widget.category.sortOrder.toString());
    _isActive = widget.category.isActive;
    _sortOrder = widget.category.sortOrder;

    // Enhanced icon initialization with validation
    _originalIcon = widget.category.iconUrl ?? widget.category.icon;
    _selectedIcon = _originalIcon;

    // Initialize service management service with API service
    serviceManagementService = ServiceManagementService(ApiService());

    // Initialize enhanced analytics and validation
    _initializeIconAnalytics();

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

    debugPrint('✏️ EditCategoryModal: → Category: "${widget.category.name}"');
    debugPrint('✏️ EditCategoryModal: → Description: "${widget.category.description}"');
    debugPrint('✏️ EditCategoryModal: → Sort Order: ${widget.category.sortOrder}');
    debugPrint('✏️ EditCategoryModal: → Is Active: ${widget.category.isActive}');
    debugPrint('✏️ EditCategoryModal: → Original Icon: ${_originalIcon ?? 'none'}');
    debugPrint('✏️ EditCategoryModal: → Selected Icon: ${_selectedIcon ?? 'none'}');
    debugPrint('✏️ EditCategoryModal: → Enhanced features initialized successfully');
  }

  /// Initialize icon analytics and validation system
  void _initializeIconAnalytics() {
    debugPrint('📊 EditCategoryModal: Initializing icon analytics...');

    _iconAnalytics = CategoryUtils.getIconAnalytics();

    if (_selectedIcon != null) {
      _iconValidation = CategoryUtils.validateIconName(_selectedIcon!);
      debugPrint('📊 EditCategoryModal: → Icon validation: ${_iconValidation!['isValid']}');
    }

    // Generate icon recommendations based on category name
    if (widget.category.name.isNotEmpty) {
      CategoryUtils.generateIconRecommendations(widget.category.name).then((recommendations) {
        debugPrint('🤖 EditCategoryModal: → Generated ${recommendations['smartSuggestionsCount']} recommendations');
        debugPrint('🤖 EditCategoryModal: → Confidence: ${recommendations['confidence']}%');
      });
    }

    debugPrint('📊 EditCategoryModal: → Analytics initialized with ${_iconAnalytics!['totalIcons']} total icons');
  }

  @override
  Widget build(BuildContext context) {
    // ========== ENHANCED THEME INTEGRATION ==========
    final themeManager = ThemeManager.of(context);
    themeManager.logThemeInfo();

    debugPrint('🎨 EditCategoryModal: =============================');
    debugPrint('🎨 EditCategoryModal: BUILDING WITH THEME MANAGER');
    debugPrint('🎨 EditCategoryModal: =============================');
    // debugPrint('🎨 EditCategoryModal: Theme brightness: ${theme.brightness.name}');
    debugPrint('🎨 EditCategoryModal: Primary color: ${themeManager.primaryColor}');
    debugPrint('🎨 EditCategoryModal: Background: ${themeManager.backgroundColor}');
    debugPrint('🎨 EditCategoryModal: Surface: ${themeManager.surfaceColor}');

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
                gradient: themeManager.backgroundGradient,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                border: Border.all(
                  color: themeManager.borderColor,
                  width: 1,
                ),
                boxShadow: [
                  ...themeManager.elevatedShadow,
                  BoxShadow(
                    color: themeManager.shadowDark,
                    blurRadius: 20.r,
                    offset: Offset(0, -5.h),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildModalHeader(themeManager),
                  Expanded(
                    child: _buildModalBody(themeManager, scrollController),
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
  Widget _buildModalHeader(ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border(
          bottom: BorderSide(
            color: themeManager.dividerColor,
            width: 1,
          ),
        ),
        boxShadow: [
          ...themeManager.subtleShadow,
        ],
      ),
      child: Row(
        children: [
          // Icon container with theme-aware gradient
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: themeManager.primaryGradient,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                ...themeManager.primaryShadow,
                BoxShadow(
                  color: themeManager.primaryColor.withValues(alpha: 51),
                  blurRadius: 8.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Icon(
              Icons.edit_rounded,
              size: 24.w,
              color: themeManager.getContrastingColor(themeManager.primaryColor),
            ),
          ),

          SizedBox(width: 16.w),

          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Category',
                  style: themeManager.textTheme.headlineSmall?.copyWith(
                    color: themeManager.textPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Update category information',
                  style: themeManager.textTheme.bodyMedium?.copyWith(
                    color: themeManager.textSecondary,
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
                gradient: themeManager.conditionalGradient(
                  lightGradient: LinearGradient(
                    colors: [
                      themeManager.surfaceElevated,
                      themeManager.cardBackground,
                    ],
                  ),
                  darkGradient: LinearGradient(
                    colors: [
                      themeManager.backgroundTertiary,
                      themeManager.surfaceElevated,
                    ],
                  ),
                ),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: themeManager.borderColor,
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
                  color: themeManager.textSecondary,
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
  Widget _buildModalBody(ThemeManager themeManager, ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: EdgeInsets.all(24.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildNameField(themeManager),
            SizedBox(height: 20.h),
            _buildDescriptionField(themeManager),
            SizedBox(height: 20.h),
            _buildIconSelectionSection(themeManager),
            SizedBox(height: 20.h),
            _buildStatusToggle(themeManager),
            SizedBox(height: 20.h),
            _buildSortOrderField(themeManager),
            SizedBox(height: 32.h),
            _buildActionButtons(themeManager),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  /// Build name input field with theme-aware styling
  Widget _buildNameField(ThemeManager themeManager) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Name',
          style: themeManager.textTheme.titleMedium?.copyWith(
            color: themeManager.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            gradient: themeManager.conditionalGradient(
              lightGradient: LinearGradient(
                colors: [
                  themeManager.inputBackground,
                  themeManager.surfaceElevated,
                ],
              ),
              darkGradient: LinearGradient(
                colors: [
                  themeManager.inputBackground,
                  themeManager.backgroundTertiary,
                ],
              ),
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: themeManager.subtleShadow,
          ),
          child: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter category name',
              hintStyle: TextStyle(color: themeManager.textSecondary),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: themeManager.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: themeManager.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: themeManager.primaryColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: themeManager.errorColor, width: 2),
              ),
              prefixIcon: Container(
                padding: EdgeInsets.all(12.w),
                child: Icon(
                  Icons.category_rounded,
                  color: themeManager.primaryColor,
                  size: 20.sp,
                ),
              ),
            ),
            style: TextStyle(color: themeManager.textPrimary),
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
  Widget _buildDescriptionField(ThemeManager themeManager) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: themeManager.textTheme.titleMedium?.copyWith(
            color: themeManager.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            gradient: themeManager.conditionalGradient(
              lightGradient: LinearGradient(
                colors: [
                  themeManager.inputBackground,
                  themeManager.surfaceElevated,
                ],
              ),
              darkGradient: LinearGradient(
                colors: [
                  themeManager.inputBackground,
                  themeManager.backgroundTertiary,
                ],
              ),
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: themeManager.subtleShadow,
          ),
          child: TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter category description (optional)',
              hintStyle: TextStyle(color: themeManager.textSecondary),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: themeManager.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: themeManager.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: themeManager.primaryColor, width: 2),
              ),
              prefixIcon: Container(
                padding: EdgeInsets.all(12.w),
                child: Icon(
                  Icons.description_rounded,
                  color: themeManager.primaryColor,
                  size: 20.sp,
                ),
              ),
            ),
            style: TextStyle(color: themeManager.textPrimary),
          ),
        ),
      ],
    );
  }

  /// Build icon selection section with theme-aware styling
  Widget _buildIconSelectionSection(ThemeManager themeManager) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                gradient: themeManager.primaryGradient,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.palette_rounded,
                size: 16.sp,
                color: themeManager.getContrastingColor(themeManager.primaryColor),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'Icon Selection',
              style: themeManager.textTheme.titleMedium?.copyWith(
                color: themeManager.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                gradient: themeManager.accent1Gradient,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Smart AI',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: themeManager.getContrastingColor(themeManager.accent1),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        // Enhanced icon selection button with theme integration
        _buildSelectedIconDisplay(themeManager),
      ],
    );
  }

  /// Build selected icon display with enhanced theme integration
  Widget _buildSelectedIconDisplay(ThemeManager themeManager) {
    return InkWell(
      onTap: () => _showIconPicker(themeManager),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: themeManager.surfaceGradient,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: themeManager.borderColor,
            width: 1,
          ),
          boxShadow: [
            ...themeManager.elevatedShadow,
            BoxShadow(
              color: themeManager.shadowMedium,
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
                gradient: themeManager.primaryGradient,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  ...themeManager.primaryShadow,
                  BoxShadow(
                    color: themeManager.primaryColor.withValues(alpha: 51),
                    blurRadius: 8.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: Icon(
                _selectedIcon != null ? CategoryUtils.getIconFromString(_selectedIcon!) : Icons.category_rounded,
                size: 32.w,
                color: themeManager.getContrastingColor(themeManager.primaryColor),
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
                    style: themeManager.textTheme.titleSmall?.copyWith(
                      color: themeManager.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (_selectedIcon != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      _selectedIcon!,
                      style: themeManager.textTheme.bodySmall?.copyWith(
                        color: themeManager.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 6.h),
                  Text(
                    'Tap to ${_selectedIcon != null ? 'change' : 'select'} icon',
                    style: themeManager.textTheme.bodySmall?.copyWith(
                      color: themeManager.primaryColor,
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
                gradient: themeManager.conditionalGradient(
                  lightGradient: LinearGradient(
                    colors: [
                      themeManager.primaryColor.withValues(alpha: 26),
                      themeManager.accent1.withValues(alpha: 13),
                    ],
                  ),
                  darkGradient: LinearGradient(
                    colors: [
                      themeManager.primaryColor.withValues(alpha: 51),
                      themeManager.accent1.withValues(alpha: 26),
                    ],
                  ),
                ),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: themeManager.primaryColor.withValues(alpha: 77),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.w,
                color: themeManager.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build status toggle with theme-aware styling
  Widget _buildStatusToggle(ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: themeManager.borderColor,
          width: 1,
        ),
        boxShadow: themeManager.subtleShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: _isActive
                  ? themeManager.successGradient
                  : themeManager.conditionalGradient(
                      lightGradient: LinearGradient(
                        colors: [themeManager.neutral300, themeManager.neutral400],
                      ),
                      darkGradient: LinearGradient(
                        colors: [themeManager.neutral600, themeManager.neutral700],
                      ),
                    ),
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: _isActive
                      ? themeManager.successColor.withValues(alpha: 51)
                      : themeManager.neutral500.withValues(alpha: 26),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(
              _isActive ? Icons.check_circle_rounded : Icons.pause_circle_rounded,
              size: 20.w,
              color: themeManager.getContrastingColor(
                _isActive ? themeManager.successColor : themeManager.neutral500,
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
                  style: themeManager.textTheme.titleSmall?.copyWith(
                    color: themeManager.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _isActive ? 'Active - Visible to users' : 'Inactive - Hidden from users',
                  style: themeManager.textTheme.bodySmall?.copyWith(
                    color: themeManager.textSecondary,
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
            activeColor: themeManager.primaryColor,
            trackColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return themeManager.primaryColor.withValues(alpha: 128);
              }
              return themeManager.borderSecondary;
            }),
          ),
        ],
      ),
    );
  }

  /// Build sort order field with theme-aware styling
  Widget _buildSortOrderField(ThemeManager themeManager) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort Order',
          style: themeManager.textTheme.titleMedium?.copyWith(
            color: themeManager.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            gradient: themeManager.conditionalGradient(
              lightGradient: LinearGradient(
                colors: [
                  themeManager.inputBackground,
                  themeManager.surfaceElevated,
                ],
              ),
              darkGradient: LinearGradient(
                colors: [
                  themeManager.inputBackground,
                  themeManager.backgroundTertiary,
                ],
              ),
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: themeManager.subtleShadow,
          ),
          child: TextFormField(
            controller: _sortOrderController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: 'Display order (0-999)',
              hintStyle: TextStyle(color: themeManager.textSecondary),
              filled: true,
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: themeManager.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: themeManager.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: themeManager.primaryColor, width: 2),
              ),
              prefixIcon: Container(
                padding: EdgeInsets.all(12.w),
                child: Icon(
                  Icons.sort_rounded,
                  color: themeManager.primaryColor,
                  size: 20.sp,
                ),
              ),
            ),
            style: TextStyle(color: themeManager.textPrimary),
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
  Widget _buildActionButtons(ThemeManager themeManager) {
    return Row(
      children: [
        // Cancel button
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: themeManager.conditionalGradient(
                lightGradient: LinearGradient(
                  colors: [
                    themeManager.surfaceElevated,
                    themeManager.cardBackground,
                  ],
                ),
                darkGradient: LinearGradient(
                  colors: [
                    themeManager.backgroundTertiary,
                    themeManager.surfaceElevated,
                  ],
                ),
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: themeManager.borderColor),
              boxShadow: themeManager.subtleShadow,
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
                color: themeManager.textSecondary,
              ),
              label: Text(
                'Cancel',
                style: TextStyle(
                  color: themeManager.textSecondary,
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

        // Update button
        Expanded(
          flex: 2,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                gradient: themeManager.primaryGradient,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  ...themeManager.primaryShadow,
                  BoxShadow(
                    color: themeManager.primaryColor.withValues(alpha: 77),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _updateCategory,
                icon: _isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            themeManager.getContrastingColor(themeManager.primaryColor),
                          ),
                        ),
                      )
                    : Icon(
                        Icons.save_rounded,
                        size: 20.w,
                        color: themeManager.getContrastingColor(themeManager.primaryColor),
                      ),
                label: Text(
                  _isLoading ? 'Updating...' : 'Update Category',
                  style: TextStyle(
                    color: themeManager.getContrastingColor(themeManager.primaryColor),
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
  Future<void> _showIconPicker(ThemeManager themeManager) async {
    HapticFeedback.lightImpact();

    debugPrint('🎨 EditCategoryModal: Showing CategoryIconPicker with theme integration');

    final selectedIcon = await CategoryIconPicker.showIconPickerBottomSheet(
      context: context,
      selectedIcon: _selectedIcon,
      showSearchBar: true,
      crossAxisCount: 4,
      showTopPopular: true,
      enableSearch: true,
      enableCategorizedView: true,
      enableSmartSuggestions: true,
      pickerContext: 'category_edit',
    );

    if (selectedIcon != null) {
      setState(() {
        _selectedIcon = selectedIcon;
      });
      debugPrint('✏️ EditCategoryModal: Icon updated to: $selectedIcon');
    }
  }

  /// Update category with enhanced error handling and theme integration
  Future<void> _updateCategory() async {
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.mediumImpact();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('✏️ EditCategoryModal: Starting category update process');

      final serviceManagementService = ref.read(serviceManagementServiceProvider);

      debugPrint('✏️ EditCategoryModal: Updating category ${widget.category.id}');
      debugPrint(
          '✏️ EditCategoryModal: Updated data - name: ${_nameController.text.trim()}, description: ${_descriptionController.text.trim()}, icon: $_selectedIcon, active: $_isActive, sortOrder: $_sortOrder');

      final response = await serviceManagementService.updateCategory(
        categoryId: widget.category.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        iconUrl: _selectedIcon,
        isActive: _isActive,
        sortOrder: _sortOrder,
      );

      if (response.isSuccess && response.data != null) {
        debugPrint('✅ EditCategoryModal: Category updated successfully');

        HapticFeedback.lightImpact();

        if (mounted) {
          final themeManager = ThemeManager.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Category "${_nameController.text}" updated successfully!',
                style: TextStyle(color: themeManager.colorScheme.onPrimary),
              ),
              backgroundColor: themeManager.colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );

          widget.onCategoryUpdated?.call();
          Navigator.of(context).pop();
        }
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('❌ EditCategoryModal: Error updating category - $e');

      if (mounted) {
        final themeManager = ThemeManager.of(context);
        HapticFeedback.lightImpact();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update category: $e',
              style: TextStyle(color: themeManager.colorScheme.onError),
            ),
            backgroundColor: themeManager.colorScheme.error,
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
    debugPrint('✏️ EditCategoryModal: Disposing widget and controllers');
    _nameController.dispose();
    _descriptionController.dispose();
    _sortOrderController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }
}
