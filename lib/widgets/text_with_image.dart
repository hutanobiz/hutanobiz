import 'package:flutter/material.dart';
import 'package:hutano/colors.dart';
import 'package:hutano/utils/color_utils.dart';

class TextWithImage extends StatelessWidget {
  final String image;
  final String label;
  final TextStyle textStyle;
  final double size;
  final double imageSpacing; //space between image and text
  const TextWithImage(
      {this.image,
      this.label,
      this.textStyle,
      this.size = 14,
      this.imageSpacing});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: size,
          width: size,
        ),
        SizedBox(
          width: imageSpacing ?? 4,
        ),
        Expanded(
          child: Text(
            label,
            style:
                textStyle ?? const TextStyle(color: colorBlack70, fontSize: 12),
            textAlign: TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
