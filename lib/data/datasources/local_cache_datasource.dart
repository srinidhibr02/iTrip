import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:itrip/core/constants/app_constants.dart';

/// Hive-based offline cache for trips and routes.
class LocalCacheDataSource {
  LocalCacheDataSource(this._tripsBox, this._routesBox);

  final Box<dynamic> _tripsBox;
  final Box<dynamic> _routesBox;

  Future<void> cacheTrips(List<Map<String, dynamic>> trips) async {
    await _tripsBox.put('cached_trips', trips);
    await _tripsBox.put('cached_at', DateTime.now().toIso8601String());
  }

  Future<void> appendTrip(Map<String, dynamic> trip) async {
    final existing = getCachedTrips() ?? [];
    await cacheTrips([trip, ...existing]);
  }

  List<Map<String, dynamic>>? getCachedTrips() {
    final data = _tripsBox.get('cached_trips');
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    return null;
  }

  Future<void> cacheRoute(String routeId, Map<String, dynamic> route) async {
    await _routesBox.put(routeId, route);
  }

  Map<String, dynamic>? getCachedRoute(String routeId) {
    final data = _routesBox.get(routeId);
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  Future<void> clearAll() async {
    await _tripsBox.clear();
    await _routesBox.clear();
  }
}

final localCacheDataSourceProvider = Provider<LocalCacheDataSource>((ref) {
  return LocalCacheDataSource(
    Hive.box(AppConstants.tripsBox),
    Hive.box(AppConstants.routesBox),
  );
});
