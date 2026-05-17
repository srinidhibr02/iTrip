import 'package:itrip/domain/entities/budget_entity.dart';
import 'package:itrip/domain/entities/package_entity.dart';
import 'package:itrip/domain/entities/place_entity.dart';
import 'package:itrip/domain/entities/post_entity.dart';
import 'package:itrip/domain/entities/route_entity.dart';
import 'package:itrip/domain/entities/trip_entity.dart';

/// Mock data source for development and demo — replace with Firebase/API in production.
class MockDataSource {
  static List<PlaceEntity> getNearbyPlaces() => [
        const PlaceEntity(
          id: 'p1',
          name: 'Jog Falls',
          category: PlaceCategory.waterfall,
          latitude: 14.2297,
          longitude: 74.8150,
          address: 'Shimoga, Karnataka',
          rating: 4.7,
          reviewCount: 2340,
          distanceKm: 45.2,
          travelTimeMinutes: 75,
          entryFee: 50,
          bestVisitingTime: 'Monsoon (Jul-Sep)',
          crowdLevel: CrowdLevel.high,
          imageUrl: 'https://images.unsplash.com/photo-1432405972618-c60b992536af?w=800',
          isFamilyFriendly: true,
          isBikeFriendly: true,
          budgetLevel: 'Budget',
        ),
        const PlaceEntity(
          id: 'p2',
          name: 'Coorg Coffee Estate Viewpoint',
          category: PlaceCategory.viewpoint,
          latitude: 12.3375,
          longitude: 75.8069,
          address: 'Madikeri, Karnataka',
          rating: 4.5,
          reviewCount: 890,
          distanceKm: 28.5,
          travelTimeMinutes: 50,
          entryFee: 0,
          bestVisitingTime: 'Early morning',
          crowdLevel: CrowdLevel.moderate,
          imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
          isFamilyFriendly: true,
          isBikeFriendly: true,
          isSafeAtNight: false,
        ),
        const PlaceEntity(
          id: 'p3',
          name: 'Highway Dhaba - Punjabi Rasoi',
          category: PlaceCategory.restaurant,
          latitude: 12.2958,
          longitude: 76.6394,
          address: 'NH 275, Mysore Road',
          rating: 4.2,
          reviewCount: 456,
          distanceKm: 12.3,
          travelTimeMinutes: 20,
          crowdLevel: CrowdLevel.moderate,
          imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800',
          isOpen: true,
          budgetLevel: 'Budget',
        ),
        const PlaceEntity(
          id: 'p4',
          name: 'Indian Oil Petrol Pump',
          category: PlaceCategory.fuelStation,
          latitude: 12.3012,
          longitude: 76.6450,
          address: 'Mysore Road',
          rating: 4.0,
          reviewCount: 120,
          distanceKm: 8.5,
          travelTimeMinutes: 15,
          isOpen: true,
          isBikeFriendly: true,
        ),
        const PlaceEntity(
          id: 'p5',
          name: 'Taj Madikeri Resort',
          category: PlaceCategory.hotel,
          latitude: 12.4200,
          longitude: 75.7400,
          address: 'Coorg, Karnataka',
          rating: 4.8,
          reviewCount: 1890,
          distanceKm: 65.0,
          travelTimeMinutes: 90,
          entryFee: 8500,
          bestVisitingTime: 'Oct-Feb',
          crowdLevel: CrowdLevel.low,
          imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
          isFamilyFriendly: true,
          budgetLevel: 'Luxury',
        ),
        const PlaceEntity(
          id: 'p6',
          name: 'Ather Grid EV Charging',
          category: PlaceCategory.evCharging,
          latitude: 12.9716,
          longitude: 77.5946,
          address: 'Koramangala, Bangalore',
          rating: 4.3,
          reviewCount: 89,
          distanceKm: 5.2,
          travelTimeMinutes: 12,
          isOpen: true,
        ),
      ];

  static List<RouteEntity> getRoutes(String source, String destination) => [
        RouteEntity(
          id: 'r1',
          source: source,
          destination: destination,
          routeType: RouteType.scenic,
          totalKm: 265,
          estimatedMinutes: 360,
          tollCount: 2,
          tollCost: 180,
          fuelRequiredLiters: 6.6,
          fuelCost: 673,
          foodStops: ['Maddur Tiffins', 'Kushalnagar Cafe'],
          restStops: ['Srirangapatna Viewpoint'],
          scenicStops: ['Bisle Ghat', 'Raja Seat'],
          roadQualityScore: 7.5,
          safetyScore: 8.0,
          trafficLevel: 'Moderate',
          weatherCondition: 'Clear',
          warnings: ['Ghat section after Kushalnagar - ride carefully'],
          nightSafetyScore: 6.5,
          riderDifficulty: 'Moderate',
        ),
        RouteEntity(
          id: 'r2',
          source: source,
          destination: destination,
          routeType: RouteType.fastest,
          totalKm: 245,
          estimatedMinutes: 300,
          tollCount: 3,
          tollCost: 280,
          fuelRequiredLiters: 6.1,
          fuelCost: 622,
          roadQualityScore: 8.5,
          safetyScore: 8.5,
          trafficLevel: 'High near Bangalore',
          weatherCondition: 'Clear',
          nightSafetyScore: 7.5,
          riderDifficulty: 'Easy',
        ),
        RouteEntity(
          id: 'r3',
          source: source,
          destination: destination,
          routeType: RouteType.bikeFriendly,
          totalKm: 258,
          estimatedMinutes: 340,
          tollCount: 1,
          tollCost: 90,
          fuelRequiredLiters: 6.5,
          fuelCost: 663,
          foodStops: ['Highway Dhaba'],
          scenicStops: ['Abbey Falls approach'],
          roadQualityScore: 7.0,
          safetyScore: 7.5,
          trafficLevel: 'Low',
          warnings: ['Single lane sections near Madikeri'],
          nightSafetyScore: 5.0,
          riderDifficulty: 'Moderate-Hard',
        ),
      ];

