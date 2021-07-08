import 'package:flutter/material.dart';
import 'package:hutano/utils/color_utils.dart';


class HutanoRoundButton extends StatelessWidget {
  final String iconText;
  final Color bgColor;
  final bool isIcon;
  final String icon;
  final double iconSize;
  final Color borderColor;

  const HutanoRoundButton(
      {Key key,
      this.bgColor = accentColor,
      this.iconText,
      this.isIcon=false,
      this.iconSize,
      this.icon, this.borderColor=colorBlack45})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildIconButton();
  }

  Widget _buildIconButton() {
    return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              width: 1.0, color: borderColor!=null ?borderColor: colorBorder2.withOpacity(0.1),
              style: BorderStyle.solid),
          color: bgColor!=null ?bgColor : accentColor ,
        ),
        child: isIcon ? Image.asset(icon, width: iconSize, height: iconSize) :Container(
          padding: const EdgeInsets.all(9.0),
          child: Text(iconText,
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ));
  }
}
