import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/post.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_event.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: Colors.grey[900],
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                post.username.isNotEmpty ? post.username[0].toUpperCase() : '?',
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
            title: Text(post.username, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              _timeAgo(post.createdAt),
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
          if (post.imageBase64 != null && post.imageBase64!.isNotEmpty)
            _buildImage(post.imageBase64!)
          else if (post.hasImage)
            Container(
              height: 180,
              color: Colors.grey[850],
              child: const Center(child: Icon(Icons.image, color: Colors.grey, size: 40)),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(post.content, style: const TextStyle(fontSize: 15)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: post.isLiked ? Colors.red[400] : Colors.grey[400],
                  ),
                  onPressed: () => context.read<FeedBloc>().add(LikePostEvent(post.id)),
                ),
                Text('${post.likeCount}', style: TextStyle(color: Colors.grey[400])),
                const SizedBox(width: 16),
                Icon(Icons.chat_bubble_outline, color: Colors.grey[500], size: 20),
                const SizedBox(width: 6),
                Text('${post.commentCount}', style: TextStyle(color: Colors.grey[400])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String base64Str) {
    try {
      // Strip data-URI prefix if present
      final raw = base64Str.contains(',') ? base64Str.split(',').last : base64Str;
      return Image.memory(
        base64Decode(raw),
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const SizedBox(
          height: 80,
          child: Center(child: Icon(Icons.broken_image, color: Colors.grey)),
        ),
      );
    } catch (_) {
      return const SizedBox.shrink();
    }
  }

  String _timeAgo(String isoString) {
    try {
      final dt = DateTime.parse(isoString).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inSeconds < 60) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }
}
