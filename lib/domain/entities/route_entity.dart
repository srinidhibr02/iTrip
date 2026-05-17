import 'package:equatable/equatable.dart';

enum RouteType { scenic, fastest, safest, budgetFriendly, bikeFriendly }

/// Route recommendation entity.
class RouteEntity extends Equatable {
  const RouteEntity({
    required this.id,
    required this.source,
    required this.destination,
    required this.routeType,
    required this.totalKm,
    required this.estimatedMinutes,
    this.tollCount = 0,
    this.tollCost = 0,
    this.fuelRequiredLiters,
    this.fuelCost,
    this.foodStops = const [],
    this.restStops = const [],
    this.scenicStops = const [],
    this.roadQualityScore = 0,
    this.safetyScore = 0,
    this.trafficLevel,
    this.weatherCondition,
    this.polylinePoints = const [],
    this.warnings = const [],
    this.nightSafetyScore,
    this.riderDifficulty,
  });

  final String id;
  final String source;
  final String destination;
  final RouteType routeType;
  final double totalKm;
  final int estimatedMinutes;
  final int tollCount;
  final double tollCost;
  final double? fuelRequiredLiters;
  final double? fuelCost;
  final List<String> foodStops;
  final List<String> restStops;
  final List<String> scenicStops;
  final double roadQualityScore;
  final double safetyScore;
  final String? trafficLevel;
  final String? weatherCondition;
  final List<Map<String, double>> polylinePoints;
  final List<String> warnings;
  final double? nightSafetyScore;
  final String? riderDifficulty;

  @override
  List<Object?> get props => [
        id,
        source,
        destination,
        routeType,
        totalKm,
        estimatedMinutes,
        tollCount,
        tollCost,
        fuelRequiredLiters,
        fuelCost,
        foodStops,
        restStops,
        scenicStops,
        roadQualityScore,
        safetyScore,
        trafficLevel,
        weatherCondition,
        polylinePoints,
        warnings,
        nightSafetyScore,
        riderDifficulty,
      ];
}

/// Route experience preview — "Experience Before You Travel" USP.
class RouteExperienceEntity extends Equatable {
  const RouteExperienceEntity({
    required this.routeId,
    required this.summary,
    this.roadConditions,
    this.ghatSections = const [],
    this.dangerousZones = const [],
    this.trafficDensity,
    this.tollBooths = const [],
    this.petrolBunks = const [],
    this.restaurants = const [],
    this.hotels = const [],
    this.weatherForecast,
    this.scenicBeautyScore = 0,
    this.riderDifficulty,
    this.bestTimeToRide,
    this.avoidDuringRain = false,
    this.nightRidingSafetyScore = 0,
    this.timeline = const [],
    this.communityUpdates = const [],
    this.mediaUrls = const [],
  });

  final String routeId;
  final String summary;
  final String? roadConditions;
  final List<String> ghatSections;
  final List<String> dangerousZones;
  final String? trafficDensity;
  final List<String> tollBooths;
  final List<String> petrolBunks;
  final List<String> restaurants;
  final List<String> hotels;
  final String? weatherForecast;
  final double scenicBeautyScore;
  final String? riderDifficulty;
  final String? bestTimeToRide;
  final bool avoidDuringRain;
  final double nightRidingSafetyScore;
  final List<ExperienceTimelineItem> timeline;
  final List<String> communityUpdates;
  final List<String> mediaUrls;

  @override
  List<Object?> get props => [
        routeId,
        summary,
        roadConditions,
        ghatSections,
        dangerousZones,
        trafficDensity,
        tollBooths,
        petrolBunks,
        restaurants,
        hotels,
        weatherForecast,
        scenicBeautyScore,
        riderDifficulty,
        bestTimeToRide,
        avoidDuringRain,
        nightRidingSafetyScore,
        timeline,
        communityUpdates,
        mediaUrls,
      ];
}

class ExperienceTimelineItem extends Equatable {
  const ExperienceTimelineItem({
    required this.title,
    required this.description,
    this.distanceKm,
    this.icon,
    this.type,
  });

  final String title;
  final String description;
  final double? distanceKm;
  final String? icon;
  final String? type;

  @override
  List<Object?> get props => [title, description, distanceKm, icon, type];
}
