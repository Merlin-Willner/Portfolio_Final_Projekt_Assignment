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
        // holds the complete list of exercises in memory
        BlocProvider(create: (_) => ExerciseListCubit(ExerciseRepository())),
        // holds the complete list of workouts in memory
        BlocProvider(create: (_) => WorkoutListCubit(WorkoutRepository())),

        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) => MaterialApp(
          title: 'Project Coconut',
          debugShowCheckedModeBanner: false,
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
