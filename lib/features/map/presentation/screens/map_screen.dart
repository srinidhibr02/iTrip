import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:itrip/core/config/app_config.dart';
import 'package:itrip/core/theme/app_colors.dart';
import 'package:itrip/data/services/location_service.dart';

/// Interactive map with user location and nearby markers.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    final positionAsync = ref.watch(currentPositionProvider);

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
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(target: target, zoom: 11),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                markers: {
                  Marker(
                    markerId: const MarkerId('current'),
                    position: target,
                    infoWindow: const InfoWindow(title: 'You are here'),
                  ),
                },
                onMapCreated: (controller) => _mapController = controller,
                onCameraIdle: () {},
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
                    leading: const Icon(Icons.search, color: AppColors.primary),
                    title: const Text('Search places, routes...'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {},
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
