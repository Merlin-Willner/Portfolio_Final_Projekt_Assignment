import 'package:flutter/material.dart';
import 'package:project_coconut/features/exercises/model/exercise_set_model.dart';
import '../../../exercises/model/exercise_model.dart';
/*
class SetCard extends StatelessWidget {
  final WorkoutSet set;
  final Exercise exercise;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const SetCard({
    Key? key,
    required this.set,
    required this.exercise,
    this.onDelete,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: {
    Navigator.of(context).pushNamed(
      ExerciseDetailScreen
    );
  },
        title: Text(
          exercise.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          set.label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_coconut/features/workouts/cubit/workout_form_cubit.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';
import 'package:project_coconut/features/exercises/cubit/exercise_form_cubit.dart';
import 'package:project_coconut/features/exercises/view/exercise_detail_screen.dart';

class SetCard extends StatelessWidget {
  /// Der Satz, den wir hier anzeigen
  final WorkoutSet set;

  /// Optional: Wenn du schon das zugehörige Exercise-Objekt kennst,
  /// kannst du es direkt mitliefern.
  /// Andernfalls wird es über den ExerciseCubit nachgeladen.
  final Exercise? exercise;

  const SetCard({
    Key? key,
    required this.set,
    this.exercise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1) Den WorkoutFormCubit zum Entfernen nutzen:
    final formCubit = context.read<WorkoutCubit>();

    // 2) Falls wir das Exercise-Objekt nicht mitbekommen haben,
    //    laden wir es nach über einen ExerciseCubit/Repository:
    final exerciseObj = exercise ??
        context
            .read<ExerciseCubit>()
            .state
            .exercises
            .firstWhere((e) => e.id == set.exerciseId);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        /// 3) Tap → direkt zum Detail-Screen mit Navigator.push
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ExerciseDetailScreen(exercise: exerciseObj),
          ));
        },

        /// 4) Titel: Übungsname
        title: Text(
          exerciseObj.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),

        /// 5) Subtitle: Dein Label ("10 reps", "30 seconds", ...)
        subtitle: Text(
          set.label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        /// 6) Trailing: Mülltonne zum Löschen des Satzes
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          color: Theme.of(context).colorScheme.error,
          onPressed: () {
            formCubit.removeSetByExerciseId(set.exerciseId);
          },
        ),
      ),
    );
  }
}
*/

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_coconut/features/workouts/cubit/workout_form_cubit.dart';

import 'package:project_coconut/features/exercises/cubit/exercise_list_cubit.dart';
import 'package:project_coconut/features/exercises/view/exercise_detail_screen.dart';

/// Displays a single workout-set tile.
/// ─────────────────────────────────────────────────────────────
/// * Shows the exercise name + a label such as “12 reps”.
/// * Opens the exercise-detail screen on tap.
/// * Provides a delete-icon to remove the set from the form.
class SetCard extends StatelessWidget {
  const SetCard({
    Key? key,
    required this.set,
    this.exercise, // optional pre-fetched exercise
  }) : super(key: key);

  /// The set that should be rendered.
  final WorkoutSet set;

  /// Optional: pass the exercise object if already available.
  final Exercise? exercise;

  @override
  Widget build(BuildContext context) {
    // Cubit that manages the workout the user is currently creating / editing.
    final formCubit = context.read<WorkoutFormCubit>();

    // Try to resolve the exercise. Use the provided one or look it up
    // in the cached exercise list; fall back to a placeholder if not found.
    final Exercise exerciseObj = exercise ??
        context.read<ExerciseListCubit>().state.exercises.firstWhere(
              (e) => e.id == set.exerciseId,
              orElse: () => Exercise(
                id: set.exerciseId,
                name: 'Unknown exercise',
                muscleGroups: [],
              ),
            );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        // ── Open the detail screen ────────────────────────────────
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ExerciseDetailScreen(exercise: exerciseObj),
          ),
        ),

        // ── Exercise name ────────────────────────────────────────
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
  }
}
