import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';

class HomeMapPage extends StatefulWidget {
  const HomeMapPage({super.key});

  @override
  State<HomeMapPage> createState() => _HomeMapPageState();
}

class _HomeMapPageState extends State<HomeMapPage> {
  MapLibreMapController? mapController;

  void _onMapCreated(MapLibreMapController controller) {
    mapController = controller;
    context.read<MapBloc>().add(LoadMarkers());
    context.read<MapBloc>().add(GetUserLocation());
  }

  void _addMarkers(MapLoaded state, Color primaryColor) {
    final controller = mapController;
    if (controller != null) {
      final hexColor =
          '#${primaryColor.value.toRadixString(16).substring(2).toUpperCase()}';
      for (var marker in state.markers) {
        controller
            .addSymbol(
              SymbolOptions(
                geometry: LatLng(marker.latitude, marker.longitude),
                iconImage: 'marker-15',
                iconSize: 2.0,
                textField: marker.title,
                textOffset: const Offset(0, 1.5),
                textColor: hexColor,
              ),
            )
            .catchError((e) {
              debugPrint('Error adding symbol: $e');
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<MapBloc, MapState>(
          listener: (context, state) {
            if (state is MapLoaded) {
              print(
                'HomeMapPage: MapLoaded state received. UserLocation: ${state.userLocation}',
              );
              _addMarkers(state, Theme.of(context).colorScheme.primary);
              if (state.userLocation != null) {
                print('HomeMapPage: Animating camera to ${state.userLocation}');
                mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(state.userLocation!.$1, state.userLocation!.$2),
                    14.0,
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                MapLibreMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(37.7749, -122.4194),
                    zoom: 12.0,
                  ),
                  styleString:
                      'https://basemaps.cartocdn.com/gl/dark-matter-gl-style/style.json',
                  myLocationEnabled: true,
                  myLocationTrackingMode: MyLocationTrackingMode.none,
                ),
                if (state is MapLoading)
                  Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          onPressed: () {
            // Dummy create post action
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Create Post FAB clicked!')),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
