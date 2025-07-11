import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prbal/services/user_service.dart';

// Utils

/// Reusable token card widget for displaying token information
class TokenCardWidget extends StatelessWidget {
  final Map<String, dynamic> token;
  final bool isDark;
  final bool showRevokeOption;
  final VoidCallback? onRevoke;

  const TokenCardWidget({
    super.key,
    required this.token,
    required this.isDark,
    this.showRevokeOption = false,
    this.onRevoke,
  });

  @override
  Widget build(BuildContext context) {
    final jti = token['jti'] as String? ?? 'Unknown';
    final isActive = token['is_active'] as bool? ?? false;
    final createdAt = token['created_at'] as String?;
    final lastUsed = token['last_used'] as String?;
    final deviceInfo = token['device_info'] as Map<String, dynamic>?;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Token status and ID
          Row(
            children: [
              Container(
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF48BB78)
                      : const Color(0xFFE53E3E),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? const Color(0xFF48BB78)
                      : const Color(0xFFE53E3E),
                ),
              ),
              const Spacer(),
              if (showRevokeOption && isActive && onRevoke != null)
                TextButton(
                  onPressed: onRevoke,
                  child: Text(
                    'Revoke',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFFE53E3E),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),

          // Token ID
          Text(
            'Token ID: ${jti.substring(0, 8)}...',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : const Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 8.h),

          // Timestamps
          if (createdAt != null)
            Text(
              'Created: ${formatDateTime(createdAt)}',
              style: TextStyle(
                fontSize: 12.sp,
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
            ),
          if (lastUsed != null) ...[
            SizedBox(height: 4.h),
            Text(
              'Last used: ${formatDateTime(lastUsed)}',
              style: TextStyle(
                fontSize: 12.sp,
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ],

          // Device info
          if (deviceInfo != null) ...[
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF000000) : Colors.grey[100],
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (deviceInfo['ip_address'] != null)
                    Text(
                      'IP: ${deviceInfo['ip_address']}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontFamily: 'monospace',
                        color: isDark ? Colors.white70 : Colors.grey[700],
                      ),
                    ),
                  if (deviceInfo['user_agent'] != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      'Device: ${parseUserAgent(deviceInfo['user_agent'])}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