  static RouteExperienceEntity getRouteExperience(String routeId) =>
      RouteExperienceEntity(
        routeId: routeId,
        summary:
            'A beautiful ride through Karnataka\'s Western Ghats with coffee plantations, waterfalls, and misty hills. Expect winding ghat roads after Kushalnagar.',
        roadConditions: 'Good asphalt till Kushalnagar; patchy in ghat sections',
        ghatSections: ['Kushalnagar to Madikeri (18 km)', 'Bisle Ghat approach'],
        dangerousZones: ['Sharp curves km 142-158', 'Fog zone near Madikeri'],
        trafficDensity: 'Moderate on weekends',
        tollBooths: ['Nelamangala Toll', 'Kushalnagar Toll'],
        petrolBunks: ['IOCL at 45km', 'HP at 120km', 'BP at 180km'],
        restaurants: ['Maddur Tiffins', 'Coorg Cuisine', 'Raintree Restaurant'],
        hotels: ['Orange County Coorg', 'Taj Madikeri', 'Homestays in Madikeri'],
        weatherForecast: 'Partly cloudy, 18-24°C',
        scenicBeautyScore: 9.2,
        riderDifficulty: 'Moderate',
        bestTimeToRide: 'October to February, start before 7 AM',
        avoidDuringRain: true,
        nightRidingSafetyScore: 5.5,
        timeline: const [
          ExperienceTimelineItem(
            title: 'Start - Bangalore',
            description: 'Smooth highway exit via Mysore Road',
            distanceKm: 0,
            type: 'start',
          ),
          ExperienceTimelineItem(
            title: 'Maddur - Breakfast Stop',
            description: 'Famous Maddur vada - must try!',
            distanceKm: 80,
            type: 'food',
          ),
          ExperienceTimelineItem(
            title: 'Ghat Section Begins',
            description: 'Winding roads, reduce speed, enjoy views',
            distanceKm: 145,
            type: 'ghat',
          ),
          ExperienceTimelineItem(
            title: 'Madikeri Arrival',
            description: 'Hill station town, fuel up, explore Raja Seat',
            distanceKm: 265,
            type: 'destination',
          ),
        ],
        communityUpdates: [
          'Road repair near Bisle completed - Jan 2025',
          'Fog expected early mornings in Dec-Jan',
        ],
        mediaUrls: [
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
          'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800',
        ],
      );

  static List<PackageEntity> getPackages() => [
        const PackageEntity(
          id: 'pkg1',
          title: 'Coorg Weekend Bike Tour',
          type: PackageType.bikeTour,
          price: 4999,
          duration: '2 Days / 1 Night',
          destination: 'Coorg, Karnataka',
          inclusions: ['Bike rental', 'Guide', 'Breakfast', 'Homestay'],
          pickupPoints: ['Bangalore - Indiranagar', 'Mysore Junction'],
          rating: 4.6,
          reviewCount: 234,
          vendorName: 'RideX Adventures',
          vendorContact: '+91 98765 43210',
          imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
          description: 'Explore Coorg on two wheels with fellow riders',
        ),
        const PackageEntity(
          id: 'pkg2',
          title: 'Ladakh Expedition 2025',
          type: PackageType.adventure,
          price: 45999,
          duration: '10 Days / 9 Nights',
          destination: 'Leh-Ladakh',
          inclusions: ['Flights', 'Hotels', 'Permits', 'Guide', 'Meals'],
          pickupPoints: ['Delhi', 'Mumbai', 'Bangalore'],
          rating: 4.9,
          reviewCount: 567,
          vendorName: 'Himalayan Trails',
          vendorContact: '+91 98765 12345',
          imageUrl: 'https://images.unsplash.com/photo-1454496524508-7a8e8e28628a?w=800',
        ),
        const PackageEntity(
          id: 'pkg3',
          title: 'Kerala Backwaters Family Package',
          type: PackageType.familyHoliday,
          price: 24999,
          duration: '5 Days / 4 Nights',
          destination: 'Alleppey, Kerala',
          inclusions: ['Houseboat', 'Meals', 'Transfers', 'Sightseeing'],
          pickupPoints: ['Kochi Airport'],
          rating: 4.7,
          reviewCount: 890,
          vendorName: 'God\'s Own Tours',
          imageUrl: 'https://images.unsplash.com/photo-1602216056526-8258079a9e0c?w=800',
        ),
      ];

