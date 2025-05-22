//Funktioniert, hat nur einen kleinen Bug weil der Satz im Globalen State nicht aktuallisiert wird

import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_coconut/features/exercises/data/exercise_repository.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';
import 'package:project_coconut/features/workouts/cubit/workout_list_cubit.dart';
import 'package:uuid/uuid.dart';

enum ExerciseAddMode { exercise, workout }

class ExerciseFormState extends Equatable {
  const ExerciseFormState({
    this.mode = ExerciseAddMode.exercise,
    this.selectedMuscles = const [],
    this.imageFile,
    this.videoFile,
  });
  final ExerciseAddMode mode;
  final List<String> selectedMuscles;
  final File? imageFile;
  final File? videoFile;

  ExerciseFormState copyWith({
    ExerciseAddMode? mode,
    List<String>? selectedMuscles,
    File? imageFile,
    File? videoFile,
  }) {
    return ExerciseFormState(
      mode: mode ?? this.mode,
      selectedMuscles: selectedMuscles ?? this.selectedMuscles,
      imageFile: imageFile ?? this.imageFile,
      videoFile: videoFile ?? this.videoFile,
    );
  }

  @override
  List<Object?> get props => [mode, selectedMuscles, imageFile, videoFile];
}

class ExerciseFormCubit extends Cubit<ExerciseFormState> {
  ExerciseFormCubit() : super(const ExerciseFormState());

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();

  static const muscleOptions = [
    'Chest',
    'Back',
    'Legs',
    'Shoulders',
    'Biceps',
    'Triceps',
    'Core',
  ];

  final _picker = ImagePicker();
  final _repo = ExerciseRepository();

  void setMode(ExerciseAddMode mode) {
    emit(state.copyWith(mode: mode));
  }

  void toggleMuscle(String muscle) {
    final muscles = List<String>.from(state.selectedMuscles);
    if (muscles.contains(muscle)) {
      muscles.remove(muscle);
    } else {
      muscles.add(muscle);
    }
    emit(state.copyWith(selectedMuscles: muscles));
  }

  Future<void> pickMedia({required bool isImage}) async {
    final picked = isImage
        ? await _picker.pickImage(source: ImageSource.gallery)
        : await _picker.pickVideo(source: ImageSource.gallery);

    if (picked == null) return;
    final file = File(picked.path);
    emit(
      isImage
          ? state.copyWith(imageFile: file)
          : state.copyWith(videoFile: file),
    );
  }

  Future<void> submit(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final exercise = Exercise(
      id: const Uuid().v4(),
      name: nameController.text,
      description: descController.text,
      muscleGroups: state.selectedMuscles,
      imageUrl: state.imageFile?.path,
      videoUrl: state.videoFile?.path,
    );

    await _repo.addExercise(exercise);
    try {
      context.read<WorkoutListCubit>().addExerciseLocally(exercise);
    } catch (_) {}

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exercise saved successfully')),
    );

    nameController.clear();
    descController.clear();
    emit(const ExerciseFormState());
  }
}


/*
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_coconut/features/exercises/data/exercise_repository.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';
import 'package:project_coconut/features/exercises/model/exercise_set_model.dart';
import 'package:project_coconut/features/workouts/cubit/workout_list_cubit.dart';
import 'package:uuid/uuid.dart';

enum ExerciseAddMode { exercise, workout }

class ExerciseFormState extends Equatable {
  const ExerciseFormState({
    this.name = '',
    this.description = '',
    this.selectedMuscles = const [],
    this.imageFile,
    this.videoFile,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final String name;
  final String description;
  final List<String> selectedMuscles;
  final File? imageFile;
  final File? videoFile;
  final bool isSubmitting;
  final String? errorMessage;

  ExerciseFormState copyWith({
    String? name,
    String? description,
    List<String>? selectedMuscles,
    File? imageFile,
    File? videoFile,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return ExerciseFormState(
      name: name ?? this.name,
      description: description ?? this.description,
      selectedMuscles: selectedMuscles ?? this.selectedMuscles,
      imageFile: imageFile ?? this.imageFile,
      videoFile: videoFile ?? this.videoFile,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        name,
        description,
        selectedMuscles,
        imageFile?.path,
        videoFile?.path,
        isSubmitting,
        errorMessage,
      ];
}

class ExerciseFormCubit extends Cubit<ExerciseFormState> {
  final ExerciseRepository _repo;
  final ImagePicker _picker = ImagePicker();
  final formKey = GlobalKey<FormState>();

  ExerciseFormCubit(this._repo) : super(const ExerciseFormState());

  void nameChanged(String value) {
    emit(state.copyWith(name: value, errorMessage: null));
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: value, errorMessage: null));
  }

  static const List<String> muscleOptions = [
    'Chest',
    'Back',
    'Legs',
    'Shoulders',
    'Biceps',
    'Triceps',
    'Core',
  ];
  void toggleMuscle(String muscle) {
    final updated = List<String>.from(state.selectedMuscles);
    updated.contains(muscle) ? updated.remove(muscle) : updated.add(muscle);
    emit(state.copyWith(selectedMuscles: updated, errorMessage: null));
  }

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      emit(state.copyWith(imageFile: File(picked.path)));
    }
  }

  Future<void> pickVideo() async {
    final picked = await _picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      emit(state.copyWith(videoFile: File(picked.path)));
    }
  }

  Future<void> submit(BuildContext context) async {
    if (state.name.isEmpty) {
      emit(state.copyWith(errorMessage: 'Name darf nicht leer sein'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final exercise = Exercise(
        id: const Uuid().v4(),
        name: state.name,
        description: state.description.isEmpty ? null : state.description,
        muscleGroups: state.selectedMuscles,
        imageUrl: state.imageFile?.path,
        videoUrl: state.videoFile?.path,
      );

      await _repo.addExercise(exercise);

      try {
        context.read<WorkoutListCubit>().addExerciseLocally(exercise);
      } catch (_) {}

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exercise saved successfully')),
      );

      emit(const ExerciseFormState());
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }
}
*/