import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class LoadFeed extends FeedEvent {}

class SearchFeed extends FeedEvent {
  final String query;

  const SearchFeed(this.query);

  @override
  List<Object> get props => [query];
}
