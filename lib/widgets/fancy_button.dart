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
    this.buttonIcon,
  });

  final VoidCallback onPressed;
  final String title, buttonIcon;
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
              visibility: buttonIcon == null
                  ? VisibilityFlag.gone
                  : VisibilityFlag.visible,
              child: Row(
                children: <Widget>[
                  "$buttonIcon".imageIcon(height: 20, width: 20),
                  SizedBox(width: 8.0),
                ],
              ),
            ),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          ],
        ),
        disabledColor: Colors.grey[350],
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
