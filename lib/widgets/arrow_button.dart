import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';

class ArrowButton extends StatelessWidget {
  ArrowButton({
    Key? key,
    required this.iconData,
    required this.onTap,
    this.buttonColor = AppColors.goldenTainoi,
    this.iconColor = Colors.black,
    this.buttonWidth = 55.0,
  }) : super(key: key);

  final IconData iconData;
  final Function? onTap;
  final double buttonWidth;
  final Color buttonColor, iconColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
      child: Material(
        color: buttonColor,
        child: InkWell(
          splashColor: AppColors.accentColor,
          onTap: onTap as void Function()?,
          child: Container(
            width: buttonWidth,
            height: 55.0,
            child: Icon(
              iconData,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
