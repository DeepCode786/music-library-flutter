import 'package:equatable/equatable.dart';
import '../../../data/models/track_model.dart';

abstract class TrackDetailEvent extends Equatable {
  const TrackDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadTrackDetailEvent extends TrackDetailEvent {
  final TrackModel track;
  const LoadTrackDetailEvent(this.track);

  @override
  List<Object?> get props => [track];
}
