import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/models/business/service_models.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
// import 'package:prbal/services/service_management_service.dart';
import 'package:prbal/utils/category/category_utils.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:prbal/widgets/admin/category/category_actions_bottom_sheet.dart';
// import 'package:prbal/utils/theme/theme_manager.dart';
// import 'package:prbal/widgets/admin/category/utils/meta_info.dart';

/// ====================================================================
/// CATEGORY CARD COMPONENTS - ENHANCED WITH COMPREHENSIVE THEMEMANAGER INTEGRATION
/// ====================================================================
///
/// **Purpose**: Reusable card components for displaying category information with complete ThemeManager theming
///
/// **Components Included**:
/// - CategoryCard: Main category card with comprehensive ThemeManager actions and theming
/// - EnhancedCategoryIcon: Advanced icon component with smart suggestions, validation, and full theming
/// - CategoryCardContent: Main content area with theme-aware typography and semantic colors
/// - CategoryActionsMenu: Actions menu using modal bottom sheet with ThemeManager styling
///
/// **Complete ThemeManager Integration Features**:
/// - All gradient types (background, surface, primary, secondary, success, warning, error, info, accent, neutral)
/// - Comprehensive color palette (text, background, border, semantic, accent colors)
/// - Advanced shadow effects (primary, elevated, subtle) and glass morphism
/// - Theme-aware animations, haptic feedback, and visual hierarchy
/// - Smart icon suggestions with AI-like recommendations and theme optimization
/// - Performance analytics and monitoring with theme-aware indicators
/// - Enhanced visual feedback and error handling with semantic colors
/// - Context-aware icon recommendations with theme-consistent styling
/// - Comprehensive debug logging for theme operations and performance tracking
///
/// **Material Design 3.0 Features**:
/// - **ENHANCED**: Complete ThemeManager integration with all properties
/// - Selection-aware tap behavior with theme-consistent feedback
/// - Smooth animations with theme-aware scaling and color transitions
/// - Advanced haptic feedback with contextual intensity
/// - Comprehensive debug logging with theme state tracking
/// - Glass morphism effects and enhanced visual hierarchy
/// - Semantic color usage for status indicators and actions
/// ====================================================================

/// Modern category card with comprehensive ThemeManager integration
class CategoryCard extends StatefulWidget {
  final ServiceCategory category;
  final bool isSelected;
  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Function(ServiceCategory)? onEdit;
  final Function(ServiceCategory)? onDelete;
  final Function(ServiceCategory)? onToggleStatus;
  final bool isInSelectionMode;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.index,
    this.onTap,
    this.onLongPress,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
    required this.isInSelectionMode,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with TickerProviderStateMixin, ThemeAwareMixin {
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    debugPrint(
        '🎴 CategoryCard: Initializing card for category "${widget.category.name}"');

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    // Start shimmer for selected cards
    if (widget.isSelected) {
      _shimmerController.repeat();
    }
  }

