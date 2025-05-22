/*

import 'package:flutter/material.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';
import 'package:video_player/video_player.dart';

class ExerciseDetailScreen extends StatefulWidget {
  static const routeName = '/exercise_detail';

  const ExerciseDetailScreen({Key? key, required exercise}) : super(key: key);

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  late Exercise? exercise;
  VideoPlayerController? _videoController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Hier holen wir uns das Exercise-Objekt aus den Argumenten
    final args = ModalRoute.of(context)!.settings.arguments as Exercise;
    exercise = args;

    // if (exercise.videoUrl != null) {
    //   _videoController = VideoPlayerController.network(exercise.videoUrl!)
    //     ..initialize().then((_) {
    //       setState(() {});
    //       _videoController!.play();
    //     });
    // }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test")), //title: Text(exercise.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bild
            // if (exercise.imageUrl != null)
            //   Image.network(exercise.imageUrl!, fit: BoxFit.cover),
            // const SizedBox(height: 12),

            // Video
            if (_videoController != null &&
                _videoController!.value.isInitialized)
              AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            const SizedBox(height: 12),

            // Beschreibung
            // if (exercise.description != null &&
            //     exercise.description!.isNotEmpty)
            //   Text(exercise.description!,
            //       style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),

            // Muskelgruppen
            Wrap(
              spacing: 6,
              //   children: exercise.muscleGroups
              //       .map((m) => Chip(label: Text(m)))
              //       .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';

/// Shows image, video, description and muscle chips of an exercise.
class ExerciseDetailScreen extends StatefulWidget {
  const ExerciseDetailScreen({super.key, required this.exercise});

  final Exercise exercise;

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  VideoPlayerController? _videoCtrl;

  @override
  void initState() {
    super.initState();
    // create the controller only if we have a video url / file
    final url = widget.exercise.videoUrl;
    if (url != null && url.isNotEmpty) {
      _videoCtrl = url.startsWith('http')
          ? VideoPlayerController.networkUrl(Uri.parse(url))
          : VideoPlayerController.file(File(url))
        ..initialize().then((_) => setState(() {}));
    }
  }

  @override
  void dispose() {
    _videoCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;

    return Scaffold(
      appBar: AppBar(title: Text(ex.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ─────────────────────────────────────────────
            if (ex.imageUrl != null && ex.imageUrl!.isNotEmpty) ...[
              Image(
                image: ex.imageUrl!.startsWith('http')
                    ? NetworkImage(ex.imageUrl!) as ImageProvider
                    : FileImage(File(ex.imageUrl!)),
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 12),
            ],

            // ── Video ─────────────────────────────────────────────
            if (_videoCtrl != null && _videoCtrl!.value.isInitialized) ...[
              AspectRatio(
                aspectRatio: _videoCtrl!.value.aspectRatio,
                child: VideoPlayer(_videoCtrl!),
              ),
              const SizedBox(height: 12),
            ],

            // ── Description ──────────────────────────────────────
            if (ex.description != null && ex.description!.isNotEmpty) ...[
              Text(
                ex.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
            ],

            // ── Muscle chips ─────────────────────────────────────
            if (ex.muscleGroups.isNotEmpty)
              Wrap(
                spacing: 6,
                children:
                    ex.muscleGroups.map((m) => Chip(label: Text(m))).toList(),
              ),
          ],
        ),
      ),
      floatingActionButton: _videoCtrl != null
          ? FloatingActionButton(
              onPressed: () {
                final v = _videoCtrl!;
                v.value.isPlaying ? v.pause() : v.play();
                setState(() {});
              },
              child: Icon(
                _videoCtrl!.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
