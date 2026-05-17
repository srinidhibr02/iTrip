import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:itrip/core/theme/app_colors.dart';
import 'package:itrip/core/widgets/gradient_button.dart';
import 'package:itrip/domain/entities/trip_entity.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _titleController = TextEditingController();
  final _sourceController = TextEditingController(text: 'Bangalore');
  final _destController = TextEditingController(text: 'Coorg');
  TripType _tripType = TripType.solo;
  TripMode _tripMode = TripMode.leisure;
  int _days = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Trip')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Trip Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _sourceController,
              decoration: const InputDecoration(
                labelText: 'Start Location',
                prefixIcon: Icon(Icons.trip_origin),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _destController,
              decoration: const InputDecoration(
                labelText: 'Destination',
                prefixIcon: Icon(Icons.place),
              ),
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
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Trip created! AI itinerary generating...'),
                    backgroundColor: AppColors.success,
                  ),
                );
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
