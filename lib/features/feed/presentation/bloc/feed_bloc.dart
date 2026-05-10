import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/post.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/usecases/create_post_usecase.dart';
import '../../domain/usecases/like_post_usecase.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetPostsUseCase getPostsUseCase;
  final CreatePostUseCase createPostUseCase;
  final LikePostUseCase likePostUseCase;

  FeedBloc({
    required this.getPostsUseCase,
    required this.createPostUseCase,
    required this.likePostUseCase,
  }) : super(FeedInitial()) {
    on<LoadFeed>(_onLoadFeed);
    on<SearchFeed>(_onSearchFeed);
    on<CreatePostEvent>(_onCreatePost);
    on<LikePostEvent>(_onLikePost);
  }

  Future<void> _onLoadFeed(LoadFeed event, Emitter<FeedState> emit) async {
    emit(FeedLoading());
    try {
      final posts = await getPostsUseCase();
      emit(FeedLoaded(posts));
    } catch (e) {
      emit(FeedError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onSearchFeed(SearchFeed event, Emitter<FeedState> emit) async {
    emit(FeedLoading());
    try {
      final all = await getPostsUseCase();
      final q = event.query.toLowerCase();
      final filtered = q.isEmpty
          ? all
          : all
              .where((p) =>
                  p.content.toLowerCase().contains(q) ||
                  p.username.toLowerCase().contains(q))
              .toList();
      emit(FeedLoaded(filtered));
    } catch (e) {
      emit(FeedError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onCreatePost(CreatePostEvent event, Emitter<FeedState> emit) async {
    final currentPosts = state is FeedLoaded
        ? (state as FeedLoaded).posts
        : <Post>[];
    emit(PostCreating(currentPosts));
    try {
      final newPost = await createPostUseCase(
        content: event.content,
        imageBase64: event.imageBase64,
      );
      emit(FeedLoaded([newPost, ...currentPosts]));
    } catch (e) {
      emit(FeedError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLikePost(LikePostEvent event, Emitter<FeedState> emit) async {
    if (state is! FeedLoaded) return;
    final currentPosts = (state as FeedLoaded).posts;

    // Optimistic update
    final optimistic = currentPosts.map((p) {
      if (p.id != event.postId) return p;
      final nowLiked = !p.isLiked;
      return p.copyWith(
        isLiked: nowLiked,
        likeCount: nowLiked ? p.likeCount + 1 : p.likeCount - 1,
      );
    }).toList();
    emit(FeedLoaded(optimistic));

    try {
      await likePostUseCase(event.postId);
    } catch (_) {
      // Revert on network failure
      emit(FeedLoaded(currentPosts));
    }
  }
}
