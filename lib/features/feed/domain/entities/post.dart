import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String userId;
  final String username;
  final String content;
  final String? imageBase64;
  final bool hasImage;
  final int likeCount;
  final int commentCount;
  final String createdAt;
  final bool isLiked;

  const Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.content,
    this.imageBase64,
    this.hasImage = false,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    this.isLiked = false,
  });

  Post copyWith({
    String? id,
    String? userId,
    String? username,
    String? content,
    String? imageBase64,
    bool? hasImage,
    int? likeCount,
    int? commentCount,
    String? createdAt,
    bool? isLiked,
  }) =>
      Post(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        username: username ?? this.username,
        content: content ?? this.content,
        imageBase64: imageBase64 ?? this.imageBase64,
        hasImage: hasImage ?? this.hasImage,
        likeCount: likeCount ?? this.likeCount,
        commentCount: commentCount ?? this.commentCount,
        createdAt: createdAt ?? this.createdAt,
        isLiked: isLiked ?? this.isLiked,
      );

  @override
  List<Object?> get props => [id, userId, username, content, likeCount, commentCount, createdAt, isLiked];
}
