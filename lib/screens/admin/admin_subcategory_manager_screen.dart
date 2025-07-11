import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:prbal/widgets/admin/subcategory_widget.dart';

/// AdminSubcategoryManagerScreen - Dedicated screen for managing service subcategories
///
/// **Purpose**: Provides a focused interface for admin subcategory management
///
/// **Key Features**:
/// - Full-screen subcategory management without tabs
/// - Search and filter functionality
/// - Modern glassmorphism design with dark/light theme support
/// - Comprehensive CRUD operations using ServiceSubcategoryCrudWidget
/// - Back navigation to admin tool manager
/// - Real-time search and filtering capabilities
/// - Category relationship management
///
/// **Business Logic**:
/// - Uses the existing ServiceSubcategoryCrudWidget for all operations
/// - Provides search bar for real-time filtering
/// - Allows bulk selection and operations
/// - Maintains state independently from admin tool manager
/// - Supports filtering by parent category relationships
///
/// **Debug Logging**:
/// - Comprehensive logging for navigation and state changes
/// - Performance monitoring for data loading
/// - User interaction tracking for UX improvements
/// - Category relationship tracking for debugging
class AdminSubcategoryManagerScreen extends ConsumerStatefulWidget {
  const AdminSubcategoryManagerScreen({super.key});

  @override
  ConsumerState<AdminSubcategoryManagerScreen> createState() =>
      _AdminSubcategoryManagerScreenState();
}

