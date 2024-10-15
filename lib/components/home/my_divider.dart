import 'package:flutter/material.dart';

class MyDivider extends StatefulWidget {
  const MyDivider({Key? key}) : super(key: key);

  @override
  _MyDividerState createState() => _MyDividerState();
}

class _MyDividerState extends State<MyDivider> {
  @override
  Widget build(BuildContext context) {
    // my own divider
    return Container(
      width: 80,
      height: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        //     spreadRadius: 1,
        //     blurRadius: 3,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
