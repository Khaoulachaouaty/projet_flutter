import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../models/user.dart';


class NotificationItem extends StatelessWidget {
  final String userName;
  final String? userAvatar;
  final String action;
  final String time;
  final bool isRead;
  final VoidCallback? onTap;

  const NotificationItem({
    super.key,
    required this.userName,
    this.userAvatar,
    required this.action,
    required this.time,
    this.isRead = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: UserAvatar(
        imageUrl: userAvatar,
        name: userName,
        showBorder: !isRead,
      ),
      title: RichText(
        text: TextSpan(
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          children: [
            TextSpan(
              text: userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' $action'),
          ],
        ),
      ),
      subtitle: Text(
        time,
        style: TextStyle(
          fontSize: 12,
          color: isRead ? AppColors.textSecondary : AppColors.primary,
          fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
        ),
      ),
      trailing: !isRead
          ? Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}