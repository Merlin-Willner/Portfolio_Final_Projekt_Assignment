import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_coconut/features/exercises/data/exercise_repository.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';
import 'package:project_coconut/features/exercises/model/exercise_set_model.dart';
import 'package:project_coconut/features/workouts/cubit/workout_list_cubit.dart';
import 'package:project_coconut/features/workouts/data/workout_repository.dart';
import 'package:project_coconut/features/workouts/model/workout_model.dart';
import 'package:uuid/uuid.dart';

class WorkoutFormState extends Equatable {
  const WorkoutFormState({
    this.title = '',
    this.description = '',
    this.muscleGroups = const [],
    this.imageFile,
    this.videoFile,
    this.sets = const [],
    this.availableExercises = const [],
    this.isSubmitting = false,
    this.errorMessage,
  });
  final String title;
  final String description;
  final List<String> muscleGroups;
  final File? imageFile;
  final File? videoFile;
  final List<ExerciseSet> sets;
  final List<Exercise> availableExercises;
  final bool isSubmitting;
  final String? errorMessage;
  WorkoutFormState copyWith({
    String? title,
    String? description,
    List<String>? muscleGroups,
    File? imageFile,
    File? videoFile,
    List<ExerciseSet>? sets,
    List<Exercise>? availableExercises,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return WorkoutFormState(
      title: title ?? this.title,
      description: description ?? this.description,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      imageFile: imageFile ?? this.imageFile,
      videoFile: videoFile ?? this.videoFile,
      sets: sets ?? this.sets,
      availableExercises: availableExercises ?? this.availableExercises,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        muscleGroups,
        imageFile?.path,
        videoFile?.path,
        sets,
        availableExercises,
        isSubmitting,
        errorMessage,
      ];
}

class WorkoutFormCubit extends Cubit<WorkoutFormState> {
  WorkoutFormCubit(this._repo, this._exerciseRepo)
      : super(const WorkoutFormState()) {
    _loadExercises();
  }
  final WorkoutRepository _repo;
  final ExerciseRepository _exerciseRepo;
  final ImagePicker _picker = ImagePicker();
  Future<void> _loadExercises() async {
    final list = await _exerciseRepo.fetchAll();
    emit(state.copyWith(availableExercises: list));
  }

  void titleChanged(String t) => emit(state.copyWith(title: t));
  void descriptionChanged(String d) => emit(state.copyWith(description: d));
  void toggleMuscle(String m) {
    final ms = List<String>.from(state.muscleGroups);
    ms.contains(m) ? ms.remove(m) : ms.add(m);
    emit(state.copyWith(muscleGroups: ms));
  }

  Future<void> pickImage() async {
    final p = await _picker.pickImage(source: ImageSource.gallery);
    if (p != null) emit(state.copyWith(imageFile: File(p.path)));
  }

  Future<void> pickVideo() async {
    final p = await _picker.pickVideo(source: ImageSource.gallery);
    if (p != null) emit(state.copyWith(videoFile: File(p.path)));
  }

  void addSet({
    required String exerciseId,
    required SetType type,
    required int valueOfType,
    required int restTime,
    double? weight,
  }) {
    final newSets = List<ExerciseSet>.from(state.sets)
      ..add(
        ExerciseSet(
          exerciseId: exerciseId,
          type: type,
          valueOfType: valueOfType,
          weight: weight,
          restTime: restTime,
        ),
      );
    emit(state.copyWith(sets: newSets));
  }

  void removeSet(int idx) {
    final newSets = List<ExerciseSet>.from(state.sets)..removeAt(idx);
    emit(state.copyWith(sets: newSets));
  }

  void removeSetByExerciseId(String exerciseId) {
    final updated =
        state.sets.where((s) => s.exerciseId != exerciseId).toList();
    emit(state.copyWith(sets: updated));
  }

  Future<void> submitWorkout(BuildContext context) async {
    if (state.title.isEmpty || state.sets.isEmpty) {
      emit(state.copyWith(errorMessage: 'Titel und mindestens 1 Set nötig'));
      return;
    }
    emit(state.copyWith(isSubmitting: true));
    try {
      final w = Workout(
        id: const Uuid().v4(),
        title: state.title,
        description: state.description.isEmpty ? null : state.description,
        imageUrl: state.imageFile?.path,
        videoUrl: state.videoFile?.path,
        muscleGroups: state.muscleGroups,
        sets: state.sets,
      );
      await _repo.addWorkout(w);
      try {
        context.read<WorkoutListCubit>().addLocally(w);
      } catch (_) {}
      emit(const WorkoutFormState()); // Reset
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout saved successfully')),
    );
  }
}
