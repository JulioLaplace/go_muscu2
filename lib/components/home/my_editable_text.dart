import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart';
import 'package:go_muscu2/providers/keyboard_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyEditableText extends StatefulWidget {
  TextEditingController controller;
  Function(String)? onChanged;
  // Function(PointerDownEvent)? onTapOutside;
  Function()? onEditingComplete;
  Function()? onTap;
  Function(String)? onSubmitted;
  TextInputType keyboardType;
  int? maxLines;
  int? minLines;
  bool filled;
  Color? fillColor;
  bool italic;
  String? hintText;
  bool isDense;
  bool center;
  Function(bool)? onFocusChange;
  EdgeInsetsGeometry? padding;
  MyEditableText({
    super.key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    // this.onTapOutside,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.maxLines,
    this.minLines,
    this.filled = false,
    this.fillColor,
    this.italic = false,
    this.hintText,
    this.isDense = false,
    this.center = false,
    this.padding,
    this.onFocusChange,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MyEditableTextState createState() => _MyEditableTextState();
}

class _MyEditableTextState extends State<MyEditableText> {
  // ----------------- Init State -----------------
  @override
  void initState() {
    super.initState();
  }

  // ----------------- Build -----------------
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focus) {
        KeyboardProvider keyboardProvider =
            Provider.of<KeyboardProvider>(context, listen: false);
        if (focus) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 200),
            curve: Curves.decelerate,
          );
          // Focus in
          keyboardProvider.setKeyboardVisibility(true);
          keyboardProvider.setDisplayExtraBox(true);
        }
        if (widget.onFocusChange != null) {
          widget.onFocusChange!(focus);
        }
      },
      child: Consumer<KeyboardProvider>(
        builder: (context, keyboardProvider, child) => TextField(
          key: widget.key,
          controller: widget.controller,
          enableSuggestions: true,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontStyle: widget.italic ? FontStyle.italic : FontStyle.normal,
              ),
          cursorColor: Theme.of(context).colorScheme.primary,
          cursorRadius: Radius.circular(radius),
          keyboardType: widget.keyboardType,
          onChanged: widget.onChanged,
          onTapOutside: (p0) {
            FocusScope.of(context).unfocus();
            // widget.onTapOutside!(p0);
          },
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
          onTap: () async {
            widget.onTap != null ? widget.onTap!() : () {};
          },
          textAlign: widget.center ? TextAlign.center : TextAlign.start,
          decoration: InputDecoration(
            isDense: widget.isDense,
            contentPadding:
                widget.padding ?? const EdgeInsets.symmetric(horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(radius),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(radius),
            ),
            filled: widget.filled,
            fillColor: widget.fillColor,
            labelText: widget.hintText,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          maxLines: widget.maxLines,
          minLines: widget.minLines,
        ),
      ),
    );
  }
}
