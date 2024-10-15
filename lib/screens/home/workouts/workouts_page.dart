import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart' as constants;
import 'package:go_muscu2/components/home/my_slidable_widget.dart';
import 'package:go_muscu2/components/loading.dart';
import 'package:go_muscu2/components/home/no_data_text.dart';
import 'package:go_muscu2/components/home/workout_frame.dart';
import 'package:go_muscu2/components/utils.dart';
import 'package:go_muscu2/models/training.dart';
import 'package:go_muscu2/categories/training_categories.dart'
    as training_categories;
import 'package:go_muscu2/providers/bottom_sheet_provider.dart';
import 'package:go_muscu2/providers/training/calendar_provider.dart';
import 'package:go_muscu2/providers/workouts/workout_provider.dart';
import 'package:go_muscu2/screens/home/bottomSheetChild/wrapper_bottom_sheet_child.dart';
import 'package:go_muscu2/screens/home/workouts/add_workout_page.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class WorkoutsPage extends StatefulWidget {
  bool startWorkoutMode;
  bool calendarMode;
  bool addingWorkoutMode;
  bool editingWorkoutMode;
  bool displayInfo;
  List<Training>? trainings;
  WorkoutsPage({
    super.key,
    this.startWorkoutMode = false,
    this.calendarMode = false,
    this.trainings,
    this.addingWorkoutMode = false,
    this.editingWorkoutMode = false,
    this.displayInfo = true,
  });

  @override
  // ignore: library_private_types_in_public_api
  _WorkoutsPageState createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  List<Training> trainings = [];

  bool trainingsAreLoading = true;

  bool noTrainingsInDataBase = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  // return all categories which have trainings
  List<String> getCategories() {
    List<String> categories = [];
    for (var i = 0; i < trainings.length; i++) {
      if (!categories.contains(trainings[i].trainingCategory)) {
        categories.add(trainings[i].trainingCategory);
      }
    }
    return categories;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          // get trainings in provider (local database)
          trainings = widget.trainings == null
              ? workoutProvider.trainings
              : widget.trainings!;
          // fetch records from the database
          if (trainings.isEmpty &&
              !workoutProvider.alreadyLoaded &&
              widget.trainings == null) {
            workoutProvider.getTrainings().then(
                  (value) => setState(
                    () {
                      trainings = value;
                      trainingsAreLoading = false;
                      value.isEmpty
                          ? noTrainingsInDataBase = true
                          : noTrainingsInDataBase = false;
                      workoutProvider.alreadyLoaded = true;
                    },
                  ),
                );
          } else {
            trainingsAreLoading = false;
            trainings.isEmpty
                ? noTrainingsInDataBase = true
                : noTrainingsInDataBase = false;
          }

          // Get trainings categories
          List<String> categories = getCategories();

          return noTrainingsInDataBase
              ? Center(
                  child: NoDataText(
                      title:
                          'You have no training, add one with the plus button'),
                )
              : MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: trainingsAreLoading
                        ? training_categories.trainingCategories.length
                        : categories.length,
                    itemBuilder: (context, index) {
                      // get each category
                      final category = trainingsAreLoading
                          ? training_categories.trainingCategories[index]
                          : categories[index];

                      // get trainings in each category
                      final trainingsInCategory = trainingsAreLoading
                          ? null
                          : trainings
                              .where((training) =>
                                  training.trainingCategory == category)
                              .toList();

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 20),
                            trainingsAreLoading
                                ? Center(
                                    heightFactor: 4,
                                    child: Loading(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  )
                                : Column(
                                    children:
                                        trainingsInCategory!.map((training) {
                                      return Column(
                                        children: [
                                          widget.startWorkoutMode
                                              ? WorkoutFrame(
                                                  training: training,
                                                  isLoading:
                                                      trainingsAreLoading,
                                                  isOnTraining:
                                                      widget.startWorkoutMode,
                                                  displayInfo:
                                                      widget.displayInfo,
                                                )
                                              : Consumer2<BottomSheetProvider,
                                                  CalendarProvider>(
                                                  builder: (context,
                                                          bottomSheetProvider,
                                                          calendarProvider,
                                                          child) =>
                                                      MySlidableWidget(
                                                    addingWorkoutMode: widget
                                                        .addingWorkoutMode,
                                                    onPressedEdit: (p0) {
                                                      if (widget.calendarMode) {
                                                        calendarProvider
                                                            .setTrainingToReplace(
                                                                training);
                                                        bottomSheetProvider
                                                            .setBottomSheetHeight(
                                                                constants
                                                                    .screenHeigth);
                                                        bottomSheetProvider
                                                            .setBottomSheetWidget(
                                                          WorkoutsPage(
                                                            editingWorkoutMode:
                                                                true,
                                                          ),
                                                        );
                                                        bottomSheetProvider
                                                            .openBottomSheet();
                                                        return;
                                                      }
                                                      bottomSheetProvider
                                                          .setBottomSheetWidget(
                                                        AddWorkoutPage(
                                                          bottomSheetProvider:
                                                              bottomSheetProvider,
                                                          editingMode: true,
                                                          training: training,
                                                        ),
                                                      );
                                                      bottomSheetProvider
                                                          .setBottomSheetHeight(
                                                              constants
                                                                  .screenHeigth);
                                                      bottomSheetProvider
                                                          .openBottomSheet();
                                                    },
                                                    onPressedDelete:
                                                        (p0) async {
                                                      if (widget.calendarMode) {
                                                        calendarProvider
                                                            .removeTrainingForDay(
                                                                calendarProvider
                                                                    .selectedDay,
                                                                training);
                                                        return;
                                                      }
                                                      bool confirmation = false;
                                                      await Utils
                                                          .confirmationPopUp(
                                                        context,
                                                        confirmation,
                                                        'Are you sure you want to delete this training?',
                                                        () {
                                                          workoutProvider
                                                              .removeTraining(
                                                                  training,
                                                                  context);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        () => Navigator.pop(
                                                            context),
                                                      );
                                                    },
                                                    child: WorkoutFrame(
                                                      training: training,
                                                      isLoading:
                                                          trainingsAreLoading,
                                                      addingWorkoutMode: widget
                                                          .addingWorkoutMode,
                                                      editingWorkoutMode: widget
                                                          .editingWorkoutMode,
                                                      displayInfo:
                                                          widget.displayInfo,
                                                    ),
                                                  ),
                                                ),
                                          const SizedBox(height: 20),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                            SizedBox(
                              height: index == categories.length - 1 ? 100 : 10,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
