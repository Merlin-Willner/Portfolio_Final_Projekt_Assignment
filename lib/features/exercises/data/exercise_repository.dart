import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';

class ExerciseRepository {
  final _collection = FirebaseFirestore.instance.collection('exercises');

  Future<void> addExercise(Exercise exercise) async {
    await _collection.doc(exercise.id).set(exercise.toJson());
  }

  Future<List<Exercise>> getAllExercises() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => Exercise.fromJson(doc.data(), doc.id))
        .toList();
  }
}
