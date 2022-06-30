import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';

class DashedBorder extends StatelessWidget {
  DashedBorder({Key? key, required this.onTap, required this.child})
      : super(key: key);

  final Function onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey,
        onTap: onTap as void Function()?,
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: Radius.circular(8),
          color: AppColors.goldenTainoi,
          dashPattern: [6, 6],
          strokeWidth: 0.5,
          child: child,
        ),
      ),
    );
  }
}
