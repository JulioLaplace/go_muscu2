import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart';

// ignore: must_be_immutable
class AddButton extends StatefulWidget {
  void Function()? onTap;
  AddButton({super.key, this.onTap});

  @override
  // ignore: library_private_types_in_public_api
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: 30,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
