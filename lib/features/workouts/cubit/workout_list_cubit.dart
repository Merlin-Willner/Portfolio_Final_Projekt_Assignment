import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';
import 'package:project_coconut/features/workouts/cubit/workout_list_state.dart';
import 'package:project_coconut/features/workouts/data/workout_repository.dart';
import 'package:project_coconut/features/workouts/model/workout_model.dart';

class WorkoutListCubit extends Cubit<WorkoutListState> {
  WorkoutListCubit(this._repo) : super(const WorkoutListState()) {
    loadAll();
  }
  final WorkoutRepository _repo;
  Future<void> loadAll() async {
    emit(state.copyWith(isLoading: true));
    try {
      final list = await _repo.fetchAll();
      emit(state.copyWith(isLoading: false, workouts: list));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void addLocally(Workout w) {
    emit(state.copyWith(workouts: [...state.workouts, w]));
  }

  void addExerciseLocally(Exercise exercise) {}
}
