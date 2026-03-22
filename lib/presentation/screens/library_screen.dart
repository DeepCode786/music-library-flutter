import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/library/library_bloc.dart';
import '../blocs/library/library_event.dart';
import '../blocs/library/library_state.dart';
import '../widgets/track_list_item.dart';
import '../widgets/offline_banner.dart';
import 'track_detail_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      context.read<LibraryBloc>().add(LoadMoreTracksEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Library'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                context.read<LibraryBloc>().add(SearchTracksEvent(value));
              },
              decoration: InputDecoration(
                hintText: 'Search tracks or artists...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, state) {
          if (state is LibraryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LibraryOffline) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'NO INTERNET CONNECTION',
                    style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<LibraryBloc>().add(LoadTracksEvent()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is LibraryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<LibraryBloc>().add(LoadTracksEvent()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is LibraryLoaded) {
            final groupedTracks = state.groupedTracks;
            final sections = groupedTracks.keys.toList();

            return Column(
              children: [
                if (state.isOffline) const OfflineBanner(),
                Expanded(
                  child: sections.isEmpty
                      ? const Center(child: Text('No tracks found.'))
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: sections.length,
                          itemBuilder: (context, index) {
                            final section = sections[index];
                            final tracks = groupedTracks[section]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: Colors.grey[900],
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text(
                                    section,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                                ...tracks.map((track) => TrackListItem(
                                      track: track,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TrackDetailScreen(track: track),
                                          ),
                                        );
                                      },
                                    )),
                              ],
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const Center(child: Text('Start exploring music!'));
        },
      ),
    );
  }
}
