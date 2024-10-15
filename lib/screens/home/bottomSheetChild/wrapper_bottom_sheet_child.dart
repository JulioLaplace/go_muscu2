import 'package:flutter/material.dart';
import 'package:go_muscu2/providers/bottom_sheet_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class WrapperBottomSheetChild extends StatefulWidget {
  String? title;
  Widget child;
  WrapperBottomSheetChild({
    super.key,
    this.title,
    required this.child,
  });

  @override
  // ignore: library_private_types_in_public_api
  _WrapperBottomSheetChildState createState() =>
      _WrapperBottomSheetChildState();
}

class _WrapperBottomSheetChildState extends State<WrapperBottomSheetChild> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              // back button
              Consumer<BottomSheetProvider>(
                  builder: (context, bottomSheetProvider, child) => IconButton(
                      onPressed: () {
                        bottomSheetProvider.setBottomSheetWidget(
                            bottomSheetProvider.previousBottomSheetItem.last);
                        bottomSheetProvider.removePreviousBottomSheetWidget();
                      },
                      icon: const Icon(Icons.arrow_back))),
              // title
              widget.title == null
                  ? const SizedBox.shrink()
                  : Expanded(
                      child: Text(widget.title!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge)),
            ],
          ),
        ),
        Expanded(
          child: widget.child,
        )
      ],
    );
  }
}
