import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_muscu2/components/constants.dart';

// ignore: must_be_immutable
class MySlidableWidget extends StatefulWidget {
  Widget child;
  void Function(BuildContext)? onPressedEdit;
  void Function(BuildContext)? onPressedDelete;
  bool addingWorkoutMode;
  MySlidableWidget({
    super.key,
    required this.child,
    this.onPressedEdit,
    this.onPressedDelete,
    this.addingWorkoutMode = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MySlidableWidgetState createState() => _MySlidableWidgetState();
}

class _MySlidableWidgetState extends State<MySlidableWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.addingWorkoutMode
        ? widget.child
        : Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.25,
              openThreshold: 0.2,
              children: [
                SlidableAction(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  icon: Icons.edit,
                  label: 'Edit',
                  borderRadius: BorderRadius.circular(doubleRadius),
                  onPressed: widget.onPressedEdit,
                )
              ],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.25,
              openThreshold: 0.2,
              children: [
                SlidableAction(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                  borderRadius: BorderRadius.circular(doubleRadius),
                  onPressed: widget.onPressedDelete,
                )
              ],
            ),
            child: widget.child,
          );
  }
}
