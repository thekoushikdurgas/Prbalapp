import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:go_router/go_router.dart';

class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  ConsumerState<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> with TickerProviderStateMixin {
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
    debugPrint('🎯 PaymentsScreen: Initializing animations and controllers');
    _initializeAnimations();
    _startAnimations();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _initializeAnimations() {
    debugPrint('🎯 PaymentsScreen: Setting up fade animation controller');
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
    debugPrint('🎯 PaymentsScreen: Starting entrance animations');
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
  }

  @override
  void dispose() {
    debugPrint('🎯 PaymentsScreen: Disposing controllers');
    _fadeController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeManager.of(context).backgroundColor,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildBalanceCard(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTransactionsTab(),
                  _buildPaymentMethodsTab(),
                  _buildSettingsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    debugPrint('🎨 PaymentsScreen: Building app bar with theme colors');
    return AppBar(
      backgroundColor: ThemeManager.of(context).surfaceColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Prbal.arrowLeft,
          color: ThemeManager.of(context).textPrimary,
        ),
        onPressed: () {
          debugPrint('🔄 PaymentsScreen: Navigating back');
          context.pop();
        },
      ),
      title: Text(
        'Payments',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: ThemeManager.of(context).textPrimary,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Prbal.plus,
            color: ThemeManager.of(context).textSecondary,
          ),
          onPressed: () {
            debugPrint('🎯 PaymentsScreen: Opening add payment method dialog');
            _showAddPaymentMethodDialog();
          },
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildBalanceCard() {
    debugPrint('🎨 PaymentsScreen: Building balance card with primary gradient');
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: ThemeManager.of(context).primaryGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: ThemeManager.of(context).primaryShadow,
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
                  color: Colors.white.withValues(alpha: 179), // 0.7 opacity
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
                    color: Colors.white.withValues(alpha: 51), // 0.2 opacity
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
                    color: Colors.white.withValues(alpha: 51), // 0.2 opacity
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

  Widget _buildTabBar() {
    debugPrint('🎨 PaymentsScreen: Building tab bar with surface colors');
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: ThemeManager.of(context).surfaceColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: ThemeManager.of(context).subtleShadow,
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: ThemeManager.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: ThemeManager.of(context).textTertiary,
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

  Widget _buildTransactionsTab() {
    debugPrint('🎯 PaymentsScreen: Building transactions tab with ${_transactions.length} items');
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final transaction = _transactions[index];
        return _buildTransactionItem(transaction);
      },
    );
  }

  Widget _buildTransactionItem(
    Map<String, dynamic> transaction,
  ) {
    final isIncome = transaction['amount'] > 0;
    final status = transaction['status'] as String;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ThemeManager.of(context).surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: ThemeManager.of(context).subtleShadow,
        border: Border.all(
          color: ThemeManager.of(context).borderColor,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: _getTransactionIconColor(transaction['type'], isIncome),
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: ThemeManager.of(context).subtleShadow,
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
                    color: ThemeManager.of(context).textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  transaction['provider'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ThemeManager.of(context).textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        transaction['paymentMethod'],
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ThemeManager.of(context).textTertiary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withValues(alpha: 26), // 0.1 opacity
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
                  color: isIncome ? ThemeManager.of(context).successColor : ThemeManager.of(context).textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                _formatDate(transaction['date']),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: ThemeManager.of(context).textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsTab() {
    debugPrint('🎯 PaymentsScreen: Building payment methods tab with ${_paymentMethods.length} methods');
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _paymentMethods.length,
      itemBuilder: (context, index) {
        final method = _paymentMethods[index];
        return _buildPaymentMethodItem(method);
      },
    );
  }

  Widget _buildPaymentMethodItem(
    Map<String, dynamic> method,
  ) {
    final isCard = method['type'] == 'card';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            method['color'] as Color,
            (method['color'] as Color).withValues(alpha: 204), // 0.8 opacity
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: (method['color'] as Color).withValues(alpha: 77), // 0.3 opacity
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
              Flexible(
                child: Text(
                  method['name'],
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (method['isDefault'])
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 51), // 0.2 opacity
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
              color: Colors.white.withValues(alpha: 179), // 0.7 opacity
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
                    color: Colors.white.withValues(alpha: 179), // 0.7 opacity
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

  Widget _buildSettingsTab() {
    debugPrint('🎯 PaymentsScreen: Building settings tab with theme-aware styling');
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _buildSettingItem(
          icon: Prbal.security,
          title: 'Payment Security',
          subtitle: 'Manage payment security settings',
          
          onTap: () {
            debugPrint('🔒 PaymentsScreen: Opening payment security settings');
          },
        ),
        _buildSettingItem(
          icon: Prbal.bell,
          title: 'Payment Notifications',
          subtitle: 'Configure payment alerts',
          
          onTap: () {
            debugPrint('🔔 PaymentsScreen: Opening notification settings');
          },
        ),
        _buildSettingItem(
          icon: Prbal.rupee,
          title: 'Transaction History',
          subtitle: 'Export transaction records',
          
          onTap: () {
            debugPrint('📊 PaymentsScreen: Opening transaction history export');
          },
        ),
        _buildSettingItem(
          icon: Prbal.questionCircle,
          title: 'Payment Help',
          subtitle: 'Get help with payments',
          
          onTap: () {
            debugPrint('❓ PaymentsScreen: Opening payment help');
          },
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: ThemeManager.of(context).surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: ThemeManager.of(context).subtleShadow,
        border: Border.all(
          color: ThemeManager.of(context).borderColor,
          width: 0.5,
        ),
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
                    color: ThemeManager.of(context).primaryColor.withValues(alpha: 26), // 0.1 opacity
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Icon(
                    icon,
                    color: ThemeManager.of(context).primaryColor,
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
                          color: ThemeManager.of(context).textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ThemeManager.of(context).textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Prbal.angleRight,
                  color: ThemeManager.of(context).textTertiary,
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

  void _showAddPaymentMethodDialog() {
    debugPrint('🎯 PaymentsScreen: Showing add payment method modal');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: ThemeManager.of(context).surfaceColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          boxShadow: ThemeManager.of(context).elevatedShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: ThemeManager.of(context).borderColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Add Payment Method',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: ThemeManager.of(context).textPrimary,
              ),
            ),
            SizedBox(height: 24.h),
            _buildAddMethodOption(
              icon: Prbal.creditCard,
              title: 'Credit/Debit Card',
              subtitle: 'Add a new card',
              
              onTap: () {
                debugPrint('💳 PaymentsScreen: Adding credit/debit card');
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 12.h),
            _buildAddMethodOption(
              icon: Prbal.paypal,
              title: 'PayPal',
              subtitle: 'Connect your PayPal account',
              
              onTap: () {
                debugPrint('💰 PaymentsScreen: Adding PayPal account');
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 12.h),
            _buildAddMethodOption(
              icon: Prbal.university,
              title: 'Bank Account',
              subtitle: 'Add bank account details',
              
              onTap: () {
                debugPrint('🏦 PaymentsScreen: Adding bank account');
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMethodOption({
    required IconData icon,
    required String title,
    required String subtitle,
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
              color: ThemeManager.of(context).borderColor,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: ThemeManager.of(context).primaryColor.withValues(alpha: 26), // 0.1 opacity
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  icon,
                  color: ThemeManager.of(context).primaryColor,
                  size: 20.sp,
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
                        color: ThemeManager.of(context).textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ThemeManager.of(context).textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Prbal.angleRight,
                color: ThemeManager.of(context).textTertiary,
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
