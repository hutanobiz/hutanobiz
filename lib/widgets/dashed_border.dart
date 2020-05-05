import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class DashedBorder extends StatelessWidget {
  DashedBorder({Key key, @required this.onTap, @required this.child})
      : super(key: key);

  final Function onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey,
        onTap: onTap,
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(8),
          color: Colors.black26,
          dashPattern: [6, 6],
          strokeWidth: 0.5,
          child: child,
        ),
      ),
    );
  }
}
