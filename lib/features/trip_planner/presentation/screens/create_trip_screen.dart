import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:itrip/core/providers/user_id_provider.dart';
import 'package:itrip/core/theme/app_colors.dart';
import 'package:itrip/core/utils/result.dart';
import 'package:itrip/core/widgets/gradient_button.dart';
import 'package:itrip/data/repositories/travel_repository.dart';
import 'package:itrip/domain/entities/trip_entity.dart';
import 'package:itrip/features/trip_planner/presentation/screens/trip_planner_screen.dart';

class CreateTripScreen extends ConsumerStatefulWidget {
  const CreateTripScreen({super.key});

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _sourceController = TextEditingController(text: 'Bangalore');
  final _destController = TextEditingController(text: 'Coorg');
  TripType _tripType = TripType.solo;
  TripMode _tripMode = TripMode.leisure;
  int _days = 3;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _sourceController.dispose();
    _destController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final userId = ref.read(currentUserIdProvider);
    final result = await ref.read(travelRepositoryProvider).createTrip(
          userId: userId,
          title: _titleController.text,
          source: _sourceController.text,
          destination: _destController.text,
          tripType: _tripType,
          tripMode: _tripMode,
          days: _days,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.when(
      success: (trip) {
        ref.invalidate(tripsProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trip created with AI itinerary!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go('/trip/${trip.id}');
      },
      error: (f) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(f.message), backgroundColor: AppColors.error),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Trip')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Trip Title (optional)',
                  hintText: 'e.g. Coorg Monsoon Escape',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sourceController,
                decoration: const InputDecoration(
                  labelText: 'Start Location',
                  prefixIcon: Icon(Icons.trip_origin),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _destController,
                decoration: const InputDecoration(
                  labelText: 'Destination',
                  prefixIcon: Icon(Icons.place),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              Text('Trip Type', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: TripType.values.map((t) {
                  return ChoiceChip(
                    label: Text(t.name),
                    selected: _tripType == t,
                    onSelected: (_) => setState(() => _tripType = t),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text('Trip Mode', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: TripMode.values.map((m) {
                  return ChoiceChip(
                    label: Text(m.name),
                    selected: _tripMode == m,
                    onSelected: (_) => setState(() => _tripMode = m),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text('Duration: $_days days'),
              Slider(
                value: _days.toDouble(),
                min: 1,
                max: 14,
                divisions: 13,
                label: '$_days days',
                onChanged: (v) => setState(() => _days = v.round()),
              ),
              const SizedBox(height: 24),
              GradientButton(
                label: 'Create Trip with AI',
                icon: Icons.auto_awesome,
                isLoading: _isLoading,
                onPressed: _create,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
