import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/workout_form_cubit.dart';
import '../data/workout_repository.dart';
import 'workout_form.dart';
import 'package:project_coconut/features/exercises/data/exercise_repository.dart';

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
