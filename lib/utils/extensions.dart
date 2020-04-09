import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Extensions {}

extension SvgIcon on String {
  svgIcon() => SvgPicture.asset("images/$this.svg");
}

extension ImageIcon on String {
  imageIcon({double height, double width}) => Image(
        image: AssetImage(
          "images/$this.png",
        ),
        height: height ?? 14.0,
        width: width ?? 14.0,
      );
}
