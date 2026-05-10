import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            hintText: 'Search by location...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
              onPressed: () {
                context.read<FeedBloc>().add(SearchFeed(_searchController.text));
              },
            ),
          ),
          style: const TextStyle(color: Colors.white),
          onSubmitted: (value) {
            context.read<FeedBloc>().add(SearchFeed(value));
          },
        ),
      ),
      body: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          if (state is FeedLoading) {
            return Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary));
          } else if (state is FeedLoaded) {
            if (state.posts.isEmpty) {
              return const Center(child: Text('No sightings found.'));
            }
            return RefreshIndicator(
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: Colors.black,
              onRefresh: () async {
                context.read<FeedBloc>().add(LoadFeed());
              },
              child: ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  return PostCard(post: state.posts[index]);
                },
              ),
            );
          } else if (state is FeedError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const Center(child: Text('Welcome to Biome Feed'));
        },
      ),
    );
  }
}
