enum SetType {
  reps, // Number of repetitions
  duration, // Duration in seconds
  rir, // Reps in reserve
  weightHold, // Hold a weight statically
}

class WorkoutSet {
  final String exerciseId;
  final SetType type;
  final int valueOfType; // Context-dependent: reps, seconds, RIR, etc.
  final double? weight; // Optional: for weighted exercises or holds

  WorkoutSet({
    required this.exerciseId,
    required this.type,
    required this.valueOfType,
    this.weight,
  });

  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      exerciseId: json['exerciseId']?.toString() ?? '',
      type: SetType.values.firstWhere((e) => e.name == json['type']),
      valueOfType: json['valueOfType'] as int? ?? 0,
      weight: (json['weight'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'type': type.name,
      'valueOfType': valueOfType,
      'weight': weight,
    };
  }

  // Optional: returns a human-readable label based on type
  String get label {
    switch (type) {
      case SetType.reps:
        return '$valueOfType reps';
      case SetType.duration:
        return '$valueOfType seconds';
      case SetType.rir:
        return '$valueOfType RIR';
      case SetType.weightHold:
        return '$valueOfType sec hold with ${weight ?? '?'} kg';
    }
  }
}
