import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/app/router/app_routes.dart';
import 'package:project_coconut/app/theme/cubit/theme_cubit.dart';
import 'package:project_coconut/app/theme/cubit/theme_state.dart';
import 'package:project_coconut/app/theme/themes/dark_theme.dart';
import 'package:project_coconut/app/theme/themes/light_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Project Coconut',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: state.themeMode,
            initialRoute: '/',
            routes: appRoutes,
          );
        },
      ),
    );
  }
}
