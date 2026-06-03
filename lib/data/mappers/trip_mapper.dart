import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itrip/domain/entities/trip_entity.dart';

/// Maps [TripEntity] to/from Firestore and cache maps.
class TripMapper {
  TripMapper._();

  static TripEntity fromMap(Map<String, dynamic> map) {
    return TripEntity(
      id: map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      source: map['source'] as String? ?? '',
      destination: map['destination'] as String? ?? '',
      stopPoints: (map['stopPoints'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      tripType: _enumFromName(
        TripType.values,
        map['tripType'] as String?,
        TripType.solo,
      ),
      tripMode: _enumFromName(
        TripMode.values,
        map['tripMode'] as String?,
        TripMode.leisure,
      ),
      status: _enumFromName(
        TripStatus.values,
        map['status'] as String?,
        TripStatus.planned,
      ),
      startDate: _parseDate(map['startDate']),
      endDate: _parseDate(map['endDate']),
      days: map['days'] as int? ?? 1,
      budget: (map['budget'] as num?)?.toDouble(),
      aiSuggestions: (map['aiSuggestions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      itinerary: _parseItinerary(map['itinerary']),
      createdAt: _parseDate(map['createdAt']),
      updatedAt: _parseDate(map['updatedAt']),
    );
  }

  static Map<String, dynamic> toMap(TripEntity trip, {bool forFirestore = false}) {
    return {
      'userId': trip.userId,
      'title': trip.title,
      'source': trip.source,
      'destination': trip.destination,
      'stopPoints': trip.stopPoints,
      'tripType': trip.tripType.name,
      'tripMode': trip.tripMode.name,
      'status': trip.status.name,
      if (trip.startDate != null)
        'startDate': forFirestore
            ? Timestamp.fromDate(trip.startDate!)
            : trip.startDate!.toIso8601String(),
      if (trip.endDate != null)
        'endDate': forFirestore
            ? Timestamp.fromDate(trip.endDate!)
            : trip.endDate!.toIso8601String(),
      'days': trip.days,
      if (trip.budget != null) 'budget': trip.budget,
      'aiSuggestions': trip.aiSuggestions,
      'itinerary': trip.itinerary
          .map(
            (d) => {
              'day': d.day,
              'activities': d.activities,
              if (d.notes != null) 'notes': d.notes,
            },
          )
          .toList(),
    };
  }

  static T _enumFromName<T extends Enum>(
    List<T> values,
    String? name,
    T fallback,
  ) {
    if (name == null) return fallback;
    return values.firstWhere(
      (e) => e.name == name,
      orElse: () => fallback,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static List<ItineraryDay> _parseItinerary(dynamic value) {
    if (value is! List) return const [];
    return value.map((item) {
      final m = item as Map<String, dynamic>;
      return ItineraryDay(
        day: m['day'] as int? ?? 1,
        activities: (m['activities'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        notes: m['notes'] as String?,
      );
    }).toList();
  }
}
