import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:go_router/go_router.dart';

class FullScreenImageScreen extends ConsumerStatefulWidget {
  final String imageUrl;
  final String heroTag;
  final List<String>? imageUrls;
  final int? initialIndex;

  const FullScreenImageScreen({
    super.key,
    required this.imageUrl,
    this.heroTag = 'image',
    this.imageUrls,
    this.initialIndex,
  });

  @override
  ConsumerState<FullScreenImageScreen> createState() => _FullScreenImageScreenState();
}

class _FullScreenImageScreenState extends ConsumerState<FullScreenImageScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late PageController _pageController;

  final TransformationController _transformationController = TransformationController();
  bool _isControlsVisible = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();

    _currentIndex = widget.initialIndex ?? 0;
    _pageController = PageController(initialPage: _currentIndex);

    // Hide system UI for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _fadeController.forward();

    // Auto-hide controls after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isControlsVisible) {
        _toggleControls();
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _isControlsVisible = !_isControlsVisible;
    });

    if (_isControlsVisible) {
      _fadeController.forward();
      // Auto-hide after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isControlsVisible) {
          _toggleControls();
        }
      });
    } else {
      _fadeController.reverse();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pageController.dispose();
    _transformationController.dispose();

    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasMultipleImages = widget.imageUrls != null && widget.imageUrls!.length > 1;

    debugPrint('🖼️ FullScreenImageScreen: Building full screen image viewer');
    debugPrint('🖼️ FullScreenImageScreen: Dark mode: ${ThemeManager.of(context).themeManager}');
    debugPrint('🖼️ FullScreenImageScreen: Multiple images: $hasMultipleImages');

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image content
          GestureDetector(
            onTap: _toggleControls,
            child: hasMultipleImages ? _buildImageGallery() : _buildSingleImage(),
          ),

          // Top controls
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Transform.translate(
                  offset: Offset(0, -60 * (1 - _fadeAnimation.value)),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: _buildTopControls(),
                  ),
                ),
              );
            },
          ),

          // Bottom controls (for gallery)
          if (hasMultipleImages)
            AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: Offset(0, 60 * (1 - _fadeAnimation.value)),
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: _buildBottomControls(),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSingleImage() {
    return Center(
      child: Hero(
        tag: widget.heroTag,
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: 0.5,
          maxScale: 4.0,
          onInteractionStart: (_) => _toggleControls(),
          child: Image.network(
            widget.imageUrl,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Loading image...',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Prbal.exclamationTriangle,
                      color: Colors.white70,
                      size: 48.sp,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Failed to load image',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextButton(
                      onPressed: () => setState(() {}),
                      child: Text(
                        'Retry',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
        _transformationController.value = Matrix4.identity();
      },
      itemCount: widget.imageUrls!.length,
      itemBuilder: (context, index) {
        final imageUrl = widget.imageUrls![index];

        return Center(
          child: Hero(
            tag: index == widget.initialIndex ? widget.heroTag : 'gallery_$index',
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.5,
              maxScale: 4.0,
              onInteractionStart: (_) {
                if (_isControlsVisible) _toggleControls();
              },
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Loading image ${index + 1} of ${widget.imageUrls!.length}...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Prbal.exclamationTriangle,
                          color: Colors.white70,
                          size: 48.sp,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Failed to load image ${index + 1}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextButton(
                          onPressed: () => setState(() {}),
                          child: Text(
                            'Retry',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopControls() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.transparent,
          ],
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        left: 16.w,
        right: 16.w,
        bottom: 24.h,
      ),
      child: Row(
        children: [
          // Back button
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(22.r),
            ),
            child: IconButton(
              onPressed: () => context.pop(),
              icon: Icon(
                Prbal.arrowLeft,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),

          const Spacer(),

          // Image counter (for gallery)
          if (widget.imageUrls != null && widget.imageUrls!.length > 1)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '${_currentIndex + 1} / ${widget.imageUrls!.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          const Spacer(),

          // Action buttons
          Row(
            children: [
              // Zoom reset button
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: IconButton(
                  onPressed: () {
                    _transformationController.value = Matrix4.identity();
                  },
                  icon: Icon(
                    Prbal.searchMinus,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              // Share button
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: IconButton(
                  onPressed: () => _shareImage(),
                  icon: Icon(
                    Prbal.share,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),

              SizedBox(width: 8.w),

              // More options
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: IconButton(
                  onPressed: () => _showMoreOptions(),
                  icon: Icon(
                    Prbal.moreVertical,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.transparent,
          ],
        ),
      ),
      padding: EdgeInsets.only(
        top: 24.h,
        left: 16.w,
        right: 16.w,
        bottom: MediaQuery.of(context).padding.bottom + 16.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Thumbnail strip
          SizedBox(
            height: 60.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.imageUrls!.length,
              itemBuilder: (context, index) {
                final isSelected = index == _currentIndex;

                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 8.w),
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.r),
                      child: Image.network(
                        widget.imageUrls![index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[800],
                          child: Icon(
                            Prbal.image,
                            color: Colors.white54,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 16.h),

          // Navigation arrows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Previous button
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: _currentIndex > 0 ? Colors.white.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: IconButton(
                  onPressed: _currentIndex > 0
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  icon: Icon(
                    Prbal.angleLeft,
                    color: _currentIndex > 0 ? Colors.white : Colors.white54,
                    size: 24.sp,
                  ),
                ),
              ),

              // Page indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${_currentIndex + 1} of ${widget.imageUrls!.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Next button
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: _currentIndex < widget.imageUrls!.length - 1
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: IconButton(
                  onPressed: _currentIndex < widget.imageUrls!.length - 1
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  icon: Icon(
                    Prbal.angleRight,
                    color: _currentIndex < widget.imageUrls!.length - 1 ? Colors.white : Colors.white54,
                    size: 24.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _shareImage() {
    // Implement image sharing functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Share Image',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Image sharing functionality would be implemented here.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 24.h),
            _buildOptionItem(
              icon: Prbal.download,
              title: 'Save to Gallery',
              onTap: () {
                Navigator.pop(context);
                _saveImage();
              },
            ),
            _buildOptionItem(
              icon: Prbal.copy,
              title: 'Copy Image URL',
              onTap: () {
                Navigator.pop(context);
                _copyImageUrl();
              },
            ),
            _buildOptionItem(
              icon: Prbal.externalLink,
              title: 'Open in Browser',
              onTap: () {
                Navigator.pop(context);
                _openInBrowser();
              },
            ),
            _buildOptionItem(
              icon: Prbal.flag,
              title: 'Report Image',
              onTap: () {
                Navigator.pop(context);
                _reportImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }

  void _saveImage() {
    // Implement save to gallery functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Save functionality would be implemented here'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  void _copyImageUrl() {
    final currentImageUrl = widget.imageUrls != null ? widget.imageUrls![_currentIndex] : widget.imageUrl;

    Clipboard.setData(ClipboardData(text: currentImageUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Image URL copied to clipboard'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  void _openInBrowser() {
    // Implement open in browser functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Open in browser functionality would be implemented here'),
        backgroundColor: const Color(0xFF3B82F6),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  void _reportImage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Report Image',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to report this image as inappropriate?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Image reported successfully'),
                  backgroundColor: const Color(0xFFEF4444),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(16.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('Report', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
