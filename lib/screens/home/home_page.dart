import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart' as constants;
import 'package:go_muscu2/components/constants.dart';
import 'package:go_muscu2/components/home/app_bar_main.dart';
import 'package:go_muscu2/components/home/child_sheet.dart';
import 'package:go_muscu2/components/home/floating_buttons/floating_buttons.dart';
import 'package:go_muscu2/providers/bottom_sheet_provider.dart';
import 'package:go_muscu2/providers/current_workout/current_exercise_data_provider.dart';
import 'package:go_muscu2/providers/current_workout/current_workout_provider.dart';
import 'package:go_muscu2/providers/current_workout/timer_current_workout_provider.dart';
import 'package:go_muscu2/providers/home_page_provider.dart';
import 'package:go_muscu2/providers/keyboard_provider.dart';
import 'package:go_muscu2/screens/home/exercises/exercises_page.dart';
import 'package:go_muscu2/screens/home/trainings/trainings_page.dart';
import 'package:go_muscu2/screens/home/profile/profile_page.dart';
import 'package:go_muscu2/screens/home/workouts/workouts_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // index of a current screen
  var _bottomNavIndex = 0; //default index of a first screen

  // current user
  final User? user = FirebaseAuth.instance.currentUser;

  final iconList = <IconData>[
    Icons.home,
    Icons.brightness_4,
    Icons.brightness_6,
    Icons.brightness_7,
  ];

  // Keyboard
  bool isKeyboardVisible = false;
  double keyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    // for the keyboard
    WidgetsBinding.instance.addObserver(this);

    // Current training provider
    CurrentWorkoutProvider currentTrainingProvider =
        Provider.of<CurrentWorkoutProvider>(context, listen: false);

    // Current exercise data provider
    CurrentExerciseDataProvider currentExerciseDataProvider =
        Provider.of<CurrentExerciseDataProvider>(context, listen: false);

    // Timer current training provider
    TimerCurrentWorkoutProvider timerCurrentTrainingProvider =
        Provider.of<TimerCurrentWorkoutProvider>(context, listen: false);

    currentTrainingProvider.checkIfIsOnTraining().then((startTime) {
      if (startTime != null) {
        // for current timer training
        timerCurrentTrainingProvider.setStartTime(startTime);
        timerCurrentTrainingProvider.startTimer();
      }
    });

    // Remove local save
    currentExerciseDataProvider.removeLocalSavedData();
    // currentTrainingProvider.stopTrainingSave();
    timerCurrentTrainingProvider.updateTimer();
  }

  @override
  void dispose() {
    // for the keyboard
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Keyboard
    final mediaQueryData = MediaQuery.of(context);
    final keyboardVisibleHeight = mediaQueryData.viewInsets.bottom;

    // Keyboard provider
    KeyboardProvider keyboardProvider =
        Provider.of<KeyboardProvider>(context, listen: false);
    keyboardProvider.setKeyboardVisibility(keyboardVisibleHeight > 0);
    keyboardProvider.setKeyboardHeight(keyboardVisibleHeight);
  }

  // list of pages
  final List<Widget> _pages = [
    const TrainingsPage(),
    WorkoutsPage(),
    ExercisesPage(),
    const ProfilePage(),
  ];

  // list of bottom bar items
  final List<BottomBarWithSheetItem> _bottomBarItems = const [
    BottomBarWithSheetItem(
      icon: Icons.date_range_rounded,
      label: 'Trainings',
    ),
    BottomBarWithSheetItem(
      icon: Icons.fitness_center_rounded,
      label: 'Workouts',
    ),
    BottomBarWithSheetItem(
      icon: Icons.dns_outlined,
      label: 'Exercises',
    ),
    BottomBarWithSheetItem(
      icon: Icons.person_2_outlined,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    constants.screenHeigth =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    constants.screenWidth = MediaQuery.of(context).size.width;

    return Consumer<BottomSheetProvider>(
      builder: (context, bottomSheetProvider, child) => Stack(
        children: [
          Consumer<HomePageProvider>(
            builder: (context, homePageProvider, child) => Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              floatingActionButton: const FloatingButtons(),
              appBar: AppBarMain(
                currentIndex: homePageProvider.navBarIndex,
              ),
              body: _pages[homePageProvider.navBarIndex],
              bottomNavigationBar: SizedBox(
                height: bottomSheetProvider.isBottomSheetOpen ? 0 : 100,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                // open sheet
                if (!bottomSheetProvider.isBottomSheetOpen &&
                    bottomSheetProvider.currentBottomSheetItem != null) {
                  // closed and upwards swipe
                  if (details.primaryDelta! < -5) {
                    bottomSheetProvider.openBottomSheet();
                  }
                }
                // close sheet
                if (bottomSheetProvider.isBottomSheetOpen) {
                  if (details.primaryDelta! > 5) {
                    bottomSheetProvider.closeBottomSheet();
                  }
                }
              },
              child: Consumer<HomePageProvider>(
                builder: (context, homePageProvider, child) =>
                    BottomBarWithSheet(
                  controller: bottomSheetProvider.bottomBarController,
                  onSelectItem: (newIndex) {
                    // close sheet
                    if (bottomSheetProvider.bottomBarController.isOpened &&
                        newIndex != homePageProvider.navBarIndex) {
                      bottomSheetProvider.closeBottomSheet();
                    }

                    // change current index
                    homePageProvider.setNavBarIndex(newIndex);
                  },
                  bottomBarTheme: BottomBarTheme(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(doubleRadius),
                      ),
                    ),
                    heightClosed: 100,
                    heightOpened: bottomSheetProvider.bottomSheetHeight,
                    contentPadding: const EdgeInsets.only(top: 20),
                    itemIconColor: Colors.grey,
                    selectedItemIconColor: Colors.white,
                    selectedItemIconSize: 30,
                    selectedItemTextStyle: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(
                            color: Theme.of(context).colorScheme.background),
                    itemTextStyle: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.grey),
                  ),
                  disableMainActionButton: true,
                  items: _bottomBarItems,
                  duration: const Duration(milliseconds: 200),
                  sheetChild: const ChildSheet(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
