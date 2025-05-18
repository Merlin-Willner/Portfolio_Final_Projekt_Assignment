import 'package:project_coconut/features/workouts/model/workout_set_model.dart';

class Workout {
  Workout({
    required this.id,
    required this.title,
    required this.sets,
  });

  factory Workout.fromJson(Map<String, dynamic> json, String id) {
    final setsJson = json['sets'] as List<dynamic>;
    return Workout(
      id: id,
      title: json['title'] as String? ?? '',
      sets: setsJson
          .map((s) => WorkoutSet.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;
  final String title;
  final List<WorkoutSet> sets;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'sets': sets.map((s) => s.toJson()).toList(),
    };
  }
}
