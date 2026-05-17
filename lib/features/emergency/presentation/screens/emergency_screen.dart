import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itrip/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency & Safety'),
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _SosButton(),
            const SizedBox(height: 24),
            const Text(
              'Emergency Contacts',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _EmergencyTile('Police', '100', Icons.local_police),
            _EmergencyTile('Ambulance', '108', Icons.medical_services),
            _EmergencyTile('Fire', '101', Icons.fire_truck),
            _EmergencyTile('Highway Helpline', '1033', Icons.directions_car),
            _EmergencyTile('Tourist Helpline', '1363', Icons.tour),
            const SizedBox(height: 24),
            const Text(
              'Nearby Emergency Services',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _EmergencyTile('Nearest Hospital', '2.3 km', Icons.local_hospital, isLocation: true),
            _EmergencyTile('Nearest Police Station', '4.1 km', Icons.local_police, isLocation: true),
            const SizedBox(height: 24),
            Card(
              child: SwitchListTile(
                title: const Text('Live Location Sharing'),
                subtitle: const Text('Share with emergency contacts'),
                value: false,
                onChanged: (_) {},
              ),
            ),
            Card(
              child: SwitchListTile(
                title: const Text('Crash Detection'),
                subtitle: const Text('Auto-alert on sudden impact (beta)'),
                value: false,
                onChanged: (_) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SosButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        HapticFeedback.heavyImpact();
        _callEmergency(context, '112');
      },
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.error,
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sos, color: Colors.white, size: 48),
            SizedBox(height: 8),
            Text(
              'SOS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
            Text(
              'Hold to call 112',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _callEmergency(BuildContext context, String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _EmergencyTile extends StatelessWidget {
  const _EmergencyTile(
    this.title,
    this.subtitle,
    this.icon, {
    this.isLocation = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isLocation;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: isLocation ? AppColors.info : AppColors.error),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: IconButton(
          icon: Icon(isLocation ? Icons.navigation : Icons.phone),
          onPressed: () async {
            if (!isLocation) {
              final uri = Uri.parse('tel:$subtitle');
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            }
          },
        ),
      ),
    );
  }
}
