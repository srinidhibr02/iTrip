import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itrip/core/theme/app_colors.dart';
import 'package:itrip/core/utils/result.dart';
import 'package:itrip/core/widgets/app_empty_view.dart';
import 'package:itrip/core/widgets/app_error_view.dart';
import 'package:itrip/core/widgets/app_loading.dart';
import 'package:itrip/core/widgets/travel_card.dart';
import 'package:itrip/data/repositories/travel_repository.dart';
import 'package:itrip/data/services/location_service.dart';
import 'package:itrip/domain/entities/place_entity.dart';

final nearbyPlacesProvider = FutureProvider<List<PlaceEntity>>((ref) async {
  final result = await ref.read(travelRepositoryProvider).getNearbyPlaces();
  return result.when(
    success: (data) => data,
    error: (_) => throw Exception('Failed'),
  );
});

class NearbyScreen extends ConsumerStatefulWidget {
  const NearbyScreen({super.key});

  @override
  ConsumerState<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends ConsumerState<NearbyScreen> {
  bool _openNow = false;
  bool _familyFriendly = false;
  bool _bikeFriendly = false;
  PlaceCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final placesAsync = ref.watch(nearbyPlacesProvider);
    final positionAsync = ref.watch(currentPositionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Nearby'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () => ref.invalidate(currentPositionProvider),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          positionAsync.when(
            loading: () => const LinearProgressIndicator(minHeight: 2),
            error: (_, __) => const SizedBox.shrink(),
            data: (pos) => Material(
              color: AppColors.primary.withValues(alpha: 0.08),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Near ${pos.lat.toStringAsFixed(2)}, ${pos.lng.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _CategoryChip(
                  label: 'All',
                  selected: _selectedCategory == null,
                  onTap: () => setState(() => _selectedCategory = null),
                ),
                ...PlaceCategory.values.take(6).map(
                      (c) => _CategoryChip(
                        label: _categoryLabel(c),
                        selected: _selectedCategory == c,
                        onTap: () => setState(() => _selectedCategory = c),
                      ),
                    ),
              ],
            ),
          ),
          if (_openNow || _familyFriendly || _bikeFriendly)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Wrap(
                spacing: 8,
                children: [
                  if (_openNow) _FilterTag('Open now', () => setState(() => _openNow = false)),
                  if (_familyFriendly)
                    _FilterTag('Family-friendly', () => setState(() => _familyFriendly = false)),
                  if (_bikeFriendly)
                    _FilterTag('Bike-friendly', () => setState(() => _bikeFriendly = false)),
                ],
              ),
            ),
          Expanded(
            child: placesAsync.when(
              loading: () => const AppLoading(message: 'Finding places near you...'),
              error: (_, __) => AppErrorView(
                message: 'Could not load places',
                onRetry: () => ref.invalidate(nearbyPlacesProvider),
              ),
              data: (places) {
                var filtered = places;
                if (_selectedCategory != null) {
                  filtered = filtered.where((p) => p.category == _selectedCategory).toList();
                }
                if (_openNow) filtered = filtered.where((p) => p.isOpen).toList();
                if (_familyFriendly) {
                  filtered = filtered.where((p) => p.isFamilyFriendly).toList();
                }
                if (_bikeFriendly) {
                  filtered = filtered.where((p) => p.isBikeFriendly).toList();
                }

                if (filtered.isEmpty) {
                  return const AppEmptyView(
                    title: 'No places found',
                    subtitle: 'Try adjusting your filters',
                    icon: Icons.location_off,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final place = filtered[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TravelCard(
                        title: place.name,
                        subtitle: place.address,
                        imageUrl: place.imageUrl,
                        rating: place.rating,
                        distance: place.distanceKm != null
                            ? '${place.distanceKm!.toStringAsFixed(1)} km • ${place.travelTimeMinutes ?? 0} min'
                            : null,
                        badge: _categoryLabel(place.category),
                        onTap: () {},
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Filters', style: Theme.of(context).textTheme.titleLarge),
              SwitchListTile(
                title: const Text('Open now'),
                value: _openNow,
                onChanged: (v) => setModalState(() => _openNow = v),
              ),
              SwitchListTile(
                title: const Text('Family-friendly'),
                value: _familyFriendly,
                onChanged: (v) => setModalState(() => _familyFriendly = v),
              ),
              SwitchListTile(
                title: const Text('Bike-friendly'),
                value: _bikeFriendly,
                onChanged: (v) => setModalState(() => _bikeFriendly = v),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                  Navigator.pop(ctx);
                },
                child: const Text('Apply'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _categoryLabel(PlaceCategory c) => switch (c) {
        PlaceCategory.attraction => 'Attractions',
        PlaceCategory.waterfall => 'Waterfalls',
        PlaceCategory.hill => 'Hills',
        PlaceCategory.restaurant => 'Restaurants',
        PlaceCategory.cafe => 'Cafes',
        PlaceCategory.fuelStation => 'Fuel',
        PlaceCategory.evCharging => 'EV',
        PlaceCategory.hotel => 'Hotels',
        PlaceCategory.hospital => 'Hospitals',
        PlaceCategory.bikeGarage => 'Garages',
        PlaceCategory.viewpoint => 'Viewpoints',
      };
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
      ),
    );
  }
}

class _FilterTag extends StatelessWidget {
  const _FilterTag(this.label, this.onRemove);

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onRemove,
    );
  }
}
