/// home/view/home_workouts_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/features/exercises/cubit/exercise_list_cubit.dart';
import 'package:project_coconut/features/exercises/cubit/exercise_list_state.dart';
import 'package:project_coconut/shared/app_bar/modular_sliver_app_bar.dart';
import '../cubit/workout_list_cubit.dart';
import '../cubit/workout_list_state.dart';
import 'widgets/workout_card.dart';

class WorkoutListView extends StatelessWidget {
  const WorkoutListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkoutListCubit, WorkoutListState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Center(
              child: Text(state.error!,
                  style: const TextStyle(color: Colors.red)));
        }

        // ---------- ONE scroll view, no nesting ----------
        return CustomScrollView(
          slivers: [
            ModularSliverAppBar(
              title: 'Workouts',
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              sliver: SliverList.separated(
                itemCount: state.workouts.length,
                itemBuilder: (context, i) =>
                    WorkoutCard(workout: state.workouts[i]),
                separatorBuilder: (context, _) => const SizedBox(height: 12),
              ),
            ),
          ],
        );
      },
    );
  }
}
