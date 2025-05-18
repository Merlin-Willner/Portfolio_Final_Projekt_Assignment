import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/app/theme/cubit/theme_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        context.watch<ThemeCubit>().state.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
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
            title: Text('Entwickler'),
            subtitle: Text('Merlin Willner\nmerlin@example.com'),
            leading: Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }
}
