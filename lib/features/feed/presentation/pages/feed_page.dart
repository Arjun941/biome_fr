import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_event.dart';
import '../bloc/feed_state.dart';
import '../widgets/post_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FeedBloc>().add(LoadFeed());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search posts...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
              onPressed: () => context.read<FeedBloc>().add(SearchFeed(_searchController.text)),
            ),
          ),
          style: const TextStyle(color: Colors.white),
          onSubmitted: (v) => context.read<FeedBloc>().add(SearchFeed(v)),
        ),
      ),
      body: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          if (state is FeedLoading) {
            return Center(
              child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
            );
          }

          if (state is PostCreating) {
            return Stack(
              children: [
                _buildList(state.posts, context),
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(),
                ),
              ],
            );
          }

          if (state is FeedLoaded) {
            if (state.posts.isEmpty) {
              return const Center(child: Text('No posts yet. Be the first to share a sighting!'));
            }
            return _buildList(state.posts, context);
          }

          if (state is FeedError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<FeedBloc>().add(LoadFeed()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create-post'),
        tooltip: 'New Post',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildList(List posts, BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Colors.black,
      onRefresh: () async => context.read<FeedBloc>().add(LoadFeed()),
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) => PostCard(post: posts[index]),
      ),
    );
  }
}
