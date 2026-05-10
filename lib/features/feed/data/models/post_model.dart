import '../../domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.userId,
    required super.username,
    required super.content,
    super.imageBase64,
    super.hasImage,
    required super.likeCount,
    required super.commentCount,
    required super.createdAt,
    super.isLiked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: (json['_id'] ?? '').toString(),
      userId: (json['user_id'] ?? '').toString(),
      username: (json['username'] ?? 'Unknown').toString(),
      content: (json['content'] ?? '').toString(),
      imageBase64: json['image_base64'] as String?,
      hasImage: json['has_image'] == true,
      likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
      commentCount: (json['comment_count'] as num?)?.toInt() ?? 0,
      createdAt: (json['created_at'] ?? '').toString(),
    );
  }
}
