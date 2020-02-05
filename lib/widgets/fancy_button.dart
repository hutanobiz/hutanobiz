import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/utils/visibility_flag.dart';

class FancyButton extends StatelessWidget {
  FancyButton(
      {this.buttonWidth,
      @required this.buttonHeight,
      @required this.title,
      this.buttonColor,
      @required this.onPressed,
      this.icon,
      this.elevation});

  final VoidCallback onPressed;
  final String title;
  final IconData icon;
  final double buttonHeight, buttonWidth;
  final Color buttonColor;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: elevation ?? 0.0,
      height: buttonHeight,
      minWidth: buttonWidth == 0.0 ? 0.0 : MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CustomVisibility(
            visibility:
                icon == null ? VisibilityFlag.gone : VisibilityFlag.visible,
            child: Row(
              children: <Widget>[
                Icon(
                  icon,
                  color: Colors.red,
                ),
                SizedBox(width: 8.0),
              ],
            ),
          ),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ],
      ),
      color: buttonColor == null ? Theme.of(context).primaryColor : buttonColor,
      splashColor: Colors.orange,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.buttonCornerRadius),
      ),
    );
  }
}
