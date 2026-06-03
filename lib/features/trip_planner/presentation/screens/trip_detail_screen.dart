import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:itrip/core/constants/route_paths.dart';
import 'package:itrip/core/theme/app_colors.dart';
import 'package:itrip/core/widgets/app_loading.dart';
import 'package:itrip/core/widgets/gradient_button.dart';
import 'package:itrip/domain/entities/trip_entity.dart';
import 'package:itrip/features/trip_planner/presentation/screens/trip_planner_screen.dart';

final tripDetailProvider = FutureProvider.family<TripEntity?, String>((ref, tripId) async {
  final trips = await ref.watch(tripsProvider.future);
  try {
    return trips.firstWhere((t) => t.id == tripId);
  } catch (_) {
    return null;
  }
});

class TripDetailScreen extends ConsumerWidget {
  const TripDetailScreen({super.key, required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripAsync = ref.watch(tripDetailProvider(tripId));

    return Scaffold(
      appBar: AppBar(title: const Text('Trip Details')),
      body: tripAsync.when(
        loading: () => const AppLoading(),
        error: (_, __) => const Center(child: Text('Trip not found')),
        data: (trip) {
          if (trip == null) return const Center(child: Text('Trip not found'));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  trip.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text('${trip.source} → ${trip.destination}',
                    style: TextStyle(color: AppColors.mediumGray)),
                if (trip.startDate != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${DateFormat.yMMMd().format(trip.startDate!)} — ${trip.endDate != null ? DateFormat.yMMMd().format(trip.endDate!) : ''}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
                const SizedBox(height: 24),
                GradientButton(
                  label: 'Preview Route Experience',
                  icon: Icons.visibility,
                  onPressed: () => context.push('${RoutePaths.routeExperience}/r1'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.push(RoutePaths.budget),
                  icon: const Icon(Icons.account_balance_wallet),
                  label: const Text('Estimate Budget'),
                ),
                if (trip.aiSuggestions.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text('AI Suggestions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  ...trip.aiSuggestions.map(
                    (s) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.auto_awesome, color: AppColors.primary),
                        title: Text(s, style: const TextStyle(fontSize: 13)),
                      ),
                    ),
                  ),
                ],
                if (trip.itinerary.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('Itinerary',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  ...trip.itinerary.map(
                    (day) => Card(
                      margin: const EdgeInsets.only(top: 8),
                      child: ExpansionTile(
                        title: Text('Day ${day.day}', style: const TextStyle(fontWeight: FontWeight.w600)),
                        children: day.activities
                            .map((a) => ListTile(dense: true, leading: const Icon(Icons.check_circle_outline, size: 18), title: Text(a)))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
