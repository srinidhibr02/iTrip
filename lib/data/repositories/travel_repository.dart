import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itrip/core/utils/result.dart';
import 'package:itrip/data/datasources/mock_data_source.dart';
import 'package:itrip/domain/entities/budget_entity.dart';
import 'package:itrip/domain/entities/package_entity.dart';
import 'package:itrip/domain/entities/place_entity.dart';
import 'package:itrip/domain/entities/post_entity.dart';
import 'package:itrip/domain/entities/route_entity.dart';
import 'package:itrip/domain/entities/trip_entity.dart';

/// Travel data repository — abstracts mock/Firebase/API sources.
class TravelRepository {
  Future<Result<List<PlaceEntity>>> getNearbyPlaces({
    PlaceCategory? category,
    bool? openNow,
    bool? familyFriendly,
    bool? bikeFriendly,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    var places = MockDataSource.getNearbyPlaces();

    if (category != null) {
      places = places.where((p) => p.category == category).toList();
    }
    if (openNow == true) {
      places = places.where((p) => p.isOpen).toList();
    }
    if (familyFriendly == true) {
      places = places.where((p) => p.isFamilyFriendly).toList();
    }
    if (bikeFriendly == true) {
      places = places.where((p) => p.isBikeFriendly).toList();
    }

    return Success(places);
  }

  Future<Result<List<RouteEntity>>> getRoutes(
    String source,
    String destination,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return Success(MockDataSource.getRoutes(source, destination));
  }

  Future<Result<RouteExperienceEntity>> getRouteExperience(String routeId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return Success(MockDataSource.getRouteExperience(routeId));
  }

  Future<Result<List<PackageEntity>>> getPackages() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return Success(MockDataSource.getPackages());
  }

  Future<Result<List<PostEntity>>> getPosts() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return Success(MockDataSource.getPosts());
  }

  Future<Result<List<TripEntity>>> getTrips(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return Success(MockDataSource.getTrips(userId));
  }

  Future<Result<BudgetEstimateEntity>> calculateBudget({
    required TransportMode transportMode,
    required BudgetMode budgetMode,
    required double distanceKm,
    int durationDays = 1,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return Success(
      MockDataSource.calculateBudget(
        transportMode: transportMode,
        budgetMode: budgetMode,
        distanceKm: distanceKm,
        durationDays: durationDays,
      ),
    );
  }
}

final travelRepositoryProvider = Provider<TravelRepository>((ref) {
  return TravelRepository();
});
