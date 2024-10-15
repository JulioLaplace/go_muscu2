import 'package:flutter/material.dart';
import 'package:go_muscu2/components/home/my_dropdown_button.dart';
import 'package:go_muscu2/components/home/my_textfield.dart';
import 'package:go_muscu2/components/utils.dart';
import 'package:go_muscu2/categories/training_categories.dart'
    as training_categories;
import 'package:go_muscu2/models/training.dart';
import 'package:go_muscu2/providers/keyboard_provider.dart';
import 'package:go_muscu2/providers/workouts/add_workout_provider.dart';
import 'package:go_muscu2/providers/bottom_sheet_provider.dart';
import 'package:go_muscu2/providers/workouts/workout_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddWorkoutPage extends StatefulWidget {
  BottomSheetProvider bottomSheetProvider;
  bool editingMode;
  Training? training;
  AddWorkoutPage({
    super.key,
    required this.bottomSheetProvider,
    this.editingMode = false,
    this.training,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddWorkoutPageState createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  String? workoutCategory;

  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.editingMode
        ? workoutCategory = widget.training!.trainingCategory
        : null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the workout name from the provider:
    final workoutName = Provider.of<AddWorkoutProvider>(context).workoutName;

    // Get the workout category from the provider:
    Provider.of<AddWorkoutProvider>(context)
        .setWorkoutCategory(workoutCategory);
    workoutCategory = Provider.of<AddWorkoutProvider>(context).workoutCategory;

    titleController.text =
        widget.editingMode ? widget.training!.trainingName : workoutName;

    return Consumer<KeyboardProvider>(
      builder: (context, keyboardProvider, child) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Add a new workout
              Text(
                widget.editingMode ? 'Edit the workout' : 'Add a new workout',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 40),
              // Choose title in a text field
              Consumer<AddWorkoutProvider>(
                builder: (context, addWorkoutProvider, child) => MyTextfield(
                  controller: titleController,
                  hintText: 'Title',
                  filledColor: Colors.white,
                  onChanged: (value) {
                    addWorkoutProvider.setWorkoutName(value);
                  },
                ),
              ),

              const SizedBox(height: 20),
              // Choose the category in a dropdown
              Consumer<AddWorkoutProvider>(
                builder: (context, addWorkoutProvider, child) =>
                    MyDropdownButton(
                  dropdownTitle: 'Select the training category',
                  items: training_categories.trainingCategories,
                  selectedValue: workoutCategory,
                  onChanged: (value) {
                    addWorkoutProvider.setWorkoutCategory(value!);
                    setState(() {
                      workoutCategory = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),
              // Add new workout button or cancel button
              Consumer2<AddWorkoutProvider, WorkoutProvider>(
                builder:
                    (context, addWorkoutProvider, workoutProvider, child) =>
                        Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Cancel button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.bottomSheetProvider.removeBottomSheetWidget();
                          widget.bottomSheetProvider.closeBottomSheet();
                          addWorkoutProvider.reset();
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
                    // Add/ update new workout button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (titleController.text.trim().isEmpty) {
                            Utils.errorPopUp(context, 'Please enter a title');
                            return;
                          }
                          if (workoutCategory == null) {
                            Utils.errorPopUp(
                                context, 'Please select a category');
                            return;
                          }
                          if (widget.editingMode) {
                            // edit the workout in the database
                            await workoutProvider.editTraining(
                                Training(
                                    id: widget.training!.id,
                                    trainingName: titleController.text.trim(),
                                    trainingCategory: workoutCategory!,
                                    exercises: widget.training!.exercises,
                                    lastTrainingDate:
                                        widget.training!.lastTrainingDate),
                                context);
                            // reset and close the bottom sheet
                            widget.bottomSheetProvider.closeBottomSheet();
                            widget.bottomSheetProvider
                                .removeBottomSheetWidget();
                            addWorkoutProvider.reset();
                            return;
                          } else {
                            // add the workout to the database
                            await workoutProvider.addTraining(
                                Training(
                                    id: widget.editingMode
                                        ? widget.training!.id
                                        : '',
                                    trainingName: titleController.text.trim(),
                                    trainingCategory: workoutCategory!,
                                    exercises: []),
                                context);
                            // reset and close the bottom sheet
                            // wait 2 seconds
                            widget.bottomSheetProvider.closeBottomSheet();
                            widget.bottomSheetProvider
                                .removeBottomSheetWidget();
                            addWorkoutProvider.reset();
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
            ],
          ),
        ),
      ),
    );
  }
}
