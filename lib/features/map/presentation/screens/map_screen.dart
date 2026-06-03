import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:itrip/core/config/app_config.dart';
import 'package:itrip/core/theme/app_colors.dart';
import 'package:itrip/core/utils/result.dart';
import 'package:itrip/data/repositories/travel_repository.dart';
import 'package:itrip/data/services/location_service.dart';
import 'package:itrip/domain/entities/place_entity.dart';

final mapPlacesProvider = FutureProvider<List<PlaceEntity>>((ref) async {
  final result = await ref.read(travelRepositoryProvider).getNearbyPlaces();
  return result.when(success: (d) => d, error: (_) => []);
});

/// Interactive map with user location and nearby place markers.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;

  Set<Marker> _buildMarkers(LatLng userPos, List<PlaceEntity> places) {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('current'),
        position: userPos,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: const InfoWindow(title: 'You are here'),
      ),
    };

    for (final place in places) {
      markers.add(
        Marker(
          markerId: MarkerId(place.id),
          position: LatLng(place.latitude, place.longitude),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: place.distanceKm != null
                ? '${place.distanceKm!.toStringAsFixed(1)} km away'
                : null,
          ),
          onTap: () => context.push('/place/${place.id}'),
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final positionAsync = ref.watch(currentPositionProvider);
    final placesAsync = ref.watch(mapPlacesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: positionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _MapFallback(onRetry: () => ref.invalidate(currentPositionProvider)),
        data: (pos) {
          final target = LatLng(pos.lat, pos.lng);
          if (!AppConfig.hasGoogleMapsKey) {
            return _MapFallback(
              message:
                  'Add GOOGLE_MAPS_API_KEY to .env and local.properties (Android) or Info.plist (iOS).',
              onRetry: () => ref.invalidate(currentPositionProvider),
            );
          }

          final places = placesAsync.valueOrNull ?? [];
          final markers = _buildMarkers(target, places);

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(target: target, zoom: 10),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                markers: markers,
                onMapCreated: (controller) => _mapController = controller,
              ),
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton.small(
                  heroTag: 'locate',
                  onPressed: () => _goToPosition(target),
                  child: const Icon(Icons.my_location),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.explore, color: AppColors.primary),
                    title: Text('${places.length} places nearby'),
                    subtitle: const Text('Tap markers for details'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _goToPosition(LatLng target) async {
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: 13)),
    );
  }
}

class _MapFallback extends StatelessWidget {
  const _MapFallback({this.message, this.onRetry});

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 72, color: AppColors.mediumGray.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              message ?? 'Unable to load map',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.mediumGray),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
