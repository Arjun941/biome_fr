import '../entities/post.dart';
import '../repositories/feed_repository.dart';

class GetPostsUseCase {
  final FeedRepository repository;

  GetPostsUseCase(this.repository);

  Future<List<Post>> call() {
    return repository.getPosts();
  }
}
