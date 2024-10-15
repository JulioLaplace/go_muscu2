import 'dart:ui';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BlurWidget extends StatefulWidget {
  const BlurWidget({
    super.key,
  });
  @override
  // ignore: library_private_types_in_public_api
  _BlurWidgetState createState() => _BlurWidgetState();
}

class _BlurWidgetState extends State<BlurWidget> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 100),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: const SizedBox(),
      ),
    );
  }
}
