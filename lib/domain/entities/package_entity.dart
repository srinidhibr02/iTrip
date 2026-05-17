import 'package:equatable/equatable.dart';

enum PackageType { local, adventure, bikeTour, trek, familyHoliday }

/// Tour package entity.
class PackageEntity extends Equatable {
  const PackageEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.price,
    required this.duration,
    required this.destination,
    this.inclusions = const [],
    this.pickupPoints = const [],
    this.rating = 0,
    this.reviewCount = 0,
    this.vendorName,
    this.vendorContact,
    this.imageUrl,
    this.description,
    this.isWishlisted = false,
  });

  final String id;
  final String title;
  final PackageType type;
  final double price;
  final String duration;
  final String destination;
  final List<String> inclusions;
  final List<String> pickupPoints;
  final double rating;
  final int reviewCount;
  final String? vendorName;
  final String? vendorContact;
  final String? imageUrl;
  final String? description;
  final bool isWishlisted;

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        price,
        duration,
        destination,
        inclusions,
        pickupPoints,
        rating,
        reviewCount,
        vendorName,
        vendorContact,
        imageUrl,
        description,
        isWishlisted,
      ];
}
