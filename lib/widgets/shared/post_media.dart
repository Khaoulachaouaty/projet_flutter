import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../colors.dart';
import '../../models/post.dart';

class PostMedia extends StatefulWidget {
  final PostModel post;
  final VoidCallback? onDownload;

  const PostMedia({
    super.key,
    required this.post,
    this.onDownload,
  });

  @override
  State<PostMedia> createState() => _PostMediaState();
}

class _PostMediaState extends State<PostMedia> {
 // VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.post.type == PostType.video && widget.post.mediaUrls.isNotEmpty) {
      _videoController = VideoPlayerController.network(widget.post.mediaUrls.first)
        ..initialize().then((_) => setState(() {}));
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post.mediaUrls.isEmpty) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          _buildMediaContent(),
          Positioned(
            top: 8,
            right: 8,
            child: _buildDownloadButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaContent() {
    switch (widget.post.type) {
      case PostType.image:
        return _buildImageGallery();
      case PostType.video:
        return _buildVideoPlayer();
      case PostType.pdf:
        return _buildPdfPreview();
      default:
        return _buildMixedContent();
    }
  }

  Widget _buildImageGallery() {
    if (widget.post.mediaUrls.length == 1) {
      return Image.network(
        widget.post.mediaUrls.first,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: widget.post.mediaUrls.length,
        itemBuilder: (context, index) {
          return Image.network(
            widget.post.mediaUrls[index],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_videoController?.value.isInitialized ?? false) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    }
    return Container(
      height: 200,
      color: AppColors.grey100,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildPdfPreview() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            ),
            child: const Icon(Icons.picture_as_pdf, color: AppColors.error, size: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Document PDF',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.post.mediaUrls.length} fichier(s)',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMixedContent() {
    return Column(
      children: widget.post.mediaUrls.map((url) {
        if (url.endsWith('.pdf')) return _buildPdfPreview();
        if (url.endsWith('.mp4')) return _buildVideoPlayer();
        return Image.network(url, fit: BoxFit.cover);
      }).toList(),
    );
  }

  Widget _buildDownloadButton() {
    return GestureDetector(
      onTap: widget.onDownload,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.download, color: Colors.white, size: 20),
      ),
    );
  }
}