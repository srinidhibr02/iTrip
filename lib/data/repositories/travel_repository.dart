import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itrip/core/utils/result.dart';
import 'package:itrip/data/datasources/firestore_travel_datasource.dart';
import 'package:itrip/data/datasources/local_cache_datasource.dart';
import 'package:itrip/data/datasources/mock_data_source.dart';
import 'package:itrip/data/mappers/trip_mapper.dart';
import 'package:itrip/data/repositories/auth_repository.dart';
import 'package:itrip/domain/entities/budget_entity.dart';
import 'package:itrip/domain/entities/package_entity.dart';
import 'package:itrip/domain/entities/place_entity.dart';
import 'package:itrip/domain/entities/post_entity.dart';
import 'package:itrip/domain/entities/route_entity.dart';
import 'package:itrip/domain/entities/trip_entity.dart';
import 'package:uuid/uuid.dart';

/// Travel data repository — Firestore → cache → mock fallback chain.
class TravelRepository {
  TravelRepository({
    required FirestoreTravelDataSource firestore,
    required LocalCacheDataSource cache,
    required AuthRepository auth,
  })  : _firestore = firestore,
        _cache = cache,
        _auth = auth;

  final FirestoreTravelDataSource _firestore;
  final LocalCacheDataSource _cache;
  final AuthRepository _auth;
  final _uuid = const Uuid();

  bool get _canUseFirestore => _auth.isAuthenticated;

  Future<Result<List<PlaceEntity>>> getNearbyPlaces({
    PlaceCategory? category,
    bool? openNow,
    bool? familyFriendly,
    bool? bikeFriendly,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
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

  Future<Result<PlaceEntity?>> getPlaceById(String id) async {
    final places = MockDataSource.getNearbyPlaces();
    try {
      return Success(places.firstWhere((p) => p.id == id));
    } catch (_) {
      return const Success(null);
    }
  }

  Future<Result<List<RouteEntity>>> getRoutes(
    String source,
    String destination,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return Success(MockDataSource.getRoutes(source, destination));
  }

  Future<Result<RouteExperienceEntity>> getRouteExperience(String routeId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return Success(MockDataSource.getRouteExperience(routeId));
  }

  Future<Result<List<PackageEntity>>> getPackages() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return Success(MockDataSource.getPackages());
  }

  Future<Result<List<PostEntity>>> getPosts() async {
    if (_canUseFirestore) {
      final remote = await _firestore.getRecentPosts();
      if (remote is Success<List<Map<String, dynamic>>> &&
          remote.data.isNotEmpty) {
        // Posts from Firestore would need a mapper; use mock for now
      }
    }
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return Success(MockDataSource.getPosts());
  }

  Future<Result<List<TripEntity>>> getTrips(String userId) async {
    if (_canUseFirestore) {
      final remote = await _firestore.getTripsForUser(userId);
      if (remote is Success<List<Map<String, dynamic>>> &&
          remote.data.isNotEmpty) {
        final trips = remote.data.map(TripMapper.fromMap).toList();
        await _cache.cacheTrips(
          trips.map((t) => {'id': t.id, ...TripMapper.toMap(t)}).toList(),
        );
        return Success(trips);
      }
    }

    final cached = _cache.getCachedTrips();
    if (cached != null && cached.isNotEmpty) {
      return Success(cached.map(TripMapper.fromMap).toList());
    }

    await Future<void>.delayed(const Duration(milliseconds: 200));
    final mock = MockDataSource.getTrips(userId);
    await _cache.cacheTrips(
      mock.map((t) => {'id': t.id, ...TripMapper.toMap(t)}).toList(),
    );
    return Success(mock);
  }

  Future<Result<TripEntity>> createTrip({
    required String userId,
    required String title,
    required String source,
    required String destination,
    TripType tripType = TripType.solo,
    TripMode tripMode = TripMode.leisure,
    int days = 1,
    List<String> stopPoints = const [],
  }) async {
    final suggestions = _generateAiSuggestions(destination, tripMode, days);
    final itinerary = _generateItinerary(destination, days);
    final now = DateTime.now();

    var trip = TripEntity(
      id: _uuid.v4(),
      userId: userId,
      title: title.isEmpty ? '$source to $destination' : title,
      source: source,
      destination: destination,
      stopPoints: stopPoints,
      tripType: tripType,
      tripMode: tripMode,
      status: TripStatus.planned,
      startDate: now.add(const Duration(days: 7)),
      endDate: now.add(Duration(days: 7 + days)),
      days: days,
      aiSuggestions: suggestions,
      itinerary: itinerary,
      createdAt: now,
      updatedAt: now,
    );

    if (_canUseFirestore) {
      final result = await _firestore.createTrip(TripMapper.toMap(trip, forFirestore: true));
      if (result is Success<String>) {
        trip = TripEntity(
          id: result.data,
          userId: trip.userId,
          title: trip.title,
          source: trip.source,
          destination: trip.destination,
          stopPoints: trip.stopPoints,
          tripType: trip.tripType,
          tripMode: trip.tripMode,
          status: trip.status,
          startDate: trip.startDate,
          endDate: trip.endDate,
          days: trip.days,
          aiSuggestions: trip.aiSuggestions,
          itinerary: trip.itinerary,
          createdAt: trip.createdAt,
          updatedAt: trip.updatedAt,
        );
      }
    }

    await _cache.appendTrip({'id': trip.id, ...TripMapper.toMap(trip)});
    return Success(trip);
  }

  Future<Result<BudgetEstimateEntity>> calculateBudget({
    required TransportMode transportMode,
    required BudgetMode budgetMode,
    required double distanceKm,
    int durationDays = 1,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return Success(
      MockDataSource.calculateBudget(
        transportMode: transportMode,
        budgetMode: budgetMode,
        distanceKm: distanceKm,
        durationDays: durationDays,
      ),
    );
  }

  List<String> _generateAiSuggestions(String destination, TripMode mode, int days) {
    final dest = destination.toLowerCase();
    final suggestions = <String>[
      'Start early to avoid traffic on highways',
      'Carry water and snacks for the journey',
    ];
    if (dest.contains('coorg') || dest.contains('madikeri')) {
      suggestions.addAll([
        'Visit Abbey Falls on day 2 morning',
        'Book a homestay in Madikeri for local experience',
        'Carry rain gear during monsoon (Jun-Sep)',
      ]);
    }
    if (mode == TripMode.adventure) {
      suggestions.add('Check bike/car fitness before ghat sections');
    }
    if (days > 2) {
      suggestions.add('Plan rest stops every 100 km');
    }
    return suggestions.take(5).toList();
  }

  List<ItineraryDay> _generateItinerary(String destination, int days) {
    return List.generate(days, (i) {
      final day = i + 1;
      if (day == 1) {
        return ItineraryDay(
          day: day,
          activities: ['Depart', 'En-route sightseeing', 'Check-in at $destination'],
        );
      }
      if (day == days) {
        return ItineraryDay(
          day: day,
          activities: ['Local exploration', 'Return journey'],
        );
      }
      return ItineraryDay(
        day: day,
        activities: ['Explore $destination', 'Local food & culture'],
      );
    });
  }
}

final travelRepositoryProvider = Provider<TravelRepository>((ref) {
  return TravelRepository(
    firestore: ref.watch(firestoreTravelDataSourceProvider),
    cache: ref.watch(localCacheDataSourceProvider),
    auth: ref.watch(authRepositoryProvider),
  );
});
