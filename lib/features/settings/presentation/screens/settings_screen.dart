import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itrip/core/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Appearance'),
            subtitle: Text('Theme'),
          ),
          ...ThemeMode.values.map((mode) {
            return RadioListTile<ThemeMode>(
              title: Text(_themeLabel(mode)),
              value: mode,
              groupValue: themeMode,
              onChanged: (v) {
                if (v != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(v);
                }
              },
            );
          }),
          const Divider(),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Trip alerts, weather, hazards'),
            value: true,
            onChanged: (_) {},
          ),
          SwitchListTile(
            title: const Text('Location Services'),
            subtitle: const Text('Required for nearby discovery'),
            value: true,
            onChanged: (_) {},
          ),
          SwitchListTile(
            title: const Text('Offline Maps'),
            subtitle: const Text('Download maps for offline use'),
            value: false,
            onChanged: (_) {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About iTrip'),
            subtitle: const Text('Version 1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode) => switch (mode) {
        ThemeMode.system => 'System default',
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
      };
}
