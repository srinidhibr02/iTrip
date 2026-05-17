import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:itrip/core/constants/route_paths.dart';
import 'package:itrip/core/utils/result.dart';
import 'package:itrip/core/theme/app_colors.dart';
import 'package:itrip/core/widgets/app_loading.dart';
import 'package:itrip/core/widgets/gradient_button.dart';
import 'package:itrip/data/repositories/travel_repository.dart';
import 'package:itrip/domain/entities/route_entity.dart';

final routesProvider = FutureProvider.family<List<RouteEntity>, (String, String)>(
  (ref, params) async {
    final result = await ref.read(travelRepositoryProvider).getRoutes(
          params.$1,
          params.$2,
        );
    return result.when(
      success: (data) => data,
      error: (_) => throw Exception('Failed'),
    );
  },
);

class RoutesScreen extends ConsumerStatefulWidget {
  const RoutesScreen({super.key});

  @override
  ConsumerState<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends ConsumerState<RoutesScreen> {
  final _sourceController = TextEditingController(text: 'Bangalore');
  final _destController = TextEditingController(text: 'Coorg');
  bool _searched = false;

  @override
  Widget build(BuildContext context) {
    final routesAsync = _searched
        ? ref.watch(routesProvider((
            _sourceController.text,
            _destController.text,
          )))
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Route Recommendations')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _sourceController,
                  decoration: const InputDecoration(
                    labelText: 'From',
                    prefixIcon: Icon(Icons.trip_origin),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _destController,
                  decoration: const InputDecoration(
                    labelText: 'To',
                    prefixIcon: Icon(Icons.place),
                  ),
                ),
                const SizedBox(height: 16),
                GradientButton(
                  label: 'Find Routes',
                  icon: Icons.route,
                  onPressed: () => setState(() => _searched = true),
                ),
              ],
            ),
          ),
          Expanded(
            child: !_searched
                ? Center(
                    child: Text(
                      'Enter source & destination to get route options',
                      style: TextStyle(color: AppColors.mediumGray),
                    ),
                  )
                : routesAsync!.when(
                    loading: () => const AppLoading(message: 'Analyzing routes...'),
                    error: (_, __) => const Center(child: Text('Failed to load routes')),
                    data: (routes) => ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: routes.length,
                      itemBuilder: (_, i) => _RouteCard(
                        route: routes[i],
                        onExperience: () => context.push(
                          '${RoutePaths.routeExperience}/${routes[i].id}',
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.route, required this.onExperience});

  final RouteEntity route;
  final VoidCallback onExperience;

  @override
  Widget build(BuildContext context) {
    final typeColor = switch (route.routeType) {
      RouteType.scenic => AppColors.scenic,
      RouteType.fastest => AppColors.fastest,
      RouteType.safest => AppColors.safest,
      RouteType.budgetFriendly => AppColors.budget,
      RouteType.bikeFriendly => AppColors.bikeFriendly,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    route.routeType.name,
                    style: TextStyle(
                      color: typeColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${route.totalKm.toStringAsFixed(0)} km',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Stat(Icons.schedule, '${route.estimatedMinutes ~/ 60}h ${route.estimatedMinutes % 60}m'),
                _Stat(Icons.toll, '${route.tollCount} tolls'),
                if (route.fuelCost != null)
                  _Stat(Icons.local_gas_station, '₹${route.fuelCost!.toStringAsFixed(0)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _Stat(Icons.star, '${route.safetyScore}/10 safety'),
                _Stat(Icons.construction, '${route.roadQualityScore}/10 road'),
              ],
            ),
            if (route.warnings.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...route.warnings.map(
                (w) => Row(
                  children: [
                    const Icon(Icons.warning_amber, size: 14, color: AppColors.warning),
                    const SizedBox(width: 4),
                    Expanded(child: Text(w, style: const TextStyle(fontSize: 12))),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onExperience,
                    icon: const Icon(Icons.visibility),
                    label: const Text('Experience Preview'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.mediumGray),
          const SizedBox(width: 4),
          Flexible(
            child: Text(label, style: const TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
