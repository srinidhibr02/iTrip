import 'package:equatable/equatable.dart';

/// Community post entity.
class PostEntity extends Equatable {
  const PostEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    this.userPhotoUrl,
    this.imageUrls = const [],
    this.routeId,
    this.likes = 0,
    this.comments = 0,
    this.hazardReport,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String content;
  final List<String> imageUrls;
  final String? routeId;
  final int likes;
  final int comments;
  final String? hazardReport;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userPhotoUrl,
        content,
        imageUrls,
        routeId,
        likes,
        comments,
        hazardReport,
        createdAt,
      ];
}
