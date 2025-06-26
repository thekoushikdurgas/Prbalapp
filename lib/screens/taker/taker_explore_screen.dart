import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';

class TakerExploreScreen extends ConsumerStatefulWidget {
  const TakerExploreScreen({super.key});

  @override
  ConsumerState<TakerExploreScreen> createState() => _TakerExploreScreenState();
}

class _TakerExploreScreenState extends ConsumerState<TakerExploreScreen> {
  bool _isMapView = true;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  double _selectedRadius = 5.0;
  String _sortBy = 'Distance';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    return Scaffold(
      backgroundColor: themeManager.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search and Filter Header
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: themeManager.surfaceColor,
                boxShadow: themeManager.subtleShadow,
              ),
              child: Column(
                children: [
                  // Title and View Toggle
                  Row(
                    children: [
                      Text(
                        'Find Services',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: themeManager.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: themeManager.inputBackground,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            _buildViewToggle(
                              icon: Prbal.map,
                              isSelected: _isMapView,
                              onTap: () => setState(() => _isMapView = true),
                              themeManager: themeManager,
                            ),
                            _buildViewToggle(
                              icon: Prbal.list,
                              isSelected: !_isMapView,
                              onTap: () => setState(() => _isMapView = false),
                              themeManager: themeManager,
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
                      color: themeManager.inputBackground,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for services...',
                        hintStyle: TextStyle(
                          color: themeManager.textTertiary,
                          fontSize: 16.sp,
                        ),
                        prefixIcon: Icon(
                          Prbal.search,
                          color: themeManager.textTertiary,
                        ),
                        suffixIcon: IconButton(
                          onPressed: _showFilterBottomSheet,
                          icon: Icon(
                            Prbal.tune,
                            color: themeManager.primaryColor,
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
                        _buildFilterChip(
                            'All', _selectedCategory == 'All', themeManager),
                        SizedBox(width: 8.w),
                        _buildFilterChip('Home Services',
                            _selectedCategory == 'Home Services', themeManager),
                        SizedBox(width: 8.w),
                        _buildFilterChip('Technical',
                            _selectedCategory == 'Technical', themeManager),
                        SizedBox(width: 8.w),
                        _buildFilterChip('Beauty & Care',
                            _selectedCategory == 'Beauty & Care', themeManager),
                        SizedBox(width: 8.w),
                        _buildFilterChip('Available Now',
                            _selectedCategory == 'Available Now', themeManager),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content Area
            Expanded(
              child: _isMapView
                  ? _buildMapView(themeManager)
                  : _buildListView(themeManager),
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
    required ThemeManager themeManager,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? themeManager.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : themeManager.textTertiary,
          size: 20.sp,
        ),
      ),
    );
  }

  Widget _buildFilterChip(
      String label, bool isSelected, ThemeManager themeManager) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? themeManager.primaryColor
              : themeManager.surfaceColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? themeManager.primaryColor
                : themeManager.borderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : themeManager.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildMapView(ThemeManager themeManager) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          // Map placeholder
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: themeManager.surfaceColor,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: themeManager.subtleShadow,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Prbal.map,
                      size: 80.sp,
                      color: themeManager.textTertiary,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Map View',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: themeManager.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Interactive map with service locations',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: themeManager.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Nearby Services
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nearby Services',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: themeManager.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return _buildNearbyServiceCard(index, themeManager);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(ThemeManager themeManager) {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 8,
      itemBuilder: (context, index) {
        return _buildServiceCard(index, themeManager);
      },
    );
  }

  Widget _buildNearbyServiceCard(int index, ThemeManager themeManager) {
    final services = [
      {
        'name': 'Quick Home Cleaning',
        'provider': 'Sarah J.',
        'distance': '0.5 km',
        'price': '\$45',
        'rating': '4.8'
      },
      {
        'name': 'Plumbing Emergency',
        'provider': 'Mike W.',
        'distance': '1.2 km',
        'price': '\$80',
        'rating': '4.9'
      },
      {
        'name': 'AC Repair Service',
        'provider': 'Lisa B.',
        'distance': '2.1 km',
        'price': '\$120',
        'rating': '4.7'
      },
    ];

    final service = services[index];

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: themeManager.surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: themeManager.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: themeManager.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Prbal.tools,
              color: themeManager.primaryColor,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['name']!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: themeManager.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  service['provider']!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: themeManager.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                service['distance']!,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: themeManager.textTertiary,
                ),
              ),
              Text(
                service['price']!,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: themeManager.successColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(int index, ThemeManager themeManager) {
    final services = [
      {
        'name': 'Professional House Cleaning',
        'provider': 'Sarah Johnson',
        'price': '\$75',
        'rating': '4.9',
        'distance': '2.3 km',
        'time': '1-2 hours',
        'image': 'house_cleaning'
      },
      {
        'name': 'AC Repair & Maintenance',
        'provider': 'Mike Wilson',
        'price': '\$120',
        'rating': '4.8',
        'distance': '1.5 km',
        'time': '2-3 hours',
        'image': 'ac_repair'
      },
      {
        'name': 'Garden Maintenance',
        'provider': 'Lisa Brown',
        'price': '\$60',
        'rating': '4.7',
        'distance': '3.1 km',
        'time': '3-4 hours',
        'image': 'gardening'
      },
      {
        'name': 'Computer Setup & Repair',
        'provider': 'David Lee',
        'price': '\$90',
        'rating': '4.9',
        'distance': '0.8 km',
        'time': '1-2 hours',
        'image': 'computer'
      },
      {
        'name': 'Plumbing Services',
        'provider': 'Emma Davis',
        'price': '\$85',
        'rating': '4.6',
        'distance': '4.2 km',
        'time': '2-3 hours',
        'image': 'plumbing'
      },
      {
        'name': 'Electrical Work',
        'provider': 'Robert Taylor',
        'price': '\$110',
        'rating': '4.8',
        'distance': '1.9 km',
        'time': '2-4 hours',
        'image': 'electrical'
      },
      {
        'name': 'Beauty & Spa Services',
        'provider': 'Maria Garcia',
        'price': '\$95',
        'rating': '4.9',
        'distance': '2.7 km',
        'time': '2-3 hours',
        'image': 'beauty'
      },
      {
        'name': 'Pet Grooming',
        'provider': 'James Wilson',
        'price': '\$55',
        'rating': '4.7',
        'distance': '3.5 km',
        'time': '1-2 hours',
        'image': 'pet_grooming'
      },
    ];

    final service = services[index % services.length];

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: themeManager.surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: themeManager.subtleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Image Placeholder
          Container(
            height: 160.h,
            decoration: BoxDecoration(
              gradient: themeManager.primaryGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Center(
              child: Icon(
                _getServiceIcon(service['image']!),
                size: 60.sp,
                color: Colors.white,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Header
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        service['name']!,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: themeManager.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: themeManager.successColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Prbal.star,
                            size: 12.sp,
                            color: themeManager.warningColor,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            service['rating']!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: themeManager.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),

                // Provider Info
                Text(
                  'by ${service['provider']}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: themeManager.textSecondary,
                  ),
                ),

                SizedBox(height: 12.h),

                // Service Details
                Row(
                  children: [
                    Icon(
                      Prbal.mapPin,
                      size: 14.sp,
                      color: themeManager.textTertiary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      service['distance']!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: themeManager.textSecondary,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Icon(
                      Prbal.clock,
                      size: 14.sp,
                      color: themeManager.textTertiary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      service['time']!,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: themeManager.textSecondary,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Price and Action
                Row(
                  children: [
                    Text(
                      service['price']!,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: themeManager.successColor,
                      ),
                    ),
                    Text(
                      ' / service',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: themeManager.textTertiary,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        // Book service
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeManager.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String imageType) {
    switch (imageType) {
      case 'house_cleaning':
        return Prbal.home;
      case 'ac_repair':
        return Prbal.tools;
      case 'gardening':
        return Prbal.leaf;
      case 'computer':
        return Prbal.laptop;
      case 'plumbing':
        return Prbal.tools;
      case 'electrical':
        return Prbal.bolt;
      case 'beauty':
        return Prbal.heart;
      case 'pet_grooming':
        return Prbal.heart;
      default:
        return Prbal.tools;
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    final themeManager = ThemeManager.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: themeManager.surfaceColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: themeManager.borderColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Title
            Text(
              'Filter Services',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: themeManager.textPrimary,
              ),
            ),
            SizedBox(height: 24.h),

            // Radius Filter
            Text(
              'Search Radius',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: themeManager.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: themeManager.primaryColor,
                inactiveTrackColor: themeManager.borderColor,
                thumbColor: themeManager.primaryColor,
                overlayColor: themeManager.primaryColor.withValues(alpha: 0.1),
              ),
              child: Slider(
                value: _selectedRadius,
                min: 1.0,
                max: 20.0,
                divisions: 19,
                label: '${_selectedRadius.round()} km',
                onChanged: (value) {
                  setState(() {
                    _selectedRadius = value;
                  });
                },
              ),
            ),
            SizedBox(height: 24.h),

            // Sort By
            Text(
              'Sort By',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: themeManager.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              children:
                  ['Distance', 'Price', 'Rating', 'Availability'].map((sort) {
                return ChoiceChip(
                  label: Text(sort),
                  selected: _sortBy == sort,
                  onSelected: (selected) {
                    setState(() {
                      _sortBy = sort;
                    });
                  },
                  selectedColor:
                      themeManager.primaryColor.withValues(alpha: 0.2),
                  backgroundColor: themeManager.inputBackground,
                  labelStyle: TextStyle(
                    color: _sortBy == sort
                        ? themeManager.primaryColor
                        : themeManager.textSecondary,
                    fontWeight:
                        _sortBy == sort ? FontWeight.w600 : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: _sortBy == sort
                        ? themeManager.primaryColor
                        : themeManager.borderColor,
                  ),
                );
              }).toList(),
            ),
            const Spacer(),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeManager.primaryColor,
                  foregroundColor: Colors.white,
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
    );
  }
}