class _AdminSubcategoryManagerScreenState
    extends ConsumerState<AdminSubcategoryManagerScreen> {
  // ========== STATE VARIABLES ==========
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _currentFilter = 'all'; // 'all', 'active', 'inactive'
  final Set<String> _selectedIds = <String>{};

  @override
  void initState() {
    super.initState();
    debugPrint(
        '🏷️ AdminSubcategoryManager: Initializing subcategory management screen');

    // Add search listener for real-time filtering
    _searchController.addListener(() {
      if (_searchController.text != _searchQuery) {
        setState(() {
          _searchQuery = _searchController.text;
        });
        debugPrint(
            '🔍 AdminSubcategoryManager: Search query updated: "$_searchQuery"');
      }
    });

    debugPrint('🏷️ AdminSubcategoryManager: Screen initialization completed');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '🎨 AdminSubcategoryManager: Building subcategory management screen');

    return Scaffold(
      backgroundColor: ThemeManager.of(context).backgroundColor,

      // ========== APP BAR WITH SEARCH ==========
      appBar: AppBar(
        backgroundColor: ThemeManager.of(context).surfaceColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            debugPrint('🔙 AdminSubcategoryManager: Back button pressed');
            Navigator.of(context).pop();
          },
          icon: Icon(
            Prbal.arrowLeft,
            color: ThemeManager.of(context).textPrimary,
            size: 24.sp,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 77),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Prbal.openstreetmap,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subcategory Manager',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: ThemeManager.of(context).textPrimary,
                    ),
                  ),
                  Text(
                    'Manage service subcategories',
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
        actions: [
          // Filter button
          Container(
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color:
                  ThemeManager.of(context).surfaceColor.withValues(alpha: 0.1),
            ),
            child: PopupMenuButton<String>(
              icon: Icon(
                Prbal.filter,
                color: ThemeManager.of(context).textSecondary,
                size: 20.sp,
              ),
              onSelected: (value) {
                debugPrint(
                    '🔧 AdminSubcategoryManager: Filter changed to: $value');
                setState(() {
                  _currentFilter = value;
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                    value: 'all', child: Text('All Subcategories')),
                const PopupMenuItem(
                    value: 'active', child: Text('Active Only')),
                const PopupMenuItem(
                    value: 'inactive', child: Text('Inactive Only')),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: _buildSearchBar(),
          ),
        ),
      ),

      // ========== MAIN CONTENT ==========
      body: Column(
        children: [
          // ========== SELECTION INFO BAR ==========
          if (_selectedIds.isNotEmpty) _buildSelectionInfoBar(),

          // ========== SUBCATEGORIES CRUD WIDGET ==========
          Expanded(
            child: ServiceSubcategoryCrudWidget(
              searchQuery: _searchQuery,
              filter: _currentFilter,
              selectedIds: _selectedIds,
              onSelectionChanged: (subcategoryId) {
                debugPrint(
                    '📋 AdminSubcategoryManager: Subcategory selection changed: $subcategoryId');
                setState(() {
                  if (_selectedIds.contains(subcategoryId)) {
                    _selectedIds.remove(subcategoryId);
                    debugPrint(
                        '📋 AdminSubcategoryManager: Subcategory deselected: $subcategoryId');
                  } else {
                    _selectedIds.add(subcategoryId);
                    debugPrint(
                        '📋 AdminSubcategoryManager: Subcategory selected: $subcategoryId');
                  }
                });
                debugPrint(
                    '📋 AdminSubcategoryManager: Total selected subcategories: ${_selectedIds.length}');
              },
              onDataChanged: () {
                debugPrint(
                    '📋 AdminSubcategoryManager: Subcategories data changed - triggering UI update');
                setState(() {
                  // Force UI update when data changes
                });
              },
            ),
          ),
        ],
      ),

      // ========== FLOATING ACTION BUTTON ==========
      floatingActionButton: _selectedIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                debugPrint(
                    '🔧 AdminSubcategoryManager: Bulk actions button pressed');
                _showBulkActionsBottomSheet();
              },
              backgroundColor: const Color(0xFF8B5CF6),
              icon: Icon(Prbal.cogs, color: Colors.white, size: 20.sp),
              label: Text(
                'Bulk Actions (${_selectedIds.length})',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  /// Build modern search bar with glassmorphism design
  Widget _buildSearchBar() {
    debugPrint('🔍 AdminSubcategoryManager: Building search bar');

    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: ThemeManager.of(context).surfaceGradient,
        border: Border.all(
          color: ThemeManager.of(context).borderColor,
          width: 1.5,
        ),
        boxShadow: ThemeManager.of(context).subtleShadow,
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          fontSize: 16.sp,
          color: ThemeManager.of(context).textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search subcategories by name, description, or category...',
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: ThemeManager.of(context).textTertiary,
          ),
          prefixIcon: Icon(
            Prbal.search,
            color: ThemeManager.of(context).primaryColor,
            size: 20.sp,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    debugPrint(
                        '🗑️ AdminSubcategoryManager: Clear search button pressed');
                    _searchController.clear();
                  },
                  icon: Icon(
                    Prbal.cross,
                    color: ThemeManager.of(context).textSecondary,
                    size: 18.sp,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
        onSubmitted: (value) {
          debugPrint('🔍 AdminSubcategoryManager: Search submitted: "$value"');
        },
      ),
    );
  }

  /// Build selection info bar showing selected count and actions
  Widget _buildSelectionInfoBar() {
    debugPrint('📊 AdminSubcategoryManager: Building selection info bar');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ThemeManager.of(context).primaryColor.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: ThemeManager.of(context).primaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Prbal.checkCircle,
            color: ThemeManager.of(context).primaryColor,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            '${_selectedIds.length} ${_selectedIds.length == 1 ? 'subcategory' : 'subcategories'} selected',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: ThemeManager.of(context).primaryColor,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              debugPrint(
                  '🗑️ AdminSubcategoryManager: Clear selection pressed');
              setState(() {
                _selectedIds.clear();
              });
            },
            child: Text(
              'Clear All',
              style: TextStyle(
                fontSize: 12.sp,
                color: ThemeManager.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show bulk actions bottom sheet
  void _showBulkActionsBottomSheet() {
    debugPrint('🔧 AdminSubcategoryManager: Showing bulk actions bottom sheet');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: ThemeManager.of(context).surfaceColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: ThemeManager.of(context).borderColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Icon(
                    Prbal.cogs,
                    color: ThemeManager.of(context).primaryColor,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Bulk Actions (${_selectedIds.length} selected)',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: ThemeManager.of(context).textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Actions
            _buildBulkActionTile('Activate All', Prbal.checkCircle,
                ThemeManager.of(context).successColor),
            _buildBulkActionTile('Deactivate All', Prbal.closeOutline,
                ThemeManager.of(context).warningColor),
            _buildBulkActionTile('Export Selected', Prbal.download,
                ThemeManager.of(context).infoColor),
            _buildBulkActionTile(
                'Delete All', Prbal.trash, ThemeManager.of(context).errorColor),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  /// Build bulk action tile
  Widget _buildBulkActionTile(
    String title,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Icon(icon, color: color, size: 20.sp),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          color: ThemeManager.of(context).textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
        debugPrint('🔧 AdminSubcategoryManager: Bulk action selected: $title');
        // TODO: Implement actual bulk actions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title action will be implemented soon'),
            backgroundColor: color,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    debugPrint(
        '🏷️ AdminSubcategoryManager: Disposing subcategory management screen');
    _searchController.dispose();
    debugPrint('🏷️ AdminSubcategoryManager: Screen disposed successfully');
    super.dispose();
  }
}
