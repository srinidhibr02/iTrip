import 'package:flutter/material.dart';
import 'package:itrip/core/theme/app_colors.dart';

/// Map screen — integrate Google Maps with API key from .env
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: Stack(
        children: [
          // Placeholder until GOOGLE_MAPS_API_KEY is configured
          Container(
            color: AppColors.lightGray,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 80, color: AppColors.mediumGray.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'Google Maps',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Add GOOGLE_MAPS_API_KEY to .env and configure\nandroid/iOS manifest to enable maps.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.mediumGray),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.my_location),
                    label: const Text('Use My Location'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Search places, routes...',
                        style: TextStyle(color: AppColors.mediumGray),
                      ),
                    ),
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
