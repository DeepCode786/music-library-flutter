import 'package:equatable/equatable.dart';

class TrackModel extends Equatable {
  final int id;
  final String title;
  final String artistName;
  final String albumCover;

  const TrackModel({
    required this.id,
    required this.title,
    required this.artistName,
    required this.albumCover,
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    return TrackModel(
      id: json['id'] as int,
      title: json['title'] as String,
      artistName: (json['artist'] as Map<String, dynamic>)['name'] as String,
      albumCover: (json['album'] as Map<String, dynamic>)['cover_small'] as String,
    );
  }

  @override
  List<Object?> get props => [id, title, artistName, albumCover];
}
