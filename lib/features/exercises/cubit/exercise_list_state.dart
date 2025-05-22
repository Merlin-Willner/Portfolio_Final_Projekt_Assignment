import 'package:equatable/equatable.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';

class ExerciseListState extends Equatable {
  final bool isLoading;
  final List<Exercise> exercises;
  final String? error;
  const ExerciseListState({
    this.isLoading = false,
    this.exercises = const [],
    this.error,
  });

  ExerciseListState copyWith({
    bool? isLoading,
    List<Exercise>? exercises,
    String? error,
  }) {
    return ExerciseListState(
      isLoading: isLoading ?? this.isLoading,
      exercises: exercises ?? this.exercises,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, exercises, error];
}
