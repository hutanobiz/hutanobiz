import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/text_style.dart';

enum HutanoButtonType {
  onlyLabel, //only label
  withIcon, // icon in left side
  withPrefixIcon, //prefix icon with label
  onlyIcon //no label
}

class HutanoButton extends StatelessWidget {
  final String label;
  final double width;
  final double height;
  final String icon;
  final double iconSize;
  final double buttonRadius;
  final Function onPressed;
  final bool isIconButton;
  final HutanoButtonType buttonType;
  final Color color;
  final Color labelColor;
  final Color _disableColor = AppColors.colorGrey;
  final double margin;
  final Color borderColor;
  final double borderWidth;
  final double fontSize;
  final ShapeBorder buttonShape;
  final double iconPosition;

  const HutanoButton({
    Key key,
    this.label,
    @required this.onPressed,
    this.icon,
    this.width,
    this.buttonRadius = 14,
    this.height = 55,
    this.iconSize = 25,
    this.margin = 0,
    this.isIconButton = false,
    this.color = AppColors.accentColor,
    this.labelColor = AppColors.colorWhite,
    this.buttonType = HutanoButtonType.onlyLabel,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.fontSize = 16,
    this.buttonShape,
    this.iconPosition = 30,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buttonType == HutanoButtonType.onlyIcon
        ? _buildIconButton()
        : _buildBaseButton();
  }

  Widget _buildIconButton() {
    return Container(
      height: height,
      width: 60,
      child: FlatButton(
        disabledColor: _disableColor,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        child: _buildIcon(),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildIcon() {
    return Image.asset(
      icon,
      width: iconSize,
      height: iconSize,
    );
  }

  Widget _buildBaseButton() {
    return Container(
      margin: EdgeInsets.all(margin),
      height: height,
      width: width,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          FlatButton(
            color: color,
            disabledColor: _disableColor,
            onPressed: onPressed,
            shape: buttonShape ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(buttonRadius),
                  side: BorderSide(
                      color: borderColor,
                      width: borderWidth,
                      style: borderWidth == 0
                          ? BorderStyle.none
                          : BorderStyle.solid),
                ),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (buttonType == HutanoButtonType.withPrefixIcon)
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: _buildIcon(),
                      ),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.mediumStyle(
                        fontSize: fontSize,
                        color: labelColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (buttonType == HutanoButtonType.withIcon)
            Positioned(
              left: iconPosition,
              top: 0,
              bottom: 0,
              child: _buildIcon(),
            )
        ],
      ),
    );
  }
}
