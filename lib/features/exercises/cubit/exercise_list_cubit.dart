import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/features/exercises/cubit/exercise_list_state.dart';
import 'package:project_coconut/features/exercises/data/exercise_repository.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';

class ExerciseListCubit extends Cubit<ExerciseListState> {
  final ExerciseRepository _repo;

  ExerciseListCubit(this._repo) : super(const ExerciseListState()) {
    loadAll();
  }
  Future<void> loadAll() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final list = await _repo.fetchAll();
      emit(state.copyWith(isLoading: false, exercises: list));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void addLocally(Exercise e) {
    emit(state.copyWith(exercises: [...state.exercises, e]));
  }
}
