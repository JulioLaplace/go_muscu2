import 'package:flutter/material.dart';
import 'package:go_muscu2/components/home/my_divider.dart';
import 'package:go_muscu2/components/home/no_data_text.dart';
import 'package:go_muscu2/components/home/white_box.dart';
import 'package:go_muscu2/components/loading.dart';
import 'package:go_muscu2/components/home/my_editable_text.dart';
import 'package:go_muscu2/components/utils.dart';
import 'package:go_muscu2/models/exercise.dart';
import 'package:go_muscu2/providers/current_workout/current_exercise_data_provider.dart';
import 'package:go_muscu2/providers/exercises/exercise_provider.dart';
import 'package:go_muscu2/providers/keyboard_provider.dart';
import 'package:go_muscu2/screens/home/exercises/exercise_data_list.dart';
import 'package:go_muscu2/screens/home/exercises/exercise_data_list_to_fill_bilateral.dart';
import 'package:go_muscu2/screens/home/exercises/exercise_data_list_to_fill_unilateral.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SelectedExercisePage extends StatefulWidget {
  bool isOnTraining;
  bool fromAnotherWidget;
  SelectedExercisePage({
    super.key,
    this.isOnTraining = false,
    this.fromAnotherWidget = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SelectedExercisePageState createState() => _SelectedExercisePageState();
}

class _SelectedExercisePageState extends State<SelectedExercisePage> {
  // ----------------- Variables -----------------
  // scroll controller
  ScrollController scrollController = ScrollController();
  int _exerciseDataDisplayed = 1;
  bool _isLoadingMoreData = false;
  bool _isLoading = true;
  late TextEditingController _noteController;
  String _note = '';
  String defaultNote = 'Insert a note';
  Exercise? selectedExercise;
  int exerciseDataLength = 0;

  // Add data mode
  bool addDataMode = false;

  // ----------------- Init State -----------------
  @override
  void initState() {
    super.initState();
    ExerciseProvider exerciseProvider =
        Provider.of<ExerciseProvider>(context, listen: false);
    CurrentExerciseDataProvider currentExerciseDataProvider =
        Provider.of<CurrentExerciseDataProvider>(context, listen: false);

    // Get the note from the current exercise
    _note = exerciseProvider.currentExercise!.note;
    _noteController = TextEditingController(text: _note);

    // Set the selected exercise
    selectedExercise = exerciseProvider.currentExercise;

    // Get the exercise data
    exerciseProvider.getExerciseData().then((value) => setState(() {
          exerciseDataLength = exerciseProvider.currentExercise!.data.length;
          selectedExercise = exerciseProvider.currentExercise;
          _isLoading = false;
        }));
  }

  // ----------------- Dispose -----------------
  @override
  void dispose() async {
    _noteController.dispose();
    super.dispose();
  }

  // ----------------- Functions -----------------
  void onNoteSubmitted(
    String value,
    BuildContext context,
    ExerciseProvider exerciseProvider,
  ) {
    FocusScope.of(context).unfocus();
    // If the note is the same as the value or the value is null or the value is empty, return
    if (selectedExercise!.note == value.trim()) {
      return;
    }

    _note = value.trim();

    selectedExercise!.note = _note;
    exerciseProvider.editExercise(selectedExercise!, context, true);
  }

  // ----------------- Build -----------------
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        child: Consumer<ExerciseProvider>(
          builder: (context, exerciseProvider, child) {
            return Column(
              // Exercise name - category - unilateral
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exercise name
                    widget.fromAnotherWidget
                        ? const SizedBox.shrink()
                        : Text(
                            selectedExercise!.exerciseName,
                            style: Theme.of(context).textTheme.titleLarge,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                    widget.fromAnotherWidget
                        ? const SizedBox.shrink()
                        : const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Exercise category
                        Text(
                          selectedExercise!.exerciseCategory,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        // Unilateral
                        selectedExercise!.unilateral
                            ? Text(
                                'Unilateral',
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    // Divider
                    const MyDivider(),
                  ],
                ),
                const SizedBox(height: 15),

                // ----------------- Note -----------------
                MyEditableText(
                  controller: _noteController,
                  onFocusChange: (p0) {
                    if (!p0) {
                      onNoteSubmitted(
                          _noteController.text, context, exerciseProvider);
                    }
                  },
                  onEditingComplete: () {
                    onNoteSubmitted(
                        _noteController.text, context, exerciseProvider);
                  },
                  onSubmitted: (p0) {
                    onNoteSubmitted(
                        _noteController.text, context, exerciseProvider);
                  },
                  onChanged: (value) {
                    _note = value;
                  },
                  maxLines: 4,
                  minLines: 1,
                  filled: true,
                  hintText: defaultNote,
                ),

                const SizedBox(height: 15),
                // ----------------- Goal -----------------
                // Set number goal X Rep number goal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Set number goal
                    Expanded(
                      child: WhiteBox(
                        border: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        title: Text(
                          'Sets',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        child: Center(
                          child: Text(
                            selectedExercise!.setNumberGoal.toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),

                    // multiplier symbol
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 5, right: 5, top: 30),
                      child: Icon(
                        Icons.clear,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),

                    // Rep number goal
                    Expanded(
                      child: WhiteBox(
                        border: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        title: Text(
                          'Reps',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        child: Center(
                          child: Text(
                            selectedExercise!.repNumberGoal.toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // ----------------- Add exercise data -----------------
                widget.isOnTraining || addDataMode
                    ? WhiteBox(
                        title: Text(
                          'Today\'s training',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        displayBackground: false,
                        child: selectedExercise!.unilateral
                            ? ExerciseDataListToFillUnilateral(
                                exerciseId: selectedExercise!.id,
                                scrollController: scrollController,
                                repNumberGoal: selectedExercise!.repNumberGoal,
                              )
                            : ExerciseDataListToFillBilateral(
                                exerciseId: selectedExercise!.id,
                                scrollController: scrollController,
                                repNumberGoal: selectedExercise!.repNumberGoal,
                              ),
                      )
                    : const SizedBox.shrink(),

                const SizedBox(height: 40),

                // -------------------- Last training data --------------------
                _isLoading
                    ? Center(
                        child: SizedBox(
                          height: 350,
                          child: Loading(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    : selectedExercise!.data.isEmpty
                        ? WhiteBox(
                            paddingLeftTitle: false,
                            displayBackground: false,
                            title: Text(
                              'Previous training',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            child: SizedBox(
                              height: 350,
                              child: Center(
                                child: NoDataText(
                                    title:
                                        'You have no data for this exercise yet. Start training!'),
                              ),
                            ),
                          )
                        // return all the data with for each
                        : getExerciseData(exerciseProvider),

                // Load more data
                _exerciseDataDisplayed >= 4 || exerciseDataLength <= 1
                    ? const SizedBox.shrink()
                    : Center(
                        child: ElevatedButton(
                          onPressed: () {
                            // if the data displayed is less than the data length
                            // increment the data displayed
                            // the data should normally be already loaded
                            if (_exerciseDataDisplayed < exerciseDataLength) {
                              setState(() {
                                _exerciseDataDisplayed += 1;
                              });
                            }
                            // Else load more data from firestore
                            else {
                              setState(() {
                                _isLoadingMoreData = true;
                              });
                              exerciseProvider
                                  .getExerciseData(_exerciseDataDisplayed + 1)
                                  .then((value) {
                                setState(() {
                                  _exerciseDataDisplayed = value;
                                  _isLoadingMoreData = false;
                                });
                              });
                            }
                          },
                          child: Text(
                            'More',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),

                const SizedBox(height: 40),

                // ------------------------ Add data --------------------------
                // Add data button
                widget.isOnTraining
                    ? const SizedBox.shrink()
                    : Row(
                        children: [
                          addDataMode
                              ? Expanded(
                                  child: Consumer<CurrentExerciseDataProvider>(
                                    builder: (context,
                                            currentExerciseDataProvider,
                                            child) =>
                                        ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          addDataMode = false;
                                        });
                                      },
                                      style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(
                                          const Size(double.infinity, 50),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Theme.of(context).colorScheme.error,
                                        ),
                                      ),
                                      child: Text(
                                        'Cancel',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          addDataMode
                              ? const SizedBox(
                                  width: 10,
                                )
                              : const SizedBox.shrink(),
                          Expanded(
                            child: Consumer2<CurrentExerciseDataProvider,
                                ExerciseProvider>(
                              builder: (context, currentExerciseDataProvider,
                                      exerciseProvider, child) =>
                                  ElevatedButton(
                                onPressed: () async {
                                  bool confirmation = false;
                                  await Utils.confirmationPopUp(
                                    context,
                                    confirmation,
                                    'Add an exercise data?',
                                    () async {
                                      if (!addDataMode) {
                                        await currentExerciseDataProvider
                                            .initializeExerciseData(
                                                selectedExercise!);
                                        // Set mode to add data
                                        setState(() {
                                          addDataMode = true;
                                        });
                                      } else {
                                        // Save the data
                                        await currentExerciseDataProvider
                                            .saveExerciseData(
                                                selectedExercise!.id,
                                                true,
                                                context);
                                        // Get the exercise data
                                        await exerciseProvider
                                            .getExerciseData();
                                        // Set mode to not add data
                                        setState(() {
                                          addDataMode = false;
                                        });
                                      }
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
                                  addDataMode ? 'Add' : 'Add an exercise data',
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

                const SizedBox(height: 40),

                Consumer<KeyboardProvider>(
                  builder: (context, keyboardProvider, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      height: (keyboardProvider.isKeyboardVisible &&
                              !keyboardProvider.isKeyboardGoingOut)
                          ? 350
                          : 0,
                      color: Colors.transparent,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Column getExerciseData(ExerciseProvider exerciseProvider) {
    return Column(
      children: [
        // for each data in the exercise data
        for (int i = 0; i < _exerciseDataDisplayed; i++)
          Column(
            children: [
              // Last training or previous training text
              WhiteBox(
                title: Text(
                  i == 0 ? 'Last training' : 'Previous training',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                paddingLeftTitle: false,
                date: selectedExercise!.data[i].date,
                displayBackground: false,
                child: ExerciseDataList(
                  exerciseData: selectedExercise!.data[i],
                  isUnilateral: selectedExercise!.unilateral,
                ),
              ),

              // Space between data
              i == _exerciseDataDisplayed - 1
                  ? const SizedBox.shrink()
                  : const SizedBox(height: 20),

              // Loading logo if loading
              _isLoadingMoreData
                  ? Center(
                      child: Loading(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
      ],
    );
  }
}
