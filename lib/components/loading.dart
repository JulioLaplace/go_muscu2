import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// ignore: must_be_immutable
class Loading extends StatefulWidget {
  double size;
  Color color;
  Loading({super.key, this.size = 35, this.color = Colors.white});

  @override
  // ignore: library_private_types_in_public_api
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.inkDrop(
        color: widget.color, size: widget.size);
  }
}
