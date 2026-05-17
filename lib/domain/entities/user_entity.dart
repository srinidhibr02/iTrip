import 'package:equatable/equatable.dart';

/// User profile entity.
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phone,
    this.bio,
    this.milesTraveled = 0,
    this.explorerLevel = 1,
    this.badges = const [],
    this.createdAt,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phone;
  final String? bio;
  final double milesTraveled;
  final int explorerLevel;
  final List<String> badges;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        phone,
        bio,
        milesTraveled,
        explorerLevel,
        badges,
        createdAt,
      ];
}
