import '../entities/sighting_marker.dart';

abstract class MapRepository {
  Future<List<SightingMarker>> getMarkers();
}