  @override
  void didUpdateWidget(CategoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update shimmer animation based on selection
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _shimmerController.repeat();
      } else {
        _shimmerController.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ========== COMPREHENSIVE THEMEMANAGER INTEGRATION ==========

    // Comprehensive debug logging for theme operations

    debugPrint('🎴 CategoryCard: Building card for "${widget.category.name}"');
    debugPrint(
        '🎨 CategoryCard: Theme mode: ${ThemeManager.of(context).themeManager ? 'dark' : 'light'}');
    debugPrint(
        '🌈 CategoryCard: Using gradients - Surface: ${ThemeManager.of(context).surfaceGradient.colors.length} colors, Primary: ${ThemeManager.of(context).primaryGradient.colors.length} colors');

    // Enhanced theme-aware colors using all ThemeManager properties
    final iconColor = CategoryUtils.getCategoryIconColor(
        widget.category, ThemeManager.of(context));

    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _shimmerAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            child: Material(
              elevation: widget.isSelected ? 12 : 4,
              shadowColor: widget.isSelected
                  ? ThemeManager.of(context).primaryColor.withValues(alpha: 102)
                  : ThemeManager.of(context).shadowMedium,
              borderRadius: BorderRadius.circular(20.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: _buildCardDecoration(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Stack(
                    children: [
                      // Shimmer overlay for selected cards
                      if (widget.isSelected) _buildShimmerOverlay(),

                      // Main card content
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (widget.isInSelectionMode) {
                              debugPrint(
                                  '🎴 CategoryCard: Card tapped in SELECTION MODE for "${widget.category.name}"');
                              HapticFeedback.selectionClick();
                              widget.onTap?.call();
                            } else {
                              debugPrint(
                                  '🎴 CategoryCard: Card tapped in NORMAL MODE for "${widget.category.name}" - no action (menu button handles this)');
                              HapticFeedback.lightImpact();
                            }
                          },
                          onLongPress: () {
                            debugPrint(
                                '🎴 CategoryCard: Card long pressed for "${widget.category.name}" - entering/toggling selection mode');
                            HapticFeedback.mediumImpact();
                            _scaleController.forward().then((_) {
                              _scaleController.reverse();
                            });
                            widget.onLongPress?.call();
                          },
                          borderRadius: BorderRadius.circular(20.r),
                          child: Container(
                            padding: EdgeInsets.all(20.w),
                            child: Row(
                              children: [
                                // Enhanced category icon with comprehensive theming
                                EnhancedCategoryIcon(
                                  category: widget.category,
                                  iconColor: iconColor,
                                  isSelected: widget.isSelected,
                                ),

                                SizedBox(width: 20.w),

                                // Main content with full theming
                                Expanded(
                                  child: CategoryCardContent(
                                    category: widget.category,
                                    isSelected: widget.isSelected,
                                  ),
                                ),

                                SizedBox(width: 16.w),

                                // Actions menu with theming
                                CategoryActionsMenu(
                                  category: widget.category,
                                  onEdit: widget.onEdit,
                                  onDelete: widget.onDelete,
                                  onToggleStatus: widget.onToggleStatus,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build comprehensive card decoration with all ThemeManager features
  BoxDecoration _buildCardDecoration() {
    if (widget.isSelected) {
      return BoxDecoration(
        gradient: ThemeManager.of(context).primaryGradient,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ThemeManager.of(context).primaryColor,
          width: 2.5,
        ),
        boxShadow: ThemeManager.of(context).elevatedShadow,
      );
    } else {
      return BoxDecoration(
        gradient: ThemeManager.of(context).surfaceGradient,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ThemeManager.of(context).borderColor,
          width: 1.5,
        ),
        boxShadow: ThemeManager.of(context).primaryShadow,
      );
    }
  }

  /// Build shimmer overlay effect for selected cards
  Widget _buildShimmerOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-1.0 + (_shimmerAnimation.value * 2.0), 0.0),
            end: Alignment(1.0 + (_shimmerAnimation.value * 2.0), 0.0),
            colors: [
              Colors.transparent,
              ThemeManager.of(context).primaryColor.withValues(alpha: 26),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint(
        '🎴 CategoryCard: Disposing card for category "${widget.category.name}"');
    _scaleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }
}

/// Enhanced Category icon component with comprehensive ThemeManager integration
class EnhancedCategoryIcon extends StatefulWidget {
  final ServiceCategory category;
  final Color iconColor;
  final bool isSelected;

  const EnhancedCategoryIcon({
    super.key,
    required this.category,
    required this.iconColor,
    this.isSelected = false,
  });

  @override
  State<EnhancedCategoryIcon> createState() => _EnhancedCategoryIconState();
}

class _EnhancedCategoryIconState extends State<EnhancedCategoryIcon>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  // Icon resolution data
  String? _resolvedIconIdentifier;
  IconData? _resolvedIcon;
  Map<String, dynamic>? _iconValidation;
  Map<String, IconData>? _smartSuggestions;
  bool _isIconValid = false;
  bool _isUsingFallback = false;
  int _performanceScore = 0;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.elasticOut),
    );

    // Start icon resolution process
    _resolveIconWithEnhancedFeatures();

    // Add animations for selected state
    if (widget.isSelected) {
      _pulseController.repeat(reverse: true);
      _rotateController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant EnhancedCategoryIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update animations based on selection state
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _pulseController.repeat(reverse: true);
        _rotateController.forward();
      } else {
        _pulseController.stop();
        _pulseController.reset();
        _rotateController.reverse();
      }
    }

    // Re-resolve icon if category changed
    if (widget.category != oldWidget.category) {
      _resolveIconWithEnhancedFeatures();
    }
  }

  /// Enhanced icon resolution with comprehensive ThemeManager integration
  Future<void> _resolveIconWithEnhancedFeatures() async {
    final startTime = DateTime.now();

    debugPrint('🎨🤖 EnhancedCategoryIcon: =============================');
    debugPrint(
        '🎨🤖 EnhancedCategoryIcon: ENHANCED ICON RESOLUTION WITH THEMEMANAGER');
    debugPrint('🎨🤖 EnhancedCategoryIcon: =============================');
    debugPrint(
        '🎨🤖 EnhancedCategoryIcon: → Category: "${widget.category.name}"');
    debugPrint(
        '🎨🤖 EnhancedCategoryIcon: → Icon URL: "${widget.category.iconUrl ?? 'null'}"');
    debugPrint(
        '🎨🤖 EnhancedCategoryIcon: → Icon field: "${widget.category.icon ?? 'null'}"');
    // debugPrint(
    // '🎨🤖 EnhancedCategoryIcon: → Theme: ${ThemeManager.of(context).themeManager ? 'dark' : 'light'}');
    // debugPrint('🎨🤖 EnhancedCategoryIcon: → Primary Color: ${ThemeManager.of(context).primaryColor}');
    // debugPrint('🎨🤖 EnhancedCategoryIcon: → Icon Color: ${widget.iconColor}');

    // Step 1: Resolve icon identifier with enhanced priority system
    _resolvedIconIdentifier = _resolveIconIdentifier();
    debugPrint(
        '🎨🤖 EnhancedCategoryIcon: → Resolved identifier: "$_resolvedIconIdentifier"');

    // Step 2: Validate the resolved icon using enhanced validation
    _iconValidation = CategoryUtils.validateIconName(_resolvedIconIdentifier!);
    _isIconValid = _iconValidation!['isValid'] as bool;
    debugPrint(
        '🎨🤖 EnhancedCategoryIcon: → Icon validation: ${_isIconValid ? '✅ VALID' : '❌ INVALID'}');

    if (!_isIconValid) {
      debugPrint(
          '🎨🤖 EnhancedCategoryIcon: → Validation details: ${_iconValidation!['suggestions']}');
    }

    // Step 3: Get smart suggestions for context-aware recommendations
    _smartSuggestions = CategoryUtils.getSmartIconSuggestions(
        widget.category.name,
        context: 'category_card_display');
    debugPrint(
        '🎨🤖 EnhancedCategoryIcon: → Smart suggestions: ${_smartSuggestions!.keys.toList()}');

    // Step 4: Resolve final icon with fallback handling
    _resolvedIcon = _resolveFinalIcon();
    _isUsingFallback = !_isIconValid && _resolvedIconIdentifier != 'list';
    debugPrint(
        '🎨🤖 EnhancedCategoryIcon: → Using fallback: $_isUsingFallback');

    // Step 5: Calculate performance score
    final endTime = DateTime.now();
    final resolutionTime = endTime.difference(startTime).inMilliseconds;
    _performanceScore = _calculatePerformanceScore(resolutionTime);

    debugPrint(
        '🎨🤖 EnhancedCategoryIcon: → Resolution time: ${resolutionTime}ms');
    debugPrint(
        '🎨🤖 EnhancedCategoryIcon: → Performance score: $_performanceScore/100');
    debugPrint('🎨🤖 EnhancedCategoryIcon: =============================');

    // Update UI
    if (mounted) {
      setState(() {});
    }
  }

  /// Calculate performance score based on resolution metrics
  int _calculatePerformanceScore(int resolutionTimeMs) {
    int score = 100;

    // Deduct points for slow resolution
    if (resolutionTimeMs > 50) score -= 20;
    if (resolutionTimeMs > 100) score -= 30;

    // Deduct points for using fallback
    if (_isUsingFallback) score -= 25;

    // Deduct points for invalid icon
    if (!_isIconValid) score -= 15;

    // Bonus points for having smart suggestions
    if (_smartSuggestions != null && _smartSuggestions!.isNotEmpty) score += 10;

    return score.clamp(0, 100);
  }

  /// Resolve icon identifier from multiple sources
  String _resolveIconIdentifier() {
    // Priority 1: Direct icon field
    if (widget.category.icon?.isNotEmpty == true) {
      return widget.category.icon!;
    }

    // Priority 2: Extract from icon URL
    if (widget.category.iconUrl?.isNotEmpty == true) {
      final url = widget.category.iconUrl!;
      if (url.contains('/')) {
        return url
            .split('/')
            .last
            .replaceAll('.svg', '')
            .replaceAll('.png', '');
      }
      return url;
    }

    // Priority 3: Generate from category name using existing method
    final inferredIcon =
        CategoryUtils.inferIconFromCategoryName(widget.category.name);
    return inferredIcon ?? 'category';
  }

  /// Resolve final icon with fallback handling
  IconData _resolveFinalIcon() {
    // Try to get icon from identifier
    final icon = CategoryUtils.getIconFromString(_resolvedIconIdentifier!);

    // If icon is valid, return it
    if (icon != Icons.list) {
      return icon;
    }

    // Use smart suggestions if available
    if (_smartSuggestions?.isNotEmpty == true) {
      return _smartSuggestions!.values.first;
    }

    // Final fallback
    return Icons.category_rounded;
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state while resolving
    if (_resolvedIcon == null) {
      return _buildLoadingIcon();
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _rotateAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isSelected ? _pulseAnimation.value : 1.0,
          child: Transform.rotate(
            angle: widget.isSelected ? _rotateAnimation.value : 0.0,
            child: Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                gradient: widget.isSelected
                    ? ThemeManager.of(context).primaryGradient
                    : ThemeManager.of(context).accent1Gradient,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: widget.iconColor
                      .withValues(alpha: widget.isSelected ? 153 : 77),
                  width: widget.isSelected ? 2.5 : 1.5,
                ),
                boxShadow: widget.isSelected
                    ? ThemeManager.of(context).elevatedShadow
                    : ThemeManager.of(context).subtleShadow,
              ),
              child: Stack(
                children: [
                  // Glass morphism background
                  Positioned.fill(
                    child: Container(
                      decoration: ThemeManager.of(context).glassMorphism,
                    ),
                  ),

                  // Main icon
                  Center(
                    child: Icon(
                      _resolvedIcon!,
                      size: widget.isSelected ? 32.sp : 28.sp,
                      color: widget.isSelected
                          ? ThemeManager.of(context).textInverted
                          : widget.iconColor,
                    ),
                  ),

                  // Enhanced performance indicator
                  _buildEnhancedPerformanceIndicator(),

                  // Enhanced validation status indicator
                  _buildEnhancedValidationIndicator(),

                  // Enhanced smart suggestions indicator
                  _buildEnhancedSmartSuggestionsIndicator(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build enhanced loading icon with ThemeManager styling
  Widget _buildLoadingIcon() {
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).shimmerGradient,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ThemeManager.of(context).borderColor,
          width: 1.5,
        ),
        boxShadow: ThemeManager.of(context).subtleShadow,
      ),
      child: Center(
        child: SizedBox(
          width: 24.w,
          height: 24.w,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
                ThemeManager.of(context).primaryColor),
          ),
        ),
      ),
    );
  }

  /// Build enhanced performance indicator with ThemeManager colors
  Widget _buildEnhancedPerformanceIndicator() {
    if (_performanceScore >= 80) return const SizedBox.shrink();

    if (_performanceScore >= 60) {
    } else {}

    return Positioned(
      top: 4,
      left: 4,
      child: Container(
        width: 16.w,
        height: 16.w,
        decoration: BoxDecoration(
          gradient: _performanceScore >= 60
              ? ThemeManager.of(context).warningGradient
              : ThemeManager.of(context).errorGradient,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
              color: ThemeManager.of(context).textInverted, width: 1.5),
          boxShadow: ThemeManager.of(context).subtleShadow,
        ),
        child: Center(
          child: Text(
            _performanceScore.toString(),
            style: TextStyle(
              fontSize: 8.sp,
              color: ThemeManager.of(context).textInverted,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// Build enhanced validation status indicator with ThemeManager styling
  Widget _buildEnhancedValidationIndicator() {
    if (_isIconValid) return const SizedBox.shrink();

    return Positioned(
      top: 4,
      right: 4,
      child: Container(
        width: 14.w,
        height: 14.w,
        decoration: BoxDecoration(
          gradient: ThemeManager.of(context).warningGradient,
          borderRadius: BorderRadius.circular(7.r),
          border: Border.all(
              color: ThemeManager.of(context).textInverted, width: 1.5),
          boxShadow: ThemeManager.of(context).subtleShadow,
        ),
        child: Icon(
          Icons.warning_rounded,
          size: 8.sp,
          color: ThemeManager.of(context).textInverted,
        ),
      ),
    );
  }

  /// Build enhanced smart suggestions indicator with ThemeManager styling
  Widget _buildEnhancedSmartSuggestionsIndicator() {
    if (_smartSuggestions == null || _smartSuggestions!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 4,
      right: 4,
      child: Container(
        width: 14.w,
        height: 14.w,
        decoration: BoxDecoration(
          gradient: ThemeManager.of(context).successGradient,
          borderRadius: BorderRadius.circular(7.r),
          border: Border.all(
              color: ThemeManager.of(context).textInverted, width: 1.5),
          boxShadow: ThemeManager.of(context).subtleShadow,
        ),
        child: Icon(
          Icons.lightbulb_rounded,
          size: 8.sp,
          color: ThemeManager.of(context).textInverted,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }
}

/// Category card content component with comprehensive ThemeManager integration
class CategoryCardContent extends StatelessWidget {
  final ServiceCategory category;

  final bool isSelected;

  const CategoryCardContent({
    super.key,
    required this.category,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '📋 CategoryCardContent: Building content for "${category.name}" with ThemeManager integration');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced category name with theme-aware typography
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            gradient: isSelected
                ? ThemeManager.of(context).enhancedGlassMorphism.gradient
                : ThemeManager.of(context).glassMorphism.gradient,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color:
                  ThemeManager.of(context).borderColor.withValues(alpha: 0.3),
            ),
            boxShadow: ThemeManager.of(context).subtleShadow,
          ),
          child: Text(
            category.name,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? ThemeManager.of(context).textInverted
                  : ThemeManager.of(context).textPrimary,
              letterSpacing: 0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        if (category.description.isNotEmpty == true) ...[
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: ThemeManager.of(context).surfaceElevated,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: ThemeManager.of(context).borderColor),
              boxShadow: ThemeManager.of(context).subtleShadow,
            ),
            child: Text(
              category.description,
              style: TextStyle(
                fontSize: 13.sp,
                color: ThemeManager.of(context).textSecondary,
                height: 1.4,
                letterSpacing: 0.1,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],

        SizedBox(height: 12.h),

        // Enhanced status and metadata row with comprehensive theming
        Row(
          children: [
            // Enhanced status badge with gradients
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: category.isActive
                      ? ThemeManager.of(context).successGradient
                      : ThemeManager.of(context).warningGradient,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: ThemeManager.of(context).subtleShadow,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category.isActive
                          ? Icons.check_circle_rounded
                          : Icons.pause_circle_rounded,
                      size: 14.sp,
                      color: ThemeManager.of(context).textInverted,
                    ),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        category.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: ThemeManager.of(context).textInverted,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // Enhanced sort order badge with accent gradient
            if (category.sortOrder > 0)
              Expanded(
                flex: 1,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    gradient: ThemeManager.of(context).accent3Gradient,
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: ThemeManager.of(context).subtleShadow,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sort_rounded,
                        size: 12.sp,
                        color: ThemeManager.of(context).textInverted,
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          '#${category.sortOrder}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: ThemeManager.of(context).textInverted,
                            letterSpacing: 0.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),

        SizedBox(height: 8.h),

        // Additional metadata with theme styling
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: ThemeManager.of(context).backgroundSecondary,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ThemeManager.of(context).borderSecondary),
          ),
          child: Row(
            children: [
              Icon(
                Icons.update_rounded,
                size: 12.sp,
                color: ThemeManager.of(context).textTertiary,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'Updated: ${CategoryUtils.formatDate(category.updatedAt)}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: ThemeManager.of(context).textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Enhanced actions menu component with comprehensive ThemeManager styling
class CategoryActionsMenu extends StatelessWidget {
  final ServiceCategory category;

  final Function(ServiceCategory)? onEdit;
  final Function(ServiceCategory)? onDelete;
  final Function(ServiceCategory)? onToggleStatus;

  const CategoryActionsMenu({
    super.key,
    required this.category,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '⚙️ CategoryActionsMenu: Building enhanced actions menu button for category "${category.name}"');

    return Container(
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).neutralGradient,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeManager.of(context).subtleShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            debugPrint(
                '⚙️ CategoryActionsMenu: Enhanced actions menu tapped for "${category.name}"');
            HapticFeedback.selectionClick();
            _showActionsBottomSheet(context);
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(12.w),
            child: Icon(
              Prbal.moreVertical,
              size: 24.sp,
              color: ThemeManager.of(context).textInverted,
            ),
          ),
        ),
      ),
    );
  }

  /// Show enhanced category actions bottom sheet
  Future<void> _showActionsBottomSheet(BuildContext context) async {
    debugPrint(
        '⚙️ CategoryActionsMenu: Showing enhanced actions bottom sheet for "${category.name}"');

    await CategoryActionsBottomSheet.show(
      context: context,
      category: category,
      onEdit: onEdit,
      onDelete: onDelete,
      onToggleStatus: onToggleStatus,
    );
  }
}

/// Simple CategoryIcon wrapper for backward compatibility with ThemeManager
///
/// **Purpose**: Provides backward compatibility for code that still uses CategoryIcon
/// **Usage**: Wraps EnhancedCategoryIcon with simplified interface and ThemeManager integration
class CategoryIcon extends StatelessWidget {
  final ServiceCategory category;
  final Color iconColor;
  final bool themeManager;

  const CategoryIcon({
    super.key,
    required this.category,
    required this.iconColor,
    required this.themeManager,
  });

  @override
  Widget build(BuildContext context) {
    // final themeManagerInstance = ThemeManager.of(context).of(context);
    debugPrint(
        '🔄 CategoryIcon: Using compatibility wrapper with ThemeManager integration');

    return EnhancedCategoryIcon(
      category: category,
      iconColor: iconColor,
    );
  }
}
