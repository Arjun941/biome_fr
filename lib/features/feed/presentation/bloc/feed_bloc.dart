import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetPostsUseCase getPostsUseCase;

  FeedBloc({required this.getPostsUseCase}) : super(FeedInitial()) {
    on<LoadFeed>((event, emit) async {
      emit(FeedLoading());
      try {
        final posts = await getPostsUseCase();
        emit(FeedLoaded(posts));
      } catch (e) {
        emit(FeedError(e.toString()));
      }
    });

    on<SearchFeed>((event, emit) async {
      emit(FeedLoading());
      try {
        final allPosts = await getPostsUseCase();
        final filteredPosts = allPosts.where((post) => 
            post.location.toLowerCase().contains(event.query.toLowerCase()) ||
            post.description.toLowerCase().contains(event.query.toLowerCase())
        ).toList();
        emit(FeedLoaded(filteredPosts));
      } catch (e) {
        emit(FeedError(e.toString()));
      }
    });
  }
}
