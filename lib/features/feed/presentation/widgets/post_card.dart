import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Colors.grey[900],
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(post.authorName[0], style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
            ),
            title: Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(post.location, style: TextStyle(color: Colors.grey[400])),
            trailing: const Icon(Icons.more_vert, color: Colors.grey),
          ),
          CachedNetworkImage(
            imageUrl: post.imageUrl,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => SizedBox(
              height: 250,
              child: Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
            ),
            errorWidget: (context, url, error) => const SizedBox(
              height: 250,
              child: Center(child: Icon(Icons.error, color: Colors.red)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(post.description),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {},
                ),
                Text('${post.likes}'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  color: Colors.grey,
                  onPressed: () {},
                ),
                Text('${post.comments}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
