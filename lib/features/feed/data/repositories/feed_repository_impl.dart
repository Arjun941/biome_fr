import '../../domain/entities/post.dart';
import '../../domain/repositories/feed_repository.dart';
import '../datasources/feed_remote_data_source.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource remoteDataSource;

  FeedRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Post>> getPosts() => remoteDataSource.getPosts();

  @override
  Future<Post> createPost({required String content, String? imageBase64}) =>
      remoteDataSource.createPost(content: content, imageBase64: imageBase64);

  @override
  Future<bool> likePost(String postId) => remoteDataSource.likePost(postId);
}
