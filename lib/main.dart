import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_muscu2/providers/bottom_sheet_provider.dart';
import 'package:go_muscu2/providers/chronometer_provider.dart';
import 'package:go_muscu2/providers/current_workout/current_exercise_data_provider.dart';
import 'package:go_muscu2/providers/current_workout/current_workout_provider.dart';
import 'package:go_muscu2/providers/current_workout/timer_current_workout_provider.dart';
import 'package:go_muscu2/providers/exercises/add_exercise_provider.dart';
import 'package:go_muscu2/providers/exercises/exercise_provider.dart';
import 'package:go_muscu2/providers/home_page_provider.dart';
import 'package:go_muscu2/providers/keyboard_provider.dart';
import 'package:go_muscu2/providers/number_manager_provider.dart';
import 'package:go_muscu2/providers/training/calendar_provider.dart';
import 'package:go_muscu2/providers/workouts/add_workout_provider.dart';
import 'package:go_muscu2/providers/workouts/workout_provider.dart';
import 'package:go_muscu2/screens/wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BottomSheetProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChronometerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => TimerCurrentWorkoutProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CalendarProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WorkoutProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddWorkoutProvider(),
        ),
        ChangeNotifierProxyProvider<WorkoutProvider, ExerciseProvider>(
          update: (context, workoutProvider, exerciseProvider) =>
              ExerciseProvider(workoutProvider),
          create: (context) => ExerciseProvider(null),
        ),
        ChangeNotifierProvider(
          create: (context) => AddExerciseProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NumberManagerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => KeyboardProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CurrentWorkoutProvider(),
        ),
        ChangeNotifierProxyProvider<CurrentWorkoutProvider,
            CurrentExerciseDataProvider>(
          update: (context, currentTrainingProvider,
                  cCurrentExerciseDataProvider) =>
              CurrentExerciseDataProvider(currentTrainingProvider),
          create: (context) => CurrentExerciseDataProvider(null),
        ),
        ChangeNotifierProvider(
          create: (context) => HomePageProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    textTheme: TextTheme(
      titleLarge: GoogleFonts.mavenPro(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 39, 39, 39),
      ),
      titleMedium: GoogleFonts.mavenPro(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 39, 39, 39),
      ),
      titleSmall: GoogleFonts.mavenPro(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 39, 39, 39),
      ),
      bodyLarge: GoogleFonts.mavenPro(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 39, 39, 39),
      ),
      bodyMedium: GoogleFonts.mavenPro(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: const Color.fromARGB(255, 39, 39, 39),
      ),
      bodySmall: GoogleFonts.mavenPro(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: const Color.fromARGB(255, 39, 39, 39),
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFEBEBEB),
      primary: const Color.fromARGB(255, 236, 191, 107),
      secondary: const Color.fromARGB(255, 39, 39, 39),
      background: Color.fromARGB(255, 241, 241, 241),
      surface: const Color(0xFFBEBEBE),
      error: const Color.fromARGB(255, 202, 73, 73), // error red
      tertiary: const Color.fromARGB(255, 57, 176, 65), // success green
      primaryContainer: const Color.fromARGB(255, 223, 154, 70), // orange
      secondaryContainer: const Color.fromARGB(255, 38, 139, 202), // blue
    ),
    appBarTheme: const AppBarTheme(
      actionsIconTheme: IconThemeData(
        color: Color.fromARGB(255, 39, 39, 39),
      ),
      shadowColor: Colors.transparent,
    ),
    // buttonTheme: const ButtonThemeData(
    //   buttonColor: Color.fromARGB(255, 236, 191, 107),
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.all(
    //       Radius.circular(30),
    //     ),
    //   ),
    // ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          const Color.fromARGB(255, 236, 191, 107),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          const Color.fromARGB(255, 236, 191, 107),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        elevation: MaterialStateProperty.all(0),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(
          const Color.fromARGB(255, 39, 39, 39),
        ),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color.fromARGB(255, 236, 191, 107),
      selectionColor: Color.fromARGB(255, 236, 191, 107),
      selectionHandleColor: Color.fromARGB(255, 236, 191, 107),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor:
          MaterialStateProperty.all(const Color.fromARGB(255, 236, 191, 107)),
    ),
    highlightColor: const Color.fromARGB(255, 236, 191, 107),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 236, 191, 107),
    ),
  );

  ThemeData darkTheme(BuildContext context) => ThemeData(
        useMaterial3: false,
        textTheme: TextTheme(
          titleLarge: GoogleFonts.mavenPro(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
          titleMedium: GoogleFonts.mavenPro(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
          titleSmall: GoogleFonts.mavenPro(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
          bodyLarge: GoogleFonts.mavenPro(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
          bodyMedium: GoogleFonts.mavenPro(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).colorScheme.secondary,
          ),
          bodySmall: GoogleFonts.mavenPro(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEBEBEB),
          primary: const Color.fromARGB(255, 236, 191, 107),
          secondary: const Color.fromARGB(255, 39, 39, 39),
          background: const Color(0xFFEBEBEB),
          surface: const Color(0xFFBEBEBE),
          error: const Color.fromARGB(255, 202, 73, 73), // error red
          tertiary: const Color.fromARGB(255, 57, 176, 65), // success green
          onPrimary: const Color.fromARGB(255, 223, 154, 70), // orange
          onSecondary: const Color.fromARGB(255, 38, 139, 202), // blue
          brightness: Brightness.dark,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Theme.of(context).colorScheme.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.primary,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            elevation: MaterialStateProperty.all(0),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Theme.of(context).colorScheme.primary,
          selectionColor: Theme.of(context).colorScheme.primary,
          selectionHandleColor: Theme.of(context).colorScheme.primary,
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor:
              MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoMuscu',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // Disable automatic screen rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return const Wrapper();
  }
}
