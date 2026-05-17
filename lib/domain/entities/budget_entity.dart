import 'package:equatable/equatable.dart';

enum TransportMode { bike, car, bus, train, flight }
enum BudgetMode { backpacker, standard, luxury }

/// Budget estimation entity.
class BudgetEstimateEntity extends Equatable {
  const BudgetEstimateEntity({
    required this.transportMode,
    required this.budgetMode,
    required this.totalCost,
    this.fuelCost = 0,
    this.tollCost = 0,
    this.stayCost = 0,
    this.foodCost = 0,
    this.parkingCost = 0,
    this.permitCost = 0,
    this.emergencyReserve = 0,
    this.distanceKm,
    this.durationDays = 1,
    this.breakdown = const {},
    this.cheapestOption,
    this.fastestOption,
    this.bestValueOption,
  });

  final TransportMode transportMode;
  final BudgetMode budgetMode;
  final double totalCost;
  final double fuelCost;
  final double tollCost;
  final double stayCost;
  final double foodCost;
  final double parkingCost;
  final double permitCost;
  final double emergencyReserve;
  final double? distanceKm;
  final int durationDays;
  final Map<String, double> breakdown;
  final String? cheapestOption;
  final String? fastestOption;
  final String? bestValueOption;

  @override
  List<Object?> get props => [
        transportMode,
        budgetMode,
        totalCost,
        fuelCost,
        tollCost,
        stayCost,
        foodCost,
        parkingCost,
        permitCost,
        emergencyReserve,
        distanceKm,
        durationDays,
        breakdown,
        cheapestOption,
        fastestOption,
        bestValueOption,
      ];
}
