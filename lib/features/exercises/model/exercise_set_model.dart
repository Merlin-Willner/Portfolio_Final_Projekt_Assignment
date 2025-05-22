enum SetType {
  reps, // Number of repetitions
  duration, // Duration in seconds
  rir, // Reps in reserve
  weightHold, // Weight hold (e.g., for isometric exercises)
}

class WorkoutSet {
  final String exerciseId;
  final SetType type;
  final int valueOfType; // Context-dependent: reps, seconds, RIR, etc.
  final double? weight; // Optional: for weighted exercises or holds
  final int? restTime; // Optional: rest time in seconds

  WorkoutSet({
    required this.exerciseId,
    required this.type,
    required this.valueOfType,
    this.weight,
    this.restTime,
  });

  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      exerciseId: json['exerciseId']?.toString() ?? '',
      type: SetType.values.firstWhere((e) => e.name == json['type']),
      valueOfType: json['valueOfType'] as int? ?? 0,
      weight: (json['weight'] as num?)?.toDouble(),
      restTime: (json['restTime'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'type': type.name,
      'valueOfType': valueOfType,
      'weight': weight,
      'restTime': restTime,
    };
  }

  // Optional: returns a human-readable label based on type
  String get label {
    switch (type) {
      case SetType.reps:
        return '$valueOfType reps with ${weight != null ? '$weight kg' : 'Bodyweight'}${restTime != null ? ' and $restTime sec rest' : ''}';
      case SetType.duration:
        return 'for $valueOfType seconds with ${weight != null ? '$weight kg' : 'Bodyweight'}${restTime != null ? ' and $restTime sec rest' : ''}';
      case SetType.rir:
        return '$valueOfType RIR with ${weight != null ? '$weight kg' : 'Bodyweight'}${restTime != null ? ' and $restTime sec rest' : ''}';
      case SetType.weightHold:
        return '$valueOfType sec static hold with ${weight != null ? '$weight kg' : 'Bodyweight'}${restTime != null ? ' and $restTime sec rest' : ''}';
    }
  }

  String get typelabel {
    switch (type) {
      case SetType.reps:
        return '$valueOfType reps';
      case SetType.duration:
        return '$valueOfType seconds';
      case SetType.rir:
        return '$valueOfType RIR';
      case SetType.weightHold:
        return '$valueOfType sec static hold';
    }
  }
}
