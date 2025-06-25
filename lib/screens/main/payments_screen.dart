import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:go_router/go_router.dart';

class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  ConsumerState<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;

  // Mock data for payment methods
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': '1',
      'type': 'card',
      'name': 'Visa ****1234',
      'provider': 'Visa',
      'isDefault': true,
      'expiryDate': '12/25',
      'color': const Color(0xFF1A1F71),
    },
    {
      'id': '2',
      'type': 'card',
      'name': 'Mastercard ****5678',
      'provider': 'Mastercard',
      'isDefault': false,
      'expiryDate': '08/26',
      'color': const Color(0xFFEB001B),
    },
    {
      'id': '3',
      'type': 'wallet',
      'name': 'PayPal',
      'provider': 'PayPal',
      'isDefault': false,
      'balance': 245.50,
      'color': const Color(0xFF003087),
    },
  ];

  // Mock data for transactions
  final List<Map<String, dynamic>> _transactions = [
    {
      'id': '1',
      'title': 'House Cleaning Service',
      'provider': 'Sarah Johnson',
      'amount': -75.00,
      'status': 'completed',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'paymentMethod': 'Visa ****1234',
      'type': 'service',
    },
    {
      'id': '2',
      'title': 'Laptop Repair',
      'provider': 'Tech Solutions',
      'amount': -120.00,
      'status': 'completed',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'paymentMethod': 'PayPal',
      'type': 'service',
    },
    {
      'id': '3',
      'title': 'Refund - Cancelled Service',
      'provider': 'Beauty Pro',
      'amount': 45.00,
      'status': 'completed',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'paymentMethod': 'Visa ****1234',
      'type': 'refund',
    },
    {
      'id': '4',
      'title': 'Hair Styling',
      'provider': 'Beauty Pro',
      'amount': -35.00,
      'status': 'pending',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'paymentMethod': 'Mastercard ****5678',
      'type': 'service',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: _buildAppBar(isDark),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildBalanceCard(isDark),
            _buildTabBar(isDark),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTransactionsTab(isDark),
                  _buildPaymentMethodsTab(isDark),
                  _buildSettingsTab(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Prbal.arrowLeft,
          color: isDark ? Colors.white : const Color(0xFF1F2937),
        ),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Payments',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : const Color(0xFF1F2937),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Prbal.plus,
            color: isDark ? Colors.white70 : const Color(0xFF6B7280),
          ),
          onPressed: () => _showAddPaymentMethodDialog(isDark),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildBalanceCard(bool isDark) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Wallet Balance',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Prbal.wallet,
                color: Colors.white,
                size: 24.sp,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '\$1,234.56',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      'Add Money',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      'Withdraw',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF3B82F6),
          borderRadius: BorderRadius.circular(8.r),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor:
            isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'Transactions'),
          Tab(text: 'Methods'),
          Tab(text: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab(bool isDark) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final transaction = _transactions[index];
        return _buildTransactionItem(transaction, isDark);
      },
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction, bool isDark) {
    final isIncome = transaction['amount'] > 0;
    final status = transaction['status'] as String;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: _getTransactionIconColor(transaction['type'], isIncome),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Icon(
              _getTransactionIcon(transaction['type'], isIncome),
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['title'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  transaction['provider'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF6B7280),
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      transaction['paymentMethod'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDark
                            ? const Color(0xFF64748B)
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(status),
                        ),
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
                '${isIncome ? '+' : ''}\$${transaction['amount'].abs().toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: isIncome
                      ? const Color(0xFF10B981)
                      : (isDark ? Colors.white : const Color(0xFF1F2937)),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                _formatDate(transaction['date']),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsTab(bool isDark) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _paymentMethods.length,
      itemBuilder: (context, index) {
        final method = _paymentMethods[index];
        return _buildPaymentMethodItem(method, isDark);
      },
    );
  }

  Widget _buildPaymentMethodItem(Map<String, dynamic> method, bool isDark) {
    final isCard = method['type'] == 'card';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            method['color'] as Color,
            (method['color'] as Color).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: (method['color'] as Color).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                method['name'],
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              if (method['isDefault'])
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'DEFAULT',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            method['provider'],
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isCard) ...[
                Text(
                  'Expires ${method['expiryDate']}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white70,
                  ),
                ),
              ] else ...[
                Text(
                  'Balance: \$${method['balance'].toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
              Icon(
                isCard ? Prbal.creditCard : Prbal.wallet,
                color: Colors.white,
                size: 24.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab(bool isDark) {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildSettingItem(
          icon: Prbal.security,
          title: 'Payment Security',
          subtitle: 'Manage payment security settings',
          isDark: isDark,
          onTap: () {},
        ),
        _buildSettingItem(
          icon: Prbal.bell,
          title: 'Payment Notifications',
          subtitle: 'Configure payment alerts',
          isDark: isDark,
          onTap: () {},
        ),
        _buildSettingItem(
          icon: Prbal.rupee,
          title: 'Transaction History',
          subtitle: 'Export transaction records',
          isDark: isDark,
          onTap: () {},
        ),
        _buildSettingItem(
          icon: Prbal.questionCircle,
          title: 'Payment Help',
          subtitle: 'Get help with payments',
          isDark: isDark,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF3B82F6),
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color:
                              isDark ? Colors.white : const Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Prbal.angleRight,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF9CA3AF),
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getTransactionIcon(String type, bool isIncome) {
    switch (type) {
      case 'service':
        return isIncome ? Prbal.arrowUp : Prbal.arrowDown;
      case 'refund':
        return Prbal.undo;
      default:
        return Prbal.stackExchange;
    }
  }

  Color _getTransactionIconColor(String type, bool isIncome) {
    switch (type) {
      case 'service':
        return isIncome ? const Color(0xFF10B981) : const Color(0xFF3B82F6);
      case 'refund':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6366F1);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'failed':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showAddPaymentMethodDialog(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Payment Method',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 24.h),
            _buildAddMethodOption(
              icon: Prbal.creditCard,
              title: 'Credit/Debit Card',
              subtitle: 'Add a new card',
              isDark: isDark,
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 12.h),
            _buildAddMethodOption(
              icon: Prbal.paypal,
              title: 'PayPal',
              subtitle: 'Connect your PayPal account',
              isDark: isDark,
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 12.h),
            _buildAddMethodOption(
              icon: Prbal.university,
              title: 'Bank Account',
              subtitle: 'Add bank account details',
              isDark: isDark,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMethodOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF3B82F6),
                size: 24.sp,
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Prbal.angleRight,
                color:
                    isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
