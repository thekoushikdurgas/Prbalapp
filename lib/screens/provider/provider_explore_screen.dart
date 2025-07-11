import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

class ProviderExploreScreen extends ConsumerStatefulWidget {
  const ProviderExploreScreen({super.key});

  @override
  ConsumerState<ProviderExploreScreen> createState() =>
      _ProviderExploreScreenState();
}

class _ProviderExploreScreenState extends ConsumerState<ProviderExploreScreen> {
  bool _isMapView = true;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  double _selectedRadius = 10.0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        '🎯 ProviderExploreScreen: Building screen with _isMapView: $_isMapView, selectedCategory: $_selectedCategory');
    debugPrint(
        '🎨 ProviderExploreScreen: ThemeManager - isDark: ${ThemeManager.of(context).themeManager}, backgroundColor: ${ThemeManager.of(context).backgroundColor}');

    return Scaffold(
      backgroundColor: ThemeManager.of(context).backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search and Filter Header
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: ThemeManager.of(context).surfaceColor,
                boxShadow: ThemeManager.of(context).subtleShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title and View Toggle
                  Row(
                    children: [
                      Text(
                        'Explore',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: ThemeManager.of(context).textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          gradient: ThemeManager.of(context).surfaceGradient,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildViewToggle(
                              icon: Prbal.map,
                              isSelected: _isMapView,
                              onTap: () => setState(() => _isMapView = true),
                            ),
                            _buildViewToggle(
                              icon: Prbal.list,
                              isSelected: !_isMapView,
                              onTap: () => setState(() => _isMapView = false),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      gradient: ThemeManager.of(context).surfaceGradient,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search customer requests...',
                        hintStyle: TextStyle(
                          color: ThemeManager.of(context).textSecondary,
                          fontSize: 16.sp,
                        ),
                        prefixIcon: Icon(
                          Prbal.search,
                          color: ThemeManager.of(context).textSecondary,
                        ),
                        suffixIcon: IconButton(
                          onPressed: _showFilterBottomSheet,
                          icon: Icon(
                            Prbal.tune,
                            color: ThemeManager.of(context).primaryColor,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Quick Filters
                  SizedBox(
                    height: 40.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFilterChip('All', _selectedCategory == 'All'),
                        SizedBox(width: 8.w),
                        _buildFilterChip('Home Services',
                            _selectedCategory == 'Home Services'),
                        SizedBox(width: 8.w),
                        _buildFilterChip(
                            'Technical', _selectedCategory == 'Technical'),
                        SizedBox(width: 8.w),
                        _buildFilterChip('Beauty & Care',
                            _selectedCategory == 'Beauty & Care'),
                        SizedBox(width: 8.w),
                        _buildFilterChip(
                            'Urgent', _selectedCategory == 'Urgent'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content Area
            Expanded(
              child: _isMapView ? _buildMapView() : _buildListView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggle({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? ThemeManager.of(context).primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? Colors.white
              : ThemeManager.of(context).textSecondary,
          size: 20.sp,
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        debugPrint(
            '🎯 ProviderExploreScreen: Filter chip tapped - label: $label, previousSelection: $_selectedCategory');
        setState(() {
          _selectedCategory = label;
        });
        debugPrint(
            '🎯 ProviderExploreScreen: Filter category updated to: $_selectedCategory');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? ThemeManager.of(context).primaryColor
              : ThemeManager.of(context).surfaceColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? ThemeManager.of(context).primaryColor
                : ThemeManager.of(context).borderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Colors.white
                : ThemeManager.of(context).textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      decoration: BoxDecoration(
        color: ThemeManager.of(context).surfaceColor,
      ),
      child: Stack(
        children: [
          // Map Placeholder
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: ThemeManager.of(context).surfaceColor,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Prbal.map,
                    size: 64.sp,
                    color: ThemeManager.of(context).textTertiary,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Map View',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: ThemeManager.of(context).textSecondary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Customer requests in your area',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ThemeManager.of(context).textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Request Cards
          Positioned(
            bottom: 20.h,
            left: 20.w,
            right: 20.w,
            child: SizedBox(
              height: 140.h,
              child: PageView(
                children: [
                  _buildMapRequestCard(
                    'Home Cleaning Service',
                    '0.5 km away',
                    '\$75 - \$100',
                    'Tomorrow, 2:00 PM',
                    ThemeManager.of(context).infoColor,
                  ),
                  _buildMapRequestCard(
                    'AC Repair Urgent',
                    '1.2 km away',
                    '\$120 - \$150',
                    'Today, 6:00 PM',
                    ThemeManager.of(context).warningColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapRequestCard(
    String title,
    String distance,
    String price,
    String time,
    Color accentColor,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeManager.of(context).surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: ThemeManager.of(context).elevatedShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 26),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Prbal.briefcase,
                  color: accentColor,
                  size: 16.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: ThemeManager.of(context).textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      distance,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ThemeManager.of(context).textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Budget: $price',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ThemeManager.of(context).successColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ThemeManager.of(context).textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // View details or bid
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Bid',
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 10, // Mock data
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: ThemeManager.of(context).surfaceColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: ThemeManager.of(context).elevatedShadow,
          ),
          child: _buildRequestListItem(index),
        );
      },
    );
  }

  Widget _buildRequestListItem(
    int index,
  ) {
    final titles = [
      'Home Cleaning Service',
      'AC Repair Urgent',
      'Plumbing Fix',
      'Garden Maintenance',
      'Computer Repair',
    ];

    final colors = [
      ThemeManager.of(context).infoColor,
      ThemeManager.of(context).warningColor,
      ThemeManager.of(context).successColor,
      ThemeManager.of(context).primaryColor,
      ThemeManager.of(context).errorColor,
    ];

    return ListTile(
      contentPadding: EdgeInsets.all(16.w),
      leading: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: colors[index % colors.length].withValues(alpha: 26),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          Prbal.briefcase,
          color: colors[index % colors.length],
          size: 24.sp,
        ),
      ),
      title: Text(
        titles[index % titles.length],
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: ThemeManager.of(context).textPrimary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.h),
          Text(
            '1.${index + 2} km away • Tomorrow, ${10 + index}:00 AM',
            style: TextStyle(
              fontSize: 12.sp,
              color: ThemeManager.of(context).textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Flexible(
                child: Text(
                  'Budget: \$${50 + (index * 25)} - \$${100 + (index * 25)}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ThemeManager.of(context).successColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              ElevatedButton(
                onPressed: () {
                  // Place bid
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors[index % colors.length],
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Bid',
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: ThemeManager.of(context).surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.symmetric(vertical: 12.h),
            height: 4.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: ThemeManager.of(context).borderColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Title
          Text(
            'Filter Options',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: ThemeManager.of(context).textPrimary,
            ),
          ),

          SizedBox(height: 24.h),

          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search Radius',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ThemeManager.of(context).textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Slider(
                    value: _selectedRadius,
                    min: 1.0,
                    max: 50.0,
                    divisions: 49,
                    label: '${_selectedRadius.round()} km',
                    activeColor: ThemeManager.of(context).primaryColor,
                    onChanged: (value) {
                      setState(() {
                        _selectedRadius = value;
                      });
                    },
                  ),

                  SizedBox(height: 24.h),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeManager.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
}
