import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';
import 'package:project_coconut/features/exercises/model/exercise_set_model.dart';
import 'package:project_coconut/features/workouts/view/Widgets/set_card.dart';
import 'package:project_coconut/features/workouts/view/Widgets/set_input_form.dart';
import '../cubit/workout_form_cubit.dart';

class WorkoutForm extends StatelessWidget {
  const WorkoutForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutFormCubit, WorkoutFormState>(
      builder: (context, state) {
        final cubit = context.watch<WorkoutFormCubit>();
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1) Titel
              TextField(
                onChanged: cubit.titleChanged,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),

              // 2) Description
              TextField(
                onChanged: cubit.descriptionChanged,
                maxLines: 4,
                decoration:
                    const InputDecoration(labelText: 'Description (opt.)'),
              ),
              const SizedBox(height: 16),

              // 3) Image Picker
              Center(
                child: ElevatedButton.icon(
                  onPressed: cubit.pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Pick Image'),
                ),
              ),
              if (state.imageFile != null) ...[
                const SizedBox(height: 8),
                Image.file(state.imageFile!,
                    width: double.infinity, height: 180, fit: BoxFit.cover),
              ],
              const SizedBox(height: 12),

              // 4) Video Picker
              Center(
                child: ElevatedButton.icon(
                  onPressed: cubit.pickVideo,
                  icon: const Icon(Icons.video_library),
                  label: const Text('Pick Video'),
                ),
              ),
              if (state.videoFile != null) ...[
                const SizedBox(height: 8),
                Text(state.videoFile!.path.split('/').last,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
              const SizedBox(height: 16),

              // 5) Bestehende Sets
              ...state.sets.map((s) {
                final ex = state.availableExercises.firstWhere(
                  (e) => e.id == s.exerciseId,
                  orElse: () => Exercise(id: '', name: '—', muscleGroups: []),
                );
                return SetCard(
                  set: s,
                  exercise: ex,
                );
              }),

              const SizedBox(height: 24),

              // 6) Add New Set
              SetInputForm(
                exercises: state.availableExercises,
                onAdd: (WorkoutSet set) => cubit.addSet(
                  exerciseId: set.exerciseId,
                  type: set.type,
                  valueOfType: set.valueOfType,
                  weight: set.weight,
                  restTime: set.restTime ?? 0,
                ),
              ),

              const SizedBox(height: 32),

              // 7) Save Workout
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => cubit.submitWorkout(context),
                  icon: const Icon(Icons.save),
                  label: const Text('Save Workout'),
                ),
              ),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  state.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}


/*

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';
import '../cubit/workout_form_cubit.dart';
import '../../exercises/model/exercise_set_model.dart';

class WorkoutForm extends StatefulWidget {
  const WorkoutForm({Key? key}) : super(key: key);

  @override
  State<WorkoutForm> createState() => _WorkoutFormState();
}

class _WorkoutFormState extends State<WorkoutForm> {
  String? _selectedExerciseId;
  SetType _selectedType = SetType.reps;
  final _valueCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();

  @override
  void dispose() {
    _valueCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutFormCubit, WorkoutFormState>(
      builder: (_, state) {
        final cubit = context.read<WorkoutFormCubit>();
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titel & Beschreibung
              TextField(
                onChanged: cubit.titleChanged,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: cubit.descriptionChanged,
                maxLines: 2,
                decoration:
                    const InputDecoration(labelText: 'Description (opt.)'),
              ),
              const SizedBox(height: 16),

              // Dropdown: Übung wählen
              DropdownButtonFormField<String>(
                value: _selectedExerciseId,
                decoration: const InputDecoration(labelText: 'Exercise'),
                items: state.availableExercises
                    .map((e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.name),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedExerciseId = v),
              ),
              const SizedBox(height: 12),

              // SetType
              DropdownButtonFormField<SetType>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Set Type'),
                items: SetType.values
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t.name),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
              ),
              const SizedBox(height: 12),

              // Wert
              TextField(
                controller: _valueCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Value'),
              ),
              const SizedBox(height: 12),

              // Gewicht (opt.)
              TextField(
                controller: _weightCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration:
                    const InputDecoration(labelText: 'Weight (kg) (opt.)'),
              ),
              const SizedBox(height: 16),

              // Add Set
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_selectedExerciseId != null &&
                        _valueCtrl.text.isNotEmpty) {
                      cubit.addSet(
                        exerciseId: _selectedExerciseId!,
                        type: _selectedType,
                        valueOfType: int.parse(_valueCtrl.text),
                        weight: _weightCtrl.text.isEmpty
                            ? null
                            : double.parse(_weightCtrl.text),
                      );
                      _valueCtrl.clear();
                      _weightCtrl.clear();
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Set'),
                ),
              ),

              const SizedBox(height: 24),

              // Bestehende Sets
              ...state.sets.asMap().entries.map((e) {
                final s = e.value;
                final name = state.availableExercises
                    .firstWhere((ex) => ex.id == s.exerciseId,
                        orElse: () =>
                            Exercise(id: '', name: '—', muscleGroups: []))
                    .name;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(name),
                    subtitle: Text(s.label),
                    trailing: Text(
                        s.type == SetType.weightHold || s.type == SetType.reps
                            ? s.weight != null
                                ? '${s.weight}kg'
                                : 'BW'
                            : ''),
                    onLongPress: () => cubit.removeSet(e.key),
                  ),
                );
              }),

              const SizedBox(height: 32),

              // Save Workout
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: cubit.submitWorkout,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Workout'),
                ),
              ),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(state.errorMessage!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
            ],
          ),
        );
      },
    );
  }
}
*/




/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/workout_form_cubit.dart';
import '../model/workout_set_model.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';

class WorkoutFormWidget extends StatefulWidget {
  const WorkoutFormWidget({super.key});
  @override
  _WorkoutFormWidgetState createState() => _WorkoutFormWidgetState();
}

class _WorkoutFormWidgetState extends State<WorkoutFormWidget> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  Exercise? _selExercise;
  SetType? _selType;
  final _valueCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _valueCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkoutFormCubit, WorkoutFormState>(
      listenWhen: (p, c) => p.errorMessage != c.errorMessage,
      listener: (ctx, s) {
        if (s.errorMessage != null) {
          ScaffoldMessenger.of(ctx)
              .showSnackBar(SnackBar(content: Text(s.errorMessage!)));
        }
      },
      child: BlocBuilder<WorkoutFormCubit, WorkoutFormState>(
        builder: (ctx, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Create Workout')),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Titel & Beschreibung
                  TextField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(labelText: 'Titel'),
                    onChanged: ctx.read<WorkoutFormCubit>().titleChanged,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Beschreibung'),
                    onChanged: ctx.read<WorkoutFormCubit>().descriptionChanged,
                  ),
                  const SizedBox(height: 8),

                  // Muskelgruppen
                  Wrap(
                    spacing: 6,
                    children: ['Chest', 'Back', 'Legs', 'Core', 'Shoulders']
                        .map((m) => FilterChip(
                              label: Text(m),
                              selected: state.muscleGroups.contains(m),
                              onSelected: (_) =>
                                  ctx.read<WorkoutFormCubit>().toggleMuscle(m),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),

                  // Bild / Video
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.image),
                        label: const Text('Bild'),
                        onPressed: () =>
                            ctx.read<WorkoutFormCubit>().pickImage(),
                      ),
                      const SizedBox(width: 8),
                      if (state.imageFile != null)
                        Image.file(File(state.imageFile!.path),
                            width: 60, height: 60, fit: BoxFit.cover),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.video_library),
                        label: const Text('Video'),
                        onPressed: () =>
                            ctx.read<WorkoutFormCubit>().pickVideo(),
                      ),
                    ],
                  ),

                  const Divider(height: 24),

                  // Liste existierender Sets
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.sets.length,
                      itemBuilder: (_, i) {
                        final s = state.sets[i];
                        final ex = state.availableExercises
                            .firstWhere((e) => e.id == s.exerciseId);
                        return ListTile(
                          leading: Text(ex.name),
                          title: Text(s.label),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                ctx.read<WorkoutFormCubit>().removeSet(i),
                          ),
                        );
                      },
                    ),
                  ),

                  const Divider(height: 16),

                  // Neues Set hinzufügen
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Übung auswählen
                      DropdownButton<Exercise>(
                        hint: const Text('Übung'),
                        value: _selExercise,
                        items: state.availableExercises.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          );
                        }).toList(),
                        onChanged: (x) => setState(() => _selExercise = x),
                      ),

                      // SetType & Werte
                      Row(
                        children: [
                          DropdownButton<SetType>(
                            hint: const Text('Typ'),
                            value: _selType,
                            items: SetType.values.map((t) {
                              return DropdownMenuItem(
                                value: t,
                                child: Text(t.name),
                              );
                            }).toList(),
                            onChanged: (x) => setState(() => _selType = x),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child: TextField(
                            controller: _valueCtrl,
                            decoration: const InputDecoration(hintText: 'Wert'),
                            keyboardType: TextInputType.number,
                          )),
                          const SizedBox(width: 8),
                          Expanded(
                              child: TextField(
                            controller: _weightCtrl,
                            decoration:
                                const InputDecoration(hintText: 'Gewicht'),
                            keyboardType: TextInputType.number,
                          )),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: (_selExercise != null &&
                                    _selType != null)
                                ? () {
                                    final set = WorkoutSet(
                                      exerciseId: _selExercise!.id,
                                      type: _selType!,
                                      valueOfType: int.parse(_valueCtrl.text),
                                      weight: _weightCtrl.text.isEmpty
                                          ? null
                                          : double.parse(_weightCtrl.text),
                                    );
                                    ctx.read<WorkoutFormCubit>().addSet(set);
                                    // Felder zurücksetzen
                                    setState(() {
                                      _selExercise = null;
                                      _selType = null;
                                      _valueCtrl.clear();
                                      _weightCtrl.clear();
                                    });
                                  }
                                : null,
                            child: const Text('Add Set'),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Save Workout
                  ElevatedButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () => ctx.read<WorkoutFormCubit>().submit(),
                    child: state.isSubmitting
                        ? const CircularProgressIndicator()
                        : const Text('Save Workout'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
*/