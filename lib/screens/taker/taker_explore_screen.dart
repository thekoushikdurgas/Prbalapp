import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Search and Filter Header
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.3)
                        : Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
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
                          color:
                              isDark ? Colors.white : const Color(0xFF2D3748),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2D2D2D)
                              : const Color(0xFFF7FAFC),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            _buildViewToggle(
                              icon: Prbal.map,
                              isSelected: _isMapView,
                              onTap: () => setState(() => _isMapView = true),
                              isDark: isDark,
                            ),
                            _buildViewToggle(
                              icon: Prbal.list,
                              isSelected: !_isMapView,
                              onTap: () => setState(() => _isMapView = false),
                              isDark: isDark,
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
                      color: isDark
                          ? const Color(0xFF2D2D2D)
                          : const Color(0xFFF7FAFC),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for services...',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 16.sp,
                        ),
                        prefixIcon: Icon(
                          Prbal.search,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        suffixIcon: IconButton(
                          onPressed: _showFilterBottomSheet,
                          icon: Icon(
                            Prbal.tune,
                            color: const Color(0xFF4299E1),
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
                            'All', _selectedCategory == 'All', isDark),
                        SizedBox(width: 8.w),
                        _buildFilterChip('Home Services',
                            _selectedCategory == 'Home Services', isDark),
                        SizedBox(width: 8.w),
                        _buildFilterChip('Technical',
                            _selectedCategory == 'Technical', isDark),
                        SizedBox(width: 8.w),
                        _buildFilterChip('Beauty & Care',
                            _selectedCategory == 'Beauty & Care', isDark),
                        SizedBox(width: 8.w),
                        _buildFilterChip('Available Now',
                            _selectedCategory == 'Available Now', isDark),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content Area
            Expanded(
              child:
                  _isMapView ? _buildMapView(isDark) : _buildListView(isDark),
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
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4299E1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          color: isSelected
              ? Colors.white
              : (isDark ? Colors.grey[400] : Colors.grey[600]),
          size: 20.sp,
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, bool isDark) {
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
              ? const Color(0xFF4299E1)
              : (isDark ? const Color(0xFF2D2D2D) : Colors.white),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4299E1)
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white : const Color(0xFF2D3748)),
          ),
        ),
      ),
    );
  }

  Widget _buildMapView(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.grey[300],
      ),
      child: Stack(
        children: [
          // Map Placeholder
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.grey[300],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Prbal.map,
                    size: 64.sp,
                    color: isDark ? Colors.grey[600] : Colors.grey[500],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Map View',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Services near your location',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.grey[500] : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Service Cards
          Positioned(
            bottom: 20.h,
            left: 20.w,
            right: 20.w,
            child: SizedBox(
              height: 160.h,
              child: PageView(
                children: [
                  _buildMapServiceCard(
                    'Professional Home Cleaning',
                    'Sarah Johnson',
                    4.8,
                    '0.3 km away',
                    '\$40/hour',
                    'Available now',
                    const Color(0xFF4299E1),
                    isDark,
                  ),
                  _buildMapServiceCard(
                    'AC Repair & Maintenance',
                    'Mike Wilson',
                    4.9,
                    '0.7 km away',
                    '\$60/hour',
                    'Available today',
                    const Color(0xFF48BB78),
                    isDark,
                  ),
                  _buildMapServiceCard(
                    'Plumbing Services',
                    'John Smith',
                    4.7,
                    '1.2 km away',
                    '\$55/hour',
                    'Available tomorrow',
                    const Color(0xFF9F7AEA),
                    isDark,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapServiceCard(
    String title,
    String provider,
    double rating,
    String distance,
    String price,
    String availability,
    Color accentColor,
    bool isDark,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: accentColor.withValues(alpha: 0.1),
                child: Icon(
                  Prbal.user,
                  color: accentColor,
                  size: 20.sp,
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
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      provider,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(
                    Prbal.star,
                    size: 14.sp,
                    color: const Color(0xFFED8936),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    rating.toString(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFED8936),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Prbal.mapMarker,
                size: 14.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              SizedBox(width: 4.w),
              Text(
                distance,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const Spacer(),
              Text(
                price,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF48BB78),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  availability,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Book service
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Book',
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

  Widget _buildListView(bool isDark) {
    return Column(
      children: [
        // Sort Options
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Text(
                '25 services found',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const Spacer(),
              DropdownButton<String>(
                value: _sortBy,
                onChanged: (value) {
                  setState(() {
                    _sortBy = value!;
                  });
                },
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.white : const Color(0xFF2D3748),
                ),
                dropdownColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                underline: Container(),
                items: ['Distance', 'Rating', 'Price', 'Availability']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text('Sort by $value'),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        // Services List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(20.w),
            itemCount: 15, // Mock data
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.3)
                          : Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _buildServiceListItem(index, isDark),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceListItem(int index, bool isDark) {
    final services = [
      'Professional Home Cleaning',
      'AC Repair & Maintenance',
      'Plumbing Services',
      'Garden Maintenance',
      'Computer Repair',
      'Beauty & Spa Services',
      'Electrical Work',
      'Painting Services',
    ];

    final providers = [
      'Sarah Johnson',
      'Mike Wilson',
      'John Smith',
      'Lisa Brown',
      'David Lee',
      'Emma Davis',
      'Robert Taylor',
      'Maria Garcia',
    ];

    final colors = [
      const Color(0xFF4299E1),
      const Color(0xFF48BB78),
      const Color(0xFF9F7AEA),
      const Color(0xFFED8936),
      const Color(0xFFED64A6),
      const Color(0xFF38B2AC),
      const Color(0xFFD69E2E),
      const Color(0xFF667EEA),
    ];

    final ratings = [4.8, 4.9, 4.7, 4.6, 4.8, 4.9, 4.5, 4.7];

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor:
                    colors[index % colors.length].withValues(alpha: 0.1),
                child: Icon(
                  Prbal.user,
                  color: colors[index % colors.length],
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      services[index % services.length],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      providers[index % providers.length],
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Prbal.star,
                          size: 14.sp,
                          color: const Color(0xFFED8936),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          ratings[index % ratings.length].toString(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFED8936),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '•',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${(index * 0.3 + 0.2).toStringAsFixed(1)} km away',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${30 + (index * 10)}/hour',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF48BB78),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color:
                          colors[index % colors.length].withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      index % 3 == 0 ? 'Available now' : 'Available today',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: colors[index % colors.length],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Professional service with 5+ years experience. Fully equipped and insured.',
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // View profile
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors[index % colors.length],
                    side: BorderSide(color: colors[index % colors.length]),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                  ),
                  child: Text(
                    'View Profile',
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Book service
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors[index % colors.length],
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                  ),
                  child: Text(
                    'Book Now',
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                  ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
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
              color: isDark ? Colors.grey[600] : Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Title
          Text(
            'Filter Services',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF2D3748),
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
                      color: isDark ? Colors.white : const Color(0xFF2D3748),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Slider(
                    value: _selectedRadius,
                    min: 1.0,
                    max: 20.0,
                    divisions: 19,
                    label: '${_selectedRadius.round()} km',
                    activeColor: const Color(0xFF4299E1),
                    onChanged: (value) {
                      setState(() {
                        _selectedRadius = value;
                      });
                    },
                  ),

                  SizedBox(height: 24.h),

                  Text(
                    'Price Range',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF2D3748),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Price range checkboxes or sliders can be added here

                  const Spacer(),

                  // Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4299E1),
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
