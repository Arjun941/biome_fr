import '../../domain/entities/sighting_marker.dart';

class MapRemoteDataSource {
  Future<List<SightingMarker>> getMarkers() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    return const [
      SightingMarker(
        id: '1',
        latitude: 37.7749,
        longitude: -122.4194,
        title: 'Red Fox Sighting',
        snippet: 'Seen near the park',
      ),
      SightingMarker(
        id: '2',
        latitude: 37.7849,
        longitude: -122.4094,
        title: 'Raccoon',
        snippet: 'Spotted in the alley',
      ),
      SightingMarker(
        id: '3',
        latitude: 37.7649,
        longitude: -122.4294,
        title: 'Coyote',
        snippet: 'Running across the road',
      ),
    ];
  }
}
