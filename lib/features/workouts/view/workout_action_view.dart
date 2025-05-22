import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/features/exercises/cubit/exercise_list_cubit.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';
import 'package:project_coconut/features/exercises/model/exercise_set_model.dart';
import 'package:project_coconut/features/workouts/model/workout_model.dart';
import 'package:project_coconut/shared/app_bar/modular_app_bar.dart';
import 'package:video_player/video_player.dart';

class WorkoutActionView extends StatefulWidget {
  const WorkoutActionView({required this.workout, super.key});

  final Workout workout;

  @override
  State<WorkoutActionView> createState() => _WorkoutActionViewState();
}

class _WorkoutActionViewState extends State<WorkoutActionView> {
  late final PageController _pageController;
  late final List<ExerciseSet> _sets;
  late final List<Exercise> _exercises;
  int _index = 0;

  Timer? _restTimer;
  int _restRemaining = 0;

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
          _initMedia();
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

  void _initMedia() {
    _restTimer?.cancel();
    _videoCtrl?.dispose();

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

  Exercise _exerciseFor(ExerciseSet s) =>
      _exercises.firstWhere((e) => e.id == s.exerciseId,
          orElse: () => Exercise(
                id: s.exerciseId,
                name: 'Unknown exercise',
                muscleGroups: const [],
              ));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: ModularAppBar(
        title: widget.workout.title,
      ),
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _sets.length,
        itemBuilder: (context, _) {
          final set = _sets[_index];
          final ex = _exerciseFor(set);
          final weightLabel = set.weight != null
              ? '${set.weight!.toStringAsFixed(1)} kg'
              : 'Body-weight';
          final detailLine = '${ex.name} – $weightLabel';

          return Column(
            children: [
              _buildMedia(ex, theme),
              const SizedBox(height: 16),

              Text(
                set.typelabel,
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // exercise + weight
              Text(
                detailLine,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),

              // REST TIMER (big red)
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

              // progress bar + gap
              LinearProgressIndicator(
                value: (_index + 1) / _sets.length,
                minHeight: 8,
              ),
              const SizedBox(height: 30),

              // navigation buttons
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

  // helper to build either video / image / placeholder
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
