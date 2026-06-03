import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itrip/core/network/api_endpoints.dart';
import 'package:itrip/core/network/dio_client.dart';
import 'package:itrip/core/utils/result.dart';
import 'package:itrip/core/errors/failures.dart';

/// REST client for places discovery — falls back to mock when API unavailable.
class PlacesApiService {
  PlacesApiService(this._dio);

  final Dio _dio;

  Future<Result<List<Map<String, dynamic>>>> fetchNearbyPlaces({
    required double latitude,
    required double longitude,
    String? category,
    int radiusMeters = 50000,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.places,
        queryParameters: {
          'lat': latitude,
          'lng': longitude,
          'radius': radiusMeters,
          if (category != null) 'category': category,
        },
      );
      final data = response.data?['data'] as List<dynamic>? ?? [];
      return Success(data.cast<Map<String, dynamic>>());
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        return const Error(NetworkFailure());
      }
      return Error(ServerFailure(e.message ?? 'Request failed'));
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }
}

final placesApiServiceProvider = Provider<PlacesApiService>((ref) {
  return PlacesApiService(ref.watch(dioClientProvider).dio);
});
