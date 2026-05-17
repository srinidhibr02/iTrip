import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itrip/core/theme/app_colors.dart';
import 'package:itrip/core/utils/result.dart';
import 'package:itrip/core/widgets/gradient_button.dart';
import 'package:itrip/data/repositories/travel_repository.dart';
import 'package:itrip/domain/entities/budget_entity.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  TransportMode _transport = TransportMode.bike;
  BudgetMode _budgetMode = BudgetMode.standard;
  double _distance = 265;
  int _days = 3;
  BudgetEstimateEntity? _estimate;

  Future<void> _calculate() async {
    final result = await ref.read(travelRepositoryProvider).calculateBudget(
          transportMode: _transport,
          budgetMode: _budgetMode,
          distanceKm: _distance,
          durationDays: _days,
        );
    result.when(
      success: (data) => setState(() => _estimate = data),
      error: (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budget Estimator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Transport', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: TransportMode.values.map((t) {
                return ChoiceChip(
                  label: Text(t.name),
                  selected: _transport == t,
                  onSelected: (_) => setState(() => _transport = t),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text('Budget Mode', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<BudgetMode>(
              segments: const [
                ButtonSegment(value: BudgetMode.backpacker, label: Text('Backpacker')),
                ButtonSegment(value: BudgetMode.standard, label: Text('Standard')),
                ButtonSegment(value: BudgetMode.luxury, label: Text('Luxury')),
              ],
              selected: {_budgetMode},
              onSelectionChanged: (s) => setState(() => _budgetMode = s.first),
            ),
            const SizedBox(height: 16),
            Text('Distance: ${_distance.toStringAsFixed(0)} km'),
            Slider(
              value: _distance,
              min: 50,
              max: 1000,
              divisions: 19,
              label: '${_distance.toStringAsFixed(0)} km',
              onChanged: (v) => setState(() => _distance = v),
            ),
            Text('Duration: $_days days'),
            Slider(
              value: _days.toDouble(),
              min: 1,
              max: 14,
              divisions: 13,
              onChanged: (v) => setState(() => _days = v.round()),
            ),
            GradientButton(label: 'Calculate Budget', onPressed: _calculate),
            if (_estimate != null) ...[
              const SizedBox(height: 24),
              _BudgetResult(estimate: _estimate!),
            ],
          ],
        ),
      ),
    );
  }
}

class _BudgetResult extends StatelessWidget {
  const _BudgetResult({required this.estimate});

  final BudgetEstimateEntity estimate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '₹${estimate.totalCost.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const Text('Estimated total cost'),
            const Divider(height: 24),
            ...estimate.breakdown.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key),
                    Text('₹${e.value.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            const Divider(height: 24),
            _Recommendation('Cheapest', estimate.cheapestOption),
            _Recommendation('Fastest', estimate.fastestOption),
            _Recommendation('Best Value', estimate.bestValueOption),
          ],
        ),
      ),
    );
  }
}

class _Recommendation extends StatelessWidget {
  const _Recommendation(this.label, this.value);

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.primary)),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value!, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
