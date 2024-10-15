import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_muscu2/components/constants.dart';
import 'package:go_muscu2/components/utils.dart';
import 'package:go_muscu2/providers/bottom_sheet_provider.dart';
import 'package:go_muscu2/providers/current_workout/current_workout_provider.dart';
import 'package:go_muscu2/screens/home/exercises/add_exercise_page.dart';
import 'package:go_muscu2/screens/home/workouts/add_workout_page.dart';
import 'package:go_muscu2/screens/home/workouts/workouts_page.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MainFloatingButton extends StatefulWidget {
  Function openSpeedDial;
  Function closeSpeedDial;
  MainFloatingButton(
      {super.key, required this.openSpeedDial, required this.closeSpeedDial});

  @override
  // ignore: library_private_types_in_public_api
  _MainFloatingButtonState createState() => _MainFloatingButtonState();
}

class _MainFloatingButtonState extends State<MainFloatingButton> {
  List<SpeedDialChild> children(
      BuildContext context, BottomSheetProvider bottomSheetProvider) {
    return [
      // add a personal record
      SpeedDialChild(
        child: const Icon(Icons.add_chart_rounded),
        label: 'Add a personal record',
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        labelBackgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.background,
        onTap: () {
          // bottomSheetProvider.setBottomSheetWidget();
          // bottomSheetProvider.setBottomSheetHeight(constants.screenHeigth);
          // bottomSheetProvider.openBottomSheet();
        },
      ),
      // add a new exercise
      SpeedDialChild(
        child: const Icon(Icons.add_rounded),
        label: 'Add a new exercise',
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        labelBackgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.background,
        onTap: () {
          openSheetWithChild(
            bottomSheetProvider,
            AddExercisePage(bottomSheetProvider: bottomSheetProvider),
          );
        },
      ),
      // add a new workout
      SpeedDialChild(
          child: const Icon(Icons.add_box_rounded),
          label: 'Add a new workout',
          backgroundColor: Theme.of(context).colorScheme.error,
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          labelBackgroundColor: Theme.of(context).colorScheme.background,
          foregroundColor: Theme.of(context).colorScheme.background,
          onTap: () {
            openSheetWithChild(
              bottomSheetProvider,
              AddWorkoutPage(
                bottomSheetProvider: bottomSheetProvider,
              ),
            );
          }),
      // start training
      SpeedDialChild(
        child: const Icon(Icons.fitness_center_rounded),
        label: 'Start training',
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        labelBackgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.background,
        onTap: () {
          // Check if the training is already started
          if (Provider.of<CurrentWorkoutProvider>(context, listen: false)
                  .currentTraining !=
              null) {
            return Utils.errorPopUp(context, 'A training is already started');
          }
          openSheetWithChild(
            bottomSheetProvider,
            WorkoutsPage(
              startWorkoutMode: true,
            ),
          );
        },
      ),
    ];
  }

  void openSheetWithChild(
      BottomSheetProvider bottomSheetProvider, Widget child) {
    bottomSheetProvider.setBottomSheetHeight(screenHeigth);
    bottomSheetProvider.setBottomSheetWidget(child);
    bottomSheetProvider.openBottomSheet();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomSheetProvider>(
      builder: (context, bottomSheetProvider, child) => SpeedDial(
        heroTag: 'MainFloatingButton',
        animatedIcon: AnimatedIcons.add_close,
        foregroundColor: Theme.of(context).colorScheme.secondary,
        spaceBetweenChildren: 15,
        overlayColor: Theme.of(context).colorScheme.secondary,
        overlayOpacity: 0.4,
        children: children(context, bottomSheetProvider),
        onOpen: () {
          widget.openSpeedDial();
        },
        onClose: () {
          widget.closeSpeedDial();
        },
      ),
    );
  }
}
