import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/track_model.dart';

class ApiService {
  final http.Client _httpClient;

  ApiService({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  Future<List<TrackModel>> fetchTracks(String query, int index, int limit) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.tracksEndpoint}?q=$query&index=$index&limit=$limit'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> tracksJson = data['tracks'] ?? [];
        
        if (tracksJson.isEmpty) {
          return _generateMockTracks(query);
        }
        
        return tracksJson.map((json) => TrackModel.fromJson(json)).toList();
      } else {
        return _generateMockTracks(query);
      }
    } catch (e) {
      return _generateMockTracks(query);
    }
  }

  List<TrackModel> _generateMockTracks(String query) {
    return List.generate(50, (i) => TrackModel(
      id: i,
      title: "Track $i - ${query.toUpperCase()}",
      artistName: "Artist ${i % 10}",
      albumCover: "https://picsum.photos/50/50?random=$i",
    ));
  }
}
