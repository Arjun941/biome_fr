import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadFeed extends FeedEvent {}

class SearchFeed extends FeedEvent {
  final String query;

  const SearchFeed(this.query);

  @override
  List<Object?> get props => [query];
}

class CreatePostEvent extends FeedEvent {
  final String content;
  final String? imageBase64;

  const CreatePostEvent({required this.content, this.imageBase64});

  @override
  List<Object?> get props => [content, imageBase64];
}

class LikePostEvent extends FeedEvent {
  final String postId;

  const LikePostEvent(this.postId);

  @override
  List<Object?> get props => [postId];
}
