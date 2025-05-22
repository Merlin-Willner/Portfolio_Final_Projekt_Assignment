import 'package:flutter/material.dart';
import 'package:project_coconut/features/settings/view/settings_screen.dart';
import 'package:project_coconut/shared/bottom_nav_bar.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const BottomNavBar(),
  '/settings': (context) => const SettingsScreen(),
};
