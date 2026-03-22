import 'package:equatable/equatable.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object?> get props => [];
}

class LoadTracksEvent extends LibraryEvent {}

class LoadMoreTracksEvent extends LibraryEvent {}

class SearchTracksEvent extends LibraryEvent {
  final String query;
  const SearchTracksEvent(this.query);

  @override
  List<Object?> get props => [query];
}
