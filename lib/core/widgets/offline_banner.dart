import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itrip/core/providers/connectivity_provider.dart';
import 'package:itrip/core/theme/app_colors.dart';

/// Overlays an offline indicator on top of app content.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);

    return Stack(
      children: [
        child,
        if (!isOnline)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Material(
              color: AppColors.warning,
              elevation: 4,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.wifi_off, color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Offline — showing cached data',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
