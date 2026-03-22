import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/track_model.dart';

class TrackListItem extends StatelessWidget {
  final TrackModel track;
  final VoidCallback onTap;

  const TrackListItem({
    super.key,
    required this.track,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CachedNetworkImage(
        imageUrl: track.albumCover,
        width: 50,
        height: 50,
        placeholder: (context, url) => Container(color: Colors.grey[800]),
        errorWidget: (context, url, error) => const Icon(Icons.music_note),
      ),
      title: Text(
        track.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        track.artistName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        'ID: ${track.id}',
        style: TextStyle(color: Colors.grey[500], fontSize: 12),
      ),
    );
  }
}
