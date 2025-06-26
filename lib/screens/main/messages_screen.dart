import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
import 'package:prbal/utils/theme/theme_manager.dart';
import 'package:go_router/go_router.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  final String? initialChatId;
  final String? initialUserId;
  final String conversationName;
  final String? avatarUrl;
  final bool isNewConversation;

  const MessagesScreen({
    super.key,
    this.initialChatId,
    this.initialUserId,
    this.conversationName = 'Messages',
    this.avatarUrl,
    this.isNewConversation = false,
  });

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isInChat = false;

  // Mock data for conversations
  final List<Map<String, dynamic>> _conversations = [
    {
      'id': '1',
      'name': 'John Smith',
      'lastMessage': 'Thanks for the great service!',
      'time': '2 min ago',
      'unread': 2,
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'isOnline': true,
    },
    {
      'id': '2',
      'name': 'Sarah Johnson',
      'lastMessage': 'When can you start the project?',
      'time': '15 min ago',
      'unread': 0,
      'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150',
      'isOnline': true,
    },
    {
      'id': '3',
      'name': 'Tech Solutions',
      'lastMessage': 'Your device is ready for pickup',
      'time': '1 hour ago',
      'unread': 1,
      'avatar': 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=150',
      'isOnline': false,
    },
    {
      'id': '4',
      'name': 'Emily Davis',
      'lastMessage': 'Perfect timing, see you tomorrow',
      'time': '3 hours ago',
      'unread': 0,
      'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
      'isOnline': false,
    },
  ];

  // Mock messages for individual chat
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'text': 'Hi! I\'m interested in your house cleaning service',
      'isMe': false,
      'time': '10:30 AM',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '2',
      'text': 'Hello! I\'d be happy to help. What type of cleaning do you need?',
      'isMe': true,
      'time': '10:32 AM',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2, minutes: -2)),
    },
    {
      'id': '3',
      'text': 'I need a deep clean for my 3-bedroom apartment. When are you available?',
      'isMe': false,
      'time': '10:35 AM',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
    },
    {
      'id': '4',
      'text': 'I can do it this weekend. The rate would be \$150 for deep cleaning',
      'isMe': true,
      'time': '10:37 AM',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 53)),
    },
    {
      'id': '5',
      'text': 'That sounds perfect! Can we schedule for Saturday morning?',
      'isMe': false,
      'time': '10:40 AM',
      'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();

    if (widget.initialChatId != null || widget.initialUserId != null) {
      _isInChat = true;
    }
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
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);

    debugPrint('💬 MessagesScreen: Building with enhanced ThemeManager');
    debugPrint('💬 MessagesScreen: Dark mode: ${themeManager.themeManager}');
    debugPrint('💬 MessagesScreen: In chat mode: $_isInChat');

    return Scaffold(
      backgroundColor: themeManager.backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: themeManager.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ========== ENHANCED APP BAR ==========
              _buildEnhancedAppBar(themeManager),

              // ========== MAIN CONTENT ==========
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _isInChat ? _buildChatView(themeManager) : _buildConversationsView(themeManager),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== ENHANCED APP BAR BUILDER ==========
  /// Builds the enhanced app bar with comprehensive ThemeManager integration
  Widget _buildEnhancedAppBar(ThemeManager themeManager) {
    debugPrint('💬 MessagesScreen: Building enhanced app bar');
    debugPrint('💬 MessagesScreen: Chat mode: $_isInChat');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        boxShadow: themeManager.elevatedShadow,
        border: Border(
          bottom: BorderSide(
            color: themeManager.borderColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // ========== BACK BUTTON ==========
          Container(
            decoration: BoxDecoration(
              gradient: themeManager.neutralGradient,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: themeManager.subtleShadow,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: () {
                  debugPrint('💬 MessagesScreen: Back button pressed');
                  if (_isInChat) {
                    debugPrint('💬 MessagesScreen: Returning to conversations list');
                    setState(() {
                      _isInChat = false;
                    });
                  } else {
                    debugPrint('💬 MessagesScreen: Navigating back to previous screen');
                    context.pop();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Icon(
                    Prbal.arrowLeft,
                    color: themeManager.textPrimary,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // ========== TITLE SECTION ==========
          Expanded(
            child: _isInChat ? _buildChatHeader(themeManager) : _buildMessagesHeader(themeManager),
          ),

          // ========== ACTION BUTTONS ==========
          if (_isInChat) ...[
            _buildActionButton(Prbal.phone, themeManager.accent1, themeManager),
            SizedBox(width: 8.w),
            _buildActionButton(Prbal.video, themeManager.accent2, themeManager),
          ] else ...[
            _buildActionButton(Prbal.plus, themeManager.primaryColor, themeManager),
          ],
        ],
      ),
    );
  }

  // ========== CHAT HEADER BUILDER ==========
  /// Builds the chat header when in individual conversation
  Widget _buildChatHeader(ThemeManager themeManager) {
    return Row(
      children: [
        // ========== CONTACT AVATAR ==========
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            gradient: themeManager.primaryGradient,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: themeManager.primaryShadow,
          ),
          child: widget.avatarUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.network(
                    widget.avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Prbal.user,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                )
              : Icon(Prbal.user, color: Colors.white, size: 20.sp),
        ),

        SizedBox(width: 12.w),

        // ========== CONTACT INFO ==========
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.conversationName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: themeManager.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: themeManager.successColor,
                      borderRadius: BorderRadius.circular(4.r),
                      boxShadow: [
                        BoxShadow(
                          color: themeManager.successColor.withValues(alpha: 0.4),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: themeManager.successColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ========== MESSAGES HEADER BUILDER ==========
  /// Builds the messages header when viewing conversations list
  Widget _buildMessagesHeader(ThemeManager themeManager) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Messages',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: themeManager.textPrimary,
          ),
        ),
        Text(
          'Stay connected with your network',
          style: TextStyle(
            fontSize: 12.sp,
            color: themeManager.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ========== ACTION BUTTON BUILDER ==========
  /// Builds action buttons with enhanced styling
  Widget _buildActionButton(IconData icon, Color accentColor, ThemeManager themeManager) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withValues(alpha: 0.1),
            accentColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            debugPrint('💬 MessagesScreen: Action button pressed: $icon');
          },
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              icon,
              color: accentColor,
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
  }

  // ========== CONVERSATIONS VIEW BUILDER ==========
  /// Builds the conversations list view with enhanced ThemeManager styling
  Widget _buildConversationsView(ThemeManager themeManager) {
    debugPrint('💬 MessagesScreen: Building conversations view');
    themeManager.logThemeInfo(); // Debug theme information
    return Column(
      children: [
        // ========== ENHANCED SEARCH BAR ==========
        Container(
          margin: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: themeManager.surfaceGradient,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: themeManager.elevatedShadow,
            border: Border.all(
              color: themeManager.borderColor,
              width: 1,
            ),
          ),
          child: TextField(
            onChanged: (value) {
              debugPrint('💬 MessagesScreen: Search query: "$value"');
            },
            decoration: InputDecoration(
              hintText: 'Search conversations...',
              hintStyle: TextStyle(
                color: themeManager.textTertiary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Container(
                padding: EdgeInsets.all(8.w),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: themeManager.accent4Gradient,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Prbal.search,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
            style: TextStyle(
              color: themeManager.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // ========== CONVERSATIONS STATISTICS ==========
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            gradient: themeManager.accent3Gradient,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: themeManager.primaryShadow,
          ),
          child: Row(
            children: [
              Icon(
                Prbal.messageCircle,
                color: Colors.white,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                '${_conversations.length} Active Conversations',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '${_conversations.where((c) => c['unread'] > 0).length} New',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ========== CONVERSATIONS LIST ==========
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: _conversations.length,
            itemBuilder: (context, index) {
              final conversation = _conversations[index];
              debugPrint('💬 MessagesScreen: Building conversation item ${index + 1}/${_conversations.length}');
              return _buildConversationItem(conversation, themeManager);
            },
          ),
        ),
      ],
    );
  }

  // ========== CONVERSATION ITEM BUILDER ==========
  /// Builds individual conversation items with enhanced ThemeManager styling
  Widget _buildConversationItem(Map<String, dynamic> conversation, ThemeManager themeManager) {
    final hasUnread = conversation['unread'] > 0;
    final isOnline = conversation['isOnline'] as bool;

    debugPrint('💬 MessagesScreen: Building conversation item: ${conversation['name']}');
    debugPrint('💬 MessagesScreen: Unread messages: ${conversation['unread']}, Online: $isOnline');

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        gradient: hasUnread ? themeManager.accent1Gradient : themeManager.surfaceGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: hasUnread ? themeManager.primaryShadow : themeManager.subtleShadow,
        border: Border.all(
          color: hasUnread ? themeManager.accent1.withValues(alpha: 0.3) : themeManager.borderColor,
          width: hasUnread ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () {
            debugPrint('💬 MessagesScreen: Opening conversation with ${conversation['name']}');
            setState(() {
              _isInChat = true;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // ========== ENHANCED AVATAR ==========
                Stack(
                  children: [
                    Container(
                      width: 56.w,
                      height: 56.h,
                      decoration: BoxDecoration(
                        gradient: isOnline ? themeManager.successGradient : themeManager.neutralGradient,
                        borderRadius: BorderRadius.circular(28.r),
                        boxShadow: isOnline ? themeManager.primaryShadow : themeManager.subtleShadow,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28.r),
                        child: Image.network(
                          conversation['avatar'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Prbal.user,
                            color: Colors.white,
                            size: 28.sp,
                          ),
                        ),
                      ),
                    ),
                    // Online indicator
                    if (isOnline)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 16.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            gradient: themeManager.successGradient,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: themeManager.surfaceColor,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: themeManager.successColor.withValues(alpha: 0.5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Unread indicator
                    if (hasUnread)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 20.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            gradient: themeManager.errorGradient,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: themeManager.surfaceColor,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              conversation['unread'].toString(),
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(width: 16.w),

                // ========== CONVERSATION DETAILS ==========
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              conversation['name'],
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: hasUnread ? Colors.white : themeManager.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              gradient: themeManager.accent4Gradient,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              conversation['time'],
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      // Last message with enhanced styling
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: hasUnread ? Colors.white.withValues(alpha: 0.1) : themeManager.backgroundSecondary,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: hasUnread ? Colors.white.withValues(alpha: 0.2) : themeManager.borderColor,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Prbal.messageCircle,
                              size: 12.sp,
                              color: hasUnread ? Colors.white70 : themeManager.textTertiary,
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                conversation['lastMessage'],
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: hasUnread ? Colors.white70 : themeManager.textSecondary,
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== CHAT VIEW BUILDER ==========
  /// Builds the individual chat view with enhanced ThemeManager styling
  Widget _buildChatView(ThemeManager themeManager) {
    debugPrint('💬 MessagesScreen: Building chat view');
    debugPrint('💬 MessagesScreen: Messages count: ${_messages.length}');

    return Column(
      children: [
        // ========== CHAT HEADER INFO ==========
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            gradient: themeManager.accent2Gradient,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: themeManager.primaryShadow,
          ),
          child: Row(
            children: [
              Icon(
                Prbal.shield,
                color: Colors.white,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'End-to-end encrypted conversation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  '${_messages.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ========== MESSAGES LIST ==========
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: themeManager.backgroundGradient,
            ),
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                debugPrint('💬 MessagesScreen: Building message ${index + 1}/${_messages.length}');
                return _buildMessageBubble(message, themeManager);
              },
            ),
          ),
        ),

        // ========== MESSAGE INPUT ==========
        _buildMessageInput(themeManager),
      ],
    );
  }

  // ========== MESSAGE BUBBLE BUILDER ==========
  /// Builds individual message bubbles with enhanced ThemeManager styling
  Widget _buildMessageBubble(Map<String, dynamic> message, ThemeManager themeManager) {
    final isMe = message['isMe'] as bool;
    final messageText = message['text'] as String;
    final messageTime = message['time'] as String;

    debugPrint('💬 MessagesScreen: Building message bubble - isMe: $isMe, text length: ${messageText.length}');

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            // ========== SENDER AVATAR ==========
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                gradient: themeManager.accent3Gradient,
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: themeManager.subtleShadow,
              ),
              child: Icon(
                Prbal.user,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 12.w),
          ],

          // ========== MESSAGE CONTENT ==========
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Message bubble
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      gradient: isMe ? themeManager.primaryGradient : themeManager.surfaceGradient,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                        bottomLeft: Radius.circular(isMe ? 20.r : 6.r),
                        bottomRight: Radius.circular(isMe ? 6.r : 20.r),
                      ),
                      boxShadow: isMe ? themeManager.primaryShadow : themeManager.subtleShadow,
                      border: Border.all(
                        color: isMe ? themeManager.primaryColor.withValues(alpha: 0.3) : themeManager.borderColor,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Message text
                        Text(
                          messageText,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isMe ? Colors.white : themeManager.textPrimary,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        // Message time and status
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Prbal.clock,
                              size: 10.sp,
                              color: isMe ? Colors.white.withValues(alpha: 0.7) : themeManager.textTertiary,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              messageTime,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: isMe ? Colors.white.withValues(alpha: 0.7) : themeManager.textTertiary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (isMe) ...[
                              SizedBox(width: 6.w),
                              Icon(
                                Prbal.check,
                                size: 12.sp,
                                color: themeManager.successColor,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isMe) ...[
            SizedBox(width: 12.w),
            // ========== MY AVATAR ==========
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                gradient: themeManager.successGradient,
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: themeManager.primaryShadow,
              ),
              child: Icon(
                Prbal.user,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ========== MESSAGE INPUT BUILDER ==========
  /// Builds the message input area with enhanced ThemeManager styling
  Widget _buildMessageInput(ThemeManager themeManager) {
    debugPrint('💬 MessagesScreen: Building message input area');

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: themeManager.surfaceGradient,
        border: Border(
          top: BorderSide(
            color: themeManager.borderColor,
            width: 1,
          ),
        ),
        boxShadow: themeManager.elevatedShadow,
      ),
      child: Row(
        children: [
          // ========== ATTACHMENT BUTTON ==========
          Container(
            decoration: BoxDecoration(
              gradient: themeManager.accent4Gradient,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: themeManager.subtleShadow,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: () {
                  debugPrint('💬 MessagesScreen: Attachment button pressed');
                },
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Icon(
                    Prbal.paperclip,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // ========== MESSAGE INPUT FIELD ==========
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: themeManager.backgroundGradient,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: themeManager.borderColor,
                  width: 1,
                ),
                boxShadow: themeManager.subtleShadow,
              ),
              child: TextField(
                controller: _messageController,
                onChanged: (value) {
                  debugPrint('💬 MessagesScreen: Message input changed: "${value.length} characters"');
                },
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(
                    color: themeManager.textTertiary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                style: TextStyle(
                  color: themeManager.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // ========== SEND BUTTON ==========
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              gradient: themeManager.primaryGradient,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: themeManager.primaryShadow,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24.r),
                onTap: () {
                  final messageText = _messageController.text.trim();
                  if (messageText.isNotEmpty) {
                    debugPrint('💬 MessagesScreen: Sending message: "$messageText"');
                    // TODO: Implement actual message sending logic
                    _messageController.clear();
                  } else {
                    debugPrint('💬 MessagesScreen: Empty message, not sending');
                  }
                },
                child: Icon(
                  Prbal.paperPlane,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
