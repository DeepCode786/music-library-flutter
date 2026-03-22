import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/track_model.dart';
import '../blocs/track_detail/track_detail_bloc.dart';
import '../blocs/track_detail/track_detail_event.dart';
import '../blocs/track_detail/track_detail_state.dart';
import '../widgets/offline_banner.dart';

class TrackDetailScreen extends StatelessWidget {
  final TrackModel track;

  const TrackDetailScreen({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrackDetailBloc()..add(LoadTrackDetailEvent(track)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(track.title),
        ),
        body: BlocBuilder<TrackDetailBloc, TrackDetailState>(
          builder: (context, state) {
            if (state is TrackDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TrackDetailLoaded) {
              final track = state.track;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: track.albumCover,
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.grey[800]),
                        errorWidget: (context, url, error) => const Icon(Icons.music_note, size: 100),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Text(
                            track.title,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            track.artistName,
                            style: TextStyle(fontSize: 18, color: Colors.grey[400]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Track ID: ${track.id}',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is TrackDetailError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
