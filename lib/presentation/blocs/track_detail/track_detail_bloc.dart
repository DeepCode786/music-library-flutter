import 'package:flutter_bloc/flutter_bloc.dart';
import 'track_detail_event.dart';
import 'track_detail_state.dart';

class TrackDetailBloc extends Bloc<TrackDetailEvent, TrackDetailState> {
  TrackDetailBloc() : super(TrackDetailInitial()) {
    on<LoadTrackDetailEvent>((event, emit) {
      emit(TrackDetailLoading());
      emit(TrackDetailLoaded(event.track));
    });
  }
}
