import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyIconButton extends StatefulWidget {
  // Container properties
  BorderRadiusGeometry? borderRadius;
  Color? containerColor;
  Color? containerColorOnTap;
  double? width;
  double? height;
  EdgeInsetsGeometry? containerMargin;
  EdgeInsetsGeometry? containerPadding;
  AlignmentGeometry? containerAlignment;

  // Icon properties
  IconData icon;
  double size;
  Color? iconColor;

  void Function()? onPressed;

  MyIconButton({
    super.key,
    this.borderRadius,
    this.containerColor,
    this.containerColorOnTap,
    this.width,
    this.height,
    this.containerMargin,
    this.containerPadding,
    this.containerAlignment,
    required this.icon,
    this.size = 20,
    required this.onPressed,
    this.iconColor,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MyIconButtonState createState() => _MyIconButtonState();
}

class _MyIconButtonState extends State<MyIconButton> {
  Color? backgroundColor;

  @override
  void initState() {
    super.initState();
    backgroundColor = widget.containerColor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Change background color on tap
      onTapDown: (_) {
        setState(() {
          backgroundColor = widget.containerColorOnTap;
        });
      },
      onTapUp: (_) {
        setState(() {
          backgroundColor = widget.containerColor;
        });
      },
      onTapCancel: () {
        setState(() {
          backgroundColor = widget.containerColor;
        });
      },
      onTap: widget.onPressed,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            color: backgroundColor,
          ),
          width: widget.width,
          height: widget.height,
          margin: widget.containerMargin,
          padding: widget.containerPadding,
          alignment: widget.containerAlignment,
          child: Center(
            child: Icon(
              widget.icon,
              size: widget.size,
              color: widget.iconColor,
            ),
          )),
    );
  }
}
