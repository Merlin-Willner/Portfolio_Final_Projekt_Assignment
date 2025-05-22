import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/features/exercises/data/exercise_repository.dart';
import 'package:project_coconut/features/workouts/cubit/workout_form_cubit.dart';
import 'package:project_coconut/features/workouts/data/workout_repository.dart';
import 'package:project_coconut/features/workouts/view/workout_form.dart';

class WorkoutFormPage extends StatelessWidget {
  const WorkoutFormPage({super.key});
  @override
  Widget build(BuildContext ctx) {
    return BlocProvider(
      create: (_) => WorkoutFormCubit(
        WorkoutRepository(),
        ExerciseRepository(),
      ),
      child: const WorkoutForm(),
    );
  }
}
