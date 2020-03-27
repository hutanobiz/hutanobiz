import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';

class ArrowButton extends StatelessWidget {
  ArrowButton(
      {Key key,
      @required this.iconData,
      @required this.onTap,
      this.buttonColor = AppColors.goldenTainoi})
      : super(key: key);

  final IconData iconData;
  final Function onTap;
  final Color buttonColor;

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
          onTap: onTap,
          child: Container(
            width: 55.0,
            height: 55.0,
            child: Icon(iconData),
          ),
        ),
      ),
    );
  }
}
