import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String authorName;
  final String location;
  final String imageUrl;
  final String description;
  final int likes;
  final int comments;

  const Post({
    required this.id,
    required this.authorName,
    required this.location,
    required this.imageUrl,
    required this.description,
    required this.likes,
    required this.comments,
  });

  @override
  List<Object> get props => [id, authorName, location, imageUrl, description, likes, comments];
}
