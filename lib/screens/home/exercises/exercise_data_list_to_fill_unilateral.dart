import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart';
import 'package:go_muscu2/components/home/my_editable_text.dart';
import 'package:go_muscu2/components/home/my_icon_button.dart';
import 'package:go_muscu2/components/home/white_box.dart';
import 'package:go_muscu2/models/setsAndReps/unilateral_set_and_rep.dart';
import 'package:go_muscu2/providers/current_workout/current_exercise_data_provider.dart';
import 'package:go_muscu2/providers/exercises/exercise_provider.dart';
import 'package:go_muscu2/providers/keyboard_provider.dart';
import 'package:go_muscu2/providers/number_manager_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ExerciseDataListToFillUnilateral extends StatefulWidget {
  String exerciseId;
  String repNumberGoal;
  ScrollController? scrollController;
  ExerciseDataListToFillUnilateral({
    super.key,
    required this.exerciseId,
    this.scrollController,
    required this.repNumberGoal,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ExerciseDataListToFillUnilateralState createState() =>
      _ExerciseDataListToFillUnilateralState();
}

class _ExerciseDataListToFillUnilateralState
    extends State<ExerciseDataListToFillUnilateral> {
  // ----------------- Variables -----------------

  // Text controllers
  // Left side
  List<TextEditingController> leftRepsControllers = [];
  List<TextEditingController> leftWeightControllers = [];
  List<TextEditingController> leftAdditionalRepsControllers = [];
  List<TextEditingController> leftAdditionalWeightControllers = [];

  // Right side
  List<TextEditingController> rightRepsControllers = [];
  List<TextEditingController> rightWeightControllers = [];
  List<TextEditingController> rightAdditionalRepsControllers = [];
  List<TextEditingController> rightAdditionalWeightControllers = [];

  List<TextEditingController> noteControllers = [];

  // ----------------- Init State -----------------
  @override
  void initState() {
    super.initState();
  }

  // ----------------- Dispose -----------------
  @override
  void dispose() {
    for (int i = 0; i < leftRepsControllers.length; i++) {
      // Left side
      leftRepsControllers[i].dispose();
      leftWeightControllers[i].dispose();
      leftAdditionalRepsControllers[i].dispose();
      leftAdditionalWeightControllers[i].dispose();

      // Right side
      rightRepsControllers[i].dispose();
      rightWeightControllers[i].dispose();
      rightAdditionalRepsControllers[i].dispose();
      rightAdditionalWeightControllers[i].dispose();

      // Note
      noteControllers[i].dispose();
    }
    super.dispose();
  }

  // ----------------- Build -----------------
  @override
  Widget build(BuildContext context) {
    return Consumer2<CurrentExerciseDataProvider, ExerciseProvider>(
      builder:
          (context, currentExerciseDataProvider, exerciseProvider, child) =>
              Column(
        children: buildDataList(currentExerciseDataProvider, exerciseProvider),
      ),
    );
  }

  List<Widget> buildDataList(
    CurrentExerciseDataProvider currentExerciseDataProvider,
    ExerciseProvider exerciseProvider,
  ) {
    List<Widget> rows = [];

    // first row : title
    // Set number, Rep number, Weight
    rows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Set number
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Text(
                'Set',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),

          // Rep number
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Text(
                'Reps',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),

          // Weight
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Text(
                'Weight',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
        ],
      ),
    );

    // Data list
    createDataList(rows, currentExerciseDataProvider);

    return rows;
  }

  // Create the data list for bilateral exercises
  createDataList(
    List<Widget> rows,
    CurrentExerciseDataProvider currentExerciseDataProvider,
  ) {
    // Cast SetAndRep to BilateralSetAndRep
    List<UnilateralSetAndRep> setAndRep = currentExerciseDataProvider
        .currentDataExercises[widget.exerciseId]!.setsAndReps
        .cast<UnilateralSetAndRep>();
    // Get the length of the setsAndReps
    int length = setAndRep.length;
    // Get the rep number goal
    String repNumberGoal = widget.repNumberGoal;

    for (int i = 0; i < length; i++) {
      // Add text controllers
      // Left side
      leftRepsControllers
          .add(TextEditingController(text: setAndRep[i].repNumberLeft));
      leftWeightControllers
          .add(TextEditingController(text: setAndRep[i].weightLeft));
      leftAdditionalRepsControllers.add(
          TextEditingController(text: setAndRep[i].additionalRepNumberLeft));
      leftAdditionalWeightControllers
          .add(TextEditingController(text: setAndRep[i].additionalWeightLeft));

      // Right side
      rightRepsControllers
          .add(TextEditingController(text: setAndRep[i].repNumberRight));
      rightWeightControllers
          .add(TextEditingController(text: setAndRep[i].weightRight));
      rightAdditionalRepsControllers.add(
          TextEditingController(text: setAndRep[i].additionalRepNumberRight));
      rightAdditionalWeightControllers
          .add(TextEditingController(text: setAndRep[i].additionalWeightRight));

      // Note
      noteControllers.add(TextEditingController(text: setAndRep[i].note));

      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              // Reps and weight left side
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Set number
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Text(
                        (setAndRep[i].setNumber).toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),

                  // Rep number
                  Expanded(
                    flex: 2,
                    child: WhiteBox(
                      border: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Center(
                        child:
                            Consumer2<NumberManagerProvider, KeyboardProvider>(
                          builder: (context, numberManagerProvider,
                                  keyboardProvider, child) =>
                              MyEditableText(
                            onFocusChange: (p0) {
                              if (!p0) {
                                if (leftRepsControllers[i].text.isEmpty) {
                                  leftRepsControllers[i].text =
                                      currentExerciseDataProvider
                                          .currentTextFieldValue;
                                  return;
                                }
                                if (leftRepsControllers[i].text == '0') {
                                  removeLineData(setAndRep, i,
                                      currentExerciseDataProvider);
                                  return;
                                }
                                leftRepsControllers[i].text =
                                    numberManagerProvider.validNumberFormat(
                                        leftRepsControllers[i].text);

                                // update SetAndRep
                                setAndRep[i].repNumberLeft =
                                    leftRepsControllers[i].text.trim();
                                // Update the provider
                                currentExerciseDataProvider.setExerciseData(
                                  widget.exerciseId,
                                  setAndRep,
                                );
                              }
                            },
                            controller: leftRepsControllers[i],
                            isDense: true,
                            center: true,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                            onTap: () {
                              // Select all
                              leftRepsControllers[i].selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                      leftRepsControllers[i].text.length);
                              // Save the current value
                              currentExerciseDataProvider
                                      .currentTextFieldValue =
                                  leftRepsControllers[i].text;
                            },
                            onChanged: (p0) {
                              setState(() {
                                leftRepsControllers[i].text =
                                    numberManagerProvider.checkNumberFormat(p0);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  // multiplier symbol
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    child: Icon(
                      Icons.clear,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                  ),

                  // Weight
                  Expanded(
                    flex: 3,
                    child: WhiteBox(
                      border: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Center(
                        child: Consumer<NumberManagerProvider>(
                          builder: (context, numberManagerProvider, child) =>
                              MyEditableText(
                            controller: leftWeightControllers[i],
                            isDense: true,
                            center: true,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            onFocusChange: (p0) {
                              if (!p0) {
                                if (leftWeightControllers[i].text.isEmpty) {
                                  leftWeightControllers[i].text =
                                      currentExerciseDataProvider
                                          .currentTextFieldValue;
                                  return;
                                }
                                leftWeightControllers[i].text =
                                    numberManagerProvider.validNumberFormat(
                                        leftWeightControllers[i].text);

                                // update SetAndRep
                                setAndRep[i].weightLeft =
                                    leftWeightControllers[i].text.trim();
                                // Update the provider
                                currentExerciseDataProvider.setExerciseData(
                                  widget.exerciseId,
                                  setAndRep,
                                );
                              }
                            },
                            onTap: () {
                              // Select all
                              leftWeightControllers[i].selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          leftWeightControllers[i].text.length);
                              // Save the current value
                              currentExerciseDataProvider
                                      .currentTextFieldValue =
                                  leftWeightControllers[i].text;
                            },
                            onChanged: (p0) {
                              setState(() {
                                leftWeightControllers[i].text =
                                    numberManagerProvider.checkNumberFormat(p0);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Add button to add a set
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    child: MyIconButton(
                      onPressed: () {
                        removeLineData(
                            setAndRep, i, currentExerciseDataProvider);
                      },
                      icon: Icons.remove_rounded,
                      containerColor: Theme.of(context).colorScheme.secondary,
                      containerColorOnTap:
                          Theme.of(context).colorScheme.primary,
                      iconColor: Colors.white,
                      borderRadius: BorderRadius.circular(radius),
                      height: 30,
                      width: 30,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              // Additional reps and weight left side
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Additional Reps text or Additional Reps and Weight text
                  checkDisplayAdditionalSetLeft(setAndRep, i)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Text(
                            'Additional Reps',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )
                      : Expanded(
                          child: Row(
                            children: [
                              // Set number
                              const Expanded(
                                flex: 1,
                                child: SizedBox(),
                              ),

                              // Additional rep number
                              Expanded(
                                flex: 2,
                                child: WhiteBox(
                                  border: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Center(
                                    child: Consumer2<NumberManagerProvider,
                                        KeyboardProvider>(
                                      builder: (context, numberManagerProvider,
                                              keyboardProvider, child) =>
                                          MyEditableText(
                                        controller:
                                            leftAdditionalRepsControllers[i],
                                        isDense: true,
                                        center: true,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                          decimal: true,
                                          signed: false,
                                        ),
                                        onFocusChange: (p0) {
                                          if (!p0) {
                                            if (leftAdditionalRepsControllers[i]
                                                .text
                                                .isEmpty) {
                                              leftAdditionalRepsControllers[i]
                                                      .text =
                                                  currentExerciseDataProvider
                                                      .currentTextFieldValue;
                                              return;
                                            }
                                            if (leftAdditionalRepsControllers[i]
                                                    .text ==
                                                '0') {
                                              removeAdditionalSetLeft(
                                                  setAndRep,
                                                  i,
                                                  currentExerciseDataProvider);
                                              return;
                                            }
                                            leftAdditionalRepsControllers[i]
                                                    .text =
                                                numberManagerProvider
                                                    .validNumberFormat(
                                                        leftAdditionalRepsControllers[
                                                                i]
                                                            .text);

                                            // update SetAndRep
                                            setAndRep[i]
                                                    .additionalRepNumberLeft =
                                                leftAdditionalRepsControllers[i]
                                                    .text
                                                    .trim();
                                            // Update the provider
                                            currentExerciseDataProvider
                                                .setExerciseData(
                                              widget.exerciseId,
                                              setAndRep,
                                            );
                                          }
                                        },
                                        onTap: () {
                                          // Select all
                                          leftAdditionalRepsControllers[i]
                                                  .selection =
                                              TextSelection(
                                                  baseOffset: 0,
                                                  extentOffset:
                                                      leftAdditionalRepsControllers[
                                                              i]
                                                          .text
                                                          .length);
                                          // Save the current value
                                          currentExerciseDataProvider
                                                  .currentTextFieldValue =
                                              leftAdditionalRepsControllers[i]
                                                  .text;
                                        },
                                        onChanged: (p0) {
                                          setState(() {
                                            leftAdditionalRepsControllers[i]
                                                    .text =
                                                numberManagerProvider
                                                    .checkNumberFormat(p0);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // multiplier symbol
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                child: Icon(
                                  Icons.clear,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 20,
                                ),
                              ),

                              // Additional weight
                              Expanded(
                                flex: 3,
                                child: WhiteBox(
                                  border: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Center(
                                    child: Consumer<NumberManagerProvider>(
                                      builder: (context, numberManagerProvider,
                                              child) =>
                                          MyEditableText(
                                        controller:
                                            leftAdditionalWeightControllers[i],
                                        isDense: true,
                                        center: true,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                          decimal: true,
                                          signed: true,
                                        ),
                                        onFocusChange: (p0) {
                                          if (!p0) {
                                            if (leftAdditionalWeightControllers[
                                                    i]
                                                .text
                                                .isEmpty) {
                                              leftAdditionalWeightControllers[i]
                                                      .text =
                                                  currentExerciseDataProvider
                                                      .currentTextFieldValue;
                                              return;
                                            }
                                            leftAdditionalWeightControllers[i]
                                                    .text =
                                                numberManagerProvider
                                                    .validNumberFormat(
                                                        leftAdditionalWeightControllers[
                                                                i]
                                                            .text);

                                            // update SetAndRep
                                            setAndRep[i].additionalWeightLeft =
                                                leftAdditionalWeightControllers[
                                                        i]
                                                    .text
                                                    .trim();
                                            // Update the provider
                                            currentExerciseDataProvider
                                                .setExerciseData(
                                              widget.exerciseId,
                                              setAndRep,
                                            );
                                          }
                                        },
                                        onTap: () {
                                          // Select all
                                          leftAdditionalWeightControllers[i]
                                                  .selection =
                                              TextSelection(
                                                  baseOffset: 0,
                                                  extentOffset:
                                                      leftAdditionalWeightControllers[
                                                              i]
                                                          .text
                                                          .length);
                                          // Save the current value
                                          currentExerciseDataProvider
                                                  .currentTextFieldValue =
                                              leftAdditionalWeightControllers[i]
                                                  .text;
                                        },
                                        onChanged: (p0) {
                                          setState(() {
                                            leftAdditionalWeightControllers[i]
                                                    .text =
                                                numberManagerProvider
                                                    .checkNumberFormat(p0);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                  // Add button (additionnal set)
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
                    child: MyIconButton(
                      onPressed: () {
                        checkDisplayAdditionalSetLeft(setAndRep, i)
                            ? addAdditionalSetLeft(
                                setAndRep,
                                i,
                                currentExerciseDataProvider,
                              )
                            : removeAdditionalSetLeft(
                                setAndRep,
                                i,
                                currentExerciseDataProvider,
                              );
                      },
                      icon: checkDisplayAdditionalSetLeft(setAndRep, i)
                          ? Icons.add_rounded
                          : Icons.remove_rounded,
                      containerColor: Theme.of(context).colorScheme.primary,
                      containerColorOnTap:
                          Theme.of(context).colorScheme.secondary,
                      iconColor: Colors.black,
                      borderRadius: BorderRadius.circular(radius),
                      height: 30,
                      width: 30,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              // Reps and weight right side
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Set number
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Text(
                        'R',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),

                  // Rep number
                  Expanded(
                    flex: 2,
                    child: WhiteBox(
                      border: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Center(
                        child:
                            Consumer2<NumberManagerProvider, KeyboardProvider>(
                          builder: (context, numberManagerProvider,
                                  keyboardProvider, child) =>
                              MyEditableText(
                            onFocusChange: (p0) {
                              if (!p0) {
                                if (rightRepsControllers[i].text.isEmpty) {
                                  rightRepsControllers[i].text =
                                      currentExerciseDataProvider
                                          .currentTextFieldValue;
                                  return;
                                }
                                if (rightRepsControllers[i].text == '0') {
                                  removeLineData(setAndRep, i,
                                      currentExerciseDataProvider);
                                  return;
                                }
                                rightRepsControllers[i].text =
                                    numberManagerProvider.validNumberFormat(
                                        rightRepsControllers[i].text);

                                // update SetAndRep
                                setAndRep[i].repNumberRight =
                                    rightRepsControllers[i].text.trim();
                                // Update the provider
                                currentExerciseDataProvider.setExerciseData(
                                  widget.exerciseId,
                                  setAndRep,
                                );
                              }
                            },
                            controller: rightRepsControllers[i],
                            isDense: true,
                            center: true,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                            onTap: () {
                              // Select all
                              rightRepsControllers[i].selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                      rightRepsControllers[i].text.length);
                              // Save the current value
                              currentExerciseDataProvider
                                      .currentTextFieldValue =
                                  rightRepsControllers[i].text;
                            },
                            onChanged: (p0) {
                              setState(() {
                                rightRepsControllers[i].text =
                                    numberManagerProvider.checkNumberFormat(p0);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  // multiplier symbol
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    child: Icon(
                      Icons.clear,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                  ),

                  // Weight
                  Expanded(
                    flex: 3,
                    child: WhiteBox(
                      border: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Center(
                        child: Consumer<NumberManagerProvider>(
                          builder: (context, numberManagerProvider, child) =>
                              MyEditableText(
                            controller: rightWeightControllers[i],
                            isDense: true,
                            center: true,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            onFocusChange: (p0) {
                              if (!p0) {
                                if (rightWeightControllers[i].text.isEmpty) {
                                  rightWeightControllers[i].text =
                                      currentExerciseDataProvider
                                          .currentTextFieldValue;
                                  return;
                                }
                                rightWeightControllers[i].text =
                                    numberManagerProvider.validNumberFormat(
                                        rightWeightControllers[i].text);

                                // update SetAndRep
                                setAndRep[i].weightRight =
                                    rightWeightControllers[i].text.trim();
                                // Update the provider
                                currentExerciseDataProvider.setExerciseData(
                                  widget.exerciseId,
                                  setAndRep,
                                );
                              }
                            },
                            onTap: () {
                              // Select all
                              rightWeightControllers[i].selection =
                                  TextSelection(
                                      baseOffset: 0,
                                      extentOffset: rightWeightControllers[i]
                                          .text
                                          .length);
                              // Save the current value
                              currentExerciseDataProvider
                                      .currentTextFieldValue =
                                  rightWeightControllers[i].text;
                            },
                            onChanged: (p0) {
                              setState(() {
                                rightWeightControllers[i].text =
                                    numberManagerProvider.checkNumberFormat(p0);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Add button to add a set
                  const Padding(
                    padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    child: SizedBox(
                      height: 30,
                      width: 30,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              // Additional reps and weight right side
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Additional Reps text or Additional Reps and Weight text
                  checkDisplayAdditionalSetRight(setAndRep, i)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Text(
                            'Additional Reps',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )
                      : Expanded(
                          child: Row(
                            children: [
                              // Set number
                              const Expanded(
                                flex: 1,
                                child: SizedBox(),
                              ),

                              // Additional rep number
                              Expanded(
                                flex: 2,
                                child: WhiteBox(
                                  border: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Center(
                                    child: Consumer2<NumberManagerProvider,
                                        KeyboardProvider>(
                                      builder: (context, numberManagerProvider,
                                              keyboardProvider, child) =>
                                          MyEditableText(
                                        controller:
                                            rightAdditionalRepsControllers[i],
                                        isDense: true,
                                        center: true,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                          decimal: true,
                                          signed: false,
                                        ),
                                        onFocusChange: (p0) {
                                          if (!p0) {
                                            if (rightAdditionalRepsControllers[
                                                    i]
                                                .text
                                                .isEmpty) {
                                              rightAdditionalRepsControllers[i]
                                                      .text =
                                                  currentExerciseDataProvider
                                                      .currentTextFieldValue;
                                              return;
                                            }
                                            if (rightAdditionalRepsControllers[
                                                        i]
                                                    .text ==
                                                '0') {
                                              removeAdditionalSetLeft(
                                                  setAndRep,
                                                  i,
                                                  currentExerciseDataProvider);
                                              return;
                                            }
                                            rightAdditionalRepsControllers[i]
                                                    .text =
                                                numberManagerProvider
                                                    .validNumberFormat(
                                                        rightAdditionalRepsControllers[
                                                                i]
                                                            .text);

                                            // update SetAndRep
                                            setAndRep[i]
                                                    .additionalRepNumberRight =
                                                rightAdditionalRepsControllers[
                                                        i]
                                                    .text
                                                    .trim();
                                            // Update the provider
                                            currentExerciseDataProvider
                                                .setExerciseData(
                                              widget.exerciseId,
                                              setAndRep,
                                            );
                                          }
                                        },
                                        onTap: () {
                                          // Select all
                                          rightAdditionalRepsControllers[i]
                                                  .selection =
                                              TextSelection(
                                                  baseOffset: 0,
                                                  extentOffset:
                                                      rightAdditionalRepsControllers[
                                                              i]
                                                          .text
                                                          .length);
                                          // Save the current value
                                          currentExerciseDataProvider
                                                  .currentTextFieldValue =
                                              rightAdditionalRepsControllers[i]
                                                  .text;
                                        },
                                        onChanged: (p0) {
                                          setState(() {
                                            rightAdditionalRepsControllers[i]
                                                    .text =
                                                numberManagerProvider
                                                    .checkNumberFormat(p0);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // multiplier symbol
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                child: Icon(
                                  Icons.clear,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 20,
                                ),
                              ),

                              // Additional weight
                              Expanded(
                                flex: 3,
                                child: WhiteBox(
                                  border: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: Center(
                                    child: Consumer<NumberManagerProvider>(
                                      builder: (context, numberManagerProvider,
                                              child) =>
                                          MyEditableText(
                                        controller:
                                            rightAdditionalWeightControllers[i],
                                        isDense: true,
                                        center: true,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                          decimal: true,
                                          signed: true,
                                        ),
                                        onFocusChange: (p0) {
                                          if (!p0) {
                                            if (rightAdditionalWeightControllers[
                                                    i]
                                                .text
                                                .isEmpty) {
                                              rightAdditionalWeightControllers[
                                                          i]
                                                      .text =
                                                  currentExerciseDataProvider
                                                      .currentTextFieldValue;
                                              return;
                                            }
                                            rightAdditionalWeightControllers[i]
                                                    .text =
                                                numberManagerProvider
                                                    .validNumberFormat(
                                                        rightAdditionalWeightControllers[
                                                                i]
                                                            .text);

                                            // update SetAndRep
                                            setAndRep[i].additionalWeightRight =
                                                rightAdditionalWeightControllers[
                                                        i]
                                                    .text
                                                    .trim();
                                            // Update the provider
                                            currentExerciseDataProvider
                                                .setExerciseData(
                                              widget.exerciseId,
                                              setAndRep,
                                            );
                                          }
                                        },
                                        onTap: () {
                                          // Select all
                                          rightAdditionalWeightControllers[i]
                                                  .selection =
                                              TextSelection(
                                                  baseOffset: 0,
                                                  extentOffset:
                                                      rightAdditionalWeightControllers[
                                                              i]
                                                          .text
                                                          .length);
                                          // Save the current value
                                          currentExerciseDataProvider
                                                  .currentTextFieldValue =
                                              rightAdditionalWeightControllers[
                                                      i]
                                                  .text;
                                        },
                                        onChanged: (p0) {
                                          setState(() {
                                            rightAdditionalWeightControllers[i]
                                                    .text =
                                                numberManagerProvider
                                                    .checkNumberFormat(p0);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                  // Add button (additionnal set)
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
                    child: MyIconButton(
                      onPressed: () {
                        checkDisplayAdditionalSetRight(setAndRep, i)
                            ? addAdditionalSetRight(
                                setAndRep,
                                i,
                                currentExerciseDataProvider,
                              )
                            : removeAdditionalSetRight(
                                setAndRep,
                                i,
                                currentExerciseDataProvider,
                              );
                      },
                      icon: checkDisplayAdditionalSetRight(setAndRep, i)
                          ? Icons.add_rounded
                          : Icons.remove_rounded,
                      containerColor: Theme.of(context).colorScheme.primary,
                      containerColorOnTap:
                          Theme.of(context).colorScheme.secondary,
                      iconColor: Colors.black,
                      borderRadius: BorderRadius.circular(radius),
                      height: 30,
                      width: 30,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              // Note
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                    flex: 6,
                    child: // ----------------- Note -----------------
                        MyEditableText(
                      controller: noteControllers[i],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      onFocusChange: (p0) {
                        if (!p0) {
                          onNoteSubmitted(noteControllers[i].text, setAndRep, i,
                              currentExerciseDataProvider);
                        }
                      },
                      onEditingComplete: () {
                        onNoteSubmitted(noteControllers[i].text, setAndRep, i,
                            currentExerciseDataProvider);
                      },
                      onSubmitted: (p0) {
                        onNoteSubmitted(noteControllers[i].text, setAndRep, i,
                            currentExerciseDataProvider);
                      },
                      onChanged: (value) {},
                      maxLines: 4,
                      minLines: 1,
                      isDense: true,
                      filled: true,
                      hintText: 'Insert a note',
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    }

    // Add button to add a set
    rows.add(MyIconButton(
      onPressed: () {
        addLineData(setAndRep, currentExerciseDataProvider, repNumberGoal);
        Future.delayed(const Duration(milliseconds: 200), () {
          widget.scrollController?.animateTo(
            widget.scrollController!.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        });
      },
      icon: Icons.add_rounded,
      containerColor: Theme.of(context).colorScheme.secondary,
      containerColorOnTap: Theme.of(context).colorScheme.primary,
      iconColor: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      height: 30,
      width: double.maxFinite,
    ));
  }

  // Add a line of data
  addLineData(
    List<UnilateralSetAndRep> setAndRep,
    CurrentExerciseDataProvider currentExerciseDataProvider,
    String repNumberGoal,
  ) {
    setState(() {
      // Add a new set and rep
      setAndRep.add(
        currentExerciseDataProvider.getEmptySetAndRepUnilateral(
          setAndRep.length + 1,
          repNumberGoal,
        ),
      );
      // Left side
      leftRepsControllers.add(TextEditingController(text: repNumberGoal));
      leftWeightControllers.add(TextEditingController(text: '0'));
      leftAdditionalRepsControllers.add(TextEditingController());
      leftAdditionalWeightControllers.add(TextEditingController());

      // Right side
      rightRepsControllers.add(TextEditingController(text: repNumberGoal));
      rightWeightControllers.add(TextEditingController(text: '0'));
      rightAdditionalRepsControllers.add(TextEditingController());
      rightAdditionalWeightControllers.add(TextEditingController());

      // Note
      noteControllers.add(TextEditingController());

      // Update the provider
      currentExerciseDataProvider.setExerciseData(
        widget.exerciseId,
        setAndRep,
      );
    });
  }

  // Remove a line of data at index i
  removeLineData(
    List<UnilateralSetAndRep> setAndRep,
    int index,
    CurrentExerciseDataProvider currentExerciseDataProvider,
  ) {
    setState(() {
      // Left side
      leftRepsControllers.removeAt(index);
      leftWeightControllers.removeAt(index);
      leftAdditionalRepsControllers.removeAt(index);
      leftAdditionalWeightControllers.removeAt(index);

      // Right side
      rightRepsControllers.removeAt(index);
      rightWeightControllers.removeAt(index);
      rightAdditionalRepsControllers.removeAt(index);
      rightAdditionalWeightControllers.removeAt(index);

      noteControllers.removeAt(index);
      setAndRep.removeAt(index);
      updateIndex(setAndRep, currentExerciseDataProvider);
// Update the provider
      currentExerciseDataProvider.setExerciseData(
        widget.exerciseId,
        setAndRep,
      );
    });
  }

  // Add additional set at index i (left side)
  addAdditionalSetLeft(
    List<UnilateralSetAndRep> setAndRep,
    int i,
    CurrentExerciseDataProvider currentExerciseDataProvider,
  ) {
    setState(() {
      // Add additional set
      // Change the value of the additional set and reps to '1'
      // Left side
      setAndRep[i].additionalRepNumberLeft = '1';
      setAndRep[i].additionalWeightLeft = '0';
      leftAdditionalRepsControllers[i].text = '1';
      leftAdditionalWeightControllers[i].text = '0';

      // Update the provider
      currentExerciseDataProvider.setExerciseData(
        widget.exerciseId,
        setAndRep,
      );
    });
  }

  // Add additional set at index i (right side)
  addAdditionalSetRight(
    List<UnilateralSetAndRep> setAndRep,
    int i,
    CurrentExerciseDataProvider currentExerciseDataProvider,
  ) {
    setState(() {
      // Add additional set
      // Change the value of the additional set and reps to '1'
      // Left side
      setAndRep[i].additionalRepNumberRight = '1';
      setAndRep[i].additionalWeightRight = '0';
      rightAdditionalRepsControllers[i].text = '1';
      rightAdditionalWeightControllers[i].text = '0';

      // Update the provider
      currentExerciseDataProvider.setExerciseData(
        widget.exerciseId,
        setAndRep,
      );
    });
  }

  // Remove additional set at index i (left side)
  removeAdditionalSetLeft(
    List<UnilateralSetAndRep> setAndRep,
    int i,
    CurrentExerciseDataProvider currentExerciseDataProvider,
  ) {
    setState(() {
      // Remove additional set
      // Change the value of the additional set and reps to null
      setAndRep[i].additionalRepNumberLeft = '';
      setAndRep[i].additionalWeightLeft = '';
      leftAdditionalRepsControllers[i].text = '';
      leftAdditionalWeightControllers[i].text = '';
      // Update the provider
      currentExerciseDataProvider.setExerciseData(
        widget.exerciseId,
        setAndRep,
      );
    });
  }

  // Remove additional set at index i (right side)
  removeAdditionalSetRight(
    List<UnilateralSetAndRep> setAndRep,
    int i,
    CurrentExerciseDataProvider currentExerciseDataProvider,
  ) {
    setState(() {
      // Remove additional set
      // Change the value of the additional set and reps to null
      setAndRep[i].additionalRepNumberRight = '';
      setAndRep[i].additionalWeightRight = '';
      rightAdditionalRepsControllers[i].text = '';
      rightAdditionalWeightControllers[i].text = '';
      // Update the provider
      currentExerciseDataProvider.setExerciseData(
        widget.exerciseId,
        setAndRep,
      );
    });
  }

  // Update the index of the setsAndReps
  updateIndex(
    List<UnilateralSetAndRep> setAndRep,
    CurrentExerciseDataProvider currentExerciseDataProvider,
  ) {
    for (int i = 0; i < setAndRep.length; i++) {
      setState(() {
        setAndRep[i].setNumber = i + 1;
      });
    }
  }

  void onNoteSubmitted(
    String value,
    List<UnilateralSetAndRep> setAndRep,
    int i,
    CurrentExerciseDataProvider currentExerciseDataProvider,
  ) {
    FocusScope.of(context).unfocus();
    if (currentExerciseDataProvider
            .currentDataExercises[widget.exerciseId]!.setsAndReps[i].note ==
        value.trim()) {
      return;
    }

    noteControllers[i].text = value.trim();
    setAndRep[i].note = value.trim();

    currentExerciseDataProvider.setExerciseData(
      widget.exerciseId,
      setAndRep,
    );
  }

  checkDisplayAdditionalSetLeft(
    List<UnilateralSetAndRep> setAndRep,
    int i,
  ) {
    if (setAndRep[i].additionalRepNumberLeft.isEmpty ||
        setAndRep[i].additionalWeightLeft.isEmpty ||
        setAndRep[i].additionalRepNumberLeft == '0') {
      return true;
    }
    return false;
  }

  checkDisplayAdditionalSetRight(
    List<UnilateralSetAndRep> setAndRep,
    int i,
  ) {
    if (setAndRep[i].additionalRepNumberRight.isEmpty ||
        setAndRep[i].additionalWeightRight.isEmpty ||
        setAndRep[i].additionalRepNumberRight == '0') {
      return true;
    }
    return false;
  }
}
