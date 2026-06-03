import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:itrip/core/constants/route_paths.dart';
import 'package:itrip/core/theme/app_colors.dart';
import 'package:itrip/core/utils/result.dart';
import 'package:itrip/core/widgets/app_loading.dart';
import 'package:itrip/core/widgets/gradient_button.dart';
import 'package:itrip/data/repositories/travel_repository.dart';
import 'package:itrip/domain/entities/place_entity.dart';

final placeDetailProvider =
    FutureProvider.family<PlaceEntity?, String>((ref, id) async {
  final result = await ref.read(travelRepositoryProvider).getPlaceById(id);
  return result.when(success: (p) => p, error: (_) => null);
});

class PlaceDetailScreen extends ConsumerWidget {
  const PlaceDetailScreen({super.key, required this.placeId});

  final String placeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeAsync = ref.watch(placeDetailProvider(placeId));

    return Scaffold(
      body: placeAsync.when(
        loading: () => const AppLoading(),
        error: (_, __) => const Center(child: Text('Place not found')),
        data: (place) {
          if (place == null) {
            return const Center(child: Text('Place not found'));
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(place.name, style: const TextStyle(fontSize: 16)),
                  background: place.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: place.imageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            color: AppColors.lightGray,
                          ),
                        )
                      : Container(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (place.address != null) ...[
                        Row(
                          children: [
                            const Icon(Icons.place, size: 18, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(child: Text(place.address!)),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      _InfoRow(Icons.star, 'Rating', '${place.rating} (${place.reviewCount} reviews)'),
                      if (place.distanceKm != null)
                        _InfoRow(Icons.directions, 'Distance', '${place.distanceKm!.toStringAsFixed(1)} km'),
                      if (place.travelTimeMinutes != null)
                        _InfoRow(Icons.schedule, 'Travel time', '${place.travelTimeMinutes} min'),
                      if (place.entryFee != null)
                        _InfoRow(Icons.currency_rupee, 'Entry fee', '₹${place.entryFee!.toStringAsFixed(0)}'),
                      if (place.bestVisitingTime != null)
                        _InfoRow(Icons.wb_sunny, 'Best time', place.bestVisitingTime!),
                      _InfoRow(Icons.people, 'Crowd', place.crowdLevel.name),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children: [
                          if (place.isOpen) _Tag('Open now', AppColors.success),
                          if (place.isFamilyFriendly) _Tag('Family-friendly', AppColors.info),
                          if (place.isBikeFriendly) _Tag('Bike-friendly', AppColors.bikeFriendly),
                          if (!place.isSafeAtNight) _Tag('Avoid at night', AppColors.warning),
                        ],
                      ),
                      const SizedBox(height: 24),
                      GradientButton(
                        label: 'Get Directions',
                        icon: Icons.navigation,
                        onPressed: () => context.push(RoutePaths.map),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.mediumGray),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label, this.color);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
