import 'package:equatable/equatable.dart';

enum PlaceCategory {
  attraction,
  waterfall,
  hill,
  restaurant,
  cafe,
  fuelStation,
  evCharging,
  hotel,
  hospital,
  bikeGarage,
  viewpoint,
}

enum CrowdLevel { low, moderate, high, veryHigh }

/// Nearby place discovery entity.
class PlaceEntity extends Equatable {
  const PlaceEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    this.address,
    this.rating = 0,
    this.reviewCount = 0,
    this.distanceKm,
    this.travelTimeMinutes,
    this.entryFee,
    this.bestVisitingTime,
    this.crowdLevel = CrowdLevel.moderate,
    this.imageUrl,
    this.isOpen = true,
    this.isFamilyFriendly = false,
    this.isBikeFriendly = false,
    this.isSafeAtNight = true,
    this.budgetLevel,
  });

  final String id;
  final String name;
  final PlaceCategory category;
  final double latitude;
  final double longitude;
  final String? address;
  final double rating;
  final int reviewCount;
  final double? distanceKm;
  final int? travelTimeMinutes;
  final double? entryFee;
  final String? bestVisitingTime;
  final CrowdLevel crowdLevel;
  final String? imageUrl;
  final bool isOpen;
  final bool isFamilyFriendly;
  final bool isBikeFriendly;
  final bool isSafeAtNight;
  final String? budgetLevel;

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        latitude,
        longitude,
        address,
        rating,
        reviewCount,
        distanceKm,
        travelTimeMinutes,
        entryFee,
        bestVisitingTime,
        crowdLevel,
        imageUrl,
        isOpen,
        isFamilyFriendly,
        isBikeFriendly,
        isSafeAtNight,
        budgetLevel,
      ];
}
