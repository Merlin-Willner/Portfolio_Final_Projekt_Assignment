import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';
import 'package:project_coconut/features/exercises/model/exercise_set_model.dart';
import 'package:project_coconut/features/workouts/cubit/workout_form_cubit.dart';
import 'package:project_coconut/features/workouts/view/Widgets/set_card.dart';
import 'package:project_coconut/features/workouts/view/Widgets/set_input_form.dart';

class WorkoutForm extends StatelessWidget {
  const WorkoutForm({super.key});

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
              TextField(
                onChanged: cubit.titleChanged,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                onChanged: cubit.descriptionChanged,
                maxLines: 4,
                decoration:
                    const InputDecoration(labelText: 'Description (opt.)'),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: cubit.pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Pick Image'),
                ),
              ),
              if (state.imageFile != null) ...[
                const SizedBox(height: 8),
                Image.file(
                  state.imageFile!,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ],
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton.icon(
                  onPressed: cubit.pickVideo,
                  icon: const Icon(Icons.video_library),
                  label: const Text('Pick Video'),
                ),
              ),
              if (state.videoFile != null) ...[
                const SizedBox(height: 8),
                Text(
                  state.videoFile!.path.split('/').last,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 16),
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
              SetInputForm(
                exercises: state.availableExercises,
                onAdd: (ExerciseSet set) => cubit.addSet(
                  exerciseId: set.exerciseId,
                  type: set.type,
                  valueOfType: set.valueOfType,
                  weight: set.weight,
                  restTime: set.restTime ?? 0,
                ),
              ),
              const SizedBox(height: 32),
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
