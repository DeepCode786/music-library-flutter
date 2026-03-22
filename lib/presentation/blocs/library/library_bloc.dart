import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../../data/models/track_model.dart';
import '../../../data/repositories/track_repository.dart';
import 'library_event.dart';
import 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final TrackRepository _trackRepository;
  final List<String> _alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');
  int _currentAlphabetIndex = 0;
  int _currentIndex = 0;
  final int _limit = 50;
  bool _isFetching = false;

  LibraryBloc({required TrackRepository trackRepository})
      : _trackRepository = trackRepository,
        super(LibraryInitial()) {
    on<LoadTracksEvent>(_onLoadTracks);
    on<LoadMoreTracksEvent>(_onLoadMoreTracks);
    on<SearchTracksEvent>(_onSearchTracks);
  }

  Future<void> _onLoadTracks(LoadTracksEvent event, Emitter<LibraryState> emit) async {
    emit(LibraryLoading());
    _currentAlphabetIndex = 0;
    _currentIndex = 0;
    try {
      final tracks = await _trackRepository.getTracks(_alphabet[_currentAlphabetIndex], _currentIndex, _limit);
      final grouped = _groupTracks(tracks);
      emit(LibraryLoaded(
        tracks: tracks,
        groupedTracks: grouped,
        hasMore: true,
        currentQuery: '',
      ));
    } catch (e) {
      if (e.toString().toUpperCase().contains('NO INTERNET CONNECTION')) {
        emit(LibraryOffline());
      } else {
        emit(LibraryError(e.toString()));
      }
    }
  }

  Future<void> _onLoadMoreTracks(LoadMoreTracksEvent event, Emitter<LibraryState> emit) async {
    if (state is! LibraryLoaded || _isFetching) return;
    final currentState = state as LibraryLoaded;
    if (currentState.currentQuery.isNotEmpty) return;

    _isFetching = true;
    try {
      _currentIndex += _limit;
      List<TrackModel> newTracks = await _trackRepository.getTracks(
        _alphabet[_currentAlphabetIndex],
        _currentIndex,
        _limit,
      );

      if (newTracks.isEmpty && _currentAlphabetIndex < _alphabet.length - 1) {
        _currentAlphabetIndex++;
        _currentIndex = 0;
        newTracks = await _trackRepository.getTracks(
          _alphabet[_currentAlphabetIndex],
          _currentIndex,
          _limit,
        );
      }

      final allTracks = List<TrackModel>.from(currentState.tracks)..addAll(newTracks);
      emit(currentState.copyWith(
        tracks: allTracks,
        groupedTracks: _groupTracks(allTracks),
        hasMore: _currentAlphabetIndex < _alphabet.length - 1 || newTracks.isNotEmpty,
        isOffline: false,
      ));
    } catch (e) {
      if (e.toString().toUpperCase().contains('NO INTERNET CONNECTION')) {
        emit(currentState.copyWith(isOffline: true));
      }
    } finally {
      _isFetching = false;
    }
  }

  void _onSearchTracks(SearchTracksEvent event, Emitter<LibraryState> emit) {
    if (state is! LibraryLoaded) return;
    final currentState = state as LibraryLoaded;

    if (event.query.isEmpty) {
      emit(currentState.copyWith(
        groupedTracks: _groupTracks(currentState.tracks),
        currentQuery: '',
      ));
      return;
    }

    final filteredTracks = currentState.tracks.where((track) {
      return track.title.toLowerCase().contains(event.query.toLowerCase()) ||
          track.artistName.toLowerCase().contains(event.query.toLowerCase());
    }).toList();

    emit(currentState.copyWith(
      groupedTracks: _groupTracks(filteredTracks),
      currentQuery: event.query,
    ));
  }

  Map<String, List<TrackModel>> _groupTracks(List<TrackModel> tracks) {
    final Map<String, List<TrackModel>> grouped = {};
    for (var track in tracks) {
      final firstLetter = track.title.isEmpty ? '#' : track.title[0].toUpperCase();
      final key = RegExp(r'[A-Z]').hasMatch(firstLetter) ? firstLetter : '#';
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(track);
    }
    final sortedKeys = grouped.keys.toList()..sort();
    final Map<String, List<TrackModel>> sortedGrouped = {};
    for (var key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }
    return sortedGrouped;
  }
}
