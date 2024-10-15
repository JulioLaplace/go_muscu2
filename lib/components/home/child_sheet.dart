import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart';
import 'package:go_muscu2/providers/bottom_sheet_provider.dart';
import 'package:provider/provider.dart';

class ChildSheet extends StatefulWidget {
  const ChildSheet({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChildSheetState createState() => _ChildSheetState();
}

class _ChildSheetState extends State<ChildSheet> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomSheetProvider>(
      builder: (context, bottomSheetProvider, child) => Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(doubleRadius),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        child: bottomSheetProvider.currentBottomSheetItem,
      ),
    );
  }
}
