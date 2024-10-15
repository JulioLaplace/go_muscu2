import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_muscu2/components/home/my_dropdown_button.dart';
import 'package:go_muscu2/components/home/my_textfield.dart';
import 'package:go_muscu2/components/home/my_toggle_buttons.dart';
import 'package:go_muscu2/components/utils.dart';
import 'package:go_muscu2/categories/exercise_categories.dart'
    as exercise_categories;
import 'package:go_muscu2/models/exercise.dart';
import 'package:go_muscu2/providers/exercises/add_exercise_provider.dart';
import 'package:go_muscu2/providers/bottom_sheet_provider.dart';
import 'package:go_muscu2/providers/exercises/exercise_provider.dart';
import 'package:go_muscu2/providers/keyboard_provider.dart';
import 'package:go_muscu2/providers/number_manager_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddExercisePage extends StatefulWidget {
  BottomSheetProvider bottomSheetProvider;
  bool editingMode;
  Exercise? exercise;
  AddExercisePage({
    super.key,
    required this.bottomSheetProvider,
    this.editingMode = false,
    this.exercise,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
// Controllers
  TextEditingController repNumberGoalController = TextEditingController();
  TextEditingController exerciseNameController = TextEditingController();
  TextEditingController setNumberGoalController = TextEditingController();
  String? exerciseCategory;
  // Get the exercise name from the provider:
  String? exerciseName;
  // Get set number goal from the provider:
  String? setNumberGoal;
  // Get rep number goal from the provider:
  String? repNumberGoal;
  // is unilateral
  bool? isUnilateral;

  Map<String, bool> selectedValue = {
    'No': false,
    'Yes': true,
  };

  List<bool> isSelected = [false, true];

  @override
  void initState() {
    super.initState();
    if (widget.editingMode) {
      // Initialize the values
      exerciseCategory = widget.exercise!.exerciseCategory;
      exerciseName = widget.exercise!.exerciseName;
      setNumberGoal = widget.exercise!.setNumberGoal.toString();
      repNumberGoal = widget.exercise!.repNumberGoal.toString();
      isUnilateral = widget.exercise!.unilateral;

      // Initialize the text controllers
      exerciseNameController.text = exerciseName!;
      setNumberGoalController.text = setNumberGoal!;
      repNumberGoalController.text = repNumberGoal!;
    }
  }

  @override
  void dispose() {
    repNumberGoalController.dispose();
    exerciseNameController.dispose();
    setNumberGoalController.dispose();
    super.dispose();
  }

  void changeIsUnilateral(bool value) {
    setState(() {
      isSelected = [!value, value];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.editingMode) {
      Provider.of<AddExerciseProvider>(context)
          .setSetNumberGoal(setNumberGoal!);
      Provider.of<AddExerciseProvider>(context)
          .setRepNumberGoal(repNumberGoal!);
      Provider.of<AddExerciseProvider>(context).setExerciseName(exerciseName!);
      Provider.of<AddExerciseProvider>(context).setIsUnilateral(isUnilateral!);
    } else {
      // Get the exercise name from the provider:
      exerciseName = Provider.of<AddExerciseProvider>(context).exerciseName;
      // Get set number goal from the provider:
      setNumberGoal = Provider.of<AddExerciseProvider>(context).setNumberGoal;
      // Get rep number goal from the provider:
      repNumberGoal = Provider.of<AddExerciseProvider>(context).repNumberGoal;
      // Get the exercise isUnilateral from the provider:
      isUnilateral = Provider.of<AddExerciseProvider>(context).isUnilateral;
      // Get the exercise category from the provider:
      exerciseCategory =
          Provider.of<AddExerciseProvider>(context).exerciseCategory;
      setNumberGoalController.text = setNumberGoal!;
      repNumberGoalController.text = repNumberGoal!;
      exerciseNameController.text = exerciseName!;
    }
    log('isUnilateral: $isUnilateral');
    changeIsUnilateral(isUnilateral!);

    // Set the text controllers

    return Consumer<KeyboardProvider>(
      builder: (context, keyboardProvider, child) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Add a new exercise
              Text(
                widget.editingMode ? 'Edit the workout' : 'Add a new exercise',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 40),
              // Choose title in a text field
              Consumer<AddExerciseProvider>(
                builder: (context, addexerciseProvider, child) => MyTextfield(
                  controller: exerciseNameController,
                  hintText: 'Title',
                  filledColor: Colors.white,
                  onChanged: (value) {
                    addexerciseProvider.setExerciseName(value);
                  },
                ),
              ),

              const SizedBox(height: 20),

              // choose set number and rep number goal
              Row(
                children: [
                  // set number goal
                  Consumer2<AddExerciseProvider, NumberManagerProvider>(
                    builder: (context, addexerciseProvider,
                            numberManagerProvider, child) =>
                        Expanded(
                      child: MyTextfield(
                        controller: setNumberGoalController,
                        hintText: 'Set number goal',
                        filledColor: Colors.white,
                        keyboardType: TextInputType.number,
                        selectAll: true,
                        onChanged: (value) {
                          String newNumber =
                              numberManagerProvider.checkNumberFormat(value);
                          addexerciseProvider.setSetNumberGoal(newNumber);
                          setState(() {
                            setNumberGoalController.text = newNumber;
                          });
                        },
                      ),
                    ),
                  ),

                  // multiplier symbol
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(
                      Icons.clear,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),

                  // rep number goal
                  Consumer2<AddExerciseProvider, NumberManagerProvider>(
                    builder: (context, addexerciseProvider,
                            numberManagerProvider, child) =>
                        Expanded(
                      child: MyTextfield(
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: false,
                        ),
                        controller: repNumberGoalController,
                        hintText: 'Rep number goal',
                        filledColor: Colors.white,
                        selectAll: true,
                        onChanged: (value) {
                          String newNumber =
                              numberManagerProvider.checkNumberFormat(value);
                          addexerciseProvider.setRepNumberGoal(newNumber);
                          setState(() {
                            repNumberGoalController.text = newNumber;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // Choose if the exercise is unilateral
              Consumer<AddExerciseProvider>(
                builder: (context, addExerciseProvider, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Unilateral',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 20),
                    MyToggleButtons(
                      disabled: widget.editingMode,
                      children: selectedValue,
                      isSelected: isSelected,
                      alertProvider: () {
                        addExerciseProvider.setIsUnilateral(isSelected[1]);
                        log('isUnilateral: ${isSelected[1]}');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // Choose the category in a dropdown
              Consumer<AddExerciseProvider>(
                builder: (context, addExerciseProvider, child) =>
                    MyDropdownButton(
                  dropdownTitle: 'Select the training category',
                  items: exercise_categories.exercisesCategories,
                  selectedValue: exerciseCategory,
                  onChanged: (value) {
                    addExerciseProvider.setExerciseCategory(value!);
                    setState(() {
                      exerciseCategory = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),
              // Add new exercise button or cancel button
              Consumer2<AddExerciseProvider, ExerciseProvider>(
                builder:
                    (context, addExerciseProvider, exerciseProvider, child) =>
                        Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Cancel button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.bottomSheetProvider.removeBottomSheetWidget();
                          widget.bottomSheetProvider.closeBottomSheet();
                          addExerciseProvider.reset();
                        },
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                            const Size(double.infinity, 50),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Add new exercise button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (exerciseNameController.text.trim().isEmpty) {
                            Utils.errorPopUp(context, 'Please enter a title');
                            return;
                          }
                          if (setNumberGoalController.text.trim().isEmpty) {
                            Utils.errorPopUp(
                                context, 'Please enter a set number goal');
                            return;
                          }
                          if (repNumberGoalController.text.trim().isEmpty) {
                            Utils.errorPopUp(
                                context, 'Please enter a rep number goal');
                            return;
                          }
                          if (exerciseCategory == null) {
                            Utils.errorPopUp(
                                context, 'Please select a category');
                            return;
                          }
                          if (widget.editingMode) {
                            // edit the workout in the database
                            await exerciseProvider.editExercise(
                                Exercise(
                                  id: widget.exercise!.id,
                                  exerciseName:
                                      exerciseNameController.text.trim(),
                                  exerciseCategory: exerciseCategory!,
                                  unilateral: addExerciseProvider.isUnilateral,
                                  setNumberGoal:
                                      setNumberGoalController.text.trim(),
                                  repNumberGoal:
                                      repNumberGoalController.text.trim(),
                                  image: widget.exercise!.image,
                                  dataString: widget.exercise!.dataString,
                                  data: widget.exercise!.data,
                                ),
                                context);
                            // reset and close the bottom sheet
                            widget.bottomSheetProvider.closeBottomSheet();
                            widget.bottomSheetProvider
                                .removeBottomSheetWidget();
                            addExerciseProvider.reset();
                            return;
                          } else {
                            // add the exercise to the database
                            await exerciseProvider.addExercise(
                                Exercise(
                                    id: '',
                                    exerciseName:
                                        exerciseNameController.text.trim(),
                                    exerciseCategory: exerciseCategory!,
                                    unilateral:
                                        addExerciseProvider.isUnilateral,
                                    setNumberGoal:
                                        addExerciseProvider.setNumberGoal,
                                    repNumberGoal:
                                        addExerciseProvider.repNumberGoal,
                                    image: '',
                                    dataString: [],
                                    data: []),
                                context);
                            // reset and close the bottom sheet
                            widget.bottomSheetProvider.closeBottomSheet();
                            widget.bottomSheetProvider
                                .removeBottomSheetWidget();
                            addExerciseProvider.reset();
                          }
                        },
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                            const Size(double.infinity, 50),
                          ),
                        ),
                        child: Text(
                          widget.editingMode ? 'Edit' : 'Add',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (keyboardProvider.isKeyboardVisible)
                Container(
                  height: keyboardProvider.keyboardHeight,
                  color: Colors.transparent,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
