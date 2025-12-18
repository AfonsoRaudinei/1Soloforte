import 'package:flutter/material.dart';
import 'package:soloforte_app/core/theme/app_colors.dart';
import 'package:soloforte_app/core/theme/app_spacing.dart';
import 'package:soloforte_app/core/theme/app_typography.dart';
import 'package:soloforte_app/features/marketing/domain/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class FeedPostCard extends StatefulWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onFollow;
  final bool isMine;
  final VoidCallback? onEdit;

  const FeedPostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onFollow,
    this.isMine = false,
    this.onEdit,
  });

  @override
  State<FeedPostCard> createState() => _FeedPostCardState();
}

class _FeedPostCardState extends State<FeedPostCard> {
  late bool isLiked;
  late int likeCount;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    isLiked = false;
    likeCount = widget.post.likes;
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
    widget.onLike?.call();
  }

  void _toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;
    });
    widget.onFollow?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isMine) {
      return _buildMyPostLayout();
    }
    return _buildFeedLayout(); // Logic from original code or kept separate if needed
  }

  Widget _buildMyPostLayout() {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Image
          if (widget.post.imageUrls.isNotEmpty)
            SizedBox(
              height: 200,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: widget.post.imageUrls.first.startsWith('http')
                    ? Image.network(
                        widget.post.imageUrls.first,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/placeholder_field.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),

          if (widget.post.imageUrls.isNotEmpty)
            const Divider(height: 1, color: Colors.grey),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. Title / Status Line
                if (widget.post.title.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '🌾 ${widget.post.title}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                // 3. Body
                Text(widget.post.content, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 8),

                // 4. Hashtags
                if (widget.post.tags.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    children: widget.post.tags
                        .map(
                          (tag) => Text(
                            tag,
                            style: TextStyle(color: AppColors.primary),
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: 16),

                // 5. Stats
                Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 16,
                      color: isLiked ? Colors.red : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text('$likeCount'), // ❤️ 45
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.chat_bubble_outline,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text('${widget.post.comments}'), // 💬 8
                    const SizedBox(width: 16),
                    const Icon(Icons.share, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    const Text('12'), // Mock share count 📤 12
                  ],
                ),
                const SizedBox(height: 16),

                // 6. Footer (Time | Actions)
                Row(
                  children: [
                    Text(
                      timeago.format(
                        widget.post.createdAt,
                        locale: 'pt_BR',
                      ), // 2 horas atrás
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const Spacer(),
                    Container(
                      height: 30, // constrain height
                      child: TextButton(
                        onPressed: widget.onEdit,
                        child: const Text(
                          '[Editar]',
                        ), // Using brackets as per ASCII
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 30,
                      child: TextButton(
                        onPressed: widget.onShare,
                        child: const Text('[Compartilhar]'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
    );
  }

  Widget _buildFeedLayout() {
    // Original implementation for general feed
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Padding(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: Text(
                    widget.post.authorName[0],
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.authorName,
                        style: AppTypography.label.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        timeago.format(widget.post.createdAt, locale: 'pt_BR'),
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _toggleFollow,
                  child: Text(
                    isFollowing ? 'Seguindo' : 'Seguir',
                    style: TextStyle(
                      color: isFollowing ? Colors.grey : AppColors.primary,
                      fontWeight: isFollowing
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // CONTENT - Image
          if (widget.post.imageUrls.isNotEmpty)
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey[200],
              child: widget.post.imageUrls.first.startsWith('http')
                  ? Image.network(
                      widget.post.imageUrls.first,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/placeholder_field.png',
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    ),
            ),

          // CONTENT - Text
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.post.title.isNotEmpty)
                  Text(widget.post.title, style: AppTypography.h4),
                SizedBox(height: AppSpacing.xs),
                Text(widget.post.content, style: AppTypography.bodyMedium),

                // Tags
                if (widget.post.tags.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Wrap(
                      spacing: 4,
                      children: widget.post.tags
                          .map(
                            (tag) => Text(
                              tag,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),

          const Divider(height: 1),

          // FOOTER
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _InteractionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  label: '$likeCount Curtir',
                  color: isLiked ? Colors.red : Colors.grey,
                  onTap: _toggleLike,
                ),
                _InteractionButton(
                  icon: Icons.comment_outlined,
                  label: '${widget.post.comments} Coment.',
                  onTap: widget.onComment,
                ),
                _InteractionButton(
                  icon: Icons.share_outlined,
                  label: 'Compartilhar',
                  onTap: widget.onShare,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xs),
        ],
      ),
    );
  }
} // End State

class _InteractionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color color;

  const _InteractionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
