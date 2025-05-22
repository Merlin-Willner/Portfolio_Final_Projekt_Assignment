import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/features/exercises/cubit/exercise_list_cubit.dart';
import 'package:project_coconut/features/exercises/cubit/exercise_list_state.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';
import 'package:project_coconut/features/exercises/model/exercise_set_model.dart';
import 'package:project_coconut/features/exercises/view/exercise_detail_screen.dart';
import 'package:project_coconut/features/workouts/cubit/workout_form_cubit.dart';
import 'package:project_coconut/features/workouts/cubit/workout_list_cubit.dart';

// Displays a single workout-set tile.
class SetCard extends StatelessWidget {
  const SetCard({
    required this.set,
    super.key,
    this.exercise, // optional pre-fetched exercise
  });

  // The set that should be rendered.
  final WorkoutSet set;
  final Exercise? exercise;

  //@override
  //Widget build(BuildContext context) {
  //  // Cubit that manages the workout the user is currently creating / editing.
  //  final formCubit = context.read<WorkoutFormCubit>();
//
  //  // Try to resolve the exercise. Use the provided one or look it up
  //  // in the cached exercise list; fall back to a placeholder if not found.
  //  final exerciseObj = exercise ??
  //      context.read<ExerciseListCubit>().state.exercises.firstWhere(
  //            (e) => e.id == set.exerciseId,
  //            orElse: () => Exercise(
  //              id: set.exerciseId,
  //              name: 'Unknown exercise',
  //              muscleGroups: [],
  //            ),
  //          );
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseListCubit, ExerciseListState>(
      builder: (context, exerciseState) {
        final formCubit = context.read<WorkoutFormCubit>();

        final exerciseObj = exercise ??
            exerciseState.exercises.firstWhere(
              (e) => e.id == set.exerciseId,
              orElse: () => Exercise(
                id: set.exerciseId,
                name: 'Unknown exercise',
                muscleGroups: [],
              ),
            );

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: ListTile(
            // Open the detail screen
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ExerciseDetailScreen(exercise: exerciseObj),
              ),
            ),

            // Exercise name
            title: Text(
              exerciseObj.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),

            // ── Label such as “10 reps” or “30 seconds” ─────────────
            subtitle: Text(
              set.label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            // ── Delete icon ─────────────────────────────────────────
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.onPrimary,
              onPressed: () => formCubit.removeSetByExerciseId(set.exerciseId),
              tooltip: 'Remove set',
            ),
          ),
        );
      },
    );
  }
}
