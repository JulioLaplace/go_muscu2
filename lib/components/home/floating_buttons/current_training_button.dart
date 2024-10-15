import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart';
import 'package:go_muscu2/providers/bottom_sheet_provider.dart';
import 'package:go_muscu2/providers/current_workout/current_workout_provider.dart';
import 'package:go_muscu2/providers/current_workout/timer_current_workout_provider.dart';
import 'package:go_muscu2/providers/workouts/workout_provider.dart';
import 'package:go_muscu2/screens/home/workouts/selected_workout_page.dart';
import 'package:provider/provider.dart';

class CurrentTrainingButton extends StatefulWidget {
  const CurrentTrainingButton({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CurrentTrainingButtonState createState() => _CurrentTrainingButtonState();
}

class _CurrentTrainingButtonState extends State<CurrentTrainingButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer4<TimerCurrentWorkoutProvider, CurrentWorkoutProvider,
        BottomSheetProvider, WorkoutProvider>(
      builder: (context, timerCurrentTrainingProvider, currentTrainingProvider,
              bottomSheetProvider, workoutProvider, child) =>
          SizedBox(
        height: 80,
        width: 80,
        child: FloatingActionButton(
          heroTag: 'current training',
          onPressed: () {
            // Set Bottom sheet height
            bottomSheetProvider.setBottomSheetHeight(screenHeigth);

            // Set the bottom sheet widget if it was not set
            if (!bottomSheetProvider.isCurrentTrainingInBottomSheet) {
              // Set the current workout
              workoutProvider
                  .setCurrentWorkout(currentTrainingProvider.currentTraining!);
              bottomSheetProvider.setBottomSheetWidget(SelectedWorkoutPage(
                isOnTraining: true,
              ));
            }
            bottomSheetProvider.openBottomSheet();
            bottomSheetProvider.setCurrentTrainingInBottomSheet(true);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                '${timerCurrentTrainingProvider.hoursString}:${timerCurrentTrainingProvider.minutesString}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                timerCurrentTrainingProvider.secondsString,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 14,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
