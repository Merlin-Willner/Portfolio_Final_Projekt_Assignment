// lib/features/workouts/view/workout_detail_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/features/exercises/model/exercise_set_model.dart';
import 'package:project_coconut/features/workouts/view/workout_action_view.dart';

import '../../exercises/cubit/exercise_list_cubit.dart';
import '../../exercises/model/exercise_model.dart';
import '../../exercises/view/exercise_detail_screen.dart';
import '../model/workout_model.dart';
import 'widgets/set_card.dart';

class WorkoutDetailView extends StatelessWidget {
  const WorkoutDetailView({super.key, required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    final exercises = context.watch<ExerciseListCubit>().state.exercises;

    return Scaffold(
      appBar: AppBar(title: Text(workout.title)),
      body: CustomScrollView(
        slivers: [
          // ── Header with cover-image & description ──────────────
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
                      // change to Image.network if you store URLs
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

          // ── List of SetCards (lazy) ────────────────────────────
          SliverList.builder(
            itemCount: workout.sets.length,
            itemBuilder: (context, index) {
              final WorkoutSet set = workout.sets[index];

              // look up the matching exercise so you can show its name
              final Exercise? exercise =
                  exercises.where((e) => e.id == set.exerciseId).firstOrNull;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: FilledButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start workout'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
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
  }
}
