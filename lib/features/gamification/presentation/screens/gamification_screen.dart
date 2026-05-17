import 'package:flutter/material.dart';
import 'package:itrip/core/theme/app_colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class GamificationScreen extends StatelessWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    CircularPercentIndicator(
                      radius: 50,
                      lineWidth: 8,
                      percent: 0.65,
                      center: const Text('Lv 5', style: TextStyle(fontWeight: FontWeight.w800)),
                      progressColor: AppColors.primary,
                      backgroundColor: AppColors.lightGray,
                    ),
                    const SizedBox(width: 24),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Road Explorer', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                          Text('650 / 1000 XP to Level 6'),
                          SizedBox(height: 8),
                          Text('1,240 miles traveled'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Badges Earned', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: const [
                _BadgeItem('🏔️', 'Ghat Master', true),
                _BadgeItem('🛣️', 'Highway Hero', true),
                _BadgeItem('☕', 'Dhaba Explorer', true),
                _BadgeItem('🌧️', 'Monsoon Rider', true),
                _BadgeItem('⭐', 'Top Reviewer', false),
                _BadgeItem('🗺️', 'Coast to Coast', false),
              ],
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Leaderboard', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
            ...List.generate(5, (i) {
              return ListTile(
                leading: CircleAvatar(child: Text('${i + 1}')),
                title: Text('Traveler${i + 1}'),
                subtitle: Text('${(5 - i) * 320} miles'),
                trailing: Text('#${i + 1}', style: const TextStyle(fontWeight: FontWeight.w700)),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _BadgeItem extends StatelessWidget {
  const _BadgeItem(this.emoji, this.label, this.earned);

  final String emoji;
  final String label;
  final bool earned;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: earned ? null : AppColors.lightGray.withValues(alpha: 0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: TextStyle(fontSize: earned ? 32 : 24, color: earned ? null : Colors.grey)),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: earned ? null : AppColors.mediumGray,
            ),
          ),
        ],
      ),
    );
  }
}
