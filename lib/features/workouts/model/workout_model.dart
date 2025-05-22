import 'package:equatable/equatable.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';
import '../../exercises/model/exercise_set_model.dart';

class Workout extends Equatable {
  const Workout({
    required this.id,
    required this.title,
    this.imageUrl,
    this.videoUrl,
    this.description,
    this.muscleGroups = const [],
    this.sets = const [],
  });

  factory Workout.fromJson(Map<String, dynamic> json, String id) {
    final setsJson = json['sets'] as List<dynamic>? ?? [];
    return Workout(
      id: id,
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      description: json['description'] as String?,
      muscleGroups: (json['muscleGroups'] is List
          ? List<String>.from(json['muscleGroups'] as List<dynamic>)
          : []),
      sets: setsJson
          .map((s) => ExerciseSet.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
  final String id;
  final String title;
  final String? imageUrl;
  final String? videoUrl;
  final String? description;
  final List<String> muscleGroups;
  final List<ExerciseSet> sets;
  Map<String, dynamic> toJson() => {
        'title': title,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
        'description': description,
        'muscleGroups': muscleGroups,
        'sets': sets.map((s) => s.toJson()).toList(),
      };

  @override
  List<Object?> get props =>
      [id, title, imageUrl, videoUrl, description, muscleGroups, sets];
}
