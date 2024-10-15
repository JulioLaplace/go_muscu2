import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;
  const SquareTile({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade500),
          borderRadius: BorderRadius.circular(doubleRadius),
        ),
        child: Image.asset(
          imagePath,
          height: 60,
        ),
      ),
    );
  }
}
