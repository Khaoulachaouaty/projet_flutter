import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../models/post.dart';

class PostActions extends StatelessWidget {
  final PostModel post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onSave;

  const PostActions({
    super.key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionButton(
          icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
          count: post.likes,
          color: post.isLiked ? AppColors.error : AppColors.textSecondary,
          onTap: onLike,
        ),
        _ActionButton(
          icon: Icons.chat_bubble_outline,
          count: post.comments,
          onTap: onComment,
        ),
        _ActionButton(
          icon: Icons.share_outlined,
          count: post.shares,
          onTap: onShare,
        ),
        const Spacer(),
        IconButton(
          icon: Icon(
            post.isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: post.isSaved ? AppColors.primary : AppColors.textSecondary,
          ),
          onPressed: onSave,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color? color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.count,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 22, color: color ?? AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                _formatCount(count),
                style: TextStyle(
                  fontSize: 13,
                  color: color ?? AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }
}