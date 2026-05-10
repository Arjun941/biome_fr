import '../../domain/entities/post.dart';

class FeedRemoteDataSource {
  Future<List<Post>> getPosts() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    return const [
      Post(
        id: '1',
        authorName: 'Jane Doe',
        location: 'San Francisco, CA',
        imageUrl: 'https://images.unsplash.com/photo-1516934024742-b461fba47600?auto=format&fit=crop&w=600&q=80',
        description: 'Just saw this beautiful red fox in the park!',
        likes: 120,
        comments: 15,
      ),
      Post(
        id: '2',
        authorName: 'John Smith',
        location: 'Yellowstone National Park',
        imageUrl: 'https://images.unsplash.com/photo-1549471013-3364d7ce79ea?auto=format&fit=crop&w=600&q=80',
        description: 'A majestic eagle flying high.',
        likes: 85,
        comments: 4,
      ),
      Post(
        id: '3',
        authorName: 'Emily Clark',
        location: 'Central Park, NY',
        imageUrl: 'https://images.unsplash.com/photo-1502673530728-f79b4cab31b1?auto=format&fit=crop&w=600&q=80',
        description: 'Found this cute raccoon foraging near the bushes.',
        likes: 230,
        comments: 42,
      ),
    ];
  }
}
