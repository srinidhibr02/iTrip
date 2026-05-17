import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itrip/core/theme/app_colors.dart';
import 'package:itrip/core/utils/result.dart';
import 'package:itrip/core/widgets/app_loading.dart';
import 'package:itrip/data/repositories/travel_repository.dart';
import 'package:itrip/domain/entities/route_entity.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

final routeExperienceProvider =
    FutureProvider.family<RouteExperienceEntity, String>((ref, routeId) async {
  final result =
      await ref.read(travelRepositoryProvider).getRouteExperience(routeId);
  return result.when(
    success: (data) => data,
    error: (_) => throw Exception('Failed'),
  );
});

/// "Experience Before You Travel" — main USP screen.
class RouteExperienceScreen extends ConsumerWidget {
  const RouteExperienceScreen({super.key, required this.routeId});

  final String routeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experienceAsync = ref.watch(routeExperienceProvider(routeId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journey Preview'),
      ),
      body: experienceAsync.when(
        loading: () => const AppLoading(message: 'Loading journey preview...'),
        error: (_, __) => const Center(child: Text('Failed to load preview')),
        data: (exp) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroCard(experience: exp),
              const SizedBox(height: 16),
              _ScoreRow(
                label: 'Scenic Beauty',
                score: exp.scenicBeautyScore,
                max: 10,
                color: AppColors.scenic,
              ),
              _ScoreRow(
                label: 'Night Riding Safety',
                score: exp.nightRidingSafetyScore,
                max: 10,
                color: exp.nightRidingSafetyScore < 6
                    ? AppColors.error
                    : AppColors.success,
              ),
              const SizedBox(height: 16),
              _InfoSection('What to Expect', exp.summary),
              if (exp.roadConditions != null)
                _InfoSection('Road Conditions', exp.roadConditions!),
              if (exp.bestTimeToRide != null)
                _InfoSection('Best Time to Ride', exp.bestTimeToRide!),
              if (exp.avoidDuringRain)
                _AlertBanner(
                  icon: Icons.water_drop,
                  message: 'Avoid during rain — slippery ghat sections',
                ),
              if (exp.ghatSections.isNotEmpty)
                _ListSection('Ghat Sections', exp.ghatSections, Icons.terrain),
              if (exp.dangerousZones.isNotEmpty)
                _ListSection('Caution Zones', exp.dangerousZones, Icons.warning),
              _ListSection('Toll Booths', exp.tollBooths, Icons.toll),
              _ListSection('Petrol Bunks', exp.petrolBunks, Icons.local_gas_station),
              _ListSection('Food Stops', exp.restaurants, Icons.restaurant),
              const SizedBox(height: 16),
              Text(
                'Journey Timeline',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              ...exp.timeline.map((item) => _TimelineTile(item: item)),
              if (exp.communityUpdates.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Community Updates',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                ...exp.communityUpdates.map(
                  (u) => Card(
                    margin: const EdgeInsets.only(top: 8),
                    child: ListTile(
                      leading: const Icon(Icons.people, color: AppColors.primary),
                      title: Text(u, style: const TextStyle(fontSize: 13)),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.experience});

  final RouteExperienceEntity experience;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.visibility, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Experience Before You Travel',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              experience.summary,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.95),
                height: 1.4,
              ),
            ),
            if (experience.riderDifficulty != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Difficulty: ${experience.riderDifficulty}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({
    required this.label,
    required this.score,
    required this.max,
    required this.color,
  });

  final String label;
  final double score;
  final double max;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('${score.toStringAsFixed(1)}/$max'),
            ],
          ),
          const SizedBox(height: 4),
          LinearPercentIndicator(
            percent: score / max,
            lineHeight: 8,
            backgroundColor: AppColors.lightGray,
            progressColor: color,
            barRadius: const Radius.circular(4),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection(this.title, this.content);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(content, style: TextStyle(color: AppColors.mediumGray, height: 1.4)),
          ],
        ),
      ),
    );
  }
}

class _ListSection extends StatelessWidget {
  const _ListSection(this.title, this.items, this.icon);

  final String title;
  final List<String> items;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        children: items
            .map((i) => ListTile(dense: true, title: Text(i, style: const TextStyle(fontSize: 13))))
            .toList(),
      ),
    );
  }
}

class _AlertBanner extends StatelessWidget {
  const _AlertBanner({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.warning),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.item});

  final ExperienceTimelineItem item;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(child: Container(width: 2, color: AppColors.primary.withValues(alpha: 0.3))),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    if (item.distanceKm != null)
                      Text(
                        '${item.distanceKm} km',
                        style: TextStyle(color: AppColors.primary, fontSize: 12),
                      ),
                    Text(item.description, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
