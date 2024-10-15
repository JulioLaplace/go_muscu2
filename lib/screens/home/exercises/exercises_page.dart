import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart' as constants;
import 'package:go_muscu2/components/home/exercise_frame.dart';
import 'package:go_muscu2/components/home/my_slidable_widget.dart';
import 'package:go_muscu2/components/loading.dart';
import 'package:go_muscu2/components/home/no_data_text.dart';
import 'package:go_muscu2/components/utils.dart';
import 'package:go_muscu2/models/exercise.dart';
import 'package:go_muscu2/providers/bottom_sheet_provider.dart';
import 'package:go_muscu2/providers/exercises/exercise_provider.dart';
import 'package:go_muscu2/screens/home/exercises/add_exercise_page.dart';
import 'package:provider/provider.dart';
import 'package:go_muscu2/categories/exercise_categories.dart'
    as exercise_categories;

// ignore: must_be_immutable
class ExercisesPage extends StatefulWidget {
  bool addingExerciseMode;
  bool editingExerciseMode;
  bool fromAnotherWidget;
  bool isOnTraining;

  ExercisesPage({
    super.key,
    this.addingExerciseMode = false,
    this.editingExerciseMode = false,
    this.fromAnotherWidget = false,
    this.isOnTraining = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  List<Exercise> exercises = [];

  bool exercisesAreLoading = true;

  bool noExercisesInDataBase = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  // return all categories which have exercises
  List<String> getCategories() {
    List<String> categories = [];
    for (var i = 0; i < exercises.length; i++) {
      if (!categories.contains(exercises[i].exerciseCategory)) {
        categories.add(exercises[i].exerciseCategory);
      }
    }
    return categories;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<ExerciseProvider>(
        builder: (context, exerciseProvider, child) {
          // get exercises in provider (local database)
          exercises = exerciseProvider.exercises;
          // fetch records from the database
          if (!exerciseProvider.alreadyLoaded) {
            exerciseProvider.getExercises().then((value) => setState(() {
                  exercises = value;
                  exercisesAreLoading = false;
                  value.isEmpty
                      ? noExercisesInDataBase = true
                      : noExercisesInDataBase = false;
                  exerciseProvider.alreadyLoaded = true;
                }));
          } else {
            exercisesAreLoading = false;
            exercises.isEmpty
                ? noExercisesInDataBase = true
                : noExercisesInDataBase = false;
          }

          // Get exercises categories
          List<String> categories = getCategories();

          return noExercisesInDataBase
              ? Center(
                  child: NoDataText(
                      title:
                          'You have no exercise, add one with the plus button'),
                )
              : MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: exercisesAreLoading
                        ? exercise_categories.exercisesCategories.length
                        : categories.length,
                    itemBuilder: (context, index) {
                      // get each category
                      final category = exercisesAreLoading
                          ? exercise_categories.exercisesCategories[index]
                          : categories[index];

                      // get exercises of the category
                      final exercisesInCategory = exercisesAreLoading
                          ? null
                          : exercises
                              .where((exercise) =>
                                  exercise.exerciseCategory == category)
                              .toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            category,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 20),
                          exercisesAreLoading
                              ? Center(
                                  heightFactor: 4,
                                  child: Loading(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                )
                              : Column(
                                  children:
                                      exercisesInCategory!.map((exercise) {
                                    return Column(
                                      children: [
                                        Consumer<BottomSheetProvider>(
                                          builder: (context,
                                                  bottomSheetProvider, child) =>
                                              MySlidableWidget(
                                            onPressedEdit: (p0) {
                                              bottomSheetProvider
                                                  .setBottomSheetWidget(
                                                AddExercisePage(
                                                  bottomSheetProvider:
                                                      bottomSheetProvider,
                                                  editingMode: true,
                                                  exercise: exercise,
                                                ),
                                              );
                                              bottomSheetProvider
                                                  .setBottomSheetHeight(
                                                      constants.screenHeigth);
                                              bottomSheetProvider
                                                  .openBottomSheet();
                                            },
                                            onPressedDelete: (p0) async {
                                              bool confirmation = false;
                                              await Utils.confirmationPopUp(
                                                context,
                                                confirmation,
                                                'Are you sure you want to delete this training?',
                                                () {
                                                  exerciseProvider
                                                      .removeExercise(
                                                          exercise, context);
                                                  Navigator.pop(context);
                                                },
                                                () => Navigator.pop(context),
                                              );
                                            },
                                            child: ExerciseFrame(
                                              exercise: exercise,
                                              isLoading: exercisesAreLoading,
                                              addingExerciseMode:
                                                  widget.addingExerciseMode,
                                              editingExerciseMode:
                                                  widget.editingExerciseMode,
                                              fromAnotherWidget:
                                                  widget.fromAnotherWidget,
                                              isOnTraining: widget.isOnTraining,
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
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
