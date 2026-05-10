import '../entities/post.dart';

abstract class FeedRepository {
  Future<List<Post>> getPosts();
  Future<Post> createPost({required String content, String? imageBase64});
  Future<bool> likePost(String postId);
}
