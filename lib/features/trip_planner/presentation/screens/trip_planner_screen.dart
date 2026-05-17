import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:itrip/core/constants/route_paths.dart';
import 'package:itrip/core/theme/app_colors.dart';
import 'package:itrip/core/widgets/app_empty_view.dart';
import 'package:itrip/core/widgets/app_error_view.dart';
import 'package:itrip/core/utils/result.dart';
import 'package:itrip/core/widgets/app_loading.dart';
import 'package:itrip/data/repositories/travel_repository.dart';
import 'package:itrip/domain/entities/trip_entity.dart';

final tripsProvider = FutureProvider<List<TripEntity>>((ref) async {
  final result = await ref.read(travelRepositoryProvider).getTrips('demo_user');
  return result.when(
    success: (data) => data,
    error: (_) => throw Exception('Failed to load trips'),
  );
});

class TripPlannerScreen extends ConsumerWidget {
  const TripPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(RoutePaths.createTrip),
          ),
        ],
      ),
      body: tripsAsync.when(
        loading: () => const AppLoading(message: 'Loading trips...'),
        error: (_, __) => AppErrorView(
          message: 'Could not load trips',
          onRetry: () => ref.invalidate(tripsProvider),
        ),
        data: (trips) {
          if (trips.isEmpty) {
            return AppEmptyView(
              title: 'No trips yet',
              subtitle: 'Create your first smart trip plan',
              icon: Icons.map_outlined,
              actionLabel: 'Plan a Trip',
              onAction: () => context.push(RoutePaths.createTrip),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: trips.length,
            itemBuilder: (_, i) => _TripCard(trip: trips[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RoutePaths.createTrip),
        icon: const Icon(Icons.add),
        label: const Text('New Trip'),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard({required this.trip});

  final TripEntity trip;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    trip.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                _StatusChip(status: trip.status),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.trip_origin, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text('${trip.source} → ${trip.destination}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.calendar_today,
                  label: '${trip.days} days',
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.people,
                  label: trip.tripType.name,
                ),
                if (trip.budget != null) ...[
                  const SizedBox(width: 8),
                  _InfoChip(
                    icon: Icons.currency_rupee,
                    label: '₹${trip.budget!.toStringAsFixed(0)}',
                  ),
                ],
              ],
            ),
            if (trip.aiSuggestions.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('AI Suggestions', style: TextStyle(fontWeight: FontWeight.w600)),
              ...trip.aiSuggestions.take(2).map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb_outline,
                              size: 14, color: AppColors.warning),
                          const SizedBox(width: 6),
                          Expanded(child: Text(s, style: const TextStyle(fontSize: 12))),
                        ],
                      ),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final TripStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      TripStatus.planned => AppColors.info,
      TripStatus.ongoing => AppColors.success,
      TripStatus.completed => AppColors.mediumGray,
      TripStatus.draft => AppColors.warning,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}
