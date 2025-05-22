import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/features/exercises/cubit/exercise_list_cubit.dart';
import 'package:project_coconut/features/exercises/data/exercise_repository.dart';
import 'package:project_coconut/features/workouts/cubit/workout_form_cubit.dart';
import 'package:project_coconut/features/workouts/data/workout_repository.dart';
import 'package:project_coconut/features/workouts/model/workout_model.dart';
import 'package:project_coconut/features/workouts/view/workout_detail_view.dart';

class WorkoutDetailPage extends StatelessWidget {
  const WorkoutDetailPage({required this.workout, super.key});
  final Workout workout;
  @override
  Widget build(BuildContext ctx) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => WorkoutFormCubit(
            WorkoutRepository(),
            ExerciseRepository(),
          ),
        ),
        BlocProvider.value(
          value: ctx.read<ExerciseListCubit>(),
        ),
      ],
      child: WorkoutDetailView(workout: workout),
    );
  }
}
