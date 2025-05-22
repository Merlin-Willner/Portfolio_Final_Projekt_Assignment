import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/features/exercises/cubit/exercise_list_cubit.dart';
import 'package:project_coconut/features/exercises/cubit/exercise_list_state.dart';
import 'package:project_coconut/shared/app_bar/modular_app_bar.dart';

class ExerciseListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ModularAppBar(title: 'Your Exercises'),
      body: BlocBuilder<ExerciseListCubit, ExerciseListState>(
        builder: (context, state) {
          if (state.isLoading)
            return const Center(child: CircularProgressIndicator());
          if (state.error != null) return Center(child: Text(state.error!));
          return ListView.builder(
            itemCount: state.exercises.length,
            itemBuilder: (_, i) {
              final ex = state.exercises[i];
              return ListTile(
                title: Text(ex.name),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/exercise_detail',
                    arguments: ex,
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add_exercise');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
