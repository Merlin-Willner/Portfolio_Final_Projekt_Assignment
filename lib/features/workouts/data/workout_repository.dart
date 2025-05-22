import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_coconut/features/workouts/model/workout_model.dart';

class WorkoutRepository {
  final _col = FirebaseFirestore.instance.collection('workouts');

  Future<void> addWorkout(Workout w) async {
    await _col.doc(w.id).set(w.toJson());
  }

  Future<List<Workout>> fetchAll() async {
    final snap = await _col.get();
    return snap.docs.map((d) => Workout.fromJson(d.data(), d.id)).toList();
  }
}
