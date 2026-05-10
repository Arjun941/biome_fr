import '../entities/sighting_marker.dart';
import '../repositories/map_repository.dart';

class GetMarkersUseCase {
  final MapRepository repository;

  GetMarkersUseCase(this.repository);

  Future<List<SightingMarker>> call() {
    return repository.getMarkers();
  }
}
