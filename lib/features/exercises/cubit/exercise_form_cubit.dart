import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_coconut/features/exercises/data/exercise_repository.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exercise saved successfully')),
    );

    // Form reset
    nameController.clear();
    descController.clear();
    emit(const ExerciseFormState());
  }
}
