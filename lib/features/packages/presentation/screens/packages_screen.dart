import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itrip/core/utils/result.dart';
import 'package:itrip/core/widgets/app_loading.dart';
import 'package:itrip/core/widgets/travel_card.dart';
import 'package:itrip/data/repositories/travel_repository.dart';
import 'package:itrip/domain/entities/package_entity.dart';

final packagesProvider = FutureProvider<List<PackageEntity>>((ref) async {
  final result = await ref.read(travelRepositoryProvider).getPackages();
  return result.when(
    success: (data) => data,
    error: (_) => throw Exception('Failed'),
  );
});

class PackagesScreen extends ConsumerWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsync = ref.watch(packagesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tour Packages')),
      body: packagesAsync.when(
        loading: () => const AppLoading(),
        error: (_, __) => const Center(child: Text('Failed to load packages')),
        data: (packages) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: packages.length,
          itemBuilder: (_, i) {
            final pkg = packages[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TravelCard(
                title: pkg.title,
                subtitle: '${pkg.destination} • ${pkg.duration}',
                imageUrl: pkg.imageUrl,
                rating: pkg.rating,
                badge: pkg.type.name,
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${pkg.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showEnquiry(context, pkg),
                      child: const Text('Enquire'),
                    ),
                  ],
                ),
                onTap: () => _showDetails(context, pkg),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, PackageEntity pkg) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(24),
          children: [
            Text(pkg.title, style: Theme.of(context).textTheme.titleLarge),
            Text('₹${pkg.price} • ${pkg.duration}'),
            if (pkg.description != null) ...[
              const SizedBox(height: 16),
              Text(pkg.description!),
            ],
            const SizedBox(height: 16),
            const Text('Inclusions', style: TextStyle(fontWeight: FontWeight.w600)),
            ...pkg.inclusions.map((i) => ListTile(dense: true, leading: const Icon(Icons.check), title: Text(i))),
          ],
        ),
      ),
    );
  }

  void _showEnquiry(BuildContext context, PackageEntity pkg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Enquiry sent for ${pkg.title}')),
    );
  }
}
