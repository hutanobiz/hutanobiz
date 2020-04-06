import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/utils/dimens.dart';
import 'package:hutano/utils/extensions.dart';
import 'package:hutano/utils/visibility_flag.dart';

class FancyButton extends StatelessWidget {
  FancyButton({
    this.buttonWidth,
    this.buttonHeight = 55.0,
    @required this.title,
    this.buttonColor,
    @required this.onPressed,
    this.icon,
    this.elevation = 0.0,
    this.svgIcon,
  });

  final VoidCallback onPressed;
  final String title, svgIcon;
  final IconData icon;
  final double buttonHeight, buttonWidth;
  final Color buttonColor;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: buttonHeight,
      minWidth: buttonWidth ?? MediaQuery.of(context).size.width,
      child: RaisedButton(
        elevation: elevation,
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
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.0),
                ],
              ),
            ),
            CustomVisibility(
              visibility: svgIcon == null
                  ? VisibilityFlag.gone
                  : VisibilityFlag.visible,
              child: Row(
                children: <Widget>[
                  "svgIcon".svgIcon(),
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
        color: buttonColor ?? AppColors.goldenTainoi,
        splashColor: Colors.orange,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.buttonCornerRadius),
        ),
      ),
    );
  }
}
