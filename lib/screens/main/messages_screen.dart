import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/utils/icon/prbal_icons.dart';
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

class _MessagesScreenState extends ConsumerState<MessagesScreen>
    with TickerProviderStateMixin {
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
      'avatar':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'isOnline': true,
    },
    {
      'id': '2',
      'name': 'Sarah Johnson',
      'lastMessage': 'When can you start the project?',
      'time': '15 min ago',
      'unread': 0,
      'avatar':
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150',
      'isOnline': true,
    },
    {
      'id': '3',
      'name': 'Tech Solutions',
      'lastMessage': 'Your device is ready for pickup',
      'time': '1 hour ago',
      'unread': 1,
      'avatar':
          'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=150',
      'isOnline': false,
    },
    {
      'id': '4',
      'name': 'Emily Davis',
      'lastMessage': 'Perfect timing, see you tomorrow',
      'time': '3 hours ago',
      'unread': 0,
      'avatar':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
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
      'text':
          'Hello! I\'d be happy to help. What type of cleaning do you need?',
      'isMe': true,
      'time': '10:32 AM',
      'timestamp':
          DateTime.now().subtract(const Duration(hours: 2, minutes: -2)),
    },
    {
      'id': '3',
      'text':
          'I need a deep clean for my 3-bedroom apartment. When are you available?',
      'isMe': false,
      'time': '10:35 AM',
      'timestamp':
          DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
    },
    {
      'id': '4',
      'text':
          'I can do it this weekend. The rate would be \$150 for deep cleaning',
      'isMe': true,
      'time': '10:37 AM',
      'timestamp':
          DateTime.now().subtract(const Duration(hours: 1, minutes: 53)),
    },
    {
      'id': '5',
      'text': 'That sounds perfect! Can we schedule for Saturday morning?',
      'isMe': false,
      'time': '10:40 AM',
      'timestamp':
          DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: _buildAppBar(isDark),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _isInChat
            ? _buildChatView(isDark)
            : _buildConversationsView(isDark),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      elevation: 0,
      leading: _isInChat
          ? IconButton(
              icon: Icon(
                Prbal.arrowLeft,
                color: isDark ? Colors.white : const Color(0xFF1F2937),
              ),
              onPressed: () {
                setState(() {
                  _isInChat = false;
                });
              },
            )
          : IconButton(
              icon: Icon(
                Prbal.arrowLeft,
                color: isDark ? Colors.white : const Color(0xFF1F2937),
              ),
              onPressed: () => context.pop(),
            ),
      title: _isInChat
          ? Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: const Color(0xFF3B82F6),
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
                                size: 20.sp),
                          ),
                        )
                      : Icon(Prbal.user, color: Colors.white, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.conversationName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color:
                              isDark ? Colors.white : const Color(0xFF1F2937),
                        ),
                      ),
                      Text(
                        'Online',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF10B981),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Text(
              'Messages',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
      actions: [
        if (_isInChat) ...[
          IconButton(
            icon: Icon(
              Prbal.phone,
              color: isDark ? Colors.white70 : const Color(0xFF6B7280),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Prbal.video,
              color: isDark ? Colors.white70 : const Color(0xFF6B7280),
            ),
            onPressed: () {},
          ),
        ] else ...[
          IconButton(
            icon: Icon(
              Prbal.plus,
              color: isDark ? Colors.white70 : const Color(0xFF6B7280),
            ),
            onPressed: () {},
          ),
        ],
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildConversationsView(bool isDark) {
    return Column(
      children: [
        // Search bar
        Container(
          margin: EdgeInsets.all(16.w),
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
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search conversations...',
              hintStyle: TextStyle(
                color:
                    isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
                fontSize: 14.sp,
              ),
              prefixIcon: Icon(
                Prbal.search,
                color:
                    isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
                size: 20.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1F2937),
              fontSize: 14.sp,
            ),
          ),
        ),

        // Conversations list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: _conversations.length,
            itemBuilder: (context, index) {
              final conversation = _conversations[index];
              return _buildConversationItem(conversation, isDark);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConversationItem(
      Map<String, dynamic> conversation, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
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
          onTap: () {
            setState(() {
              _isInChat = true;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Avatar
                Stack(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.r),
                        color: const Color(0xFF3B82F6),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25.r),
                        child: Image.network(
                          conversation['avatar'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                              Prbal.user,
                              color: Colors.white,
                              size: 24.sp),
                        ),
                      ),
                    ),
                    if (conversation['isOnline'])
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 12.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(width: 12.w),

                // Conversation details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            conversation['name'],
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1F2937),
                            ),
                          ),
                          Text(
                            conversation['time'],
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isDark
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation['lastMessage'],
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF6B7280),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (conversation['unread'] > 0)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                conversation['unread'].toString(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
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
          ),
        ),
      ),
    );
  }

  Widget _buildChatView(bool isDark) {
    return Column(
      children: [
        // Messages list
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(16.w),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return _buildMessageBubble(message, isDark);
            },
          ),
        ),

        // Message input
        _buildMessageInput(isDark),
      ],
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isDark) {
    final isMe = message['isMe'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Prbal.user,
                color: Colors.white,
                size: 16.sp,
              ),
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isMe
                    ? const Color(0xFF3B82F6)
                    : (isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFF3F4F6)),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.r),
                  topRight: Radius.circular(18.r),
                  bottomLeft: Radius.circular(isMe ? 18.r : 4.r),
                  bottomRight: Radius.circular(isMe ? 4.r : 18.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['text'],
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isMe
                          ? Colors.white
                          : (isDark ? Colors.white : const Color(0xFF1F2937)),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    message['time'],
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: isMe
                          ? Colors.white70
                          : (isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF6B7280)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            SizedBox(width: 8.w),
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Prbal.user,
                color: Colors.white,
                size: 16.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput(bool isDark) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Prbal.paperclip,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
            ),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF374151) : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF9CA3AF),
                    fontSize: 14.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                  fontSize: 14.sp,
                ),
                maxLines: null,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(22.r),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(22.r),
                onTap: () {
                  if (_messageController.text.trim().isNotEmpty) {
                    // Send message logic here
                    _messageController.clear();
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
