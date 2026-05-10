import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_markers_usecase.dart';
import '../../../../core/services/location_service.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetMarkersUseCase getMarkersUseCase;
  final LocationService locationService;

  MapBloc({
    required this.getMarkersUseCase,
    required this.locationService,
  }) : super(MapInitial()) {
    on<LoadMarkers>((event, emit) async {
      final currentState = state;
      (double, double)? userLocation;
      if (currentState is MapLoaded) {
        userLocation = currentState.userLocation;
      }

      emit(MapLoading());
      try {
        final markers = await getMarkersUseCase();
        emit(MapLoaded(markers, userLocation: userLocation));
      } catch (e) {
        emit(MapError(e.toString()));
      }
    });

    on<GetUserLocation>((event, emit) async {
      print('MapBloc: Handling GetUserLocation');
      try {
        final position = await locationService.getCurrentLocation();
        print('MapBloc: Position received: $position');
        if (position != null) {
          final currentState = state;
          if (currentState is MapLoaded) {
            emit(currentState.copyWith(
              userLocation: (position.latitude, position.longitude),
            ));
          } else {
            emit(MapLoaded(const [],
                userLocation: (position.latitude, position.longitude)));
          }
        }
      } catch (e) {
        print('MapBloc: Error getting location: $e');
      }
    });
  }
}
