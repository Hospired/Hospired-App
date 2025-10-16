import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../providers/healthcare_facilities_provider.dart';
import '../../backend-api/dtos.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    final facilitiesAsync = ref.watch(healthcareFacilitiesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de hospitales')),
      body: facilitiesAsync.when(
        data: (facilities) {
          _markers.clear();
          for (var f in facilities) {
            _markers.add(
              Marker(
                markerId: MarkerId(f.id.toString()),
                position: LatLng(f.latitude.toDouble(), f.longitude.toDouble()),
                infoWindow: InfoWindow(title: f.name),
              ),
            );
          }

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: facilities.isNotEmpty
                  ? LatLng(
                      facilities.first.latitude.toDouble(),
                      facilities.first.longitude.toDouble(),
                    )
                  : const LatLng(12.13, -86.25), // fallback
              zoom: 12,
            ),
            markers: _markers,
            onMapCreated: (controller) {
              _controller = controller;

              // Solo para web: habilitar controles
              if (kIsWeb) {
                _controller?.setMapStyle(null); // puedes personalizar el estilo si quieres
              }
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: !kIsWeb, // controles de zoom solo en móvil
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
