import 'package:flutter/material.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';
import 'package:project_coconut/features/exercises/model/exercise_set_model.dart';

class SetInputForm extends StatefulWidget {
  const SetInputForm({
    super.key,
    required this.exercises,
    required this.onAdd,
  });

  final List<Exercise> exercises;
  final void Function(WorkoutSet newSet) onAdd;

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

    final int value = int.tryParse(_valCtrl.text.trim()) ?? 0;
    if (value <= 0) return;

    final double? weight =
        _wtCtrl.text.trim().isEmpty ? null : double.tryParse(_wtCtrl.text);
    final int? rest =
        _restCtrl.text.trim().isEmpty ? null : int.tryParse(_restCtrl.text);

    widget.onAdd(
      WorkoutSet(
        exerciseId: _exerciseId!,
        type: _type,
        valueOfType: value,
        weight: weight,
        restTime: rest,
      ),
    );

    // clear inputs but keep the selected exercise (UX preference)
    _valCtrl.clear();
    _wtCtrl.clear();
    _restCtrl.clear();
    setState(() {
      _type = SetType.reps;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ------------ Exercise dropdown ------------
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

            // ------------ Value & Type in one row -------
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

            // ------------ Weight ------------------------
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

            // ------------ Rest time ---------------------
            TextField(
              controller: _restCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Rest time (sec, optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // ------------ Add button --------------------
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




/*

import 'package:flutter/material.dart';
import 'package:project_coconut/features/exercises/model/exercise_set_model.dart';
import '../../../exercises/model/exercise_model.dart';

class SetInputForm extends StatefulWidget {
  final List<Exercise> exercises;
  final void Function(WorkoutSet newSet) onAdd;

  const SetInputForm({
    Key? key,
    required this.exercises,
    required this.onAdd,
  }) : super(key: key);

  @override
  State<SetInputForm> createState() => _SetInputFormState();
}

class _SetInputFormState extends State<SetInputForm> {
  String? _exerciseId;
  SetType _type = SetType.reps;
  final _valueController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _valueController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_exerciseId == null || _valueController.text.isEmpty) return;
    final int val = int.tryParse(_valueController.text) ?? 0;
    final double? wt = _weightController.text.isEmpty
        ? null
        : double.tryParse(_weightController.text);
    final newSet = WorkoutSet(
      exerciseId: _exerciseId!,
      type: _type,
      valueOfType: val,
      weight: wt,
      restTime: 0,
    );
    widget.onAdd(newSet);
    _valueController.clear();
    _weightController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Übungsauswahl
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Exercise'),
          items: widget.exercises
              .map((e) => DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                  ))
              .toList(),
          value: _exerciseId,
          onChanged: (v) => setState(() => _exerciseId = v),
        ),
        const SizedBox(height: 8),

        // SetType–Dropdown
        DropdownButtonFormField<SetType>(
          decoration: const InputDecoration(labelText: 'Type'),
          items: SetType.values
              .map((t) => DropdownMenuItem(
                    value: t,
                    child: Text(t.name),
                  ))
              .toList(),
          value: _type,
          onChanged: (v) => setState(() => _type = v!),
        ),
        const SizedBox(height: 8),

        // Wert und optional Gewicht
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _valueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Value'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _weightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Weight (opt.)'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Center(
          child: ElevatedButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.add),
            label: const Text('Add Set'),
          ),
        ),
      ],
    );
  }
}
*/
/* Does not work properly Add Button is only working once
import 'package:flutter/material.dart';
import 'package:project_coconut/features/exercises/model/exercise_set_model.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';

class SetInputForm extends StatefulWidget {
  const SetInputForm({
    super.key,
    required this.exercises,
    required this.onAdd,
  });

  final List<Exercise> exercises;
  final void Function(WorkoutSet newSet) onAdd;

  @override
  State<SetInputForm> createState() => _SetInputFormState();
}

class _SetInputFormState extends State<SetInputForm> {
  String? _exerciseId;
  SetType _type = SetType.reps;

  final _valueCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _restCtrl = TextEditingController();

  @override
  void dispose() {
    _valueCtrl.dispose();
    _weightCtrl.dispose();
    _restCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_exerciseId == null || _valueCtrl.text.trim().isEmpty) return;

    final val = int.tryParse(_valueCtrl.text) ?? 0;
    if (val <= 0) return;

    final wt =
        _weightCtrl.text.isEmpty ? null : double.tryParse(_weightCtrl.text);
    final rest = _restCtrl.text.isEmpty ? null : int.tryParse(_restCtrl.text);

    final newSet = WorkoutSet(
      exerciseId: _exerciseId!,
      type: _type,
      valueOfType: val,
      weight: wt,
      restTime: rest, // ⬅ requires `restTime` field in model
    );

    widget.onAdd(newSet);

    // reset inputs
    _valueCtrl.clear();
    _weightCtrl.clear();
    _restCtrl.clear();
    setState(() {
      _type = SetType.reps;
      _exerciseId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Exercise selector -----------------------------
            DropdownMenu<String>(
              hintText: 'Exercise',
              width: double.infinity,
              dropdownMenuEntries: widget.exercises
                  .map((e) => DropdownMenuEntry(value: e.id, label: e.name))
                  .toList(),
              onSelected: (v) => setState(() => _exerciseId = v),
              initialSelection: _exerciseId,
            ),
            const SizedBox(height: 12),

            // value + type row ------------------------------
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _valueCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Value',
                      hintText: '10',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownMenu<SetType>(
                    dropdownMenuEntries: SetType.values
                        .map((t) => DropdownMenuEntry(
                              value: t,
                              label: t.name,
                            ))
                        .toList(),
                    onSelected: (t) =>
                        setState(() => _type = t ?? SetType.reps),
                    initialSelection: _type,
                    hintText: 'Type',
                    width: double.infinity,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // weight row ------------------------------------
            TextField(
              controller: _weightCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Weight (kg) – optional',
                hintText: 'e.g. 20',
              ),
            ),
            const SizedBox(height: 12),

            // rest time row ---------------------------------
            TextField(
              controller: _restCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Rest time (sec) – optional',
                hintText: '60',
              ),
            ),
            const SizedBox(height: 16),

            // add button ------------------------------------
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.add),
              label: const Text('Add set'),
            ),
          ],
        ),
      ),
    );
  }
}
*/