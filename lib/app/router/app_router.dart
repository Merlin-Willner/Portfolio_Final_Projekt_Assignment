import 'package:flutter/material.dart';
import 'package:project_coconut/app/widgets/bottom_nav_bar.dart';
import 'package:project_coconut/features/settings/view/settings_screen.dart';
import 'package:project_coconut/features/workouts/view/workout_detail_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const BottomNavBar(),
  '/workout_detail_screen': (context) => const WorkoutDetailScreen(),
  '/settings': (context) => const SettingsScreen(),
};
