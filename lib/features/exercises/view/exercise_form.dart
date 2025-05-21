import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/features/exercises/cubit/exercise_cubit.dart';

// This widget is the main screen for adding a new exercise.
// The View and Page classes are inside of the add feature
class ExerciseForm extends StatelessWidget {
  const ExerciseForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseFormCubit, ExerciseFormState>(
      builder: (context, state) {
        final cubit = context.read<ExerciseFormCubit>();
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: cubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                TextFormField(
                  controller: cubit.nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Please enter a name' : null,
                ),
                const SizedBox(height: 12),

                // Description
                TextFormField(
                  controller: cubit.descController,
                  decoration:
                      const InputDecoration(labelText: 'Description (opt.)'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Muscle chips
                Text(
                  'Muscle Groups',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ExerciseFormCubit.muscleOptions.map((m) {
                    final sel = state.selectedMuscles.contains(m);
                    return FilterChip(
                      label: Text(m),
                      selected: sel,
                      onSelected: (_) => cubit.toggleMuscle(m),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Bild / Video Buttons
                Center(
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => cubit.pickMedia(isImage: true),
                        icon: const Icon(Icons.image),
                        label: const Text('Pick Image'),
                      ),
                      if (state.imageFile != null) ...[
                        const SizedBox(height: 8),
                        Image.file(
                          state.imageFile!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ],
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => cubit.pickMedia(isImage: false),
                        icon: const Icon(Icons.video_library),
                        label: const Text('Pick Video'),
                      ),
                      if (state.videoFile != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          state.videoFile!.path.split('/').last,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                // Save
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Save Exercise'),
                    onPressed: () => cubit.submit(context),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
