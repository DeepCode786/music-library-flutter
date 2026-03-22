import 'package:equatable/equatable.dart';
import '../../../data/models/track_model.dart';

abstract class TrackDetailState extends Equatable {
  const TrackDetailState();

  @override
  List<Object?> get props => [];
}

class TrackDetailInitial extends TrackDetailState {}

class TrackDetailLoading extends TrackDetailState {}

class TrackDetailLoaded extends TrackDetailState {
  final TrackModel track;
  const TrackDetailLoaded(this.track);
// fsdfsdfsdf
  @override
  List<Object?> get props => [track];
}

class TrackDetailError extends TrackDetailState {
  final String message;
  const TrackDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
