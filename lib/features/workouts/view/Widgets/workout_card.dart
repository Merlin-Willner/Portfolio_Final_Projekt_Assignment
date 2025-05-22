import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_coconut/features/workouts/model/workout_model.dart';
import 'package:project_coconut/features/workouts/view/workout_detail_page.dart';

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({super.key, required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Wrapper so we can capture taps outside the ExpansionTile header
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => WorkoutDetailPage(workout: workout),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _buildImage(),
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                dividerTheme: const DividerThemeData(space: 0, thickness: 0),
              ),
              child: ExpansionTile(
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.title,
                      style: textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      workout.muscleGroups.join(', '),
                      style: textTheme.bodySmall?.copyWith(
                        color: textTheme.bodySmall?.color?..withValues(),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (_hasDescription) ...[
                      const SizedBox(height: 6),
                      Text(
                        workout.description!,
                        style: textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
                trailing: _hasDescription ? null : const SizedBox.shrink(),
                children: _hasDescription
                    ? [
                        const Divider(height: 1),
                        const SizedBox(height: 8),
                        Text(workout.description!, style: textTheme.bodyMedium),
                      ]
                    : [],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _hasDescription =>
      workout.description != null && workout.description!.isNotEmpty;

  Widget _buildImage() {
    if (workout.imageUrl == null) {
      return Image.asset(
        'assets/images/workout_placeholder.jpeg',
        fit: BoxFit.cover,
      );
    }
    final file = File(workout.imageUrl!);
    return file.existsSync()
        ? Image.file(file, fit: BoxFit.cover)
        : Image.asset(
            'assets/images/workout_placeholder.jpeg',
            fit: BoxFit.cover,
          );
  }
}
