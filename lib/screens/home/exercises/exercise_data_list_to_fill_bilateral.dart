import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart';
import 'package:go_muscu2/components/home/my_editable_text.dart';
import 'package:go_muscu2/components/home/my_icon_button.dart';
import 'package:go_muscu2/components/home/white_box.dart';
import 'package:go_muscu2/models/setsAndReps/bilateral_set_and_rep.dart';
import 'package:go_muscu2/providers/current_workout/current_exercise_data_provider.dart';
import 'package:go_muscu2/providers/exercises/exercise_provider.dart';
import 'package:go_muscu2/providers/keyboard_provider.dart';
import 'package:go_muscu2/providers/number_manager_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ExerciseDataListToFillBilateral extends StatefulWidget {
  String exerciseId;
  String repNumberGoal;
  ScrollController? scrollController;
  ExerciseDataListToFillBilateral({
    super.key,
    required this.exerciseId,
    this.scrollController,
    required this.repNumberGoal,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ExerciseDataListToFillBilateralState createState() =>
      _ExerciseDataListToFillBilateralState();
}

class _ExerciseDataListToFillBilateralState
    extends State<ExerciseDataListToFillBilateral> {
  // ----------------- Variables -----------------

  // Text controllers
  List<TextEditingController> repsControllers = [];
  List<TextEditingController> weightControllers = [];
  List<TextEditingController> additionalRepsControllers = [];
  List<TextEditingController> additionalWeightControllers = [];
  List<TextEditingController> noteControllers = [];

  // ----------------- Init State -----------------
  @override
  void initState() {
    super.initState();
  }

  // ----------------- Dispose -----------------
  @override
  void dispose() {
    for (int i = 0; i < repsControllers.length; i++) {
      repsControllers[i].dispose();
      weightControllers[i].dispose();
      additionalRepsControllers[i].dispose();
      additionalWeightControllers[i].dispose();
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
    List<BilateralSetAndRep> setAndRep = currentExerciseDataProvider
        .currentDataExercises[widget.exerciseId]!.setsAndReps
        .cast<BilateralSetAndRep>();
    // Get the length of the setsAndReps
    int length = setAndRep.length;
    // Get the rep number goal
    String repNumberGoal = widget.repNumberGoal;

    for (int i = 0; i < length; i++) {
      // Add text controllers
      repsControllers.add(TextEditingController(text: setAndRep[i].repNumber));
      weightControllers.add(TextEditingController(text: setAndRep[i].weight));
      additionalRepsControllers
          .add(TextEditingController(text: setAndRep[i].additionalRepNumber));
      additionalWeightControllers
          .add(TextEditingController(text: setAndRep[i].additionalWeight));
      noteControllers.add(TextEditingController(text: setAndRep[i].note));

      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
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
                                if (repsControllers[i].text.isEmpty) {
                                  repsControllers[i].text =
                                      currentExerciseDataProvider
                                          .currentTextFieldValue;
                                  return;
                                }
                                if (repsControllers[i].text == '0') {
                                  removeLineData(setAndRep, i,
                                      currentExerciseDataProvider);
                                  return;
                                }
                                repsControllers[i].text = numberManagerProvider
                                    .validNumberFormat(repsControllers[i].text);

                                // update SetAndRep
                                setAndRep[i].repNumber =
                                    repsControllers[i].text.trim();

                                log('focus changed');
                                // Update the provider
                                currentExerciseDataProvider.setExerciseData(
                                  widget.exerciseId,
                                  setAndRep,
                                );
                              }
                            },
                            controller: repsControllers[i],
                            isDense: true,
                            center: true,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: false,
                            ),
                            onTap: () {
                              // Select all
                              repsControllers[i].selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: repsControllers[i].text.length);
                              // Save the current value
                              currentExerciseDataProvider
                                      .currentTextFieldValue =
                                  repsControllers[i].text;
                            },
                            onChanged: (p0) {
                              setState(() {
                                repsControllers[i].text =
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
                            controller: weightControllers[i],
                            isDense: true,
                            center: true,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                            onFocusChange: (p0) {
                              if (!p0) {
                                if (weightControllers[i].text.isEmpty) {
                                  weightControllers[i].text =
                                      currentExerciseDataProvider
                                          .currentTextFieldValue;
                                  return;
                                }
                                weightControllers[i].text =
                                    numberManagerProvider.validNumberFormat(
                                        weightControllers[i].text);

                                // update SetAndRep
                                setAndRep[i].weight =
                                    weightControllers[i].text.trim();
                                // Update the provider
                                currentExerciseDataProvider.setExerciseData(
                                  widget.exerciseId,
                                  setAndRep,
                                );
                              }
                            },
                            onTap: () {
                              // Select all
                              weightControllers[i].selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset:
                                      weightControllers[i].text.length);
                              // Save the current value
                              currentExerciseDataProvider
                                      .currentTextFieldValue =
                                  weightControllers[i].text;
                            },
                            onChanged: (p0) {
                              setState(() {
                                weightControllers[i].text =
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

              // Additional reps and weight
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Additional Reps text or Additional Reps and Weight text
                  checkDisplayAdditionalSet(setAndRep, i)
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
                                            additionalRepsControllers[i],
                                        isDense: true,
                                        center: true,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                          decimal: true,
                                          signed: false,
                                        ),
                                        onFocusChange: (p0) {
                                          if (!p0) {
                                            if (additionalRepsControllers[i]
                                                .text
                                                .isEmpty) {
                                              additionalRepsControllers[i]
                                                      .text =
                                                  currentExerciseDataProvider
                                                      .currentTextFieldValue;
                                              return;
                                            }
                                            if (additionalRepsControllers[i]
                                                    .text ==
                                                '0') {
                                              removeAdditionalSet(setAndRep, i,
                                                  currentExerciseDataProvider);
                                              return;
                                            }
                                            additionalRepsControllers[i].text =
                                                numberManagerProvider
                                                    .validNumberFormat(
                                                        additionalRepsControllers[
                                                                i]
                                                            .text);

                                            // update SetAndRep
                                            setAndRep[i].additionalRepNumber =
                                                additionalRepsControllers[i]
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
                                          additionalRepsControllers[i]
                                                  .selection =
                                              TextSelection(
                                                  baseOffset: 0,
                                                  extentOffset:
                                                      additionalRepsControllers[
                                                              i]
                                                          .text
                                                          .length);
                                          // Save the current value
                                          currentExerciseDataProvider
                                                  .currentTextFieldValue =
                                              additionalRepsControllers[i].text;
                                        },
                                        onChanged: (p0) {
                                          setState(() {
                                            additionalRepsControllers[i].text =
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
                                            additionalWeightControllers[i],
                                        isDense: true,
                                        center: true,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                          decimal: true,
                                          signed: true,
                                        ),
                                        onFocusChange: (p0) {
                                          if (!p0) {
                                            if (additionalWeightControllers[i]
                                                .text
                                                .isEmpty) {
                                              additionalWeightControllers[i]
                                                      .text =
                                                  currentExerciseDataProvider
                                                      .currentTextFieldValue;
                                              return;
                                            }
                                            additionalWeightControllers[i]
                                                    .text =
                                                numberManagerProvider
                                                    .validNumberFormat(
                                                        additionalWeightControllers[
                                                                i]
                                                            .text);

                                            // update SetAndRep
                                            setAndRep[i].additionalWeight =
                                                additionalWeightControllers[i]
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
                                          additionalWeightControllers[i]
                                                  .selection =
                                              TextSelection(
                                                  baseOffset: 0,
                                                  extentOffset:
                                                      additionalWeightControllers[
                                                              i]
                                                          .text
                                                          .length);
                                          // Save the current value
                                          currentExerciseDataProvider
                                                  .currentTextFieldValue =
                                              additionalWeightControllers[i]
                                                  .text;
                                        },
                                        onChanged: (p0) {
                                          setState(() {
                                            additionalWeightControllers[i]
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
                        checkDisplayAdditionalSet(setAndRep, i)
                            ? addAdditionalSet(
                                setAndRep,
                                i,
                                currentExerciseDataProvider,
                              )
                            : removeAdditionalSet(
                                setAndRep,
                                i,
                                currentExerciseDataProvider,
                              );
                      },
                      icon: checkDisplayAdditionalSet(setAndRep, i)
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
    List<BilateralSetAndRep> setAndRep,
    CurrentExerciseDataProvider currentExerciseDataProvider,
    String repNumberGoal,
  ) {
    setState(() {
      // Add a new set and rep
      setAndRep.add(
        currentExerciseDataProvider.getEmptySetAndRepBilateral(
          setAndRep.length + 1,
          repNumberGoal,
        ),
      );
      repsControllers.add(TextEditingController(text: repNumberGoal));
      weightControllers.add(TextEditingController(text: '0'));
      additionalRepsControllers.add(TextEditingController());
      additionalWeightControllers.add(TextEditingController());
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
    List<BilateralSetAndRep> setAndRep,
    int index,
    CurrentExerciseDataProvider currentExerciseDataProvider,
  ) {
    setState(() {
      repsControllers.removeAt(index);
      weightControllers.removeAt(index);
      additionalRepsControllers.removeAt(index);
      additionalWeightControllers.removeAt(index);
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

  // Add additional set at index i
  addAdditionalSet(
    List<BilateralSetAndRep> setAndRep,
    int i,
    CurrentExerciseDataProvider currentExerciseDataProvider,
  ) {
    setState(() {
      // Add additional set
      // Change the value of the additional set and reps to '1'
      setAndRep[i].additionalRepNumber = '1';
      setAndRep[i].additionalWeight = '0';
      additionalRepsControllers[i].text = '1';
      additionalWeightControllers[i].text = '0';
      // Update the provider
      currentExerciseDataProvider.setExerciseData(
        widget.exerciseId,
        setAndRep,
      );
    });
  }

  // Remove additional set at index i
  removeAdditionalSet(
    List<BilateralSetAndRep> setAndRep,
    int i,
    CurrentExerciseDataProvider currentExerciseDataProvider,
  ) {
    setState(() {
      // Remove additional set
      // Change the value of the additional set and reps to null
      setAndRep[i].additionalRepNumber = '';
      setAndRep[i].additionalWeight = '';
      additionalRepsControllers[i].text = '';
      additionalWeightControllers[i].text = '';
      // Update the provider
      currentExerciseDataProvider.setExerciseData(
        widget.exerciseId,
        setAndRep,
      );
    });
  }

  // Update the index of the setsAndReps
  updateIndex(
    List<BilateralSetAndRep> setAndRep,
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
    List<BilateralSetAndRep> setAndRep,
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

  checkDisplayAdditionalSet(
    List<BilateralSetAndRep> setAndRep,
    int i,
  ) {
    if (setAndRep[i].additionalRepNumber.isEmpty ||
        setAndRep[i].additionalWeight.isEmpty ||
        setAndRep[i].additionalRepNumber == '0') {
      return true;
    }
    return false;
  }
}
