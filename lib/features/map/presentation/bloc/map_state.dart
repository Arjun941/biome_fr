import 'package:equatable/equatable.dart';
import '../../domain/entities/sighting_marker.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final List<SightingMarker> markers;
  final (double, double)? userLocation;

  const MapLoaded(this.markers, {this.userLocation});

  @override
  List<Object> get props => [markers, if (userLocation != null) userLocation!];

  MapLoaded copyWith({
    List<SightingMarker>? markers,
    (double, double)? userLocation,
  }) {
    return MapLoaded(
      markers ?? this.markers,
      userLocation: userLocation ?? this.userLocation,
    );
  }
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object> get props => [message];
}
