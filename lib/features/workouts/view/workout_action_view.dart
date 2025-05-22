// lib/features/workouts/view/workout_action_view.dart
/*
import 'dart:async';
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
  Timer? _restTimer;
  int _restRemaining = 0;

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
          duration: const Duration(milliseconds: 250), curve: Curves.ease);
    } else {
      Navigator.of(context).pop();
    }
    final nextRest = _sets[_index].restTime ?? 0;
    _startRestTimer(nextRest);
  }

  void _prev() {
    if (_index > 0) {
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      );
    }
  }

  void _startRestTimer(int seconds) {
    _restTimer?.cancel();
    if (seconds <= 0) return;
    _restRemaining = seconds;
    _restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_restRemaining <= 1) {
        t.cancel();
      }
      setState(() => _restRemaining--);
    });
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
                final exerciseName = set.exerciseId;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exerciseName,
                          style: theme.textTheme.headlineSmall), // ← NEW
                      const SizedBox(height: 4),
                      Text('Set ${i + 1} / ${_sets.length}',
                          style: theme.textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Text(set.label, style: theme.textTheme.displayMedium),
                      if (set.weight != null) ...[
                        const SizedBox(height: 4),
                        Text('${set.weight} kg',
                            style: theme.textTheme.titleLarge),
                      ],
                      const Spacer(),
                      // live rest-count-down
                      if ((_restRemaining) > 0)
                        Text('Rest: $_restRemaining s',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(color: theme.colorScheme.secondary)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (_index > 0)
                            OutlinedButton(
                                onPressed: _prev,
                                child: const Text('Previous')),
                          const Spacer(),
                          FilledButton(
                            onPressed: _next,
                            child: Text(
                                _index == _sets.length - 1 ? 'Finish' : 'Next'),
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
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}*/
// lib/features/workouts/view/workout_action_view.dart
// ---------------------------------------------------
// – full-screen walk-through of all sets in a workout
// – displays video ▸ image ▸ placeholder, repetitions in BIG type,
//   exercise-name & weight underneath,
//   a large REST count-down, progress-bar + prev/next buttons.
// – reads ExerciseListCubit for exercise meta data, no extra cubits created.

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/shared/app_bar/modular_app_bar.dart';
import 'package:video_player/video_player.dart';

import '../../exercises/cubit/exercise_list_cubit.dart';
import '../../exercises/model/exercise_model.dart';
import '../../exercises/view/exercise_detail_screen.dart';
import '../model/workout_model.dart';
import '../../exercises/model/exercise_set_model.dart';

/// Full-screen UI that lets the athlete walk through every set
/// of a workout one by one (swipe is disabled – “Previous/Next”
/// buttons advance the [PageView]).
class WorkoutActionView extends StatefulWidget {
  const WorkoutActionView({super.key, required this.workout});

  final Workout workout;

  @override
  State<WorkoutActionView> createState() => _WorkoutActionViewState();
}

class _WorkoutActionViewState extends State<WorkoutActionView> {
  late final PageController _pageController;
  late final List<WorkoutSet> _sets;
  late final List<Exercise> _exercises; // cached list
  int _index = 0;

  /* ── rest-timer ──────────────────────────────────────────── */
  Timer? _restTimer;
  int _restRemaining = 0;

  /* ── media controller (optional) ─────────────────────────── */
  VideoPlayerController? _videoCtrl;

  @override
  void initState() {
    super.initState();
    _sets = widget.workout.sets;
    _exercises = context.read<ExerciseListCubit>().state.exercises;
    _pageController = PageController()
      ..addListener(() {
        final i = _pageController.page!.round();
        if (i != _index) {
          setState(() => _index = i);
          _initMedia(); // reload media + rest timer
        }
      });

    _initMedia();
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    _videoCtrl?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  /* ────────────────────────────────────────────────────────── */

  void _initMedia() {
    // cancel previous
    _restTimer?.cancel();
    _videoCtrl?.dispose();

    /* REST TIMER */
    final rest = _sets[_index].restTime ?? 0;
    if (rest > 0) {
      _restRemaining = rest;
      _restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_restRemaining == 0) {
          t.cancel();
        } else {
          setState(() => _restRemaining--);
        }
      });
    } else {
      _restRemaining = 0;
    }

    /* VIDEO (if available) */
    final Exercise ex = _exerciseFor(_sets[_index]);
    if (ex.videoUrl != null && ex.videoUrl!.isNotEmpty) {
      _videoCtrl = VideoPlayerController.file(File(ex.videoUrl!))
        ..initialize().then((_) {
          setState(() {});
          _videoCtrl!.setLooping(true);
          _videoCtrl!.play();
        });
    } else {
      _videoCtrl = null;
    }
  }

  Exercise _exerciseFor(WorkoutSet s) =>
      _exercises.firstWhere((e) => e.id == s.exerciseId,
          orElse: () => Exercise(
                id: s.exerciseId,
                name: 'Unknown exercise',
                muscleGroups: const [],
              ));

  /* ────────────────────────────────────────────────────────── */

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: ModularAppBar(
        title: widget.workout.title,
      ),
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // lock swipe
        itemCount: _sets.length,
        itemBuilder: (context, _) {
          final WorkoutSet set = _sets[_index];
          final Exercise ex = _exerciseFor(set);
          final weightLabel = set.weight != null
              ? '${set.weight!.toStringAsFixed(1)} kg'
              : 'Body-weight';
          final detailLine = '${ex.name} – $weightLabel';

          return Column(
            children: [
              _buildMedia(ex, theme),
              const SizedBox(height: 16),

              /* value (huge) */
              Text(
                //"set.valueOfType.toString() + set.type.toString()",
                set.typelabel,
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 55,
                  //color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              /* exercise + weight */
              Text(
                detailLine,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),

              /* REST TIMER (big red) */
              if (_restRemaining > 0 && _index > 0) ...[
                Text(
                  'REST  $_restRemaining s',
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
              ],
              //const Spacer(),

              /* progress bar + gap */
              LinearProgressIndicator(
                value: (_index + 1) / _sets.length,
                minHeight: 8,
              ),
              const SizedBox(height: 30),

              /* navigation buttons */
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_index > 0)
                      Expanded(
                        child: FilledButton.tonal(
                          onPressed: () => _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut),
                          child: const Text('Previous'),
                        ),
                      )
                    else
                      const Spacer(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          if (_index < _sets.length - 1) {
                            _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                          } else {
                            Navigator.of(context).pop(); // finished
                          }
                        },
                        child:
                            Text(_index < _sets.length - 1 ? 'Next' : 'Finish'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 45),
            ],
          );
        },
      ),
    );
  }

  /* ── helper to build either video / image / placeholder ───── */
  Widget _buildMedia(Exercise ex, ThemeData theme) {
    const placeholder = 'assets/images/workout_placeholder.jpeg';

    if (_videoCtrl != null && _videoCtrl!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoCtrl!.value.aspectRatio,
        child: VideoPlayer(_videoCtrl!),
      );
    }

    final imgPath =
        ex.imageUrl?.isNotEmpty == true ? ex.imageUrl! : placeholder;

    return Image.file(
      File(imgPath),
      fit: BoxFit.cover,
      width: double.infinity,
      height: 250,
      errorBuilder: (_, __, ___) => Image.asset(
        placeholder,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 250,
      ),
    );
  }
}
