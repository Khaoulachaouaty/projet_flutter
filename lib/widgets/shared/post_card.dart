import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../models/post.dart';
import '../../models/user.dart';
import 'post_media.dart';
import 'post_actions.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final VoidCallback? onUserTap;
  final Function(PostModel) onUpdate;

  const PostCard({
    super.key,
    required this.post,
    this.onUserTap,
    required this.onUpdate,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late PostModel _post;
  bool _showComments = false;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  void _toggleLike() {
    setState(() {
      _post = _post.copyWith(
        isLiked: !_post.isLiked,
        likes: _post.isLiked ? _post.likes - 1 : _post.likes + 1,
      );
    });
    widget.onUpdate(_post);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            Text(_post.content, style: const TextStyle(fontSize: 15)),
            if (_post.mediaUrls.isNotEmpty) ...[
              const SizedBox(height: 12),
              PostMedia(
                post: _post,
                onDownload: () => _downloadMedia(),
              ),
            ],
            const SizedBox(height: 12),
            PostActions(
              post: _post,
              onLike: _toggleLike,
              onComment: () => setState(() => _showComments = !_showComments),
              onShare: () {},
              onSave: () {
                setState(() => _post = _post.copyWith(isSaved: !_post.isSaved));
                widget.onUpdate(_post);
              },
            ),
            if (_showComments) _buildCommentsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        UserAvatar(
          imageUrl: _post.userAvatar,
          name: _post.userName,
          onTap: widget.onUserTap,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _post.userName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                _formatTime(_post.createdAt),
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildCommentsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildCommentInput(),
          const SizedBox(height: 8),
          // Liste des commentaires simulée
          ...List.generate(2, (index) => _buildCommentItem()),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Row(
      children: [
        const UserAvatar(name: 'Moi', size: 32),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Ajouter un commentaire...',
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UserAvatar(name: 'User', size: 32),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jean Dupont', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  SizedBox(height: 4),
                  Text('Super publication ! 👍', style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}j';
  }

  void _downloadMedia() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Téléchargement démarré...')),
    );
  }
}