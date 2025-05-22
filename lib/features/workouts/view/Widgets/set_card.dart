import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/features/exercises/cubit/exercise_list_cubit.dart';
import 'package:project_coconut/features/exercises/cubit/exercise_list_state.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';
import 'package:project_coconut/features/exercises/model/exercise_set_model.dart';
import 'package:project_coconut/features/exercises/view/exercise_detail_screen.dart';
import 'package:project_coconut/features/workouts/cubit/workout_form_cubit.dart';

// Displays a single workout-set tile
class SetCard extends StatelessWidget {
  const SetCard({
    required this.set,
    super.key,
    this.exercise, // optional pre-fetched exercise
  });

  final ExerciseSet set;
  final Exercise? exercise;

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
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ExerciseDetailScreen(exercise: exerciseObj),
              ),
            ),
            title: Text(
              exerciseObj.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              set.label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
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
