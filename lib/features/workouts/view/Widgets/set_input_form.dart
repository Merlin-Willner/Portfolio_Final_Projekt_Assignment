import 'package:flutter/material.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';
import 'package:project_coconut/features/exercises/model/exercise_set_model.dart';

class SetInputForm extends StatefulWidget {
  const SetInputForm({
    required this.exercises,
    required this.onAdd,
    super.key,
  });

  final List<Exercise> exercises;
  final void Function(ExerciseSet newSet) onAdd;

  @override
  State<SetInputForm> createState() => _SetInputFormState();
}

class _SetInputFormState extends State<SetInputForm> {
  // local, form-only state
  String? _exerciseId;
  SetType _type = SetType.reps;

  final _valCtrl = TextEditingController();
  final _wtCtrl = TextEditingController();
  final _restCtrl = TextEditingController();

  @override
  void dispose() {
    _valCtrl.dispose();
    _wtCtrl.dispose();
    _restCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_exerciseId == null || _valCtrl.text.trim().isEmpty) return;

    final value = int.tryParse(_valCtrl.text.trim()) ?? 0;
    if (value <= 0) return;

    final weight =
        _wtCtrl.text.trim().isEmpty ? null : double.tryParse(_wtCtrl.text);
    final rest =
        _restCtrl.text.trim().isEmpty ? null : int.tryParse(_restCtrl.text);

    widget.onAdd(
      ExerciseSet(
        exerciseId: _exerciseId!,
        type: _type,
        valueOfType: value,
        weight: weight,
        restTime: rest,
      ),
    );

    _valCtrl.clear();
    _wtCtrl.clear();
    _restCtrl.clear();
    setState(() {
      _type = SetType.reps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Exercise dropdown
            DropdownButtonFormField<String>(
              value: _exerciseId,
              items: widget.exercises
                  .map((e) => DropdownMenuItem(
                        value: e.id,
                        child: Text(e.name),
                      ))
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'Exercise',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _exerciseId = v),
            ),
            const SizedBox(height: 16),

            // Value & Type in one row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _valCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Value',
                      hintText: '10',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<SetType>(
                    value: _type,
                    items: SetType.values
                        .map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(t.name),
                            ))
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (t) => setState(() => _type = t ?? SetType.reps),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Weight
            TextField(
              controller: _wtCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Weight (kg, optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Rest time
            TextField(
              controller: _restCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Rest time (sec, optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Add button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.add),
                label: const Text('Add set'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
