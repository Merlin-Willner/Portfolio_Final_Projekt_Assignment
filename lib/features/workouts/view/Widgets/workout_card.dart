// lib/features/workouts/view/widgets/workout_card.dart
import 'dart:io';
/*
import 'package:flutter/material.dart';
import 'package:project_coconut/features/workouts/model/workout_model.dart';

class WorkoutCard extends StatefulWidget {
  const WorkoutCard({
    super.key,
    required this.workout,
    required this.onCardTap,
  });

  final Workout workout;
  final VoidCallback onCardTap;

  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    // ------------------------------------------------ image ---------------
    Widget thumb;
    if (widget.workout.imageUrl == null) {
      thumb = Image.asset('assets/images/workout_placeholder.png',
          height: 180, width: double.infinity, fit: BoxFit.cover);
    } else {
      thumb = Image.file(
        File(widget.workout.imageUrl!),
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
            'assets/images/workout_placeholder.png',
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover),
      );
    }

    // ------------------------------------------------ description ----------
    final desc = widget.workout.description ?? '';
    final descWidget = desc.isEmpty
        ? const SizedBox.shrink()
        : Text(
            desc,
            maxLines: _expanded ? null : 1,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: t.textTheme.bodyLarge,
          );

    // ------------------------------------------------ card -----------------
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        // Whole card (except pill) opens detail
        onTap: widget.onCardTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title
              Text(
                widget.workout.title,
                style: t.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),

              // full-width image
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: thumb,
              ),
              const SizedBox(height: 12),

              // description (collapsed)
              descWidget,
              const SizedBox(height: 8),

              // show-more pill
              Center(
                child: Material(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _expanded ? 'Show less' : 'Show more',
                            style: t.textTheme.labelLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            _expanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
/// features/workouts/view/widgets/workout_card.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_coconut/features/workouts/view/workout_detail_page.dart';
import 'package:project_coconut/features/workouts/view/workout_detail_view.dart';
import '../../model/workout_model.dart';

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({super.key, required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Wrapper so we can capture taps outside the ExpansionTile header.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => WorkoutDetailPage(workout: workout),
        ),
      ),

      //Navigator.of(context)
      //  .pushNamed('/workout/detail', arguments: workout),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- full-width image ----------
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _buildImage(),
              ),
            ),

            // ---------- expandable section ----------
            Theme(
              // shrink Divider height inside ExpansionTile
              data: Theme.of(context).copyWith(
                dividerTheme: const DividerThemeData(space: 0, thickness: 0),
              ),
              child: ExpansionTile(
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                childrenPadding:
                    const EdgeInsets.fromLTRB(16, 0, 16, 12), // body padding
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(workout.title,
                        style: textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(
                      workout.muscleGroups.join(', '),
                      style: textTheme.bodySmall?.copyWith(
                          color: textTheme.bodySmall?.color?.withOpacity(.75)),
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
                // show chevron even when there is no description → hide it:
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
      return Image.asset('assets/img/workout_placeholder.png',
          fit: BoxFit.cover);
    }
    final file = File(workout.imageUrl!);
    return file.existsSync()
        ? Image.file(file, fit: BoxFit.cover)
        : Image.asset('assets/img/workout_placeholder.png', fit: BoxFit.cover);
  }
}
