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
  final String title;
  final String description;
  final List<String> muscleGroups;
  final File? imageFile;
  final File? videoFile;
  final List<WorkoutSet> sets;
  final List<Exercise> availableExercises;
  final bool isSubmitting;
  final String? errorMessage;

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

  WorkoutFormState copyWith({
    String? title,
    String? description,
    List<String>? muscleGroups,
    File? imageFile,
    File? videoFile,
    List<WorkoutSet>? sets,
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
  final WorkoutRepository _repo;
  final ExerciseRepository _exerciseRepo;
  final ImagePicker _picker = ImagePicker();

  WorkoutFormCubit(this._repo, this._exerciseRepo)
      : super(const WorkoutFormState()) {
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    final list = await _exerciseRepo.fetchAll(); //TODO: Better make that global
    emit(state.copyWith(availableExercises: list));
  }

  void titleChanged(String t) =>
      emit(state.copyWith(title: t, errorMessage: null));
  void descriptionChanged(String d) =>
      emit(state.copyWith(description: d, errorMessage: null));
  void toggleMuscle(String m) {
    final ms = List<String>.from(state.muscleGroups);
    ms.contains(m) ? ms.remove(m) : ms.add(m);
    emit(state.copyWith(muscleGroups: ms, errorMessage: null));
  }

  Future<void> pickImage() async {
    final p = await _picker.pickImage(source: ImageSource.gallery);
    if (p != null) emit(state.copyWith(imageFile: File(p.path)));
  }

  Future<void> pickVideo() async {
    final p = await _picker.pickVideo(source: ImageSource.gallery);
    if (p != null) emit(state.copyWith(videoFile: File(p.path)));
  }

  /// Fügt einen neuen Satz, basierend auf den UI-Feldern, hinzu
  void addSet({
    required String exerciseId,
    required SetType type,
    required int valueOfType,
    required int restTime,
    double? weight,
  }) {
    final newSets = List<WorkoutSet>.from(state.sets)
      ..add(
        WorkoutSet(
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
    final newSets = List<WorkoutSet>.from(state.sets)..removeAt(idx);
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
    emit(state.copyWith(isSubmitting: true, errorMessage: null));
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
        // ignore if provider not found
        // (e.g. unit tests or other isolated contexts)
        // ignore: use_build_context_synchronously
        context.read<WorkoutListCubit>().addLocally(w);
      } catch (_) {}
      emit(const WorkoutFormState()); // Reset
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }
}
