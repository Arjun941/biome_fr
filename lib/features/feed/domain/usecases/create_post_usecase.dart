import '../entities/post.dart';
import '../repositories/feed_repository.dart';

class CreatePostUseCase {
  final FeedRepository repository;

  CreatePostUseCase(this.repository);

  Future<Post> call({required String content, String? imageBase64}) =>
      repository.createPost(content: content, imageBase64: imageBase64);
}
