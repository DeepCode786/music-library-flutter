import '../models/track_model.dart';
import '../services/api_service.dart';
import '../../core/network/connectivity_service.dart';

class TrackRepository {
  final ApiService _apiService;
  final ConnectivityService _connectivityService;

  TrackRepository({
    required ApiService apiService,
    required ConnectivityService connectivityService,
  })  : _apiService = apiService,
        _connectivityService = connectivityService;

  Future<List<TrackModel>> getTracks(String query, int index, int limit) async {
    await _connectivityService.isConnected();
    try {
      return await _apiService.fetchTracks(query, index, limit);
    } catch (e) {
      throw 'Failed to fetch tracks: $e';
    }
  }
}
