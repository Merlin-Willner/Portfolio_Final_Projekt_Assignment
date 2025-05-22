import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/features/exercises/exercises.dart';
import 'package:project_coconut/features/workouts/view/workout_form_page.dart';
import 'package:project_coconut/shared/app_bar/modular_app_bar.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExerciseFormCubit(),
      child: const _AddView(),
    );
  }
}

class _AddView extends StatelessWidget {
  const _AddView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ModularAppBar(title: 'Create'),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Exercise'),
                Tab(text: 'Workout'),
              ],
            ),
            Divider(height: 1),
            Expanded(
              child: TabBarView(
                children: [
                  ExerciseForm(),
                  WorkoutFormPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
