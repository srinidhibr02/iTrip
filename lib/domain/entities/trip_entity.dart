import 'package:equatable/equatable.dart';

enum TripType { solo, family, friends, couple }
enum TripMode { adventure, religious, leisure }
enum TripStatus { draft, planned, ongoing, completed }

/// Trip planning entity.
class TripEntity extends Equatable {
  const TripEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.source,
    required this.destination,
    this.stopPoints = const [],
    this.tripType = TripType.solo,
    this.tripMode = TripMode.leisure,
    this.status = TripStatus.draft,
    this.startDate,
    this.endDate,
    this.days = 1,
    this.budget,
    this.aiSuggestions = const [],
    this.itinerary = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String title;
  final String source;
  final String destination;
  final List<String> stopPoints;
  final TripType tripType;
  final TripMode tripMode;
  final TripStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final int days;
  final double? budget;
  final List<String> aiSuggestions;
  final List<ItineraryDay> itinerary;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        source,
        destination,
        stopPoints,
        tripType,
        tripMode,
        status,
        startDate,
        endDate,
        days,
        budget,
        aiSuggestions,
        itinerary,
        createdAt,
        updatedAt,
      ];
}

class ItineraryDay extends Equatable {
  const ItineraryDay({
    required this.day,
    required this.activities,
    this.notes,
  });

  final int day;
  final List<String> activities;
  final String? notes;

  @override
  List<Object?> get props => [day, activities, notes];
}
