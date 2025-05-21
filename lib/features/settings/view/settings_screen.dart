import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/app/theme/cubit/theme_cubit.dart';
import 'package:project_coconut/shared/app_bar/modular_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        context.watch<ThemeCubit>().state.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: ModularAppBar(
        title: 'Settings',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDark,
            onChanged: (value) {
              context.read<ThemeCubit>().toggleTheme(value);
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('Developer'),
            subtitle: Text('Merlin Willner\nmerlin@example.com'),
            leading: Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }
}
