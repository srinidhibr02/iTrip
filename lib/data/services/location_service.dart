import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:itrip/core/config/app_config.dart';
import 'package:itrip/core/errors/failures.dart';
import 'package:itrip/core/utils/result.dart';

/// GPS location service wrapper.
class LocationService {
  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  Future<LocationPermission> checkPermission() =>
      Geolocator.checkPermission();

  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  Future<Result<({double lat, double lng})>> getCurrentPosition() async {
    try {
      final serviceEnabled = await isServiceEnabled();
      if (!serviceEnabled) {
        return const Error(LocationFailure('Location services are disabled'));
      }

      var permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          return const Error(LocationFailure('Location permission denied'));
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const Error(
          LocationFailure('Location permission permanently denied'),
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      return Success((lat: position.latitude, lng: position.longitude));
    } catch (e) {
      return Error(LocationFailure(e.toString()));
    }
  }

  /// Fallback when GPS unavailable — Bangalore center.
  ({double lat, double lng}) get defaultPosition => (
        lat: AppConfig.defaultLatitude,
        lng: AppConfig.defaultLongitude,
      );
}

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final currentPositionProvider =
    FutureProvider<({double lat, double lng})>((ref) async {
  final service = ref.watch(locationServiceProvider);
  final result = await service.getCurrentPosition();
  return result.when(
    success: (pos) => pos,
    error: (_) => service.defaultPosition,
  );
});
