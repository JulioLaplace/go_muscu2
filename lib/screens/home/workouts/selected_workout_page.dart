import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_muscu2/components/home/add_button.dart';
import 'package:go_muscu2/components/home/exercise_frame.dart';
import 'package:go_muscu2/components/home/my_divider.dart';
import 'package:go_muscu2/components/home/my_slidable_widget.dart';
import 'package:go_muscu2/components/home/no_data_text.dart';
import 'package:go_muscu2/components/home/white_box.dart';
import 'package:go_muscu2/components/datetime_converter.dart'
    as datetime_converter;
import 'package:go_muscu2/components/utils.dart';
import 'package:go_muscu2/providers/bottom_sheet_provider.dart';
import 'package:go_muscu2/providers/current_workout/current_exercise_data_provider.dart';
import 'package:go_muscu2/providers/current_workout/current_workout_provider.dart';
import 'package:go_muscu2/providers/current_workout/timer_current_workout_provider.dart';
import 'package:go_muscu2/providers/workouts/workout_provider.dart';
import 'package:go_muscu2/screens/home/bottomSheetChild/wrapper_bottom_sheet_child.dart';
import 'package:go_muscu2/screens/home/exercises/exercises_page.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SelectedWorkoutPage extends StatefulWidget {
  bool isOnTraining;
  SelectedWorkoutPage({
    super.key,
    this.isOnTraining = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SelectedWorkoutPageState createState() => _SelectedWorkoutPageState();
}

class _SelectedWorkoutPageState extends State<SelectedWorkoutPage> {
  // ------------------------- VARIABLES -------------------------

  // ------------------------- INIT STATE -------------------------
  @override
  void initState() {
    super.initState();
    // Current exercise data provider
    CurrentExerciseDataProvider currentExerciseDataProvider =
        Provider.of<CurrentExerciseDataProvider>(context, listen: false);

    // If the user is on training and the exercises data is not loaded yet,
    // initialize the exercises data
    if (widget.isOnTraining) {
      // Try to get the exercises data from current training
      log('Getting all local exercise data');
      currentExerciseDataProvider.getAllLocalExerciseData().then((value) {
        if (currentExerciseDataProvider.alreadyLoaded == false) {
          // Initialize the exercises data : empty or from the previous training
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            // Initialize the exercises data
            log('Initializing exercises data');
            await currentExerciseDataProvider.initializeExercisesData();
            currentExerciseDataProvider.alreadyLoaded = true;
          });
        }
      });
    }
  }

  // ------------------------- BUILD -------------------------
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
        ),
        child: Consumer2<WorkoutProvider, CurrentWorkoutProvider>(
          builder: (context, workoutProvider, currentTrainingProvider, child) =>
              Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Training name
                  Text(
                    workoutProvider.currentWorkout!.trainingName,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 5),
                  // Training category
                  Text(
                    workoutProvider.currentWorkout!.trainingCategory,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  // Divider
                  const MyDivider(),
                ],
              ),
              const SizedBox(height: 30),

              // Last training date
              workoutProvider.currentWorkout!.lastTrainingDate == null
                  ? const SizedBox.shrink()
                  : WhiteBox(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      title: Text(
                        'Last training date',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                datetime_converter.convertDatetimeToString(
                                  workoutProvider
                                      .currentWorkout!.lastTrainingDate!,
                                ),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

              workoutProvider.currentWorkout!.duration == null
                  ? const SizedBox.shrink()
                  : const SizedBox(height: 30),

              // Last training duration
              workoutProvider.currentWorkout!.duration == null
                  ? const SizedBox.shrink()
                  : WhiteBox(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      title: Text(
                        'Duration',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                datetime_converter.convertDurationToString(
                                  workoutProvider.currentWorkout!.duration!,
                                ),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

              const SizedBox(height: 30),

              // Training exercises
              WhiteBox(
                title: Text(
                  'Exercises',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                displayBackground: false,
                displayPadding: false,
                child: Column(
                  children: [
                    workoutProvider.currentWorkout!.exercises.isEmpty
                        ? Column(
                            children: [
                              const SizedBox(height: 20),
                              NoDataText(
                                title: 'No exercises added yet',
                              ),
                              const SizedBox(height: 30),
                            ],
                          )
                        : Consumer<WorkoutProvider>(
                            builder: (context, workoutProvider, child) =>
                                Column(
                              children: workoutProvider
                                  .currentWorkout!.exercises
                                  .map((exercise) {
                                return Column(
                                  children: [
                                    MySlidableWidget(
                                      onPressedEdit: (context) {
                                        workoutProvider
                                            .setExerciseToReplace(exercise);
                                        chooseExercisePage(
                                          Provider.of<BottomSheetProvider>(
                                              context,
                                              listen: false),
                                          false,
                                          true,
                                        );
                                      },
                                      onPressedDelete: (context) {
                                        workoutProvider
                                            .removeExerciseFromWorkout(
                                                exercise);
                                        if (widget.isOnTraining) {
                                          Provider.of<CurrentExerciseDataProvider>(
                                                  context,
                                                  listen: false)
                                              .changeExerciseData(exercise);
                                        }
                                      },
                                      child: ExerciseFrame(
                                        exercise: exercise,
                                        isLoading: false,
                                        addingExerciseMode: false,
                                        fromAnotherWidget: true,
                                        isOnTraining: widget.isOnTraining,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),

                    // Add exercise button
                    Consumer<BottomSheetProvider>(
                      builder: (context, bottomSheetProvider, child) =>
                          AddButton(
                        onTap: () {
                          chooseExercisePage(
                            bottomSheetProvider,
                            true,
                            false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),
              // Stop training button
              widget.isOnTraining || widget.key != null
                  ? Row(
                      children: [
                        Expanded(
                          child: Consumer4<
                              CurrentWorkoutProvider,
                              BottomSheetProvider,
                              TimerCurrentWorkoutProvider,
                              CurrentExerciseDataProvider>(
                            builder: (context,
                                    currentTrainingProvider,
                                    bottomSheetProvider,
                                    timerCurrentTrainingProvider,
                                    currentExerciseDataProvider,
                                    child) =>
                                ElevatedButton(
                              onPressed: () async {
                                bool confirmation = false;
                                await Utils.confirmationPopUp(
                                  context,
                                  confirmation,
                                  'Are you sure you want to stop your training?',
                                  () async {
                                    // onConfirm
                                    // Save the exercises data
                                    // and stop the current training
                                    if (!await currentExerciseDataProvider
                                        .terminateTraining(context)) {
                                      Navigator.pop(context);
                                      return;
                                    }
                                    // Stop the timer
                                    timerCurrentTrainingProvider.stopTimer();
                                    // Close the bottom sheet and remove the widget
                                    bottomSheetProvider.closeBottomSheet();
                                    bottomSheetProvider
                                        .removeBottomSheetWidget();
                                    Navigator.pop(context);
                                  },
                                  // onCancel
                                  () => Navigator.pop(context),
                                );
                              },
                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(
                                  const Size(double.infinity, 50),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.error,
                                ),
                              ),
                              child: Text(
                                'Stop training',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : // Start training button
                  currentTrainingProvider.isOnTraining
                      ? const SizedBox.shrink()
                      : Row(
                          children: [
                            Expanded(
                              child: Consumer4<
                                  CurrentWorkoutProvider,
                                  BottomSheetProvider,
                                  TimerCurrentWorkoutProvider,
                                  WorkoutProvider>(
                                builder: (context,
                                        currentTrainingProvider,
                                        bottomSheetProvider,
                                        timerCurrentTrainingProvider,
                                        workoutProvider,
                                        child) =>
                                    ElevatedButton(
                                  onPressed: () async {
                                    bool confirmation = false;
                                    await Utils.confirmationPopUp(
                                      context,
                                      confirmation,
                                      'Are you sure you want to start your training?',
                                      () async {
                                        // Get access to the Current training provider to set the current workout
                                        currentTrainingProvider.startTraining(
                                            workoutProvider.currentWorkout!);
                                        // Start the timer
                                        timerCurrentTrainingProvider
                                            .setIsPlaying(true);
                                        timerCurrentTrainingProvider
                                            .startTimer();
                                        // Close bottom sheet
                                        bottomSheetProvider.closeBottomSheet();
                                        Navigator.pop(context);
                                      },
                                      // onCancel
                                      () => Navigator.pop(context),
                                    );
                                  },
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                      const Size(double.infinity, 50),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.tertiary,
                                    ),
                                  ),
                                  child: Text(
                                    'Start training',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Choosing exercise page to add to the workout
  chooseExercisePage(
    BottomSheetProvider bottomSheetProvider,
    bool addingExerciseMode,
    bool editingExerciseMode,
  ) {
    bottomSheetProvider.addPreviousBottomSheetWidget(SelectedWorkoutPage(
      isOnTraining: widget.isOnTraining,
    ));
    bottomSheetProvider.setBottomSheetWidget(
      WrapperBottomSheetChild(
        title: 'Choose an exercise',
        child: ExercisesPage(
          addingExerciseMode: addingExerciseMode,
          editingExerciseMode: editingExerciseMode,
          isOnTraining: widget.isOnTraining,
        ),
      ),
    );
  }
}
