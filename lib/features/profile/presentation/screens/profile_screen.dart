import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:itrip/core/constants/route_paths.dart';
import 'package:itrip/core/theme/app_colors.dart';
import 'package:itrip/core/providers/guest_mode_provider.dart';
import 'package:itrip/data/repositories/auth_repository.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(RoutePaths.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: Text(
                (user?.displayName ?? user?.email ?? 'G')[0].toUpperCase(),
                style: const TextStyle(fontSize: 36, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.displayName ?? 'Guest Traveler',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Text(
              user?.email ?? 'demo@itrip.app',
              style: TextStyle(color: AppColors.mediumGray),
            ),
            const SizedBox(height: 24),
            _StatsRow(),
            const SizedBox(height: 24),
            _MenuTile(
              icon: Icons.emoji_events,
              title: 'Achievements & Badges',
              onTap: () => context.push(RoutePaths.gamification),
            ),
            _MenuTile(
              icon: Icons.favorite_border,
              title: 'Saved Places',
              onTap: () {},
            ),
            _MenuTile(
              icon: Icons.history,
              title: 'Trip History',
              onTap: () => context.go(RoutePaths.tripPlanner),
            ),
            _MenuTile(
              icon: Icons.group,
              title: 'Travel Groups',
              onTap: () {},
            ),
            _MenuTile(
              icon: Icons.offline_bolt,
              title: 'Offline Mode',
              onTap: () {},
            ),
            const Divider(),
            _MenuTile(
              icon: Icons.logout,
              title: 'Sign Out',
              onTap: () async {
                await ref.read(authRepositoryProvider).signOut();
                await ref.read(guestModeProvider.notifier).disableGuestMode();
                if (context.mounted) context.go(RoutePaths.login);
              },
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem('1,240', 'Miles'),
          _StatItem('12', 'Trips'),
          _StatItem('Lv 5', 'Explorer'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem(this.value, this.label);

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        Text(label, style: TextStyle(color: AppColors.mediumGray, fontSize: 12)),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? AppColors.error : null),
      title: Text(
        title,
        style: TextStyle(color: isDestructive ? AppColors.error : null),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
