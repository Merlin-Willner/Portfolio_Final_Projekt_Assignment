import 'package:flutter/material.dart';
import 'package:project_coconut/shared/app_bar/modular_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: ModularAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/profile_picture.jpeg',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Merlin Willner',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Weight: 90 kg',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Highlights',
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildImagePreview('assets/images/ring_dip.jpeg'),
                  _buildImagePreview('assets/images/profile_picture.jpeg'),
                  _buildImagePreview('assets/images/workout_placeholder.jpeg'),
                  _buildImagePreview('assets/images/exercise_placeholder.jpeg'),
                  _buildImagePreview('assets/images/pull_up.jpeg'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  const Icon(Icons.construction, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'More features coming soon…',
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildImagePreview(String assetPath) {
  return Container(
    margin: const EdgeInsets.only(right: 12),
    width: 140,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      image: DecorationImage(
        image: AssetImage(assetPath),
        fit: BoxFit.cover,
      ),
    ),
  );
}
