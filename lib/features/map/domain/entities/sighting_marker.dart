import 'package:equatable/equatable.dart';

class SightingMarker extends Equatable {
  final String id;
  final double latitude;
  final double longitude;
  final String title;
  final String snippet;

  const SightingMarker({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.snippet,
  });

  @override
  List<Object> get props => [id, latitude, longitude, title, snippet];
}
