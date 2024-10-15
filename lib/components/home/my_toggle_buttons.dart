import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart';

// ignore: must_be_immutable
class MyToggleButtons extends StatefulWidget {
  Map<String, dynamic> children;
  List<bool> isSelected;
  bool multiSelect;
  Function? alertProvider;
  bool disabled;
  MyToggleButtons({
    super.key,
    required this.children,
    required this.isSelected,
    this.multiSelect = false,
    this.alertProvider,
    this.disabled = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MyToggleButtonsState createState() => _MyToggleButtonsState();
}

class _MyToggleButtonsState extends State<MyToggleButtons> {
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: widget.isSelected,
      onPressed: widget.disabled
          ? (index) {}
          : (index) {
              setState(() {
                if (widget.multiSelect) {
                  widget.isSelected[index] = !widget.isSelected[index];
                } else {
                  for (int buttonIndex = 0;
                      buttonIndex < widget.isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      widget.isSelected[buttonIndex] = true;
                    } else {
                      widget.isSelected[buttonIndex] = false;
                    }
                  }
                  widget.alertProvider!();
                }
              });
            },
      borderRadius: BorderRadius.circular(radius),
      borderColor:
          widget.disabled ? Colors.grey.shade500 : Colors.grey.shade700,
      selectedBorderColor: widget.disabled
          ? Theme.of(context).colorScheme.secondary.withOpacity(0.5)
          : Theme.of(context).colorScheme.secondary,
      color: widget.disabled
          ? Theme.of(context).colorScheme.secondary.withOpacity(0.5)
          : Theme.of(context).colorScheme.secondary,
      selectedColor: widget.disabled
          ? Theme.of(context).colorScheme.secondary.withOpacity(0.5)
          : Theme.of(context).colorScheme.secondary,
      fillColor: widget.disabled
          ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
          : Theme.of(context).colorScheme.primary,
      splashColor: widget.disabled ? Colors.transparent : null,
      children: widget.children.keys.map((key) => Text(key)).toList(),
    );
  }
}