  static List<PostEntity> getPosts() => [
        PostEntity(
          id: 'post1',
          userId: 'u1',
          userName: 'RiderRahul',
          content:
              'Just completed Bangalore to Coorg ride! The ghat section was misty but absolutely worth it. Pro tip: Start early to avoid traffic.',
          imageUrls: [
            'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
          ],
          routeId: 'r1',
          likes: 234,
          comments: 45,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        PostEntity(
          id: 'post2',
          userId: 'u2',
          userName: 'TravelPriya',
          content:
              '⚠️ Hazard Alert: Potholes reported on NH 275 near Maddur. Ride slow!',
          hazardReport: 'Potholes near km 85',
          likes: 89,
          comments: 12,
          createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        ),
      ];

  static List<TripEntity> getTrips(String userId) => [
        TripEntity(
          id: 't1',
          userId: userId,
          title: 'Coorg Monsoon Escape',
          source: 'Bangalore',
          destination: 'Coorg',
          stopPoints: ['Mysore', 'Kushalnagar'],
          tripType: TripType.couple,
          tripMode: TripMode.leisure,
          status: TripStatus.planned,
          startDate: DateTime.now().add(const Duration(days: 14)),
          endDate: DateTime.now().add(const Duration(days: 16)),
          days: 3,
          budget: 15000,
          aiSuggestions: [
            'Visit Abbey Falls on Day 2 morning',
            'Book homestay in Madikeri for authentic experience',
            'Carry rain gear - monsoon season',
          ],
          itinerary: const [
            ItineraryDay(
              day: 1,
              activities: ['Drive to Coorg', 'Check-in', 'Raja Seat sunset'],
            ),
            ItineraryDay(
              day: 2,
              activities: ['Abbey Falls', 'Coffee plantation tour', 'Local food'],
            ),
            ItineraryDay(
              day: 3,
              activities: ['Dubare Elephant Camp', 'Return to Bangalore'],
            ),
          ],
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];

  static BudgetEstimateEntity calculateBudget({
    required TransportMode transportMode,
    required BudgetMode budgetMode,
    required double distanceKm,
    int durationDays = 1,
  }) {
    final multiplier = switch (budgetMode) {
      BudgetMode.backpacker => 0.7,
      BudgetMode.standard => 1.0,
      BudgetMode.luxury => 1.8,
    };

    double fuelCost = 0;
    double tollCost = 0;
    double stayCost = 0;
    double foodCost = 0;

    switch (transportMode) {
      case TransportMode.bike:
        fuelCost = (distanceKm / 40) * 102 * multiplier;
        tollCost = (distanceKm / 100) * 90;
        stayCost = 800.0 * durationDays * multiplier;
        foodCost = 400.0 * durationDays * multiplier;
      case TransportMode.car:
        fuelCost = (distanceKm / 15) * 102 * multiplier;
        tollCost = (distanceKm / 80) * 120;
        stayCost = 2500.0 * durationDays * multiplier;
        foodCost = 800.0 * durationDays * multiplier;
      case TransportMode.bus:
        fuelCost = 0;
        tollCost = 0;
        stayCost = 600.0 * durationDays * multiplier;
        foodCost = 300.0 * durationDays * multiplier;
      case TransportMode.train:
        fuelCost = distanceKm * 1.5 * multiplier;
        tollCost = 0;
        stayCost = 0;
        foodCost = 200.0 * durationDays;
      case TransportMode.flight:
        fuelCost = 5000.0 * multiplier;
        tollCost = 0;
        stayCost = 3000.0 * durationDays * multiplier;
        foodCost = 500.0 * durationDays;
    }

    final parkingCost = transportMode == TransportMode.car ? 200.0 * durationDays : 0.0;
    final permitCost = distanceKm > 300 ? 500.0 : 0.0;
    final emergencyReserve = (fuelCost + stayCost + foodCost) * 0.1;

    final total = fuelCost +
        tollCost +
        stayCost +
        foodCost +
        parkingCost +
        permitCost +
        emergencyReserve;

    return BudgetEstimateEntity(
      transportMode: transportMode,
      budgetMode: budgetMode,
      totalCost: total,
      fuelCost: fuelCost,
      tollCost: tollCost,
      stayCost: stayCost,
      foodCost: foodCost,
      parkingCost: parkingCost,
      permitCost: permitCost,
      emergencyReserve: emergencyReserve,
      distanceKm: distanceKm,
      durationDays: durationDays,
      breakdown: {
        'Fuel': fuelCost,
        'Tolls': tollCost,
        'Stay': stayCost,
        'Food': foodCost,
        'Parking': parkingCost,
        'Permits': permitCost,
        'Emergency Reserve': emergencyReserve,
      },
      cheapestOption: 'Bike + Homestay',
      fastestOption: 'Car via NH 275',
      bestValueOption: 'Bike with planned stops',
    );
  }
}
