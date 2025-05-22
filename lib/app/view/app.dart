import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_coconut/app/router/app_routes.dart';
import 'package:project_coconut/app/theme/cubit/theme_cubit.dart';
import 'package:project_coconut/app/theme/cubit/theme_state.dart';
import 'package:project_coconut/app/theme/themes/dark_theme.dart';
import 'package:project_coconut/app/theme/themes/light_theme.dart';
import 'package:project_coconut/features/exercises/cubit/exercise_list_cubit.dart';
import 'package:project_coconut/features/exercises/data/exercise_repository.dart';
import 'package:project_coconut/features/workouts/cubit/workout_list_cubit.dart';
import 'package:project_coconut/features/workouts/data/workout_repository.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // hält die komplette Liste aller Exercises im Speicher
        BlocProvider(create: (_) => ExerciseListCubit(ExerciseRepository())),
        // hält die komplette Liste aller Workouts im Speicher
        BlocProvider(create: (_) => WorkoutListCubit(WorkoutRepository())),
        // Theme-Cubit bleibt hier
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) => MaterialApp(
          title: 'Project Coconut',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeState.themeMode,
          initialRoute: '/',
          routes: appRoutes,
        ),
      ),
    );
  }
}
