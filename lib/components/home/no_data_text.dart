import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoDataText extends StatelessWidget {
  String title;
  NoDataText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: TextAlign.center,
    );
  }
}
