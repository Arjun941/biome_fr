import '../../domain/entities/sighting_marker.dart';
import '../../domain/repositories/map_repository.dart';
import '../datasources/map_remote_data_source.dart';

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource remoteDataSource;

  MapRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<SightingMarker>> getMarkers() async {
    return await remoteDataSource.getMarkers();
  }
}
