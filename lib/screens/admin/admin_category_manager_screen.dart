import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:prbal/widgets/admin/category_widget.dart';

/// AdminCategoryManagerScreen - Modern category management screen
///
/// **Purpose**: Provides an advanced interface for admin category management with Material Design 3.0
///
/// **Key Features**:
/// - Modern Material Design 3.0 components with enhanced visual hierarchy
/// - Advanced dark/light theme support with dynamic gradients and glass morphism
/// - Intelligent search and filtering with real-time feedback and suggestions
/// - Intuitive category CRUD operations with smooth animations and haptic feedback
/// - Smart selection and bulk actions with contextual controls
/// - Beautiful modal bottom sheets with progressive disclosure
/// - Enhanced accessibility and user experience
/// - Performance optimized with lazy loading and caching
class AdminCategoryManagerScreen extends ConsumerStatefulWidget {
  const AdminCategoryManagerScreen({super.key});

  @override
  ConsumerState<AdminCategoryManagerScreen> createState() => _AdminCategoryManagerScreenState();
}

class _AdminCategoryManagerScreenState extends ConsumerState<AdminCategoryManagerScreen> with TickerProviderStateMixin {
  // ========== STATE VARIABLES ==========
  final Set<String> _selectedIds = <String>{};

  @override
  void initState() {
    super.initState();
    debugPrint('🏷️ AdminCategoryManager: Initializing modern category management screen');
    debugPrint('🏷️ AdminCategoryManager: Screen initialization completed');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🎨 AdminCategoryManager: Building modern category management screen');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    debugPrint('🎨 AdminCategoryManager: Theme mode: ${isDark ? 'dark' : 'light'}');

    return Scaffold(
      // Modern gradient background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1A1A1A), const Color(0xFF0D1117)]
                : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ========== CATEGORIES LIST ==========
              Expanded(
                child: ServiceCategoryCrudWidget(
                  selectedIds: _selectedIds,
                  showBackButton: true,
                  title: 'Category Manager',
                  subtitle: 'Manage your service categories',
                  onBackPressed: () {
                    debugPrint('⬅️ AdminCategoryManager: Back button pressed');
                    Navigator.of(context).pop();
                  },
                  onSelectionChanged: (categoryId) {
                    debugPrint('📋 AdminCategoryManager: Category selection changed: $categoryId');
                    setState(() {
                      if (_selectedIds.contains(categoryId)) {
                        _selectedIds.remove(categoryId);
                        debugPrint('📋 AdminCategoryManager: Category deselected: $categoryId');
                      } else {
                        _selectedIds.add(categoryId);
                        debugPrint('📋 AdminCategoryManager: Category selected: $categoryId');
                      }
                    });
                    debugPrint('📋 AdminCategoryManager: Total selected categories: ${_selectedIds.length}');

                    // Haptic feedback
                    HapticFeedback.selectionClick();
                  },
                  onDataChanged: () {
                    debugPrint('📋 AdminCategoryManager: Categories data changed - triggering UI update');
                    setState(() {
                      // Force UI update when data changes
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('🏷️ AdminCategoryManager: Disposing modern category management screen');
    debugPrint('🏷️ AdminCategoryManager: Screen disposed successfully');
    super.dispose();
  }
}
