class Exercise {
  Exercise({
    required this.id,
    required this.name,
    required this.muscleGroups,
    this.description,
    this.imageUrl,
    this.videoUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json, String id) {
    return Exercise(
      id: id,
      name: json['name']?.toString() ?? '',
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      muscleGroups:
          List<String>.from((json['muscleGroups'] as List<dynamic>?) ?? []),
    );
  }
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? videoUrl;
  final List<String> muscleGroups;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'muscleGroups': muscleGroups,
    };
  }
}
