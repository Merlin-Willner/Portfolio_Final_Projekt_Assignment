import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/features/exercises/cubit/exercise_list_cubit.dart';
import 'package:project_coconut/features/exercises/cubit/exercise_list_state.dart';
import 'package:project_coconut/features/workouts/model/workout_model.dart';
import 'package:project_coconut/features/workouts/view/widgets/set_card.dart';
import 'package:project_coconut/features/workouts/view/workout_action_view.dart';
import 'package:project_coconut/shared/app_bar/modular_app_bar.dart';

class WorkoutDetailView extends StatelessWidget {
  const WorkoutDetailView({required this.workout, super.key});

  final Workout workout;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseListCubit, ExerciseListState>(
      builder: (context, exerciseState) {
        if (exerciseState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final exercises = exerciseState.exercises;

        return Scaffold(
          appBar: ModularAppBar(title: workout.title),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (workout.imageUrl != null)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.file(
                          File(workout.imageUrl!),
                          fit: BoxFit.cover,
                          height: 180,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        workout.description?.trim() ?? '',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const Divider(thickness: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Sets',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              SliverList.builder(
                itemCount: workout.sets.length,
                itemBuilder: (context, index) {
                  final set = workout.sets[index];

                  // look up the matching exercise so you can show its name
                  final exercise = exercises
                      .where((e) => e.id == set.exerciseId)
                      .firstOrNull;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SetCard(
                      set: set,
                      exercise: exercise,
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: FilledButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start workout'),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => WorkoutActionView(workout: workout),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
