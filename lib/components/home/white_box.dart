import 'package:flutter/material.dart';
import 'package:go_muscu2/components/constants.dart';
import 'package:go_muscu2/components/datetime_converter.dart'
    as datetime_converter;

// ignore: must_be_immutable
class WhiteBox extends StatefulWidget {
  Widget child;
  Text? title;
  bool displayBackground;
  bool displayPadding;
  double? width;
  double? height;
  EdgeInsetsGeometry? padding;
  DateTime? date;
  bool paddingLeftTitle;
  bool border;
  WhiteBox({
    super.key,
    required this.child,
    this.title,
    this.displayBackground = true,
    this.displayPadding = true,
    this.width,
    this.height,
    this.padding,
    this.date,
    this.paddingLeftTitle = true,
    this.border = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _WhiteBoxState createState() => _WhiteBoxState();
}

class _WhiteBoxState extends State<WhiteBox> {
  Widget whiteBox(Widget child) {
    return Container(
      width: double.maxFinite,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.displayBackground ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        border: widget.border
            ? Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1,
              )
            : null,
      ),
      child: widget.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.title == null
        ? whiteBox(widget.child)
        : widget.date == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          left: widget.paddingLeftTitle ? 10 : 0),
                      child: widget.title!),
                  const SizedBox(height: 10),
                  whiteBox(widget.child),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          left: widget.paddingLeftTitle ? 10 : 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.title!,
                          Text(
                            datetime_converter.convertDatetimeToString(
                              widget.date!,
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      )),
                  const SizedBox(height: 10),
                  whiteBox(widget.child),
                ],
              );
  }
}
