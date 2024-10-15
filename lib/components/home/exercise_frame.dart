import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart';
import 'package:go_muscu2/components/loading.dart';
import 'package:go_muscu2/models/exercise.dart';
import 'package:go_muscu2/providers/bottom_sheet_provider.dart';
import 'package:go_muscu2/providers/current_workout/current_exercise_data_provider.dart';
import 'package:go_muscu2/providers/exercises/exercise_provider.dart';
import 'package:go_muscu2/providers/workouts/workout_provider.dart';
import 'package:go_muscu2/screens/home/bottomSheetChild/wrapper_bottom_sheet_child.dart';
import 'package:go_muscu2/screens/home/exercises/selected_exercise_page.dart';
import 'package:go_muscu2/screens/home/workouts/selected_workout_page.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ExerciseFrame extends StatefulWidget {
  Exercise exercise;
  bool isLoading;
  bool addingExerciseMode;
  bool editingExerciseMode;
  bool fromAnotherWidget;
  bool isOnTraining;
  ExerciseFrame({
    super.key,
    required this.exercise,
    this.isLoading = true,
    this.addingExerciseMode = false,
    this.editingExerciseMode = false,
    this.fromAnotherWidget = false,
    this.isOnTraining = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ExerciseFrameState createState() => _ExerciseFrameState();
}

class _ExerciseFrameState extends State<ExerciseFrame> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.addingExerciseMode || widget.editingExerciseMode
          ? () {
              widget.addingExerciseMode
                  ? Provider.of<WorkoutProvider>(context, listen: false)
                      .addExerciseToWorkout(widget.exercise)
                  : null;
              widget.editingExerciseMode
                  ? Provider.of<WorkoutProvider>(context, listen: false)
                      .editExerciseInWorkout(
                          Provider.of<WorkoutProvider>(context, listen: false)
                              .exerciseToReplace!,
                          widget.exercise)
                  : null;
              widget.isOnTraining
                  ? Provider.of<CurrentExerciseDataProvider>(context,
                          listen: false)
                      .changeExerciseData(widget.exercise)
                  : null;
              Provider.of<BottomSheetProvider>(context, listen: false)
                  .setBottomSheetWidget(
                SelectedWorkoutPage(
                  isOnTraining: widget.isOnTraining,
                ),
              );
            }
          : () {
              // Get access to the WorkoutProvider to set the current workout
              Provider.of<ExerciseProvider>(context, listen: false)
                  .setCurrentExercise(widget.exercise);
              // Open bottom sheet with the selected workout
              Provider.of<BottomSheetProvider>(context, listen: false)
                  .setBottomSheetHeight(screenHeigth);

              if (widget.fromAnotherWidget) {
                Provider.of<BottomSheetProvider>(context, listen: false)
                    .addPreviousBottomSheetWidget(
                        SelectedWorkoutPage(isOnTraining: widget.isOnTraining));
                Provider.of<BottomSheetProvider>(context, listen: false)
                    .setBottomSheetWidget(WrapperBottomSheetChild(
                  title: Provider.of<ExerciseProvider>(context, listen: false)
                      .currentExercise!
                      .exerciseName,
                  child: SelectedExercisePage(
                    isOnTraining: widget.isOnTraining,
                    fromAnotherWidget: widget.fromAnotherWidget,
                  ),
                ));
              } else {
                Provider.of<BottomSheetProvider>(context, listen: false)
                    .setBottomSheetWidget(SelectedExercisePage(
                  isOnTraining: widget.isOnTraining,
                ));
                Provider.of<BottomSheetProvider>(context, listen: false)
                    .openBottomSheet();
              }
            },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(doubleRadius),
        ),
        width: double.infinity,
        height: 70,
        child: widget.isLoading
            ? Center(
                child: Loading(
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Title of the exercise
                        Expanded(
                          flex: 3,
                          child: Text(
                            widget.exercise.exerciseName,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        // Exercise category and isUnilateral or not
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.exercise.exerciseCategory,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            widget.exercise.unilateral
                                ? Icon(
                                    Icons.swap_horiz,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : Container(),
                          ],
                        )),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
