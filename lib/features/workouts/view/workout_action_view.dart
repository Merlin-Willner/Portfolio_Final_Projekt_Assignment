// lib/features/workouts/view/workout_action_view.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../exercises/model/exercise_model.dart';
import '../../exercises/model/exercise_set_model.dart';
import '../model/workout_model.dart';

class WorkoutActionView extends StatefulWidget {
  const WorkoutActionView({super.key, required this.workout});

  final Workout workout;

  @override
  State<WorkoutActionView> createState() => _WorkoutActionViewState();
}

class _WorkoutActionViewState extends State<WorkoutActionView> {
  late final PageController _pageCtrl;
  late final List<WorkoutSet> _sets;
  int _index = 0;

  VideoPlayerController? _videoCtrl;

  @override
  void initState() {
    super.initState();
    _sets = widget.workout.sets;
    _pageCtrl = PageController();
    _loadVideoIfNeeded();
  }

  void _loadVideoIfNeeded() {
    _videoCtrl?.dispose();
    final url = widget.workout.videoUrl;
    if (url != null && File(url).existsSync()) {
      _videoCtrl = VideoPlayerController.file(File(url))
        ..initialize().then((_) => setState(() {}));
    } else {
      _videoCtrl = null;
    }
  }

  @override
  void dispose() {
    _videoCtrl?.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < _sets.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      );
    } else {
      Navigator.of(context).pop(); // finished
    }
  }

  void _prev() {
    if (_index > 0) {
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.title),
      ),
      body: Column(
        children: [
          // ── header: image / video ──────────────────────────
          SizedBox(
            height: 220,
            width: double.infinity,
            child: _videoCtrl != null && _videoCtrl!.value.isInitialized
                ? VideoPlayer(_videoCtrl!)
                : (widget.workout.imageUrl != null &&
                        File(widget.workout.imageUrl!).existsSync())
                    ? Image.file(
                        File(widget.workout.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : Image.asset('assets/images/placeholder.jpg',
                        fit: BoxFit.cover),
          ),

          // ── page-view with all sets ───────────────────────
          Expanded(
            child: PageView.builder(
              controller: _pageCtrl,
              itemCount: _sets.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (ctx, i) {
                final set = _sets[i];
                final label = set.label; //  “10 reps” / “60 sec” …
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set ${i + 1} / ${_sets.length}',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        label,
                        style: theme.textTheme.displayMedium,
                      ),
                      if (set.weight != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          '${set.weight} kg',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                      if (set.restTime != null && set.restTime! > 0) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Rest ${set.restTime} s after this set',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                      const Spacer(),
                      Row(
                        children: [
                          if (_index > 0)
                            OutlinedButton(
                              onPressed: _prev,
                              child: const Text('Previous'),
                            ),
                          const Spacer(),
                          FilledButton(
                            onPressed: _next,
                            child: Text(
                              _index == _sets.length - 1 ? 'Finish' : 'Next',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // ── progress bar ──────────────────────────────────
          LinearProgressIndicator(
            value: (_index + 1) / _sets.length,
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
