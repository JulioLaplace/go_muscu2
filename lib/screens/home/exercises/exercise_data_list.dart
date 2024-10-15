import 'package:flutter/material.dart';
import 'package:go_muscu2/components/home/white_box.dart';
import 'package:go_muscu2/models/exercise_data.dart';
import 'package:go_muscu2/models/setsAndReps/bilateral_set_and_rep.dart';
import 'package:go_muscu2/models/setsAndReps/unilateral_set_and_rep.dart';

// ignore: must_be_immutable
class ExerciseDataList extends StatefulWidget {
  ExerciseData exerciseData;
  bool isUnilateral;

  ExerciseDataList({
    super.key,
    required this.exerciseData,
    required this.isUnilateral,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ExerciseDataListState createState() => _ExerciseDataListState();
}

class _ExerciseDataListState extends State<ExerciseDataList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: getDataList(widget.exerciseData),
    );
  }

  List<Widget> getDataList(ExerciseData data) {
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
    widget.isUnilateral
        ? getDataListUnilateral(data, rows)
        : getDataListBilateral(data, rows);

    return rows;
  }

  List<Widget> getDataListBilateral(ExerciseData data, List<Widget> rows) {
    int length = data.setsAndReps.length;

    // Cast SetAndRep to BilateralSetAndRep
    List<BilateralSetAndRep> bilateralSetAndRep =
        data.setsAndReps.cast<BilateralSetAndRep>();

    for (int i = 0; i < length; i++) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Set number
              Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Text(
                    data.setsAndReps[i].setNumber.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),

              // Rep number
              Expanded(
                flex: 2,
                child: WhiteBox(
                  border: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Center(
                    child: Text(
                      bilateralSetAndRep[i].repNumber.toString(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Center(
                    child: Text(
                      bilateralSetAndRep[i].weight.toString(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      // Additional rep number and weight
      bilateralSetAndRep[i].additionalRepNumber.isNotEmpty &&
              bilateralSetAndRep[i].additionalWeight.isNotEmpty
          ? rows.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Plus symbol
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.add,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 20,
                            ),
                          ],
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
                          child: Text(
                            bilateralSetAndRep[i]
                                .additionalRepNumber
                                .toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
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
                          child: Text(
                            bilateralSetAndRep[i].additionalWeight.toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink();

      // Note text
      bilateralSetAndRep[i].note.isNotEmpty
          ? rows.add(
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Note ',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  // Note text
                  Expanded(
                    flex: 5,
                    child: Text(
                      bilateralSetAndRep[i].note.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink();

      rows.add(
        const SizedBox(height: 20),
      );
    }

    return rows;
  }

  // Unilateral data
  List<Widget> getDataListUnilateral(ExerciseData data, List<Widget> rows) {
    int length = data.setsAndReps.length;

    // Cast SetAndRep to UnilateralSetAndRep
    List<UnilateralSetAndRep> unilateralSetAndRep =
        data.setsAndReps.cast<UnilateralSetAndRep>();

    for (int i = 0; i < length; i++) {
      // Left side
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Set number
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Text(
                    data.setsAndReps[i].setNumber.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),

              // Rep number
              Expanded(
                flex: 4,
                child: WhiteBox(
                  border: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Center(
                    child: Text(
                      unilateralSetAndRep[i].repNumberLeft.toString(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
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
                flex: 6,
                child: WhiteBox(
                  border: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Center(
                    child: Text(
                      unilateralSetAndRep[i].weightLeft.toString(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),

              // "L" for left side text
              Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'L',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      // Additional rep number and weight
      unilateralSetAndRep[i].additionalRepNumberLeft.isNotEmpty &&
              unilateralSetAndRep[i].additionalWeightLeft.isNotEmpty
          ? rows.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Plus symbol
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.add,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Rep number
                    Expanded(
                      flex: 4,
                      child: WhiteBox(
                        border: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Center(
                          child: Text(
                            unilateralSetAndRep[i]
                                .additionalRepNumberLeft
                                .toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
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
                      flex: 6,
                      child: WhiteBox(
                        border: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Center(
                          child: Text(
                            unilateralSetAndRep[i]
                                .additionalWeightLeft
                                .toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),

                    // Empty space
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink();

      // Right side
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Set number
              Expanded(
                flex: 2,
                child: Container(),
              ),

              // Rep number
              Expanded(
                flex: 4,
                child: WhiteBox(
                  border: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Center(
                    child: Text(
                      unilateralSetAndRep[i].repNumberRight.toString(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
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
                flex: 6,
                child: WhiteBox(
                  border: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Center(
                    child: Text(
                      unilateralSetAndRep[i].weightRight.toString(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),

              // "R" for right side text
              Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'R',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      // Additional rep number and weight
      unilateralSetAndRep[i].additionalRepNumberRight.isNotEmpty &&
              unilateralSetAndRep[i].additionalWeightRight.isNotEmpty
          ? rows.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Plus symbol
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.add,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Rep number
                    Expanded(
                      flex: 4,
                      child: WhiteBox(
                        border: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Center(
                          child: Text(
                            unilateralSetAndRep[i]
                                .additionalRepNumberRight
                                .toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
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
                      flex: 6,
                      child: WhiteBox(
                        border: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Center(
                          child: Text(
                            unilateralSetAndRep[i]
                                .additionalWeightRight
                                .toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),

                    // Empty space
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink();

      // Note text
      unilateralSetAndRep[i].note.isNotEmpty
          ? rows.add(
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Note ',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  // Note text
                  Expanded(
                    flex: 5,
                    child: Text(
                      unilateralSetAndRep[i].note.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink();

      rows.add(
        const SizedBox(height: 30),
      );
    }
    return rows;
  }
}
