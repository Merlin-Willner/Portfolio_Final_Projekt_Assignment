import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_coconut/features/exercises/model/exercise_model.dart';
import 'package:project_coconut/shared/app_bar/modular_app_bar.dart';
import 'package:video_player/video_player.dart';

/// Shows image / video and meta–data of an exercise.
class ExerciseDetailScreen extends StatefulWidget {
  const ExerciseDetailScreen({required this.exercise, super.key});
  final Exercise exercise;

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  static const _fallbackImg = 'assets/images/exercise_placeholder.jpeg';

  VideoPlayerController? _videoCtrl;
  bool _videoFailed = false;

  @override
  void initState() {
    super.initState();

    final url = widget.exercise.videoUrl;
    if (url != null && url.isNotEmpty) {
      _videoCtrl = url.startsWith('http')
          ? VideoPlayerController.networkUrl(Uri.parse(url))
          : VideoPlayerController.file(File(url));

      _videoCtrl!
        ..initialize().then((_) => setState(() {})).catchError((_) {
          // if video cannot be loaded -> show image fallback
          setState(() => _videoFailed = true);
        });
    } else {
      _videoFailed = true; // no url at all → skip video
    }
  }

  @override
  void dispose() {
    _videoCtrl?.dispose();
    super.dispose();
  }

  ImageProvider _imageProviderFor(String? path) {
    if (path != null && path.isNotEmpty) {
      return path.startsWith('http')
          ? NetworkImage(path)
          : FileImage(File(path));
    }
    return const AssetImage(_fallbackImg);
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;

    return Scaffold(
      appBar: ModularAppBar(title: ex.name),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_videoCtrl != null &&
                _videoCtrl!.value.isInitialized &&
                !_videoFailed)
              AspectRatio(
                aspectRatio: _videoCtrl!.value.aspectRatio,
                child: VideoPlayer(_videoCtrl!),
              )
            else
              Image(
                image: _imageProviderFor(ex.imageUrl),
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 12),
            if (ex.description?.trim().isNotEmpty ?? false) ...[
              Text(
                ex.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
            ],
            if (ex.muscleGroups.isNotEmpty)
              Wrap(
                spacing: 6,
                children:
                    ex.muscleGroups.map((m) => Chip(label: Text(m))).toList(),
              ),
          ],
        ),
      ),
      floatingActionButton: (_videoCtrl != null &&
              _videoCtrl!.value.isInitialized &&
              !_videoFailed)
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
