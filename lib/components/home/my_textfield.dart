import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Color filledColor;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final bool selectAll;
  final bool unFocus;
  const MyTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.filledColor = Colors.transparent,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.selectAll = false,
    this.unFocus = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autocorrect: true,
      cursorColor: Colors.black,
      enableSuggestions: true,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      style: Theme.of(context).textTheme.bodyMedium,
      cursorErrorColor: Theme.of(context).colorScheme.error,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade700),
          borderRadius: BorderRadius.circular(radius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade700),
          borderRadius: BorderRadius.circular(radius),
        ),
        labelText: hintText,
        labelStyle: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.grey.shade800),
        fillColor: filledColor,
        filled: true,
      ),
      obscureText: obscureText,
      onTapOutside:
          unFocus ? (event) => FocusScope.of(context).unfocus() : null,
      onChanged: onChanged,
      onTap: () => selectAll
          ? controller.selection =
              TextSelection(baseOffset: 0, extentOffset: controller.text.length)
          : null,
    );
  }
}
