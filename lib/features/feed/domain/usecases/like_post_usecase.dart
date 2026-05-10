import '../repositories/feed_repository.dart';

class LikePostUseCase {
  final FeedRepository repository;

  LikePostUseCase(this.repository);

  Future<bool> call(String postId) => repository.likePost(postId);
}
