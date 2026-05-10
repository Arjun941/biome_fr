import 'dart:convert';
import '../../domain/entities/post.dart';
import '../models/post_model.dart';
import '../../../../core/network/api_client.dart';

class FeedRemoteDataSource {
  final ApiClient apiClient;

  FeedRemoteDataSource(this.apiClient);

  Future<List<Post>> getPosts() async {
    final response = await apiClient.get('/posts/feed');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items = data['data'] as List<dynamic>? ?? [];
      return items
          .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to load feed (${response.statusCode})');
  }

  Future<Post> createPost({required String content, String? imageBase64}) async {
    final body = <String, dynamic>{'content': content};
    if (imageBase64 != null) body['image_base64'] = imageBase64;

    final response = await apiClient.post('/posts', body);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 201) {
      return PostModel.fromJson(data['post'] as Map<String, dynamic>);
    }
    throw Exception(data['error'] ?? 'Failed to create post');
  }

  Future<bool> likePost(String postId) async {
    final response = await apiClient.post('/posts/$postId/like', {});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['liked'] == true;
    }
    throw Exception('Failed to toggle like (${response.statusCode})');
  }
}
