import 'package:equatable/equatable.dart';
import '../model/workout_model.dart';

class WorkoutListState extends Equatable {
  final bool isLoading;
  final List<Workout> workouts;
  final String? error;

  const WorkoutListState({
    this.isLoading = false,
    this.workouts = const [],
    this.error,
  });

  WorkoutListState copyWith({
    bool? isLoading,
    List<Workout>? workouts,
    String? error,
  }) {
    return WorkoutListState(
      isLoading: isLoading ?? this.isLoading,
      workouts: workouts ?? this.workouts,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, workouts, error];
}
