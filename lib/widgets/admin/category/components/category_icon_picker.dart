// ====================================================================
// CATEGORY ICON PICKER COMPONENT - Visual Icon Selection
// ====================================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/widgets/admin/category/utils/category_utils.dart';

/// CategoryIconPicker - Visual icon selection component
///
/// **Purpose**: Provides a visual grid-based picker for category icons
/// **Features**:
/// - Visual icon grid with names
/// - Search/filter functionality
/// - Integration with CategoryUtils.getAvailableIcons()
/// - Selected state indication
/// - Theme-aware design
class CategoryIconPicker extends StatefulWidget {
  final String? selectedIcon;
  final ValueChanged<String?> onIconSelected;
  final bool showSearchBar;
  final int crossAxisCount;

  const CategoryIconPicker({
    super.key,
    this.selectedIcon,
    required this.onIconSelected,
    this.showSearchBar = true,
    this.crossAxisCount = 4,
  });

  @override
  State<CategoryIconPicker> createState() => _CategoryIconPickerState();
}

class _CategoryIconPickerState extends State<CategoryIconPicker> {
  final _searchController = TextEditingController();
  late Map<String, IconData> _allIcons;
  late Map<String, IconData> _filteredIcons;
  String? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.selectedIcon;
    _allIcons = CategoryUtils.getAvailableIcons();
    _filteredIcons = Map.from(_allIcons);

    debugPrint('🎨 CategoryIconPicker: Initialized with ${_allIcons.length} available icons');
    debugPrint('🎨 CategoryIconPicker: Pre-selected icon: ${_selectedIcon ?? 'none'}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Row(
          children: [
            Icon(
              Prbal.palette,
              color: theme.primaryColor,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Select Category Icon',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.titleMedium?.color,
              ),
            ),
            const Spacer(),
            if (_selectedIcon != null)
              TextButton.icon(
                onPressed: () => _clearSelection(),
                icon: Icon(Prbal.cross, size: 16.sp),
                label: Text('Clear', style: TextStyle(fontSize: 12.sp)),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
              ),
          ],
        ),

        SizedBox(height: 12.h),

        // Search bar
        if (widget.showSearchBar) ...[
          TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search icons...',
              prefixIcon: Icon(Prbal.search, size: 18.sp),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Prbal.cross, size: 16.sp),
                      onPressed: () => _clearSearch(),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
            ),
            style: TextStyle(fontSize: 14.sp),
            onChanged: _onSearchChanged,
          ),
          SizedBox(height: 16.h),
        ],

        // Selected icon preview
        if (_selectedIcon != null) ...[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 26),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: theme.primaryColor.withValues(alpha: 128),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  CategoryUtils.getIconFromString(_selectedIcon!),
                  color: theme.primaryColor,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Icon',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _selectedIcon!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
        ],

        // Icons grid
        if (_filteredIcons.isEmpty) ...[
          _buildNoIconsFound(theme),
        ] else ...[
          _buildIconsGrid(theme, isDark),
        ],
      ],
    );
  }

  /// Build icons grid
  Widget _buildIconsGrid(ThemeData theme, bool isDark) {
    return Container(
      constraints: BoxConstraints(maxHeight: 300.h),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
          childAspectRatio: 1.0,
        ),
        itemCount: _filteredIcons.length,
        itemBuilder: (context, index) {
          final entry = _filteredIcons.entries.elementAt(index);
          final iconName = entry.key;
          final iconData = entry.value;
          final isSelected = _selectedIcon == iconName;

          return _buildIconTile(
            iconName: iconName,
            iconData: iconData,
            isSelected: isSelected,
            theme: theme,
            isDark: isDark,
          );
        },
      ),
    );
  }

  /// Build individual icon tile
  Widget _buildIconTile({
    required String iconName,
    required IconData iconData,
    required bool isSelected,
    required ThemeData theme,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () => _selectIcon(iconName),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? theme.primaryColor.withValues(alpha: 51) : theme.cardColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? theme.primaryColor : theme.dividerColor.withValues(alpha: 128),
            width: isSelected ? 2.0 : 1.0,
          ),
          // boxShadow: isSelected
          //     ? [
          //         BoxShadow(
          //           color: theme.primaryColor.withValues(alpha: 77),
          //           blurRadius: 8.r,
          //           offset: Offset(0, 2.h),
          //         ),
          //       ]
          //     : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 24.sp,
              color: isSelected ? theme.primaryColor : (isDark ? Colors.white70 : Colors.black87),
            ),
            SizedBox(height: 4.h),
            Text(
              iconName.toUpperCase(),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? theme.primaryColor : theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Build no icons found state
  Widget _buildNoIconsFound(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Icon(
            Prbal.search,
            size: 48.sp,
            color: theme.disabledColor,
          ),
          SizedBox(height: 16.h),
          Text(
            'No icons found',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: theme.disabledColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your search terms',
            style: TextStyle(
              fontSize: 12.sp,
              color: theme.disabledColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Handle icon selection
  void _selectIcon(String iconName) {
    debugPrint('🎨 CategoryIconPicker: Icon selected: $iconName');

    setState(() {
      _selectedIcon = iconName;
    });

    widget.onIconSelected(iconName);
  }

  /// Clear icon selection
  void _clearSelection() {
    debugPrint('🎨 CategoryIconPicker: Icon selection cleared');

    setState(() {
      _selectedIcon = null;
    });

    widget.onIconSelected(null);
  }

  /// Handle search input changes
  void _onSearchChanged(String query) {
    debugPrint('🎨 CategoryIconPicker: Search query: "$query"');

    setState(() {
      if (query.isEmpty) {
        _filteredIcons = Map.from(_allIcons);
      } else {
        _filteredIcons = Map.fromEntries(
          _allIcons.entries.where((entry) => entry.key.toLowerCase().contains(query.toLowerCase())),
        );
      }
    });

    debugPrint('🎨 CategoryIconPicker: Filtered to ${_filteredIcons.length} icons');
  }

  /// Clear search
  void _clearSearch() {
    debugPrint('🎨 CategoryIconPicker: Search cleared');

    _searchController.clear();
    setState(() {
      _filteredIcons = Map.from(_allIcons);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
