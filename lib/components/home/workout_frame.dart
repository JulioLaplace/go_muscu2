import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart';
import 'package:go_muscu2/components/loading.dart';
import 'package:go_muscu2/models/training.dart';
import 'package:go_muscu2/components/datetime_converter.dart'
    as datetime_converter;
import 'package:go_muscu2/providers/bottom_sheet_provider.dart';
import 'package:go_muscu2/providers/current_workout/current_workout_provider.dart';
import 'package:go_muscu2/providers/current_workout/timer_current_workout_provider.dart';
import 'package:go_muscu2/providers/training/calendar_provider.dart';
import 'package:go_muscu2/providers/workouts/workout_provider.dart';
import 'package:go_muscu2/screens/home/workouts/selected_workout_page.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class WorkoutFrame extends StatefulWidget {
  Training training;
  bool isLoading;
  bool isOnTraining;
  bool addingWorkoutMode;
  bool editingWorkoutMode;
  bool displayInfo;
  WorkoutFrame({
    super.key,
    required this.training,
    this.isLoading = true,
    this.isOnTraining = false,
    this.addingWorkoutMode = false,
    this.editingWorkoutMode = false,
    this.displayInfo = true,
  });

  @override
  // ignore: library_private_types_in_public_api
  _WorkoutFrameState createState() => _WorkoutFrameState();
}

class _WorkoutFrameState extends State<WorkoutFrame> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // If we are in adding workout mode (from the calendar)
        if (widget.addingWorkoutMode) {
          CalendarProvider calendarProvider =
              Provider.of<CalendarProvider>(context, listen: false);
          // Get access to the CurrentExerciseDataProvider to set the current workout
          await calendarProvider.addTrainingForDay(
              calendarProvider.selectedDay, widget.training);
          // Close bottom sheet
          Provider.of<BottomSheetProvider>(context, listen: false)
              .closeBottomSheet();
          return;
        }
        // If we are in editing workout mode (from the calendar)
        if (widget.editingWorkoutMode) {
          CalendarProvider calendarProvider =
              Provider.of<CalendarProvider>(context, listen: false);
          // Get access to the CurrentExerciseDataProvider to set the current workout
          await calendarProvider.replaceTrainingForDay(
              calendarProvider.selectedDay, widget.training);
          // Close bottom sheet
          Provider.of<BottomSheetProvider>(context, listen: false)
              .closeBottomSheet();
          return;
        }
        // If the user is not on training
        if (!widget.isOnTraining) {
          // Get access to the WorkoutProvider to set the current workout
          Provider.of<WorkoutProvider>(context, listen: false)
              .setCurrentWorkout(widget.training);
          // Open bottom sheet with the selected workout
          Provider.of<BottomSheetProvider>(context, listen: false)
              .setBottomSheetHeight(screenHeigth);
          Provider.of<BottomSheetProvider>(context, listen: false)
              .setBottomSheetWidget(SelectedWorkoutPage());
          Provider.of<BottomSheetProvider>(context, listen: false)
              .openBottomSheet();
        }
        // else start the training mode
        else {
          // Get access to the Current training provider to set the current workout
          Provider.of<CurrentWorkoutProvider>(context, listen: false)
              .startTraining(widget.training);
          // Start the timer
          Provider.of<TimerCurrentWorkoutProvider>(context, listen: false)
              .setIsPlaying(true);
          Provider.of<TimerCurrentWorkoutProvider>(context, listen: false)
              .startTimer();
          // Close bottom sheet
          Provider.of<BottomSheetProvider>(context, listen: false)
              .closeBottomSheet();
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        widget.training.trainingName,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    widget.training.lastTrainingDate == null
                        ? const SizedBox.shrink()
                        : const SizedBox(height: 10),

                    // Date of the last training
                    (widget.training.lastTrainingDate == null ||
                            !widget.displayInfo)
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Date
                                Text(
                                  datetime_converter
                                      .convertDatetimeToStringWithoutTime(
                                          widget.training.lastTrainingDate!),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontSize: 14,
                                      ),
                                ),
                                // Time
                                Text(
                                  datetime_converter.convertDatetimeToTime(
                                      widget.training.lastTrainingDate!),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontSize: 14,
                                      ),
                                ),
                                // Duration
                                widget.training.duration == null
                                    ? const SizedBox.shrink()
                                    : Text(
                                        datetime_converter
                                            .convertDurationToString(
                                                widget.training.duration!),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontSize: 14,
                                            ),
                                      ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
