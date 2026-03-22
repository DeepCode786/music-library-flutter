import 'package:equatable/equatable.dart';
import '../../../data/models/track_model.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object?> get props => [];
}

class LibraryInitial extends LibraryState {}

class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final List<TrackModel> tracks;
  final Map<String, List<TrackModel>> groupedTracks;
  final bool hasMore;
  final String currentQuery;
  final bool isOffline;

  const LibraryLoaded({
    required this.tracks,
    required this.groupedTracks,
    required this.hasMore,
    required this.currentQuery,
    this.isOffline = false,
  });

  @override
  List<Object?> get props => [tracks, groupedTracks, hasMore, currentQuery, isOffline];

  LibraryLoaded copyWith({
    List<TrackModel>? tracks,
    Map<String, List<TrackModel>>? groupedTracks,
    bool? hasMore,
    String? currentQuery,
    bool? isOffline,
  }) {
    return LibraryLoaded(
      tracks: tracks ?? this.tracks,
      groupedTracks: groupedTracks ?? this.groupedTracks,
      hasMore: hasMore ?? this.hasMore,
      currentQuery: currentQuery ?? this.currentQuery,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

class LibraryError extends LibraryState {
  final String message;
  const LibraryError(this.message);

  @override
  List<Object?> get props => [message];
}

class LibraryOffline extends LibraryState {}
